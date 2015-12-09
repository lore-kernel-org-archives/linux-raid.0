From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC] using mempools for raid5-cache
Date: Wed, 09 Dec 2015 11:36:30 +1100
Message-ID: <876108qwz5.fsf@notabene.neil.brown.name>
References: <1449072638-15409-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449072638-15409-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 03 2015, Christoph Hellwig wrote:

> Currently the raid5-cache code is heavily relying on GFP_NOFAIL allocations.
>
> I've looked into replacing these with mempools and biosets, and for the
> bio and the meta_page that's pretty trivial as they have short life times
> and do make guaranteed progress.  I'm massively struggling with the iounit
> allocation, though.  These can live on for a long time over log I/O, cache
> flushing and last but not least RAID I/O, and every attempt at something
> mempool-like results in reproducible deadlocks.  I wonder if we need to
> figure out some more efficient data structure to communicate the completion
> status that doesn't rely on these fairly long living allocations from
> the I/O path.

Presumably the root cause of these deadlocks is that the raid5d thread
has called
   handle_stripe -> ops_run_io ->r5l_write_stripe -> r5l_log_stripe
      -> r5l_get_meta -> r5l_new_meta

and r5l_new_meta is blocked on memory allocation, which won't complete
until some raid5 stripes get written out, which requires raid5d to do
something more useful than sitting and waiting.

I suspect a good direction towards a solution would be to allow the
memory allocation to fail, to cleanly propagate that failure indication
up through r5l_log_stripe to r5l_write_stripe which falls back to adding
the stripe_head to ->no_space_stripes.

Then we only release stripes from no_space_stripes when a memory
allocation might succeed.

There are lots of missing details, and possibly we would need a separate
list rather than re-using no_space_stripes.
But the key idea is that raid5d should never block (except beneath
submit_bio on some other device) and when it cannot make progress
without blocking, it should queue the stripe_head for later handling.

Does that make sense?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZ3eOAAoJEDnsnt1WYoG5g1cP/jPOgn+rQY7lPgIs8RIXgDLx
slUH+2/VNrwJC0egoTmD5+d2vxH0/Hz9lK7V2OI7LZ9o/p3a9M5eFWKRk/QLG0dW
Ud2BVuZa3/Yx3cfpLonGX/emXgtHjXeTaJnw7+hIRYL63IlyyMyAyxjkQH9oqcbH
h+52mTkVAXCUlj2pdSOsILgYQ93UpWdgVqemJwPqqP7zinWN3g8OIsDVDM2Suq+K
haIA+uTwh42f00ank3ookXyiUJ+HN9EsUcTDj1uvouUu7rIcyBQ5Je3OWG4rP0aG
8D0y2ILOzup6ZArFH/hh4XIWQA1btfKrPTT51zSVG02ItW8zaFs1sjAowQpZp6H+
sUmnEm95sYEIJi+3rOM+yfT7G9nzghutNZEu+VTKNg1TX8WgG5YyDuXN+/iwsSkW
/rlQse8QcmJKy7q2cy04kSOoG7qMMFAzSgn1aQ/+LyNF85BkEvP0Jf1Xk4fDHnxC
aHa0K3v55ulCeM6mvUrD0nfiQgCyATE8lVPMHY8GrR1ye94NTGoINdsXWvx6PByo
mnBKUISZfX9mI1Rf5G913fx98pIHXN+X7J3Gr3rRnfEIoQmOaOQgVmkMw1f7+0Pw
VLmzYy9sts8qWalIkesfo5fAlQtXIK4xAfEOXGr3/j4awda7O7xSjflsFOultZak
vsoY5QshSZhJP7CSfBm7
=aUkP
-----END PGP SIGNATURE-----
--=-=-=--
