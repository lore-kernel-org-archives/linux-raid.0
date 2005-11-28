From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sun, 27 Nov 2005 22:11:49 -0500
Message-ID: <20051128031149.GB26118@jose.lug.udel.edu>
References: <17290.11404.619425.81197@cse.unsw.edu.au> <05d301c5f3c0$fb6f6860$200a11ac@NCNF5131FTH> <20051128022412.GA26118@jose.lug.udel.edu> <060001c5f3c4$23e35dd0$200a11ac@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <060001c5f3c4$23e35dd0$200a11ac@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 27, 2005 at 09:33:38PM -0500, David M. Strang wrote:
> I use CRUX (http://www.crux.nu) -- I compile my own kernel; from my breif 
> exploration of initrd -- which debian has about a trillion web pages 
> dedicated to raids and initrd -- the feeling / impression I had was that 
> initrd is mostly used if you cannot compile full support into the kernel.

Well, more generally, it's used when something needs to happen before
the kernel can mount your root partiton.  Sometimes this means DHCPing
for an IP and mounting an NFS drive, it often means loading kernel
modules.  In your case, it means using mdadm to start the RAID
devices.

http://www.faqs.org/docs/evms/x3834.html that link is pretty helpful
information on how to build an initrd manually.  It's aimed at people
using EVMS, but the general lessons it teaches about building the
image are generally sound.

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
