function [ MacroF] = Compute_MAF(actual,pred)
% pred_label=pred;
% orig_label=actual;
% 
% [ ~, macro ] = micro_macro_PR( pred_label , orig_label);
% MacroF1 = macro.fscore;
[ MacroF] = MacroF1(actual,pred);
end