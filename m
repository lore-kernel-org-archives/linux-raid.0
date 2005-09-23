From: Ming Zhang <mingz@ele.uri.edu>
Subject: mdadm core dump
Date: Fri, 23 Sep 2005 10:13:49 -0400
Message-ID: <1127484829.5546.38.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i did not read the mdadm code. but i suspect there is a pointer misuse
when there is no configuration file available.


ming

----------------------------------------------------
[root@localhost ~]# strace mdadm --assemble /dev/md0
execve("/sbin/mdadm", ["mdadm", "--assemble", "/dev/md0"], [/* 23 vars
*/]) = 0
uname({sys="Linux", node="localhost.localdomain", ...}) = 0
brk(0)                                  = 0x515000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
= 0x2aaaaaac0000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=112968, ...}) = 0
mmap(NULL, 112968, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2aaaaaac1000
close(3)                                = 0
open("/lib64/tls/libc.so.6", O_RDONLY)  = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\305\1\0"...,
640) = 640
lseek(3, 624, SEEK_SET)                 = 624
read(3, "\4\0\0\0\20\0\0\0\1\0\0\0GNU\0\0\0\0\0\2\0\0\0\4\0\0\0"..., 32)
= 32
fstat(3, {st_mode=S_IFREG|0755, st_size=1488892, ...}) = 0
mmap(NULL, 2305992, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x2aaaaabc1000
mprotect(0x2aaaaaceb000, 1085384, PROT_NONE) = 0
mmap(0x2aaaaadea000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_DENYWRITE, 3, 0x129000) = 0x2aaaaadea000
mmap(0x2aaaaadf0000, 16328, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_ANONYMOUS, -1, 0) = 0x2aaaaadf0000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
= 0x2aaaaadf4000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
= 0x2aaaaadf5000
mprotect(0x2aaaaadea000, 12288, PROT_READ) = 0
arch_prctl(ARCH_SET_FS, 0x2aaaaadf4b00) = 0
munmap(0x2aaaaaac1000, 112968)          = 0
brk(0)                                  = 0x515000
brk(0x536000)                           = 0x536000
open("/dev/md0", O_RDWR)                = 3
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
ioctl(3, 0x800c0910, 0x7fffff98a6c0)    = 0
open("/etc/mdadm.conf", O_RDONLY)       = -1 ENOENT (No such file or
directory)
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV +++

[root@localhost ~]# mdadm --version
mdadm - v1.6.0 - 4 June 2004



