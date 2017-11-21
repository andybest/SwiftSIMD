#!/bin/sh

swift build --configuration release
.build/release/GenBoilerplate Sources/SwiftSIMD templates/VectorTemplate.stencil
