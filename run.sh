emcc -o index.html \
    basic_window.c \
    -lraylib -Os -Wall \
    external/raylib-5.5/src/*.a \
    -I external/raylib-5.5/src/ \
    -L external/raylib-5.5/src/ \
    -s USE_GLFW=3 \
    -s ASYNCIFY \
    --shell-file shell.html \
    -s TOTAL_STACK=64MB \
    -s INITIAL_MEMORY=128MB \
    -s ASSERTIONS \
    -DPLATFORM_WEB 
emrun index.html
