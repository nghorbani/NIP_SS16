function [A,i] = make_PD(A)
% gets a matrix and turns it into positive definit
for i=1:1000
    try
        chol(A,'lower');
        fprintf('positive def at %d iters\n',i);
        break;
    catch
        A = A+eps*eye(size(A));%for numerical stability
        continue
    end
end
end