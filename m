From: Jan Kasprzak <kas@fi.muni.cz>
Subject: RAID-10 explicitly defined drive pairs?
Date: Mon, 12 Dec 2011 12:54:59 +0100
Message-ID: <20111212115459.GC20730@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

	Hello, Linux RAID gurus,

I have a new server with two identical external disk shelves (22 drives each),
which will be connected to the server with a pair of SAS cables.
I want to use RAID-10 on these disks, but I want it to be configured
so that the data will always be mirrored between the shelves.
I.e. I want to be able to overcome complete failure of a single shelf.

	Is there any way how to tell mdadm explicitly how to set up
the pairs of mirrored drives inside a RAID-10 volume?

	Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
