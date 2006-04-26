From: "Matt Harding" <Matt.Harding@pt.com>
Subject: Infinite fail-retry loop on degraded RAID1 array
Date: Tue, 25 Apr 2006 17:46:51 -0700
Message-ID: <AE5398F6F2923E429D8870BFDE090196025BC13F@sloexchange01.corp.pt.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am experiencing a problem that I think was supposed to be fixed some
time ago (if I read the previous discussion correctly) but appears to
have resurfaced on my somewhat unusual configuration.

configuration info:

- PowerPC (440gx)
- kernel 2.6.12 with preemption disabled
- Adaptec AIC-9410 SAS/SATA controller
- two SATA drives
- "monolithic" Adaptec adp94xx driver that presents SATA drives as sd
SCSI devices without using libata
- degraded two-drive RAID 1 array, rebuilding to new disk when the
"good" disk starts getting read errors.

Obviously, the rebuild cannot complete without at least one good drive.

However, the problem is that the kernel keeps trying to read the bad
block on the "good" disk forever.  This swamps the serial console and
makes the network stack unresponsive to anything other than pings.

The system log looks like this:

adp94xx SATA Status = 0x51
adp94xx Completion Status Error = 0x40
(scsi0: Ch 1 Id 128 Lun 0): Abort requested for SCSI cmd dfc55060,
opcode 0x28.
(scsi0: Ch 1 Id 128 Lun 0): Abort requested for SCSI cmd dfc55060,
opcode 0x0.
(scsi0: Ch 1 Id 128 Lun 0): Cmd dfc55060 found on device queue.
end_request: I / O? error, dev sdb, sector 3251760
scsi0 (128:0): rejecting I / O? to offline device
raid1: sdb: rescheduling sector 3251760
scsi0 (128:0): rejecting I / O? to offline device
raid1: sdb: redirecting sector 3251760 to another mirror
scsi0 (128:0): rejecting I / O? to offline device
raid1: sdb: rescheduling sector 3251760
raid1: sdb: redirecting sector 3251760 to another mirror
scsi0 (128:0): rejecting I / O? to offline device
raid1: sdb: rescheduling sector 3251760
raid1: sdb: redirecting sector 3251760 to another mirror
scsi0 (128:0): rejecting I / O? to offline device
raid1: sdb: rescheduling sector 3251760

...ad infinitem

Is this refusal of the RAID system to give up in the face of an
unresolvable error a known/expected behavior?  Or is something in my
configuration causing unusually degenerate behavior?

Many thanks,
~Matt Harding~
