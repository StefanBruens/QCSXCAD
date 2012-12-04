TEMPLATE = lib
TARGET = QCSXCAD

VERSION = 0.3.1

# add git revision
GITREV = $$system(git describe --tags)
DEFINES += GIT_VERSION=\\\"$$GITREV\\\"

# vtk includes deprecated header files; silence the corresponding warning
QMAKE_CXXFLAGS += -Wno-deprecated

exists(localPathes.pri) {
    include(localPathes.pri)
}

MOC_DIR = moc
OBJECTS_DIR = obj
QT += core \
    gui \
    xml

HEADERS += QCSXCAD.h \
    QCSGridEditor.h \
    QCSPrimEditor.h \
    QCSPropEditor.h \
    QCSTreeWidget.h \
    QParameterGui.h \
    QVTKStructure.h \
    VTKPrimitives.h \
    QCSXCAD_Global.h \
    export_x3d.h \
    export_pov.h \
    QGeometryPlot.h
SOURCES += QCSXCAD.cpp \
    QCSGridEditor.cpp \
    QCSPrimEditor.cpp \
    QCSPropEditor.cpp \
    QCSTreeWidget.cpp \
    QParameterGui.cpp \
    QVTKStructure.cpp \
    VTKPrimitives.cpp \
    export_x3d.cpp \
    export_pov.cpp \
    QGeometryPlot.cpp \
    QCSXCAD_Global.cpp

win32 { 
    DEFINES += BUILD_QCSXCAD_LIB

    isEmpty(WIN32_LIB_ROOT) {
        WIN32_LIB_ROOT = ..
    }
    isEmpty(CSXCAD_ROOT) {
     CSXCAD_ROOT = $$WIN32_LIB_ROOT/CSXCAD
    }

    # CSXCAD
    INCLUDEPATH += $$CSXCAD_ROOT/include/CSXCAD
    LIBS += -L$$CSXCAD_ROOT/lib -lCSXCAD0

    # #3rd party libraries#
    # tinyxml
    INCLUDEPATH += $$WIN32_LIB_ROOT/tinyxml/include
    LIBS += -L$$WIN32_LIB_ROOT/tinyxml/bin -ltinyxml2

    # vtk
    INCLUDEPATH +=   $$WIN32_LIB_ROOT/vtk/include/vtk-5.10
    LIBS += -L$$WIN32_LIB_ROOT/vtk/bin -lvtkCommon -lQVTK -lvtkRendering -lvtkGraphics -lvtkFiltering -lvtkIO -lvtkHybrid -lvtkWidgets
}

unix { 
    # CSXCAD
    isEmpty(CSXCAD_ROOT) {
     CSXCAD_ROOT = /usr
    }
    INCLUDEPATH += $$CSXCAD_ROOT/include/CSXCAD
    LIBS += -L$$CSXCAD_ROOT/lib -lCSXCAD

    # #3rd party libraries#
    INCLUDEPATH += /usr/include/vtk-5.2 \
        /usr/include/vtk-5.4 \
        /usr/include/vtk-5.6 \
        /usr/include/vtk-5.8 \
        /usr/include/vtk-5.10 \
        /usr/include/vtk
    LIBS += -lvtkCommon \
        -lvtkDICOMParser \
        -lvtkFiltering \
        -lvtkGenericFiltering \
        -lvtkGraphics \
        -lvtkHybrid \
        -lvtkIO \
        -lvtkImaging \
        -lvtkParallel \
        -lvtkRendering \
        -lvtkVolumeRendering \
        -lvtkWidgets \
        -lvtkexoIIc \
        -lvtkftgl \
        -lvtksys \
        -lQVTK
}
FORMS += 
RESOURCES += resources.qrc
DEFINES += BUILD_QCSXCAD_LIB
QMAKE_CXXFLAGS_DEBUG = -O0 -g


#
# create tar file
#
tarball.target = tarball
tarball.commands = git archive --format=tar --prefix=QCSXCAD-$$VERSION/ HEAD | bzip2 > QCSXCAD-$${VERSION}.tar.bz2

QMAKE_EXTRA_TARGETS += tarball


#
# INSTALL
#
isEmpty(PREFIX) {
 PREFIX = /usr/local
}
install.target = install
install.commands = mkdir -p \"$$PREFIX/lib$$LIB_SUFFIX\"
install.commands += && mkdir -p \"$$PREFIX/include/QCSXCAD\"
install.commands += && cp -at \"$$PREFIX/include/QCSXCAD/\" $$HEADERS
unix:install.commands += && cp -at \"$$PREFIX/lib$$LIB_SUFFIX/\" libQCSXCAD.so*
win32:install.commands += && cp -at \"$$PREFIX/lib$$LIB_SUFFIX/\" release/QCSXCAD0.dll

QMAKE_EXTRA_TARGETS += install


#
# create .PHONY target
#
phony.target = .PHONY
phony.depends = $$QMAKE_EXTRA_TARGETS
QMAKE_EXTRA_TARGETS += phony
