From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Growing RAID5 SSD Array
Date: Mon, 17 Mar 2014 16:43:35 +1100
Message-ID: <53268B87.4060203@websitemanagers.com.au>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53219D4C.2020207@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/03/14 22:58, Stan Hoeppner wrote:
> On 3/12/2014 9:49 PM, Adam Goryachev wrote:
> ...
>>      Number   Major   Minor   RaidDevice State
>>         7       8       33        0      active sync   /dev/sdc1
>>         6       8        1        1      active sync   /dev/sda1
>>         8       8       49        2      active sync   /dev/sdd1
>>         5       8       81        3      active sync   /dev/sdf1
>>         9       8       65        4      active sync   /dev/sde1
> ...
>> /dev/sda	Total_LBAs_Written	845235
>> /dev/sdc	Total_LBAs_Written      851335
>> /dev/sdd	Total_LBAs_Written      804564
>> /dev/sde	Total_LBAs_Written	719767
>> /dev/sdf	Total_LBAs_Written      719982
> ...
>> So the drive with the highest writes 851335 and the drive with the
>> lowest writes 719982 show a big difference. Perhaps I have a problem
>> with the setup/config of my array, or similar?
> This is normal for striped arrays.  If we reorder your write statistics
> table to reflect array device order, we can clearly see the effect of
> partial stripe writes.  These are new file allocations, appends, etc
> that are smaller than stripe width.  Totally normal.  To get these close
> to equal you'd need a chunk size of 16K or smaller.

Would that have a material impact on performance?
While current wear stats (Media Wearout Indicator) are all 98 or higher, 
at some point, would it be reasonable to fail the drive with the lowest 
write count, and then use it to replace the drive with the highest write 
count, repeating twice, so that over the next period of time usage 
should merge toward the average? Given the current wear rate, will 
probably replace all the drives in 5 years, which is well before they 
reach 50% wear anyway.

>> So, I could simply do the following:
>> mdadm --manage /dev/md1 --add /dev/sdb1
>> mdadm --grow /dev/md1 --raid-devices=6
>>
>> Probably also need to remove the bitmap and re-add the bitmap.
> Might want to do
>
> ~$ echo 250000 > /proc/sys/dev/raid/speed_limit_min
> ~$ echo 500000 > /proc/sys/dev/raid/speed_limit_min
>
> That'll bump min resync to 250 MB/s per drive, max 500 MB/s.  IIRC the
> defaults are 1 MB/s and 100 MB/s.

Worked perfectly on one machine, the second machine hung, and basically 
crashed. Almost turned into a disaster, but thankfully having two copies 
over the two machines I managed to get everything sorted. After a 
reboot, the second machine recovered and it grew the array also.

