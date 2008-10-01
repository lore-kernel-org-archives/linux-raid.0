From: "David Lethe" <david@santools.com>
Subject: RE: SATA errors?
Date: Wed, 1 Oct 2008 08:11:06 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C021D052A@34093-C3-EVS3.exchange.rackspace.com>
References: <48E34221.1000008@agenda.si> <20081001100833.3253724847@gemini.denx.de> <48E353D5.1060908@agenda.si> <A20315AE59B5C34585629E258D76A97C02180F8B@34093-C3-EVS3.exchange.rackspace.com> <48E36A61.4020903@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <48E36A61.4020903@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Danilo Godec <danilo.godec@agenda.si>, Wolfgang Denk <wd@denx.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: David Greaves [mailto:david@dgreaves.com]
> Sent: Wednesday, October 01, 2008 7:18 AM
> To: David Lethe
> Cc: Danilo Godec; Wolfgang Denk; Linux RAID Mailing List
> Subject: Re: SATA errors?
> 
> David Lethe wrote:
> > There is no cause of concern. The 0x25 command translates to
> > READ_CAPACITY10.  (i.e., how many blocks does the disk hold).  This
> > command is emulated because the disk doesn't natively speak SCSI
> > commands, which is how your specific hardware/driver/controller
> > combination configures such things.
> 
> and yet look at the timestamps...
> 
> 
> > Oct  1 10:11:30 bigxen2 kernel: ata1: waiting for device to spin up
> (7
> > secs)
> > Oct  1 10:11:40 bigxen2 kernel: ata1: soft resetting port
> > Oct  1 10:11:41 bigxen2 kernel: ata1: softreset failed (1st FIS
> failed)
> > Oct  1 10:11:41 bigxen2 kernel: ata1: softreset failed, retrying in
5
> secs
> > Oct  1 10:11:46 bigxen2 kernel: ata1: hard resetting port
> > Oct  1 10:11:47 bigxen2 kernel: ata1: SATA link up 3.0 Gbps (SStatus
> > 123 SControl 300)
> > Oct  1 10:11:47 bigxen2 kernel: ata1.00: configured for UDMA/133
> > Oct  1 10:11:47 bigxen2 kernel: ata1: EH complete
> 
> That looks to me like 15-17 seconds of unresponsive disk; certainly
the
> time
> around the resets are times when the driver isn't allowing disk
access.
> 
> I'd say there was cause for something; although I'd cc the linux-ide
> group for
> real insight, not linux-raid :)
> 
> David - maybe the response from the 0x25 command should not result in
a
> reset -
> or maybe the 0x25 should not be issued if it causes a state that does
> require a
> reset.
> 
> I get similar softreset/hardreset problems with some samsung drives on
> some
> controllers. I've not got round to investigating it yet. Sorry.
> 
> David
> 
> 
> --
> "Don't worry, you'll be fine; I saw it work in a cartoon once..."
===========================================
Without spending a lot of time on this, gut feeling is that problem is
due to a weakly implemented drive capacity query logic.   Something
wants to know capacity of the drive, and when it doesn't get expected
results, it issues a brute-force reset, probably because it assumes
drive is locked up or something like that.  As the disks emulate SCSI
devices (due to the fact that SCSI commands are being sent, then you
have to look at whatever does the translation.  If you just want to do a
brute-force-can-I-fix-it, then look at the firmware for your RAID
controller first, then drivers.  Do not just upgrade them without
checking out potential compatibility problems, and the appropriate
vendor's support site.  

Since the problem isn't limited to the POST, then there is potential the
problem has nothing to do with your embedded controller/firmware.  You
could have an application program causing this.  Think about programs
you run that need to know how many blocks there are on a physical disk
drive.   See if you can disable them.  Certainly smartctl is one of
them.  All the fdisk family commands, mdadm, and RAID management
commands would need to know physical block counts at some point in time.

If this was my system, I would ...
1) First check into upgrading firmware/bios/drivers of disk controller.
2) Look at cron jobs and see if anything that needs capacity runs around
the time the errors are reported.  Something has to run to start this
off, so you need to find it.  
3) Use logger and a shell script to try to catch system in the 15 second
window when you have this problem, and see what programs are running. 
4) Actually, if this was my system, and if I/O wasn't actually being
suspended during those 15 seconds, then I probably would do step 1 only,
and if everything is current, then I would move on and not worry about
it.   Even if you find the offending program, then that doesn't mean
that the author of the program has or will make an acceptable change in
their code.  

The problem you have from SCSI perspective is the bozo who wrote this
chunk of code did it the wrong way. The CORRECT way to determine
addressable blocks is to send out the READCAP10, look for return value
of FFFFFFFFh blocks, then issue a 16-byte (0x9e 0x10) READ CAPACITY,
because you have > FFFFFFFE blocks on the disk.  This architect never
imagined that the READCAP10 would have to deal with large disks, and
assumed if there was a problem, then the disk needs to be reset.   
 

David @ SANtools.com
Storage Diagnostics Software
http://www.santools.com/smart/unix/manual


