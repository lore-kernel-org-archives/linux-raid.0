From: Henrik Johnson <henrik.johnson@quest.com>
Subject: RE: Computer locked up when adding bitmap=internal and now
 filesystem is gone
Date: Thu, 11 Jun 2009 16:11:23 -0700
Message-ID: <6592BDAF72405343BA096C66B735B38E017D64393B@alvxmbw04.prod.quest.corp>
References: <6592BDAF72405343BA096C66B735B38E017D64335C@alvxmbw04.prod.quest.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Saw that my original email on this issue got garbled by the mailing list server so I'm reposting with that fixed (I hope).

/Regards
Henrik Johnson
-----Original Message-----
From: Henrik Johnson 
Sent: Thursday, June 11, 2009 3:19 PM
To: linux-raid@vger.kernel.org
Subject: Computer locked up when adding bitmap=internal and now filesystem is gone

I am having a decidedly bad day today. I just posted another issue here a few hours ago. Now on another machine I was trying to remove and then add back an internal bitmap. When executing the command to add the internal bitmap back I ran into this error is the syslog.

Jun 11 14:06:36 pallas klogd: BUG: unable to handle kernel NULL pointer dereference at (null)

Jun 11 14:06:36 pallas klogd: IP: [<c0306ddb>] bitmap_daemon_work+0x1eb/0x380

Jun 11 14:06:36 pallas klogd: *pde = 00000000

