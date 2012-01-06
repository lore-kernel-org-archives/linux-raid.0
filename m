From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Fri, 6 Jan 2012 16:08:23 +0100
Message-ID: <20120106150823.GX25976@fi.muni.cz>
References: <20111212115459.GC20730@fi.muni.cz>
 <4EE61EAE.20101@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EE61EAE.20101@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

John Robinson wrote:
: On 12/12/2011 11:54, Jan Kasprzak wrote:
: >	Is there any way how to tell mdadm explicitly how to set up
: >the pairs of mirrored drives inside a RAID-10 volume?
: 
: If you're using RAID10,n2 (the default layout) then adjacent pairs
: of drives in the create command will be mirrors, so your command
: line should be something like:
: 
: # mdadm --create /dev/mdX -l10 -pn2 -n44 /dev/shelf1drive1
: /dev/shelf2drive1 /dev/shelf1drive2 ...

	OK, this works, thanks!

: Having said that, if you think there's a real chance of a shelf
: failing, you probably ought to think about adding more redundancy
: within the shelves so that you can survive another drive failure or
: two while you're running on just one shelf.

	I am aware of that. I don't think the whole shelf will fail,
but who knows :-)

: If you are sticking with RAID10, you can potentially get double the
: read performance using the far layout - -pf2 - and with the same
: order of drives you can still survive a shelf failure, though your
: use of port multipliers may well limit your performance anyway.

	On the older hardware I have a majority of writes, so the far
layout is probably not good for me (reads can be cached pretty well
at the OS level).

	After some experiments with my new hardware, I have discovered
one more serious problem: I have simulated an enclosure failure,
so half of the disks forming the RAID-10 volume disappeared.
After removing them using mdadm --remove, and adding them back,
iostat reports that they are resynced one disk a time, not all
just-added disks in parallel.

	Is there any way of adding more than one disk to the degraded
RAID-10 volume, and get the volume restored as fast as the hardware permits?
Otherwise, it would be better for us to discard RAID-10 altogether,
and use several independent RAID-1 volumes joined together using LVM
(which we will probably use on top of the RAID-10 volume anyway).

	I have tried mdadm --add /dev/mdN /dev/sd.. /dev/sd.. /dev/sd..,
but it behaves the same way as issuing mdadm --add one drive at a time.

	Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
