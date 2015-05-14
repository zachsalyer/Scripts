function dataType= datatypeformat(signalDataType,numberOfBits)
% DATATYPEFORMAT Data type format precision to give to fread
%   DATATYPEFORMAT(SIGNALDATATYPE,NUMBEROFBITS) is the precision string to
%   give to fread for reading the data type specified by SIGNALDATATYPE and
%   NUMBEROFBITS
% Copyright 2006-2014 The MathWorks, Inc.

  switch signalDataType
    
    case {0, 9, 13} % unsigned
      switch numberOfBits
        case 8
          dataType='uint8';
        case 16
          dataType='uint16';
        case 32
          dataType='uint32';
        case 64
          dataType='uint64';
        case 1
          dataType='ubit1';
        case 2
          dataType='ubit2';
        otherwise
          error('Unsupported number of bits for unsigned int');
      end
      
    case {1, 10, 14} % signed int
      switch numberOfBits
        case 8
          dataType='int8';
        case 16
          dataType='int16';
        case 32
          dataType='int32';
        otherwise
          error('Unsupported number of bits for signed int');
      end
      
    case {2, 3, 11, 12,15, 16} % floating point
      switch numberOfBits
        case 32
          dataType='single';
        case 64
          dataType='double';
        otherwise
          error('Unsupported number of bit for floating point');
      end
      
    case 7 % string
      dataType='uint8';
      
    otherwise
      error('Unsupported Signal Data Type');
  end
end