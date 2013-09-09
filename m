From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] DDF: new algorithm for subarray UUID
Date: Tue, 10 Sep 2013 09:51:26 +1000
Message-ID: <20130910095126.2b07d8cd@notabene.brown>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de>
	<1378502781-849-2-git-send-email-mwilck@arcor.de>
	<522B7D2A.4000409@arcor.de>
	<20130909112041.4b8401f3@notabene.brown>
	<522E1556.4030502@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J1H_naN0H.Gh1muW6N8AIIM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <522E1556.4030502@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/J1H_naN0H.Gh1muW6N8AIIM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Sep 2013 20:37:10 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 09/09/2013 03:20 AM, NeilBrown wrote:
> > On Sat, 07 Sep 2013 21:23:22 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> >=20
> >> On 09/06/2013 11:26 PM, mwilck@arcor.de wrote:
> >>> Some fake RAID BIOSes (in particular, LSI ones) change the
> >>> VD GUID at every boot. These GUIDs are not suitable for
> >>> identifying an array. Luckily the header GUID appears to
> >>> remain constant.
> >>>
> >>> We construct a pseudo-UUID from the header GUID and those
> >>> properties of the subarray that we expect to remain constant.
> >>
> >> Thinking about it once more, it may actually be better to construct the
> >> subarray UUID only from the container GUID and the member number (and
> >> name), because if we implement Grow or Reshape for DDF, the other
> >> properties might change.
> >>
> >> I'm open for comments and suggestions.
> >>
> >> Martin
> >=20
> > I'd probably just base it on the container GUID and the member number.
> > Exclude even the name.
>=20
> Why that? Does it make sense to expect the UUID to remain the same when
> the array name has changed?

I would rather the UUID only changed when it absolutely has too.
A name is just an attributed, not part of the core identity.


>=20
> > It is unfortunate that this change will cause all existing DDF uuids to
> > change even for controllers where they are currently stable.
>=20
> Only for "foreign" arrays not created by MD - but see below.
>=20
> > Is it possible to detect whether a VD GUID is likely to change, and to =
only
> > use the new algorithm for those?
>=20
> I am going to submit a new patch soon where I built in a vendor "black
> list". This list currently contains only LSI, so the UUIDs of all
> non-LSI arrays will stay the same, and for LSI, to the best of our
> current knowledge, the UUIDs aren't constant anyway. I don't know
> whether all LSI fake RAIDs behave like this, nor whether the Option ROMs
> of other vendors do. Perhaps other people on this list can supply data
> points on this.

Thanks.  I'm going with this patch for now.  I'm certainly keen to hear of
any other data points which might suggest some improvement might be possibl=
e.

Thanks.
NeilBrown

--Sig_/J1H_naN0H.Gh1muW6N8AIIM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi5e/jnsnt1WYoG5AQJ1Og//Wo1Naa3NFE2MzEgORKiIY2hXSm0sScJS
cmPsptZB8IeJsNPLOWDZ3BGrGgB+viEHWCOAqUJPEE/TF47GDQ76M9J0fPYT5yeX
QTJRv4/BhwbW2hGvPffSPrFL3ATEuLJ0h8rafcImwTAHHTfqXhtFeKl3fiTa1nGw
CmdEmsdG+votpacKvII8o7kh/PQxcTUNObwZP/E5ryqIXktSgvPTb0DYfZNKWLAD
eA7bzBT+pvH7u7B4F9Teero4V7y8eRoiAO+UhHlyTjdEKPpgAQozWhyYSD9obnSL
Sh8xI5azHIDAA8T4QIsoxPQaYJM9XVN5JqTtanYv8yGZnGJixn6uMLt2QpvKd8dF
q5qxevOqdXSUggbJig0c8F/Gh+1+TtS8DPc39yjpOmCF+/MqvfJ5/3IXpmB3IrRM
fbVG4q4IHmiJMfB3hXBhbiFLYb1WyLSUXUOsfVTK6q/GRF7VATtbR1mUnTyCblam
3WKg97dU8WANfqLCVX2MIgVJpwNazxMhxTQkznTIrUoYvFfsdR2q5uEQXhfvUFEt
b2td+eXZ3V3/ADjEn8u1L8PG8aP2xMxLkpQIHwP8DjbAQQUk1rZF1GI6Fgg2D4ZZ
dEeGjkLHQ+eyNAtGDIIOwU9IbkQdDMrK+o9X9UsS98A5C9HD8DcmcTgpedFHkRWK
dlZB8aZGSSY=
=rS4+
-----END PGP SIGNATURE-----

--Sig_/J1H_naN0H.Gh1muW6N8AIIM--
