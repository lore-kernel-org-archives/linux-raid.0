From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Odd (slow) RAID performance
Date: Sat, 02 Dec 2006 00:27:56 -0500
Message-ID: <45710EDC.9050805@tmr.com>
References: <456F4872.2090900@tmr.com> <20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Lucas <roger@planbit.co.uk>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Roger Lucas wrote:
>> Roger Lucas wrote:
>>>>> What drive configuration are you using (SCSI / ATA / SATA), what
>> chipset
>>>> is
>>>>
>>>>> providing the disk interface and what cpu are you running with?
>>>>>
>>>> 3xSATA, Seagate 320 ST3320620AS, Intel 6600, ICH7 controller using the
>>>> ata-piix driver, with drive cache set to write-back. It's not obvious
>> to
>>>> me why that matters, but if it helps you see the problem I''m glad to
>>>> provide the info. I'm seeing ~50MB/s on the raw drive, and 3x that on
>>>> plain stripes, so I'm assuming that either the RAID-5 code is not
>>>> working well or I haven't set it up optimally.
>>>>
>>> If it had been ATA, and you had two drives as master+slave on the same
>>> cable, then they would be fast individually but slow as a pair.
>>>
>>> RAID-5 is higher overhead than RAID-0/RAID-1 so if your CPU was slow
>> then
>>> you would see some degradation from that too.
>>>
>>> We have similar hardware here so I'll run some tests here and see what I
>>> get...
>> Much appreciated. Since my last note I tried adding --bitmap=internal to
>> the array. Bot is that a write performance killer. I will have the chart
>> updated in a minute, but write dropped to ~15MB/s with bitmap. Since
>> Fedora can't seem to shut the last array down cleanly, I get a rebuild
>> on every boot :-( So the array for the LVM has bitmap on, as I hate to
>> rebuild 1.5TB regularly. Have to do some compromises on that!
>>
> 
> Hi Bill,
> 
> Here are the results of my tests here:
> 
> 	CPU: Intel Celetron 2.7GHz socket 775
> 	MB:  Abit LG-81 (Lakeport ICH7 chipset)
> 	HDD: 4 x Seagate SATA ST3160812AS (directly connected to ICH7)
> 	OS:  Linux 2.6.16-xen
> 
> root@hydra:~# uname -a
> Linux hydra 2.6.16-xen #1 SMP Thu Apr 13 18:46:07 BST 2006 i686 GNU/Linux
> root@hydra:~#
> 
> All four disks are built into a RAID-5 array to provide ~420GB real storage.
> Most of this is then used by the other Xen virtual machines but there is a
> bit of space left on this server to play with in the Dom-0.
> 
> I wasn't able to run I/O tests with "dd" on the disks themselves as I don't
> have a spare partition to corrupt, but hdparm gives:
> 
> root@hydra:~# hdparm -tT /dev/sda
> 
> /dev/sda:
>  Timing cached reads:   3296 MB in  2.00 seconds = 1648.48 MB/sec
>  Timing buffered disk reads:  180 MB in  3.01 seconds =  59.78 MB/sec
> root@hydra:~#
> 
> Which is exactly what I would expect as this is the performance limit of the
> disk.  We have a lot of ICH7/ICH7R-based servers here and all can run the
> disk at their maximum physical speed without problems.
> 
> root@hydra:~# cat /proc/mdstat
> Personalities : [raid5] [raid4]
> md0 : active raid5 sda2[0] sdd2[3] sdc2[2] sdb2[1]
>       468647808 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> unused devices: <none>
> root@hydra:~# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/bigraid-root
>                        10G  1.3G  8.8G  13% /
> <snip>
> root@hydra:~# vgs
>   VG      #PV #LV #SN Attr   VSize   VFree
>   bigraid   1  13   0 wz--n- 446.93G 11.31G
> root@hydra:~# lvcreate --name testspeed --size 2G bigraid
>   Logical volume "testspeed" created
> root@hydra:~#
> 
> *** Now for the LVM over RAID-5 read/write tests ***
> 
> root@hydra:~# sync; time bash -c "dd if=/dev/zero bs=1024k count=2048
> of=/dev/bigraid/testspeed; sync"
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 33.7345 seconds, 63.7 MB/s
> 
> real    0m34.211s
> user    0m0.020s
> sys     0m2.970s
> root@hydra:~# sync; time bash -c "dd of=/dev/zero bs=1024k count=2048
> if=/dev/bigraid/testspeed; sync"
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 38.1175 seconds, 56.3 MB/s
> 
> real    0m38.637s
> user    0m0.010s
> sys     0m3.260s
> root@hydra:~#
> 
> During the above two tests, the CPU showed about 35% idle using "top".
> 
> *** Now for the file system read/write tests ***
>    (Reiser over LVM over RAID-5)
> 
> root@hydra:~# mount
> /dev/mapper/bigraid-root on / type reiserfs (rw)
> <snip>
> root@hydra:~#
> 
> 
> root@hydra:~# sync; time bash -c "dd if=/dev/zero bs=1024k count=2048
> of=~/testspeed; sync"
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 29.8863 seconds, 71.9 MB/s
> 
> real    0m32.289s
> user    0m0.000s
> sys     0m4.440s
> root@hydra:~# sync; time bash -c "dd of=/dev/null bs=1024k count=2048
> if=~/testspeed; sync"
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 40.332 seconds, 53.2 MB/s
> 
> real    0m40.973s
> user    0m0.010s
> sys     0m2.640s
> root@hydra:~#
> 
> During the above two tests, the CPU showed between 0% and 30% idle using
> "top".
> 
> Just for curiousity, I started the RAID-5 check process to see what load it
> generated...
> 
> root@hydra:~# cat /sys/block/md0/md/mismatch_cnt
> 0
> root@hydra:~# echo check > /sys/block/md0/md/sync_action
> root@hydra:~# cat /sys/block/md0/md/sync_action
> check
> root@hydra:~# cat /proc/mdstat
> Personalities : [raid5] [raid4]
> md0 : active raid5 sda2[0] sdd2[3] sdc2[2] sdb2[1]
>       468647808 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
>       [>....................]  resync =  1.0% (1671552/156215936)
> finish=101.8min speed=25292K/sec
> 
> unused devices: <none>
> root@hydra:~#
> 
> Whilst the above test was running, the CPU load was between 3% and 7%, so
> running the RAID array isn't that hard for it...
> 
> -------------------------
> 
> So, using a 4-disk RAID-5 array with an ICH7, I get about 64M write and 54MB
> read prformance.  The processor is about 35% idle whilst the test is running
> - I'm not sure why this is, I would have expected the processor load to be
> 0% idle as it should be hitting the hard disk as fast as possible and
> waiting for it otherwise....
> 
> If I run over Reiser, the processor load changes a lot more, varying between
> 0% and 35% idle.  It also takes a couple of seconds after the test has
> finished before the load drops down to zero on the write test, so I suspect
> these results are basically the same as the raw LVM-over-RAID5 performance.
> 
> Summary - it is a little faster with 4 disks rather than the 37.5 MB/s that
> you have with just the three, but it is WAY off the theoretical target of
> 3x60MB = 180MB that could be expected given that you are running a 4-disk
> RAID-5 array.
>  
> On the flip side, the performance is good enough for me, so it is not
> causing me a problem, but it seems that there should be a performance boost
> available somewhere!
> 
> Best regards,
> 
> Roger

Thank you so much for verifying this. I do keep enough room on my drives 
to run tests by creating any kind of whatever I need, but the point is 
clear: with N drives striped the transfer rate is N x base rate of one 
drive; with RAID-5 it is about the speed of one drive, suggesting that 
the md code serializes writes.

If true, BOO, HISS!

Can you explain and educate us, Neal? This look like terrible performance.

-- 
Bill Davidsen
   He was a full-time professional cat, not some moonlighting
ferret or weasel. He knew about these things.
