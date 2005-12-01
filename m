From: Neil Brown <neilb@suse.de>
Subject: Re: quick Q re raid reconstruction
Date: Fri, 2 Dec 2005 09:56:48 +1100
Message-ID: <17295.32688.483645.390383@cse.unsw.edu.au>
References: <438EE429.2030903@eyal.emu.id.au>
	<17295.29744.13292.368041@cse.unsw.edu.au>
	<438F7C4B.1090404@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eyal Lebedinsky on Friday December 2
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday December 2, eyal@eyal.emu.id.au wrote:
> Neil Brown wrote:
> >>Q1) What is the correct command to bring these three up as
> >>    degraded?
> > 
> > 
> >   mdadm --assemble --force /dev/mdX /dev/sd[abc]1
> > 
> > However this won't work with the superblocks you have. So
> > 
> >   mdadm --create /dev/mdX -l5 -c256 -n4 missing /dev/sda /dev/sdb /dev/sdc
> 
> I do not see 'missing' the the mdadm manpage, but maybe Debian is too
> far behind?

It is in the section on "CREATE MODE"

       To create a "degraded" array in which some devices are missing,  simply
       give  the  word  "missing"  in place of a device name.  This will cause
       mdadm to leave the corresponding slot in the array empty.  For a  RAID4
       or  RAID5 array at most one slot can be "missing"; for a RAID6 array at
       most two slots.  For a RAID1 array, only one real device  needs  to  be
       given.  All of the others can be "missing".


> 
> # mdadm --version
> mdadm - v1.9.0 - 04 February 2005

The section I quoted is from the man page for 1.12.0, but that text
certainly predates 1.9.0.

> 
> Should I use 2.1 (is it safe to upgrade to it)?

You don't need to, but you can.  It is safe to upgrade.

> 
> I built it anyway and I do not see 'missing' listed in
> 	mdadm --create --help

I do.

$ /sbin/mdadm --create --help
Usage:  mdadm --create device -chunk=X --level=Y --raid-devices=Z devices

 This usage will initialise a new md array, associate some
 devices with it, and activate the array.   In order to create an
 array with some devices missing, use the special word 'missing' in
                                                        ^^^^^^^
 place of the relevant device name.

> 
> Reading the new mdadm.man I can see what .missing' does, good.
> 
> I got it up (fsck now running), thanks a lot.

Good to hear.

NeilBrown

> 
> -- 
> Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
> 	attach .zip as .dat
