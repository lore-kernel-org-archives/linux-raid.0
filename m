From: Reggie Dugard <reggie@merfinllc.com>
Subject: Re: "megaraid mbox: critical hardware error" on new dell poweredge
	1850, suse 9.2, kernel 2.6.8
Date: Wed, 26 Jan 2005 11:48:58 -0800
Message-ID: <1106768938.6416.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Olivier,

> I'm trying to get a quite standard "suse linux 9.2" setup working
> on a brand new dell poweredge 1850 with 2 scsi disks in raid1 setup.
> 
> Installation went completely fine, everything is working. But now (and
> every time), after 2-3h of uptime and some high disk I/O load (rsync of
> some GB of data), it badly crashes with the following messages:

We're seeing something similar here on an 1850 with 2 disks under
hardware raid1 running RHEL rel. 3 with a 2.4.21-27 kernel.  It has
happened twice so far for us (about once a week or so).  It may have
been a backup of the raid (high disk i/o) that caused it to fail the
most recent time.  Below I've included data from our system
corresponding to what you've included, for comparison purposes.

Unfortunately, we have no leads as to the cause, but I thought I let you
know that you're not alone :) and we can share anything we find out.


megaraid: aborting-5781469 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781520 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781529 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781527 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781470 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781498 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781524 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781525 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781507 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781526 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781514 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781509 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781530 cmd=2a <c=0 t=0 l=0>
megaraid: 5781530:81, driver owner.
megaraid: aborting-5781530 cmd=2a <c=0 t=0 l=0>
megaraid: 5781530:81, driver owner.
megaraid: aborting-5781537 cmd=2a <c=0 t=0 l=0>
megaraid: 5781537:94, driver owner.
megaraid: aborting-5781537 cmd=2a <c=0 t=0 l=0>
megaraid: 5781537:94, driver owner.
megaraid: aborting-5781506 cmd=28 <c=0 t=0 l=0>
megaraid: aborting-5781532 cmd=2a <c=0 t=0 l=0>
megaraid: 5781532:98, driver owner.
megaraid: aborting-5781532 cmd=2a <c=0 t=0 l=0>
megaraid: 5781532:98, driver owner.
megaraid: reset-5781504 cmd=28 <c=0 t=0 l=0>
megaraid: 49 pending cmds; max wait 180 seconds
megaraid: pending 49; remaining 180 seconds
megaraid: pending 49; remaining 175 seconds
megaraid: pending 49; remaining 170 seconds
megaraid: pending 49; remaining 165 seconds
megaraid: pending 49; remaining 160 seconds
megaraid: pending 49; remaining 155 seconds
megaraid: pending 49; remaining 150 seconds
megaraid: pending 49; remaining 145 seconds
megaraid: pending 49; remaining 140 seconds
megaraid: pending 49; remaining 135 seconds
megaraid: pending 49; remaining 130 seconds
megaraid: pending 49; remaining 125 seconds
megaraid: pending 49; remaining 120 seconds
megaraid: pending 49; remaining 115 seconds
megaraid: pending 49; remaining 110 seconds
megaraid: pending 49; remaining 105 seconds
megaraid: pending 49; remaining 100 seconds
megaraid: pending 49; remaining 95 seconds
megaraid: pending 49; remaining 90 seconds
megaraid: pending 49; remaining 85 seconds
megaraid: pending 49; remaining 80 seconds
megaraid: pending 49; remaining 75 seconds
megaraid: pending 49; remaining 70 seconds
megaraid: pending 49; remaining 65 seconds
megaraid: pending 49; remaining 60 seconds
megaraid: pending 49; remaining 55 seconds
megaraid: pending 49; remaining 50 seconds
megaraid: pending 49; remaining 45 seconds
megaraid: pending 49; remaining 40 seconds
megaraid: pending 49; remaining 35 seconds
megaraid: pending 49; remaining 30 seconds
megaraid: pending 49; remaining 25 seconds
megaraid: pending 49; remaining 20 seconds
megaraid: pending 49; remaining 15 seconds
megaraid: pending 49; remaining 10 seconds
megaraid: pending 49; remaining 5 seconds
megaraid: critical hardware error!
megaraid: reset-5781504 cmd=28 <c=0 t=0 l=0>
megaraid: hw error, cannot reset
megaraid: reset-5781473 cmd=28 <c=0 t=0 l=0>
megaraid: hw error, cannot reset
megaraid: reset-5781472 cmd=28 <c=0 t=0 l=0>
megaraid: hw error, cannot reset
megaraid: reset-5781512 cmd=28 <c=0 t=0 l=0>
megaraid: hw error, cannot reset
megaraid: reset-5781471 cmd=28 <c=0 t=0 l=0>
megaraid: hw error, cannot reset
megaraid: reset-5781535 cmd=2a <c=0 t=0 l=0>
megaraid: hw error, cannot reset
megaraid: reset-5781490 cmd=28 <c=0 t=0 l=0>
megaraid: hw error, cannot reset

Loaded modules:

sg                     37388   0 (autoclean)
ext3                   89992   2
jbd                    55092   2 [ext3]
megaraid2              38376   3
diskdumplib             5260   0 [megaraid2]
sd_mod                 13936   6
scsi_mod              115240   3 [sg megaraid2 sd_mod]

$ uname -a
Linux kijang 2.4.21-27.0.1.ELsmp #1 SMP Mon Dec 20 18:47:45 EST 2004
i686 i686 i386 GNU/Linux

SCSI output from dmesg:

SCSI subsystem driver Revision: 1.00
megaraid: v2.10.8.2-RH1 (Release Date: Mon Jul 26 12:15:51 EDT 2004)
megaraid: found 0x1028:0x0013:bus 2:slot 14:func 0
scsi0:Found MegaRAID controller at 0xf8846000, IRQ:38
megaraid: [513O:H418] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
scsi0 : LSI Logic MegaRAID 513O 254 commands 16 targs 4 chans 7 luns
blk: queue f7359e18, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
scsi0: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD 0 RAID1   69G  Rev: 513O
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue f7359c18, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
scsi0: scanning scsi channel 1 for logical drives.
scsi0: scanning scsi channel 2 for logical drives.
scsi0: scanning scsi channel 3 for logical drives.
scsi0: scanning scsi channel 4 [P0] for physical devices.
  Vendor: PE/PV     Model: 1x2 SCSI BP       Rev: 1.0
  Type:   Processor                          ANSI SCSI revision: 02
blk: queue f7359a18, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 143114240 512-byte hdwr sectors (73274 MB)
Partition check:
 sda: sda1 sda2 sda3 sda4 < sda5 >

Regards,

Reggie

-- 
Reggie Dugard <reggie@merfinllc.com>
Merfin, LLC


