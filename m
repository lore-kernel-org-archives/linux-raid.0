From: Piotr Karbowski <piotr.karbowski@gmail.com>
Subject: mdadm --assemble --scan always fail if bulit with uClibc.
Date: Mon, 27 Feb 2012 12:47:42 +0100
Message-ID: <4F4B6D5E.6040409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there.

There is a weird mdadm problem if build with uClibc. The 'mdadm 
--assemble --scan' always fail with messages about missing superblock 
whatever it is 3.2.3 or latest git code. However exact the same sources 
bulit with glibc does work. In this testcase I am using raid1 array with 
/dev/vdb member and 2nd one marked as missing.

It is 100% reproducable, I am using Aboriginal Linux's root-filesystem 
images (images with bash2, busybox, uclibc and gcc) from 
http://landley.net/code/aboriginal/bin/

heres how it looks like in my initramfs:

remote rescueshell ~ # mdadm --assemble --scan
mdadm: failed to add 252:16 to /dev/md/2: Invalid argument
mdadm: /dev/md/2 assembled from 0 drives - not enough to start the array.
remote rescueshell ~ # mdadm --assemble --scan --verbose
mdadm: looking for devices for /dev/md/2
mdadm: no RAID superblock on 252:3
mdadm: no RAID superblock on 252:2
mdadm: no RAID superblock on 252:1
mdadm: no RAID superblock on 252:0
mdadm: 252:16 is identified as a member of /dev/md/2, slot 0.
mdadm: no uptodate device for slot 1 of /dev/md/2
mdadm: failed to add 252:16 to /dev/md/2: Invalid argument
mdadm: /dev/md/2 assembled from 0 drives - not enough to start the array.


But I can do 'mdadm --assemble /dev/md2 /dev/vdb' it does work, the 
working /dev/md2 is created.


The kernel logs after '--assemble --scan':
md: md2 stopped.
md: vda does not have a valid v1.2 superblock, not importing!
md: md_import_device returned -22

I tried amd64 and i686 binaries (I found a note in Makefile that 
mdadm.udlibc does not work on x86_64), mdassamble print exact the same 
error like mdadm. Also I tried with /dev as devtmpfs and with 
mdev-created nodes on tmpfs mountpoint.

The strace:

