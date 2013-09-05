From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Thu, 5 Sep 2013 11:03:14 +0200
Message-ID: <CAC9WiBgRiu_YL1TpzD4dtLXv=LiA-RERn+C6Q+i=P_WTNdw3+w@mail.gmail.com>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
	<20130904160832.3627bcb8@notabene.brown>
	<CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
	<20130905121123.27968f9f@notabene.brown>
	<CAC9WiBiHcS126iFv91250d83sMrBYmRbvoqYAEhjJWjb2p5J3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBiHcS126iFv91250d83sMrBYmRbvoqYAEhjJWjb2p5J3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 5, 2013 at 9:04 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hi Neil,
>
> On Thu, Sep 5, 2013 at 4:11 AM, NeilBrown <neilb@suse.de> wrote:
>> On Wed, 4 Sep 2013 09:36:27 +0200 Francis Moreau <francis.moro@gmail.com>
>> wrote:
>
> [...]
>
>>> no arrays to monitor... exiting
>>>
>>
>> The line
>>
>>> mdmon: ddf_open_new: subarray 0 doesn't exist
>>
>> is the problem.  mdmon read the metadata from the array but didn't find
>> subarray '0' in there even though the previous mdmon clearly did:
>>
>>> ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n
>>
>> This suggests that even though it succeeded in reading the metadata (it would
>> have printed
>>     Cannot load metadata for md127
>> and exited if it had), the metadata is somehow inconsistent.
>>
>> Could you trying running each mdmon under strace:
>>   strace -f -o /tmp/str-1 ./mddmon --takeover --all
>>
>> and attach the two /tmp/str-? files?
>
> This is weird: if I'm doing that the first strace process is put in a
> uninterruptible state at some point:
>
> # ps aux | grep dmon
> root      2297  0.1  0.0   4468   736 tty1     D+   08:39   0:00
> strace -f -o /tmp/str-1 ./mdmon --takeover --all
> root      2301  0.6  1.0  15156 11056 ?        SLsl 08:39   0:00
> ./mdmon --takeover md127
>
> Starting the second straced mdmon does the same result, and the system
> is becoming unusable as soon as it tries to write something to the
> disk/raid I guess.
>
> Note that /tmp on my system is not a tmpfs filesystem but is part of /
> which is ext4.
>
> I gave a second shot but this time I tried to put the strace output
> files on /dev/shm which is a tmpfs FS. This time I didn't have the
> issue describes above where strace is put in D state. But since after
> the second run of mdmon, there was no running mdmon process anymore,
> it was hard to retrieve the 2 strace output files.
>
> Anyways I'm attaching the 2 files now.
>
>>
>> Also what is the difference between
>>   mdadm --examine /dev/sda
>> and
>>   mdadm --examine /dev/sdb
>> ??
>>
>
> After the system finish booting:
>
> # diff -u sda sdb
> --- sda 2013-09-05 09:00:59.554291764 +0200
> +++ sdb 2013-09-05 09:01:01.634279757 +0200
> @@ -1,4 +1,4 @@
> -/dev/sda:
> +/dev/sdb:
>            Magic : de11de11
>          Version : 01.02.00
>  Controller GUID : 4C696E75:782D4D44:20202020:2020206C:6F63616C:686F7374
> @@ -23,5 +23,5 @@
>
>   Physical Disks : 2
>        Number    RefNo      Size       Device      Type/State
> -         0    2cf00056   2064384K /dev/sda        active/Online
> -         1    b342fbdc   2064384K                 active/Online
> +         0    2cf00056   2064384K                 active/Online
> +         1    b342fbdc   2064384K /dev/sdb        active/Online
>
> After starting the first mdmon process:
>
> # mdadm --examine /dev/sda >sda
> Segmentation fault
>
> It looks like mdadm is running an infinite loop or something before segfaulting.
>

I don't know if that can help but it seems to start failing here:

# strace ./mdadm --examine /dev/sda
...
write(2, "mdmon: Failed to load secondary "..., 55) = 55
lseek(3, 2130706944, SEEK_SET)    = 2130706944
read(3, "\336\21\336\21\262@8\360Linux-MD\336\255\276\357\0\0\0\0?O\2672\2045b="...,
512) = 512
lseek(3, 2130707456, SEEK_SET)    = 2130707456
read(3, "\255\21\21\21etx\241Linux-MD       localhost"..., 65536) = 65536
lseek(3, 2130772992, SEEK_SET)    = 2130772992
read(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"...,
16384) = 16384
lseek(3, 2131022336, SEEK_SET)    = 2131022336
read(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"...,
512) = 512
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 0), ...}) = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 0), ...}) = 0
ioctl(3, BLKGETSIZE64, 2147483648) = 0
lseek(3, 2130789376, SEEK_SET)    = 2130789376
read(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"...,
232960) = 232960
close(3)                          = 0
fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(4, 64), ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
TCGETS, {B9600 opost isig icanon echo ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7fcc26b80000
write(1, "/dev/sda:\n", 10)       = 10
write(1, "          Magic : de11de11\n", 27) = 27
write(1, "        Version : 01.02.00\n", 27) = 27
write(1, "Controller GUID : 4C696E75:782D4"..., 72) = 72
write(1, "                  (Linux-MD)\n", 29) = 29
write(1, " Container GUID : 4C696E75:782D4"..., 72) = 72
open("/etc/localtime", O_RDONLY)  = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2945, ...}) = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=2945, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7fcc26b7f000
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\f\0\0\0\f\0\0\0\0"...,
4096) = 2945
lseek(3, -1863, SEEK_CUR)         = 1082
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r\0\0\0\r\0\0\0\0"...,
4096) = 1863
lseek(3, 2944, SEEK_SET)          = 2944
close(3)                          = 0
munmap(0x7fcc26b7f000, 4096)      = 0
write(1, "                  (Linux-MD 08/2"..., 47) = 47
write(1, "            Seq : 00000016\n", 27) = 27
write(1, "  Redundant hdr : no\n", 21) = 21
write(1, "  Virtual Disks : 65535\n", 24) = 24
write(1, "\n", 1)                 = 1
write(1, "      VD GUID[7] : DDDDDDDD:0FDC"..., 73) = 73
stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2945, ...}) = 0
write(1, "                  ( 01/01/80 00:"..., 39) = 39
write(1, "         unit[7] : 65535\n", 25) = 25
write(1, "        state[7] : -reserved-, M"..., 56) = 56
write(1, "   init state[7] : *UNKNOWN*\n", 29) = 29
write(1, "       access[7] : Blocked (no a"..., 39) = 39
write(1, "         Name[7] :
\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 36) = 36
write(1, "\n", 1)                 = 1
write(1, "      VD GUID[8] : 4C696E75:782D"..., 73) = 73
stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2945, ...}) = 0
write(1, "                  (Linux-MD 08/2"..., 47) = 47
write(1, "         unit[8] : 126\n", 23) = 23
write(1, "        state[8] : Optimal, Not "..., 43) = 43
write(1, "   init state[8] : Fully Initial"..., 37) = 37
write(1, "       access[8] : Read/Write\n", 30) = 30
write(1, "         Name[8] : array1\n", 26) = 26
write(1, "\n", 1)                 = 1



-- 
Francis
