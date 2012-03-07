From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: Adding a disk to RAID0
Date: Wed, 07 Mar 2012 16:59:12 +0200
Message-ID: <4F5777C0.7020805@oldum.net>
References: <4F4D6493.3030300@ubc.ca> <4F554DB3.8080203@ubc.ca> <20120306122109.73cd065e@notabene.brown> <4F56613C.8070007@ubc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F56613C.8070007@ubc.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Victor Balakine <victor.balakine@ubc.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Victor,
The exact same behavior on my machine:

http://marc.info/?l=linux-raid&m=132757440920831&w=2


Cheers,
- -Nik

On 03/06/2012 09:10 PM, Victor Balakine wrote:
> # cat /proc/1506/stack
> [<ffffffff8003a1e5>] __cond_resched+0x25/0x40
> [<ffffffffa0102ebf>] raid5d+0x26f/0x3d0 [raid456]
> [<ffffffff803c7a36>] md_thread+0x106/0x140
> [<ffffffff8006444e>] kthread+0x7e/0x90
> [<ffffffff80510d24>] kernel_thread_helper+0x4/0x10
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> And this is what I see on system console
> [  411.331287] md: bind<xvda2>
> [  411.353737] md: raid0 personality registered for level 0
> [  411.354362] bio: create slab <bio-1> at 1
> [  411.354377] md/raid0:md0: looking at xvda2
> [  411.354382] md/raid0:md0:   comparing xvda2(8386560) with xvda2(8386560)
> [  411.354389] md/raid0:md0:   END
> [  411.354393] md/raid0:md0:   ==> UNIQUE
> [  411.354397] md/raid0:md0: 1 zones
> [  411.354400] md/raid0:md0: FINAL 1 zones
> [  411.354409] md/raid0:md0: done.
> [  411.354414] md/raid0:md0: md_size is 8386560 sectors.
> [  411.354418] ******* md0 configuration *********
> [  411.354424] zone0=[xvda2/]
> [  411.354430]         zone offset=0kb device offset=0kb size=4193280kb
> [  411.354434] **********************************
> [  411.354436]
> [  411.354451] md0: detected capacity change from 0 to 4293918720
> [  411.372921]  md0: p1
> [  434.228901] md/raid:md0: device xvda2 operational as raid disk 0
> [  434.229104] md/raid:md0: allocated 2176kB
> [  434.229159] md/raid:md0: raid level 4 active with 1 out of 2 devices, algorithm 5
> [  434.306479] md: bind<xvda3>
> [  434.405827] md: reshape of RAID array md0
> [  434.405839] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [  434.405844] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> [  434.405851] md: using 128k window, over a total of 4193280k.
> 
> And a little while later:
> [  960.220050] INFO: task md0_reshape:1508 blocked for more than 480 seconds.
> [  960.220068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  960.220077] md0_reshape     D 0000000000000000     0  1508      2 0x00000000
> [  960.220087]  ffff88001e69fbc0 0000000000000246 ffff88001e10c1c0 ffffffffa0100c45
> [  960.220097]  ffff88001e69ffd8 ffff88001e10c1c0 ffff88001e69ffd8 ffff88001e10c1c0
> [  960.220106]  ffff88001e038440 ffff88001e10c1c0 0000000000000001 0000000000000000
> [  960.220119] Call Trace:
> [  960.220141]  [<ffffffffa0101f6d>] reshape_request+0x57d/0x930 [raid456]
> [  960.220165]  [<ffffffffa010266e>] sync_request+0x23e/0x2c0 [raid456]
> [  960.220183]  [<ffffffff803cae48>] md_do_sync+0x748/0xd10
> [  960.220194]  [<ffffffff803c7a36>] md_thread+0x106/0x140
> [  960.220204]  [<ffffffff8006444e>] kthread+0x7e/0x90
> [  960.220216]  [<ffffffff80510d24>] kernel_thread_helper+0x4/0x10
> 
> Victor
> 
> On 2012-03-05 17:21, NeilBrown wrote:
>> On Mon, 05 Mar 2012 15:35:15 -0800 Victor Balakine<victor.balakine@ubc.ca>
>> wrote:
>>
>>> Am I the only one having problem adding disks to RAID0? Has anybody
>>> tried that on 3.* kernel?
>>
>> Strange.  It works for me.
>>
>> We need to find out what the md0_raid0 process is doing.
>> Can you
>>     cat /proc/PROCESSID/stack
>>
>> and see what that shows?
>>
>> NeilBrown
>>
>>
>>>
>>> Victor
>>>
>>> On 2012-02-28 15:34, Victor Balakine wrote:
>>>> I am trying to add another disk to RAID0 and this functionality appears
>>>> to be broken.
>>>> First I create a RAID0 array:
>>>> #mdadm --create /dev/md0 --level=0 --raid-devices=1 --force /dev/xvda2
>>>> mdadm: Defaulting to version 1.2 metadata
>>>> mdadm: array /dev/md0 started.
>>>>
>>>> So far everything works fine. Then I add another disk to it:
>>>> #mdadm --grow /dev/md0 --raid-devices=2 --add /dev/xvda3
>>>> --backup-file=/backup-md0
>>>> mdadm: level of /dev/md0 changed to raid4
>>>> mdadm: added /dev/xvda3
>>>> mdadm: Need to backup 1024K of critical section..
>>>>
>>>> This is what I see in /var/log/messages
>>>> Feb 28 15:03:30 storage kernel: [ 1420.174022] md: bind<xvda2>
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209167] md: raid0 personality
>>>> registered for level 0
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209818] bio: create slab<bio-1>
>>>> at 1
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209832] md/raid0:md0: looking at
>>>> xvda2
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209837] md/raid0:md0: comparing
>>>> xvda2(8386560) with xvda2(8386560)
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209844] md/raid0:md0: END
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209851] md/raid0:md0: ==>  UNIQUE
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209856] md/raid0:md0: 1 zones
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209859] md/raid0:md0: FINAL 1 zones
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209866] md/raid0:md0: done.
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209870] md/raid0:md0: md_size is
>>>> 8386560 sectors.
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209875] ******* md0 configuration
>>>> *********
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209879] zone0=[xvda2/]
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209885] zone offset=0kb device
>>>> offset=0kb size=4193280kb
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209902]
>>>> **********************************
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209903]
>>>> Feb 28 15:03:30 storage kernel: [ 1420.209919] md0: detected capacity
>>>> change from 0 to 4293918720
>>>> Feb 28 15:03:30 storage kernel: [ 1420.223968] md0: p1
>>>> ...
>>>> Feb 28 15:04:01 storage kernel: [ 1450.783016] async_tx: api initialized
>>>> (async)
>>>> Feb 28 15:04:01 storage kernel: [ 1450.796912] xor: automatically using
>>>> best checksumming function: generic_sse
>>>> Feb 28 15:04:01 storage kernel: [ 1450.816012] generic_sse: 9509.000 MB/sec
>>>> Feb 28 15:04:01 storage kernel: [ 1450.816021] xor: using function:
>>>> generic_sse (9509.000 MB/sec)
>>>> Feb 28 15:04:01 storage kernel: [ 1450.912021] raid6: int64x1 1888 MB/s
>>>> Feb 28 15:04:01 storage kernel: [ 1450.980013] raid6: int64x2 2707 MB/s
>>>> Feb 28 15:04:01 storage kernel: [ 1451.048025] raid6: int64x4 2073 MB/s
>>>> Feb 28 15:04:01 storage kernel: [ 1451.116039] raid6: int64x8 2010 MB/s
>>>> Feb 28 15:04:01 storage kernel: [ 1451.184017] raid6: sse2x1 4764 MB/s
>>>> Feb 28 15:04:01 storage kernel: [ 1451.252018] raid6: sse2x2 5170 MB/s
>>>> Feb 28 15:04:01 storage kernel: [ 1451.320016] raid6: sse2x4 7548 MB/s
>>>> Feb 28 15:04:01 storage kernel: [ 1451.320025] raid6: using algorithm
>>>> sse2x4 (7548 MB/s)
>>>> Feb 28 15:04:01 storage kernel: [ 1451.330136] md: raid6 personality
>>>> registered for level 6
>>>> Feb 28 15:04:01 storage kernel: [ 1451.330145] md: raid5 personality
>>>> registered for level 5
>>>> Feb 28 15:04:01 storage kernel: [ 1451.330149] md: raid4 personality
>>>> registered for level 4
>>>> Feb 28 15:04:01 storage kernel: [ 1451.330662] md/raid:md0: device xvda2
>>>> operational as raid disk 0
>>>> Feb 28 15:04:01 storage kernel: [ 1451.330820] md/raid:md0: allocated
>>>> 2176kB
>>>> Feb 28 15:04:01 storage kernel: [ 1451.330869] md/raid:md0: raid level 4
>>>> active with 1 out of 2 devices, algorithm 5
>>>> Feb 28 15:04:01 storage kernel: [ 1451.330874] RAID conf printout:
>>>> Feb 28 15:04:01 storage kernel: [ 1451.330876] --- level:4 rd:2 wd:1
>>>> Feb 28 15:04:01 storage kernel: [ 1451.330878] disk 0, o:1, dev:xvda2
>>>> Feb 28 15:04:01 storage kernel: [ 1451.417995] md: bind<xvda3>
>>>> Feb 28 15:04:01 storage kernel: [ 1451.616399] RAID conf printout:
>>>> Feb 28 15:04:01 storage kernel: [ 1451.616404] --- level:4 rd:3 wd:2
>>>> Feb 28 15:04:01 storage kernel: [ 1451.616408] disk 0, o:1, dev:xvda2
>>>> Feb 28 15:04:01 storage kernel: [ 1451.616411] disk 1, o:1, dev:xvda3
>>>> Feb 28 15:04:01 storage kernel: [ 1451.619054] md: reshape of RAID array
>>>> md0
>>>> Feb 28 15:04:01 storage kernel: [ 1451.619066] md: minimum _guaranteed_
>>>> speed: 1000 KB/sec/disk.
>>>> Feb 28 15:04:01 storage kernel: [ 1451.619069] md: using maximum
>>>> available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
>>>> Feb 28 15:04:01 storage kernel: [ 1451.619075] md: using 128k window,
>>>> over a total of 4193280k.
>>>> Feb 28 15:05:02 storage udevd[280]: timeout '/sbin/blkid -o udev -p
>>>> /dev/md0'
>>>> Feb 28 15:05:03 storage udevd[280]: timeout: killing '/sbin/blkid -o
>>>> udev -p /dev/md0' [1829]
>>>> Feb 28 15:05:04 storage udevd[280]: timeout: killing '/sbin/blkid -o
>>>> udev -p /dev/md0' [1829]
>>>> Feb 28 15:05:05 storage udevd[280]: timeout: killing '/sbin/blkid -o
>>>> udev -p /dev/md0' [1829]
>>>>
>>>> And then it just goes on forever. md0_raid0 process stays at 100% CPU load.
>>>> # ps -ef | grep md0
>>>> root 7268 2 99 09:34 ? 05:53:00 [md0_raid0]
>>>> root 7270 2 0 09:34 ? 00:00:00 [md0_reshape]
>>>> root 7271 1 0 09:34 pts/0 00:00:00 mdadm --grow /dev/md0
>>>> --raid-devices=2 --add /dev/sdc1 --backup-file=/backup-md0
>>>>
>>>> # cat /proc/mdstat
>>>> Personalities : [raid0] [raid6] [raid5] [raid4]
>>>> md0 : active raid4 xvda3[2] xvda2[0]
>>>> 4193280 blocks super 1.2 level 4, 512k chunk, algorithm 5 [3/1] [U__]
>>>> resync=DELAYED
>>>>
>>>> unused devices:<none>
>>>>
>>>> # mdadm --version
>>>> mdadm - v3.2.2 - 17th June 2011
>>>> # uname -a
>>>> Linux storage 3.1.9-1.4-xen #1 SMP Fri Jan 27 08:55:10 UTC 2012
>>>> (efb5ff4) x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>> It's OpenSUSE 12.1 with all the latest updates running in XEN that I
>>>> created to reproduce the problem. The actual server is running the same
>>>> version of OpenSUSE (Linux san1 3.1.9-1.4-desktop #1 SMP PREEMPT Fri Jan
>>>> 27 08:55:10 UTC 2012 (efb5ff4) x86_64 x86_64 x86_64 GNU/Linux) on a
>>>> hardware server. If you need any more information I can easily get it
>>>> since it's a VM and the problem is easily reproducible.
>>>>
>>>> Victor
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPV3fAAAoJEDFLYVOGGjgXE8IIAJ0DFKP/1waMvxUEYO41LXL2
VcEYl/+yMN7VXV5Pp+Y62IPjyS2ty/EKZhVn9f7uw/PTwL19yiBZcUuxtcRIg8W/
YyVf5boX7L6bfd2+2qnvSVnzaajA612ZkOZutd3DekpMDqb7EEag1CaavLav+ulL
Yt4+OVunJKzJRHoNn4GQ4AlSaW0P2RN0qVFW/grDPGATVaJYNxg75WHgblaJIO16
1DMt30jM7T3jC6F6DQd/h7gSdUJgdSkZPnGHjFBwN9UH+v8N1N2XRikDhpquQ+Nq
2PO/LYUO5eMWR9fBcysTv+4WPaIFNyq5fPJ/MHvMEEHOANj9298bf3k2v71iwwc=
=n8pl
-----END PGP SIGNATURE-----
