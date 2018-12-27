#!/bin/bash

set -euo pipefail

nginx_repo='https://github.com/nginx/nginx.git'
vts_repo='https://github.com/vozlt/nginx-module-vts.git'

builddir='/build'
nginx_dir="${builddir}/nginx"
vts_dir="${builddir}/vts"
pkg_dir="${builddir}/pkg"

nginx_release='1.15.7'
nginx_tag="release-${nginx_release}"
vts_release='0.1.18'
vts_tag="v${vts_release}"

git clone ${nginx_repo} ${nginx_dir}
git clone ${vts_repo} ${vts_dir}

cd ${vts_dir}
git checkout ${vts_tag}

cd ${nginx_dir}
git checkout ${nginx_tag}

cd ${nginx_dir}
./auto/configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-compat \
    --with-file-aio \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
    --add-module=${vts_dir}

make -j 4

mkdir -p "${pkg_dir}"
cp "${nginx_dir}/objs/nginx" "${pkg_dir}/nginx-vts"

# Depend on nginx for now to obtain default configs (/etc/nginx)
fpm \
    --name nginx-vts \
    --version ${nginx_release}-${vts_release} \
    --output-type deb \
    --input-type dir \
    --package ${pkg_dir} \
    --force \
    --maintainer 'Alex Dzyoba <alex@dzyoba.com>' \
    --depends 'init-system-helpers (>= 1.18~)' \
    --depends 'libc6 (>= 2.17)' \
    --depends 'libpcre3' \
    --depends 'libssl1.1 (>= 1.1.0)' \
    --depends 'zlib1g (>= 1:1.1.4)' \
    --depends 'lsb-base (>= 3.0-6)' \
    --depends 'nginx' \
    --url 'https://github.com/alexdzyoba/nginx-vts-build' \
    --license 'BSD' \
    --vendor '' \
    --architecture 'amd64' \
    --category 'httpd' \
    --deb-priority 'optional' \
    --description  "nginx distribution built with VTS module" \
    ${pkg_dir}/=/usr/sbin/

