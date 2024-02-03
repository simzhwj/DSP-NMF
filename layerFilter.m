function lay = layerFilter(layers, max_len, min_len)

lay = layers;
lay(lay >= max_len) = [];
lay(lay < min_len) = [];
lay = [lay min_len];%[max_len lay min_len];