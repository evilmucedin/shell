#!/usr/bin/env python

import sys
import os
import stat
import random
import optparse
import subprocess

def catPath(path, subfolders):
    return path + "/" + "/".join(subfolders)

class FSWalker:
    def __init__(self, path, callbacks):
        self.mPath = path
        self.mCallbacks = callbacks

    def walkInt(self, path0, subfolders):
        dir = catPath(path0, subfolders)
        for callback in self.mCallbacks:
            callback.enter(path0, subfolders)
        for item in os.listdir(dir):
            if -1 == item.find(".svn") and -1 == item.find("SRC") and -1 == item.find("CMakeFiles"):
                good = True
                try:
                    itemStat = os.stat(dir + "/" + item)
                except:
                    good = False
                if good and not stat.S_ISLNK(itemStat[0]):
                    if stat.S_ISDIR(itemStat[0]):
                        subfolders.append(item)
                        self.walkInt(path0, subfolders)
                        subfolders.pop()
                    else:
                        for callback in self.mCallbacks:
                            callback.file(path0, subfolders, item)
        for callback in self.mCallbacks:
            callback.exit(path0, subfolders)
    
    def walk(self):
        self.walkInt(self.mPath, [])
        for callback in self.mCallbacks:
            callback.end()

class EmptyCallback:
    def enter(self, path0, subfolders):
        pass

    def file(self, path0, subfolders, file):
        pass

    def exit(self, path0, subfolders):
        pass

    def end(self):
        pass

class ProjectWriter(EmptyCallback):
    def __init__(self, out):
        self.mLevel = 0
        self.mOut = out
    
    def enter(self, path0, subfolders):
        path = catPath(path0, subfolders)
        # print path
        alias = filter(lambda x: x != "", path.split("/"))[-1]
        print >>self.mOut, " "*self.mLevel + alias + "=" + path + " CD=\"" + path + "\" {"
        self.mLevel += 1

    def file(self, path0, subfolders, file):
        print >>self.mOut, " " * self.mLevel + file
    
    def exit(self, path0, subfolders):
        self.mLevel -= 1
        print >>self.mOut, " "*self.mLevel + "}"

ECHO = False
def sExec(command):
    if ECHO:
        print command
    p = subprocess.Popen(command, shell=True, stdout=sys.stdout, stdin=sys.stdin, stderr=sys.stderr)
    retCode = p.wait()
    if 0 != retCode:
        raise Exception("'%s' failed with %d" % (command, retCode))

class CtagsGenerator(EmptyCallback):
    def __init__(self, root):
        self.mFiles = []
        self.mRoot = root

    def file(self, path0, subfolders, file):
        path = catPath(path0, subfolders)
        if 0 != len(subfolders):
            if subfolders[0] in ["search", "util", "quality", "ysite", "yandex", "yweb", "library"] or (len(subfolders) > 2 and subfolders[0] == "junk" and subfolders[1] == "denplusplus"):
                if file.endswith(".cpp") or file.endswith(".h") and (os.path.getsize(path0) < 1000000):
                    self.mFiles.append(path + "/" + file)

    def end(self):
        self.mFiles = sorted(self.mFiles, lambda x, y: cmp(x, y))
        BATCH = 1000
        i = 0
        out = "%s/tags" % (self.mRoot)
        while i < len(self.mFiles):
            mx = min( len(self.mFiles), i + BATCH )
            sExec("ctags -f %s %s %s" % (out, "" if 0 == i else "-a", " ".join(self.mFiles[i:mx])))
            i = mx

def findArcadia(path):
    parts = path.split("/")
    i = len(parts) - 1
    while i >= 0 and parts[i] != 'arcadia':
        i -= 1
    if i >= 0:
        return (True, "/".join(parts[0:i + 1]))
    else:
        return (False, )

def findArcadiaWrapper(path):
    resFind = findArcadia(path)
    if resFind[0]:
        print "arcadia found: " + resFind[1]
        return resFind[1]
    else:
        return path

def handleOptions():
    parser = optparse.OptionParser()
    parser.add_option("-c", "--ctags", action="store_true", dest="ctags", help="generate ctags", default=False)
    (options, args) = parser.parse_args()
    return options

root = findArcadiaWrapper(os.getcwd())

callbacks = []

options = handleOptions()
if options.ctags:
    callbacks.append(CtagsGenerator(root))

path = "/Users/denplusplus"
if not os.path.exists(path):
    path = "/home/denplusplus"
path += "/.vimprojects"
callbacks.append( ProjectWriter(open(path, "w")) )

walker = FSWalker(root, callbacks)
walker.walk()
