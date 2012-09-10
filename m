From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID: Fix for ineffective "sync" directive
Date: Mon, 10 Sep 2012 17:11:51 +1000
Message-ID: <20120910171151.0158ff6c@notabene.brown>
References: <1345735914.25206.8.camel@f16>
	<20120905114426.1ce3c898@notabene.brown>
	<D4625EDF-9059-4716-A3B2-CEC8418047F4@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8o1HYeHM1ueN0f8zTgb/Gp2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D4625EDF-9059-4716-A3B2-CEC8418047F4@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8o1HYeHM1ueN0f8zTgb/Gp2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Sep 2012 09:32:16 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Sep 4, 2012, at 8:44 PM, NeilBrown wrote:
>=20
> > On Thu, 23 Aug 2012 10:31:54 -0500 Jonathan Brassow <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >> Neil,
> >>=20
> >> There are two ways I see to fix the problem of the "sync" table argume=
nt
> >> not causing the array to re-sync.  We could set mddev->events to
> >> UINT_MAX and force an mddev/bitmap event mismatch - causing the bitmap
> >> code to set BITMAP_STALE itself.  Otherwise, we can do as I have below
> >> and set BITMAP_STALE ourselves.  The real difference is whether this is
> >> done before or after md_run().  The first solution can be done before
> >> md_run(); the second cannot because the bitmap is allocated during
> >> md_run().  Either solution works and correctly sets the bitmap to stale
> >> before bitmap_load() is called.  So, rather than having to think about
> >> issues that come with setting events to UINT_MAX, I chose to set the
> >> bitmap stale after md_run().
> >=20
> > I'm not at all sure this is the right way to look at the issue.
> >=20
> > The only reason that we have 'sync' and 'nosync' table args is because
> > originally we weren't storing any metadata on disk.  The 'in-sync?' sta=
te of
> > the array is important metadata, so it needed to be given to md via a t=
able
> > option.
> >=20
> > If you have a bitmap, then you are storing this information in metadata=
, so
> > including it as a table option is redundant and - as you noticed - igno=
red.
> >=20
> > If you want to assert that the data in the bitmap is incorrect, then I =
think
> > the best approach is to change it so that it is correct.
> > i.e. if you want to assert that an array is not in-sync and should be f=
ully
> > 'synced', then the right thing to do is to write lots of '1's to the bi=
tmap
> > before trying to assemble the array.
> >=20
> > However I'm not violently against the patch - though I would be against
> > fiddling with event_count. It does seem unpleasantly asymmetric though.
> > The 'sync' option says 'assume all bits in the bitmap are set', but the
> > 'nosync' option doesn't say 'assume all bits in the bitmap are clear'.
> >=20
> > Is simply writing to the bitmap when you want to force some behaviour an
> > option, or do you really really want "sync" to mean "please ignore the
> > bitmap"?  (or maybe an "ignorebitmap" option is what we want??).
>=20
> For me, the 'sync' and 'nosync' args are not just a vestige of when we di=
dn't have metadata; but also a form of continuity with dm-raid1.  The 'sync=
' option has - for device-mapper - always been a way to reset the bitmap an=
d force a resync.

With dm-raid1, it is dm-log.c which interprets the 'sync' and 'nosync' flag=
s.
The meaning seems to be:
 - 'sync' - ignore the log, force the array to be synced (i.e. set all
   regions to 'dirty')
 - 'nosync' - ignore the log, don't sync the array (i.e. set all regions
   to 'clean')
 - neither of those - use the log to determine whether to sync or not.

If you want to make the flags to dm-raid mean exactly the same as that (i.e.
if either  sync or nosync is present, we ignore the metadata) then I would =
be
happy with that.  I don't think that is quite what your patch does though -
it only does half of it.

NeilBrown


--Sig_/8o1HYeHM1ueN0f8zTgb/Gp2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE2SuDnsnt1WYoG5AQJlYRAAuNtELmIeyVN/gbpLV07pjC5uHlq01QpU
z263TxgTJZt/cCYQTMtMvFsUEm6p5I9HsR7qPXiDv/Yd0rY2azsyit/kIM/E/sZ9
TjRIV2RTW5bDsqP7Nmfdw6Yb75/MEyPG0DHltXc80kXcqh5xDCMdN0LT3Ckp+oLn
mLZxAcwgYct6J0QVG6QFFpZYGgCH7yPL+6TldCjNvdYz0QfVAQrGPa1BsYgpxdPN
U9ftby/pr30v3KMBk1PaxnmDNaKDxZ4cxasIHkqqe1PhPw5yL102C6UI5YW33aZ7
NclPtZkH9YON3ymWvD2//1tZSuCJFaJFaz+7HUkbvs4kcE8vY5lNqoed/Jz5qIXf
ovAbZd+WoMrko4WxvNViIlHd27NuYmRaqvuvRWl+fph4S5leXCNP6wy+HLS0G9hp
SAE43P7OroCdrZJqaPRKhXs/ZQviZQC5bZiJsCfKUTh3E4W8n4nmRG1MdM6Gv4rk
+DpxVLc572L0mfzrPyWmIfWTWLYe2PO4gM04XNS257tojVZEzIH0C1v2vg5V4Jg8
kdsBNBY8VNqufKvMzwoK6g/PxqnhnRcz5wCcfCKuV6fFCGMqUDHmXY8Gv3aYtcNK
uBsdS0oImeP+aeEU3+zX9cpu00hfJoAOMlrjcXi59cv29rNzfPxd4rvNus9Sv3YS
3oMAvbn4eOc=
=MS+h
-----END PGP SIGNATURE-----

--Sig_/8o1HYeHM1ueN0f8zTgb/Gp2--
