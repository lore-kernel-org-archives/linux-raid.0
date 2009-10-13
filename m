From: Antonio Perez <ap23563m@gmx.com>
Subject: About seting up Raid5 on a four disk box.
Date: Tue, 13 Oct 2009 09:13:13 -0400
Message-ID: <hb1udb$6t1$1@ger.gmane.org>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If I'm posting to the wrong group, sorry. just point to the RTFM link.

This post is about setting up a Debian box with four disks (size should not 
be important, me thinks), let's assume that a Raid 5 is the correct type for 
the intended use.

Keeping aside LVM and/or layering of md (just for simplicity), and taking 
into account that /boot, / and maybe other areas should go in a Raid 1 
configuration, for booting reliability. I have three questions that perhaps 
you could help to clarify:

1.- Should the "rest of the disk" be only one partition?
I have read that making several partitions and setting several md disks:
	sd[a..d]2 --> md1
	sd[a..d]3 --> md2
	sd[a..d]4 --> md3
would help with the rebuild time of each md, which sounds correct. It is 
also proposed that the md on the outer area of the disk would be faster 
allowing for better control of performance, assigning faster mds to the more 
used filesystems.

However, and this I don't know, those sda[2..4] are not really different 
devices (spindles) and reads to one md would conflict (or not?) with reads 
to the other mds.

Setting the whole disk as one partition would prevent any conflict but would 
take longer to rebuild and files would be spread over the whole area of the 
disk.

I really don't know the internals of md well enough to tell what advantages 
and problems one setup has over the other.

2.- On the Raid 1: How many sectors to copy? 63?
On an update of grub code, core.img could change, which means that the first 
63 sectors (to be on the safe side) of the disk which gets the update should 
be copied to the other 3 disks.
Or is it that the md code would mirror sectors 1-62 and only the MBR needs 
to be manually mirroed?

2.- Is there a recomended way to trigger the said copy of question 2?
Where should a call to copy the MBR should be placed? On update-grub?

TIA

-- 
Antonio Perez

