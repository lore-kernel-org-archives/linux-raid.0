From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: Mdadm misuse or bug ? mdadm: Cannot find 8:18: No such file or
 directory
Date: Sat, 09 Aug 2014 09:52:09 +0200
Message-ID: <53E5D329.4040004@megasoft.be>
References: <53E54AC5.4010904@megasoft.be> <20140809104915.05b8da17@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140809104915.05b8da17@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doesn't work since sdb has been ejected. Strace below.

package manager: mdadm 3.3-r2
#mdadm -V: mdadm - v3.3 - 3rd September 2013

Just tried 3.3-r3 and 3.2.6-r1 same issue.
(There are no older in the package manager to try fast.)

#strace mdadm /dev/md126 -r /dev/sdb2
execve("/sbin/mdadm", ["mdadm", "/dev/md126", "-r", "/dev/sdb2"], [/* 99 vars */]) = 0
uname({sys="Linux", node="********", ...}) = 0
brk(0)                                  = 0x212d000
brk(0x212e1c0)                          = 0x212e1c0
arch_prctl(ARCH_SET_FS, 0x212d880)      = 0
brk(0x214f1c0)                          = 0x214f1c0
brk(0x2150000)                          = 0x2150000
time(NULL)                              = 1407569631
getpid()                                = 6499
open("/dev/md126", O_RDWR)              = 3
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
ioctl(3, RAID_VERSION, 0x7ffffed2ffa0)  = 0
open("/etc/mdadm.conf", O_RDONLY)       = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
fstat(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f804b529000
read(4, "ARRAY /dev/md/main metadata=1.2 "..., 4096) = 286
read(4, "", 4096)                       = 0
read(4, "", 4096)                       = 0
fstat(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
close(4)                                = 0
munmap(0x7f804b529000, 4096)            = 0
open("/etc/mdadm.conf.d", O_RDONLY)     = -1 ENOENT (No such file or directory)
uname({sys="Linux", node="*********", ...}) = 0
geteuid()                               = 0
ioctl(3, GET_ARRAY_INFO, 0x7ffffed2fd70) =
ioctl(3, RAID_VERSION, 0x7ffffed2fc50)  = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
readlink("/sys/dev/block/9:126", "../../devices/virtual/block/md12"..., 199) = 33
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
open("/proc/devices", O_RDONLY)         = 4
fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f804b529000
read(4, "Character devices:\n  1 mem\n  2 p"..., 1024) = 734
read(4, "", 1024)                       = 0
close(4)                                = 0
munmap(0x7f804b529000, 4096)            = 0
open("/sys/block/md126/md/component_size", O_RDONLY) = 4
read(4, "102272\n", 50)                 = 7
close(4)                                = 0
ioctl(3, RAID_VERSION, 0x7ffffed2daf0)  = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
readlink("/sys/dev/block/9:126", "../../devices/virtual/block/md12"..., 199) = 33
open("/sys/block/md126/md/metadata_version", O_RDONLY) = 4
read(4, "1.2\n", 1024)                  = 4
close(4)                                = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 126), ...}) = 0
readlink("/sys/dev/block/9:126", "../../devices/virtual/block/md12"..., 199) = 33
open("/dev/sdb2", O_RDONLY|O_DIRECT)    = -1 ENOENT (No such file or directory)
stat("/dev/sdb2", 0x7ffffed2fe10)       = -1 ENOENT (No such file or directory)
write(2, "mdadm: Cannot find /dev/sdb2: No"..., 56mdadm: Cannot find /dev/sdb2: No such file or directory
) = 56
exit_group(1)                           = ?
+++ exited with 1 +++

Killian De Volder

On 09-08-14 02:49, NeilBrown wrote:
> On Sat, 09 Aug 2014 00:10:13 +0200 Killian De Volder
> <killian.de.volder@megasoft.be> wrote:
>
>> I'm having some trouble with a disk of unknown cause.
>> As a result the disk is now "failed"
>>
>> #dmesg
>> [362288.463008] ata3: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0xe frozen
>> ...
>> [377997.666956] md: super_written gets error=-5, uptodate=0
>> [377997.666960] md/raid1:md126: Disk failure on sdb3, disabling device
>>
>> I replugged the disk, and added it again to the raid (it is now called sdf instead of sdb):
>>
>> # cat /proc/mdstat:
>> md126 : active raid1 sdf2[5] sdd2[0] sde2[3] sdc2[2] sdb2[4](F)
>>       102272 blocks super 1.2 [4/4] [UUUU]
>>
>> So I wanted to remove the failed disk:
>>
>> # mdadm /dev/md126 -r failed
>> mdadm: Cannot find 8:18: No such file or directory
> Hmm.. that looks broken.
> What version of mdadm is this?
> Does
>    mdadm /dev/md126 -r detached
> work?
> How about
>    mdadm /dev/md127 -r sdb2
>
> Thanks,
> NeilBrown

