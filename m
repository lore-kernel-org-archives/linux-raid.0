From: Tim Bock <jtbock@daylight.com>
Subject: Question about raid robustness when disk fails
Date: Fri, 08 Jan 2010 10:39:45 -0700
Message-ID: <1262972385.8962.159.camel@kije>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

	I built a raid-1 + lvm setup on a Dell 2950 in December 2008.  The OS
disk (ubuntu server 8.04) is not part of the raid.  Raid is 4 disks + 1
hot spare (all raid disks are sata, 1TB Seagates).

	Worked like a charm for ten months, and then had some kind of disk
problem in October which drove the load average to 13.  Initially tried
a reboot, but system would not come all of the way back up.  Had to boot
single-user and comment out the RAID entry.  System came up, I manually
failed/removed the offending disk, added the RAID entry back to fstab,
rebooted, and things proceeded as I would expect.  Replaced offending
drive.

	In early December, had a hiccup on a drive in a different slot.  Load
average again near 13.  Issued reboot, which proceeded normally until
the "unmounting local filesystems" stage, and then just seemed to hang.
Eventually just pushed power button.  The subsequent boot took about
twenty minutes (journal recovery and fsck), but seemed to come up ok.

From the log:
Dec 9 02:06:10 fs1 kernel: [6185521.188847] mptbase: ioc0:
LogInfo(0x31080000): Originator={PL}, Code={SATA NCQ Fail All Commands
After Error}, SubCode(0x0000) 
Dec 9 02:06:10 fs1 kernel: [6185521.189287] sd 2:0:1:0: [sdb] Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK 
Dec 9 02:06:10 fs1 kernel: [6185521.189294] sd 2:0:1:0: [sdb] Sense
Key : Medium Error [current] 
Dec 9 02:06:10 fs1 kernel: [6185521.189299] Info fld=0x2e78894 
Dec 9 02:06:10 fs1 kernel: [6185521.189302] sd 2:0:1:0: [sdb] Add.
Sense: Unrecovered read error 
Dec 9 02:06:10 fs1 kernel: [6185521.189309] end_request: I/O error, dev
sdb, sector 48728212

Ok, so looks like the drive is having some problems, maybe failing.
Noted, but I have a hot spare which should take over in the event of a
failure, yes?

Things moved along fine until Dec 23.  Same drive and symptoms as
earlier that month, but this time it did not come up on its own when
rebooted.  Had to comment out the RAID while in single-user mode,
reboot, manually fail/remove drive, and then it finally started syncing
with the spare as expected.  From smartctl, the last command before the
error was READ FPDMA QUEUED (this was the same for all five of the most
recent errors reported by SMART, and all essentially at the same time).

So it appears I have another bad disk, though smartctl reports that the
drive passes the extended self-test.  My question (at long last) is
this:  In all three cases, why didn't the raid fail the drive and start
using the spare (without my help)?  I guess I'm not clear on what kind
of failures the raid will detect/survive (beyond the obvious, like
failure of a disk and its mirror or bus failure).  Is there some
configuration piece I have missed?

Thanks for any enlightenment...

Tim

