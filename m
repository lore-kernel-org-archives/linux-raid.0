From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: How to create initrd.img to boot LVM-on-RAID0?
Date: Wed,  3 Oct 2007 15:53:16 -0700 (PDT)
Message-ID: <20071003225316.CAEB81023DC@medulla.enet.sharplabs.com>
References: <20071003171837.9A0481023D4@medulla.enet.sharplabs.com> <871464B0-38A6-440A-87CF-66B4EDA433F3@rescomp.stanford.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <871464B0-38A6-440A-87CF-66B4EDA433F3@rescomp.stanford.edu>
	(message from Ian Ward Comfort on Wed, 3 Oct 2007 10:45:23 -0700)
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Ian Ward Comfort wrote:
: On Oct 3, 2007, at 10:18 AM, Dean S. Messing wrote:
: > I've created a software RAID-0, defined a Volume Group on in with  
: > (currently) a single logical volume, and copied my entire  
: > installation onto it, modifying the copied fstab to reflect where  
: > the new "/" is.
: 
: > mkinitrd --preload raid0  --with=raid0 initrd_raid.img 2.6.22.5-76-fc7
: 
: > But the thing won't complete the boot process. From the boot  
: > messages it appears to not be starting the array, so when it goes  
: > to scan for LVs it doesn't find the one that's sitting on top of  
: > the array where root lives.
: >
: > Are there instructions for how to make this work?  I've googled for  
: > a couple of hours, tried a bunch of stuff, but can't get it to  
: > work.  From what I've read I suspect I must hand-tweek the "init"  
: > file in the initrd.
: 
: You're probably correct in that your initrd's nash script currently  
: lacks any "raidautorun" directives, since mkinitrd is looking at your  
: old fstab and finding that your old root device is not on RAID.
: 
: Instead of specifying modules yourself and hand-tweaking the nash  
: script, just ask mkinitrd to figure out the correct modules to load  
: and RAID devices to start on its own, given your chosen boot device,  
: with the --fstab option.
: 
: 	mkinitrd --fstab=/newroot/etc/fstab initrd_raid.img 2.6.22.5-76-fc7


That did the trick!
Thanks a lot, Ian.


Dean
