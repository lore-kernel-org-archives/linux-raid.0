From: Andre Noll <maan@systemlinux.org>
Subject: Re: mdadm-2.3.1 fails to hotadd device
Date: Sun, 26 Feb 2006 13:13:32 +0100
Message-ID: <20060226121332.GK7030@skl-net.de>
References: <20060226110859.GJ7030@skl-net.de> <17409.37867.588055.108823@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17409.37867.588055.108823@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22:41, Neil Brown wrote:
> > # mdadm /dev/md1 -a /dev/hdd1
> > mdadm: cannot find valid superblock in this array - HELP
> 
> Can you
>   strace -o /tmp/trace mdadm /dev/md1 -a /dev/hdd1
> 
> and send me /tmp/trace?

Here it comes.
Andre
---
execve("/sbin/mdadm", ["mdadm", "/dev/md1", "-a", "/dev/hdd1"], [/* 99 vars */]) = 0
uname({sys="Linux", node="raspe", ...}) = 0
brk(0)                                  = 0x806a000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/usr/lib/glibc-2.3.6/etc/ld.so.cache", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=44713, ...}) = 0
mmap2(NULL, 44713, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f4d000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0O\1\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1175704, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f4c000
mmap2(NULL, 1162428, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e30000
mmap2(0xb7f46000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x116) = 0xb7f46000
mmap2(0xb7f4a000, 7356, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f4a000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e2f000
mprotect(0xb7f46000, 4096, PROT_READ)   = 0
mprotect(0xb7f6d000, 4096, PROT_READ)   = 0
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7e2f6b0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0xb7f4d000, 44713)               = 0
time(NULL)                              = 1140955660
getpid()                                = 1392
brk(0)                                  = 0x806a000
brk(0x808b000)                          = 0x808b000
open("/dev/md1", O_RDWR)                = 3
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 1), ...}) = 0
ioctl(3, 0x800c0910, 0xbfd671d0)        = 0
ioctl(3, 0x80480911, 0xbfd67310)        = 0
stat64("/dev/hdd1", {st_mode=S_IFBLK|0660, st_rdev=makedev(22, 65), ...}) = 0
open("/dev/hdd1", O_RDONLY|O_EXCL)      = 4
ioctl(4, BLKGETSIZE64, 0xbfd670f0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 263061504, [263061504], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0Z\0\0\0\0\0\0\0\0\0\0\0a7h\220hTiC\1"..., 4096) = 4096
close(4)                                = 0
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 1), ...}) = 0
ioctl(3, 0x800c0910, 0xbfd67090)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
lstat64("/dev", {st_mode=S_IFLNK|0777, st_size=5, ...}) = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
ioctl(3, 0x80140912, 0xbfd672f0)        = 0
write(2, "mdadm: cannot find valid superbl"..., 57) = 57
exit_group(1)                           = ?
-- 
The only person who always got his work done by Friday was Robinson Crusoe
