% Author: Seydanur Tikir (seydanurtikir@gmail.com)

%findChanNum(ch)

function ch = findChanNum(chan)

chanNames={'FF','F-L','F','F-R',  'T-L','C-L', 'C', 'C-R','T-R',   'P','P-L','P-R','O' };
chanNames2={'fpz','D23','fz','CN17',   't7','c3','cz','c4','t8',  'pz','E30','B12','oz' };
chanInds    =  [104 119 100 81       137 132 1 71 64           19 158  44   23 ];

ch=chanInds(find(chanNames==chan));

end
