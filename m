From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: mdadm 3.1.3 call trace crash on Ubuntu 10.04 64-bit
Date: Mon, 13 Sep 2010 20:44:59 -0700
Message-ID: <AANLkTik5-MuAjvgEJR959UB+ZhHmBo+Xi_BsUh-jXt4P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I built a basic RAID 5 array with 24 SATA SSD drives on my Ubuntu
10.04 64-bit system with mdadm 3.1.3 installed, along with the patch
that fixes the incremental assembly regression bug.

I tried to delete my RAID 5 array and the Ubuntu system hung: not even
cat /proc/mdstat would return anything. Finally, a few minutes later,
the following call trace appearing in /var/log/messages. Any insight
would be recommended. Thanks!

-Tommy


Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.354081] md: bind<sdb1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.354253] md: bind<sdc1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.354458] md: bind<sdd1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.354565] md: bind<sde1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.354655] md: bind<sdf1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.354741] md: bind<sdg1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.354822] md: bind<sdh1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.354904] md: bind<sdi1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.354987] md: bind<sdj1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355073] md: bind<sdk1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355154] md: bind<sdl1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355239] md: bind<sdm1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355331] md: bind<sdn1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355411] md: bind<sdo1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355493] md: bind<sdp1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355575] md: bind<sdq1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355657] md: bind<sdr1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355743] md: bind<sds1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355826] md: bind<sdt1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355906] md: bind<sdu1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.355987] md: bind<sdv1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.356067] md: bind<sdw1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.356149] md: bind<sdx1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.356234] md: bind<sdy1>
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358782] raid5: md0 is not
clean -- starting background reconstruction
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358803] raid5: device sdy1
operational as raid disk 23
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358806] raid5: device sdx1
operational as raid disk 22
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358808] raid5: device sdw1
operational as raid disk 21
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358810] raid5: device sdv1
operational as raid disk 20
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358812] raid5: device sdu1
operational as raid disk 19
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358814] raid5: device sdt1
operational as raid disk 18
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358816] raid5: device sds1
operational as raid disk 17
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358819] raid5: device sdr1
operational as raid disk 16
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358821] raid5: device sdq1
operational as raid disk 15
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358823] raid5: device sdp1
operational as raid disk 14
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358825] raid5: device sdo1
operational as raid disk 13
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358827] raid5: device sdn1
operational as raid disk 12
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358829] raid5: device sdm1
operational as raid disk 11
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358831] raid5: device sdl1
operational as raid disk 10
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358833] raid5: device sdk1
operational as raid disk 9
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358835] raid5: device sdj1
operational as raid disk 8
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358837] raid5: device sdi1
operational as raid disk 7
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358840] raid5: device sdh1
operational as raid disk 6
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358842] raid5: device sdg1
operational as raid disk 5
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358844] raid5: device sdf1
operational as raid disk 4
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358846] raid5: device sde1
operational as raid disk 3
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358848] raid5: device sdd1
operational as raid disk 2
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358850] raid5: device sdc1
operational as raid disk 1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.358852] raid5: device sdb1
operational as raid disk 0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360534] raid5: allocated
25322kB for md0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360573] 23: w=1 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360576] 22: w=2 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360579] 21: w=3 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360582] 20: w=4 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360585] 19: w=5 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360588] 18: w=6 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360591] 17: w=7 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360594] 16: w=8 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360597] 15: w=9 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360600] 14: w=10 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360603] 13: w=11 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360606] 12: w=12 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360609] 11: w=13 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360612] 10: w=14 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360615] 9: w=15 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360618] 8: w=16 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360621] 7: w=17 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360624] 6: w=18 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360627] 5: w=19 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360630] 4: w=20 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360632] 3: w=21 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360635] 2: w=22 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360638] 1: w=23 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360641] 0: w=24 pa=0 pr=24
m=1 a=2 r=24 op1=0 op2=0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360644] raid5: raid level 5
set md0 active with 24 out of 24 devices, algorithm 2
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360646] RAID5 conf printout:
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360648]  --- rd:24 wd:24
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360650]  disk 0, o:1, dev:sdb1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360652]  disk 1, o:1, dev:sdc1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360654]  disk 2, o:1, dev:sdd1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360656]  disk 3, o:1, dev:sde1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360658]  disk 4, o:1, dev:sdf1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360660]  disk 5, o:1, dev:sdg1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360662]  disk 6, o:1, dev:sdh1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360664]  disk 7, o:1, dev:sdi1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360666]  disk 8, o:1, dev:sdj1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360668]  disk 9, o:1, dev:sdk1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360670]  disk 10, o:1, dev:sdl1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360672]  disk 11, o:1, dev:sdm1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360674]  disk 12, o:1, dev:sdn1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360675]  disk 13, o:1, dev:sdo1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360677]  disk 14, o:1, dev:sdp1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360679]  disk 15, o:1, dev:sdq1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360681]  disk 16, o:1, dev:sdr1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360683]  disk 17, o:1, dev:sds1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360685]  disk 18, o:1, dev:sdt1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360687]  disk 19, o:1, dev:sdu1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360689]  disk 20, o:1, dev:sdv1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360691]  disk 21, o:1, dev:sdw1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360693]  disk 22, o:1, dev:sdx1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360695]  disk 23, o:1, dev:sdy1
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360768] md0: detected
capacity change from 0 to 2300607594496
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.360998] md: resync of RAID array md0
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.361002] md: minimum
_guaranteed_  speed: 10 KB/sec/disk.
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.361004] md: using maximum
available idle IO bandwidth (but not more than 100 KB/sec) for resync.
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.361046] md: using 128k
window, over a total of 97682048 blocks.
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.361278] md: md_import_device
returned -16
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.361299] md: md_import_device
returned -16
Sep 13 20:34:02 NIMBUS7D46 kernel: [ 1109.361771]  md0: unknown partition table
Sep 13 20:34:40 NIMBUS7D46 kernel: [ 1147.264539] md: md_do_sync() got
signal ... exiting
Sep 13 20:34:40 NIMBUS7D46 kernel: [ 1147.264547] md: checkpointing
resync of md0.
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052573] mdadm         D
0000000000000000     0 21840  21586 0x00000000
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052578]  ffff880627e31a68
0000000000000086 0000000000015bc0 0000000000015bc0
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052584]  ffff880631bfdf80
ffff880627e31fd8 0000000000015bc0 ffff880631bfdbc0
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052588]  0000000000015bc0
ffff880627e31fd8 0000000000015bc0 ffff880631bfdf80
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052593] Call Trace:
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052607]
[<ffffffff81558efd>] schedule_timeout+0x22d/0x300
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052612]
[<ffffffff815581a6>] wait_for_common+0xd6/0x180
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052618]
[<ffffffff8115cdf8>] ? ifind_fast+0x58/0xb0
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052626]
[<ffffffff8105b210>] ? default_wake_function+0x0/0x20
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052633]
[<ffffffff811af5f9>] ? sysfs_drop_dentry+0x139/0x160
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052637]
[<ffffffff8155830d>] wait_for_completion+0x1d/0x20
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052641]
[<ffffffff811b0118>] sysfs_addrm_finish+0x118/0x150
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052657]
[<ffffffff811ada1b>] sysfs_hash_and_remove+0x5b/0x80
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052663]
[<ffffffff811b19ef>] sysfs_remove_group+0x5f/0x100
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052670]
[<ffffffffa00dfc11>] stop+0x61/0x80 [raid456]
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052676]
[<ffffffff8142d39d>] do_md_stop+0xdd/0x560
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052682]
[<ffffffff812bba10>] ? string+0x40/0x100
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052688]
[<ffffffff812857b1>] ? apparmor_capable+0x31/0xa0
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052692]
[<ffffffff8143011b>] md_ioctl+0x6bb/0x790
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052698]
[<ffffffff810f417e>] ? find_get_page+0x1e/0xa0
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052702]
[<ffffffff810f5b8b>] ? filemap_fault+0x8b/0x450
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052706]
[<ffffffff8113d5dd>] ? mem_cgroup_update_mapped_file_stat+0x2d/0x90
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052714]
[<ffffffff812a6307>] __blkdev_driver_ioctl+0x27/0x80
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052717]
[<ffffffff812a67dd>] blkdev_ioctl+0x1ed/0x6f0
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052722]
[<ffffffff81173adc>] block_ioctl+0x3c/0x40
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052728]
[<ffffffff81154772>] vfs_ioctl+0x22/0xa0
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052732]
[<ffffffff81154911>] do_vfs_ioctl+0x81/0x410
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052736]
[<ffffffff8155d6b3>] ? do_page_fault+0x153/0x3b0
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052740]
[<ffffffff81154d21>] sys_ioctl+0x81/0xa0
Sep 13 20:37:34 NIMBUS7D46 kernel: [ 1321.052748]
[<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857782] mdadm         D
0000000000000000     0 21840  21586 0x00000000
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857788]  ffff880627e31a68
0000000000000086 0000000000015bc0 0000000000015bc0
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857793]  ffff880631bfdf80
ffff880627e31fd8 0000000000015bc0 ffff880631bfdbc0
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857797]  0000000000015bc0
ffff880627e31fd8 0000000000015bc0 ffff880631bfdf80
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857801] Call Trace:
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857815]
[<ffffffff81558efd>] schedule_timeout+0x22d/0x300
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857820]
[<ffffffff815581a6>] wait_for_common+0xd6/0x180
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857827]
[<ffffffff8115cdf8>] ? ifind_fast+0x58/0xb0
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857835]
[<ffffffff8105b210>] ? default_wake_function+0x0/0x20
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857842]
[<ffffffff811af5f9>] ? sysfs_drop_dentry+0x139/0x160
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857846]
[<ffffffff8155830d>] wait_for_completion+0x1d/0x20
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857850]
[<ffffffff811b0118>] sysfs_addrm_finish+0x118/0x150
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857865]
[<ffffffff811ada1b>] sysfs_hash_and_remove+0x5b/0x80
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857870]
[<ffffffff811b19ef>] sysfs_remove_group+0x5f/0x100
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857878]
[<ffffffffa00dfc11>] stop+0x61/0x80 [raid456]
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857884]
[<ffffffff8142d39d>] do_md_stop+0xdd/0x560
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857889]
[<ffffffff812bba10>] ? string+0x40/0x100
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857896]
[<ffffffff812857b1>] ? apparmor_capable+0x31/0xa0
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857899]
[<ffffffff8143011b>] md_ioctl+0x6bb/0x790
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857905]
[<ffffffff810f417e>] ? find_get_page+0x1e/0xa0
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857909]
[<ffffffff810f5b8b>] ? filemap_fault+0x8b/0x450
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857913]
[<ffffffff8113d5dd>] ? mem_cgroup_update_mapped_file_stat+0x2d/0x90
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857921]
[<ffffffff812a6307>] __blkdev_driver_ioctl+0x27/0x80
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857924]
[<ffffffff812a67dd>] blkdev_ioctl+0x1ed/0x6f0
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857929]
[<ffffffff81173adc>] block_ioctl+0x3c/0x40
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857934]
[<ffffffff81154772>] vfs_ioctl+0x22/0xa0
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857938]
[<ffffffff81154911>] do_vfs_ioctl+0x81/0x410
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857942]
[<ffffffff8155d6b3>] ? do_page_fault+0x153/0x3b0
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857946]
[<ffffffff81154d21>] sys_ioctl+0x81/0xa0
Sep 13 20:39:34 NIMBUS7D46 kernel: [ 1440.857954]
[<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
root@NIMBUS7D46:/dev/shm#
