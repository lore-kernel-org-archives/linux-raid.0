From: Mike <mikee@mikee.ath.cx>
Subject: Re: FailSpare event?
Date: Thu, 11 Jan 2007 17:06:36 -0600
Message-ID: <20070111230636.GV32386@mikee.ath.cx>
References: <eo6cn8$5se$1@sea.gmane.org> <17830.47341.560158.521091@notabene.brown> <20070111223628.GU32386@mikee.ath.cx> <17830.49475.108136.376489@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17830.49475.108136.376489@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 12 Jan 2007, Neil Brown might have said:

> On Thursday January 11, mikee@mikee.ath.cx wrote:
> > 
> > So I'm ok for the moment? Yes, I need to find the error and fix everything
> > back to the (S) state.
> 
> Yes, OK for the moment.
> 
> > 
> > The messages in $HOST:/var/log/messages for the time of the email are:
> > 
> > Jan 11 16:04:25 elo kernel: sd 2:0:4:0: SCSI error: return code = 0x8000002
> > Jan 11 16:04:25 elo kernel: sde: Current: sense key: Hardware Error
> > Jan 11 16:04:25 elo kernel:     Additional sense: Internal target failure
> > Jan 11 16:04:25 elo kernel: Info fld=0x10b93c4d
> > Jan 11 16:04:25 elo kernel: end_request: I/O error, dev sde, sector 280575053
> > Jan 11 16:04:25 elo kernel: raid5: Disk failure on sde2, disabling device. Operation continuing on 5 devices
> 
> Given the sector number it looks likely that it was a superblock
> update.
> No idea how bad an 'internal target failure' is.  Maybe powercycling
> the drive would 'fix' it, maybe not.
> 
> > 
> > On AIX boxes I can blink the drives to identify a bad/failing device. Is there
> > a way to blink the drives in linux?
> 
> Unfortunately not.
> 
> NeilBrown
> 

I found the smartctl command. I have a 'long' test running in the background.
I checked this drive and the other drives. This drive has been used the least
(confirms it is a spare?) and is the only one with 'Total uncorrected errors' > 0.

How to determine the error, correct the error, or clear the error?

Mike

[root@$HOST ~]# smartctl -a /dev/sde
smartctl version 5.36 [i686-redhat-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: SEAGATE  ST3146707LC      Version: D703
Serial number: 3KS30WY8
Device type: disk
Transport protocol: Parallel SCSI (SPI-4)
Local Time is: Thu Jan 11 17:00:26 2007 CST
Device supports SMART and is Enabled
Temperature Warning Enabled
SMART Health Status: OK

Current Drive Temperature:     48 C
Drive Trip Temperature:        68 C
Elements in grown defect list: 0
Vendor (Seagate) cache information
  Blocks sent to initiator = 66108
  Blocks received from initiator = 147374656
  Blocks read from cache and sent to initiator = 42215
  Number of read and write commands whose size <= segment size = 12635583
  Number of read and write commands whose size > segment size = 0
Vendor (Seagate/Hitachi) factory information
  number of hours powered up = 3943.42
  number of minutes until next internal SMART test = 94

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:        354        0         0       354        354          0.546           0
write:         0        0         0         0          0        185.871           1

Non-medium error count:        0

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background long   Completed, segment failed   -    3943                 - [-   -    -]

Long (extended) Self Test duration: 2726 seconds [45.4 minutes]

