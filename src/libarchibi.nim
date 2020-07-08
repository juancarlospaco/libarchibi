when nimvm: discard else: from osproc import execCmdEx

template compressImpl(filename, includes, excludes: string, verbose: bool): string =
  ("bsdtar --format ustar --create --auto-compress -f '" & filename & "' " &
  (if excludes.len > 0: "--exclude='" & excludes & "' " else: " ") &
  (if includes.len > 0: "--include='" & includes & "' " else: " ") & (if verbose: "-v -totals " else: " "))

proc compress*(filename: string, includes = "", excludes = "", verbose = true): tuple[output: string, exitCode: int] {.inline.} =
  assert filename.len > 0
  when nimvm: result = gorgeEx(compressImpl(filename, includes, excludes, verbose))
  else: result = execCmdEx(compressImpl(filename, includes, excludes, verbose))

template extractImpl(filename, destinationDir: string, overwrite, verbose, permissions, time: bool): string =
  ("bsdtar --extract -C '" & destinationDir & "' -f '" & filename & "' " &
  (if permissions: "-p " else: "") & (if overwrite: "" else: "-k ") &
  (if verbose: "-v " else: "") & (if time: "" else: "-m "))

proc extract*(filename, destinationDir: string, overwrite = true, verbose = true, permissions = true, time = true): tuple[output: string, exitCode: int] {.inline.} =
  assert filename.len > 0 and destinationDir.len > 0
  when nimvm: result = gorgeEx(extractImpl(filename, destinationDir, overwrite, verbose, permissions, time))
  else: result = execCmdEx(extractImpl(filename, destinationDir, overwrite, verbose, permissions, time))
