From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Need to upgrade to latest stable mdadm version?
Date: Sun, 22 Jan 2006 17:31:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601221719020.24057-100000@coffee.psychology.mcmaster.ca>
References: <43D3C5A8.3070200@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D3C5A8.3070200@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >and with the ETCH testing 2.6.12:  the sata_via module fails with

I'm sure you know that no kernel developer really cares about distro-hacked 
kernels.  why not test a real (kernel.org) kernel?

> >ata1: status=0x51 { DriveReady SeekComplete Error }
> >ata1: error=0x84 { DriveStatusError BadCRC }

badcrc's are a sign that the link is failing - bad cable, bad power,
overclocking, possibly an error in the driver's timing config.
it cannot possibly be an mdadm problem, and cannot be related to 
other software (kernel memory management, say.)

> >ata1: command 0x35 timeout, stat 0xd0 host_stat 0x0
> >ata1: status=0xd0 { Busy }
> >SCSI error : <0 0 0 0> return code = 0x8000002
> >sda: Current: sense key: Aborted Command
> >    Additional sense: Scsi parity error
> >end_request: I/O error, dev sda, sector 94109775
> >raid1: Disk failure on sda1, disabling device.

I don't know the code well enough to tell whether that CRC error is
triggering that cascade of scsi->raid errors.

> >Note these messages are not caused by the hard drive (reproduced on multiple 
> >hard drives which fine work with the Promise controller), nor is it the 
> >controller hardware (occurs with multiple asus A8v motherboards) - because it 

being triggered by a CRC error means that it's definitely a problem in the 
cable, though it may simply that something has mis-programmed the timing
of the port.  working with a different controller also doesn't rule out 
power problems.

> >only happens when both the sata_via and sata_promise controller are loaded by 
> >the ETCH debian 2.6.12 kernel.

I don't see how driver interaction could cause the BadCRC, unless one driver
is screwing with the timing registers of the other's hardware.

> >So I have to compile my own 2.6.15 kernel. So what version of mdadm do I use? 
> >How shall I install it? 

why do you think mdadm has anything to do with it?  it's a user-level tool
for manipilating md.  it only knows blockdevs, not drivers, CRC's, etc.

> >Does it make sense to simply compile mdadm  2.2 and replace /sbin/mdadm with 
> >the new version?????? How can I get the best recent mdadm? I am using raid1.

mdadm cannot possibly have anything to do with causing BadCRC's.  upgrade if
you feel like it, but not because of this problem.

> I am running the *stock* 2.6.15 and get the same problems (ata timeouts etc)

is there a reason you call this a timeout, rather than a BadCRC?

