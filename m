From: Joel Walberg <joel.walberg@gmail.com>
Subject: Re: debian9/raid1 assembly/unexpected failure opening device
Date: Thu, 31 Aug 2017 07:12:21 -0600
Message-ID: <CAGv-CEJfZZQfQKzwVRdgtkAy7PrAQFL8uKDADkAJZdyQn9NvnQ@mail.gmail.com>
References: <CAGv-CE+UwWraQpVF8hG+OBxj1B7Gwbh7tUcMq7hKz0MQ0NWd-w@mail.gmail.com>
 <CA+res+QAvW_WeULtzwVN8jyYvRgSt8bUFXbHDu5Fg9Wyo85_xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+QAvW_WeULtzwVN8jyYvRgSt8bUFXbHDu5Fg9Wyo85_xw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

root@jowahome:~# dmesg >before
root@jowahome:~# strace mdadm -A /dev/md2014 /dev/sdc1 /dev/sdb1
execve("/sbin/mdadm", ["mdadm", "-A", "/dev/md2014", "/dev/sdc1",
"/dev/sdb1"], [/* 15 vars */]) =3D 0
brk(NULL)                               =3D 0x55b9563e6000
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x7faf336f6000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D116207, ...}) =3D 0
mmap(NULL, 116207, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7faf336d9000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200\r\0\0\0\0\0\0".=
..,
832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D14640, ...}) =3D 0
mmap(NULL, 2109680, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x7faf332d2000
mprotect(0x7faf332d5000, 2093056, PROT_NONE) =3D 0
mmap(0x7faf334d4000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) =3D 0x7faf334d4000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) =3D 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\3\2\0\0\0\0\0".=
..,
832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D1689360, ...}) =3D 0
mmap(NULL, 3795360, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x7faf32f33000
mprotect(0x7faf330c8000, 2097152, PROT_NONE) =3D 0
mmap(0x7faf332c8000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x195000) =3D 0x7faf332c8000
mmap(0x7faf332ce000, 14752, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x7faf332ce000
close(3)                                =3D 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x7faf336d7000
arch_prctl(ARCH_SET_FS, 0x7faf336d7700) =3D 0
mprotect(0x7faf332c8000, 16384, PROT_READ) =3D 0
mprotect(0x7faf334d4000, 4096, PROT_READ) =3D 0
mprotect(0x55b9558df000, 4096, PROT_READ) =3D 0
mprotect(0x7faf336f9000, 4096, PROT_READ) =3D 0
munmap(0x7faf336d9000, 116207)          =3D 0
getpid()                                =3D 19817
brk(NULL)                               =3D 0x55b9563e6000
brk(0x55b956407000)                     =3D 0x55b956407000
open("/dev/md2014", O_RDWR)             =3D -1 ENOENT (No such file or dire=
ctory)
open("/etc/mdadm/mdadm.conf", O_RDONLY) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D662, ...}) =3D 0
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D662, ...}) =3D 0
read(3, "# mdadm.conf\n#\n# Please refer to"..., 4096) =3D 662
read(3, "", 4096)                       =3D 0
read(3, "", 4096)                       =3D 0
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D662, ...}) =3D 0
close(3)                                =3D 0
open("/etc/mdadm/mdadm.conf.d", O_RDONLY) =3D -1 ENOENT (No such file or
directory)
uname({sysname=3D"Linux", nodename=3D"jowahome", ...}) =3D 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D116207, ...}) =3D 0
mmap(NULL, 116207, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7faf336d9000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffdf2b634c0) =3D -1 ENOENT
(No such file or directory)
open("/lib/x86_64-linux-gnu/tls/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D
-1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/tls", 0x7ffdf2b634c0) =3D -1 ENOENT (No such
file or directory)
open("/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/x86_64", 0x7ffdf2b634c0) =3D -1 ENOENT (No
such file or directory)
open("/lib/x86_64-linux-gnu/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D -1
ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu", {st_mode=3DS_IFDIR|0755, st_size=3D12288, ...=
}) =3D 0
open("/usr/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffdf2b634c0) =3D -1
ENOENT (No such file or directory)
open("/usr/lib/x86_64-linux-gnu/tls/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/tls", 0x7ffdf2b634c0) =3D -1 ENOENT (No
such file or directory)
open("/usr/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/x86_64", 0x7ffdf2b634c0) =3D -1 ENOENT
(No such file or directory)
open("/usr/lib/x86_64-linux-gnu/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D
-1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu", {st_mode=3DS_IFDIR|0755,
st_size=3D90112, ...}) =3D 0
open("/lib/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT
(No such file or directory)
stat("/lib/tls/x86_64", 0x7ffdf2b634c0) =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/tls/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No
such file or directory)
stat("/lib/tls", 0x7ffdf2b634c0)        =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No
such file or directory)
stat("/lib/x86_64", 0x7ffdf2b634c0)     =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No such
file or directory)
stat("/lib", {st_mode=3DS_IFDIR|0755, st_size=3D4096, ...}) =3D 0
open("/usr/lib/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D -1
ENOENT (No such file or directory)
stat("/usr/lib/tls/x86_64", 0x7ffdf2b634c0) =3D -1 ENOENT (No such file
or directory)
open("/usr/lib/tls/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT
(No such file or directory)
stat("/usr/lib/tls", 0x7ffdf2b634c0)    =3D -1 ENOENT (No such file or dire=
ctory)
open("/usr/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT
(No such file or directory)
stat("/usr/lib/x86_64", 0x7ffdf2b634c0) =3D -1 ENOENT (No such file or dire=
ctory)
open("/usr/lib/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No
such file or directory)
stat("/usr/lib", {st_mode=3DS_IFDIR|0755, st_size=3D16384, ...}) =3D 0
munmap(0x7faf336d9000, 116207)          =3D 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D116207, ...}) =3D 0
mmap(NULL, 116207, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7faf336d9000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/x86_64-linux-gnu/libcmap.so.4", O_RDONLY|O_CLOEXEC) =3D -1
ENOENT (No such file or directory)
open("/usr/lib/x86_64-linux-gnu/libcmap.so.4", O_RDONLY|O_CLOEXEC) =3D
-1 ENOENT (No such file or directory)
open("/lib/libcmap.so.4", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No such
file or directory)
open("/usr/lib/libcmap.so.4", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No such
file or directory)
munmap(0x7faf336d9000, 116207)          =3D 0
geteuid()                               =3D 0
open("/dev/sdc1", O_RDONLY|O_DIRECT)    =3D 3
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, RAID_VERSION, 0x7ffdf2b63450)  =3D -1 ENOTTY (Inappropriate
ioctl for device)
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 3000591384576, SEEK_SET)       =3D 3000591384576
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
..,
4096) =3D 4096
ioctl(3, BLKSSZGET, [512])              =3D 0
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 3000591441920, SEEK_SET)       =3D 3000591441920
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
..,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 3000591446016
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 0, SEEK_SET)                   =3D 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
..,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 4096
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 4096, SEEK_SET)                =3D 4096
read(3, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0C\333\256\306[\26}\250\1\277#-\3=
02\30\353l"...,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 8192
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 4096, SEEK_SET)                =3D 4096
read(3, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0C\333\256\306[\26}\250\1\277#-\3=
02\30\353l"...,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 8192
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
ioctl(3, BLKPG, {BLKPG_DEL_PARTITION, flags=3D0, datalen=3D152,
data=3D{start=3D0, length=3D0, pno=3D1073741824, devname=3D"", volname=3D""=
}}) =3D
-1 EINVAL (Invalid argument)
ioctl(3, BLKPG, {BLKPG_DEL_PARTITION, flags=3D0, datalen=3D152,
data=3D{start=3D0, length=3D0, pno=3D1073741824, devname=3D"", volname=3D""=
}}) =3D
-1 EINVAL (Invalid argument)
lseek(3, 0, SEEK_SET)                   =3D 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
..,
512) =3D 512
lseek(3, 0, SEEK_SET)                   =3D 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
..,
512) =3D 512
ioctl(3, BLKSSZGET, [512])              =3D 0
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 3000591441920, SEEK_SET)       =3D 3000591441920
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
..,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 3000591446016
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 0, SEEK_SET)                   =3D 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
..,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 4096
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 4096, SEEK_SET)                =3D 4096
read(3, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0C\333\256\306[\26}\250\1\277#-\3=
02\30\353l"...,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 8192
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 4096, SEEK_SET)                =3D 4096
read(3, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0C\333\256\306[\26}\250\1\277#-\3=
02\30\353l"...,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 8192
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 33), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 4096, SEEK_SET)                =3D 4096
read(3, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0C\333\256\306[\26}\250\1\277#-\3=
02\30\353l"...,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 8192
close(3)                                =3D 0
open("/dev/sdc1", O_RDONLY|O_EXCL|O_DIRECT) =3D 3
close(3)                                =3D 0
stat("/sys/dev/block/8:33/partition", {st_mode=3DS_IFREG|0444,
st_size=3D4096, ...}) =3D 0
open("/dev/sdb1", O_RDONLY|O_DIRECT)    =3D 3
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 17), ...}) =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 17), ...}) =3D 0
ioctl(3, RAID_VERSION, 0x7ffdf2b63450)  =3D -1 ENOTTY (Inappropriate
ioctl for device)
ioctl(3, BLKSSZGET, [512])              =3D 0
fstat(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 17), ...}) =3D 0
ioctl(3, BLKGETSIZE64, [3000591450112]) =3D 0
lseek(3, 4096, SEEK_SET)                =3D 4096
read(3, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0C\333\256\306[\26}\250\1\277#-\3=
02\30\353l"...,
4096) =3D 4096
lseek(3, 0, SEEK_CUR)                   =3D 8192
close(3)                                =3D 0
open("/dev/sdb1", O_RDONLY|O_EXCL|O_DIRECT) =3D 3
close(3)                                =3D 0
stat("/sys/dev/block/8:17/partition", {st_mode=3DS_IFREG|0444,
st_size=3D4096, ...}) =3D 0
mkdir("/run/mdadm", 0755)               =3D -1 EEXIST (File exists)
open("/run/mdadm/map.lock", O_RDWR|O_CREAT|O_TRUNC, 0600) =3D 3
fcntl(3, F_GETFL)                       =3D 0x8002 (flags O_RDWR|O_LARGEFIL=
E)
flock(3, LOCK_EX)                       =3D 0
fstat(3, {st_mode=3DS_IFREG|0600, st_size=3D0, ...}) =3D 0
open("/run/mdadm/map", O_RDONLY)        =3D 4
fcntl(4, F_GETFL)                       =3D 0x8000 (flags O_RDONLY|O_LARGEF=
ILE)
fstat(4, {st_mode=3DS_IFREG|0600, st_size=3D0, ...}) =3D 0
read(4, "", 4096)                       =3D 0
close(4)                                =3D 0
open("/run/mdadm/map", O_RDONLY)        =3D 4
fcntl(4, F_GETFL)                       =3D 0x8000 (flags O_RDONLY|O_LARGEF=
ILE)
fstat(4, {st_mode=3DS_IFREG|0600, st_size=3D0, ...}) =3D 0
read(4, "", 4096)                       =3D 0
close(4)                                =3D 0
open("/proc/mdstat", O_RDONLY)          =3D 4
fcntl(4, F_SETFD, FD_CLOEXEC)           =3D 0
fstat(4, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
read(4, "Personalities : [linear] [multip"..., 1024) =3D 110
read(4, "", 1024)                       =3D 0
read(4, "", 1024)                       =3D 0
close(4)                                =3D 0
stat("/dev/.udev", 0x7ffdf2b631f0)      =3D -1 ENOENT (No such file or dire=
ctory)
stat("/run/udev", {st_mode=3DS_IFDIR|0755, st_size=3D220, ...}) =3D 0
open("/sys/block/md2014/dev", O_RDONLY) =3D -1 ENOENT (No such file or dire=
ctory)
getpid()                                =3D 19817
mknod("/dev/.tmp.md.19817:9:2014", S_IFBLK|0600, makedev(9, 2014)) =3D 0
open("/dev/.tmp.md.19817:9:2014", O_RDWR|O_EXCL|O_DIRECT) =3D -1 ENXIO
(No such device or address)
unlink("/dev/.tmp.md.19817:9:2014")     =3D 0
getpid()                                =3D 19817
mknod("/tmp/.tmp.md.19817:9:2014", S_IFBLK|0600, makedev(9, 2014)) =3D 0
open("/tmp/.tmp.md.19817:9:2014", O_RDWR|O_EXCL|O_DIRECT) =3D -1 ENXIO
(No such device or address)
unlink("/tmp/.tmp.md.19817:9:2014")     =3D 0
write(2, "mdadm: unexpected failure openin"..., 46mdadm: unexpected
failure opening /dev/md2014
) =3D 46
exit_group(1)                           =3D ?
+++ exited with 1 +++
root@jowahome:~# dmesg >after
root@jowahome:~# diff before after

On Thu, Aug 31, 2017 at 7:02 AM, Jack Wang <jack.wang.usish@gmail.com> wrot=
e:
> 2017-08-31 14:06 GMT+02:00 Joel Walberg <joel.walberg@gmail.com>:
>> ## If you have any ideas or suggestions, I would appreciate it.
>> ##
>> ## =3D=3Dissue=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## System has 3 hard drives, 1=3DOS, 2=3DRAID1 members
>> ## Prior OS: Debian 7
>> ## Installed Debian 9 on OS drive, unable to now get RAID1
>> assembled/started/missing special device files
>> ##
>> ## root@jowahome:~# mdadm -A /dev/md2014 /dev/sdc1 /dev/sdb1
>> ## mdadm: unexpected failure opening /dev/md2014
>> ## root@jowahome:~# mdadm -A /dev/md/md2014 /dev/sdc1 /dev/sdb1
>> ## mdadm: unexpected failure opening /dev/md2014
>> ##
> Can you do strace and share the output, also better share the dmesg
> when it happens?
> The metadata looks fine on both drives.
>
>
> Regards,
> Jack
>
>> ##
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## root@jowahome:~# mdadm -E -s
>> ## ARRAY /dev/md/md2014  metadata=3D1.2
>> UUID=3D43dbaec6:5b167da8:01bf232d:c218eb6c name=3Djowahome:md2014
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## root@jowahome:~# mdadm -E /dev/sdb1
>> ## /dev/sdb1:
>> ##           Magic : a92b4efc
>> ##         Version : 1.2
>> ##     Feature Map : 0x0
>> ##      Array UUID : 43dbaec6:5b167da8:01bf232d:c218eb6c
>> ##            Name : jowahome:md2014  (local to host jowahome)
>> ##   Creation Time : Thu Dec  4 17:44:01 2014
>> ##      Raid Level : raid1
>> ##    Raid Devices : 2
>> ##
>> ##  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>> ##      Array Size : 2930133824 (2794.39 GiB 3000.46 GB)
>> ##   Used Dev Size : 5860267648 (2794.39 GiB 3000.46 GB)
>> ##     Data Offset : 262144 sectors
>> ##    Super Offset : 8 sectors
>> ##    Unused Space : before=3D262064 sectors, after=3D384 sectors
>> ##           State : clean
>> ##     Device UUID : 3d78e679:e1ec930a:92f60635:3f8d79b5
>> ##
>> ##     Update Time : Wed Aug 30 10:01:33 2017
>> ##        Checksum : 83624b92 - correct
>> ##          Events : 48385
>> ##
>> ##
>> ##    Device Role : Active device 1
>> ##    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## root@jowahome:~# mdadm -E /dev/sdc1
>> ## /dev/sdc1:
>> ##           Magic : a92b4efc
>> ##         Version : 1.2
>> ##     Feature Map : 0x0
>> ##      Array UUID : 43dbaec6:5b167da8:01bf232d:c218eb6c
>> ##            Name : jowahome:md2014  (local to host jowahome)
>> ##   Creation Time : Thu Dec  4 17:44:01 2014
>> ##      Raid Level : raid1
>> ##    Raid Devices : 2
>> ##
>> ##  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>> ##      Array Size : 2930133824 (2794.39 GiB 3000.46 GB)
>> ##   Used Dev Size : 5860267648 (2794.39 GiB 3000.46 GB)
>> ##     Data Offset : 262144 sectors
>> ##    Super Offset : 8 sectors
>> ##    Unused Space : before=3D262064 sectors, after=3D384 sectors
>> ##           State : clean
>> ##     Device UUID : ffb6f0de:43aa75a9:3feb8c8e:b7c41993
>> ##
>> ##     Update Time : Wed Aug 30 10:01:33 2017
>> ##        Checksum : be7473da - correct
>> ##          Events : 48385
>> ##
>> ##
>> ##    Device Role : Active device 0
>> ##    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## root@jowahome:~# smartctl --xall /dev/sdb
>> ## smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-3-amd64] (local bui=
ld)
>> ## Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontoo=
ls.org
>> ##
>> ## =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>> ## Model Family:     Seagate Barracuda 7200.14 (AF)
>> ## Device Model:     ST3000DM001-1ER166
>> ## Serial Number:    Z5009M1W
>> ## LU WWN Device Id: 5 000c50 07903c6be
>> ## Firmware Version: CC43
>> ## User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>> ## Sector Sizes:     512 bytes logical, 4096 bytes physical
>> ## Rotation Rate:    7200 rpm
>> ## Form Factor:      3.5 inches
>> ## Device is:        In smartctl database [for details use: -P show]
>> ## ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
>> ## SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
>> ## Local Time is:    Thu Aug 31 05:31:38 2017 MDT
>> ## SMART support is: Available - device has SMART capability.
>> ## SMART support is: Enabled
>> ## AAM feature is:   Unavailable
>> ## APM level is:     254 (maximum performance)
>> ## Rd look-ahead is: Enabled
>> ## Write cache is:   Enabled
>> ## ATA Security is:  Disabled, frozen [SEC2]
>> ## Wt Cache Reorder: Unavailable
>> ##
>> ## =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
>> ## SMART overall-health self-assessment test result: PASSED
>> ##
>> ## General SMART Values:
>> ## Offline data collection status:  (0x82) Offline data collection activ=
ity
>> ##                                         was completed without error.
>> ##                                         Auto Offline Data
>> Collection: Enabled.
>> ## Self-test execution status:      (   0) The previous self-test
>> routine completed
>> ##                                         without error or no
>> self-test has ever
>> ##                                         been run.
>> ## Total time to complete Offline
>> ## data collection:                (   80) seconds.
>> ## Offline data collection
>> ## capabilities:                    (0x7b) SMART execute Offline immedia=
te.
>> ##                                         Auto Offline data
>> collection on/off support.
>> ##                                         Suspend Offline collection up=
on new
>> ##                                         command.
>> ##                                         Offline surface scan supporte=
d.
>> ##                                         Self-test supported.
>> ##                                         Conveyance Self-test supporte=
d.
>> ##                                         Selective Self-test supported=
.
>> ## SMART capabilities:            (0x0003) Saves SMART data before enter=
ing
>> ##                                         power-saving mode.
>> ##                                         Supports SMART auto save time=
r.
>> ## Error logging capability:        (0x01) Error logging supported.
>> ##                                         General Purpose Logging suppo=
rted.
>> ## Short self-test routine
>> ## recommended polling time:        (   1) minutes.
>> ## Extended self-test routine
>> ## recommended polling time:        ( 331) minutes.
>> ## Conveyance self-test routine
>> ## recommended polling time:        (   2) minutes.
>> ## SCT capabilities:              (0x1085) SCT Status supported.
>> ##
>> ## SMART Attributes Data Structure revision number: 10
>> ## Vendor Specific SMART Attributes with Thresholds:
>> ## ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>> ##   1 Raw_Read_Error_Rate     POSR--   118   099   006    -    18616555=
2
>> ##   3 Spin_Up_Time            PO----   094   092   000    -    0
>> ##   4 Start_Stop_Count        -O--CK   100   100   020    -    54
>> ##   5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
>> ##   7 Seek_Error_Rate         POSR--   070   060   030    -    10955017
>> ##   9 Power_On_Hours          -O--CK   075   075   000    -    22641
>> ##  10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>> ##  12 Power_Cycle_Count       -O--CK   100   100   020    -    54
>> ## 183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
>> ## 184 End-to-End_Error        -O--CK   100   100   099    -    0
>> ## 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
>> ## 188 Command_Timeout         -O--CK   100   100   000    -    0 0 0
>> ## 189 High_Fly_Writes         -O-RCK   088   088   000    -    12
>> ## 190 Airflow_Temperature_Cel -O---K   062   056   045    -    38
>> (Min/Max 37/42)
>> ## 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
>> ## 192 Power-Off_Retract_Count -O--CK   100   100   000    -    32
>> ## 193 Load_Cycle_Count        -O--CK   100   100   000    -    439
>> ## 194 Temperature_Celsius     -O---K   038   044   000    -    38 (0 15=
 0 0 0)
