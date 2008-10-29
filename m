From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: And again help on deciphering an error
Date: Wed, 29 Oct 2008 04:08:01 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0810290407370.14813@p34.internal.lan>
References: <4907A5FA.7050903@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4907A5FA.7050903@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Wed, 29 Oct 2008, Peter Rabbitson wrote:

> Hello,
>
> Before I ask my question - if there is some documentation that answers
> what I am asking - I would be thrilled to read it. So far google has not
> helped me at all.
>
> This being said I need help with understanding what is going on here
> (full log):
>
>
> Oct 27 11:33:41 Arzamas kernel: ata6.00: exception Emask 0x10 SAct 0x0
> SErr 0x80000 action 0xe frozen
> Oct 27 11:33:41 Arzamas kernel: ata6.00: irq_stat 0x01100010, PHY RDY
> changed
> Oct 27 11:33:41 Arzamas kernel: ata6: SError: { 10B8B }
> Oct 27 11:33:41 Arzamas kernel: ata6.00: cmd
> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Oct 27 11:33:41 Arzamas kernel: res 06/37:00:00:00:00/00:00:00:00:06/00
> Emask 0x12 (ATA bus error)
> Oct 27 11:33:41 Arzamas kernel: ata6.00: error: { IDNF ABRT }
> Oct 27 11:33:41 Arzamas kernel: ata6: hard resetting link
> Oct 27 11:33:46 Arzamas kernel: ata6: SATA link up 3.0 Gbps (SStatus 123
> SControl 0)
> Oct 27 11:33:46 Arzamas kernel: ata6.00: configured for UDMA/100
> Oct 27 11:33:46 Arzamas kernel: ata6: EH complete
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] 488397168 512-byte
> hardware sectors (250059 MB)
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write Protect is off
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Oct 27 11:33:46 Arzamas kernel: end_request: I/O error, dev sde, sector
> 488166955
> Oct 27 11:33:46 Arzamas kernel: md: super_written gets error=-5, uptodate=0
> Oct 27 11:33:46 Arzamas kernel: raid10: Disk failure on sde2, disabling
> device.
> Oct 27 11:33:46 Arzamas kernel: raid10: Operation continuing on 3 devices.
> Oct 27 11:33:46 Arzamas kernel: RAID10 conf printout:
> Oct 27 11:33:46 Arzamas kernel: --- wd:3 rd:4
> Oct 27 11:33:46 Arzamas kernel: disk 0, wo:0, o:1, dev:sdc2
> Oct 27 11:33:46 Arzamas kernel: disk 1, wo:0, o:1, dev:sdb2
> Oct 27 11:33:46 Arzamas kernel: disk 2, wo:1, o:0, dev:sde2
> Oct 27 11:33:46 Arzamas kernel: disk 3, wo:0, o:1, dev:sdd2
> Oct 27 11:33:46 Arzamas kernel: RAID10 conf printout:
> Oct 27 11:33:46 Arzamas kernel: --- wd:3 rd:4
> Oct 27 11:33:46 Arzamas kernel: disk 0, wo:0, o:1, dev:sdc2
> Oct 27 11:33:46 Arzamas kernel: disk 1, wo:0, o:1, dev:sdb2
> Oct 27 11:33:46 Arzamas kernel: disk 3, wo:0, o:1, dev:sdd2
>
> Afterwards I removed sde from all arrays and mounts, and grilled it
> repeatedly with badblocks and smartctl -t long. Nothing came out for
> over a day. Below see the smartclt -a output. This happened one day
> after I upgraded to 2.6.27.4 from 2.6.23.
>
> Can someone please tell me what seems to be dying? Thank you!

Oct 27 11:33:46 Arzamas kernel: end_request: I/O error, dev sde, sector
488166955

Disk is going bad, I had the same problem, a week later, it was another I/O
error, a week after that, another I/O error, replace/RMA disk.

Justin.

