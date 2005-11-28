From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sun, 27 Nov 2005 21:24:13 -0500
Message-ID: <20051128022412.GA26118@jose.lug.udel.edu>
References: <17290.11404.619425.81197@cse.unsw.edu.au> <05d301c5f3c0$fb6f6860$200a11ac@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <05d301c5f3c0$fb6f6860$200a11ac@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 27, 2005 at 09:11:02PM -0500, David M. Strang wrote:
> + mdadm. Essentially, the end goal -- is if either drive fails, the system 
> should not go down. So, I invoked the paritioned MD route; and created it 
> on top of a single large partition for each drive. I'm still working out 
> bootloader bugs...
> 
> So, excuse the rambling -- but in a nutshell, will the following 
> configuration work with initrd?

Yes, you can absolutely boot from RAID1 with initrd.  If you're not an
initrd wizard it will be difficult.  You'll need to make sure that
your initrd has all the necessary device files, the modules for md,
the mdadm binary, and any shared libraries that your mdadm is built
against.

If you're using Debian, mkinitrd can build you an initrd that has
everything needed and works.  It has a few config files in /etc/ that
let you control how things get built, and a cool -k switch that leaves
the temporary directory around so you can easily examine the initrd.

Can't really speak for other distros.  Are you compiling your own
kernels?  If so, I'd strongly suggest abandoning initrd.  It's easy as
pie to boot off md if you have the drivers built into the kernel.
But I do understand that it might not be practical for you to build
your own kernel.



-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
