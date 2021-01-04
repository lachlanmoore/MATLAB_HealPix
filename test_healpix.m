%% Main function to generate tests
function tests = test_healpix
tests = functiontests(localfunctions);
end

%% Test Functions
function testFunctionOne(testCase)
    py.importlib.import_module('numpy');
    
    colatitude = testCase.TestData.colatitude;
    longitude = testCase.TestData.longitude;
    
    cosTheta = cos(colatitude);
    lon_norm = longitude/pi;
    x = lon_norm;
    y = cosTheta;

    % create numpy arrays of angles
    theta = py.numpy.array(colatitude);
    phi = py.numpy.array(longitude);
    % convert angles to a nx3 unit vector 
    vec = py.healpy.ang2vec(theta,phi);

    % choose the resolution of the map, which must be a power of 2
    nside = testCase.TestData.nside;
    % convert MATLAB data type to numpy array and cast as uint8
    nside_py = py.numpy.array(nside).astype('uint8');
    % create array to hold 
    % npix == 12*nside^2
    npix = py.healpy.nside2npix(nside_py);

    % get the pixel locations based on the angles theta and phi
    % get nest pixels and neighbors: this is the ordering scheme we'll use
    % refer to https://healpix.sourceforge.io/pdf/intro.pdf to see how
    % these pixels neighbor each other
    pix_nest_mat = ang2pix(nside, colatitude, longitude, 1, 0)';
    neighbors_nest_mat = neighbor_nest(nside, pix_nest_mat)';
    
    pix_nest_py = int64(py.healpy.ang2pix(nside_py,theta,phi,pyargs('nest',1)));
    neighbors_nest_py = int64(py.healpy.get_all_neighbours(nside_py,theta,phi,pyargs('nest',1)));
    
    testCase.verifyEqual(pix_nest_py,int64(pix_nest_mat));
    testCase.verifyEqual(sort(neighbors_nest_py),int64(sort(neighbors_nest_mat)));
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
    clc
    % set a new path, for example
    
    % create and change to temporary folder
    disp("Adding Test Data")
    testCase.TestData.origPath = pwd;
    testCase.TestData.tmpFolder = ['tmpFolder' datestr(now,30)];
    mkdir(testCase.TestData.tmpFolder)
    cd(testCase.TestData.tmpFolder)
    % load appropriate crater data
    % ensure that the Python distribution you are using has Healpy installed:
    % you can choose the version by using pyenv
    % e.g., pyenv('Version', '/usr/local/bin/python3.7')

    % theta is colatitude: 0 at north pole, pi/2 at equator, pi at south pole
    % conversion from latitude to colatitude: colat = pi/2-latitude
    % phi is the longitude: 0 at center of mollweide projection and increasing
    % eastward up to 2pi
    n_pts = 50;
    latitude = linspace(-pi/2, pi/2, n_pts);%[pi/2:-0.1:0];
    colatitude = wrapTo2Pi(pi/2-latitude);
    longitude = linspace(0, 2*pi, n_pts);
    [colat, lon] = meshgrid(colatitude, longitude);
    testCase.TestData.colatitude = colat(:);
    testCase.TestData.longitude = lon(:);
    testCase.TestData.nside = 2;
    disp("Running Tests...")
end

function teardownOnce(testCase)  % do not change function name
% change back to original path, for example
    disp("Removing Test Data")
    cd(testCase.TestData.origPath)
    rmdir(testCase.TestData.tmpFolder)
    disp("Complete!")
end


%% Optional fresh fixtures 
