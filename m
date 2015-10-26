From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Converting 4 disk RAID10 to RAID5
Date: Tue, 27 Oct 2015 10:55:04 +1100
Message-ID: <562EBD58.2040306@websitemanagers.com.au>
References: <562D8142.80507@websitemanagers.com.au>
 <562E345D.5030206@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562E345D.5030206@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/10/15 01:10, Phil Turmel wrote:
> Good morning Adam,
>
> On 10/25/2015 09:26 PM, Adam Goryachev wrote:
>> Hi all,
>>
>> I'm trying to convert a 4 disk RAID10 to a RAID5. Currently I have:
>> cat /proc/mdstat
>> Personalities : [raid10]
>> md0 : active raid10 sdd1[2] sdc1[1] sdb1[0] sde1[3]
>>        7813772288 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>>        bitmap: 0/59 pages [0KB], 65536KB chunk
> [trim /]
>
> Your plan looks reasonable, if a bit long.  I've done similar before.
> Usually I add the new array to the LVM volume group of the original,
> then pvmove the contents to the new physical volume.  Let's me stay
> online through the entire operation.
>
> Anyways, it seems you are missing an opportunity to convert in place,
> though.  Consider setting up four small loop devices and test
> conversions from r10,n2 -n4 => r0 -n3 => r4 -n4 => r5 -n4 .  I suspect
> you can get to your new raid5 without moving a bunch of data around.

This sounds interesting, I'm just messing around with a VM at the 
moment, but I'm not sure I understand your shorthand?

Currently, I have raid10 with 4 devices
I can convert to raid0 with 2 devices
mdadm --grow --level=0 --raid-devices=2 /dev/md0
md0 : active raid0 vde1[2] vdc1[0]
       2093056 blocks super 1.2 512k chunks
       bitmap: 1/1 pages [4KB], 65536KB chunk

So then I tried to add the other two drives back:
mdadm --manage /dev/md0 --add /dev/vdd1
mdadm: add new device failed for /dev/vdd1 as 3: Invalid argument
That failed, raid0 doesn't allow spares, because there is nothing for 
them to "do".

So I tried jumping to raid5:
mdadm --grow --level=5 --raid-devices=4 /dev/md0 /dev/vdd1 /dev/vdf1
mdadm: Must give -a/--add for devices to add: /dev/vdd1
OK, I was just guessing...
mdadm --grow --level=5 --raid-devices=4 /dev/md0 -a /dev/vdd1 -a /dev/vdf1
mdadm: level of /dev/md0 changed to raid5
mdadm: added /dev/vdd1
mdadm: added /dev/vdf1
mdadm: Need to backup 3072K of critical section..
mdadm: Cannot set device shape for /dev/md0
        Bitmap must be removed before shape can be changed
unfreeze

Oh, alrighty... but wait, what did it actually do?
cat /proc/mdstat
Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
md0 : active raid5 vdf1[4] vdd1[3](S) vde1[2] vdc1[0]
       2093056 blocks super 1.2 level 5, 512k chunk, algorithm 5 [3/3] [UUU]
       bitmap: 1/1 pages [4KB], 65536KB chunk

Interesting, it has changed to a three disk RAID5 without removing the 
bitmap, only adding the 4th disk seems to need that.

mdadm --grow --bitmap=none /dev/md0
root@testraid:~# cat /proc/mdstat
Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
md0 : active raid5 vdf1[4] vdd1[3](S) vde1[2] vdc1[0]
       2093056 blocks super 1.2 level 5, 512k chunk, algorithm 5 [3/3] [UUU]

unused devices: <none>

So, still 3 disk raid5 with one spare, but seems to be insync, so either 
it was really quick (possible since they are small drives) or it didn't 
need to do a sync??

mdadm --grow --level=5 --raid-devices=4 /dev/md0
mdadm: Need to backup 3072K of critical section..

cat /proc/mdstat
Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
md0 : active raid5 vdf1[4] vdd1[3] vde1[2] vdc1[0]
       2093056 blocks super 1.2 level 5, 512k chunk, algorithm 5 [4/4] 
[UUUU]
           resync=DELAYED

unused devices: <none>

OK, so now how to make it resync?

Here I'm stuck...
I've tried:
mdadm --misc /dev/md0 --action=check
mdadm --misc /dev/md0 --action=repair

Nothing seems to be happening.

BTW, I had the array mounted during my testing, as ideally that is what 
I will do with the live machine. Worst case scenario (on the live 
machine) I can afford to lose all the data, as it is only an extra 
backup of the other backup machine, but it would mean a few TB's of data 
across a slow WAN....

Any suggestions on getting this to progress? Did I do something wrong?

Thanks for the suggestion, it certainly looks promising so far.

PS test machine is running:
mdadm - v3.3.2 - 21st August 2014
Linux testraid 3.2.0-4-amd64 #1 SMP Debian 3.2.65-1+deb7u2 x86_64 GNU/Linux

