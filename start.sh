#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
#
# start.sh
#
# SCANOSS Startup Script
# 
# This program pulls the SCANOSS test-kb and runs the scanoss-engine container.
#
# Copyright (C) 2018-2020 SCANOSS.COM
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Download test kb
if [ ! -d "ldb" ]; then
    # Minimum required disk space in bytes (45 GB)
    MIN_REQUIRED_SPACE=$((45 * 1024 * 1024 * 1024))

    # Check available disk space
    available_space=$(df . | awk 'NR==2 {print $4}')

    if [ "$available_space" -lt "$MIN_REQUIRED_SPACE" ]; then
        echo "Insufficient disk space available. At least 45 GB required."
        exit 1
    fi

    curl -LO https://github.com/scanoss/test-kb/releases/download/v0.1.0/ldb.tar.xz
    tar -vaxf ldb.tar.xz
    rm ldb.tar.xz
fi

# Default to interactive mode
MODE="-it"

# Process command line options
while getopts ":d" opt; do
  case ${opt} in
    d )
      MODE="-d" ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1 ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1 ;;
  esac
done
shift $((OPTIND -1))

# Run SCANOSS container
docker run --rm $MODE -p 8083:8083 \
   -v $(pwd)/ldb:/var/lib/ldb \
   ghcr.io/scanoss/scanoss-engine
