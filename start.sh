#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
#
# start.sh
#
# SCANOSS startup script
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
    curl -LO https://github.com/scanoss/test-kb/releases/download/v0.1.0/ldb.tar.xz
    tar -vaxf ldb.tar.xz
    rm ldb.tar.xz
fi

# Run SCANOSS container
docker run --rm -p 5443:5443 \
   -e SCANOSS_API_URL=http://localhost:5443/api \
   -v $(pwd)/ldb:/var/lib/ldb \
   -it ghcr.io/scanoss/scanoss-engine
