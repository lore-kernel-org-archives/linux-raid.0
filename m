From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Why 4k native drives haven't arrived
Date: Sun, 5 Jan 2014 18:48:54 +0000
Message-ID: <21193.43286.201949.339364@tree.ty.sabi.co.uk>
References: <52C61807.6050906@hardwarefreak.com>
	<yq1d2k8zsie.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1d2k8zsie.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> DASD on the mainframe is 4Kn, for instance. And there are a
> bunch of SAN devices and SSDs out there that also report
> themselves as 4Kn.

Some HW RAID host adapters can be configured to offer the host
4KiB sectors too.

> So devices absolutely exist and are available. 4Kn harddrives
> are harder to come by, however. SAS/FC drives are available
> formatted as 4Kn when you order them. Some 512n drives can be
> reformatted. But you won't find 4Kn formatted drives in retail.

But as mentioned later on they have been available for
years. Also I remember buying some old generation of SATA WD
Green drive that had 4096 logical sectors, quickly superceded by
emulated drives in later updates, as major OS support some years
ago was not quite there yet.

> 4Kn SATA works fine in Linux as well but has failed to get any
> traction. Mainly because there is no win for the user. Just
> lots of pain. [ ... ] The drive vendors pushed 4Kn for years
> and years. The problem was that to the host there is no
> benefit whatsoever. Just lots of pain throughout the entire
> I/O stack (BIOS, OS, HBA ROMs, RAID controller firmware). And
> no win. None.

There are some obvious wins to addressing in 4KiB sectors, the
most important of which is the avoidance of RMW as a possibility.

But there is another important short term win, as older storage
protols and formats relate maximum disk or partition or filetree
capacity to maximum number of sectors addressable, which is
often fixed at below 2^32 or 2^31, so addresses in units of 4KiB
sectors allow 8 times more capacity than 512B ones.

This is particularly important for drives partitioned using MBR
partitions with FAT32 filetrees in them, which is why this is
the case especially for USB drives:

> [ ... ]  Actually, >2TB USB drives typically expose 4Kn to the
> host. For that reason there are already problems with XP and
> big drives.

As for example here:

  http://kb.netgear.com/app/answers/detail/a_id/22039/~/readyshare-and-usb-hard-drives-with-4kb-sector-size

and ingeneral in several reports here:

  http://www.google.com/search?btnG=SEARCH&num=100&as_epq=Logical+Sector+size+4096+bytes
