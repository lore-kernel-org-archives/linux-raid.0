From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: Unable to reduce raid size.
Date: Fri, 18 Jul 2014 11:58:25 +0200
Message-ID: <53C8EFC1.1050105@megasoft.be>
References: <53C8DFEE.7000000@megasoft.be> <20140718194043.1c938b2c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140718194043.1c938b2c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bytes are cheap, but screens are small (you'll have to scroll more).

"This condition isn't treated as an error by mdadm, so it isn't the cause."
This is not an error, but if the size isn't changed, the end result will be
component size of /dev/md125 unchanged at 2858285568K (skimmed the source code of mdadm, might have gotten it wrong though)

Full Strace below

execve("/sbin/mdadm", ["mdadm", "-vv", "--grow", "/dev/md125", "--size=2778726400"], [/* 99 vars */]) = 0
uname({sys="Linux", node="*****", ...}) = 0
brk(0)                                  = 0xf43000
brk(0xf441c0)                           = 0xf441c0
arch_prctl(ARCH_SET_FS, 0xf43880)       = 0
brk(0xf651c0)                           = 0xf651c0
brk(0xf66000)                           = 0xf66000
time(NULL)                              = 1405669998
getpid()                                = 20073
open("/dev/md125", O_RDWR)              = 3
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 125), ...}) = 0
ioctl(3, RAID_VERSION, 0x7fffd69526c0)  = 0
open("/etc/mdadm.conf", O_RDONLY)       = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
fstat(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4711ffe000
read(4, "ARRAY /dev/md/main metadata=1.2 "..., 4096) = 286
read(4, "", 4096)                       = 0
read(4, "", 4096)                       = 0
fstat(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
close(4)                                = 0
munmap(0x7f4711ffe000, 4096)            = 0
open("/etc/mdadm.conf.d", O_RDONLY)     = -1 ENOENT (No such file or directory)
uname({sys="Linux", node="qantourisc", ...}) = 0
geteuid()                               = 0
ioctl(3, GET_ARRAY_INFO, 0x7fffd6952570) = 0
ioctl(3, RAID_VERSION, 0x7fffd69502f0)  = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 125), ...}) = 0
readlink("/sys/dev/block/9:125", "../../devices/virtual/block/md12"..., 199) = 33
open("/sys/block/md125/md/metadata_version", O_RDONLY) = 4
read(4, "1.2\n", 1024)                  = 4
close(4)                                = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 125), ...}) = 0
readlink("/sys/dev/block/9:125", "../../devices/virtual/block/md12"..., 199) = 33
ioctl(3, RAID_VERSION, 0x7fffd69503d0)  = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 125), ...}) = 0
readlink("/sys/dev/block/9:125", "../../devices/virtual/block/md12"..., 199) = 33
open("/sys/block/md125/md/metadata_version", O_RDONLY) = 4
read(4, "1.2\n", 1024)                  = 4
close(4)                                = 0
open("/sys/block/md125/md/level", O_RDONLY) = 4
read(4, "raid5\n", 1024)                = 6
close(4)                                = 0
open("/sys/block/md125/md/raid_disks", O_RDONLY) = 4
read(4, "4\n", 1024)                    = 2
close(4)                                = 0
openat(AT_FDCWD, "/sys/block/md125/md/", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
fcntl(4, F_GETFD)                       = 0x1 (flags FD_CLOEXEC)
getdents(4, /* 41 entries */, 32768)    = 1408
open("/sys/block/md125/md/dev-sdb4/slot", O_RDONLY) = 5
read(5, "2\n", 1024)                    = 2
close(5)                                = 0
open("/sys/block/md125/md/dev-sdb4/block/dev", O_RDONLY) = 5
read(5, "8:20\n", 1024)                 = 5
close(5)                                = 0
open("/sys/block/md125/md/dev-sdb4/block/device/state", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/sys/block/md125/md/dev-sdb4/state", O_RDONLY) = 5
read(5, "in_sync\n", 1024)              = 8
close(5)                                = 0
open("/sys/block/md125/md/dev-sdc4/slot", O_RDONLY) = 5
read(5, "0\n", 1024)                    = 2
close(5)                                = 0
open("/sys/block/md125/md/dev-sdc4/block/dev", O_RDONLY) = 5
read(5, "8:36\n", 1024)                 = 5
close(5)                                = 0
open("/sys/block/md125/md/dev-sdc4/block/device/state", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/sys/block/md125/md/dev-sdc4/state", O_RDONLY) = 5
read(5, "in_sync\n", 1024)              = 8
close(5)                                = 0
open("/sys/block/md125/md/dev-sdd4/slot", O_RDONLY) = 5
read(5, "3\n", 1024)                    = 2
close(5)                                = 0
open("/sys/block/md125/md/dev-sdd4/block/dev", O_RDONLY) = 5
read(5, "8:52\n", 1024)                 = 5
close(5)                                = 0
open("/sys/block/md125/md/dev-sdd4/block/device/state", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/sys/block/md125/md/dev-sdd4/state", O_RDONLY) = 5
read(5, "in_sync\n", 1024)              = 8
close(5)                                = 0
getdents(4, /* 0 entries */, 32768)     = 0
close(4)                                = 0
open("/sys/block/md125/md/metadata_version", O_RDONLY) = 4
read(4, "1.2\n", 1024)                  = 4
close(4)                                = 0
open("/sys/block/md125/md//array_state", O_RDWR) = 4
lseek(4, 0, SEEK_SET)                   = 0
read(4, "clean\n", 20)                  = 6
close(4)                                = 0
stat("/sys/block/md125/md//sync_action", {st_mode=S_IFREG|0644, st_size=4096, ...}) = 0
open("/sys/block/md125/md//sync_action", O_RDWR) = 4
lseek(4, 0, SEEK_SET)                   = 0
read(4, "idle\n", 20)                   = 5
close(4)                                = 0
open("/sys/block/md125/md//sync_action", O_WRONLY) = 4
write(4, "frozen", 6)                   = 6
close(4)                                = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 125), ...}) = 0
open("/proc/devices", O_RDONLY)         = 4
fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4711ffe000
read(4, "Character devices:\n  1 mem\n  2 p"..., 1024) = 740
read(4, "", 1024)                       = 0
close(4)                                = 0
munmap(0x7f4711ffe000, 4096)            = 0
open("/sys/block/md125/md/component_size", O_RDONLY) = 4
read(4, "2858285568\n", 50)             = 11
close(4)                                = 0
open("/sys/block/md125/md/dev-sdb4/size", O_WRONLY) = 4
write(4, "2778726400", 10)              = -1 EBUSY (Device or resource busy)
close(4)                                = 0
ioctl(3, SET_ARRAY_INFO, 0x7fffd6952570) = 0
ioctl(3, GET_ARRAY_INFO, 0x7fffd6952570) = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 125), ...}) = 0
open("/sys/block/md125/md/component_size", O_RDONLY) = 4
read(4, "2858285568\n", 50)             = 11
close(4)                                = 0
write(2, "mdadm: component size of /dev/md"..., 61mdadm: component size of /dev/md125 unchanged at 2858285568K
) = 61
open("/sys/block/md125/md/metadata_version", O_RDONLY) = 4
read(4, "1.2\n", 1024)                  = 4
close(4)                                = 0
open("/sys/block/md125/md//sync_action", O_WRONLY) = 4
write(4, "idle", 4)                     = 4
close(4)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++

