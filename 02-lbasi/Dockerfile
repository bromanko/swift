FROM bromanko/swift:2.2-SNAPSHOT-2016-03-16-a

ENV ROOT=/usr/src/app/

WORKDIR ${ROOT}
RUN mkdir -p ${ROOT}

COPY ["CMakeLists.txt", "Package.swift", "${ROOT}"]
COPY Sources ${ROOT}/Sources

RUN swift build

CMD .build/debug/LetsBuildASimpleInterpreter