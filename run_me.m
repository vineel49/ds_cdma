% 4 user CDMA system (BPSK modulation)

clear all
close all
clc
N = 4; % number of users in the CDMA system ( donot change this number)
level = ceil(log2(N)); % leven in OVSF code generation
codes = Gen_OVSF(level); % generate orthogonal variable spread factor codes

num_bit = 10^4; % data size
SNR_dB =10 ; % SNR per bit in dB 
tic()
% Source
a1 = randi([0 1],1,num_bit);% source for user1
a2 = randi([0 1],1,num_bit); % source for user2 
a3 = randi([0 1],1,num_bit);% source for user3
a4 = randi([0 1],1,num_bit); % source for user4

% BPSK mapper (bit 0 maps to 1)
bpsk_seq1 = 1-2*a1;
bpsk_seq2 = 1-2*a2;
bpsk_seq3 = 1-2*a3;
bpsk_seq4 = 1-2*a4;

% Spreading operation
user1_bpsk_seq_rep = repmat(bpsk_seq1,2^level,1);
user2_bpsk_seq_rep = repmat(bpsk_seq2,2^level,1);
user3_bpsk_seq_rep = repmat(bpsk_seq3,2^level,1);
user4_bpsk_seq_rep = repmat(bpsk_seq4,2^level,1);

user1_code_rep = repmat(codes(1,:).',1,num_bit);
user2_code_rep = repmat(codes(2,:).',1,num_bit);
user3_code_rep = repmat(codes(3,:).',1,num_bit);
user4_code_rep = repmat(codes(4,:).',1,num_bit);

user1_trans_sig = user1_bpsk_seq_rep .* user1_code_rep;
user2_trans_sig = user2_bpsk_seq_rep .* user2_code_rep;
user3_trans_sig = user3_bpsk_seq_rep .* user3_code_rep;
user4_trans_sig = user4_bpsk_seq_rep .* user4_code_rep;

% summing operation
trans_sig = user1_trans_sig + user2_trans_sig + user3_trans_sig + user4_trans_sig;

% AWGN 
SNR = 10^(0.1*SNR_dB); % SNR in linear scale
noise_var = (2^level)/(2*SNR); % awgn variance
noise = normrnd(0,sqrt(noise_var),2^level,num_bit);

% channel output
Chan_Op = trans_sig + noise;

% RECIEVER for user 1
% Despreading operation
user1_rec_sig = (1/N)*sum(Chan_Op.*user1_code_rep,1);

% ML decoding
dec_a1 = user1_rec_sig<0;

% Bit error rate
BER = nnz(a1-dec_a1)/num_bit
toc()







