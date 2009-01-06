From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Tue, 6 Jan 2009 05:48:04 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901060547270.19351@p34.internal.lan>
References: <bQVFb-3SB-37@gated-at.bofh.it> <bQVFb-3SB-39@gated-at.bofh.it> <bQVFb-3SB-41@gated-at.bofh.it> <bQVFc-3SB-43@gated-at.bofh.it> <bQVFc-3SB-45@gated-at.bofh.it> <bQVFc-3SB-47@gated-at.bofh.it> <bQVFb-3SB-35@gated-at.bofh.it>
 <4963306F.4060504@sm7jqb.se>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-326657234-1231238884=:19351"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4963306F.4060504@sm7jqb.se>
Sender: linux-raid-owner@vger.kernel.org
To: Bengt Samuelsson <bengt@sm7jqb.se>
Cc: debian-user@lists.debian.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-326657234-1231238884=:19351
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

cc: linux-ide, linux-raid

There was some talk about corruption on these chips I believe, hopefully=20
someone on the list can offer further insight.

On Tue, 6 Jan 2009, Bengt Samuelsson wrote:

> Justin Piszcz skrev:
>>=20
>>=20
>> On Mon, 5 Jan 2009, Bengt Samuelsson wrote:
>>=20
>>> Justin Piszcz skrev:
>>>>=20
>>>>=20
>>>> On Sun, 4 Jan 2009, Bengt Samuelsson wrote:
>>>>=20
>>>>> Bengt Samuelsson skrev:
>>>>>=20
>>>>> ~# mdadm -D /dev/md0
>>>>> ------------------------------
>>>>> /dev/md0:
>>>>>         Version : 00.90.03
>>>>>   Creation Time : Fri Sep 12 19:08:22 2008
>>>>>      Raid Level : raid5
>>>>>      Array Size : 1465151616 (1397.28 GiB 1500.32 GB)
>>>>>     Device Size : 488383872 (465.76 GiB 500.11 GB)
>>>>>    Raid Devices : 4
>>>>>   Total Devices : 4
>>>>> Preferred Minor : 0
>>>>>     Persistence : Superblock is persistent
>>>>>
>>>>>     Update Time : Fri Jan  2 16:53:10 2009
>>>>>           State : clean
>>>>>  Active Devices : 4
>>>>> Working Devices : 4
>>>>>  Failed Devices : 0
>>>>>   Spare Devices : 0
>>>>>
>>>>>          Layout : left-symmetric
>>>>>      Chunk Size : 128K
>>>>>
>>>>>            UUID : 68439662:90431c4a:5e66217b:5a1a585f (local to host=
=20
>>>>> sm7jqb.dnsalias.com)
>>>>>          Events : 0.13406
>>>>>
>>>>>     Number   Major   Minor   RaidDevice State
>>>>>        0       8        1        0      active sync   /dev/sda1
>>>>>        1       8       17        1      active sync   /dev/sdb1
>>>>>        2       8       33        2      active sync   /dev/sdc1
>>>>>        3       8       49        3      active sync   /dev/sdd1
>>>>> ------------------------------
>>>>>=20
>>>>>=20
>>>>>=20
>>>=20
>>>>> No memory error
>>>>>=20
>>>>> L1 Cache 128 7361MB/s
>>>>> L2 Cache 64k 3260MB/s
>>>>> Mem 1024M 275MB/s
>>>>>=20
>>>>> Next to check for?
>>>>>=20
>>>>> --=20
>>>>=20
>>>> You ran a check on the array and then checked mismatch_cnt?
>>> like
>>> ~# fsck.ext3 -y -v /dev/md0  ??
>>> You vant to se any log ??  I do not understand maybe?
>>> It works for 95% I want it to work 100%
>>>=20
>>> /var/log/fsck/ceheks
>>> Log of fsck -C -R -A -a
>>> Sun Jan  4 16:30:05 2009
>>>=20
>>> fsck 1.40-WIP (14-Nov-2006)
>>> /: clean, 21179/987712 files, 648652/1973160 blocks
>>> boot: clean, 30/32128 files, 22378/128488 blocks
>>> /dev/md0: clean, 142094/183156736 files, 23162450/366287904 blocks (che=
ck=20
>>> after next mount)
>>>=20
>>> Sun Jan  4 16:30:06 2009
>>> ----------------
>>>=20
>>> Can I se the sata_sil parameters?
>>> Or test something there?
>>> For me it shuld slow don a bit more.
>>>=20
>>>=20
>>>=20
>>=20
>> Run a check on the array:
>> p34:~# echo check > /sys/devices/virtual/block/md0/md/sync_action
>
> I found /sys/block/md0/md/sync_action
> idle
>
> I don't find 'check' i my box, but I run this every 2nd day, it help a bi=
t.
> /etc/cron.d/mdadm/
> ...
> 5 0 * * 1,3,5 root [ -x /usr/share/mdadm/checkarray ] \
> && /usr/share/mdadm/checkarray --cron --all --quiet
> ...
>
>> p34:~#
>>=20
>> Watch the status:
>> p34:~# cat /proc/mdstat
> ---
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sda1[0] sdd1[3] sdc1[2] sdb1[1]
>      1465151616 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]
>
> unused devices: <none>
> ---
>>=20
>> When its done, run:
>>=20
>> p34:~# cat /sys/devices/virtual/block/md0/md/mismatch_cnt
> /sys/block/md0/md/mismatch_cnt 0
>
>> p34:~#
>>=20
>> And show the output.
>>=20
>> Justin.
> I find
> /sys/module/sata_sil/parameter/slow_down
> 0
>
> and some more, all locks ok to me!
>
> My motherboard is KT7A-RAID (not using that raid)
> AMD 1.2Ghz
> I have a pdf manual.
>
> SATA kontroler board SA3114-4IR
> http://it.us.syba.com/product/43/02/05/index.html
>
> Now I have -3C and sunshine outside, I have to go out in the sun now!
>
> --=20
> Bengt Samuelsson
> Nydalav=E4gen 30 A
> 352 48 V=E4xj=F6
>
> +46(0)703686441
>
> http://sm7jqb.se
>
---1463747160-326657234-1231238884=:19351--
