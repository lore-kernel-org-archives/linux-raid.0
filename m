From: "Tim Harvey" <tharvey@alumni.calpoly.edu>
Subject: RE: mounting of unknown filesystem type on RAID5 array
Date: Thu, 3 Jun 2004 14:32:37 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000001c449b2$4a8fa230$7001a8c0@darwin>
References: <000101c44938$9daca4b0$7001a8c0@darwin>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000101c44938$9daca4b0$7001a8c0@darwin>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I finally figured out how the filesystems were stored.  The XFS log
device was an external partition and once I specified it appropriately I
was able to mount the data filesystem and retrieve my data.

Thanks for all the help on this list!  In learning about linux RAID I
was very impressed with the ease of use of the mdadm tool!

Tim

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Tim Harvey
> Sent: Thursday, June 03, 2004 12:02 AM
> To: linux-raid@vger.kernel.org
> Subject: RE: mounting of unknown filesystem type on RAID5 array
> 
> Neither of those tools will work as a RAID array doesn't have a
> partition table, just a filesystem.
> 
> I've discovered that the filesystem is an LVM filesystem and I've done
a
> 'vgscan' which found two volume groups from 2 of the RAID arrays I'm
> trying to recover:
> 
> [root@masterbackend root]# vgdisplay -D
> --- Volume group ---
> VG Name               vgroup00
> VG Access             read/write
> VG Status             NOT available/resizable
> VG #                  0
> MAX LV                256
> Cur LV                1
> Open LV               0
> MAX LV Size           1023.97 GB
> Max PV                256
> Cur PV                1
> Act PV                1
> VG Size               832.28 GB
> PE Size               16 MB
> Total PE              53266
> Alloc PE / Size       53266 / 832.28 GB
> Free  PE / Size       0 / 0
> VG UUID               oizRKm-JFUq-hMiZ-rN6F-1M7u-mRDc-vqqy1p
> 
> --- Volume group ---
> VG Name               logdev
> VG Access             read/write
> VG Status             NOT available/resizable
> VG #                  1
> MAX LV                256
> Cur LV                2
> Open LV               0
> MAX LV Size           255.99 GB
> Max PV                256
> Cur PV                1
> Act PV                1
> VG Size               1.46 GB
> PE Size               4 MB
> Total PE              375
> Alloc PE / Size       138 / 552 MB
> Free  PE / Size       237 / 948 MB
> VG UUID               nCpyXh-5bn4-Qh2W-UlAc-3dyh-zQOT-i33ow8
> 
> So far I'm not understanding how to make the VG Status 'available' and
> how to mount them.  I now have the following devices:
> 
> /dev/vgroup00/storage1 block special (58/2)
> /dev/vgroup00/group character specail (109/0)
> /dev/logdev/storage1 block special (58/1)
> /dev/logdev/syslog block special (58/0)
> /dev/logdev/group character special (109/1)
> 
> I believe these are XFS filesystems based on examination of some of
the
> raw data in the /dev/md's.  But I still can't mount them via:
> 
> [root@masterbackend root]# mount /dev/vgroup00/storage1 /mnt/array/ -t
> xfs
> mount: wrong fs type, bad option, bad superblock on
> /dev/vgroup00/storage1,
>        or too many mounted file systems
> 
> Any ideas?  I'm not familiar with LVM, but have been googling it.  I
> think its time to post this over on the linux-lvm maillist.
> 
> Tim
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of M K
> > Sent: Wednesday, June 02, 2004 2:58 PM
> > To: Tim Harvey; linux-raid@vger.kernel.org
> > Subject: Re: mounting of unknown filesystem type on RAID5 array
> >
> > would it be possible to examine the fs using
> > parted or fdisk ?
> > --- Tim Harvey <tharvey@alumni.calpoly.edu> wrote:
> > > Greetings,
> > >
> > > I'm trying to mount a RAID5 array created on a
> > > NASAS-2040 which uses an
> > > embedded Linux OS which has failed.  I'm having
> > > trouble determining the
> > > filesystem type used.  I've physically connected 3
> > > out of the 4 drives,
> > > so as to start it in degraded mode and pull the data
> > > off.  Here are
> > > sections of my logs:
> > >
> > > Jun  2 13:58:16 localhost kernel: hda:
> > > IBM-DJNA-351520, ATA DISK drive
> > > Jun  2 13:58:16 localhost kernel: hdb: Maxtor
> > > 5A300J0, ATA DISK drive
> > > Jun  2 13:58:16 localhost kernel: blk: queue
> > > c03fcf00, I/O limit 4095Mb
> > > (mask 0xffffffff)
> > > Jun  2 13:58:16 localhost kernel: blk: queue
> > > c03fd040, I/O limit 4095Mb
> > > (mask 0xffffffff)
> > > Jun  2 13:58:16 localhost kernel: hdc: Maxtor
> > > 5A300J0, ATA DISK drive
> > > Jun  2 13:58:16 localhost kernel: hdd: Maxtor
> > > 5A300J0, ATA DISK drive
> > > Jun  2 13:58:16 localhost kernel: blk: queue
> > > c03fd35c, I/O limit 4095Mb
> > > (mask 0xffffffff)
> > > Jun  2 13:58:16 localhost kernel: blk: queue
> > > c03fd49c, I/O limit 4095Mb
> > > (mask 0xffffffff)
> > > Jun  2 13:58:16 localhost kernel: ide0 at
> > > 0x1f0-0x1f7,0x3f6 on irq 14
> > > Jun  2 13:58:16 localhost kernel: ide1 at
> > > 0x170-0x177,0x376 on irq 15
> > > Jun  2 13:58:16 localhost kernel: hda: attached
> > > ide-disk driver.
> > > Jun  2 13:58:16 localhost kernel: hda: host
> > > protected area => 1
> > > Jun  2 13:58:16 localhost kernel: hda: 30033360
> > > sectors (15377 MB)
> > > w/430KiB Cache, CHS=1869/255/63
> > > Jun  2 13:58:16 localhost kernel: hdb: attached
> > > ide-disk driver.
> > > Jun  2 13:58:16 localhost kernel: hdb: host
> > > protected area => 1
> > > Jun  2 13:58:16 localhost kernel: hdb: 585940320
> > > sectors (300001 MB)
> > > w/2048KiB Cache, CHS=36473/255/63, UDMA(133)
> > > Jun  2 13:58:16 localhost kernel: hdc: attached
> > > ide-disk driver.
> > > Jun  2 13:58:16 localhost kernel: hdc: host
> > > protected area => 1
> > > Jun  2 13:58:16 localhost kernel: hdc: 585940320
> > > sectors (300001 MB)
> > > w/2048KiB Cache, CHS=36473/255/63, UDMA(133)
> > > Jun  2 13:58:16 localhost kernel: hdd: attached
> > > ide-disk driver.
> > > Jun  2 13:58:16 localhost kernel: hdd: host
> > > protected area => 1
> > > Jun  2 13:58:16 localhost kernel: hdd: 585940320
> > > sectors (300001 MB)
> > > w/2048KiB Cache, CHS=36473/255/63, UDMA(133)
> > > Jun  2 13:58:16 localhost kernel: Partition check:
> > > Jun  2 13:58:16 localhost kernel:  hda: hda1 hda2
> > > hda3
> > > Jun  2 13:58:16 localhost kernel:  hdb: hdb1 hdb2
> > > hdb3
> > > Jun  2 13:58:16 localhost kernel:  hdc: hdc1 hdc2
> > > hdc3
> > > Jun  2 13:58:16 localhost kernel:  hdd: hdd1 hdd2
> > > hdd3
> > > Jun  2 13:58:16 localhost kernel: ide: late
> > > registration of driver.
> > > Jun  2 13:58:16 localhost kernel: md: md driver
> > > 0.90.0 MAX_MD_DEVS=256,
> > > MD_SB_DISKS=27
> > > Jun  2 13:58:16 localhost kernel: md: Autodetecting
> > > RAID arrays.
> > > Jun  2 13:58:16 localhost kernel:  [events:
> > > 00000008]
> > > Jun  2 13:58:17 localhost last message repeated 2
> > > times
> > > Jun  2 13:58:17 localhost kernel: md: autorun ...
> > > Jun  2 13:58:17 localhost kernel: md: considering
> > > hdd1 ...
> > > Jun  2 13:58:17 localhost kernel: md:  adding hdd1
> > > ...
> > > Jun  2 13:58:17 localhost kernel: md:  adding hdc1
> > > ...
> > > Jun  2 13:58:17 localhost kernel: md:  adding hdb1
> > > ...
> > > Jun  2 13:58:17 localhost kernel: md: created md0
> > > Jun  2 13:58:17 localhost kernel: md: bind<hdb1,1>
> > > Jun  2 13:58:17 localhost kernel: md: bind<hdc1,2>
> > > Jun  2 13:58:17 localhost kernel: md: bind<hdd1,3>
> > > Jun  2 13:58:17 localhost kernel: md: running:
> > > <hdd1><hdc1><hdb1>
> > > Jun  2 13:58:17 localhost kernel: md: hdd1's event
> > > counter: 00000008
> > > Jun  2 13:58:17 localhost kernel: md: hdc1's event
> > > counter: 00000008
> > > Jun  2 13:58:17 localhost kernel: md: hdb1's event
> > > counter: 00000008
> > > Jun  2 13:58:17 localhost kernel: kmod: failed to
> > > exec /sbin/modprobe -s
> > > -k md-personality-4, errno = 2
> > > Jun  2 13:58:17 localhost kernel: md: personality 4
> > > is not loaded!
> > > Jun  2 13:58:17 localhost kernel: md :do_md_run()
> > > returned -22
> > > Jun  2 13:58:17 localhost kernel: md: md0 stopped.
> > > Jun  2 13:58:17 localhost kernel: md: unbind<hdd1,2>
> > > Jun  2 13:58:17 localhost kernel: md:
> > > export_rdev(hdd1)
> > > Jun  2 13:58:17 localhost kernel: md: unbind<hdc1,1>
> > > Jun  2 13:58:17 localhost kernel: md:
> > > export_rdev(hdc1)
> > > Jun  2 13:58:17 localhost kernel: md: unbind<hdb1,0>
> > > Jun  2 13:58:17 localhost kernel: md:
> > > export_rdev(hdb1)
> > > Jun  2 13:58:17 localhost kernel: md: ... autorun
> > > DONE.
> > > ...
> > > Jun  2 14:01:59 localhost kernel:  [events:
> > > 00000008]
> > > Jun  2 14:01:59 localhost kernel: md: bind<hdc1,1>
> > > Jun  2 14:01:59 localhost kernel:  [events:
> > > 00000008]
> > > Jun  2 14:01:59 localhost kernel: md: bind<hdd1,2>
> > > Jun  2 14:01:59 localhost kernel:  [events:
> > > 00000008]
> > > Jun  2 14:01:59 localhost kernel: md: bind<hdb1,3>
> > > Jun  2 14:01:59 localhost kernel: md: hdb1's event
> > > counter: 00000008
> > > Jun  2 14:01:59 localhost kernel: md: hdd1's event
> > > counter: 00000008
> > > Jun  2 14:01:59 localhost kernel: md: hdc1's event
> > > counter: 00000008
> > > Jun  2 14:01:59 localhost kernel: raid5: measuring
> > > checksumming speed
> > > Jun  2 14:01:59 localhost kernel:    8regs     :
> > > 2060.800 MB/sec
> > > Jun  2 14:01:59 localhost kernel:    32regs    :
> > > 1369.200 MB/sec
> > > Jun  2 14:01:59 localhost kernel:    pIII_sse  :
> > > 3178.800 MB/sec
> > > Jun  2 14:01:59 localhost kernel:    pII_mmx   :
> > > 3168.800 MB/sec
> > > Jun  2 14:01:59 localhost kernel:    p5_mmx    :
> > > 4057.600 MB/sec
> > > Jun  2 14:01:59 localhost kernel: raid5: using
> > > function: pIII_sse
> > > (3178.800 MB/sec)
> > > Jun  2 14:01:59 localhost kernel: md: raid5
> > > personality registered as nr
> > > 4
> > > Jun  2 14:01:59 localhost kernel: md0: max total
> > > readahead window set to
> > > 744k
> > > Jun  2 14:01:59 localhost kernel: md0: 3 data-disks,
> > > max readahead per
> > > data-disk: 248k
> > > Jun  2 14:01:59 localhost kernel: raid5: device hdb1
> > > operational as raid
> > > disk 1
> > > Jun  2 14:01:59 localhost kernel: raid5: device hdd1
> > > operational as raid
> > > disk 3
> > > Jun  2 14:01:59 localhost kernel: raid5: device hdc1
> > > operational as raid
> > > disk 2
> > > Jun  2 14:01:59 localhost kernel: raid5: md0, not
> > > all disks are
> > > operational -- trying to recover array
> > > Jun  2 14:01:59 localhost kernel: raid5: allocated
> > > 4334kB for md0
> > > Jun  2 14:01:59 localhost kernel: raid5: raid level
> > > 5 set md0 active
> > > with 3 out of 4 devices, algorithm 2
> > > Jun  2 14:01:59 localhost kernel: RAID5 conf
> > > printout:
> > > Jun  2 14:01:59 localhost kernel:  --- rd:4 wd:3
> > > fd:1
> > > Jun  2 14:01:59 localhost kernel:  disk 0, s:0, o:0,
> > > n:0 rd:0 us:1
> > > dev:[dev 00:00]
> > > Jun  2 14:01:59 localhost kernel:  disk 1, s:0, o:1,
> > > n:1 rd:1 us:1
> > > dev:hdb1
> > > Jun  2 14:01:59 localhost kernel:  disk 2, s:0, o:1,
> > > n:2 rd:2 us:1
> > > dev:hdc1
> > > Jun  2 14:01:59 localhost kernel:  disk 3, s:0, o:1,
> > > n:3 rd:3 us:1
> > > dev:hdd1
> > > Jun  2 14:01:59 localhost kernel: RAID5 conf
> > > printout:
> > > Jun  2 14:01:59 localhost kernel:  --- rd:4 wd:3
> > > fd:1
> > >
> > === message truncated ===
> >
> >
> >
> >
> >
> > __________________________________
> > Do you Yahoo!?
> > Friends.  Fun.  Try the all-new Yahoo! Messenger.
> > http://messenger.yahoo.com/
> > -
> > To unsubscribe from this list: send the line "unsubscribe
linux-raid"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

