classdef GenericFeatureExtractor < handle
    %GenericFeatureExtractor Generic interface for extracting image features
    
    properties
    end
    
    properties(Constant,Hidden)
        out_dim = 128;
    end
    
    methods(Abstract)
        [feats, frames] = compute(obj, im)
    end
    
    methods (Static)
        function image = readImage(imagePath)
            % Reads an image at the given file path.
            [~, ~, ext] = fileparts(imagePath);
            
            switch lower(ext)
                case 'gif'
                    % frames=1: take only the first frame if it's
                    % an animated GIF
                    [image, map] = imread(imagePath, 'frames', 1);
                    % Do the conversion to an RGB image
                    image = ind2rgb(image, map);
                otherwise
                    image = imread(imagePath);
            end % switch
        end % readImage
        
        function image = standardizeImage(image)
			%standardizeImage Wrapper to render an image compatible with vlfeat
			%library.
			%
			%   NOTE: all PASCAL VOC images are RGB and already size-normalized, so the
			%   output of this function for them is always equivalent to:
			%   single(rgb2gray(im))

			if ndims(image) == 3
				image = im2single(image);
			elseif ndims(image) == 2
				newImage = cat(3,image,image);
				newImage = cat(3,newImage,image);
				image = newImage;
				image = im2single(image);
				clear newImage;
			else
				error('Input image not valid');
			end

			if size(image,1) > 480, image = imresize(image, [480 NaN]) ; end
		end
	end
end