>> ## 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
>> ## 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
>> ## 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
>> ## 240 Head_Flying_Hours       ------   100   253   000    -
>> 20087h+17m+38.336s
>> ## 241 Total_LBAs_Written      ------   100   253   000    -    40747055=
745
>> ## 242 Total_LBAs_Read         ------   100   253   000    -    20838724=
2739
>> ##                             ||||||_ K auto-keep
>> ##                             |||||__ C event count
>> ##                             ||||___ R error rate
>> ##                             |||____ S speed/performance
>> ##                             ||_____ O updated online
>> ##                             |______ P prefailure warning
>> ##
>> ## General Purpose Log Directory Version 1
>> ## SMART           Log Directory Version 1 [multi-sector log support]
>> ## Address    Access  R/W   Size  Description
>> ## 0x00       GPL,SL  R/O      1  Log Directory
>> ## 0x01           SL  R/O      1  Summary SMART error log
>> ## 0x02           SL  R/O      5  Comprehensive SMART error log
>> ## 0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
>> ## 0x06           SL  R/O      1  SMART self-test log
>> ## 0x07       GPL     R/O      1  Extended self-test log
>> ## 0x09           SL  R/W      1  Selective self-test log
>> ## 0x10       GPL     R/O      1  SATA NCQ Queued Error log
>> ## 0x11       GPL     R/O      1  SATA Phy Event Counters log
>> ## 0x21       GPL     R/O      1  Write stream error log
>> ## 0x22       GPL     R/O      1  Read stream error log
>> ## 0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
>> ## 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
>> ## 0xa1       GPL,SL  VS      20  Device vendor specific log
>> ## 0xa2       GPL     VS    4496  Device vendor specific log
>> ## 0xa8       GPL,SL  VS     129  Device vendor specific log
>> ## 0xa9       GPL,SL  VS       1  Device vendor specific log
>> ## 0xab       GPL     VS       1  Device vendor specific log
>> ## 0xb0       GPL     VS    5176  Device vendor specific log
>> ## 0xbe-0xbf  GPL     VS   65535  Device vendor specific log
>> ## 0xc0       GPL,SL  VS       1  Device vendor specific log
>> ## 0xc1       GPL,SL  VS      10  Device vendor specific log
>> ## 0xc3       GPL,SL  VS       8  Device vendor specific log
>> ## 0xc4       GPL,SL  VS       5  Device vendor specific log
>> ## 0xe0       GPL,SL  R/W      1  SCT Command/Status
>> ## 0xe1       GPL,SL  R/W      1  SCT Data Transfer
>> ##
>> ## SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
>> ## No Errors Logged
>> ##
>> ## SMART Extended Self-test Log Version: 1 (1 sectors)
>> ## Num  Test_Description    Status                  Remaining
>> LifeTime(hours)  LBA_of_first_error
>> ## # 1  Short offline       Completed without error       00%
>> 21086         -
>> ##
>> ## SMART Selective self-test log data structure revision number 1
>> ##  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>> ##     1        0        0  Not_testing
>> ##     2        0        0  Not_testing
>> ##     3        0        0  Not_testing
>> ##     4        0        0  Not_testing
>> ##     5        0        0  Not_testing
>> ## Selective self-test flags (0x0):
>> ##   After scanning selected spans, do NOT read-scan remainder of disk.
>> ## If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>> ##
>> ## SCT Status Version:                  3
>> ## SCT Version (vendor specific):       522 (0x020a)
>> ## SCT Support Level:                   1
>> ## Device State:                        Active (0)
>> ## Current Temperature:                    38 Celsius
>> ## Power Cycle Min/Max Temperature:     37/41 Celsius
>> ## Lifetime    Min/Max Temperature:     15/44 Celsius
>> ## Under/Over Temperature Limit Count:   0/0
>> ##
>> ## SCT Data Table command not supported
>> ##
>> ## SCT Error Recovery Control command not supported
>> ##
>> ## Device Statistics (GP/SMART Log 0x04) not supported
>> ##
>> ## SATA Phy Event Counters (GP Log 0x11)
>> ## ID      Size     Value  Description
>> ## 0x000a  2           18  Device-to-host register FISes sent due to a C=
OMRESET
>> ## 0x0001  2            0  Command failed due to ICRC error
>> ## 0x0003  2            0  R_ERR response for device-to-host data FIS
>> ## 0x0004  2            0  R_ERR response for host-to-device data FIS
>> ## 0x0006  2            0  R_ERR response for device-to-host non-data FI=
S
>> ## 0x0007  2            0  R_ERR response for host-to-device non-data FI=
S
>> ##
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## root@jowahome:~# smartctl --xall /dev/sdc
>> ## smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-3-amd64] (local bui=
ld)
>> ## Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontoo=
ls.org
>> ##
>> ## =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>> ## Model Family:     Seagate Barracuda 7200.14 (AF)
>> ## Device Model:     ST3000DM001-1ER166
>> ## Serial Number:    Z5009W5Z
>> ## LU WWN Device Id: 5 000c50 079052344
>> ## Firmware Version: CC43
>> ## User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>> ## Sector Sizes:     512 bytes logical, 4096 bytes physical
>> ## Rotation Rate:    7200 rpm
>> ## Form Factor:      3.5 inches
>> ## Device is:        In smartctl database [for details use: -P show]
>> ## ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
>> ## SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
>> ## Local Time is:    Thu Aug 31 05:31:41 2017 MDT
>> ## SMART support is: Available - device has SMART capability.
>> ## SMART support is: Enabled
>> ## AAM feature is:   Unavailable
>> ## APM level is:     254 (maximum performance)
>> ## Rd look-ahead is: Enabled
>> ## Write cache is:   Enabled
>> ## ATA Security is:  Disabled, frozen [SEC2]
>> ## Wt Cache Reorder: Unavailable
>> ##
>> ## =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
>> ## SMART overall-health self-assessment test result: PASSED
>> ##
>> ## General SMART Values:
>> ## Offline data collection status:  (0x82) Offline data collection activ=
ity
>> ##                                         was completed without error.
>> ##                                         Auto Offline Data
>> Collection: Enabled.
>> ## Self-test execution status:      (   0) The previous self-test
>> routine completed
>> ##                                         without error or no
>> self-test has ever
>> ##                                         been run.
>> ## Total time to complete Offline
>> ## data collection:                (   89) seconds.
>> ## Offline data collection
>> ## capabilities:                    (0x7b) SMART execute Offline immedia=
te.
>> ##                                         Auto Offline data
>> collection on/off support.
>> ##                                         Suspend Offline collection up=
on new
>> ##                                         command.
>> ##                                         Offline surface scan supporte=
d.
>> ##                                         Self-test supported.
>> ##                                         Conveyance Self-test supporte=
d.
>> ##                                         Selective Self-test supported=
.
>> ## SMART capabilities:            (0x0003) Saves SMART data before enter=
ing
>> ##                                         power-saving mode.
>> ##                                         Supports SMART auto save time=
r.
>> ## Error logging capability:        (0x01) Error logging supported.
>> ##                                         General Purpose Logging suppo=
rted.
>> ## Short self-test routine
>> ## recommended polling time:        (   1) minutes.
>> ## Extended self-test routine
>> ## recommended polling time:        ( 332) minutes.
>> ## Conveyance self-test routine
>> ## recommended polling time:        (   2) minutes.
>> ## SCT capabilities:              (0x1085) SCT Status supported.
>> ##
>> ## SMART Attributes Data Structure revision number: 10
>> ## Vendor Specific SMART Attributes with Thresholds:
>> ## ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>> ##   1 Raw_Read_Error_Rate     POSR--   119   099   006    -    20503628=
0
>> ##   3 Spin_Up_Time            PO----   094   093   000    -    0
>> ##   4 Start_Stop_Count        -O--CK   100   100   020    -    59
>> ##   5 Reallocated_Sector_Ct   PO--CK   097   097   010    -    3344
>> ##   7 Seek_Error_Rate         POSR--   070   060   030    -    11270536
>> ##   9 Power_On_Hours          -O--CK   075   075   000    -    22632
>> ##  10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>> ##  12 Power_Cycle_Count       -O--CK   100   100   020    -    60
>> ## 183 Runtime_Bad_Block       -O--CK   098   098   000    -    2
>> ## 184 End-to-End_Error        -O--CK   100   100   099    -    0
>> ## 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
>> ## 188 Command_Timeout         -O--CK   100   098   000    -    5 5 5
>> ## 189 High_Fly_Writes         -O-RCK   099   099   000    -    1
>> ## 190 Airflow_Temperature_Cel -O---K   057   052   045    -    43
>> (Min/Max 42/46)
>> ## 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
>> ## 192 Power-Off_Retract_Count -O--CK   100   100   000    -    34
>> ## 193 Load_Cycle_Count        -O--CK   100   100   000    -    456
>> ## 194 Temperature_Celsius     -O---K   043   048   000    -    43 (0 15=
 0 0 0)