Some of the logs from that time:
Mar 13 23:05:59 san2 kernel: [42511.418380] RAID conf printout:
Mar 13 23:05:59 san2 kernel: [42511.418385]  --- level:5 rd:6 wd:6
Mar 13 23:05:59 san2 kernel: [42511.418388]  disk 0, o:1, dev:sdc1
Mar 13 23:05:59 san2 kernel: [42511.418390]  disk 1, o:1, dev:sde1
Mar 13 23:05:59 san2 kernel: [42511.418392]  disk 2, o:1, dev:sdd1
Mar 13 23:05:59 san2 kernel: [42511.418394]  disk 3, o:1, dev:sdf1
Mar 13 23:05:59 san2 kernel: [42511.418396]  disk 4, o:1, dev:sda1
Mar 13 23:05:59 san2 kernel: [42511.418399]  disk 5, o:1, dev:sdb1
Mar 13 23:05:59 san2 kernel: [42511.418444] md: reshape of RAID array md1
Mar 13 23:05:59 san2 kernel: [42511.418448] md: minimum _guaranteed_  
speed: 1000 KB/sec/disk.
Mar 13 23:05:59 san2 kernel: [42511.418451] md: using maximum available 
idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
Mar 13 23:05:59 san2 kernel: [42511.418493] md: using 128k window, over 
a total of 468847936k.
Mar 13 23:06:00 san2 kernel: [42511.512165] md: md_do_sync() got signal 
... exiting
Mar 13 23:07:01 san2 kernel: [42573.067781] iscsi_trgt: Abort Task (01) 
issued on tid:9 lun:0 by sid:8162774362161664 (Function Complete)
Mar 13 23:07:01 san2 kernel: [42573.067789] iscsi_trgt: Abort Task (01) 
issued on tid:11 lun:0 by sid:7318349599801856 (Function Complete)
Mar 13 23:07:01 san2 kernel: [42573.067797] iscsi_trgt: Abort Task (01) 
issued on tid:12 lun:0 by sid:6473924787110400 (Function Complete)
Mar 13 23:07:01 san2 kernel: [42573.067838] iscsi_trgt: Abort Task (01) 
issued on tid:14 lun:0 by sid:5348025014485504 (Function Complete)
Mar 13 23:07:02 san2 kernel: [42573.237591] iscsi_trgt: Abort Task (01) 
issued on tid:8 lun:0 by sid:4503599899804160 (Function Complete)
Mar 13 23:07:02 san2 kernel: [42573.237600] iscsi_trgt: Abort Task (01) 
issued on tid:2 lun:0 by sid:14918173819994624 (Function Complete)