### STRACE:
execve("/bin/mdadm", ["/bin/mdadm", "--assemble", "--scan"], [/* 10 vars 
*/]) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo 
...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3dca0) = -1 ENOTTY 
(Inappropriate ioctl for device)
time(NULL)                              = 1330341443
getpid()                                = 872
brk(0)                                  = 0x80e6200
brk(0x80e7200)                          = 0x80e7200
brk(0x80e8000)                          = 0x80e8000
open("/etc/mdadm.conf", O_RDONLY|O_LARGEFILE) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3d640) = -1 ENOTTY 
(Inappropriate ioctl for device)
read(3, "ARRAY /dev/md/2 metadata=1.2 UUI"..., 4096) = 87
read(3, "", 4096)                       = 0
close(3)                                = 0
uname({sys="Linux", node="(none)", ...}) = 0
geteuid32()                             = 0
open("/proc/partitions", O_RDONLY|O_LARGEFILE) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3d1e0) = -1 ENOTTY 
(Inappropriate ioctl for device)
read(3, "major minor  #blocks  name\n\n 252"..., 4096) = 176
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
read(3, "", 4096)                       = 0
close(3)                                = 0
open("/proc/mdstat", O_RDONLY|O_LARGEFILE) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3d580) = -1 ENOTTY 
(Inappropriate ioctl for device)
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
read(3, "Personalities : [raid1] \nunused "..., 4096) = 48
read(3, "", 4096)                       = 0
dup(3)                                  = 4
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
close(3)                                = 0
mkdir("/dev/.mdadm", 0755)              = -1 EEXIST (File exists)
open("/dev/.mdadm/map.lock", O_RDWR|O_CREAT|O_TRUNC|O_LARGEFILE, 0600) = 3
fcntl(3, F_GETFL)                       = 0x8002 (flags O_RDWR|O_LARGEFILE)
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3d5d0) = -1 ENOTTY 
(Inappropriate ioctl for device)
flock(3, LOCK_EX)                       = 0
fstat64(3, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
open("/dev/.mdadm/map", O_RDONLY|O_LARGEFILE) = 5
fcntl(5, F_GETFL)                       = 0x8000 (flags 
O_RDONLY|O_LARGEFILE)
ioctl(5, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3b480) = -1 ENOTTY 
(Inappropriate ioctl for device)
brk(0x80e9000)                          = 0x80e9000
read(5, "md2 1.2 00196000:bb52dbaa:8dfe7c"..., 4096) = 54
read(5, "", 4096)                       = 0
close(5)                                = 0
uname({sys="Linux", node="(none)", ...}) = 0
open("/proc/partitions", O_RDONLY|O_LARGEFILE) = 5
ioctl(5, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3c990) = -1 ENOTTY 
(Inappropriate ioctl for device)
read(5, "major minor  #blocks  name\n\n 252"..., 4096) = 176
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
read(5, "", 4096)                       = 0
close(5)                                = 0
_llseek(4, 0, [0], SEEK_SET)            = 0
dup(4)                                  = 5
fcntl(5, F_GETFL)                       = 0x8000 (flags 
O_RDONLY|O_LARGEFILE)
ioctl(5, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3cd30) = -1 ENOTTY 
(Inappropriate ioctl for device)
fcntl64(5, F_SETFD, FD_CLOEXEC)         = 0
read(5, "Personalities : [raid1] \nunused "..., 4096) = 48
read(5, "", 4096)                       = 0
close(5)                                = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
getpid()                                = 872
mknod("/dev/.tmp.md.872:252:16", S_IFBLK|0600, makedev(252, 16)) = 0
open("/dev/.tmp.md.872:252:16", O_RDONLY|O_EXCL|O_DIRECT|O_LARGEFILE) = 5
unlink("/dev/.tmp.md.872:252:16")       = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 16), ...}) = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 16), ...}) = 0
ioctl(5, 0x800c0910, 0xbfd3ce8c)        = -1 ENOTTY (Inappropriate ioctl 
for device)
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 16), ...}) = 0
ioctl(5, BLKGETSIZE64, 0xbfd3ce50)      = 0
ioctl(5, BLKFLSBUF, 0)                  = 0
_llseek(5, 4096, [4096], SEEK_SET)      = 0
ioctl(5, BLKSSZGET, 0xbfd3ce4c)         = 0
read(5, 
"\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\0`\31\0\252\333R\273Z|\376\215\32\177\336\265"..., 
1024) = 1024
close(5)                                = 0
stat64("/sys/dev/block/252:16/partition", 0xbfd3cc68) = -1 ENOENT (No 
such file or directory)
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
getpid()                                = 872
mknod("/dev/.tmp.md.872:252:3", S_IFBLK|0600, makedev(252, 3)) = 0
open("/dev/.tmp.md.872:252:3", O_RDONLY|O_EXCL|O_DIRECT|O_LARGEFILE) = 5
unlink("/dev/.tmp.md.872:252:3")        = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 3), ...}) = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 3), ...}) = 0
ioctl(5, 0x800c0910, 0xbfd3ce8c)        = -1 ENOTTY (Inappropriate ioctl 
for device)
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 3), ...}) = 0
ioctl(5, BLKGETSIZE64, 0xbfd3ce50)      = 0
ioctl(5, BLKFLSBUF, 0)                  = 0
_llseek(5, 4096, [4096], SEEK_SET)      = 0
ioctl(5, BLKSSZGET, 0xbfd3ce4c)         = 0
read(5, 
"\1\0\10\0\21\0\10\0!\0\10\0\332\2\275\1;\2\4\0\0\0\0\0\0\0\0\0\274\1>+"..., 
1024) = 1024
close(5)                                = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
getpid()                                = 872
mknod("/dev/.tmp.md.872:252:2", S_IFBLK|0600, makedev(252, 2)) = 0
open("/dev/.tmp.md.872:252:2", O_RDONLY|O_EXCL|O_DIRECT|O_LARGEFILE) = 5
unlink("/dev/.tmp.md.872:252:2")        = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 2), ...}) = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 2), ...}) = 0
ioctl(5, 0x800c0910, 0xbfd3ce8c)        = -1 ENOTTY (Inappropriate ioctl 
for device)
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 2), ...}) = 0
ioctl(5, BLKGETSIZE64, 0xbfd3ce50)      = 0
ioctl(5, BLKFLSBUF, 0)                  = 0
_llseek(5, 4096, [4096], SEEK_SET)      = 0
ioctl(5, BLKSSZGET, 0xbfd3ce4c)         = 0
read(5, "\306=\0\0\22\0\0\0\0 
\0\0\0\0\0\0\0pG\1\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
close(5)                                = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
getpid()                                = 872
mknod("/dev/.tmp.md.872:252:1", S_IFBLK|0600, makedev(252, 1)) = 0
open("/dev/.tmp.md.872:252:1", O_RDONLY|O_EXCL|O_DIRECT|O_LARGEFILE) = 5
unlink("/dev/.tmp.md.872:252:1")        = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 1), ...}) = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 1), ...}) = 0
ioctl(5, 0x800c0910, 0xbfd3ce8c)        = -1 ENOTTY (Inappropriate ioctl 
for device)
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 1), ...}) = 0
ioctl(5, BLKGETSIZE64, 0xbfd3ce50)      = 0
ioctl(5, BLKFLSBUF, 0)                  = 0
_llseek(5, 4096, [4096], SEEK_SET)      = 0
ioctl(5, BLKSSZGET, 0xbfd3ce4c)         = 0
read(5, "\4 \0\0\4`\0\0\4\240\0\0\4\340\0\0\4 
\1\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
close(5)                                = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
getpid()                                = 872
mknod("/dev/.tmp.md.872:252:0", S_IFBLK|0600, makedev(252, 0)) = 0
open("/dev/.tmp.md.872:252:0", O_RDONLY|O_EXCL|O_DIRECT|O_LARGEFILE) = 5
unlink("/dev/.tmp.md.872:252:0")        = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 0), ...}) = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 0), ...}) = 0
ioctl(5, 0x800c0910, 0xbfd3ce8c)        = -1 ENOTTY (Inappropriate ioctl 
for device)
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 0), ...}) = 0
ioctl(5, BLKGETSIZE64, 0xbfd3ce50)      = 0
ioctl(5, BLKFLSBUF, 0)                  = 0
_llseek(5, 4096, [4096], SEEK_SET)      = 0
ioctl(5, BLKSSZGET, 0xbfd3ce4c)         = 0
read(5, 
"\0\213E\f%\0\377\0\0=\0\377\0\0t&\213E\f%\0\0\377\0=\0\0\377\0\17\204\6"..., 
1024) = 1024
close(5)                                = 0
open("/proc/mdstat", O_RDONLY|O_LARGEFILE) = 5
ioctl(5, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3c9e0) = -1 ENOTTY 
(Inappropriate ioctl for device)
brk(0x80ea000)                          = 0x80ea000
fcntl64(5, F_SETFD, FD_CLOEXEC)         = 0
read(5, "Personalities : [raid1] \nunused "..., 4096) = 48
read(5, "", 4096)                       = 0
close(5)                                = 0
stat64("/dev/.udev", 0xbfd3cb08)        = -1 ENOENT (No such file or 
directory)
lstat64("/dev/md2", {st_mode=S_IFBLK|0600, st_rdev=makedev(9, 2), ...}) = 0
mkdir("/dev/md", 0700)                  = -1 EEXIST (File exists)
unlink("/dev/md/2")                     = 0
lstat64("/dev/md/2", 0xbfd3cb08)        = -1 ENOENT (No such file or 
directory)
symlink("/dev/md2", "/dev/md/2")        = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
getpid()                                = 872
mknod("/dev/.tmp.md.872:9:2", S_IFBLK|0600, makedev(9, 2)) = 0
open("/dev/.tmp.md.872:9:2", O_RDWR|O_EXCL|O_DIRECT|O_LARGEFILE) = 5
unlink("/dev/.tmp.md.872:9:2")          = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(9, 2), ...}) = 0
ioctl(5, 0x800c0910, 0xbfd3cebc)        = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(9, 2), ...}) = 0
open("/proc/mdstat", O_RDONLY|O_LARGEFILE) = 6
ioctl(6, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3cda0) = -1 ENOTTY 
(Inappropriate ioctl for device)
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
read(6, "Personalities : [raid1] \nunused "..., 4096) = 48
read(6, "", 4096)                       = 0
close(6)                                = 0
ioctl(5, 0x932, 0)                      = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
getpid()                                = 872
mknod("/dev/.tmp.md.872:252:16", S_IFBLK|0600, makedev(252, 16)) = 0
open("/dev/.tmp.md.872:252:16", O_RDWR|O_EXCL|O_DIRECT|O_LARGEFILE) = 6
unlink("/dev/.tmp.md.872:252:16")       = 0
fstat64(6, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 16), ...}) = 0
ioctl(6, BLKGETSIZE64, 0xbfd3ce50)      = 0
ioctl(6, BLKFLSBUF, 0)                  = 0
_llseek(6, 4096, [4096], SEEK_SET)      = 0
ioctl(6, BLKSSZGET, 0xbfd3ce4c)         = 0
read(6, 
"\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\0`\31\0\252\333R\273Z|\376\215\32\177\336\265"..., 
1024) = 1024
close(6)                                = 0
stat64("252:16", 0xbfd3cec8)            = -1 ENOENT (No such file or 
directory)
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
getpid()                                = 872
mknod("/dev/.tmp.md.872:252:16", S_IFBLK|0600, makedev(252, 16)) = 0
open("/dev/.tmp.md.872:252:16", O_RDONLY|O_EXCL|O_DIRECT|O_LARGEFILE) = 6
unlink("/dev/.tmp.md.872:252:16")       = 0
fstat64(6, {st_mode=S_IFBLK|0600, st_rdev=makedev(252, 16), ...}) = 0
ioctl(6, BLKGETSIZE64, 0xbfd3ce50)      = 0
ioctl(6, BLKFLSBUF, 0)                  = 0
_llseek(6, 4096, [4096], SEEK_SET)      = 0
ioctl(6, BLKSSZGET, 0xbfd3ce4c)         = 0
read(6, 
"\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\0`\31\0\252\333R\273Z|\376\215\32\177\336\265"..., 
1024) = 1024
close(6)                                = 0
ioctl(5, 0x800c0910, 0xbfd3cf1c)        = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(9, 2), ...}) = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(9, 2), ...}) = 0
open("/dev/.mdadm/map", O_RDONLY|O_LARGEFILE) = 6
fcntl(6, F_GETFL)                       = 0x8000 (flags 
O_RDONLY|O_LARGEFILE)
ioctl(6, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3ac80) = -1 ENOTTY 
(Inappropriate ioctl for device)
read(6, "md2 1.2 00196000:bb52dbaa:8dfe7c"..., 4096) = 54
read(6, "", 4096)                       = 0
close(6)                                = 0
mkdir("/dev/.mdadm", 0755)              = -1 EEXIST (File exists)
open("/dev/.mdadm/map.new", O_RDWR|O_CREAT|O_LARGEFILE, 0600) = 6
fcntl(6, F_GETFL)                       = 0x8002 (flags O_RDWR|O_LARGEFILE)
ioctl(6, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfd3cd90) = -1 ENOTTY 
(Inappropriate ioctl for device)
write(6, "md2 1.2 00196000:bb52dbaa:8dfe7c"..., 54) = 54
close(6)                                = 0
rename("/dev/.mdadm/map.new", "/dev/.mdadm/map") = 0
fstat64(5, {st_mode=S_IFBLK|0600, st_rdev=makedev(9, 2), ...}) = 0
ioctl(5, 0x800c0910, 0xbfd3ce4c)        = 0
ioctl(5, 0x40480923, 0xbfd3ced4)        = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=4900, ...}) = 0
getpid()                                = 872
mknod("/dev/.tmp.md.872:252:16", S_IFBLK|0600, makedev(252, 16)) = 0
open("/dev/.tmp.md.872:252:16", O_RDWR|O_EXCL|O_DIRECT|O_LARGEFILE) = 6
unlink("/dev/.tmp.md.872:252:16")       = 0
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 EINVAL (Invalid argument)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
ioctl(6, BLKPG, 0xbfd3cf18)             = -1 ENXIO (No such device or 
address)
close(6)                                = 0
ioctl(5, 0x40140921, 0x80e75a8)         = -1 EINVAL (Invalid argument)
write(2, "mdadm: failed to add ", 21mdadm: failed to add )   = 21
write(2, "252:16", 6252:16)                   = 6
write(2, " to ", 4 to )                     = 4
write(2, "/dev/md/2", 9/dev/md/2)                = 9
write(2, ": ", 2: )                       = 2
write(2, "Invalid argument", 16Invalid argument)        = 16
write(2, "\n", 1
)                       = 1
write(2, "mdadm: ", 7mdadm: )                  = 7
write(2, "/dev/md/2", 9/dev/md/2)                = 9
write(2, " assembled from ", 16 assembled from )        = 16
write(2, "0", 10)                        = 1
write(2, " drive", 6 drive)                   = 6
write(2, "s", 1s)                        = 1
write(2, " - not enough to start the array"..., 34 - not enough to start 
the array.
) = 34
close(5)                                = 0
unlink("/dev/.mdadm/map.lock")          = 0
close(3)                                = 0
_exit(1)
###

-- Piotr.
