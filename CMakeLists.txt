# based on
# https://alcarazzam.dev/posts/generate-python-bindings-shiboken/
# https://github.com/KDE/labplot/blob/master/lib/python/CMakeLists.txt

cmake_minimum_required(VERSION 3.16)
project(KTextEditorPythonBindings LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Python3
find_package(Python3 COMPONENTS Interpreter Development REQUIRED)

# Find Qt, KF6, Shiboken
find_package(Qt6 REQUIRED COMPONENTS Core Widgets Gui)
find_package(KF6TextEditor REQUIRED)
find_package(Shiboken6 REQUIRED)
find_package(PySide6 REQUIRED)

# ecm_generate_python_bindings
include(ECMGeneratePythonBindings)

set(bindings_library "KTextEditor")

# TODO upstream to https://invent.kde.org/frameworks/ktexteditor
# as /python/bindings.xml etc
set(wrapped_header ${CMAKE_SOURCE_DIR}/bindings.h)
set(typesystem_file ${CMAKE_SOURCE_DIR}/bindings.xml)

set(generated_sources
    ${CMAKE_CURRENT_BINARY_DIR}/KTextEditor/ktexteditor_wrapper.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/KTextEditor/ktexteditor_module_wrapper.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/KTextEditor/ktexteditor_editor_wrapper.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/KTextEditor/ktexteditor_document_wrapper.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/KTextEditor/ktexteditor_view_wrapper.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/KTextEditor/ktexteditor_cursor_wrapper.cpp
    # TODO more?
)

# https://api.kde.org/ecm/module/ECMGeneratePythonBindings.html
ecm_generate_python_bindings(
    PACKAGE_NAME ${bindings_library}
    VERSION ${KF_VERSION}
    WRAPPED_HEADER ${wrapped_header}
    TYPESYSTEM ${typesystem_file}
    GENERATED_SOURCES ${generated_sources}
    DEPENDENCIES KF6::TextEditor
    QT_VERSION ${REQUIRED_QT_VERSION}
    HOMEPAGE_URL "https://invent.kde.org/frameworks/ktexteditor"
    ISSUES_URL "https://bugs.kde.org/describecomponents.cgi?product=frameworks-ktexteditor"
    AUTHOR "The KDE Community"
    README ./README.md
)

target_link_libraries(${bindings_library}
    PRIVATE
        KF6::TextEditor
        Qt6::Core
        Qt6::Widgets
        Qt6::Gui
)

target_include_directories(${bindings_library}
    PRIVATE
        $<TARGET_PROPERTY:Shiboken6::libshiboken,INTERFACE_INCLUDE_DIRECTORIES>
        $<TARGET_PROPERTY:PySide6::pyside6,INTERFACE_INCLUDE_DIRECTORIES>
        ${CMAKE_BINARY_DIR}  # where the generated *_python.h files live
)

install(TARGETS ${bindings_library} LIBRARY DESTINATION "${KDE_INSTALL_LIBDIR}/python-kf6")
