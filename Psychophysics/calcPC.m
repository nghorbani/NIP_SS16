function pc = calcPC(pH, pFA)
ps = 0.5;
pc = pH*ps + (1-pFA)*(1-ps);
end