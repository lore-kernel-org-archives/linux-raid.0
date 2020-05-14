From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Thu, 14 May 2020 13:07:19 +0200
Message-ID: <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl>
 <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
 <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl>
 <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------17C2B7CF14F9B535DF170B03"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
Content-Language: en-US-large
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------17C2B7CF14F9B535DF170B03
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/13/20 6:17 PM, Song Liu wrote:
>>>
>>> Are these captured back to back? I am asking because they showed different
>>> "Events" number.
>>
>> Nah, they were captured between reboots. Back to back all event fields show identical value (at 56291 now).
>>
>>>
>>> Also, when mdadm -A hangs, could you please capture /proc/$(pidof mdadm)/stack ?
>>>
>>
>> The output is empty:
>>
>> xs22:/☠ ps -eF fww | grep mdadm
>> root     10332  9362 97   740  1884  25 12:47 pts/1    R+     6:59  |   \_ mdadm -A /dev/md/r5_big /dev/md/r1_journal_big /dev/sdi1 /dev/sdg1 /dev/sdj1 /dev/sdh1
>> xs22:/☠ cd /proc/10332
>> xs22:/proc/10332☠ cat stack
>> xs22:/proc/10332☠
> 
> Hmm... Could you please share the strace output of "mdadm -A" command? Like
> 
> strace mdadm -A /dev/md/r5_big /dev/md/r1_journal_big /dev/xxx ...
> 
> Thanks,
> Song

I did one more thing - ran cat on that stack in another terminal every 
0.1 seconds, this is what was found:

cat: /proc//stack: No such file or directory
cat: /proc//stack: No such file or directory
cat: /proc//stack: No such file or directory
[<0>] submit_bio_wait+0x5b/0x80
[<0>] r5l_recovery_read_page+0x1b6/0x200 [raid456]
[<0>] r5l_recovery_verify_data_checksum+0x19/0x70 [raid456]
[<0>] r5l_start+0x99e/0xe70 [raid456]
[<0>] md_start.part.48+0x2e/0x50 [md_mod]
[<0>] do_md_run+0x64/0x100 [md_mod]
[<0>] md_ioctl+0xe7d/0x17d0 [md_mod]
[<0>] blkdev_ioctl+0x4d0/0xa00
[<0>] block_ioctl+0x39/0x40
[<0>] do_vfs_ioctl+0xa4/0x630
[<0>] ksys_ioctl+0x60/0x90
[<0>] __x64_sys_ioctl+0x16/0x20
[<0>] do_syscall_64+0x52/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
cat: /proc//stack: No such file or directory
[<0>] submit_bio_wait+0x5b/0x80
[<0>] r5l_recovery_read_page+0x1b6/0x200 [raid456]
[<0>] r5l_recovery_verify_data_checksum+0x19/0x70 [raid456]
[<0>] r5l_start+0x99e/0xe70 [raid456]
[<0>] md_start.part.48+0x2e/0x50 [md_mod]
[<0>] do_md_run+0x64/0x100 [md_mod]
[<0>] md_ioctl+0xe7d/0x17d0 [md_mod]
[<0>] blkdev_ioctl+0x4d0/0xa00
[<0>] block_ioctl+0x39/0x40
[<0>] do_vfs_ioctl+0xa4/0x630
[<0>] ksys_ioctl+0x60/0x90
[<0>] __x64_sys_ioctl+0x16/0x20
[<0>] do_syscall_64+0x52/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
cat: /proc//stack: No such file or directory
cat: /proc//stack: No such file or directory
cat: /proc//stack: No such file or directory
cat: /proc//stack: No such file or directory


Strace output attached.

Thanks.

--------------17C2B7CF14F9B535DF170B03
Content-Type: text/x-log; charset=UTF-8;
 name="mdadm.strace.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdadm.strace.log"

