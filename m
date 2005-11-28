From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sun, 27 Nov 2005 21:33:38 -0500
Message-ID: <060001c5f3c4$23e35dd0$200a11ac@NCNF5131FTH>
References: <17290.11404.619425.81197@cse.unsw.edu.au> <05d301c5f3c0$fb6f6860$200a11ac@NCNF5131FTH> <20051128022412.GA26118@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@jose.lug.udel.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 27 November 2005 21:20:22, Ross Vandegrift wrote:
> Yes, you can absolutely boot from RAID1 with initrd.  If you're not an
> initrd wizard it will be difficult.  You'll need to make sure that
> your initrd has all the necessary device files, the modules for md,
> the mdadm binary, and any shared libraries that your mdadm is built
> against.
>
> If you're using Debian, mkinitrd can build you an initrd that has
> everything needed and works.  It has a few config files in /etc/ that
> let you control how things get built, and a cool -k switch that leaves
> the temporary directory around so you can easily examine the initrd.
>
> Can't really speak for other distros.  Are you compiling your own
> kernels?  If so, I'd strongly suggest abandoning initrd.  It's easy as
> pie to boot off md if you have the drivers built into the kernel.
> But I do understand that it might not be practical for you to build
> your own kernel.

Russ --

I use CRUX (http://www.crux.nu) -- I compile my own kernel; from my breif 
exploration of initrd -- which debian has about a trillion web pages 
dedicated to raids and initrd -- the feeling / impression I had was that 
initrd is mostly used if you cannot compile full support into the kernel.

My concern is, I want to do it the 'right way' -- to me, that is a pure 
kernel boot -- the problem is, the current kernel does not facilitate 
booting raids with superblock1 -- not via automount (which Neil has 
previously said he is quite against), and not natively via do_mounts_md.c. 
Neil has put together a small patch (may need some spit and polish; the 
hardcoded workaround from Raphael is currently working) but said he is 
hesistant to submit it for addition to a future kernel. I don't want to go 
about doing things the wrong way, and journey down the path of being 
'unsupported'. It seems to me, there could be some huge benefits of putting 
some of the mdadm assemble.c code into do_mounts_md.c; I have no issue using 
a workaround / hack for immediate use -- but as I mentioned before, I don't 
want to start a bad habit so to speak. If there is a proper way, I'd rather 
learn (use) it.

-- David M. Strang 

