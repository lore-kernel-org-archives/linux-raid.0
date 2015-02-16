From: gary <gary.mdjiang@gmail.com>
Subject: Re: mdadm failed to remove internal bitmap
Date: Mon, 16 Feb 2015 14:42:20 +0800
Message-ID: <54E1914C.9030000@gmail.com>
References: <54DDC806.5010803@gmail.com> <20150216143419.553cf93e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150216143419.553cf93e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Please check the followings.
> What kernel are you running?
linux48:~ # uname -r
3.12.32-33-default

And 3.12.28-4-default kernel is ok.
> Please use "strace" on mdadm in a case where it fails, and post the result.
linux48:~ # strace mdadm --grow --bitmap=none /dev/md127
execve("/sbin/mdadm", ["mdadm", "--grow", "--bitmap=none", 
"/dev/md127"], [/* 58 vars */]) = 0
brk(0)                                  = 0xfe8000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7fcab07ad000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or 
directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=93919, ...}) = 0
mmap(NULL, 93919, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fcab0796000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\34\2\0\0\0\0\0"..., 
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1978611, ...}) = 0
mmap(NULL, 3832352, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 
0) = 0x7fcab01e6000
mprotect(0x7fcab0384000, 2097152, PROT_NONE) = 0
mmap(0x7fcab0584000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19e000) = 0x7fcab0584000
mmap(0x7fcab058a000, 14880, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fcab058a000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7fcab0795000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7fcab0794000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7fcab0793000
arch_prctl(ARCH_SET_FS, 0x7fcab0794700) = 0
mprotect(0x7fcab0584000, 16384, PROT_READ) = 0
mprotect(0x677000, 4096, PROT_READ)     = 0
mprotect(0x7fcab07ae000, 4096, PROT_READ) = 0
munmap(0x7fcab0796000, 93919)           = 0
getpid()                                = 6000
brk(0)                                  = 0xfe8000
brk(0x1009000)                          = 0x1009000
open("/dev/md127", O_RDWR)              = 3
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 127), ...}) = 0
ioctl(3, RAID_VERSION, 0x7fff2e10d160)  = 0
open("/etc/mdadm.conf", O_RDONLY)       = -1 ENOENT (No such file or 
directory)
open("/etc/mdadm/mdadm.conf", O_RDONLY) = -1 ENOENT (No such file or 
directory)
open("/etc/mdadm.conf.d", O_RDONLY)     = -1 ENOENT (No such file or 
directory)
uname({sys="Linux", node="linux48", ...}) = 0
geteuid()                               = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 127), ...}) = 0
ioctl(3, RAID_VERSION, 0x7fff2e10c060)  = 0
ioctl(3, GET_BITMAP_FILE, 0x7fff2e10c1f0) = 0
ioctl(3, GET_ARRAY_INFO, 0x7fff2e10c1a0) = 0
ioctl(3, SET_ARRAY_INFO, 0x7fff2e10c1a0) = -1 EINVAL (Invalid argument)
write(2, "mdadm: failed to remove internal"..., 41mdadm: failed to 
remove internal bitmap.
) = 41
exit_group(1)                           = ?
+++ exited with 1 +++

Thanks,
gary

