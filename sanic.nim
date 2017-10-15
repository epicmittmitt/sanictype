import os 
import winim
import strutils
type Word = tuple
  word: string
  count: int
var frag = ""
var lastString = ""
var db = newSeq[Word](0)
var tabs = 0
var on = true
echo "Loading database ..."
for str in readFile("db.txt").splitLines:
  var parts = str.split(',')
  db.add((word: parts[0], count: parts[1].parseInt))
echo "Complete. Loaded ", db.len, " words"
proc complete(frag:string, i: int): string = 
  var counter = 0
  for str in db:
    if str.word.startsWith(frag):
      if counter == i:
        return str.word.replace(frag, "")
      counter += 1
proc writeString(input: string) = 
  for c in input:
    keybd_event(VkKeyScan(c.BYTE).BYTE, 0x9e.BYTE, 0, 0)
    keybd_event(VkKeyScan(c.BYTE).BYTE, 0x9e.BYTE, KEYEVENTF_KEYUP, 0)
proc backspace(num: int) =
  for i in 0..<num:
    keybd_event(VK_BACK, 0x9e.BYTE, 0, 0);
    keybd_event(VK_BACK, 0x9e.BYTE, KEYEVENTF_KEYUP, 0);
proc reset() =
  frag = ""
  tabs = 0
  lastString = ""
proc main() =
  while true:
    Sleep(50)
    for i in 8..190:
      if GetAsyncKeyState(cint(i)) == -32767:
        if VK_SPACE == i or VK_RETURN == i: 
          if not lastString.isNilOrEmpty: echo frag, lastString
          reset()
        elif VK_BACK == i: frag.delete(frag.len, frag.len)
        elif chr(i) in Letters: frag = frag & toLowerAscii($chr(i))
        var delFrag = false
        if frag == "sanicon":
          on = true
          delFrag = true
        if frag == "sanicoff":
          on = false
          delFrag = true
        if frag == "sanicexit":
          backspace("sanicexit".len)
          return
        if delFrag:
          backspace(frag.len)
          reset()
        if VK_TAB == i and on:
          backspace(lastString.len + 1)
          lastString = complete(frag.strip, tabs)
          writeString(lastString)
          tabs += 1
main()
