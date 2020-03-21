when nimvm: discard else: from osproc import execCmdEx

type
  Action* {.pure.} = enum create = "-c", add = "-r", replace = "-r", update = "-u"
  Algo* {.pure.} = enum gzip = "-z", bzip2 = "-j", xz = "-J", lzma = "--lzma"

proc compress*(action: Action, algo: Algo, filename: string,
    includes = "", excludes = "", verbose = true): tuple[output: string, exitCode: int] =
  runnableExamples: static: echo compress(Action.create, Algo.gzip, filename = "temp", includes = "libarchibi.nim")
  let cmd = ("bsdtar --format ustar " & $action & " " & $algo & " " & "-f '" & filename &
    (if algo == Algo.xz: ".tar.xz" else: ".tar.gz") & "' " &
    (if excludes.len > 0: "--exclude '" & excludes & "' " else: " ") &
    (if verbose: "-v " else: " ") & (if includes.len > 0: "'" & includes & "'" else: ""))
  when nimvm: result = gorgeEx(cmd) else: result = execCmdEx(cmd)

proc extract*(filename, destinationDir: string, overwrite = true, verbose = true,
    permissions = true, time = true): tuple[output: string, exitCode: int] =
  runnableExamples: static: echo extract(filename = "libarchibi.tar.gz", ".")
  let cmd = ("bsdtar -x -C '" & destinationDir & "' -f '" & filename & "' " &
    (if permissions: "-p " else: "") & (if overwrite: "" else: "-k ") &
    (if verbose: "-v " else: "") & (if time: "" else: "-m "))
  when nimvm: result = gorgeEx(cmd) else: result = execCmdEx(cmd)
