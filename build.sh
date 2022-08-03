#!/bin/bash

#  Copyright (C) 2018-2022 LEIDOS.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); you may not
#  use this file except in compliance with the License. You may obtain a copy of
#  the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#  License for the specific language governing permissions and limitations under
#  the License.

# This script is meant to generate .gcov files for code coverage analysis by sonar cloud
# This script depends on collect_gcovr.bash
# This script requires that gcovr be installed
# WARNING this script will remove any .gcov files which currently exist under the output directory argument 2. default=./coverage_reports/gcov/
#
# Required Options
# Either -m or -t or both must be set
#       -m Call make: If set then catkin_make install will be called
# -t Run tests: If set then catkin_make run_tests will be called
# Additional Options
# -e The execution directory which this script will be run from. Generally this should be the catkin workspace with all source code and binaries below this directory
# -o The output directory which the .gcov files will be written to. Relative paths in the output directory will be resolved relative to the execution directory
#
#
set -e

COVERAGE_FLAGS="-g --coverage -fprofile-arcs -ftest-coverage"

cd /opt/carma/src/CARMANovatelGpsDriver
mkdir build
cd ./novatel_gps_driver/build
cmake -DCMAKE_CXX_FLAGS="${COVERAGE_FLAGS}" -DCMAKE_C_FLAGS="${COVERAGE_FLAGS}" -DCMAKE_BUILD_TYPE="Debug" ..
make
make install

cd /opt/carma/src/CARMANovatelGpsDriver
mkdir build
cd /opt/carma/src/CARMANovatelGpsDriver/build
cmake -DCMAKE_CXX_FLAGS="${COVERAGE_FLAGS}" -DCMAKE_C_FLAGS="${COVERAGE_FLAGS}" -DCMAKE_BUILD_TYPE="Debug" ..
make

cd /opt/carma/src/CARMANovatelGpsDriver
mkdir build
cd /opt/carma/src/CARMANovatelGpsDriver/build/
cmake -DCMAKE_CXX_FLAGS="${COVERAGE_FLAGS}" -DCMAKE_C_FLAGS="${COVERAGE_FLAGS}" -DCMAKE_BUILD_TYPE="Debug" ..
make
make install

cd /opt/carma/src/CARMANovatelGpsDriver
mkdir build
cd /opt/carma/src/CARMANovatelGpsDriver/build
cmake -DCMAKE_CXX_FLAGS="${COVERAGE_FLAGS}" -DCMAKE_C_FLAGS="${COVERAGE_FLAGS}" -DCMAKE_BUILD_TYPE="Debug" ..
make
