From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: flaky controller or disk error?
Date: Mon, 22 Oct 2007 15:54:21 +0200
Message-ID: <20071022135421.GA31257@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

[using kernel 2.6.23 and mdadm 2.6.3+20070929]

I have a rather flaky sata controller with which I am trying to resync a raid5
array. It usually starts failing after 40% of the resync is done. Short of
changing the controller (which I will do later this week), is there a way to
have mdmadm resume the resync where it left at reboot time?

Here is the error I am seeing in the syslog. Can this actually be a disk 
error?

	Oct 18 11:54:34 sylla kernel: ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x10000 action 0x2 frozen
	Oct 18 11:54:34 sylla kernel: ata1.00: irq_stat 0x00400000, PHY RDY changed
	Oct 18 11:54:34 sylla kernel: ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
	Oct 18 11:54:34 sylla kernel: res 40/00:00:19:26:33/00:00:3a:00:00/40 Emask 0x10 (ATA bus error)
	Oct 18 11:54:35 sylla kernel: ata1: soft resetting port
	Oct 18 11:54:40 sylla kernel: ata1: failed to reset engine (errno=-95)<4>ata1: port is slow to respond, please be patient (Status 0xd0)
	Oct 18 11:54:45 sylla kernel: ata1: softreset failed (device not ready)
	Oct 18 11:54:45 sylla kernel: ata1: hard resetting port
	Oct 18 11:54:46 sylla kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
	Oct 18 11:54:46 sylla kernel: ata1.00: configured for UDMA/133
	Oct 18 11:54:46 sylla kernel: ata1: EH complete
	Oct 18 11:54:46 sylla kernel: sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
	Oct 18 11:54:46 sylla kernel: sd 0:0:0:0: [sda] Write Protect is off
	Oct 18 11:54:46 sylla kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
	Oct 18 11:54:46 sylla kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA


Thanks,
