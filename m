From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Partitioning a RAID device
Date: Thu, 05 Sep 2002 18:00:57 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D776399.AC6BD33E@tls.msk.ru>
References: <Pine.LNX.4.30.0209040912270.11782-100000@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Derek Vadala wrote:
> 
> On Wed, 4 Sep 2002, Arne Wiebalck wrote:
> 
> > is it possible to have partitions on a RAID device?
> >
> > [...]
> >
> > Anything I am missing here?
> 
> You first need to patch your kernel so that the md driver and md devices
> support partitioning. Check out
> http://cgi.cse.unsw.edu.au/~neilb/patches/linux-stable/ for the patches.

Hmm, interesting.  What's those patches are for?  What's their status?
Are they just experiments, proof-of-concept, or intended for general
use?  Are there any interdependances of the set of 5 md-related patches
for 2.4.19?  Some more information on this all?  Discussions?  Official
2.4/2.5 status of this work?  Relation with e.g. LVM?  Iteraction with
devfs for mdp?  Device nodes assignment (i.e. what will become mpa, mpb
etc when one have md0, md1 etc)?  (There are quite a few aspects mentioned
on the above page, mostly nfs-, ext[23]- and md-related stuff, but this is
linux-raid list :)

Errm, so many question... ;)

BTW, still don't know which is "better" -- have several md arrays for every
filesystem/whatether, or have one md array and split it using e.g. lvm or
using this mdp method?  (Two different point of view: system resource usage
should be less for one large md array, but will this one large array handle
load as effective as several independant ones?)

Thanks.

/mjt
