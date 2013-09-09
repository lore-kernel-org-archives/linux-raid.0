From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] DDF: new algorithm for subarray UUID
Date: Mon, 9 Sep 2013 11:20:41 +1000
Message-ID: <20130909112041.4b8401f3@notabene.brown>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de>
	<1378502781-849-2-git-send-email-mwilck@arcor.de>
	<522B7D2A.4000409@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l4C8K4MzXNNl8wK8HmOhNBD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <522B7D2A.4000409@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/l4C8K4MzXNNl8wK8HmOhNBD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 07 Sep 2013 21:23:22 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 09/06/2013 11:26 PM, mwilck@arcor.de wrote:
> > Some fake RAID BIOSes (in particular, LSI ones) change the
> > VD GUID at every boot. These GUIDs are not suitable for
> > identifying an array. Luckily the header GUID appears to
> > remain constant.
> >=20
> > We construct a pseudo-UUID from the header GUID and those
> > properties of the subarray that we expect to remain constant.
>=20
> Thinking about it once more, it may actually be better to construct the
> subarray UUID only from the container GUID and the member number (and
> name), because if we implement Grow or Reshape for DDF, the other
> properties might change.
>=20
> I'm open for comments and suggestions.
>=20
> Martin

I'd probably just base it on the container GUID and the member number.
Exclude even the name.

It is unfortunate that this change will cause all existing DDF uuids to
change even for controllers where they are currently stable.

Is it possible to detect whether a VD GUID is likely to change, and to only
use the new algorithm for those?

Thanks,
NeilBrown

--Sig_/l4C8K4MzXNNl8wK8HmOhNBD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi0iaTnsnt1WYoG5AQIQcBAAklnAsmdmPfVSfxzhp7EvKKj5ja/ucUrf
XB03pIGzyHuRLRhJ4qOEPXV9mWuF4a/SUgyTAbk0RbDU+FrvmN/4VlPMlKnAnm1P
MAUVkPjP9W6goL9bEx/tFJJh58F+AqilGYi7wLZvG5+xfuLdZnli8u5HNi6BV5cV
QyNY8nc3eAckPCZRG2WoxmftYYOxQ5ykxZYdUd2ViPpz/DS+SCJg1vHkCv2vkV+f
kAX982koRimrvvHzGNGq2cVqlHJAV4rC8HmEGfopPpCTvrNnG8PY9vGYsVNKRJWT
fGAbcrv8dVcf0UrNvzo+87U0rOedxnymt8gjW6IibCr2IcYqPHf5XHAYS/SSQCwv
FVKZYXc2+RHO+2qoU7nlMvICJwUKKix7EvNZdkeKtNOLJQ6Dk+n9tzxUOKg8lGQ3
t/C63YbwbglPdtnKnBCC55z6WsBvbGxH+BKwfAqxpnoaQeD/R3teUfNsYNoy54La
mw7BuoH63NguKUvFpUvQHbJgZD6bRQlct7A8MhjMnOOmPda2bqmzLxv4zLWvvLnX
Q6zu4IbzyQbkPDFD1AaEE8RJQmi32DbabdY42Q4JUwUChY9AiWcwYp8501ZJtIQP
ae9zFugaMHROqltCXZO8UhTN/glfNE5iStNyLiyvxoZIyumK7kxes2OMug6E7RP0
v5fTY0zNgZU=
=SIqv
-----END PGP SIGNATURE-----

--Sig_/l4C8K4MzXNNl8wK8HmOhNBD--
