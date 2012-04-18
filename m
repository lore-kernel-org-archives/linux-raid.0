From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC 1/2] MD: raid5 trim support
Date: Wed, 18 Apr 2012 15:57:49 +1000
Message-ID: <20120418155749.4afae9cb@notabene.brown>
References: <20120417083552.483324288@kernel.org>
	<20120417084632.306032602@kernel.org>
	<CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
	<20120418062641.000e881c@notabene.brown>
	<4F8E11A6.7090305@kernel.org>
	<20120418144841.04ce1a10@notabene.brown>
	<4F8E5185.8050809@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PECm/zhP9vf2NDxnYv6l0ri"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8E5185.8050809@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

--Sig_/PECm/zhP9vf2NDxnYv6l0ri
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 13:30:45 +0800 Shaohua Li <shli@kernel.org> wrote:

> On 4/18/12 12:48 PM, NeilBrown wrote:
> > On Wed, 18 Apr 2012 08:58:14 +0800 Shaohua Li<shli@kernel.org>  wrote:
> >
> >> On 4/18/12 4:26 AM, NeilBrown wrote:
> >>> On Tue, 17 Apr 2012 07:46:03 -0700 Dan Williams<dan.j.williams@intel.=
com>
> >>> wrote:
> >>>
> >>>> On Tue, Apr 17, 2012 at 1:35 AM, Shaohua Li<shli@kernel.org>   wrote:
> >>>>> Discard for raid4/5/6 has limitation. If discard request size is sm=
all, we do
> >>>>> discard for one disk, but we need calculate parity and write parity=
 disk.  To
> >>>>> correctly calculate parity, zero_after_discard must be guaranteed.
> >>>>
> >>>> I'm wondering if we could use the new bad blocks facility to mark
> >>>> discarded ranges so we don't necessarily need determinate data after
> >>>> discard.
> >>>>
> >>>> ...but I have not looked into it beyond that.
> >>>>
> >>>> --
> >>>> Dan
> >>>
> >>> No.
> >>>
> >>> The bad blocks framework can only store a limited number of bad range=
s - 512
> >>> in the current implementation.
> >>> That would not be an acceptable restriction for discarded ranges.
> >>>
> >>> You would need a bitmap of some sort if you wanted to record discarded
> >>> regions.
> >>>
> >>> http://neil.brown.name/blog/20110216044002#5
> >>
> >> This appears to remove the unnecessary resync for discarded range after
> >> a crash
> >> or discard error, eg an enhancement. From my understanding, it can't
> >> remove the
> >> limitation I mentioned in the patch. For raid5, we still need discard a
> >> whole
> >> stripe (discarding one disk but writing parity disk isn't good).
> >
> > It is certainly not ideal, but it is worse than not discarding at all?
> > And would updating some sort of bitmap be just as bad as updating the p=
arity
> > block?
> >
> > How about treating a DISCARD request as a request to write a block full=
 of
> > zeros, then at the lower level treat any request to write a block full =
of
> > zeros as a DISCARD request.  So when the parity becomes zero, it gets
> > discarded.
> >
> > Certainly it is best if the filesystem would discard whole stripes at a=
 time,
> > and we should be sure to optimise that.  But maybe there is still room =
to do
> > something useful with small discards?
>=20
> Sure, it would be great we can do small discards. But I didn't get how to=
 do
> it with the bitmap approach. Let's give an example, data disk1, data disk=
2,
> parity disk3. Say discard some sectors of disk1. The suggested approach is
> to mark the range bad. Then how to deal with parity disk3? As I said,=20
> writing
> parity disk3 isn't good. So mark the corresponding range of parity disk3
> bad too? If we did this, if disk2 is broken, how can we restore it?

Why, exactly, is writing the parity disk not good?
Not discarding blocks that we possibly could discard is also not good.
Which is worst?


>=20
> Am I missed something or are you talking about different issues?

We are probably talking about slightly different issues..

NeilBrown


--Sig_/PECm/zhP9vf2NDxnYv6l0ri
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT45X3Tnsnt1WYoG5AQLNYxAAmRxespFdsNSskIFMGma8OSPohg9B6/H7
H4Q4I2bdPlp2XVOBI+diy9huXozubsU2B8QqikUHbYEopCQQJDDNKdZDPqePzFbF
pj+PIm2clSy3pbLWhV1nzReniviCDMmKkL6a4pSzwkzvN2IoEHv29LBGOcEma/0c
yh84vkt9Jm4lrUHdveFODQHdjh7VELd9e8HADJGwxgzK/5cDOTTkCABUAWDpZurK
6qlc/nCKjJS2HwG88sppAn4kUJoJFH3G8ScnYGmgFR3/T+pOUkXJ/gW6/cm1sDUX
ulPaarwj4oth5Czv9shnImdJiXyAdEMRbv6qeY2m4bWHIzUEkwN7XT5iqcMIseL5
9yvfAPGuLepl9bIc4Licog4x1b/cgzk49PNdaus2j1SxsQgvl6niDhxdxi5NqbKO
ABlXF6X9xi6k86FJCrAOQeJjpMGk05c3y18Fy4HmhGB9XFQRtU+mWj3DA7/7Z57r
UrtoVzKobvuVFZbrGYy3jSU7KZGYJe/McFMKaibsx+qfq2tCIhQtX73FXQPayGoa
FHCtw6imrsMd1rfhnJrXsLl4dW6V+NR+dVHrhZbhEEhXc38nPZfZO2D60kMAjaTc
uyRUTK+0WostA/BiqVL2mZN8MDtnUa1PqEm6Z2LXJmqmlX+g0M6c62uIy5GJwuHJ
7rDf/bx85tI=
=CNju
-----END PGP SIGNATURE-----

--Sig_/PECm/zhP9vf2NDxnYv6l0ri--
