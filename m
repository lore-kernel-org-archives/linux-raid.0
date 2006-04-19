From: "Karl Schricker" <k_schricker@gmx.net>
Subject: Re: Raid5 says it's rebuilding, but it lies :)
Date: Wed, 19 Apr 2006 18:44:58 +0200 (MEST)
Message-ID: <26099.1145465098@www001.gmx.net>
References: <44463EAF.7000901@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >  mdadm -S /dev/md0
> >  mdadm -A /dev/md0 --force /dev/sd[abd]
> >  mdadm /dev/md0 --add /dev/sdc
> >   
> All the command line tricks in the world will not change the fact that
> his IEEE1394 drive subsystem is presenting one or more of his drives as
> read only devices..

Well, the command line tricks did at least get me past the first roadblock
and the array started recovering.  (Thank you, Neil!)

However perhaps you are onto something, as the recovery failed halfway
through with "CRC" errors.  Running badblocks on the faulty disk generates
lots of these errors in my log:

Apr 19 09:14:52 pingo kernel: ata2: command 0x25 timeout, stat 0xd0
host_stat 0x61
Apr 19 09:14:52 pingo kernel: ata2: status=0xd0 { Busy }
Apr 19 09:14:52 pingo kernel: SCSI error : <1 0 0 0> return code = 0x8000002
Apr 19 09:14:52 pingo kernel: sdc: Current: sense key: Aborted Command
Apr 19 09:14:52 pingo kernel:     Additional sense: Scsi parity error
Apr 19 09:14:52 pingo kernel: end_request: I/O error, dev sdc, sector 344
Apr 19 09:14:52 pingo kernel: Buffer I/O error on device sdc, logical block
43
Apr 19 09:14:52 pingo kernel: ATA: abnormal status 0xD0 on port 0x5007

Is this symptomatic of the IEEE1394 problem you mention?

I really wasn't doing anything special here.  I'm using out-of-the-box
packages on Mandriva 2006, not compiling kernel modules by hand.  And all I
did was plug in a camcorder...

-- 
Analog-/ISDN-Nutzer sparen mit GMX SmartSurfer bis zu 70%!
Kostenlos downloaden: http://www.gmx.net/de/go/smartsurfer
