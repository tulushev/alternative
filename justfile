setup:
	cd SPIRV-Cross && make
	cd rust-gpu && cargo build --release
	sed -i '' "4s|CLONED_LOCATION|$(pwd)|" shader/.cargo/config.toml

build:
	cd shader && cargo build --release
	./SPIRV-Cross/spirv-cross --msl --entry main_fs ./shader/target/spirv-unknown-spv1.3/release/deps/shader.spv --output ./alternative/alternative/fragment_shader.metal 
	./SPIRV-Cross/spirv-cross --msl --entry main_vs ./shader/target/spirv-unknown-spv1.3/release/deps/shader.spv --output ./alternative/alternative/vertex_shader.metal 
