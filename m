From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: 2 drive RAID10 rebuild issue
Date: Fri, 14 Oct 2011 11:06:45 +0800
Message-ID: <4E97A745.8050401@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

My main OS drives are a pair of 1TB WD SATA units in a RAID-10 f,2 layout.

Current configuration is as follows :

root@srv:~# uname -a
Linux srv 3.1.0-rc9 #1 SMP Wed Oct 5 17:35:49 WST 2011 x86_64 GNU/Linux
root@srv:~# mdadm --version
mdadm - v3.2.1 - 28th March 2011
root@srv:~# mdadm --detail /dev/md2
/dev/md2:
         Version : 1.2
   Creation Time : Sun May  8 14:02:40 2011
      Raid Level : raid10
      Array Size : 976247808 (931.02 GiB 999.68 GB)
   Used Dev Size : 976247808 (931.02 GiB 999.68 GB)
    Raid Devices : 2
   Total Devices : 1
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Fri Oct 14 10:53:23 2011
           State : active, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0

          Layout : far=2
      Chunk Size : 512K

            Name : sysresccd:2
            UUID : 6df98448:8cfbee7e:acdf3947:f282c441
          Events : 317419

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8      226        1      active sync   /dev/sdo2

root@srv:~# mdadm --examine /dev/sdo2
/dev/sdo2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 6df98448:8cfbee7e:acdf3947:f282c441
            Name : sysresccd:2
   Creation Time : Sun May  8 14:02:40 2011
      Raid Level : raid10
    Raid Devices : 2

  Avail Dev Size : 1952497072 (931.02 GiB 999.68 GB)
      Array Size : 1952495616 (931.02 GiB 999.68 GB)
   Used Dev Size : 1952495616 (931.02 GiB 999.68 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 0f132a57:e1c95358:904c3195:4c3f9af8

Internal Bitmap : 2 sectors from superblock
     Update Time : Fri Oct 14 10:53:53 2011
        Checksum : 91576962 - correct
          Events : 317431

          Layout : far=2
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : .A ('A' == active, '.' == missing)

root@srv:~# mdadm --examine /dev/sdp2
mdadm: No md superblock detected on /dev/sdp2.

I accidentally unplugged sdp a while ago. Yesterday I plugged it back in and tried to re-add 
/dev/sdp2 to /dev/md2. /dev/sdp2 was initially added as a spare, so I removed it and zero'd the 
superblock before re-trying an add. sd[op]1 are both components of /dev/md1 in a RAID1 and that all 
worked ok.

<snip from bootup dmesg> (root is on md2p1)

[    4.464763] md: md2 stopped.
[    4.465318] md: bind<sdo2>
[    4.465992] md/raid10:md2: not clean -- starting background reconstruction
[    4.466026] md/raid10:md2: active with 1 out of 2 devices
[    4.466236] created bitmap (8 pages) for device md2
[    4.466464] md2: bitmap initialized from disk: read 1/1 pages, set 308 of 14897 bits
[    4.478694] md2: detected capacity change from 0 to 999677755392
[    4.489859]  md2: p1 p2 p3

When I add /dev/sdp2 to /dev/md2 the following occurs :

Oct 14 10:05:51 srv kernel: [  266.534562] md: bind<sdp2>
Oct 14 10:05:51 srv kernel: [  266.559686] RAID10 conf printout:
Oct 14 10:05:51 srv kernel: [  266.559694]  --- wd:1 rd:2
Oct 14 10:05:51 srv kernel: [  266.559701]  disk 1, wo:1, o:1, dev:sdp2
Oct 14 10:05:51 srv kernel: [  266.559717] ------------[ cut here ]------------
Oct 14 10:05:51 srv kernel: [  266.559772] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb9/0xf0()
Oct 14 10:05:51 srv kernel: [  266.559816] Hardware name: To Be Filled By O.E.M.
Oct 14 10:05:51 srv kernel: [  266.559858] sysfs: cannot create duplicate filename 
'/devices/virtual/block/md2/md/rd1'
Oct 14 10:05:51 srv kernel: [  266.559905] Modules linked in: iptable_filter ip_tables x_tables nfs 
ppp_generic slhc cls_u32 sch_htb deflate zlib_deflate des_generic cbc ecb crypto_blkcipher 
sha1_generic md5 hmac crypto_hash cryptomgr aead crypto_algapi af_key fuse w83627ehf hwmon_vid 
vhost_net powernow_k8 mperf kvm_amd kvm pl2303 usbserial xhci_hcd i2c_piix4 k10temp ohci_hcd 
ehci_hcd r8169 usbcore ahci libahci sata_mv megaraid_sas [last unloaded: scsi_wait_scan]
Oct 14 10:05:51 srv kernel: [  266.561427] Pid: 1468, comm: md2_raid10 Not tainted 3.1.0-rc9 #1
Oct 14 10:05:51 srv kernel: [  266.561469] Call Trace:
Oct 14 10:05:51 srv kernel: [  266.561516]  [<ffffffff81034dcb>] ? warn_slowpath_common+0x7b/0xc0
Oct 14 10:05:51 srv kernel: [  266.561562]  [<ffffffff81034ec5>] ? warn_slowpath_fmt+0x45/0x50
Oct 14 10:05:51 srv kernel: [  266.561617]  [<ffffffff8111aea9>] ? sysfs_add_one+0xb9/0xf0
Oct 14 10:05:51 srv kernel: [  266.561662]  [<ffffffff8111bf53>] ? sysfs_do_create_link+0x143/0x210
Oct 14 10:05:51 srv kernel: [  266.561709]  [<ffffffff811dd1d3>] ? sprintf+0x43/0x50
Oct 14 10:05:51 srv kernel: [  266.561755]  [<ffffffff812f24c9>] ? md_check_recovery+0x549/0x6a0
Oct 14 10:05:51 srv kernel: [  266.561801]  [<ffffffff812db397>] ? raid10d+0x27/0xb50
Oct 14 10:05:51 srv kernel: [  266.561846]  [<ffffffff81041043>] ? lock_timer_base+0x33/0x70
Oct 14 10:05:51 srv kernel: [  266.561890]  [<ffffffff810410ec>] ? try_to_del_timer_sync+0x6c/0x90
Oct 14 10:05:51 srv kernel: [  266.561935]  [<ffffffff8104113a>] ? del_timer_sync+0x2a/0x50
Oct 14 10:05:51 srv kernel: [  266.561981]  [<ffffffff813e9440>] ? schedule_timeout+0x160/0x230
Oct 14 10:05:51 srv kernel: [  266.562025]  [<ffffffff810411f0>] ? del_timer+0x90/0x90
Oct 14 10:05:51 srv kernel: [  266.562071]  [<ffffffff812efa4f>] ? md_thread+0x10f/0x140
Oct 14 10:05:51 srv kernel: [  266.562117]  [<ffffffff81050120>] ? wake_up_bit+0x40/0x40
Oct 14 10:05:51 srv kernel: [  266.562162]  [<ffffffff812ef940>] ? md_register_thread+0x100/0x100
Oct 14 10:05:51 srv kernel: [  266.562208]  [<ffffffff812ef940>] ? md_register_thread+0x100/0x100
Oct 14 10:05:51 srv kernel: [  266.562580]  [<ffffffff8104fcc6>] ? kthread+0x96/0xa0
Oct 14 10:05:51 srv kernel: [  266.562625]  [<ffffffff813ec6b4>] ? kernel_thread_helper+0x4/0x10
Oct 14 10:05:51 srv kernel: [  266.562671]  [<ffffffff8104fc30>] ? kthread_worker_fn+0x120/0x120
Oct 14 10:05:51 srv kernel: [  266.562715]  [<ffffffff813ec6b0>] ? gs_change+0xb/0xb
Oct 14 10:05:51 srv kernel: [  266.562757] ---[ end trace c02313193e85d8a8 ]---
Oct 14 10:05:51 srv kernel: [  266.562879] md: recovery of RAID array md2
Oct 14 10:05:51 srv kernel: [  266.562927] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Oct 14 10:05:51 srv kernel: [  266.562971] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
Oct 14 10:05:51 srv kernel: [  266.563062] md: using 128k window, over a total of 976247808k.
Oct 14 10:05:51 srv kernel: [  266.563253] md/raid10:md2: insufficient working devices for recovery.
Oct 14 10:05:51 srv kernel: [  266.563306] md: md2: recovery done.
Oct 14 10:05:51 srv kernel: [  266.609662] RAID10 conf printout:
Oct 14 10:05:51 srv kernel: [  266.609669]  --- wd:1 rd:2
Oct 14 10:05:51 srv kernel: [  266.609675]  disk 1, wo:1, o:1, dev:sdp2
Oct 14 10:05:51 srv kernel: [  266.750052] RAID10 conf printout:
Oct 14 10:05:51 srv kernel: [  266.750056]  --- wd:1 rd:2
Oct 14 10:05:52 srv kernel: [  267.757749] Buffer I/O error on device md2p1, logical block 5230645
Oct 14 10:05:52 srv kernel: [  267.757808] EXT4-fs warning (device md2p1): ext4_end_bio:258: I/O 
error writing to inode 923126 (offset 282624 size 4096 starting block 5230901)
Oct 14 10:05:52 srv kernel: [  267.757907] Buffer I/O error on device md2p1, logical block 1620503
Oct 14 10:05:52 srv kernel: [  267.757952] Buffer I/O error on device md2p1, logical block 1620504
Oct 14 10:05:52 srv kernel: [  267.757997] EXT4-fs warning (device md2p1): ext4_end_bio:258: I/O 
error writing to inode 425274 (offset 0 size 8192 starting block 1620759)
Oct 14 10:05:52 srv kernel: [  267.758067] Buffer I/O error on device md2p1, logical block 2917504
Oct 14 10:05:52 srv kernel: [  267.758114] EXT4-fs warning (device md2p1): ext4_end_bio:258: I/O 
error writing to inode 1052016 (offset 0 size 4096 starting block 2917760)
Oct 14 10:05:52 srv kernel: [  267.758180] Buffer I/O error on device md2p1, logical block 2917529
Oct 14 10:05:52 srv kernel: [  267.758225] Buffer I/O error on device md2p1, logical block 2917530
Oct 14 10:05:52 srv kernel: [  267.758270] EXT4-fs warning (device md2p1): ext4_end_bio:258: I/O 
error writing to inode 1052016 (offset 102400 size 8192 starting block 2917785)
Oct 14 10:05:56 srv kernel: [  271.151176] Buffer I/O error on device md2p2, logical block 4352449
Oct 14 10:05:56 srv kernel: [  271.151226] lost page write due to I/O error on md2p2
Oct 14 10:05:56 srv kernel: [  271.151322] JBD2: Detected IO errors while flushing file data on md2p2-8
Oct 14 10:05:56 srv kernel: [  271.151370] Aborting journal on device md2p2-8.
Oct 14 10:05:56 srv kernel: [  271.151417] Buffer I/O error on device md2p2, logical block 5275648
Oct 14 10:05:56 srv kernel: [  271.151459] lost page write due to I/O error on md2p2
Oct 14 10:05:56 srv kernel: [  271.151503] JBD2: I/O error detected when updating journal superblock 
for md2p2-8.
Oct 14 10:05:57 srv kernel: [  272.774195] Buffer I/O error on device md2p2, logical block 5767612
Oct 14 10:05:57 srv kernel: [  272.774246] lost page write due to I/O error on md2p2
Oct 14 10:05:57 srv kernel: [  272.774303] Buffer I/O error on device md2p2, logical block 5770220
Oct 14 10:05:57 srv kernel: [  272.774346] lost page write due to I/O error on md2p2
Oct 14 10:05:57 srv kernel: [  272.774392] Buffer I/O error on device md2p2, logical block 9439050
Oct 14 10:05:57 srv kernel: [  272.774436] lost page write due to I/O error on md2p2

I've repeated this three times now, each time zeroing the superblock on /dev/sdp2 and trying an add. 
I get the same result every time, requiring a belt of the big red button.

I'm just using :
mdadm --add /dev/md2 /dev/sdp2

Have I done something particularly wrong?

This is neither urgent, nor critical as the system is happily spinning on one drive and I have 
pedantic backups of everything.

Regards,
Brad
