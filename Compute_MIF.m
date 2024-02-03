function [ MicroF1] = Compute_MIF(actual,pred)
pred_label=pred;
orig_label=actual;

[ micro, ~ ] = micro_macro_PR( pred_label , orig_label);
MicroF1 = micro.fscore;
end