I probably hit CTRL-C causing the "got signal... exiting" because the 
system wasn't responding. There are a *lot* more iscsi errors and then 
these:
Mar 13 23:09:09 san2 kernel: [42700.645060] INFO: task md1_raid5:314 
blocked for more than 120 seconds.
Mar 13 23:09:09 san2 kernel: [42700.645087] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 13 23:09:09 san2 kernel: [42700.645117] md1_raid5       D 
ffff880236833780     0   314      2 0x00000000
Mar 13 23:09:09 san2 kernel: [42700.645123]  ffff88022fc53690 
0000000000000046 ffff8801ee330240 ffff88023593e0c0
Mar 13 23:09:09 san2 kernel: [42700.645128]  0000000000013780 
ffff88022d859fd8 ffff88022d859fd8 ffff88022fc53690
Mar 13 23:09:09 san2 kernel: [42700.645133]  ffff8801ee4b85b8 
ffffffff81071011 0000000000000046 ffff8802307aa000
Mar 13 23:09:09 san2 kernel: [42700.645138] Call Trace:
Mar 13 23:09:09 san2 kernel: [42700.645146] [<ffffffff81071011>] ? 
arch_local_irq_save+0x11/0x17
Mar 13 23:09:09 san2 kernel: [42700.645160] [<ffffffffa0111c44>] ? 
check_reshape+0x27b/0x51a [raid456]
Mar 13 23:09:09 san2 kernel: [42700.645165] [<ffffffff8103f6ba>] ? 
try_to_wake_up+0x197/0x197
Mar 13 23:09:09 san2 kernel: [42700.645175] [<ffffffffa0060381>] ? 
md_check_recovery+0x2a5/0x514 [md_mod]
Mar 13 23:09:09 san2 kernel: [42700.645181] [<ffffffffa01156fe>] ? 
raid5d+0x1c/0x483 [raid456]
Mar 13 23:09:09 san2 kernel: [42700.645187] [<ffffffff8134fdc7>] ? 
_raw_spin_unlock_irqrestore+0xe/0xf
Mar 13 23:09:09 san2 kernel: [42700.645192] [<ffffffff8134eedb>] ? 
schedule_timeout+0x2c/0xdb
Mar 13 23:09:09 san2 kernel: [42700.645195] [<ffffffff81071011>] ? 
arch_local_irq_save+0x11/0x17
Mar 13 23:09:09 san2 kernel: [42700.645199] [<ffffffff81071011>] ? 
arch_local_irq_save+0x11/0x17
Mar 13 23:09:09 san2 kernel: [42700.645206] [<ffffffffa005a256>] ? 
md_thread+0x114/0x132 [md_mod]
Mar 13 23:09:09 san2 kernel: [42700.645212] [<ffffffff8105fcd3>] ? 
add_wait_queue+0x3c/0x3c
Mar 13 23:09:09 san2 kernel: [42700.645219] [<ffffffffa005a142>] ? 
md_rdev_init+0xea/0xea [md_mod]
Mar 13 23:09:09 san2 kernel: [42700.645224] [<ffffffff8105f681>] ? 
kthread+0x76/0x7e
Mar 13 23:09:09 san2 kernel: [42700.645229] [<ffffffff81356ef4>] ? 
kernel_thread_helper+0x4/0x10
Mar 13 23:09:09 san2 kernel: [42700.645234] [<ffffffff8105f60b>] ? 
kthread_worker_fn+0x139/0x139
Mar 13 23:09:09 san2 kernel: [42700.645238] [<ffffffff81356ef0>] ? 
gs_change+0x13/0x13
Mar 13 23:11:09 san2 kernel: [42820.250905] INFO: task md1_raid5:314 
blocked for more than 120 seconds.
Mar 13 23:11:09 san2 kernel: [42820.250932] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 13 23:11:09 san2 kernel: [42820.250961] md1_raid5       D 
ffff880236833780     0   314      2 0x00000000
Mar 13 23:11:09 san2 kernel: [42820.250967]  ffff88022fc53690 
0000000000000046 ffff8801ee330240 ffff88023593e0c0
Mar 13 23:11:09 san2 kernel: [42820.250973]  0000000000013780 
ffff88022d859fd8 ffff88022d859fd8 ffff88022fc53690
Mar 13 23:11:09 san2 kernel: [42820.250978]  ffff8801ee4b85b8 
ffffffff81071011 0000000000000046 ffff8802307aa000
Mar 13 23:11:09 san2 kernel: [42820.250982] Call Trace:
Mar 13 23:11:09 san2 kernel: [42820.250991] [<ffffffff81071011>] ? 
arch_local_irq_save+0x11/0x17
Mar 13 23:11:09 san2 kernel: [42820.251004] [<ffffffffa0111c44>] ? 
check_reshape+0x27b/0x51a [raid456]
Mar 13 23:11:09 san2 kernel: [42820.251009] [<ffffffff8103f6ba>] ? 
try_to_wake_up+0x197/0x197
Mar 13 23:11:09 san2 kernel: [42820.251019] [<ffffffffa0060381>] ? 
md_check_recovery+0x2a5/0x514 [md_mod]
Mar 13 23:11:09 san2 kernel: [42820.251025] [<ffffffffa01156fe>] ? 
raid5d+0x1c/0x483 [raid456]
Mar 13 23:11:09 san2 kernel: [42820.251031] [<ffffffff8134fdc7>] ? 
_raw_spin_unlock_irqrestore+0xe/0xf
Mar 13 23:11:09 san2 kernel: [42820.251035] [<ffffffff8134eedb>] ? 
schedule_timeout+0x2c/0xdb
Mar 13 23:11:09 san2 kernel: [42820.251039] [<ffffffff81071011>] ? 
arch_local_irq_save+0x11/0x17
Mar 13 23:11:09 san2 kernel: [42820.251043] [<ffffffff81071011>] ? 
arch_local_irq_save+0x11/0x17
Mar 13 23:11:09 san2 kernel: [42820.251050] [<ffffffffa005a256>] ? 
md_thread+0x114/0x132 [md_mod]
Mar 13 23:11:09 san2 kernel: [42820.251056] [<ffffffff8105fcd3>] ? 
add_wait_queue+0x3c/0x3c
Mar 13 23:11:09 san2 kernel: [42820.251063] [<ffffffffa005a142>] ? 
md_rdev_init+0xea/0xea [md_mod]
Mar 13 23:11:09 san2 kernel: [42820.251068] [<ffffffff8105f681>] ? 
kthread+0x76/0x7e
Mar 13 23:11:09 san2 kernel: [42820.251073] [<ffffffff81356ef4>] ? 
kernel_thread_helper+0x4/0x10
Mar 13 23:11:09 san2 kernel: [42820.251078] [<ffffffff8105f60b>] ? 
kthread_worker_fn+0x139/0x139
Mar 13 23:11:09 san2 kernel: [42820.251082] [<ffffffff81356ef0>] ? 
gs_change+0x13/0x13