Killian De Volder

On 18-07-14 11:40, NeilBrown wrote:
> On Fri, 18 Jul 2014 10:50:54 +0200 Killian De Volder
> <killian.de.volder@megasoft.be> wrote:
>
>> Hello,
>>
>> I have a strange issue, I cannot reduce the size of a degraded raid 5:
>>
>> strace mdadm -vv --grow /dev/md125 --size=2778726400
>>
>> Fails with:
>> Stace:
>>     open("/sys/block/md125/md/dev-sdb4/size", O_WRONLY) = 4
>>     write(4, "2778726400", 10)              = -1 EBUSY (Device or resource busy)
>>     close(4)
> This condition isn't treated as an error by mdadm, so it isn't the cause.
>
> Could you post the entire strace (really, bytes a cheap, alway provide more
> detail than you think is needed.... though you did provide quite a bit)
>
> Any kernel messages (dmesg output) ??
>
> NeilBrown
>
>
>> Stdout:
>>     component size of /dev/md125 unchanged at 2858285568K
>> Stderr:
>>     <nothing>
>>
>>
>> Any suggestions ?
>> Note: I can work around this bug, by moving partitions around a bit, and not requiring the size reduction.
>> However I suspect a bug/undocumented border case that should be resolved?
>>
>>
>> Things I tried:
>> ---------------
>> - Disable bcache udev rules (as it was appearing in each attempt, maybe it got triggered during resize, seems not to be the case).
>> - I have tried the same with loop files -> this works fine even with bcache (and the udev rules disabled)
>> - Removed the internal write bitmap
>> - Opend the file os.open("md125",os.O_EXCL,os.O_RDWR) in Python to test if it's in use somewhere (command worked fine)
>> - Set array-size to the less then the desired new size (while still not destroying the FS below it).
>>
>>  
>> Information:
>> ------------
>> Kernel version: 3.15.5
>> mdadm tools: 3.3-r2
>>
>> mdadm --detail:
>> /dev/md125:
>>         Version : 1.2
>>   Creation Time : Wed Apr 16 20:58:09 2014
>>      Raid Level : raid5
>>      Array Size : 8283750400 (7900.00 GiB 8482.56 GB)
>>   Used Dev Size : 2858285568 (2725.87 GiB 2926.88 GB)
>>    Raid Devices : 4
>>   Total Devices : 3
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Fri Jul 18 09:53:08 2014
>>           State : clean, degraded
>>  Active Devices : 3
>> Working Devices : 3
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>            UUID : 885c588b:c3503d9d:c67b86db:2887f8f7
>>          Events : 6440
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       36        0      active sync   /dev/sdc4
>>        2       0        0        2      removed
>>        2       8       20        2      active sync   /dev/sdb4
>>        4       8       52        3      active sync   /dev/sdd4
>>

