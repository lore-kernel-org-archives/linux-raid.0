From: Nix <nix@esperi.org.uk>
Subject: How to un-degrade an array after a totally spurious failure?
Date: Thu, 21 May 2009 00:10:47 +0100
Message-ID: <87skiztloo.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So this just happened on one of my older machines:

sym0: SCSI parity error detected: SCR1=132 DBC=50000000 SBCL=0
sd 0:0:0:0: [sda] ABORT operation started
sd 0:0:0:0: ABORT operation timed-out.
sd 0:0:0:0: [sda] ABORT operation started
sd 0:0:0:0: ABORT operation timed-out.
sd 0:0:2:0: [sdb] ABORT operation started
sd 0:0:2:0: ABORT operation timed-out.
sd 0:0:0:0: [sda] DEVICE RESET operation started
sd 0:0:0:0: DEVICE RESET operation timed-out.
sd 0:0:2:0: [sdb] DEVICE RESET operation started
sd 0:0:2:0: DEVICE RESET operation timed-out.
sd 0:0:0:0: [sda] BUS RESET operation started
sym0: SCSI BUS reset detected.
sym0: SCSI BUS has been reset.
sd 0:0:0:0: BUS RESET operation complete.
end_request: I/O error, dev sdb, sector 128591
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sdb6, disabling device.
raid5: Operation continuing on 2 devices.
RAID5 conf printout:
 --- rd:3 wd:2
 disk 0, o:1, dev:sda6
 disk 1, o:0, dev:sdb6
 disk 2, o:1, dev:sdd5
RAID5 conf printout:
 --- rd:3 wd:2
 disk 0, o:1, dev:sda6
 disk 2, o:1, dev:sdd5

This failure is quasi-spurious: nothing is actually wrong with the disks
(just one cable, which throws an error like this about once every two
years and otherwise works perfectly well, though the error has never
overlapped with a RAID superblock write before), so I'd like the drive
to be pulled back into the array sharpish. But it's quite unclear how to
do that. I can't afford to take the array down, but will accept (because
I must) the background hit of an array reconstruction.

Normally I'd just try things until one works, but if I get a command
wrong now then several rather important and long-running (months)
processes trickling writes to that array will be interrupted and I'll be
in rather a lot of trouble.

So, anyone got a command that would help? I'm not even sure if this is
assembly or growth: it doesn't quite fit into either of those
categories. There must be a way to do this, surely?