>> ## 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
>> ## 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
>> ## 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
>> ## 240 Head_Flying_Hours       ------   100   253   000    -
>> 20088h+20m+07.582s
>> ## 241 Total_LBAs_Written      ------   100   253   000    -    24949386=
363
>> ## 242 Total_LBAs_Read         ------   100   253   000    -    22651188=
8729
>> ##                             ||||||_ K auto-keep
>> ##                             |||||__ C event count
>> ##                             ||||___ R error rate
>> ##                             |||____ S speed/performance
>> ##                             ||_____ O updated online
>> ##                             |______ P prefailure warning
>> ##
>> ## General Purpose Log Directory Version 1
>> ## SMART           Log Directory Version 1 [multi-sector log support]
>> ## Address    Access  R/W   Size  Description
>> ## 0x00       GPL,SL  R/O      1  Log Directory
>> ## 0x01           SL  R/O      1  Summary SMART error log
>> ## 0x02           SL  R/O      5  Comprehensive SMART error log
>> ## 0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
>> ## 0x06           SL  R/O      1  SMART self-test log
>> ## 0x07       GPL     R/O      1  Extended self-test log
>> ## 0x09           SL  R/W      1  Selective self-test log
>> ## 0x10       GPL     R/O      1  SATA NCQ Queued Error log
>> ## 0x11       GPL     R/O      1  SATA Phy Event Counters log
>> ## 0x21       GPL     R/O      1  Write stream error log
>> ## 0x22       GPL     R/O      1  Read stream error log
>> ## 0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
>> ## 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
>> ## 0xa1       GPL,SL  VS      20  Device vendor specific log
>> ## 0xa2       GPL     VS    4496  Device vendor specific log
>> ## 0xa8       GPL,SL  VS     129  Device vendor specific log
>> ## 0xa9       GPL,SL  VS       1  Device vendor specific log
>> ## 0xab       GPL     VS       1  Device vendor specific log
>> ## 0xb0       GPL     VS    5176  Device vendor specific log
>> ## 0xbe-0xbf  GPL     VS   65535  Device vendor specific log
>> ## 0xc0       GPL,SL  VS       1  Device vendor specific log
>> ## 0xc1       GPL,SL  VS      10  Device vendor specific log
>> ## 0xc3       GPL,SL  VS       8  Device vendor specific log
>> ## 0xc4       GPL,SL  VS       5  Device vendor specific log
>> ## 0xe0       GPL,SL  R/W      1  SCT Command/Status
>> ## 0xe1       GPL,SL  R/W      1  SCT Data Transfer
>> ##
>> ## SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
>> ## No Errors Logged
>> ##
>> ## SMART Extended Self-test Log Version: 1 (1 sectors)
>> ## Num  Test_Description    Status                  Remaining
>> LifeTime(hours)  LBA_of_first_error
>> ## # 1  Short offline       Completed without error       00%
>> 21078         -
>> ##
>> ## SMART Selective self-test log data structure revision number 1
>> ##  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>> ##     1        0        0  Not_testing
>> ##     2        0        0  Not_testing
>> ##     3        0        0  Not_testing
>> ##     4        0        0  Not_testing
>> ##     5        0        0  Not_testing
>> ## Selective self-test flags (0x0):
>> ##   After scanning selected spans, do NOT read-scan remainder of disk.
>> ## If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>> ##
>> ## SCT Status Version:                  3
>> ## SCT Version (vendor specific):       522 (0x020a)
>> ## SCT Support Level:                   1
>> ## Device State:                        Active (0)
>> ## Current Temperature:                    42 Celsius
>> ## Power Cycle Min/Max Temperature:     42/46 Celsius
>> ## Lifetime    Min/Max Temperature:     15/48 Celsius
>> ## Under/Over Temperature Limit Count:   0/0
>> ##
>> ## SCT Data Table command not supported
>> ##
>> ## SCT Error Recovery Control command not supported
>> ##
>> ## Device Statistics (GP/SMART Log 0x04) not supported
>> ##
>> ## SATA Phy Event Counters (GP Log 0x11)
>> ## ID      Size     Value  Description
>> ## 0x000a  2           18  Device-to-host register FISes sent due to a C=
OMRESET
>> ## 0x0001  2            0  Command failed due to ICRC error
>> ## 0x0003  2            0  R_ERR response for device-to-host data FIS
>> ## 0x0004  2            0  R_ERR response for host-to-device data FIS
>> ## 0x0006  2            0  R_ERR response for device-to-host non-data FI=
S
>> ## 0x0007  2            0  R_ERR response for host-to-device non-data FI=
S
>> ##
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## root@jowahome:~# mdadm --examine /dev/sdb
>> ## /dev/sdb:
>> ##    MBR Magic : aa55
>> ## Partition[0] :   4294967295 sectors at            1 (type ee)
>> ##
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## root@jowahome:~# mdadm --examine /dev/sdc
>> ## /dev/sdc:
>> ##    MBR Magic : aa55
>> ## Partition[0] :   4294967295 sectors at            1 (type ee)
>> ##
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## root@jowahome:~/lsdrv# ./lsdrv
>> ## **Warning** The following utility(ies) failed to execute:
>> ##   sginfo
>> ## Some information may be missing.
>> ##
>> ## PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation 7
>> Series/C210 Series Chipset Family 4-port SATA Controller [IDE mode]
>> (rev 04)
>> ## =E2=94=9Cscsi 0:0:0:0 ATA      WDC WD20EARX-00P {WD-WCAZAA923311}
>> ## =E2=94=82=E2=94=94sda 1.82t [8:0] Partitioned (dos)
>> ## =E2=94=82 =E2=94=9Csda1 1.79t [8:1] ext4 {f714c162-9d48-48d1-9b25-34c=
7a36d0ae5}
>> ## =E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /
>> ## =E2=94=82 =E2=94=9Csda2 1.00k [8:2] Partitioned (dos)
>> ## =E2=94=82 =E2=94=94sda5 31.78g [8:5] swap {e3367b07-46bf-4903-871f-83=
f6b8d6d823}
>> ## =E2=94=9Cscsi 0:0:1:0 ATA      ST3000DM001-1ER1 {Z5009M1W}
>> ## =E2=94=82=E2=94=94sdb 2.73t [8:16] Partitioned (gpt)
>> ## =E2=94=82 =E2=94=94sdb1 2.73t [8:17] MD raid1 (2) inactive 'jowahome:=
md2014'
>> {43dbaec6-5b16-7da8-01bf-232dc218eb6c}
>> ## =E2=94=94scsi 1:0:1:0 ATA      ST3000DM001-1ER1 {Z5009W5Z}
>> ##  =E2=94=94sdc 2.73t [8:32] Partitioned (gpt)
>> ##   =E2=94=94sdc1 2.73t [8:33] MD raid1 (2) inactive 'jowahome:md2014'
>> {43dbaec6-5b16-7da8-01bf-232dc218eb6c}
>> ## PCI [ata_piix] 00:1f.5 IDE interface: Intel Corporation 7
>> Series/C210 Series Chipset Family 2-port SATA Controller [IDE mode]
>> (rev 04)
>> ## =E2=94=9Cscsi 2:x:x:x [Empty]
>> ## =E2=94=94scsi 3:0:0:0 ATAPI    DVD A  DH24ACSH  {2A8215504489}
>> ##  =E2=94=94sr0 1.00g [11:0] Empty/Unknown
>> ## USB [usb-storage] Bus 001 Device 003: ID 058f:6362 Alcor Micro
>> Corp. Flash Card Reader/Writer {058F63626420}
>> ## =E2=94=9Cscsi 4:0:0:0 Generic- SD/MMC
>> ## =E2=94=82=E2=94=94sdd 0.00k [8:48] Empty/Unknown
>> ## =E2=94=9Cscsi 4:0:0:1 Generic- Compact Flash
>> ## =E2=94=82=E2=94=94sde 0.00k [8:64] Empty/Unknown
>> ## =E2=94=9Cscsi 4:0:0:2 Generic- SM/xD Picture
>> ## =E2=94=82=E2=94=94sdf 0.00k [8:80] Empty/Unknown
>> ## =E2=94=94scsi 4:0:0:3 Generic- MS/MS-Pro
>> ##  =E2=94=94sdg 0.00k [8:96] Empty/Unknown
>> ##
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## root@jowahome:~/lsdrv# cat /proc/mdstat
>> ## Personalities : [linear] [multipath] [raid0] [raid1] [raid6]
>> [raid5] [raid4] [raid10]
>> ## unused devices: <none>
>> ##
>> ## =3D=3Doutput=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ## =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ##
>>
>>
>> --
>>
>> ___________________________
>> Joel A. Walberg
>> joel.walberg@gmail.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20

___________________________
Joel A. Walberg
joel.walberg@gmail.com
