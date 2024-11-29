#********************************************************************************
# Copyright (c) 2023 Martin Erich Jobst
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.
#
# SPDX-License-Identifier: EPL-2.0
# 
# Contributors:
#    Martin Jobst
#      - initial API and implementation and/or initial documentation
# *******************************************************************************/

FROM buildpack-deps:noble

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		cmake \
		lcov \
		libmbedtls-dev \
		libboost-all-dev \
	; \
	rm -rf /var/lib/apt/lists/*

ENV WORKDIR=/build

RUN set -eux; \
	git clone --depth 1 --branch v1.3.4 --recurse-submodules https://github.com/open62541/open62541 $WORKDIR/open62541; \
	sed -i 's/CMAKE_INTERPROCEDURAL_OPTIMIZATION ON/CMAKE_INTERPROCEDURAL_OPTIMIZATION OFF/g' $WORKDIR/open62541/CMakeLists.txt; \
	mkdir -p $WORKDIR/open62541/binStatic && cd $WORKDIR/open62541/binStatic; \
	cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DUA_ENABLE_AMALGAMATION=ON -DUA_ENABLE_DISCOVERY=ON -DUA_ENABLE_DISCOVERY_MULTICAST=ON -DUA_ENABLE_SUBSCRIPTIONS_EVENTS=ON ..; \
	make -j$(nproc); \
	mkdir -p $WORKDIR/open62541/binShared && cd $WORKDIR/open62541/binShared; \
	cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DUA_ENABLE_AMALGAMATION=ON -DUA_ENABLE_DISCOVERY_MULTICAST=ON -DBUILD_SHARED_LIBS=ON -DUA_ENABLE_SUBSCRIPTIONS_EVENTS=ON ..; \
	make -j$(nproc) all; \
	mkdir -p $WORKDIR/open62541/binStaticEncrypted && cd $WORKDIR/open62541/binStaticEncrypted; \
	cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DUA_ENABLE_AMALGAMATION=ON -DUA_ENABLE_DISCOVERY_MULTICAST=ON -DUA_ENABLE_ENCRYPTION=ON -DUA_ENABLE_SUBSCRIPTIONS_EVENTS=ON ..; \
	make -j$(nproc) all;
