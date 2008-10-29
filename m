From: "Steve Evans" <jeeping@gmail.com>
Subject: Re: mdadm degraded RAID5 failure
Date: Wed, 29 Oct 2008 16:16:41 -0600
Message-ID: <6cc8e9ed0810291516p46cb24a7pdd230e222797d06e@mail.gmail.com>
References: <6cc8e9ed0810221350o2b8b3aedm3d1c229fe7e66163@mail.gmail.com>
	 <6cc8e9ed0810221352y7427cb7dmfc7c3fcefd495bb9@mail.gmail.com>
	 <18690.48372.369694.309381@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18690.48372.369694.309381@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 25, 2008 at 12:30 AM, Neil Brown <neilb@suse.de> wrote:
> On Wednesday October 22, jeeping@gmail.com wrote:
>> Hi all..
>
> Hi.
> You need to get a mail client that doesn't destroy the formatting of
> the text that you paste in.  But while it is an inconvenience, we
> should be able to persevere...
>

Sorry, I attempted a plain text email through gmail.. I probably
messed it up :(  Hopefully this one is better..

>>
>> I had one of the disks in my 3 disk RAID5 die on me this week. When
>> attempting to replace the disk via a hot swap (USB), the RAID didn't
>> like it. It decided to mark one of my remaining 2 disks as faulty.
>
> It would be interesting to see the kernel logs at this time.  Maybe
> the USB bus glitched while you were plugging the device in.
>

Here are some of what I thought were the more relevent entries in the
logs, let me know if you'd like all of them and I can email them
directly to you as attachments -

Oct 18 20:40:27 sjev kernel: usb 4-3.2: USB disconnect, address 4
Oct 18 20:40:27 sjev kernel: usb 4-3.2: new high speed USB device
using address 12
Oct 18 20:40:27 sjev kernel: scsi8 : SCSI emulation for USB Mass Storage devices
Oct 18 20:40:28 sjev kernel:   Vendor: ST330063  Model: 1A
   Rev: 0000
Oct 18 20:40:28 sjev kernel:   Type:   Direct-Access
   ANSI SCSI revision: 02
Oct 18 20:40:28 sjev kernel: SCSI device sdc: 586072368 512-byte hdwr
sectors (300069 MB)
Oct 18 20:40:28 sjev kernel: sdc: assuming drive cache: write through
Oct 18 20:40:28 sjev kernel:  /dev/scsi/host8/bus0/target0/lun0: p1
Oct 18 20:40:28 sjev kernel: Attached scsi disk sdc at scsi8, channel
0, id 0, lun 0
Oct 18 20:40:28 sjev kernel: Attached scsi generic sg1 at scsi8,
channel 0, id 0, lun 0,  type 0
Oct 18 20:40:28 sjev kernel: USB Mass Storage device found at 12
Oct 18 20:40:28 sjev usb.agent[8548]:      usb-storage: already loaded
Oct 18 20:40:29 sjev scsi.agent[8571]:      sd_mod: loaded sucessfully
(for disk)
Oct 18 20:40:29 sjev kernel: scsi1 (0:0): rejecting I/O to dead device
Oct 18 20:40:29 sjev kernel: md: write_disk_sb failed for device sdb1
Oct 18 20:40:29 sjev kernel: md: errors occurred during superblock
update, repeating
Oct 18 20:40:29 sjev kernel: scsi1 (0:0): rejecting I/O to dead device
Oct 18 20:40:29 sjev kernel: md: write_disk_sb failed for device sdb1
Oct 18 20:40:29 sjev kernel: md: errors occurred during superblock
update, repeating
Oct 18 20:40:29 sjev kernel: scsi1 (0:0): rejecting I/O to dead device
Oct 18 20:40:29 sjev kernel: md: write_disk_sb failed for device sdb1
Oct 18 20:40:29 sjev kernel: md: errors occurred during superblock
update, repeating
Oct 18 20:40:29 sjev kernel: scsi1 (0:0): rejecting I/O to dead device

etc..

Oct 18 20:40:34 sjev kernel: md: errors occurred during superblock
update, repeating
Oct 18 20:40:34 sjev kernel: scsi1 (0:0): rejecting I/O to dead device
Oct 18 20:40:34 sjev kernel: md: write_disk_sb failed for device sdb1
Oct 18 20:40:34 sjev kernel: md: errors occurred during superblock
update, repeating
Oct 18 20:40:34 sjev kernel: scsi1 (0:0): rejecting I/O to dead device
Oct 18 20:40:34 sjev kernel: md: write_disk_sb failed for device sdb1
Oct 18 20:40:34 sjev kernel: md: excessive errors occurred during
superblock update, exiting
Oct 18 20:40:34 sjev kernel: scsi1 (0:0): rejecting I/O to dead device
Oct 18 20:40:34 sjev kernel: raid5: Disk failure on sdb1, disabling
device. Operation continuing on 0 devices
Oct 18 20:40:34 sjev kernel: RAID5 conf printout:
Oct 18 20:40:34 sjev kernel:  --- rd:3 wd:0 fd:2
Oct 18 20:40:34 sjev kernel:  disk 0, o:0, dev:sdb1
Oct 18 20:40:34 sjev kernel:  disk 2, o:1, dev:sdd1
Oct 18 20:40:34 sjev kernel: RAID5 conf printout:
Oct 18 20:40:34 sjev kernel:  --- rd:3 wd:0 fd:2
Oct 18 20:40:34 sjev kernel:  disk 2, o:1, dev:sdd1
Oct 18 20:40:34 sjev kernel: Buffer I/O error on device md1, logical block 3601
Oct 18 20:40:34 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:34 sjev kernel: Aborting journal on device md1.
Oct 18 20:40:35 sjev kernel: ext3_abort called.
Oct 18 20:40:35 sjev kernel: EXT3-fs abort (device md1):
ext3_journal_start: Detected aborted journal
Oct 18 20:40:35 sjev kernel: Remounting filesystem read-only
Oct 18 20:40:38 sjev kernel: Buffer I/O error on device md1, logical
block 103252006
Oct 18 20:40:38 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:38 sjev kernel: Buffer I/O error on device md1, logical
block 103252007
Oct 18 20:40:38 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:38 sjev kernel: Buffer I/O error on device md1, logical
block 103252008
Oct 18 20:40:38 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:38 sjev kernel: Buffer I/O error on device md1, logical
block 103252009
Oct 18 20:40:38 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:38 sjev kernel: Buffer I/O error on device md1, logical
block 103252010
Oct 18 20:40:38 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:38 sjev kernel: Buffer I/O error on device md1, logical
block 103252011
Oct 18 20:40:38 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:38 sjev kernel: Buffer I/O error on device md1, logical
block 103252012
Oct 18 20:40:38 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:38 sjev kernel: Buffer I/O error on device md1, logical
block 103252013
Oct 18 20:40:38 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:38 sjev kernel: Buffer I/O error on device md1, logical
block 103252014
Oct 18 20:40:38 sjev kernel: lost page write due to I/O error on md1
Oct 18 20:40:52 sjev kernel: printk: 35 messages suppressed.


later ..

Oct 18 22:12:39 sjev kernel: usb 4-3.3: new high speed USB device
using address 13
Oct 18 22:12:40 sjev usb.agent[21323]:      usb-storage: already loaded
Oct 18 22:12:40 sjev kernel: scsi9 : SCSI emulation for USB Mass Storage devices
Oct 18 22:12:40 sjev kernel:   Vendor: MAXTOR S  Model: TM3320620A
   Rev: 0000
Oct 18 22:12:40 sjev kernel:   Type:   Direct-Access
   ANSI SCSI revision: 02
Oct 18 22:12:40 sjev kernel: SCSI device sde: 625142448 512-byte hdwr
sectors (320073 MB)
Oct 18 22:12:40 sjev kernel: sde: assuming drive cache: write through
Oct 18 22:12:40 sjev kernel:  /dev/scsi/host9/bus0/target0/lun0: p1
Oct 18 22:12:40 sjev kernel: Attached scsi disk sde at scsi9, channel
0, id 0, lun 0
Oct 18 22:12:40 sjev kernel: Attached scsi generic sg2 at scsi9,
channel 0, id 0, lun 0,  type 0
Oct 18 22:12:40 sjev kernel: USB Mass Storage device found at 13
Oct 18 22:12:41 sjev scsi.agent[21357]:      sd_mod: loaded
sucessfully (for disk)
Oct 18 22:13:00 sjev kernel: md: trying to hot-add unknown-block(8,33)
to md1 ...
Oct 18 22:13:00 sjev kernel: md: bind<sdc1>
Oct 18 22:13:00 sjev kernel: RAID5 conf printout:
Oct 18 22:13:00 sjev kernel:  --- rd:3 wd:0 fd:2
Oct 18 22:13:00 sjev kernel:  disk 0, o:1, dev:sdc1
Oct 18 22:13:00 sjev kernel:  disk 2, o:1, dev:sdd1
Oct 18 22:13:00 sjev kernel: md: syncing RAID array md1
Oct 18 22:13:00 sjev kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Oct 18 22:13:00 sjev kernel: md: using maximum available idle IO
bandwith (but not more than 200000 KB/sec) for reconstruction.
Oct 18 22:13:00 sjev kernel: md: using 128k window, over a total of
293033536 blocks.
Oct 18 22:13:00 sjev kernel: md: md1: sync done.
Oct 18 22:13:00 sjev kernel: md: syncing RAID array md1
Oct 18 22:13:00 sjev kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Oct 18 22:13:00 sjev kernel: md: using maximum available idle IO
bandwith (but not more than 200000 KB/sec) for reconstruction.
Oct 18 22:13:00 sjev kernel: md: using 128k window, over a total of
293033536 blocks.
Oct 18 22:13:00 sjev kernel: md: md1: sync done.
Oct 18 22:13:01 sjev kernel: md: syncing RAID array md1

repeats until..

Oct 18 22:14:48 sjev kernel: md: syncing RAID array md1
Oct 18 22:14:48 sjev kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Oct 18 22:14:48 sjev kernel: md: using maximum available idle IO
bandwith (but not more than 200000 KB/sec) for reconstruction.
Oct 18 22:14:48 sjev kernel: md: using 128k window, over a total of
293033536 blocks.
Oct 18 22:14:48 sjev kernel: md: md1: sync done.
Oct 18 22:14:48 sjev kernel: Unable to handle kernel NULL pointer
dereference at virtual address 000000a4
Oct 18 22:14:48 sjev kernel:  printing eip:
Oct 18 22:14:48 sjev kernel: c0124d89
Oct 18 22:14:48 sjev kernel: *pde = 00000000
Oct 18 22:14:48 sjev kernel: Oops: 0000 [#1]
Oct 18 22:14:48 sjev kernel: PREEMPT
Oct 18 22:14:48 sjev kernel: Modules linked in: ipv6 smbfs
snd_intel8x0m snd_intel8x0 snd_ac97_codec snd_pcm snd_timer
snd_page_alloc gameport snd_mpu401_uart snd_rawmidi snd_seq_device snd
capability commoncap raid5 xor sr_mod tsdev mousedev joydev evdev
pcspkr pci_hotplug intel_agp agpgart ide_scsi ide_generic sg font
vesafb cfbcopyarea cfbimgblt cfbfillrect appletalk af_packet hw_random
i810_audio soundcore ac97_codec b44 mii yenta_socket rtc piix unix ds
pcmcia_core usb_storage ext3 mbcache raid1 md jbd ehci_hcd ohci_hcd
uhci_hcd usbcore reiserfs psmouse ide_disk ide_cd ide_core cdrom
sd_mod scsi_mod
Oct 18 22:14:48 sjev kernel: CPU:    0
Oct 18 22:14:48 sjev kernel: EIP:    0060:[sig_ignored+73/112]    Not tainted
Oct 18 22:14:48 sjev kernel: EFLAGS: 00010006   (2.6.8-3-686)
Oct 18 22:14:48 sjev kernel: EIP is at sig_ignored+0x49/0x70
Oct 18 22:14:48 sjev kernel: eax: 000000b4   ebx: 00000000   ecx:
00000008   edx: 00000000
Oct 18 22:14:48 sjev kernel: esi: 00000009   edi: 00000009   ebp:
00000000   esp: cedf3ec0
Oct 18 22:14:48 sjev kernel: ds: 007b   es: 007b   ss: 0068
Oct 18 22:14:48 sjev kernel: Process md1_raid5 (pid: 685,
threadinfo=cedf2000 task=cedef3e0)
Oct 18 22:14:48 sjev kernel: Stack: cf10e1b0 00000001 c01259f3
cf10e1b0 00000009 c86194a0 cf99771c 00000202
Oct 18 22:14:48 sjev kernel:        cedf2000 cf997680 cf222c00
c0126565 00000009 00000001 cf10e1b0 c86194a0
Oct 18 22:14:48 sjev kernel:        cedf3f30 cf997680 d093eb7d
00000009 00000001 cf10e1b0 d093ebcd c86194a0
Oct 18 22:14:48 sjev kernel: Call Trace:
Oct 18 22:14:48 sjev kernel:  [specific_send_sig_info+83/224]
specific_send_sig_info+0x53/0xe0
Oct 18 22:14:48 sjev kernel:  [send_sig_info+69/128] send_sig_info+0x45/0x80
Oct 18 22:14:48 sjev kernel:  [__crc_sb_min_blocksize+815035/1015327]
md_interrupt_thread+0x4d/0x60 [md]
Oct 18 22:14:48 sjev kernel:  [__crc_sb_min_blocksize+815115/1015327]
md_unregister_thread+0x3d/0x60 [md]
Oct 18 22:14:48 sjev kernel:  [recalc_task_prio+168/416]
recalc_task_prio+0xa8/0x1a0
Oct 18 22:14:48 sjev kernel:  [__crc_sb_min_blocksize+821862/1015327]
md_check_recovery+0x288/0x300 [md]
Oct 18 22:14:48 sjev kernel:  [__crc_fb_pan_display+1312520/2923165]
raid5d+0x19/0x150 [raid5]
Oct 18 22:14:48 sjev kernel:  [__crc_sb_min_blocksize+814642/1015327]
md_thread+0x164/0x1d0 [md]
Oct 18 22:14:48 sjev kernel:  [autoremove_wake_function+0/96]
autoremove_wake_function+0x0/0x60
Oct 18 22:14:48 sjev kernel:  [ret_from_fork+6/20] ret_from_fork+0x6/0x14
Oct 18 22:14:48 sjev kernel:  [autoremove_wake_function+0/96]
autoremove_wake_function+0x0/0x60
Oct 18 22:14:48 sjev kernel:  [__crc_sb_min_blocksize+814286/1015327]
md_thread+0x0/0x1d0 [md]
Oct 18 22:14:48 sjev kernel:  [kernel_thread_helper+5/24]
kernel_thread_helper+0x5/0x18
Oct 18 22:14:48 sjev kernel: Code: 8b 40 f0 83 f8 01 74 18 85 c0 74 04
89 d3 eb c1 83 fe 1f 7f
Oct 18 22:14:48 sjev kernel:  <6>note: md1_raid5[685] exited with
preempt_count 2


>
>>
>> Can someone *please* help me get the raid back!?
>
> Probably.
>

I like the optimism! Thanks!

>>
>> More details -
>>
>> Drives are /dev/sdb1, /dev/sdc1 & /dev/sdd1
>
> ... or were.  USB device names can change every time you plug them in.
>
>>
>> sdc1 was the one that died earlier this week
>> sdb1 appears to be the one that was marked as faulty
>>
>> mdadm detail before sdc1 was plugged in -
>>
>> root@imp[~]:11 # mdadm --detail /dev/md1
>> /dev/md1:
> ...
>>
>> Number Major Minor RaidDevice State
>> 0 8 17 0 active sync /dev/sdb1
>> 1 0 0 - removed
>> 2 8 49 2 active sync /dev/sdd1
>
> So the array thinks the 2nd of 3 is missing.  That is consistent with
> your description.
>
>>
>>
>> then after plugging in the replacement sdc1 -
>>
>> root@imp[~]:13 # mdadm --add /dev/md1 /dev/sdc1
>> mdadm: hot added /dev/sdc1
>> root@imp[~]:14 #
>> root@imp[~]:14 #
>> root@imp[~]:14 # mdadm --detail /dev/md1
>> /dev/md1:
> ...
>>
>> Number Major Minor RaidDevice State
>> 0 0 0 - removed
>> 1 0 0 - removed
>> 2 8 49 2 active sync /dev/sdd1
>>
>> 3 8 33 0 spare rebuilding /dev/sdc1
>> 4 8 17 - faulty /dev/sdb1
>
> Yes, sdb must have got an error and failed while sdc was rebuilding.
> Sad.  That suggests that it didn't fail at the moment of USB
> insertion, but a little later.  Not conclusively though.
>
>>
>> Shortly after this, subsequent mdadm --details stopped responding.. So
>> I rebooted in the hope I could reset and problems with the hot add..
>>
>> Now, I'm unable to assemble the raid with the 2 working drives -
>>
>> mdadm --assemble /dev/md1 /dev/sdb1 /dev/sdd1
>>
>> doesn't work -
>>
>> mdadm: /dev/md1 assembled from 1 drive and 1 spare - not enough to
>> start the array.
>
> You have rebooted so device names may have changed.
> If it thought you had named a good drive and a spare, it probably saw
> the device that was originally sdb (and possibly still is)
> and the device that was originally sdc (and now might be sdd).
>
>>
>> mdadm --assemble --force /dev/md1 /dev/sdb1 /dev/sdd1
>>
>> doesn't' work either
>
> What error messages?  Always best to be explicit.
> Adding "-v" to the --assemble line would help too.
>
>>
>> This -
>>
>> mdadm --assemble --force --run /dev/md1 /dev/sdb1 /dev/sdd1
>>
>> Did work partially -
>>
> Hmm.. That really shouldn't have worked.  The kernel should have
> rejected the array...
>
>>
>> Here's the output from mdadm -E on each of the 2 drives -
>
> Uhm... There should be 3 drives?
> The 'good' one, the 'new' one, and the one that seemed to fail
> immediately after you plugged in the 'new' one.
>

Sorry, here are all 3 -

root@imp[~]:3 # mdadm -E /dev/sd[bcd]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : bed40ee2:98523fdd:e4d010fb:894c0966
  Creation Time : Fri Nov 17 21:28:44 2006
     Raid Level : raid5
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Sat Oct 18 22:14:48 2008
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 1
       Checksum : e6dbf86 - correct
         Events : 0.1521614

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       33        0      spare   /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : bed40ee2:98523fdd:e4d010fb:894c0966
  Creation Time : Fri Nov 17 21:28:44 2006
     Raid Level : raid5
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Fri Oct 17 22:30:49 2008
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : e6ae9ea - correct
         Events : 0.1471469

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       33        3      spare   /dev/sdc1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       33        3      spare   /dev/sdc1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : bed40ee2:98523fdd:e4d010fb:894c0966
  Creation Time : Fri Nov 17 21:28:44 2006
     Raid Level : raid5
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Sat Oct 18 22:14:48 2008
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 1
       Checksum : e6dbf75 - correct
         Events : 0.1521614

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       33        3      spare   /dev/sdc1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       33        3      spare   /dev/sdc1

fdisk details too -

root@imp[~]:7 # fdisk -l /dev/sd[bcd]

Disk /dev/sdb: 300.0 GB, 300069052416 bytes
255 heads, 63 sectors/track, 36481 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       36481   293033601   fd  Linux raid autodetect

Disk /dev/sdc: 320.0 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       36481   293033601   fd  Linux raid autodetect

Disk /dev/sdd: 300.0 GB, 300069052416 bytes
255 heads, 63 sectors/track, 36481 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       36481   293033601   fd  Linux raid autodetect


>>
>> /dev/sdb1:
> ..
>> Number Major Minor RaidDevice State
>> this 3 8 33 3 spare /dev/sdc1
>>
>> 0 0 0 0 0 removed
>> 1 1 0 0 1 faulty removed
>> 2 2 8 49 2 active sync /dev/sdd1
>> 3 3 8 33 3 spare /dev/sdc1
>
> sdb looks like the new one.
>
>> /dev/sdd1:
> ...
>>
>> Number Major Minor RaidDevice State
>> this 2 8 49 2 active sync /dev/sdd1
>>
>> 0 0 0 0 0 removed
>> 1 1 0 0 1 faulty removed
>> 2 2 8 49 2 active sync /dev/sdd1
>> 3 3 8 33 0 spare /dev/sdc1
>
> sdd looks like the good one.
>
> Where is the "one that seemed to fail" which was once called sdb ??
>>
>> Is all the data lost, or can I recover from this?
>
> Try
>
>  mdadm --examine --brief --verbose /dev/sd*
>

ARRAY /dev/md1 level=raid5 num-devices=3
UUID=bed40ee2:98523fdd:e4d010fb:894c0966
   devices=/dev/sdb1,/dev/sdc1,/dev/sdd1
ARRAY /dev/md4 level=raid1 num-devices=2
UUID=6fded12b:6ecdca8a:18400b9a:df6a2ffc
   devices=/dev/sda5
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=c94d0631:20f0db42:9c6ab972:19acc617
   devices=/dev/sda1

>
> Then
>
>  mdadm --assemble --force --verbose /dev/md1 /dev/sd....
>
> where you list all the devices in the device= section for the array
> you want to try to start.
>
> Report the output of that command and whether it was successful.

root@imp[~]:9 # mdadm --assemble --force --verbose /dev/md1 /dev/sdb1
/dev/sdc1 /dev/sdd1
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 3.
mdadm: no uptodate device for slot 0 of /dev/md1
mdadm: no uptodate device for slot 1 of /dev/md1
mdadm: added /dev/sdd1 to /dev/md1 as 3
mdadm: added /dev/sdb1 to /dev/md1 as 2
mdadm: /dev/md1 assembled from 1 drive and 1 spare - not enough to
start the array.
root@imp[~]:10 #

Oct 29 14:52:41 sjev kernel: md: md1 stopped.
Oct 29 14:52:41 sjev kernel: md: unbind<sdb1>
Oct 29 14:52:41 sjev kernel: md: export_rdev(sdb1)
Oct 29 14:52:41 sjev kernel: md: unbind<sdd1>
Oct 29 14:52:41 sjev kernel: md: export_rdev(sdd1)
Oct 29 14:52:41 sjev kernel: md: bind<sdd1>
Oct 29 14:52:41 sjev kernel: md: bind<sdb1>
Oct 29 14:58:07 sjev smartd[2302]: Device: /dev/hdc, SMART Usage
Attribute: 190 Unknown_Attribute changed from 49 to 48
Oct 29 14:58:07 sjev smartd[2302]: Device: /dev/hdc, SMART Usage
Attribute: 194 Temperature_Celsius changed from 51 to 52

I've held off upgrading mdadm to the latest version until I know it's
the best option (vs recovering the raid 1st before upgrading), so you
agree?

>
> NeilBrown
>

Thanks for your patience and help!
Regards,
Steve..
