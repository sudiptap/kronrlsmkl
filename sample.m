clear
dataname = 'nr';
% dataname = 'gpcr';
% dataname = 'ic';
% dataname = 'e';


%% load adjacency matrix
[y,l1,l2] = loadtabfile(['data/interactions/' dataname '_admat_dgc.txt']);

%remove random entries
crossval_idx = crossvalind('Kfold', length(y(:)), 5);
aupr_m = [];

%% load kernels
k1_paths = {['data/kernels/' dataname '_simmat_proteins_sw-n.txt'],...
            ['data/kernels/' dataname '_simmat_proteins_go.txt'],...
            ['data/kernels/' dataname '_simmat_proteins_mismatch-n-k3m1.txt'],...
            ['data/kernels/' dataname '_simmat_proteins_mismatch-n-k3m2.txt'],...
            ['data/kernels/' dataname '_simmat_proteins_mismatch-n-k4m1.txt'],...
            ['data/kernels/' dataname '_simmat_proteins_mismatch-n-k4m2.txt'],...
            ['data/kernels/' dataname '_simmat_proteins_spectrum-n-k3.txt'],...
            ['data/kernels/' dataname '_simmat_proteins_spectrum-n-k4.txt'],...
            ['data/kernels/' dataname '_simmat_proteins_ppi.txt'],...
            };
K1 = [];
for i=1:length(k1_paths)
    [mat, labels] = loadtabfile(k1_paths{i});
    K1(:,:,i) = mat;
end
K1(:,:,i+1) = kernel_gip(y,1, 1);

k2_paths = {['data/kernels/' dataname '_simmat_drugs_simcomp.txt'],...
            ['data/kernels/' dataname '_simmat_drugs_lambda.txt'],...
            ['data/kernels/' dataname '_simmat_drugs_marginalized.txt'],...
            ['data/kernels/' dataname '_simmat_drugs_minmaxTanimoto.txt'],...
            ['data/kernels/' dataname '_simmat_drugs_spectrum.txt'],...
            ['data/kernels/' dataname '_simmat_drugs_tanimoto.txt'],...
            ['data/kernels/' dataname '_simmat_drugs_aers-bit.txt'],...
            ['data/kernels/' dataname '_simmat_drugs_aers-freq.txt'],...
            ['data/kernels/' dataname '_simmat_drugs_sider.txt'],...
            };
K2 = [];
for i=1:length(k2_paths)
    [mat, labels] = loadtabfile(k2_paths{i});
    K2(:,:,i) = mat;
end
K2(:,:,i+1) = kernel_gip(y,2, 1);

%% perform predictions
lambda = 1;
regcoef = 0.25;
[ y2, alpha, beta ] = kronrls_mkl( K1, K2, y, lambda, regcoef );

alpha
beta