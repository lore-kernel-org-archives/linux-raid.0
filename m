From: NeilBrown <neilb@suse.de>
Subject: Re: Growing 6 HDD RAID5 to 7 HDD RAID5
Date: Wed, 13 Apr 2011 07:15:54 +1000
Message-ID: <20110413071554.6537c52c@notabene.brown>
References: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
	<20110412231401.5bb9065c@natsu>
	<BANLkTim-iiYbza8ZZZv60ArRfXjnOuU7sg@mail.gmail.com>
	<20110413002238.3f31bdeb@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bOzDzmoY7xHxe0zBmzkWxEM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110413002238.3f31bdeb@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/bOzDzmoY7xHxe0zBmzkWxEM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Apr 2011 00:22:38 +0600 Roman Mamedov <rm@romanrm.ru> wrote:

> On Tue, 12 Apr 2011 18:21:13 +0100
> Mathias Bur=E9n <mathias.buren@gmail.com> wrote:
>=20
> > If I use --layout=3Dpreserve , what impact will that have?
> > If I preserve the layout, what is the final result of the array
> > compared to not preserving it?
>=20
> Neil wrote about this on his blog:
> "It is a very similar process that can now be used to convert a RAID5 to a
> RAID6. We first change the RAID5 to RAID6 with a non-standard layout that=
 has
> the parity blocks distributed as normal, but the Q blocks all on the last
> device (a new device). So this is RAID6 using the RAID6 driver, but with a
> non-RAID6 layout. So we "simply" change the layout and the job is done."
> http://neil.brown.name/blog/20090817000931
>=20
> Admittedly it is not completely clear to me what are the long-term downsi=
des of
> this layout. As I understand it does fully provide the RAID6-level redund=
ancy.
> Perhaps just the performance will suffer a bit? Maybe someone can explain=
 this
> more.

If you specify --layout=3Dpreserve, then all the 'Q' blocks will be on one =
disk.
As every write needs to update a Q block, every write will write to that di=
sk.

With our current RAID6 implementation that probably isn't a big cost - for
any write, we need to either read from or write to each disk anyway.

Anyway:  the only possible problem would be a performance problem, and I
really don't know what performance impact there is - if any.

>=20
> If anything, I think it is safe to use this layout for a while, e.g. in c=
ase
> you don't want to rebuild 'right now'. You can always change the layout t=
o the
> traditional one later, by issuing "--grow --layout=3Dnormalise". Or perha=
ps if
> you plan to add another disk soon, you can normalise it on that occasion,=
 and
> still gain the benefit of only one full reshape.

Note that doing a normalise by itself later will be much slower than not
doing a preserve now.
Doing the normalise later when growing the the device again would be just as
fast as no doing the preserve now.

NeilBrown


>=20
> >  Will the array have redundancy during the rebuild of the new drive?
>=20
> If you choose --layout=3Dpreserve, your array immediately becomes a RAID6=
 with
> one rebuilding drive. So this is the kind of redundancy you will have dur=
ing
> that rebuild - tolerance of up to one more (among the "old" drives) failu=
re,
> in other words, identical to what you currently have with RAID5.
>=20


--Sig_/bOzDzmoY7xHxe0zBmzkWxEM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iD8DBQFNpMEKG5fc6gV+Wb0RAi6pAJwM3W7XrMeBg3PC7x4mIviX3obZdACg0fXk
uHuwg43UikEvv2Cdb7IK5EU=
=Txai
-----END PGP SIGNATURE-----

--Sig_/bOzDzmoY7xHxe0zBmzkWxEM--
