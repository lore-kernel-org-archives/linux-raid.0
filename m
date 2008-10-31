From: Vladislav Konecny <vladislav.konecny@digmia.com>
Subject: Bug in mdadm 2.6.7
Date: Fri, 31 Oct 2008 14:41:53 +0100
Message-ID: <490B0B21.3090007@digmia.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090308060808050404020506"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090308060808050404020506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi there,

two days ago I was trying to grow my existing md raid5 array (with mdadm 
2.6.3 old version in ubuntu hardy). Everything goes well, but after one 
day in process of reshaping got power outage and must restart the 
reshaping process. I learned from some forums, that mdadm 2.6.3 have bug 
for restoring this process, and it's fixed in 2.6.4. So I download and 
make 2.6.4. With this version everything goes well, and reshaping 
process start again.

And now my problem: I do recent upgrade to new Ubuntu release (8.1) and 
system upgraded the mdadm package to 2.6.7. The version 2.6.7 gave me 
segmentation fault when I try to restore reshaping process.
I'm attaching strace of both 2.6.4 and 2.6.7.

oryon@server:~$ uname -a
Linux server 2.6.24-19-server #1 SMP Wed Aug 20 23:54:28 UTC 2008 i686 
GNU/Linux
oryon@server:~$ mdadm --version
mdadm - v2.6.7 - 6th June 2008
oryon@server:~$ /home/oryon/mdadm-2.6.4/mdadm --version
mdadm - v2.6.4 - 19th October 2007

I think the problem is only in 2.6.7. If it's needed, I can try this 
also in 2.6.5 or 2.6.6.

Best,

Vladislav

--------------090308060808050404020506
Content-Type: text/plain;
 name="strace-mdadm-2.6.4.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="strace-mdadm-2.6.4.txt"

