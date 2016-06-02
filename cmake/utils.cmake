
# All files in input parameter are set in a source group according to path
function(grpc_source_group files)
  foreach(f ${${files}})
    get_filename_component(path ${f} DIRECTORY)
    string(REPLACE "/" "\\" path ${path})
    source_group(${path} FILES ${f})
  endforeach()
endfunction()
