From: Alessandro Bono <a.bono@libero.it>
Subject: Re: bugs in md.c
Date: Tue, 09 Sep 2003 11:22:17 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <pan.2003.09.09.09.22.15.38454@libero.it>
References: <pan.2003.09.08.21.01.07.571395@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After stoping /dev/md0 i tried to assemble updating summaries with mdadm
1.3 + patches but i receive a segmentation fault

mdadm compiled staticaly on a Debian stable (gcc 2.95) and unstable (gcc
3.3.2)

grignolino:/home/sandro# ./bin/mdadm --assemble --update=summaries /dev/md0 /dev/hdc3 /dev/hdd3
Segmentation fault
grignolino:/home/sandro# strace ./bin/mdadm --assemble --update=summaries /dev/md0 /dev/hdc3 /dev/hdd3
execve("./bin/mdadm", ["./bin/mdadm", "--assemble", "--update=summaries", "/dev/md0", "/dev/hdc3", "/dev/hdd3"], [/* 28 vars */]) = 0
fcntl64(0, F_GETFD)                     = 0
fcntl64(1, F_GETFD)                     = 0
fcntl64(2, F_GETFD)                     = 0
uname({sys="Linux", node="grignolino", ...}) = 0
geteuid32()                             = 0
getuid32()                              = 0
getegid32()                             = 0
getgid32()                              = 0
brk(0)                                  = 0x80c535c
brk(0x80c537c)                          = 0x80c537c
brk(0x80c6000)                          = 0x80c6000
open("/dev/md0", O_RDWR)                = 3
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
ioctl(3, 0x800c0910, 0xbffff788)        = 0
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
ioctl(3, 0x800c0910, 0xbfffd5e8)        = 0
uname({sys="Linux", node="grignolino", ...}) = 0
ioctl(3, 0x80480911, 0xbffff7ac)        = -1 ENODEV (No such device)
ioctl(3, 0x932, 0)                      = -1 ENODEV (No such device)
open("/dev/hdc3", O_RDONLY)             = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(22, 3), ...}) = 0
ioctl(4, BLKGETSIZE, 0xbfffd648)        = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 81402200064, [81402200064], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0Z\0\0\0\0\0\0\0\0\0\0\0\242\7\262\352"..., 4096) = 4096
close(4)                                = 0
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV +++


