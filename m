From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Partitioning a RAID device
Date: Fri, 6 Sep 2002 15:21:52 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15736.15216.73004.873636@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.30.0209040912270.11782-100000@jaded.cynicism.com>
	<3D776399.AC6BD33E@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Thursday September 5
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 5, mjt@tls.msk.ru wrote:
> Derek Vadala wrote:
> > 
> > On Wed, 4 Sep 2002, Arne Wiebalck wrote:
> > 
> > > is it possible to have partitions on a RAID device?
> > >
> > > [...]
> > >
> > > Anything I am missing here?
> > 
> > You first need to patch your kernel so that the md driver and md devices
> > support partitioning. Check out
> > http://cgi.cse.unsw.edu.au/~neilb/patches/linux-stable/ for the patches.
> 
> Hmm, interesting.  What's those patches are for?  What's their status?
> Are they just experiments, proof-of-concept, or intended for general
> use?  Are there any interdependances of the set of 5 md-related patches
> for 2.4.19?  Some more information on this all?  Discussions?  Official
> 2.4/2.5 status of this work?  Relation with e.g. LVM?  Iteraction with
> devfs for mdp?  Device nodes assignment (i.e. what will become mpa, mpb
> etc when one have md0, md1 etc)?  (There are quite a few aspects mentioned
> on the above page, mostly nfs-, ext[23]- and md-related stuff, but this is
> linux-raid list :)
> 
> Errm, so many question... ;)

State:  I use them in production on most of my servers.
I like to mirror two whole devices together, and use that as the
system disk.  I parition it for a root,  a swap, and an other-stuff
partitions.

Lilo needs a bit of coaxing to make it work with partitioned raid.

Dependancies: probably.  I should sort them out and maybe submit bits
to Marcelo if I ever find a minute.  I'd kind-of like to ge
partitioning into 2.5 before I submit it for 2.4 though.

LVM:  Independant, thought can provide vaguely similar function.

devfs: works fine. try it and see.

device nodes:
  minors 0..15 are
   /dev/md/d0, /dev/md/d0p1, /dev/md/d0p2, ... /dev/md/d0p15
  minors 16..31 are
   /dev/md/d1, /dev/md/d1p1, /dev/md/d1p2, ... /dev/md/d1p15

 /dev/md/d0 is the same as /dev/md0
 /dev/md/d1 is the same as /dev/md1

> 
> BTW, still don't know which is "better" -- have several md arrays for every
> filesystem/whatether, or have one md array and split it using e.g. lvm or
> using this mdp method?  (Two different point of view: system resource usage
> should be less for one large md array, but will this one large array handle
> load as effective as several independant ones?)

Depends what you want to do.  As I said, I use a partitions raid1 part
of drives for some servers.  
For others (where I want a bit more disk space and so have extra
drives) I partition each drive, into root, swap and rest.
All the roots are raid1 together.
All the swaps are raid1 together
All the rest are raid5 together.

NeilBrown
