From: Tom Dickson <tdickson@inostor.com>
Subject: mkraid segfaults if /etc/mtab does not exist
Date: Fri, 16 Jul 2004 16:20:33 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40F862C1.10705@inostor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

If you don't have /etc/mtab, mkraid segfaults.

mkraid -V
mkraid version 0.90.0
[root@builder raidtools-1.00.2]#

./strace /sbin/mkraid --configfile raidtab_9 /dev/md1
execve("/sbin/mkraid", ["/sbin/mkraid", "--configfile", "raidtab_9",
"/dev/md1"], [/* 20 vars */]) = 0
uname({sys="Linux", node="install", ...}) = 0
brk(0)                                  = 0x8058ef8
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=12992, ...}) = 0
old_mmap(NULL, 12992, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40014000
close(3)                                = 0
open("/lib/i686/libc.so.6", O_RDONLY)   = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`u\1B4\0"...,
1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=1401027, ...}) = 0
old_mmap(0x42000000, 1264928, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) =
0x42000000
mprotect(0x4212c000, 36128, PROT_NONE)  = 0
old_mmap(0x4212c000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED,
3, 0x12c000) = 0x4212c000
old_mmap(0x42131000, 15648, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x42131000
close(3)                                = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
- -1, 0) = 0x40018000
munmap(0x40014000, 12992)               = 0
brk(0)                                  = 0x8058ef8
brk(0x8058f28)                          = 0x8058f28
brk(0x8059000)                          = 0x8059000
brk(0x805a000)                          = 0x805a000
open("/dev/md0", O_RDONLY)              = 3
ioctl(3, 0x800c0910, 0x8058ec0)         = 0
close(3)                                = 0
open("raidtab_9", O_RDONLY)             = 3
time(NULL)                              = 1090019986
fstat64(3, {st_mode=S_IFREG|0664, st_size=6377, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x40014000
read(3, "raiddev /dev/md0\n      raid-leve"..., 4096) = 4096
brk(0x805b000)                          = 0x805b000
read(3, "   chunk-size              4096\n"..., 4096) = 2281
brk(0x805c000)                          = 0x805c000
read(3, "", 4096)                       = 0
open("/dev/md0", O_RDONLY)              = 4
ioctl(4, 0x800c0910, 0xbffffaa0)        = 0
close(4)                                = 0
open("/proc/mdstat", O_RDONLY)          = 4
fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x40015000
read(4, "Personalities : [raid1] \nread_ah"..., 1024) = 208
read(4, "", 1024)                       = 0
close(4)                                = 0
munmap(0x40015000, 4096)                = 0
open("/proc/mdstat", O_RDONLY)          = 4
fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x40015000
read(4, "Personalities : [raid1] \nread_ah"..., 1024) = 208
read(4, "", 1024)                       = 0
close(4)                                = 0
munmap(0x40015000, 4096)                = 0
stat64("/dev/md1", {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 1), ...}) = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(3, 0), ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE, {B38400 opost isig icanon echo ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x40015000
write(1, "handling MD device /dev/md1\n", 28handling MD device /dev/md1
) = 28
write(1, "analyzing super-block\n", 22analyzing super-block
) = 22
time(NULL)                              = 1090019986
stat64("/dev/sda2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 2), ...}) = 0
stat64("/dev/sdb2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 18), ...}) = 0
stat64("/dev/sdc2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 34), ...}) = 0
stat64("/dev/sdd2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 50), ...}) = 0
stat64("/dev/sde2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 66), ...}) = 0
stat64("/dev/sdf2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 82), ...}) = 0
stat64("/dev/sdg2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 98), ...}) = 0
stat64("/dev/sdh2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 114),
...}) = 0
stat64("/dev/sdi2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 130),
...}) = 0
open("/dev/sda2", O_RDWR)               = 4
ioctl(4, BLKGETSIZE, 0xbffff74c)        = 0
write(1, "disk 0: /dev/sda2, 409600kB, rai"..., 57disk 0: /dev/sda2,
409600kB, raid superblock at 409536kB
) = 57
open("/etc/mtab", O_RDONLY)             = -1 ENOENT (No such file or
directory)
brk(0x805e000)                          = 0x805e000
- --- SIGSEGV (Segmentation fault) ---
+++ killed by SIGSEGV +++


- -Tom
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFA+GLB2dxAfYNwANIRAhZ6AJ0d1gkf/MOYibe00FG6S8TzU0pBhACfXulo
sSA82YqB5/gLYOtNvC8B7w8=
=SZJY
-----END PGP SIGNATURE-----