Jun 11 14:06:36 pallas klogd: Oops: 0000 [#1] SMP

Jun 11 14:06:36 pallas klogd: last sysfs file: /sys/firmware/edd/int13_dev8c/mbr_signature

Jun 11 14:06:36 pallas klogd: Modules linked in: w83627ehf hwmon_vid nfsd exportfs ext4 jbd2 crc16 sha256_generic aes_i586 aes_generic cbc dm_crypt af_packet nfs lockd nfs_acl auth_rpcgss sunrpc raid456 async_xor async_memcpy async_tx xor ipv6 binfmt_misc loop dm_mirror dm_region_hash dm_log dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave p4_clockmod speedstep_lib freq_table ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss snd pcspkr i2c_i801 i2c_core evdev sr_mod rng_core iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc sg e1000e shpchp sky2 pci_hotplug rtc_cmos parport_pc parport thermal button processor ehci_hcd uhci_hcd usbcore sata_sil24 sata_sil sata_promise a
 ta_generic ide_pci_generic pata_acpi piix ide_gd_mod ide_core ahci ata_piix libata sd_mod scsi_mod crc_t10dif ext3 jbd

Jun 11 14:06:36 pallas klogd:

Jun 11 14:06:36 pallas klogd: Pid: 3840, comm: md0_raid5 Not tainted (2.6.29.3-desktop-1mnb #1) PDSG4

Jun 11 14:06:36 pallas klogd: EIP: 0060:[<c0306ddb>] EFLAGS: 00010046 CPU: 0

Jun 11 14:06:36 pallas klogd: EIP is at bitmap_daemon_work+0x1eb/0x380

Jun 11 14:06:36 pallas klogd: EAX: 00000007 EBX: f5f6bf00 ECX: 00000000 EDX: 0000001e

Jun 11 14:06:36 pallas klogd: ESI: c16961a0 EDI: 00000282 EBP: f5fa1efc ESP: f5fa1ed4

Jun 11 14:06:36 pallas klogd:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068

Jun 11 14:06:36 pallas klogd: Process md0_raid5 (pid: 3840, ti=f5fa0000 task=f5efd4e0 task.ti=f5fa0000)

Jun 11 14:06:36 pallas klogd: Stack:

Jun 11 14:06:36 pallas klogd:  f5fa1eec 00000000 f5f6bf30 000390ba 00000282 000398b9 00000800 00000290

Jun 11 14:06:36 pallas klogd:  f66e0800 f6070394 f5fa1f20 c030107a 00000286 f5fa1f10 c011ef08 f5fa1f20

Jun 11 14:06:36 pallas klogd:  00000290 f6070380 f6070394 f5fa1fa4 f8562d46 00000296 f5fa1f68 00000001

Jun 11 14:06:36 pallas klogd: Call Trace:

Jun 11 14:06:36 pallas klogd:  [<c030107a>] ? md_check_recovery+0x1a/0x540

Jun 11 14:06:36 pallas klogd:  [<c011ef08>] ? default_spin_lock_flags+0x8/0x10

Jun 11 14:06:36 pallas klogd:  [<f8562d46>] ? raid5d+0x26/0x670 [raid456]

Jun 11 14:06:36 pallas klogd:  [<c013e04a>] ? try_to_del_timer_sync+0x4a/0x60

Jun 11 14:06:36 pallas klogd:  [<c013e071>] ? del_timer_sync+0x11/0x20

Jun 11 14:06:36 pallas klogd:  [<c03aa6d6>] ? schedule_timeout+0x86/0xe0

Jun 11 14:06:36 pallas klogd:  [<c013dc10>] ? process_timeout+0x0/0x10

Jun 11 14:06:36 pallas klogd:  [<c0148b6a>] ? finish_wait+0x4a/0x70

Jun 11 14:06:36 pallas klogd:  [<c02fe352>] ? md_thread+0x32/0x100

Jun 11 14:06:36 pallas klogd:  [<c01489e0>] ? autoremove_wake_function+0x0/0x50

Jun 11 14:06:36 pallas klogd:  [<c02fe320>] ? md_thread+0x0/0x100

Jun 11 14:06:36 pallas klogd:  [<c014866c>] ? kthread+0x3c/0x70

Jun 11 14:06:36 pallas klogd:  [<c0148630>] ? kthread+0x0/0x70

Jun 11 14:06:36 pallas klogd:  [<c0105d13>] ? kernel_thread_helper+0x7/0x14

Jun 11 14:06:36 pallas klogd: Code: e4 01 8b 45 e4 39 43 1c 0f 87 6a ff ff ff 66 90 85 f6 74 3c 8b 45 e0 e8 f4 51 0a 00 8b 4b 44 89 c7 8b 46 14 8d 14 85 02 00 00 00 <0f> a3 11 19 c0 85 c0 0f 84 40 01 00 00 0f b3 11 8b 45 e0 89 fa

Jun 11 14:06:36 pallas klogd: EIP: [<c0306ddb>] bitmap_daemon_work+0x1eb/0x380 SS:ESP 0068:f5fa1ed4


After this the machine completely locked up. I had to hard reset it to get it back up and running. The array was dirty but all the disks seemed to be there and in the array. It started syncing up a bit before I stopped it just to be on the safe side. Here is the problem. It seems that most of the filesystem on the array is gone. According to mdstat and mdadm the array has no bitmap (It was during the call to add the array back that the computer locked up). Here is the output from one of the disks from mdadm -E.

/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 5e517376:6cb5c7d3:8675859c:e35b7317
  Creation Time : Thu Mar  8 10:50:50 2007
     Raid Level : raid6
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 6837375104 (6520.63 GiB 7001.47 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 0

    Update Time : Thu Jun 11 14:21:05 2009
          State : active
 Active Devices : 16
Working Devices : 16
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8c8787ae - correct
         Events : 9707267

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8      209        1      active sync   /dev/sdn1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8      145        4      active sync   /dev/sdj1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      193        7      active sync   /dev/sdm1
   8     8       8      225        8      active sync   /dev/sdo1
   9     9      65        1        9      active sync   /dev/sdq1
  10    10       8       33       10      active sync   /dev/sdc1
  11    11       8      241       11      active sync   /dev/sdp1
  12    12       8       81       12      active sync   /dev/sdf1
  13    13       8      129       13      active sync   /dev/sdi1
  14    14       8      113       14      active sync   /dev/sdh1
  15    15       8      177       15      active sync   /dev/sdl1

Also here is the output from /proc/mdadm:

md0 : active (auto-read-only) raid6 sdb1[0] sdl1[15] sdh1[14] sdi1[13] sdf1[12] sdp1[11] sdc1[10] sdq1[9] sdo1[8] sdm1[7] sdg1[6] sdk1[5] sdj1[4] sde1[3] sdd1[2] sdn1[1]
      6837375104 blocks level 6, 64k chunk, algorithm 2 [16/16] [UUUUUUUUUUUUUUUU]
        resync=PENDING

(As you can see no indication of bitmaps anywhere).

Can anybody think of any reason how this could completely corrupt and ext4 file system. The ext4 filesystem is sitting on top of an luks encrypted partition if that helps in any way. It seems not everything is gone though because luks can correctly decode the password but pretty much every single group descriptor in ext4 had an invalid checksum when I ran a read only fsck.

On this machine I am running mdadm 2.6.9 and a Mandriva Linux 2.6.29.3-desktop-1mnb kernel.

Any help is welcome in regards to what could have happened.

/Regards
Henrik Johnson
