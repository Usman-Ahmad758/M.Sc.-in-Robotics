function [Ypred, rms_pred, rms_overall] = LSTM_Algorithm(pxx, px)

rng("default");

%% Partition of Data

%The input data will be pxx, pyy,pzz, output data will be px, py,pz
%Starting with x

NTST1 =floor( 0.6* numel(pxx) );
NTST2 =floor( 0.6* numel(px) );

dataTrain1 = pxx(1:NTST1);  %Inputs 
dataTest1 = pxx(1:end);

dataTrain2= px(1:NTST2);     %outputs
dataTest2 = px(1:end);

%% Normalization of data

mu1 = mean(dataTrain1);
sig1 = std(dataTrain1);
dataTrainStd1= (dataTrain1-mu1)/sig1;

mu2 = mean(dataTrain2);
sig2 = std(dataTrain2);
dataTrainStd2= (dataTrain2-mu2)/sig2;

%% Inputs and outputs
%Input parameters are features
%Output parameters are responses

%During Training

XTrain = dataTrainStd1;
YTrain = dataTrainStd2;

%% LSTM Network Architecture

NOF = 1; %No of Features/Inputs
NOR =1;  %No of Responses/Outputs
NHU= 250; %No of Hidden Units

layers = [ sequenceInputLayer(NOF, 'Name', 'ip'),...
    lstmLayer(NHU,'Name','lstm'),...
    fullyConnectedLayer(NOR,'Name','Fc'),...
    regressionLayer('Name','RL')];

lgraph= layerGraph(layers);
plot(lgraph);

%% Specifying the training options

options = trainingOptions('adam',...
    'MaxEpochs', 600, ...
    'GradientThreshold', 1,...
    'InitialLearnRate', 0.005,...
    'LearnRateSchedule', 'piecewise',...
    'LearnRateDropPeriod',125,...
    'LearnRateDropFactor', 0.2,...
    'Verbose', 0,...
    'Plots', 'training-progress');

%% Training LSTM

net = trainNetwork(XTrain,YTrain,layers,options);

%% VALIDATION PHASE
%Using same sig and mu here for the test data

dataTestStd1= (dataTest1-mu1)/sig1;


XTest = dataTestStd1;
YTest = dataTest2;

%Predicting and updating the state

% net = predictAndUpdateState(net,XTrain);
Ypred= zeros(1,length(XTest));

for i= 1:length(XTest)
    
    testingdata= XTest(:,i);
    [net, predict]= predictAndUpdateState(net,testingdata,'ExecutionEnvironment','auto');
    Ypred(:,i) = predict;
    
end

Ypred = (sig2.*Ypred)+mu2;
rms_pred = sqrt(mean(Ypred-YTest).^2);
disp('Root Mean Square Error of Validation Data after Training');
disp(rms_pred);


disp('Root Mean Square Error of Raw Data');
rms_overall = sqrt(mean(pxx-px).^2);
disp(rms_overall);




end