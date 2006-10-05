From: mickg <mickg@mickg.net>
Subject: Re: mdadm RAID5 Grow
Date: Thu, 05 Oct 2006 08:41:20 -0400
Message-ID: <4524FD70.6070609@mickg.net>
References: <6652499.post@talk.nabble.com> <17700.35743.152233.689956@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17700.35743.152233.689956@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday October 4, mickg@mickg.net wrote:
>> I have been trying to run: 
>> mdadm --grow /dev/md0 --raid-devices=6 --backup-file /backup_raid_grow
>> I get:
>> mdadm: Need to backup 1280K of critical section..
>> mdadm: /dev/md0: Cannot get array details from sysfs
> 
> It shouldn't do that.... 
> Can you 
>   strace -o /tmp/trace -s 300 mdadm --grow .....
> 
> and send a copy of /tmp/trace.  I'd like to see how far it gets at
> reading information from sysfs.
> 
>> Would it need to be unmounted to work properly (It is currently mounted
>> under lvm)?
> 
> No.  unmounting isn't needed and won't make any difference.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
strace mdadm --grow /dev/md0 --raid-devices=6 --backup-file /backup_raid_grow


execve("/sbin/mdadm", ["mdadm", "--grow", "/dev/md0", "--raid-devices=6", "--backup-file", "/backup_raid_grow"], [/* 68 vars */]) = 0
brk(0)                                  = 0x8076000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=107351, ...}) = 0
mmap2(NULL, 107351, PROT_READ, MAP_PRIVATE, 3, 0) = 0xa7fa8000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\300Y\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1404242, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xa7fa7000
mmap2(NULL, 1176988, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xa7e87000
madvise(0xa7e87000, 1176988, MADV_SEQUENTIAL|0x1) = 0
mmap2(0xa7fa0000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x118) = 0xa7fa0000
mmap2(0xa7fa4000, 9628, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xa7fa4000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xa7e86000
set_thread_area({entry_number:-1 -> 6, base_addr:0xa7e866b0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, 
seg_not_present:0, useable:1}) = 0
mprotect(0xa7fa0000, 8192, PROT_READ)   = 0
munmap(0xa7fa8000, 107351)              = 0
time(NULL)                              = 1160052126
getpid()                                = 8461
brk(0)                                  = 0x8076000
brk(0x8097000)                          = 0x8097000
open("/etc/mdadm.conf", O_RDONLY)       = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=154, ...}) = 0
mmap2(NULL, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xa7e66000
read(3, "DEVICE partitions\nARRAY /dev/md0"..., 131072) = 154
read(3, "", 131072)                     = 0
read(3, "", 131072)                     = 0
close(3)                                = 0
munmap(0xa7e66000, 131072)              = 0
open("/dev/md0", O_RDWR)                = 3
fstat64(3, {st_mode=S_IFBLK|0640, st_rdev=makedev(9, 0), ...}) = 0
ioctl(3, 0x800c0910, 0xafc4a024)        = 0
ioctl(3, 0x80480911, 0xafc4a0a8)        = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 3), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xa7fc2000
write(1, "mdadm: Need to backup 1280K of c"..., 50mdadm: Need to backup 1280K of critical section..
) = 50
fstat64(3, {st_mode=S_IFBLK|0640, st_rdev=makedev(9, 0), ...}) = 0
open("/sys/block/md0/md/component_size", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "mdadm: /dev/md0: Cannot get arra"..., 53mdadm: /dev/md0: Cannot get array details from sysfs
) = 53
exit_group(1)                           = ?
Process 8461 detached


