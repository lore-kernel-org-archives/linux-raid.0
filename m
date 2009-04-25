From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 25 Apr 2009 02:03:03 -0500
Message-ID: <20090425070306714.WAHV6537@cdptpa-omta02.mail.rr.com>
References: <49F2A193.8080807@sauce.co.nz>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F2A193.8080807@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >> I grew a 3 disk RAID5 to 4 disks and the write performance was
> >> definitely inferior until this was done.
> >
> > Well, write performance is not generally a big issue with this array, as
> it
> > does vastly more reading than writing.  In any case, as long as the
> > parameters can be updated with a mount option, it's not a really big
> deal.
> > What about the read performance?  Is it badly impacted for pre-existing
> > files?  The files on this system are very static.  Once they are edited
> and
> > saved, they're pretty much permanent.
> 
> My understanding of growing the array by adding more disks, is that all
> files are rewritten across all disks, so there is

So there is...?  I think you accidentally deleted part of what you were
saying.  Let me see if I can guess what it was.  You were perhaps going to
say the stripe is re-organized at the array layer, so at the file system
layer the machine thinks the file was originally written that way?  While it
would seem to make sense, I'm going to have to think about it a bit to
convince myself it is true.
 
> The issue with writes is that if the filesystem knows the exact geometry
> of the array (no. of devices and stripe size), it can coalesce writes
> into n x stripe size chunks, which means that there is minimal
> read-modify-write penalty with parity having to be recalculated.

Yes, I follow that.

> If you grow the array and do not tell XFS that this chunk size has
> changed, then every single write will be based on the previous size and
> will require read-modify-write.

Yeah, I understood that, too.  That it can be re-configured in the mount
makes it a reasonable proposition.

