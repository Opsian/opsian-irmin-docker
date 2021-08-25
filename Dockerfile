FROM ubuntu:20.04
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/London"
RUN apt update && apt install -y opam curl ubuntu-dbgsym-keyring lsb-release gnuplot-x11 pkg-config libffi-dev libgmp-dev
RUN echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
RUN apt update
WORKDIR /
RUN opam init --disable-sandboxing -a --yes --bare && opam switch create 4.12.0
RUN opam install dune
RUN mkdir ~/.ssh
RUN touch ~/.ssh
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git clone --recurse-submodules https://github.com/Opsian/opsian-ocaml
RUN git clone --recurse-submodules https://github.com/mirage/irmin
workdir irmin
# pin and build opsian
RUN apt install -y autoconf libc6-dev libpthread-stubs0-dev libtool liblzma-dev
RUN opam pin -y --debug -vv add opsian git+file:///opsian-ocaml#main
RUN opam install -y --debug -vv opsian
# TODO: COPY ./irmin.patch .
RUN opam pin add -yn tezos-context-hash.dev 'vendors/tezos-context-hash/' && \
    opam pin add -yn tezos-context-hash-irmin.dev 'vendors/tezos-context-hash/' && \
    opam pin add -yn ppx_irmin.dev './' && \
    opam pin add -yn irmin.dev './' && \
    opam pin add -yn irmin-unix.dev './' && \
    opam pin add -yn irmin-test.dev './' && \
    opam pin add -yn irmin-pack.dev './' && \
    opam pin add -yn irmin-mirage.dev './' && \
    opam pin add -yn irmin-mirage-graphql.dev './' && \
    opam pin add -yn irmin-mirage-git.dev './' && \
    opam pin add -yn irmin-layers.dev './' && \
    opam pin add -yn irmin-http.dev './' && \
    opam pin add -yn irmin-graphql.dev './' && \
    opam pin add -yn irmin-git.dev './' && \
    opam pin add -yn irmin-fs.dev './' && \
    opam pin add -yn irmin-containers.dev './' && \
    opam pin add -yn irmin-chunk.dev './' && \
    opam pin add -yn irmin-bench.dev './'
