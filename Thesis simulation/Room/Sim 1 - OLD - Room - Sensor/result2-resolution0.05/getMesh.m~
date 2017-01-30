function [p,e,t]  = getMesh(heatX,heatY,heatdx,heatdy,...
                            winX ,winY ,windx ,windy ,...
                            senX ,senY ,sendx ,sendy ,...
                            roomCornersCoord,wantRefinedMesh)
                        
room   = [2,6,roomCornersCoord]'                                                                                       ;
sensor = [3,4,senX-sendx,senX-sendx,senX+sendx,senX+sendx,senY-sendy,senY+sendy,senY+sendy,senY-sendy]'                ;
window = [3,4,winX-windx,winX-windx,winX+windx,winX+windx,winY-windy,winY+windy,winY+windy,winY-windy]'                ;
heater = [3,4,heatX-heatdx,heatX-heatdx,heatX+heatdx,heatX+heatdx,heatY-heatdy,heatY+heatdy,heatY+heatdy,heatY-heatdy]';

% Pad with zeros to enable concatenation, room is the longest
heater    = [heater;zeros(length(room)-length(heater),1)];
window    = [window;zeros(length(room)-length(window),1)];
sensor    = [sensor;zeros(length(room)-length(sensor),1)];
objects   = [heater,room,window,sensor]                  ;

% Creating one mesh, labeling each object
ns                    = (char('heater','room','window','sensor'))';
sf                    = 'heater+room+window+sensor'               ; % set formula
[geom,bt,dl1,bt1,msb] = decsg(objects,sf,ns)                      ; % packing the geometric info
[p,e,t]               = initmesh(geom)                            ; % makes the mesh;
if wantRefinedMesh == 1
    [p,e,t]           = refinemesh(geom,p,e,t,[1,3])              ; % refine mesh at heater and window if requested.
end
end
        
