From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: RAID-5 creation crashes when files system installed while recovery going on
Date: Fri, 26 Jun 2009 11:27:50 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07A31C9D@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0797AC80@SDCEXCHANGE01.ad.amcc.com> <a5f578de750a09c145f5d4f50e90a4f8.squirrel@neil.brown.name> <AC5E1C3367E37D44970B81A6ADD1DA2C0534ABE5@SDCEXCHANGE01.ad.amcc.com> <a765142d3b99baf3edb3da397b2ee350.squirrel@neil.brown.name> <AC5E1C3367E37D44970B81A6ADD1DA2C07A318FD@SDCEXCHANGE01.ad.amcc.com> <e9c3a7c20906251825i14c735f9kb5ddd7fe0d50d655@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <e9c3a7c20906251825i14c735f9kb5ddd7fe0d50d655@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Dan.=20
   Looks like my ADMA driver has issue. I will debug more into it.
Regards,
Marri

-----Original Message-----
=46rom: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On B=
ehalf Of Dan Williams
Sent: Thursday, June 25, 2009 6:26 PM
To: Tirumala Reddy Marri
Cc: NeilBrown; linux-raid@vger.kernel.org
Subject: Re: RAID-5 creation crashes when files system installed while =
recovery going on

On Wed, Jun 24, 2009 at 4:45 PM, Tirumala Reddy Marri<tmarri@amcc.com> =
wrote:
> Hi Dan,
> =A0 I am suspecting that ADMA driver has all the XOR operations queue=
d up
> for processing and file-system mount is not waiting till ADMA finishe=
s
> all the requests. Is this working fine on Intel IO-Processor ?

Yes, this works fine on iop13xx with 2.6.30, see the log below.  Check
to see if your driver can run dmatest (CONFIG_DMATEST).  Make sure
CONFIG_NET_DMA=3Dn and the raid456 module is not loaded, otherwise
dmatest will not be able to acquire the channels.

Regards,
Dan

iq81340mc:~# mdadm --create /dev/md0 /dev/sd[a-d] -n 4 -l 5
md: bind<sda>
md: bind<sdb>
md: bind<sdc>
md: bind<sdd>
raid5: device sdc operational as raid disk 2
raid5: device sdb operational as raid disk 1
raid5: device sda operational as raid disk 0
raid5: allocated 4208kB for md0
raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:3
 disk 0, o:1, dev:sda
 disk 1, o:1, dev:sdb
 disk 2, o:1, dev:sdc
RAID5 conf printout:
 --- rd:4 wd:3
 disk 0, o:1, dev:sda
 disk 1, o:1, dev:sdb
 disk 2, o:1, dev:sdc
 disk 3, o:1, dev:sdd
md0: detected capacity change from 0 to 240078815232
 md0:<6>md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for recovery.
md: using 128k window, over a total of 78150656 blocks.
 unknown partition table
mdadm: array /dev/md/0 started.
iq81340mc:~# mkfs /dev/md0
mke2fs 1.40-WIP (14-Nov-2006)
=46ilesystem label=3D
OS type: Linux
Block size=3D4096 (log=3D2)
=46ragment size=3D4096 (log=3D2)
29310976 inodes, 58612992 blocks
2930649 blocks (5.00%) reserved for the super user
=46irst data block=3D0
Maximum filesystem blocks=3D0
1789 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, =
2654208,
        4096000, 7962624, 11239424, 20480000, 23887872
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 24 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
iq81340mc:~# cat /proc/interrupts
           CPU0
  0:       6929   IOP13xx-1  iop-adma
  1:     301173   IOP13xx-1  iop-adma
  2:     186895   IOP13xx-1  iop-adma
  3:     187957   IOP13xx-1  iop-adma
  4:          0   IOP13xx-1  iop-adma
  5:          5   IOP13xx-1  iop-adma
  8:      18175   IOP13xx-1  IOP Timer Tick
 10:          0   IOP13xx-1  IOP3xx-I2C
 11:          0   IOP13xx-1  IOP3xx-I2C
 25:     127234   IOP13xx-1  sata_vsc
 26:      31572   IOP13xx-1  eth0
 52:       3937   IOP13xx-2  serial
 57:          0   IOP13xx-2  iop-adma
 58:          0   IOP13xx-2  iop-adma
 59:          0   IOP13xx-2  iop-adma
 96:          0   IOP13xx-4  IOP3xx-I2C
Err:          0

iq81340mc:~# fsck /dev/md0
fsck 1.40-WIP (14-Nov-2006)
e2fsck 1.40-WIP (14-Nov-2006)
/dev/md0: clean, 12/29310976 files, 960553/58612992 blocks
iq81340mc:~# mdadm --fail /dev/md0 /dev/sdd
raid5: Disk failure on sdd, disabling device.
raid5: Operation continuing on 3 devices.
md: md0: recovery done.
mdadm: set /dev/sdd faulty in /dev/md0
RAID5 conf printout:
 --- rd:4 wd:3
 disk 0, o:1, dev:sda
 disk 1, o:1, dev:sdb
 disk 2, o:1, dev:sdc
 disk 3, o:0, dev:sdd
RAID5 conf printout:
 --- rd:4 wd:3
 disk 0, o:1, dev:sda
 disk 1, o:1, dev:sdb
 disk 2, o:1, dev:sdc
iq81340mc:~# echo 3 > /proc/sys/vm/drop_caches
iq81340mc:~# fsck /dev/md0
fsck 1.40-WIP (14-Nov-2006)
e2fsck 1.40-WIP (14-Nov-2006)
/dev/md0: clean, 12/29310976 files, 960553/58612992 blocks
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