ENV DEPS alcotest.1.4.0 alcotest-lwt.1.4.0 angstrom.0.15.0 asn1-combinators.0.2.6 astring.0.8.5 awa.0.0.3 awa-mirage.0.0.3 base.v0.14.1 base-bigarray.base base-bytes.base base-threads.base base-unix.base base64.3.5.0 bentov.1 bheap.2.0.0 bigarray-compat.1.0.0 bigstringaf.0.8.0 biniou.1.2.1 bos.0.2.0 ca-certs.0.2.1 ca-certs-nss.3.66 carton.0.4.3 carton-git.0.4.3 carton-lwt.0.4.3 cf.0.4 cf-lwt.0.4 checkseum.0.3.2 cmdliner.1.0.4 cohttp.4.0.0 cohttp-lwt.4.0.0 cohttp-lwt-unix.4.0.0 conduit.4.0.1 conduit-lwt.4.0.1 conduit-lwt-unix.4.0.1 conduit-mirage.4.0.1 conf-gmp.3 conf-gmp-powm-sec.3 conf-gnuplot.0.1 conf-libffi.2.0.0 conf-pkg-config.2 cppo.1.6.7 crunch.3.2.0 csexp.1.5.1 cstruct.6.0.1 cstruct-lwt.6.0.1 cstruct-sexp.6.0.1 cstruct-unix.6.0.1 ctypes.0.19.1 ctypes-foreign.0.18.0 decompress.1.4.2 digestif.1.0.1 dispatch.0.5.0 dns.5.0.1 dns-client.5.0.1 domain-name.0.3.0 duff.0.4 dune.2.9.0 dune-configurator.2.9.0 duration.0.2.0 easy-format.1.3.2 either.1.0.0 emile.1.1 encore.0.8 eqaf.0.8 ethernet.2.2.0 faraday.0.8.1 fmt.0.8.9 fpath.0.7.3 fsevents.0.3.0 fsevents-lwt.0.3.0 git.3.5.0 git-cohttp.3.5.0 git-cohttp-unix.3.5.0 git-paf.3.5.0 git-unix.3.5.0 gmap.0.3.0 graphql.0.13.0 graphql-cohttp.0.13.0 graphql-lwt.0.13.0 graphql_parser.0.13.0 h2.0.8.0 hex.1.4.0 hkdf.1.0.4 hpack.0.2.0 httpaf.0.7.1 hxd.0.3.1 index.dev inotify.2.3 integers.0.5.1 io-page.2.4.0 ipaddr.5.1.0 ipaddr-sexp.5.1.0 irmin-watcher.0.5.0 jsonm.1.0.1 ke.0.4 logs.0.7.0 lru.0.3.0 lwt.5.4.2 lwt-dllist.1.0.1 macaddr.5.1.0 macaddr-cstruct.5.1.0 magic-mime.1.2.0 memtrace.0.2.1.2 menhir.20210419 menhirLib.20210419 menhirSdk.20210419 metrics.0.3.0 metrics-unix.0.3.0 mimic.0.0.3 mirage-clock.3.1.0 mirage-clock-unix.3.1.0 mirage-crypto.0.10.3 mirage-crypto-ec.0.10.3 mirage-crypto-pk.0.10.3 mirage-crypto-rng.0.10.3 mirage-device.2.0.0 mirage-flow.2.0.1 mirage-flow-combinators.2.0.1 mirage-kv.3.0.1 mirage-net.3.0.1 mirage-no-solo5.1 mirage-no-xen.1 mirage-profile.0.9.1 mirage-protocols.5.0.0 mirage-random.2.0.0 mirage-stack.2.2.0 mirage-time.2.0.1 mmap.1.1.0 mtime.1.2.0 num.1.4 ocaml.4.12.0 ocaml-base-compiler.4.12.0 ocaml-compiler-libs.v0.12.3 ocaml-config.2 ocaml-migrate-parsetree.2.2.0 ocaml-options-vanilla.1 ocaml-syntax-shims.1.0.0 ocamlbuild.0.14.0 ocamlfind.1.9.1 ocamlgraph.2.0.0 ocplib-endian.1.1 optint.0.1.0 paf.0.0.5 parsexp.v0.14.1 pbkdf.1.2.0 pecu.0.6 ppx_cstruct.6.0.1 ppx_derivers.1.2.1 ppx_deriving.5.2.1 ppx_repr.dev ppx_sexp_conv.v0.14.3 ppxlib.0.22.2 printbox.0.5 progress.0.2.1 psq.0.2.0 ptime.0.8.5 randomconv.0.1.3 re.1.9.0 repr.dev result.1.5 rresult.0.6.0 rusage.1.0.0 semaphore-compat.1.0.1 seq.base sexplib.v0.14.0 sexplib0.v0.14.0 stdlib-shims.0.3.0 stringext.1.6.0 tcpip.6.2.0 terminal.0.2.1 tls.0.14.0 tls-mirage.0.14.0 topkg.1.0.3 uchar.0.0.2 uri.4.2.0 uri-sexp.4.2.0 uucp.13.0.0 uuidm.0.9.7 uutf.1.0.2 vchan.6.0.0 vector.1.0.0 webmachine.0.7.0 x509.0.14.1 xenstore.2.1.1 xenstore_transport.1.3.0 yaml.3.0.0 yojson.1.7.0 zarith.1.12
RUN opam install -y depext
RUN opam depext --update -y ppx_irmin.dev irmin.dev irmin-unix.dev irmin-test.dev irmin-pack.dev irmin-mirage.dev irmin-mirage-graphql.dev irmin-mirage-git.dev irmin-layers.dev irmin-http.dev irmin-graphql.dev irmin-git.dev irmin-fs.dev irmin-containers.dev irmin-chunk.dev irmin-bench.dev $DEPS
RUN opam install -y $DEPS
RUN curl http://data.tarides.com/irmin/data4_10310commits.repr -o data4_10310commits.repr
RUN curl http://data.tarides.com/irmin/data4_100066commits.repr -o data4_100066commits.repr
RUN curl http://data.tarides.com/irmin/data_1343496commits.repr -o data_1343496commits.repr
# RUN opam install -y .
COPY ./irmin.patch .
RUN git apply ./irmin.patch
RUN opam exec -- make
COPY ./bench.sh ./bench.sh
CMD ./bench.sh

