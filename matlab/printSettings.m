clc
for i = 1:size(tb,1) 
    fprintf('rec %d:\n\n',i); 
    for j = 1:4
        fprintf('chan %s: lpf1 %s lpf2 %s Fs = %d\n',...
            tb.tdData{i}(j).chanOut,...
            tb.tdData{i}(j).lpf1,...
            tb.tdData{i}(j).lpf2,...
            tb.tdData{i}(j).sampleRate);
    end
end