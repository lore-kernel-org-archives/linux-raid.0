From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm drives me crazy
Date: Thu, 2 Dec 2004 08:38:21 +1100
Message-ID: <16814.14797.780410.83537@cse.unsw.edu.au>
References: <41ADA964.3030606@univ-mlv.fr>
	<41ADBEC6.8030701@univ-mlv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Fabrice LORRAIN on Wednesday December 1
Sender: linux-raid-owner@vger.kernel.org
To: Fabrice LORRAIN <Fabrice.Lorrain@univ-mlv.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 1, Fabrice.Lorrain@univ-mlv.fr wrote:
> Fabrice LORRAIN wrote:
> > Hi all,
> > 
> ...
> > $ sudo mdadm --create /dev/md0 --level=5 --raid-devices=6 /dev/loop[0-5]
> 
> 
> $ sudo mdadm --create /dev/md0 --force --level=5 --raid-devices=6 
> /dev/loop[0-5]
> 
> Seems to give what I expected (a raid5 pool with 6 devices, no spare).
> 
>  From mdadm man page :
> "...When creating a RAID5 array, mdadm will automatically create a 
> degraded array with an extra spare drive.  This is because building the 
> spare into a  degraded  array  is in general faster than resyncing the 
> parity on a non-degraded, but not clean, array.  This feature can be 
> over-ridden with the -I --force option."
> 
> "-I" doesn't seems to be understood by mdadm. Leftover ?

The "-I" is a typo in the man page.  It should be ".I", which would
set the "--force" in italics.

> 
> I don't understand what the previous extract from the man page means. My 
> understanding is that the default behaviour of mdadm is to create a 
> raid5 pool in degraded mode aka with a missing drive ? Is this
> correct ?

Yes.  That is correct.  
It does this because (as the man page says) you get a fully in-sync
raid5 array - with all parity blocks correct - sooner.
> 
> after
> $ sudo mdadm --create /dev/md0 --force --level=5 --raid-devices=6 
> /dev/loop[0-5]
> 
> the state of the array is dirty. Why ?
> 
> $ sudo mdadm --stop /dev/md0 followed by
> $ sudo mdadm --examine /dev/loop[0-5]
> 
> gives a clean state for each device but
> 
> $ sudo mdadm --assemble /dev/md0 /dev/loop[0-5] keeps the dirty state of 
> the array.

"dirty" should be changed to say "active", and probably will be in the
next release of mdadm.

NeilBrown
