%% I HAVE CREATED A ROBOT CAPABLE OF PICKING ITEMS USING NEEDLE IN HIS FRONT

clear all
close all
clf
handle_axes= axes('XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [0,0.4]);

xlabel('e_1'); 
ylabel('e_2');
zlabel('e_3');

view(-130, 26);
grid on;
axis equal
camlight
axis_length= 0.05;




%% Root frame E
trf_E_axes= hgtransform('Parent', handle_axes); 
% The root-link transform should be created as a child of the axes from the
% beginning to avoid the error "Cannot set property to a deleted object".
% E is synonymous with the axes, so there is no need for plot_axes(trf_E_axes, 'E');




%% Link-0: Base-link

trf_link0_E= make_transform([0, 0, 0], 0, 0, pi/2, trf_E_axes);
plot_axes(trf_link0_E, 'L_0', false, axis_length); 

trf_viz_link0= make_transform([0, 0, 0.1], 0, 0, 0, trf_link0_E);
length0= 0.3; radius0= 0.05;
h(1)= link_cylinder(radius0, length0, trf_viz_link0, [0.823529 0.411765 0.117647]); 
plot_axes(trf_viz_link0, ' ', true, axis_length); % V_0




%% Link-1
trf_viz_link1= make_transform([0, 0, 0], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
length1= 0.05; radius1= 0.04;
h(2)= link_cylinder(radius1, length1, trf_viz_link1, [0, 0, 1]); 
% V_1 and L_1 are the same.




%% Link-2
trf_viz_link2= make_transform([0.1, 0, 0], 0, pi/2, 0); % Do not specify parent yet: It will be done in the joint
length1= 0.2; radius1= 0.01;
h(3)= link_cylinder(radius1, length1, trf_viz_link2, [0, 0, 1]); 




%% Link-3
trf_viz_link3= make_transform([0,0,0], 0, pi/2, 0); % Do not specify parent yet: It will be done in the joint
length1= 0.04; radius1= 0.013;
h(4)= link_cylinder(radius1, length1, trf_viz_link3, [0, 1, 0]); 
% V_1 and L_1 are the same.


%%link-4
trf_viz_link4= make_transform([0.1, 0, -0,1], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
h(3)= link_box([0.02, 0.02, 0.2], trf_viz_link4, [0, 1, 0]); 
plot_axes(trf_viz_link4, ' ', true, axis_length); % V_{1-2}


%% Link-5
trf_viz_link5= make_transform([0, 0.1, 0], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
h(9)= link_cylinder(0.004, 0.15, trf_viz_link5, [0.482353 0.407843 0.933333]); 
% plot_axes(trf_viz_link4, ' ', true, axis_length); % V_{4}



%% Link-End-Effector
trf_viz_linkEE= make_transform([0, 0, 0.001], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
h(10)= link_sphere(0.005, trf_viz_linkEE, [1, 0, 0]); 
% plot_axes(trf_viz_linkEE, ' ', true, axis_length); % V_{EE}





%% Now define all the joints

%% Joint 1: Links 0,1: Revolute
j1_rot_axis_j1= [0,0,1]';
j1_rot_angle= 0; % [-pi/2, pi/2]

trf_joint1_link0= make_transform([0, 0, 0.275], 0, 0, 0, trf_link0_E); 
trf_link1_joint1= make_transform_revolute(j1_rot_axis_j1, j1_rot_angle, trf_joint1_link0); 
plot_axes(trf_link1_joint1, 'L_1', false, axis_length); 
make_child(trf_link1_joint1, trf_viz_link1);




%% Joint: Links 1,2: Fixed
trf_link2_link1= make_transform([0, 0, 0], 0, 0, 0, trf_link1_joint1); 
make_child(trf_link2_link1, trf_viz_link2);




%% Joint 3: Links 2,3: Prismatic
j3_translation_axis_j3= [1,0,0]';
j3_translation= 0; % [-0.04, 0.04]

trf_joint3_link2= make_transform([0.1, 0, 0], pi/2, 0, 0, trf_link2_link1); 
trf_link3_joint3= make_transform_prismatic(j3_translation_axis_j3, j3_translation, trf_joint3_link2);
plot_axes(trf_link3_joint3, 'L_3', false, axis_length); 
make_child(trf_link3_joint3, trf_viz_link3);






%% Joint: Links ,4: Fixed
trf_link4_link3= make_transform([-0.1, -0.1 , 0 ], pi/2, 0, 0, trf_link3_joint3); 
make_child(trf_link4_link3, trf_viz_link4);



%% Joint 2: Links 4,5: Prismatic
j5_translation_axis_j5= [0,0,1]';
j5_translation= 0; % [-0.04, 0.04]

trf_joint5_link4= make_transform([0.2, 0, 0.05], 0, 0, pi/2, trf_link4_link3); 
trf_link5_joint5= make_transform_prismatic(j5_translation_axis_j5, j5_translation, trf_joint5_link4);
plot_axes(trf_link5_joint5, 'L_5', false, axis_length); 
make_child(trf_link5_joint5, trf_viz_link5);

%% Animation: One joint at a time
for q1=[linspace(0, -pi/2, 30), linspace(-pi/2, pi/2, 30), linspace(pi/2, 0, 30)]
    set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [-0.2,0.4]);
    trf_q1= makehgtform('axisrotate', j1_rot_axis_j1, q1);
    set(trf_link1_joint1, 'Matrix', trf_q1);
    drawnow;
    pause(0.02);
end

for a3=[linspace(0, -0.04, 30), linspace(-0.04, 0.04, 30), linspace(0.04, 0, 30)]
    set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [-0.2,0.4]);
    trf_a3= makehgtform('translate', j3_translation_axis_j3*a3);
    set(trf_link3_joint3, 'Matrix', trf_a3);
    drawnow;
    pause(0.02);
end

for a5=[linspace(0, -0.04, 30), linspace(-0.04, 0.04, 30), linspace(0.04, 0, 30)]
    set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [-0.2,0.4]);
    trf_a5= makehgtform('translate', j5_translation_axis_j5*a5);
    set(trf_link5_joint5, 'Matrix', trf_a5);
    drawnow;
    pause(0.02);
end





%% Animation: All joints together.
q_init= 0.5*ones(4,1); % This leads to all joints being at 0.

for i= 1:20
    q_next= rand(4,1); 
    % rand() gives uniformly distributed random numbers in the interval [0,1]
    
    for t=0:0.02:1
        q  = q_init + t*(q_next - q_init);
        q1 = (pi/2)*(2*q(1) - 1);
        a3 = (0.04)*(2*q(3) - 1);
        a5 = (0.04)*(2*q(4) - 1);
        
        set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [-0.2,0.4]);
        trf_q1= makehgtform('axisrotate', j1_rot_axis_j1, q1);
        set(trf_link1_joint1, 'Matrix', trf_q1);
        
        set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [-0.2,0.4]);
        trf_a5= makehgtform('translate', j5_translation_axis_j5*a5);
        set(trf_link5_joint5, 'Matrix', trf_a5);
        
        drawnow;
        pause(0.005);
    end
    
    q_init= q_next;
    
end

