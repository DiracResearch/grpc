
set(GRPC_TARGETS
  gpr
  grpc_cpp_plugin
  grpc_plugin_support
  grpc_unsecure
  grpc++_unsecure
  libprotobuf
  libprotoc
  protoc
  zlibstatic
  grpc
  grpc++
)

foreach(target ${GRPC_TARGETS})
	if(TARGET ${target})
		set_target_properties(${target} PROPERTIES FOLDER "Libraries/gRPC")
	endif()
endforeach()

set(SSL_TARGETS
  aes
  asn1
  base64
  bio
  bn
  buf
  bytestring
  c-ares
  chacha
  cipher
  cmac
  conf
  crypto
  curve25519
  des
  dh
  digest
  dsa
  ec
  ecdh
  ecdsa
  engine
  err
  evp
  hkdf
  hmac
  js_embed
  lhash
  md4
  md5
  modes
  obj
  pem
  pkcs8_lib
  poly1305
  pool
  rand
  rc4
  rsa
  sha
  ssl
  stack
  x509
  x509v3
)

foreach(target ${SSL_TARGETS})
	if(TARGET ${target})
		set_target_properties(${target} PROPERTIES FOLDER "Libraries/SSL")
	endif()
endforeach()