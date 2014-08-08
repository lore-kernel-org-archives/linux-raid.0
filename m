From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Mdadm misuse or bug ? mdadm: Cannot find 8:18: No such file or directory
Date: Sat, 09 Aug 2014 00:10:13 +0200
Message-ID: <53E54AC5.4010904@megasoft.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having some trouble with a disk of unknown cause.
As a result the disk is now "failed"

#dmesg
[362288.463008] ata3: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0xe frozen
...
[377997.666956] md: super_written gets error=-5, uptodate=0
[377997.666960] md/raid1:md126: Disk failure on sdb3, disabling device

I replugged the disk, and added it again to the raid (it is now called sdf instead of sdb):

# cat /proc/mdstat:
md126 : active raid1 sdf2[5] sdd2[0] sde2[3] sdc2[2] sdb2[4](F)
      102272 blocks super 1.2 [4/4] [UUUU]

So I wanted to remove the failed disk:

# mdadm /dev/md126 -r failed
mdadm: Cannot find 8:18: No such file or directory

# strace mdadm /dev/md126 -r failed
execve("/sbin/mdadm", ["mdadm", "/dev/md126", "-r", "failed"], [/* 99 vars */]) = 0
uname({sys="Linux", node="*****", ...}) = 0
brk(0)                                  = 0x22b8000
brk(0x22b91c0)                          = 0x22b91c0
arch_prctl(ARCH_SET_FS, 0x22b8880)      = 0
brk(0x22da1c0)                          = 0x22da1c0
brk(0x22db000)                          = 0x22db000
time(NULL)                              = 1407534997
getpid()                                = 15706
open("/dev/md126", O_RDWR)              = 3
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
ioctl(3, RAID_VERSION, 0x7ffff00550c0)  = 0
open("/etc/mdadm.conf", O_RDONLY)       = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
fstat(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f906273d000
read(4, "ARRAY /dev/md/main metadata=1.2 "..., 4096) = 286
read(4, "", 4096)                       = 0
read(4, "", 4096)                       = 0
fstat(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
close(4)                                = 0
munmap(0x7f906273d000, 4096)            = 0
open("/etc/mdadm.conf.d", O_RDONLY)     = -1 ENOENT (No such file or directory)
uname({sys="Linux", node="qantourisc", ...}) = 0
geteuid()                               = 0
ioctl(3, GET_ARRAY_INFO, 0x7ffff0054e90) = 0
ioctl(3, RAID_VERSION, 0x7ffff0054d70)  = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
readlink("/sys/dev/block/9:126", "../../devices/virtual/block/md12"..., 199) = 33
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
open("/proc/devices", O_RDONLY)         = 4
fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f906273d000
read(4, "Character devices:\n  1 mem\n  2 p"..., 1024) = 734
read(4, "", 1024)                       = 0
close(4)                                = 0
munmap(0x7f906273d000, 4096)            = 0
open("/sys/block/md126/md/component_size", O_RDONLY) = 4
read(4, "102272\n", 50)                 = 7
close(4)                                = 0
ioctl(3, RAID_VERSION, 0x7ffff0052c10)  = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
readlink("/sys/dev/block/9:126", "../../devices/virtual/block/md12"..., 199) = 33
open("/sys/block/md126/md/metadata_version", O_RDONLY) = 4
read(4, "1.2\n", 1024)                  = 4
close(4)                                = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
readlink("/sys/dev/block/9:126", "../../devices/virtual/block/md12"..., 199) = 33
ioctl(3, GET_ARRAY_INFO, 0x7ffff0054ee0) = 0
ioctl(3, GET_DISK_INFO, 0x7ffff0054e40) = 0
ioctl(3, GET_DISK_INFO, 0x7ffff0054e40) = 0
ioctl(3, GET_DISK_INFO, 0x7ffff0054e40) = 0
ioctl(3, GET_DISK_INFO, 0x7ffff0054e40) = 0
ioctl(3, GET_DISK_INFO, 0x7ffff0054e40) = 0
ioctl(3, GET_DISK_INFO, 0x7ffff0054e40) = 0
mknod("/dev/.tmp.md.15706:8:18", S_IFBLK|0600, makedev(8, 18)) = 0
open("/dev/.tmp.md.15706:8:18", O_RDONLY|O_DIRECT) = -1 ENXIO (No such device or address)
unlink("/dev/.tmp.md.15706:8:18")       = 0
mknod("/tmp/.tmp.md.15706:8:18", S_IFBLK|0600, makedev(8, 18)) = 0
open("/tmp/.tmp.md.15706:8:18", O_RDONLY|O_DIRECT) = -1 ENXIO (No such device or address)
unlink("/tmp/.tmp.md.15706:8:18")       = 0
stat("8:18", 0x7ffff0054f30)            = -1 ENOENT (No such file or directory)
write(2, "mdadm: Cannot find 8:18: No such"..., 51mdadm: Cannot find 8:18: No such file or directory
) = 51
exit_group(1)                           = ?
+++ exited with 1 +++


PS. If anyone has an idea why this slot keeps failing ?
First it was failing every 12 hours, probably related to vibrations.
Found a loose power connector so re plugged that.
Then it ran OK for ~2 weeks, today it failed.
Might of course be chance ?

-- Kind regard, Killian

