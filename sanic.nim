import os 
import winim
import strutils
var frag = ""
var lastString = ""
var db = newSeq[string](0)
var tabs = 0
var on = true
for str in readFile("db.txt").split:
  if str.len > 3:
    db.add(str)
proc complete(frag:string, i: int): string = 
  var counter = 0
  for str in db:
    if str.startsWith(frag) and counter == i:
      return str.replace(frag, "")
    counter += 1
proc writeString(input: string) = 
  for c in input:
    keybd_event(VkKeyScan(c.BYTE).BYTE, 0x9e.BYTE, 0, 0);
    keybd_event(VkKeyScan(c.BYTE).BYTE, 0x9e.BYTE, KEYEVENTF_KEYUP, 0);
proc backspace(num: int) =
  for i in 0..<num:
    keybd_event(VK_BACK, 0x9e.BYTE, 0, 0);
    keybd_event(VK_BACK, 0x9e.BYTE, KEYEVENTF_KEYUP, 0);
proc main() =
  while true:
    Sleep(50)
    for i in 8..190:
      if GetAsyncKeyState(cint(i)) == -32767:
        proc reset() =
          frag = ""
          tabs = 0
          lastString = ""
        if VK_SPACE == i or VK_RETURN == i: reset()
        elif VK_BACK == i: frag.delete(frag.len, frag.len)
        elif chr(i) in Letters: frag = frag & toLowerAscii($chr(i))
        if frag == "sanicon": on = true
        if frag == "sanicoff": on = false
        if VK_TAB == i and on:
          backspace(lastString.len + 1)
          lastString = complete(frag.strip, tabs)
          writeString(lastString)
          tabs += 1
main()