Plus a few more (can provide them if interested), then more iscsi 
errors, and finally I rebooted the machine:
Mar 14 00:55:08 san2 kernel: [    4.415215] md/raid:md1: not clean -- 
starting background reconstruction
Mar 14 00:55:08 san2 kernel: [    4.415216] md/raid:md1: reshape will 
continue
Mar 14 00:55:08 san2 kernel: [    4.415223] md/raid:md1: device sdc1 
operational as raid disk 0
Mar 14 00:55:08 san2 kernel: [    4.415225] md/raid:md1: device sdb1 
operational as raid disk 5
Mar 14 00:55:08 san2 kernel: [    4.415226] md/raid:md1: device sda1 
operational as raid disk 4
Mar 14 00:55:08 san2 kernel: [    4.415227] md/raid:md1: device sdf1 
operational as raid disk 3
Mar 14 00:55:08 san2 kernel: [    4.415228] md/raid:md1: device sdd1 
operational as raid disk 2
Mar 14 00:55:08 san2 kernel: [    4.415230] md/raid:md1: device sde1 
operational as raid disk 1
Mar 14 00:55:08 san2 kernel: [    4.415477] md/raid:md1: allocated 6384kB
Mar 14 00:55:08 san2 kernel: [    4.415491] md/raid:md1: raid level 5 
active with 6 out of 6 devices, algorithm 2
Mar 14 00:55:08 san2 kernel: [    4.415492] RAID conf printout:
Mar 14 00:55:08 san2 kernel: [    4.415493]  --- level:5 rd:6 wd:6
Mar 14 00:55:08 san2 kernel: [    4.415494]  disk 0, o:1, dev:sdc1
Mar 14 00:55:08 san2 kernel: [    4.415495]  disk 1, o:1, dev:sde1
Mar 14 00:55:08 san2 kernel: [    4.415496]  disk 2, o:1, dev:sdd1
Mar 14 00:55:08 san2 kernel: [    4.415497]  disk 3, o:1, dev:sdf1
Mar 14 00:55:08 san2 kernel: [    4.415498]  disk 4, o:1, dev:sda1
Mar 14 00:55:08 san2 kernel: [    4.415499]  disk 5, o:1, dev:sdb1
Mar 14 00:55:08 san2 kernel: [    4.415526] md1: detected capacity 
change from 0 to 1920401145856
Mar 14 00:55:08 san2 kernel: [    4.416733]  md1: unknown partition table

