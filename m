From: dean gaudet <dean@arctic.org>
Subject: Re: proactive-raid-disk-replacement
Date: Fri, 8 Sep 2006 02:24:40 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609080215220.32186@twinlark.arctic.org>
References: <45012E73.5040900@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45012E73.5040900@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 8 Sep 2006, Michael Tokarev wrote:

> Recently Dean Gaudet, in thread titled 'Feature
> Request/Suggestion - "Drive Linking"', mentioned his
> document, http://arctic.org/~dean/proactive-raid5-disk-replacement.txt
> 
> I've read it, and have some umm.. concerns.  Here's why:
> 
> ....
> > mdadm -Gb internal --bitmap-chunk=1024 /dev/md4
> > mdadm /dev/md4 -r /dev/sdh1
> > mdadm /dev/md4 -f /dev/sde1 -r /dev/sde1
> > mdadm --build /dev/md5 -ayes --level=1 --raid-devices=2 /dev/sde1 missing
> > mdadm /dev/md4 --re-add /dev/md5
> > mdadm /dev/md5 -a /dev/sdh1
> >
> > ... wait a few hours for md5 resync...
> 
> And here's the problem.  While new disk, sdh1, are resynced from
> old, probably failing disk sde1, chances are high that there will
> be an unreadable block on sde1.  And this means the whole thing
> will not work -- md5 initially contained one working drive (sde1)
> and one spare (sdh1) which is being converted (resynced) to working
> disk.  But after read error on sde1, md5 will contain one failed
> drive and one spare -- for raid1 it's fatal combination.
> 
> While at the same time, it's perfectly easy to reconstruct this
> failing block from other component devices of md4.

this statement is an argument for native support for this type of activity 
in md itself.

> That to say: this way of replacing disk in a software raid array
> isn't much better than just removing old drive and adding new one.

hmm... i'm not sure i agree.  in your proposal you're guaranteed to have 
no redundancy while you wait for the new disk to sync in the raid5.

in my proposal the probability that you'll retain redundancy through the 
entire process is non-zero.  we can debate how non-zero it is, but 
non-zero is greater than zero.

i'll admit it depends a heck of a lot on how long you wait to replace your 
disks, but i prefer to replace mine well before they get to the point 
where just reading the entire disk is guaranteed to result in problems.


> And if the drive you're replacing is failing (according to SMART
> for example), this method is more likely to fail.

my practice is to run regular SMART long self tests, which tend to find 
Current_Pending_Sectors (which are generally read errors waiting to 
happen) and then launch a "repair" sync action... that generally drops the 
Current_Pending_Sector back to zero.  either through a realloc or just 
simply rewriting the block.  if it's a realloc then i consider if there's 
enough of them to warrant replacing the disk...

so for me the chances of a read error while doing the raid1 thing aren't 
as high as they could be...

but yeah you've convinced me this solution isn't good enough.

-dean