Relevant sections from dmesg:
[  582.456118] md/raid10:md0: Disk failure on vdd1, disabling device.
[  582.456119] md/raid10:md0: Operation continuing on 3 devices.
[  582.459135] RAID10 conf printout:
[  582.459137]  --- wd:3 rd:4
[  582.459138]  disk 0, wo:0, o:1, dev:vdc1
[  582.459140]  disk 1, wo:1, o:0, dev:vdd1
[  582.459141]  disk 2, wo:0, o:1, dev:vde1
[  582.459142]  disk 3, wo:0, o:1, dev:vdf1
[  582.459144] RAID10 conf printout:
[  582.459145]  --- wd:3 rd:4
[  582.459146]  disk 0, wo:0, o:1, dev:vdc1
[  582.459147]  disk 2, wo:0, o:1, dev:vde1
[  582.459148]  disk 3, wo:0, o:1, dev:vdf1
[  582.459174] md: unbind<vdd1>
[  582.459178] md: export_rdev(vdd1)
[  582.460851] md/raid10:md0: Disk failure on vdf1, disabling device.
[  582.460852] md/raid10:md0: Operation continuing on 2 devices.
[  582.463685] RAID10 conf printout:
[  582.463687]  --- wd:2 rd:4
[  582.463689]  disk 0, wo:0, o:1, dev:vdc1
[  582.463700]  disk 2, wo:0, o:1, dev:vde1
[  582.463702]  disk 3, wo:1, o:0, dev:vdf1
[  582.463703] RAID10 conf printout:
[  582.463704]  --- wd:2 rd:4
[  582.463705]  disk 0, wo:0, o:1, dev:vdc1
[  582.463706]  disk 2, wo:0, o:1, dev:vde1
[  582.463731] md: unbind<vdf1>
[  582.463734] md: export_rdev(vdf1)
[  661.433432] md: raid0 personality registered for level 0
[  661.433775] md0: bitmaps are not supported for raid0
[ 1999.023095] md0: personality does not support diskops!
[ 1999.123016] md0: personality does not support diskops!
[ 1999.275905] md0: personality does not support diskops!
[ 1999.312123] md0: personality does not support diskops!
[ 2164.827683] async_tx: api initialized (async)
[ 2164.828731] xor: automatically using best checksumming function: 
generic_sse
[ 2164.848017]    generic_sse:  3623.000 MB/sec
[ 2164.848019] xor: using function: generic_sse (3623.000 MB/sec)
[ 2164.916020] raid6: int64x1   1743 MB/s
[ 2164.984015] raid6: int64x2   2248 MB/s
[ 2165.052028] raid6: int64x4   2537 MB/s
[ 2165.120021] raid6: int64x8   2143 MB/s
[ 2165.188010] raid6: sse2x1    6819 MB/s
[ 2165.256011] raid6: sse2x2    8521 MB/s
[ 2165.324014] raid6: sse2x4    9659 MB/s
[ 2165.324015] raid6: using algorithm sse2x4 (9659 MB/s)
[ 2165.328986] md: raid6 personality registered for level 6
[ 2165.328991] md: raid5 personality registered for level 5
[ 2165.328993] md: raid4 personality registered for level 4
[ 2165.329357] md/raid:md0: device vde1 operational as raid disk 1
[ 2165.329361] md/raid:md0: device vdc1 operational as raid disk 0
[ 2165.330125] md/raid:md0: allocated 3228kB
[ 2165.331574] md/raid:md0: raid level 5 active with 2 out of 3 devices, 
algorithm 5
[ 2165.332646] RAID conf printout:
[ 2165.332648]  --- level:5 rd:3 wd:2
[ 2165.332651]  disk 0, o:1, dev:vdc1
[ 2165.332653]  disk 1, o:1, dev:vde1
[ 2165.355069] md: bind<vdd1>
[ 2165.364753] md: bind<vdf1>
[ 2165.389506] md/raid0:md0: bad disk number -1 - aborting!
[ 2165.389849] md: md0: raid0 would not accept array
[ 2165.390051] RAID conf printout:
[ 2165.390053]  --- level:5 rd:3 wd:2
[ 2165.390054]  disk 0, o:1, dev:vdc1
[ 2165.390055]  disk 1, o:1, dev:vde1
[ 2165.390056]  disk 2, o:1, dev:vdf1
[ 2165.390061] RAID conf printout:
[ 2165.390062]  --- level:5 rd:3 wd:2
[ 2165.390063]  disk 0, o:1, dev:vdc1
[ 2165.390064]  disk 1, o:1, dev:vde1
[ 2165.390065]  disk 2, o:1, dev:vdf1
[ 2165.390960] md: recovery of RAID array md0
[ 2165.390962] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 2165.390963] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[ 2165.390973] md: using 128k window, over a total of 1046528k.
[ 2176.293108] md: md0: recovery done.
[ 2176.306088] RAID conf printout:
[ 2176.306091]  --- level:5 rd:3 wd:3
[ 2176.306092]  disk 0, o:1, dev:vdc1
[ 2176.306094]  disk 1, o:1, dev:vde1
[ 2176.306095]  disk 2, o:1, dev:vdf1
[ 2214.230914] RAID conf printout:
[ 2214.230920]  --- level:5 rd:4 wd:4
[ 2214.230923]  disk 0, o:1, dev:vdc1
[ 2214.230926]  disk 1, o:1, dev:vde1
[ 2214.230929]  disk 2, o:1, dev:vdf1
[ 2214.230931]  disk 3, o:1, dev:vdd1
[ 2214.235161] md: reshape of RAID array md0
[ 2214.235164] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 2214.235167] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for reshape.
[ 2214.235186] md: using 128k window, over a total of 1046528k.



Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