Later after the resync completed I grew the array to make the extra 
space available:
Mar 14 01:37:02 san2 kernel: [ 2514.928987] md: md1: reshape done.
Mar 14 01:37:02 san2 kernel: [ 2514.982394] RAID conf printout:
Mar 14 01:37:02 san2 kernel: [ 2514.982398]  --- level:5 rd:6 wd:6
Mar 14 01:37:02 san2 kernel: [ 2514.982402]  disk 0, o:1, dev:sdc1
Mar 14 01:37:02 san2 kernel: [ 2514.982405]  disk 1, o:1, dev:sde1
Mar 14 01:37:02 san2 kernel: [ 2514.982407]  disk 2, o:1, dev:sdd1
Mar 14 01:37:02 san2 kernel: [ 2514.982410]  disk 3, o:1, dev:sdf1
Mar 14 01:37:02 san2 kernel: [ 2514.982413]  disk 4, o:1, dev:sda1
Mar 14 01:37:02 san2 kernel: [ 2514.982415]  disk 5, o:1, dev:sdb1
Mar 14 01:37:02 san2 kernel: [ 2514.982422] md1: detected capacity 
change from 1920401145856 to 2400501432320
Mar 14 01:37:02 san2 kernel: [ 2514.993988] md: resync of RAID array md1
Mar 14 01:37:02 san2 kernel: [ 2514.993992] md: minimum _guaranteed_  
speed: 300000 KB/sec/disk.
Mar 14 01:37:02 san2 kernel: [ 2514.993995] md: using maximum available 
idle IO bandwidth (but not more than 400000 KB/sec) for resync.
Mar 14 01:37:02 san2 kernel: [ 2514.994041] md: using 128k window, over 
a total of 468847936k.
Mar 14 01:55:16 san2 kernel: [ 3605.141839] md: md1: resync done.
Mar 14 01:55:16 san2 kernel: [ 3605.172547] RAID conf printout:
Mar 14 01:55:16 san2 kernel: [ 3605.172551]  --- level:5 rd:6 wd:6
Mar 14 01:55:16 san2 kernel: [ 3605.172554]  disk 0, o:1, dev:sdc1
Mar 14 01:55:16 san2 kernel: [ 3605.172556]  disk 1, o:1, dev:sde1
Mar 14 01:55:16 san2 kernel: [ 3605.172558]  disk 2, o:1, dev:sdd1
Mar 14 01:55:16 san2 kernel: [ 3605.172560]  disk 3, o:1, dev:sdf1
Mar 14 01:55:16 san2 kernel: [ 3605.172562]  disk 4, o:1, dev:sda1
Mar 14 01:55:16 san2 kernel: [ 3605.172564]  disk 5, o:1, dev:sdb1


This did lead to another observation.... The speed of the resync seemed 
limited by something other than disk IO. It was usually around 250 to 
300MB/s, the maximum achieved was around 420MB/s. I also noticed that 
idle CPU time on one of the cores was relatively low, though I never saw 
it hit 0 (minimum I saw was 12% idle, average around 20%).

So, I'm wondering whether I should consider upgrading the CPU and/or 
motherboard to try and improve peak performance?
Currently I have Intel Xeon E3-1230V2/3.3GHz/8MB 
Cache/4core/8thread/5GTs, my supplier has offered a number of options:
1) Compatible with current motherboard
      Intel Xeon E3-1280V2/3.6GHz/8MB Cache/4core/8thread/5GTs
2)  Intel Xeon E5-2620V2/2.1GHz/15MB Cache/6core/12thread/5GTs
3)  Intel Xeon E5-2630V2/2.6GHz/15MB Cache/6core/12thread/7.2GTs

My understanding is that the RAID5 is single threaded, so will work best 
with a higher speed single core CPU compared to a larger number of cores 
at a lower speed. However, I'm not sure how much "work" is being done 
across the various models. ie, does a E5 CPU do more work even though it 
has a lower clock speed? Does this carry over to the E7 class as well?

Currently I'm looking to replace at least the motherboard with 
http://www.supermicro.com/products/motherboard/Xeon/C202_C204/X9SCM-F.cfm in 
order to get 2 of the PCIe 2.0 8x slots (one for the existing LSI SATA 
controller and one for a dual port 10Gb ethernet card. This will provide 
a 10Gb cross-over connection between the two server, plus replace the 8 
x 1G ports with a single 10Gb port (solving the load balancing across 
the multiple links issue). Finally, this 28 port (4 x 10G + 24 x 1G) 
switch 
http://www.netgear.com.au/business/products/switches/stackable-smart-switches/GS728TXS.aspx# 
should allow the 2 x 10G connections to be connected through to the 8 
servers with 2 x 1G connections each using multipath scsi to setup two 
connections (one on each 1G port) with the same destination (10G port)

Any suggestions/comments would be welcome.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
