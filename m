From: Bob Glamm <glamm@a-s-i.com>
Subject: Re: RAID migration from 2.4 -> 2.6
Date: Mon, 16 Aug 2004 22:23:08 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040817032308.GA31824@romulus.a-s-i.com>
References: <20040812152939.GD5326@romulus.a-s-i.com> <20040816223541.GA1197@romulus.a-s-i.com> <41213B52.60903@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41213B52.60903@tls.msk.ru>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >I'm not sure why the devices can't be found: the Adaptec driver appears
> >to go through its initialization routines just fine and find all the
> >disks.
> 
> How about sd_mod (scsi disk module)?  Is it loaded (or compiled into the
> kernel) together with the adaptec driver?  Does the kernel prints a line
> like
>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
> (partition layout) for all your disks?

I cannot (at the moment) say anything about the partition line
being printed out, but:

  * legacy /proc/scsi/ support
  * SCSI disk support
  * SCSI tape support
  * SCSI CDROM support
  * SCSI generic support
  * Verbose SCSI error reporting
  * SCSI logging facility
  SCSI Transport Attributes --> * SPI
  SCSI low-level drivers --> AIC7xxx Fast -> U160 support (new driver)
                         --> Adaptec AIC79xx U320 support

are all compiled into the kernel.

I wonder if it's possible there's a collision between the AIC79xx
and AIC7xxx driver.  I suppose I could try eliminating the AIC79xx driver
(as I have a pair of 7899's and a 7892 in these systems, no 79xx..)

-Bob