oryon@server:~$ sudo strace /home/oryon/mdadm-2.6.4/mdadm -Af /dev/md1 /dev/sd[a-e]5
execve("/home/oryon/mdadm-2.6.4/mdadm", ["/home/oryon/mdadm-2.6.4/mdadm", "-Af", "/dev/md1", "/dev/sda5", "/dev/sdb5", "/dev/sdc5", "/dev/sdd5", "/dev/sde5"], [/* 14 vars */]) = 0
brk(0)                                  = 0x807c000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f7b000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=29525, ...}) = 0
mmap2(NULL, 29525, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f73000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\340g\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1425800, ...}) = 0
mmap2(NULL, 1431152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e15000
mmap2(0xb7f6d000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x158) = 0xb7f6d000
mmap2(0xb7f70000, 9840, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f70000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e14000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7e146b0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7f6d000, 8192, PROT_READ)   = 0
mprotect(0xb7f98000, 4096, PROT_READ)   = 0
munmap(0xb7f73000, 29525)               = 0
time(NULL)                              = 1225459840
getpid()                                = 5285
brk(0)                                  = 0x807c000
brk(0x809d000)                          = 0x809d000
open("/etc/mdadm.conf", O_RDONLY)       = -1 ENOENT (No such file or directory)
open("/etc/mdadm/mdadm.conf", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=896, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f7a000
read(3, "# mdadm.conf\n#\n# Please refer to"..., 4096) = 896
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
open("/etc/nsswitch.conf", O_RDONLY)    = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=475, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f79000
read(4, "# /etc/nsswitch.conf\n#\n# Example"..., 4096) = 475
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0xb7f79000, 4096)                = 0
open("/etc/ld.so.cache", O_RDONLY)      = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=29525, ...}) = 0
mmap2(NULL, 29525, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7e0c000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_compat.so.2", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\16\0"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=30436, ...}) = 0
mmap2(NULL, 33356, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7e03000
mmap2(0xb7e0a000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x6) = 0xb7e0a000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnsl.so.1", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\00001\0\000"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=87804, ...}) = 0
mmap2(NULL, 100328, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7dea000
mmap2(0xb7dff000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x14) = 0xb7dff000
mmap2(0xb7e01000, 6120, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7e01000
close(4)                                = 0
mprotect(0xb7dff000, 4096, PROT_READ)   = 0
mprotect(0xb7e0a000, 4096, PROT_READ)   = 0
munmap(0xb7e0c000, 29525)               = 0
open("/etc/ld.so.cache", O_RDONLY)      = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=29525, ...}) = 0
mmap2(NULL, 29525, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7e0c000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_nis.so.2", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\31\0"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=38448, ...}) = 0
mmap2(NULL, 41532, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7ddf000
mmap2(0xb7de8000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x8) = 0xb7de8000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_files.so.2", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\30"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=42508, ...}) = 0
mmap2(NULL, 45720, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7dd3000
mmap2(0xb7ddd000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x9) = 0xb7ddd000
close(4)                                = 0
mprotect(0xb7ddd000, 4096, PROT_READ)   = 0
mprotect(0xb7de8000, 4096, PROT_READ)   = 0
munmap(0xb7e0c000, 29525)               = 0
open("/etc/passwd", O_RDONLY|0x80000 /* O_??? */) = 4
fcntl64(4, F_GETFD)                     = 0x1 (flags FD_CLOEXEC)
_llseek(4, 0, [0], SEEK_CUR)            = 0
fstat64(4, {st_mode=S_IFREG|0644, st_size=1106, ...}) = 0
mmap2(NULL, 1106, PROT_READ, MAP_SHARED, 4, 0) = 0xb7f79000
_llseek(4, 1106, [1106], SEEK_SET)      = 0
munmap(0xb7f79000, 1106)                = 0
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
open("/etc/group", O_RDONLY|0x80000 /* O_??? */) = 4
_llseek(4, 0, [0], SEEK_CUR)            = 0
fstat64(4, {st_mode=S_IFREG|0644, st_size=779, ...}) = 0
mmap2(NULL, 779, PROT_READ, MAP_SHARED, 4, 0) = 0xb7f79000
_llseek(4, 779, [779], SEEK_SET)        = 0
munmap(0xb7f79000, 779)                 = 0
close(4)                                = 0
read(3, "", 4096)                       = 0
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb7f7a000, 4096)                = 0
stat64("/dev/md1", {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 1), ...}) = 0
open("/dev/md1", O_RDWR)                = 3
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 1), ...}) = 0
ioctl(3, 0x800c0910, 0xbf8659fc)        = 0
uname({sys="Linux", node="server", ...}) = 0
uname({sys="Linux", node="server", ...}) = 0
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 1), ...}) = 0
ioctl(3, 0x800c0910, 0xbf86575c)        = 0
ioctl(3, 0x80480911, 0xbf8659e0)        = -1 ENODEV (No such device)
ioctl(3, 0x932, 0)                      = 0
open("/dev/sda5", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf8655d8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
ioctl(4, BLKGETSIZE64, 0xbf865508)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995914240, [987995914240], SEEK_SET) = 0
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
ioctl(4, BLKGETSIZE64, 0xbf865508)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
ioctl(4, BLKGETSIZE64, 0xbf865508)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 4096, [4096], SEEK_SET)      = 0
read(4, "\21$8\3 LVM2 x[5A%r0N*>\1\0\0\0\0\20\0\0\0\0\0\0"..., 1024) = 1024
ioctl(4, BLKGETSIZE64, 0xbf8655d8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
open("/dev/sdb5", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 21), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
open("/dev/sdc5", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 37), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
open("/dev/sdd5", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 53), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
open("/dev/sde5", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 69), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
open("/dev/sda5", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
stat64("/dev/sda5", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
open("/dev/sdb5", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
stat64("/dev/sdb5", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 21), ...}) = 0
open("/dev/sdc5", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
stat64("/dev/sdc5", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 37), ...}) = 0
open("/dev/sdd5", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
stat64("/dev/sdd5", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 53), ...}) = 0
open("/dev/sde5", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf8656c0)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
stat64("/dev/sde5", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 69), ...}) = 0
open("/dev/sda5", O_RDONLY|O_EXCL)      = 4
ioctl(4, BLKGETSIZE64, 0xbf8656e8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
open("/dev/sda5", O_RDWR|O_EXCL)        = 4
open("/dev/sdb5", O_RDWR|O_EXCL)        = 5
open("/dev/sdc5", O_RDWR|O_EXCL)        = 6
open("/dev/sdd5", O_RDWR|O_EXCL)        = 7
open("/dev/sde5", O_RDWR|O_EXCL)        = 8
ioctl(8, BLKGETSIZE64, 0xbf8644d8)      = 0
ioctl(8, BLKFLSBUF, 0)                  = 0
_llseek(8, 987995832320, [987995832320], SEEK_SET) = 0
read(8, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
_llseek(8, 987995828224, [987995828224], SEEK_SET) = 0
read(8, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 68) = 68
close(8)                                = 0
close(7)                                = 0
close(6)                                = 0
close(5)                                = 0
close(4)                                = 0
ioctl(3, 0x40480923, 0xbf865898)        = 0
ioctl(3, 0x40140921, 0xbf865898)        = 0
ioctl(3, 0x40140921, 0xbf865898)        = 0
ioctl(3, 0x40140921, 0xbf865898)        = 0
ioctl(3, 0x40140921, 0xbf865898)        = 0
ioctl(3, 0x40140921, 0xbf865898)        = 0
ioctl(3, 0x400c0930, 0)                 = 0
write(2, "mdadm: /dev/md1 has been started"..., 46mdadm: /dev/md1 has been started with 4 drives) = 46
write(2, " (out of 5)", 11 (out of 5))             = 11
write(2, " and 1 spare", 12 and 1 spare)            = 12
write(2, ".\n", 2.
)                      = 2
exit_group(0)                           = ?
Process 5285 detached


--------------090308060808050404020506
Content-Type: text/plain;
 name="strace-mdadm-2.6.7.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="strace-mdadm-2.6.7.txt"

oryon@server:~$ sudo strace mdadm -Af /dev/md1 /dev/sd[a-e]5
[sudo] password for oryon: 
execve("/sbin/mdadm", ["mdadm", "-Af", "/dev/md1", "/dev/sda5", "/dev/sdb5", "/dev/sdc5", "/dev/sdd5", "/dev/sde5"], [/* 14 vars */]) = 0
brk(0)                                  = 0x807a000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f59000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=29525, ...}) = 0
mmap2(NULL, 29525, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f51000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\340g\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1425800, ...}) = 0
mmap2(NULL, 1431152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7df3000
mmap2(0xb7f4b000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x158) = 0xb7f4b000
mmap2(0xb7f4e000, 9840, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f4e000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7df2000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7df28c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7f4b000, 8192, PROT_READ)   = 0
mprotect(0x8074000, 4096, PROT_READ)    = 0
mprotect(0xb7f76000, 4096, PROT_READ)   = 0
munmap(0xb7f51000, 29525)               = 0
time(NULL)                              = 1225459731
getpid()                                = 5227
brk(0)                                  = 0x807a000
brk(0x809b000)                          = 0x809b000
open("/etc/mdadm/mdadm.conf", O_RDONLY|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=896, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f58000
read(3, "# mdadm.conf\n#\n# Please refer to"..., 4096) = 896
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
open("/etc/nsswitch.conf", O_RDONLY)    = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=475, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f57000
read(4, "# /etc/nsswitch.conf\n#\n# Example"..., 4096) = 475
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0xb7f57000, 4096)                = 0
open("/etc/ld.so.cache", O_RDONLY)      = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=29525, ...}) = 0
mmap2(NULL, 29525, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7dea000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_compat.so.2", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\16\0"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=30436, ...}) = 0
mmap2(NULL, 33356, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7de1000
mmap2(0xb7de8000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x6) = 0xb7de8000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnsl.so.1", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\00001\0\000"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=87804, ...}) = 0
mmap2(NULL, 100328, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7dc8000
mmap2(0xb7ddd000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x14) = 0xb7ddd000
mmap2(0xb7ddf000, 6120, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ddf000
close(4)                                = 0
mprotect(0xb7ddd000, 4096, PROT_READ)   = 0
mprotect(0xb7de8000, 4096, PROT_READ)   = 0
munmap(0xb7dea000, 29525)               = 0
open("/etc/ld.so.cache", O_RDONLY)      = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=29525, ...}) = 0
mmap2(NULL, 29525, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7dea000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_nis.so.2", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\31\0"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=38448, ...}) = 0
mmap2(NULL, 41532, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7dbd000
mmap2(0xb7dc6000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x8) = 0xb7dc6000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_files.so.2", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\30"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=42508, ...}) = 0
mmap2(NULL, 45720, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7db1000
mmap2(0xb7dbb000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x9) = 0xb7dbb000
close(4)                                = 0
mprotect(0xb7dbb000, 4096, PROT_READ)   = 0
mprotect(0xb7dc6000, 4096, PROT_READ)   = 0
munmap(0xb7dea000, 29525)               = 0
open("/etc/passwd", O_RDONLY|0x80000 /* O_??? */) = 4
fcntl64(4, F_GETFD)                     = 0x1 (flags FD_CLOEXEC)
_llseek(4, 0, [0], SEEK_CUR)            = 0
fstat64(4, {st_mode=S_IFREG|0644, st_size=1106, ...}) = 0
mmap2(NULL, 1106, PROT_READ, MAP_SHARED, 4, 0) = 0xb7f57000
_llseek(4, 1106, [1106], SEEK_SET)      = 0
munmap(0xb7f57000, 1106)                = 0
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
open("/etc/group", O_RDONLY|0x80000 /* O_??? */) = 4
_llseek(4, 0, [0], SEEK_CUR)            = 0
fstat64(4, {st_mode=S_IFREG|0644, st_size=779, ...}) = 0
mmap2(NULL, 779, PROT_READ, MAP_SHARED, 4, 0) = 0xb7f57000
_llseek(4, 779, [779], SEEK_SET)        = 0
munmap(0xb7f57000, 779)                 = 0
close(4)                                = 0
read(3, "", 4096)                       = 0
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb7f58000, 4096)                = 0
stat64("/dev/md1", {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 1), ...}) = 0
open("/dev/md1", O_RDWR|O_LARGEFILE)    = 3
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 1), ...}) = 0
ioctl(3, 0x800c0910, 0xbfe49268)        = 0
uname({sys="Linux", node="server", ...}) = 0
uname({sys="Linux", node="server", ...}) = 0
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 1), ...}) = 0
ioctl(3, 0x800c0910, 0xbfe48fb8)        = 0
ioctl(3, 0x80480911, 0xbfe491e0)        = -1 ENODEV (No such device)
ioctl(3, 0x932, 0)                      = 0
open("/dev/sda5", O_RDONLY|O_EXCL|O_LARGEFILE) = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbfe48e00)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbfe48d70)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995914240, [987995914240], SEEK_SET) = 0
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbfe48d70)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbfe48d70)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 4096, [4096], SEEK_SET)      = 0
read(4, "\21$8\3 LVM2 x[5A%r0N*>\1\0\0\0\0\20\0\0\0\0\0\0"..., 1024) = 1024
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbfe48e00)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbfe48f60)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 987995832320, [987995832320], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\332\201\224|"..., 4096) = 4096
close(4)                                = 0
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV +++
Process 5227 detached


--------------090308060808050404020506--
