From: John Valarti <mdadmuser@gmail.com>
Subject: =?UTF-8?Q?Re=3A_Server_down=2Dfail=E2=80=8Bed_RAID5=2Dasking_for_some_assi?=
	=?UTF-8?Q?stance?=
Date: Sun, 24 Apr 2011 01:06:52 -0600
Message-ID: <BANLkTi=8P75-wUBq149wiM-=XGVa2HBuvA@mail.gmail.com>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
	<20110422125734.1a68a736@notabene.brown>
	<BANLkTin0SoBzRAear8Jt+26MnVJWouXoNA@mail.gmail.com>
	<20110423074411.78fef94f@notabene.brown>
	<BANLkTik_ZY4uoV3E=ua1p+tUD9g8xqQDVg@mail.gmail.com>
	<20110423184824.55ee7893@notabene.brown>
	<BANLkTi=sCfFFfmZTzj2g8-aDNhDqVK8e-A@mail.gmail.com>
	<20110424075101.6763309f@notabene.brown>
	<BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
	<20110424125401.3de3720d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110424125401.3de3720d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 23, 2011 at 8:54 PM, NeilBrown <neilb@suse.de> wrote:
=2E.
> Could you please run this set of commands exactly as given and send m=
e the
> complete output. =A0Maybe put them in a file and run
> =A0sh -x file > /path/on/usb 2>&1
>
>
> cat /proc/mdstat
> mdadm --stop --verbose /dev/md1
> ls -l /dev/sd[acd]2
> mdadm -E /dev/sd[acd]2
> mdadm -Afvv /dev/md1 /dev/sd[acd]2
> cat /proc/mdstat
> dmesg | tail -100
>

Here you go. I warn you it is a bit long!

+ cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
unused devices: <none>
+ mdadm --stop --verbose /dev/md1
mdadm: stopped /dev/md1
+ ls -l /dev/sda2 /dev/sdb2 /dev/sdc2
brw------- 1 root root 8,  2 Apr 23 14:39 /dev/sda2
brw------- 1 root root 8, 18 Apr 23 14:39 /dev/sdb2
brw------- 1 root root 8, 34 Apr 23 14:39 /dev/sdc2
+ mdadm -E /dev/sda2 /dev/sdb2 /dev/sdc2
/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ddf4d448:36afa319:f0917855:03f8bbe8
  Creation Time : Mon May 15 16:38:05 2006
     Raid Level : raid5
  Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
     Array Size : 734925312 (700.88 GiB 752.56 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 1

    Update Time : Mon Apr 18 07:48:54 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5674ce60 - correct
         Events : 28580020

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       0        0        3      faulty removed
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ddf4d448:36afa319:f0917855:03f8bbe8
  Creation Time : Mon May 15 16:38:05 2006
     Raid Level : raid5
  Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
     Array Size : 734925312 (700.88 GiB 752.56 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 1

    Update Time : Mon Apr 18 07:48:51 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5674ce6b - correct
         Events : 28580018

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     2       8       34        2      active sync   /dev/sdc2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       0        0        3      faulty removed
/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ddf4d448:36afa319:f0917855:03f8bbe8
  Creation Time : Mon May 15 16:38:05 2006
     Raid Level : raid5
  Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
     Array Size : 734925312 (700.88 GiB 752.56 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 1

    Update Time : Mon Apr 18 07:48:54 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5674ce4e - correct
         Events : 28580020

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       0        0        3      faulty removed
+ mdadm -Afvv /dev/md1 /dev/sda2 /dev/sdb2 /dev/sdc2
mdadm: looking for devices for /dev/md1
mdadm: no devices found for /dev/md1
+ cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
unused devices: <none>
+ dmesg
+ tail -100
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<5>SCSI device sdd: 2030592 512-byte hdwr sectors (1040 MB)
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<6> sdd: sdd1
<5>sd 3:0:0:0: Attached scsi removable disk sdd
<7>usb-storage: device scan complete
<7>SELinux: initialized (dev sdd1, type vfat), uses genfs_contexts
<6>md: md0 stopped.
<6>md: md0 stopped.
<6>usb 1-3: USB disconnect, address 3
<6>md: md1 stopped.
<6>usb 1-3: new high speed USB device using ehci_hcd and address 4
<6>usb 1-3: configuration #1 chosen from 1 choice
<6>scsi4 : SCSI emulation for USB Mass Storage devices
<7>usb-storage: device found at 4
<7>usb-storage: waiting for device to settle before scanning
<5>  Vendor: Kingston  Model: DataTraveler R    Rev: PMAP
<5>  Type:   Direct-Access                      ANSI SCSI revision: 00
<5>SCSI device sdd: 2030592 512-byte hdwr sectors (1040 MB)
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<5>SCSI device sdd: 2030592 512-byte hdwr sectors (1040 MB)
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<6> sdd: sdd1
<5>sd 4:0:0:0: Attached scsi removable disk sdd
<7>usb-storage: device scan complete
<7>SELinux: initialized (dev sdd1, type vfat), uses genfs_contexts
<6>usb 1-3: USB disconnect, address 4
<6>usb 1-3: new high speed USB device using ehci_hcd and address 5
<6>usb 1-3: configuration #1 chosen from 1 choice
<6>scsi5 : SCSI emulation for USB Mass Storage devices
<7>usb-storage: device found at 5
<7>usb-storage: waiting for device to settle before scanning
<5>  Vendor: Kingston  Model: DataTraveler R    Rev: PMAP
<5>  Type:   Direct-Access                      ANSI SCSI revision: 00
<5>SCSI device sdd: 2030592 512-byte hdwr sectors (1040 MB)
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<5>SCSI device sdd: 2030592 512-byte hdwr sectors (1040 MB)
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<6> sdd: sdd1
<5>sd 5:0:0:0: Attached scsi removable disk sdd
<7>usb-storage: device scan complete
<7>SELinux: initialized (dev sdd1, type vfat), uses genfs_contexts
<6>usb 1-3: USB disconnect, address 5
<6>usb 1-3: new high speed USB device using ehci_hcd and address 6
<6>usb 1-3: configuration #1 chosen from 1 choice
<6>scsi6 : SCSI emulation for USB Mass Storage devices
<7>usb-storage: device found at 6
<7>usb-storage: waiting for device to settle before scanning
<5>  Vendor: Kingston  Model: DataTraveler R    Rev: PMAP
<5>  Type:   Direct-Access                      ANSI SCSI revision: 00
<5>SCSI device sdd: 2030592 512-byte hdwr sectors (1040 MB)
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<5>SCSI device sdd: 2030592 512-byte hdwr sectors (1040 MB)
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<6> sdd: sdd1
<5>sd 6:0:0:0: Attached scsi removable disk sdd
<7>usb-storage: device scan complete
<7>SELinux: initialized (dev sdd1, type vfat), uses genfs_contexts
<6>usb 1-3: USB disconnect, address 6
<6>md: md1 stopped.
<6>md: md1 stopped.
<6>md: md1 stopped.
<6>md: md1 stopped.
<6>usb 1-3: new high speed USB device using ehci_hcd and address 7
<6>usb 1-3: configuration #1 chosen from 1 choice
<6>scsi7 : SCSI emulation for USB Mass Storage devices
<7>usb-storage: device found at 7
<7>usb-storage: waiting for device to settle before scanning
<5>  Vendor: Kingston  Model: DataTraveler R    Rev: PMAP
<5>  Type:   Direct-Access                      ANSI SCSI revision: 00
<5>SCSI device sdd: 2030592 512-byte hdwr sectors (1040 MB)
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<5>SCSI device sdd: 2030592 512-byte hdwr sectors (1040 MB)
<5>sdd: Write Protect is off
<7>sdd: Mode Sense: 23 00 00 00
<3>sdd: assuming drive cache: write through
<6> sdd: sdd1
<5>sd 7:0:0:0: Attached scsi removable disk sdd
<7>usb-storage: device scan complete
<7>SELinux: initialized (dev sdd1, type vfat), uses genfs_contexts
<6>md: md1 stopped.
<6>md: md1 stopped.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
