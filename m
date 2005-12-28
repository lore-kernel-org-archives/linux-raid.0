From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: raid1: All my data completely vanished into the void
Date: Tue, 27 Dec 2005 23:50:21 -0500
Message-ID: <20051228045021.GA2490@lug.udel.edu>
References: <200512272340.48483.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200512272340.48483.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 27, 2005 at 11:40:48PM -0500, Mitchell Laks wrote:
> I then created 3 raid1 arrays
> mdadm -Cv -n2 -l1 /dev/md0 /dev/sda1 /dev/sdb1
> mdadm -Cv -n2 -l1 /dev/md1 /dev/sdc1 /dev/sdd1
> mdadm -Cv -n2 -l1 /dev/md2 /dev/sde1 /dev/sdf1

Are you 100% sure that you didn't do:

mdadm -Cv -n2 -l1 /dev/md0 /dev/sda /dev/sdb, etc, etc?
(ie, note lack of subdevice for partition!!!)

That's the only thing I can image that would cause this:

> Device contains neither a valid DOS partition table, nor Sun, SGI or OSF 
> disklabel

It sounds like you created md devices out of whole disks instead of
partitions and overwrote the partition information.  I don't *think*
this should be a problem, but I don't 100% know...

Try this to see if it finds your array:

mdadm --assemble /dev/md0 /dev/sda /dev/sdb

> however I did not!! (?evil) umount the different devices 
> /dev/md0 /dev/md1 /dev/md2 before doing that.

When you shutdown cleanly, your system's scripts almost certainly did
that for you! ::-)

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