3650  execve("/sbin/mdadm", ["mdadm", "-A", "/dev/md/r5_big", "/dev/md/r1_journal_big", "/dev/sdi1", "/dev/sdg1", "/dev/sdj1", "/dev/sdh1"], 0x7ffea6946570 /* 39 vars */) = 0
3650  brk(NULL)                         = 0x55885c8e2000
3650  access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
3650  fstat(3, {st_mode=S_IFREG|0644, st_size=63242, ...}) = 0
3650  mmap(NULL, 63242, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fbb17321000
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
3650  read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\21\0\0\0\0\0\0"..., 832) = 832
3650  fstat(3, {st_mode=S_IFREG|0644, st_size=14592, ...}) = 0
3650  mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fbb1731f000
3650  mmap(NULL, 16656, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fbb1731a000
3650  mmap(0x7fbb1731b000, 4096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7fbb1731b000
3650  mmap(0x7fbb1731c000, 4096, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7fbb1731c000
3650  mmap(0x7fbb1731d000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7fbb1731d000
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
3650  read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260A\2\0\0\0\0\0"..., 832) = 832
3650  fstat(3, {st_mode=S_IFREG|0755, st_size=1824496, ...}) = 0
3650  mmap(NULL, 1837056, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fbb17159000
3650  mprotect(0x7fbb1717b000, 1658880, PROT_NONE) = 0
3650  mmap(0x7fbb1717b000, 1343488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x22000) = 0x7fbb1717b000
3650  mmap(0x7fbb172c3000, 311296, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16a000) = 0x7fbb172c3000
3650  mmap(0x7fbb17310000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1b6000) = 0x7fbb17310000
3650  mmap(0x7fbb17316000, 14336, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fbb17316000
3650  close(3)                          = 0
3650  mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fbb17156000
3650  arch_prctl(ARCH_SET_FS, 0x7fbb17156740) = 0
3650  mprotect(0x7fbb17310000, 16384, PROT_READ) = 0
3650  mprotect(0x7fbb1731d000, 4096, PROT_READ) = 0
3650  mprotect(0x55885b2e6000, 4096, PROT_READ) = 0
3650  mprotect(0x7fbb17358000, 4096, PROT_READ) = 0
3650  munmap(0x7fbb17321000, 63242)     = 0
3650  getpid()                          = 3650
3650  uname({sysname="Linux", nodename="xs22", ...}) = 0
3650  brk(NULL)                         = 0x55885c8e2000
3650  brk(0x55885c903000)               = 0x55885c903000
3650  openat(AT_FDCWD, "/dev/md/r5_big", O_RDONLY) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/etc/mdadm/mdadm.conf", O_RDONLY) = 3
3650  fstat(3, {st_mode=S_IFREG|0644, st_size=1729, ...}) = 0
3650  fstat(3, {st_mode=S_IFREG|0644, st_size=1729, ...}) = 0
3650  read(3, "# mdadm.conf\n#\n# Please refer to"..., 4096) = 1729
3650  read(3, "", 4096)                 = 0
3650  fstat(3, {st_mode=S_IFREG|0644, st_size=1729, ...}) = 0
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/etc/mdadm/mdadm.conf.d", O_RDONLY) = -1 ENOENT (No such file or directory)
3650  uname({sysname="Linux", nodename="xs22", ...}) = 0
3650  openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
3650  fstat(3, {st_mode=S_IFREG|0644, st_size=63242, ...}) = 0
3650  mmap(NULL, 63242, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fbb17321000
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/tls/x86_64/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64-linux-gnu/tls/x86_64/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/tls/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64-linux-gnu/tls", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/x86_64/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64-linux-gnu/x86_64/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64-linux-gnu/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64-linux-gnu/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64-linux-gnu", {st_mode=S_IFDIR|0755, st_size=6218, ...}) = 0
3650  openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/tls/x86_64/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64-linux-gnu/tls/x86_64/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/tls/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64-linux-gnu/tls", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/x86_64/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64-linux-gnu/x86_64/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64-linux-gnu/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64-linux-gnu/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64-linux-gnu", {st_mode=S_IFDIR|0755, st_size=38826, ...}) = 0
3650  openat(AT_FDCWD, "/lib/tls/x86_64/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/tls/x86_64/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/tls/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/tls/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/tls/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/tls", 0x7ffc70457820)  = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/lib", {st_mode=S_IFDIR|0755, st_size=326, ...}) = 0
3650  openat(AT_FDCWD, "/usr/lib/tls/x86_64/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/tls/x86_64/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/tls/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/tls/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/tls/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/tls", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib/x86_64", 0x7ffc70457820) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  stat("/usr/lib", {st_mode=S_IFDIR|0755, st_size=1262, ...}) = 0
3650  munmap(0x7fbb17321000, 63242)     = 0
3650  openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
3650  fstat(3, {st_mode=S_IFREG|0644, st_size=63242, ...}) = 0
3650  mmap(NULL, 63242, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fbb17321000
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libcmap.so.4", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libcmap.so.4", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/lib/libcmap.so.4", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/usr/lib/libcmap.so.4", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
3650  munmap(0x7fbb17321000, 63242)     = 0
3650  geteuid()                         = 0
3650  openat(AT_FDCWD, "/dev/md/r1_journal_big", O_RDONLY|O_DIRECT) = 3
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  readlink("/sys/dev/block/9:125", "../../devices/virtual/block/md12"..., 199) = 33
3650  stat("/sys/block/md125/md", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  openat(AT_FDCWD, "/sys/block/md125/md/metadata_version", O_RDONLY) = 4
3650  read(4, "1.1\n", 4096)            = 4
3650  close(4)                          = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 274742575104, SEEK_SET)  = 274742575104
3650  read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 274742632448, SEEK_SET)  = 274742632448
3650  read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 274742636544
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 4096
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 4096, SEEK_SET)          = 4096
3650  read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 8192
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 4096
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  ioctl(3, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=1073741824, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 274742640128, SEEK_SET)  = 274742640128
3650  read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512) = 512
3650  ioctl(3, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=1073741824, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  ioctl(3, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=1073741824, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  openat(AT_FDCWD, "/sys/bus/pci/drivers/isci", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/sys/bus/pci/drivers/ahci", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
3650  fstat(4, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  getdents64(4, /* 9 entries */, 32768) = 264
3650  readlink("/sys/bus/pci/drivers/ahci/./subsystem", 0x7ffc70456530, 4096) = -1 ENOENT (No such file or directory)
3650  readlink("/sys/bus/pci/drivers/ahci/../subsystem", 0x7ffc70456530, 4096) = -1 ENOENT (No such file or directory)
3650  readlink("/sys/bus/pci/drivers/ahci/uevent/subsystem", 0x7ffc70456530, 4096) = -1 ENOTDIR (Not a directory)
3650  readlink("/sys/bus/pci/drivers/ahci/0000:00:1f.2/subsystem", "../../../bus/pci", 4096) = 16
3650  openat(AT_FDCWD, "/sys/bus/pci/drivers/ahci/0000:00:1f.2/vendor", O_RDONLY) = 5
3650  read(5, "0x8086\n", 7)            = 7
3650  close(5)                          = 0
3650  openat(AT_FDCWD, "/sys/bus/pci/drivers/ahci/0000:00:1f.2/device", O_RDONLY) = 5
3650  lseek(5, 0, SEEK_SET)             = 0
3650  read(5, "0x1d02\n", 50)           = 7
3650  close(5)                          = 0
3650  openat(AT_FDCWD, "/sys/bus/pci/drivers/ahci/0000:00:1f.2/class", O_RDONLY) = 5
3650  lseek(5, 0, SEEK_SET)             = 0
3650  read(5, "0x010601\n", 50)         = 9
3650  close(5)                          = 0
3650  lstat("/sys", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
3650  lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/bus/pci/drivers", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/bus/pci/drivers/ahci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/bus/pci/drivers/ahci/0000:00:1f.2", {st_mode=S_IFLNK|0777, st_size=0, ...}) = 0
3650  readlink("/sys/bus/pci/drivers/ahci/0000:00:1f.2", "../../../../devices/pci0000:00/0"..., 4095) = 43
3650  lstat("/sys/devices", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/devices/pci0000:00", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/devices/pci0000:00/0000:00:1f.2", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  readlink("/sys/bus/pci/drivers/ahci/bind/subsystem", 0x7ffc70456530, 4096) = -1 ENOTDIR (Not a directory)
3650  readlink("/sys/bus/pci/drivers/ahci/new_id/subsystem", 0x7ffc70456530, 4096) = -1 ENOTDIR (Not a directory)
3650  readlink("/sys/bus/pci/drivers/ahci/remove_id/subsystem", 0x7ffc70456530, 4096) = -1 ENOTDIR (Not a directory)
3650  readlink("/sys/bus/pci/drivers/ahci/unbind/subsystem", 0x7ffc70456530, 4096) = -1 ENOTDIR (Not a directory)
3650  readlink("/sys/bus/pci/drivers/ahci/module/subsystem", 0x7ffc70456530, 4096) = -1 ENOENT (No such file or directory)
3650  getdents64(4, /* 0 entries */, 32768) = 0
3650  close(4)                          = 0
3650  openat(AT_FDCWD, "/sys/bus/pci/drivers/vmd", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/sys/bus/pci/drivers/nvme", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = -1 ENOENT (No such file or directory)
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  lstat("/sys", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
3650  lstat("/sys/dev", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/dev/block", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/dev/block/9:125", {st_mode=S_IFLNK|0777, st_size=0, ...}) = 0
3650  readlink("/sys/dev/block/9:125", "../../devices/virtual/block/md12"..., 4095) = 33
3650  lstat("/sys/devices", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/devices/virtual", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/devices/virtual/block", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/devices/virtual/block/md125", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  lstat("/sys/devices/virtual/block/md125/device", 0x7ffc704573c0) = -1 ENOENT (No such file or directory)
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 274742639616, SEEK_SET)  = 274742639616
3650  read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512) = 512
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 512) = 512
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 512) = 512
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 274742632448, SEEK_SET)  = 274742632448
3650  read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 274742636544
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 4096
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 4096, SEEK_SET)          = 4096
3650  read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 8192
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 4096
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 4096
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/dev/md/r1_journal_big", O_RDONLY|O_EXCL|O_DIRECT) = 3
3650  close(3)                          = 0
3650  stat("/sys/dev/block/9:125/partition", 0x7ffc704575c0) = -1 ENOENT (No such file or directory)
3650  openat(AT_FDCWD, "/dev/sdi1", O_RDONLY|O_DIRECT) = 3
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x81), ...}) = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x81), ...}) = 0
3650  readlink("/sys/dev/block/8:129", "../../devices/pci0000:00/0000:00"..., 199) = 141
3650  stat("/sys/block/sdi/md", 0x7ffc704556d0) = -1 ENOENT (No such file or directory)
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x81), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [4000000000000]) = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 4096
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/dev/sdi1", O_RDONLY|O_EXCL|O_DIRECT) = 3
3650  close(3)                          = 0
3650  stat("/sys/dev/block/8:129/partition", {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
3650  openat(AT_FDCWD, "/dev/sdg1", O_RDONLY|O_DIRECT) = 3
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x61), ...}) = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x61), ...}) = 0
3650  readlink("/sys/dev/block/8:97", "../../devices/pci0000:00/0000:00"..., 199) = 141
3650  stat("/sys/block/sdg/md", 0x7ffc704556d0) = -1 ENOENT (No such file or directory)
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x61), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [4000000000000]) = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 4096
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/dev/sdg1", O_RDONLY|O_EXCL|O_DIRECT) = 3
3650  close(3)                          = 0
3650  stat("/sys/dev/block/8:97/partition", {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
3650  openat(AT_FDCWD, "/dev/sdj1", O_RDONLY|O_DIRECT) = 3
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x91), ...}) = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x91), ...}) = 0
3650  readlink("/sys/dev/block/8:145", "../../devices/pci0000:00/0000:00"..., 199) = 141
3650  stat("/sys/block/sdj/md", 0x7ffc704556d0) = -1 ENOENT (No such file or directory)
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x91), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [4000000000000]) = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 4096
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/dev/sdj1", O_RDONLY|O_EXCL|O_DIRECT) = 3
3650  close(3)                          = 0
3650  stat("/sys/dev/block/8:145/partition", {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
3650  openat(AT_FDCWD, "/dev/sdh1", O_RDONLY|O_DIRECT) = 3
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x71), ...}) = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x71), ...}) = 0
3650  readlink("/sys/dev/block/8:113", "../../devices/pci0000:00/0000:00"..., 199) = 141
3650  stat("/sys/block/sdh/md", 0x7ffc704556d0) = -1 ENOENT (No such file or directory)
3650  ioctl(3, BLKSSZGET, [512])        = 0
3650  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x71), ...}) = 0
3650  ioctl(3, BLKGETSIZE64, [4000000000000]) = 0
3650  lseek(3, 0, SEEK_SET)             = 0
3650  read(3, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(3, 0, SEEK_CUR)             = 4096
3650  close(3)                          = 0
3650  openat(AT_FDCWD, "/dev/sdh1", O_RDONLY|O_EXCL|O_DIRECT) = 3
3650  close(3)                          = 0
3650  stat("/sys/dev/block/8:113/partition", {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
3650  mkdir("/run/mdadm", 0755)         = -1 EEXIST (File exists)
3650  openat(AT_FDCWD, "/run/mdadm/map.lock", O_RDWR|O_CREAT|O_TRUNC, 0600) = 3
3650  fcntl(3, F_GETFL)                 = 0x8002 (flags O_RDWR|O_LARGEFILE)
3650  flock(3, LOCK_EX)                 = 0
3650  fstat(3, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
3650  openat(AT_FDCWD, "/run/mdadm/map", O_RDONLY) = 4
3650  fcntl(4, F_GETFL)                 = 0x8000 (flags O_RDONLY|O_LARGEFILE)
3650  fstat(4, {st_mode=S_IFREG|0600, st_size=191, ...}) = 0
3650  read(4, "md125 1.1 96398bc1:491fb249:928e"..., 4096) = 191
3650  read(4, "", 4096)                 = 0
3650  close(4)                          = 0
3650  stat("/dev/.udev", 0x7ffc704574d0) = -1 ENOENT (No such file or directory)
3650  stat("/run/udev", {st_mode=S_IFDIR|0755, st_size=160, ...}) = 0
3650  openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) = 4
3650  fcntl(4, F_SETFD, FD_CLOEXEC)     = 0
3650  fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
3650  read(4, "Personalities : [linear] [multip"..., 1024) = 654
3650  read(4, "", 1024)                 = 0
3650  close(4)                          = 0
3650  openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) = 4
3650  fcntl(4, F_SETFD, FD_CLOEXEC)     = 0
3650  fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
3650  read(4, "Personalities : [linear] [multip"..., 1024) = 654
3650  read(4, "", 1024)                 = 0
3650  close(4)                          = 0
3650  openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) = 4
3650  fcntl(4, F_SETFD, FD_CLOEXEC)     = 0
3650  fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
3650  read(4, "Personalities : [linear] [multip"..., 1024) = 654
3650  read(4, "", 1024)                 = 0
3650  close(4)                          = 0
3650  openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) = 4
3650  fcntl(4, F_SETFD, FD_CLOEXEC)     = 0
3650  fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
3650  read(4, "Personalities : [linear] [multip"..., 1024) = 654
3650  read(4, "", 1024)                 = 0
3650  close(4)                          = 0
3650  openat(AT_FDCWD, "/sys/block/md124/dev", O_RDONLY) = -1 ENOENT (No such file or directory)
3650  getpid()                          = 3650
3650  mknod("/dev/.tmp.md.3650:9:124", S_IFBLK|0600, makedev(0x9, 0x7c)) = 0
3650  openat(AT_FDCWD, "/dev/.tmp.md.3650:9:124", O_RDWR|O_EXCL|O_DIRECT) = 4
3650  unlink("/dev/.tmp.md.3650:9:124") = 0
3650  fstat(4, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x7c), ...}) = 0
3650  readlink("/sys/dev/block/9:124", "../../devices/virtual/block/md12"..., 199) = 33
3650  openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) = 5
3650  fcntl(5, F_SETFD, FD_CLOEXEC)     = 0
3650  fstat(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
3650  read(5, "Personalities : [linear] [multip"..., 1024) = 654
3650  read(5, "", 1024)                 = 0
3650  close(5)                          = 0
3650  ioctl(4, STOP_ARRAY, 0)           = 0
3650  openat(AT_FDCWD, "/dev/md/r1_journal_big", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKSSZGET, [512])        = 0
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  ioctl(5, BLKGETSIZE64, [274742640640]) = 0
3650  lseek(5, 0, SEEK_SET)             = 0
3650  read(5, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(5, 0, SEEK_CUR)             = 4096
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x9, 0x7d), ...}) = 0
3650  close(5)                          = 0
3650  openat(AT_FDCWD, "/dev/sdi1", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKSSZGET, [512])        = 0
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x81), ...}) = 0
3650  ioctl(5, BLKGETSIZE64, [4000000000000]) = 0
3650  lseek(5, 0, SEEK_SET)             = 0
3650  read(5, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(5, 0, SEEK_CUR)             = 4096
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x81), ...}) = 0
3650  close(5)                          = 0
3650  openat(AT_FDCWD, "/dev/sdg1", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKSSZGET, [512])        = 0
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x61), ...}) = 0
3650  ioctl(5, BLKGETSIZE64, [4000000000000]) = 0
3650  lseek(5, 0, SEEK_SET)             = 0
3650  read(5, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(5, 0, SEEK_CUR)             = 4096
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x61), ...}) = 0
3650  close(5)                          = 0
3650  openat(AT_FDCWD, "/dev/sdj1", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKSSZGET, [512])        = 0
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x91), ...}) = 0
3650  ioctl(5, BLKGETSIZE64, [4000000000000]) = 0
3650  lseek(5, 0, SEEK_SET)             = 0
3650  read(5, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(5, 0, SEEK_CUR)             = 4096
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x91), ...}) = 0
3650  close(5)                          = 0
3650  openat(AT_FDCWD, "/dev/sdh1", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKSSZGET, [512])        = 0
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x71), ...}) = 0
3650  ioctl(5, BLKGETSIZE64, [4000000000000]) = 0
3650  lseek(5, 0, SEEK_SET)             = 0
3650  read(5, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(5, 0, SEEK_CUR)             = 4096
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x71), ...}) = 0
3650  close(5)                          = 0
3650  openat(AT_FDCWD, "/dev/sdg1", O_RDONLY|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKSSZGET, [512])        = 0
3650  fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0x61), ...}) = 0
3650  ioctl(5, BLKGETSIZE64, [4000000000000]) = 0
3650  lseek(5, 0, SEEK_SET)             = 0
3650  read(5, "\374N+\251\1\0\0\0\0\2\0\0\0\0\0\0\325\231]vg\327\372\275\59/\207%\251\32\227"..., 4096) = 4096
3650  lseek(5, 0, SEEK_CUR)             = 4096
3650  close(5)                          = 0
3650  fstat(4, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x7c), ...}) = 0
3650  readlink("/sys/dev/block/9:124", "../../devices/virtual/block/md12"..., 199) = 33
3650  stat("/sys/block/md124/md", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3650  fstat(4, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x7c), ...}) = 0
3650  readlink("/sys/dev/block/9:124", "../../devices/virtual/block/md12"..., 199) = 33
3650  mkdir("/run/mdadm", 0755)         = -1 EEXIST (File exists)
3650  openat(AT_FDCWD, "/run/mdadm/map.new", O_RDWR|O_CREAT, 0600) = 5
3650  fcntl(5, F_GETFL)                 = 0x8002 (flags O_RDWR|O_LARGEFILE)
3650  fstat(5, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
3650  write(5, "md124 1.1 765d99d5:bdfad767:872f"..., 252) = 252
3650  close(5)                          = 0
3650  rename("/run/mdadm/map.new", "/run/mdadm/map") = 0
3650  ioctl(4, SET_ARRAY_INFO, 0x7ffc70457950) = 0
3650  openat(AT_FDCWD, "/dev/sdh1", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=0, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=1, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=2, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=3, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=4, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=5, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=6, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=7, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=8, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=9, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=10, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=11, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=12, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=13, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=14, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=15, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  close(5)                          = 0
3650  ioctl(4, ADD_NEW_DISK, 0x55885c8e7cc8) = 0
3650  openat(AT_FDCWD, "/dev/sdi1", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=0, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=1, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=2, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=3, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=4, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=5, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=6, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=7, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=8, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=9, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=10, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=11, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=12, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=13, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=14, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=15, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  close(5)                          = 0
3650  ioctl(4, ADD_NEW_DISK, 0x55885c8e7710) = 0
3650  openat(AT_FDCWD, "/dev/sdj1", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=0, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=1, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=2, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=3, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=4, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=5, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=6, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=7, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=8, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=9, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=10, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=11, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=12, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=13, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=14, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=15, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  close(5)                          = 0
3650  ioctl(4, ADD_NEW_DISK, 0x55885c8e7ae0) = 0
3650  openat(AT_FDCWD, "/dev/md/r1_journal_big", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=0, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=1, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=2, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=3, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=4, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=5, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=6, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=7, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=8, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=9, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=10, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=11, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=12, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=13, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=14, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=15, devname="", volname=""}}) = -1 ENXIO (No such device or address)
3650  close(5)                          = 0
3650  ioctl(4, ADD_NEW_DISK, 0x55885c8e7528) = 0
3650  openat(AT_FDCWD, "/dev/sdg1", O_RDWR|O_EXCL|O_DIRECT) = 5
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=0, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=1, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=2, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=3, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=4, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=5, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=6, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=7, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=8, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=9, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=10, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=11, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=12, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=13, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=14, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  ioctl(5, BLKPG, {op=BLKPG_DEL_PARTITION, flags=0, datalen=152, data={start=0, length=0, pno=15, devname="", volname=""}}) = -1 EINVAL (Invalid argument)
3650  close(5)                          = 0
3650  ioctl(4, ADD_NEW_DISK, 0x55885c8e78f8) = 0
3650  ioctl(4, RUN_ARRAY
--------------17C2B7CF14F9B535DF170B03--
