From: NeilBrown <neilb@suse.de>
Subject: Re: Status of discard support in MD RAID
Date: Mon, 15 Sep 2014 13:56:05 +1000
Message-ID: <20140915135605.19cb3998@notabene.brown>
References: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com>
	<26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com>
	<20140912153915.473bc562@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/QBGvLxCRTN5c8dqsECI56lT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140912153915.473bc562@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Chris Murphy <lists@colorremedies.com>, Brassow Jonathan <jbrassow@redhat.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/QBGvLxCRTN5c8dqsECI56lT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Sep 2014 15:39:15 +0600 Roman Mamedov <rm@romanrm.net> wrote:

> On Thu, 11 Sep 2014 18:46:04 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
>=20
> > If it doesn't, a check check > md/sync_action will report mismatches in
> > md/mismatch_cnt; and a repair will probably corrupt the volume.
>=20
> At least with RAID1/10, why would it?
>=20
> > and you can't do repair type scrubs.
>=20
> If the FS issues TRIM on a certain region, by definition it no longer car=
es
> about what's stored there (as it's is no longer in use by the FS). So eve=
n if
> a repair ends up coping some data from one SSD to another, in effect chan=
ging
> the contents of that region, this should not affect anything whatsoever f=
rom
> the FS standpoint.
>=20
> Technically perhaps that still counts as a "corruption", but not of anyth=
ing
> in the filesystem metadata or user data, just of unused regions. So not as
> scary as it first sounds.
>=20
> The only case where you'd run into problems with this, is if some apps ex=
pect
> to read back zeroes on TRIM'ed regions, e.g. Qemu in the "detect-zeroes=
=3Dunmap"
> mode. But using that would be dangerous even on a single SSD with
> non-deterministic TRIM, so mdraid changes nothing here.
>=20

For any block device in Linux you can read the 'queue/discard_zeroes_data'
attribute to see if it is safe to expect zeros from a discarded region.
md sets that correctly.
For raid1/raid10 it is set if all member devices have it set.
For raid5/6, it is never set.  This is because we can only discard full
stripes so a non-full-stripe discard will not zero all of the data.

NeilBrown

--Sig_/QBGvLxCRTN5c8dqsECI56lT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBZjVTnsnt1WYoG5AQKG0RAAuBUPI6Z6NBIVy5dpyNVqk+Jx6yJ2xzg1
6JJkUqesT24DJaweyvdoQ3slhh1fbdrgwWNk64ucskJgfXiJXFYo8a2s8m5iSYWl
6Own/+xhRhYi5W5j0F8zQFTM8MHSX/vBTUXNXhD02zzSt7qf0ozqmEj3hF9HZ6zi
PRqsjqAegJpUcIlPmu2vdWhjyjDel80ak2dLrhseuTRcE89Hxzj11WbQk817XSUZ
LyHO09G2DnNvTEaPszasU2h4tac5DAOcrsPx8lpuGnWEXtk7tAuo6JhlG0/OqfsZ
Z03jp5uenQGgRJBSGipWZ8v01uD5/YOdwuUnhW2wVtw+dXO9bNDvnf4Xqx0Q8P/t
jT07WAF9qn/SBe+svq/JX83pG+PVtd/fOxuMwe6+kdi6WkPrJuNNEh7A6UT5mioO
5orXyEDtbdd0A3HbTYJTVb+H+KirnHTDDA9VLPJlW/DcrgMZv9UOLk3gQg9eRMz3
mBQyD81B0MPJAutGPog1O5hN/pu3701FEcIFwgF/VaaWIB0eew4bD9v28J+PyV3+
gWoLgdAr8Fn2Gkrk499uLsw0EbuwIR6QBAjS0H9J3/RO7seir3iZrmPiVLCLu+Ig
Ln5elrX8NELK04MTzM2v/npS1lifiwiEJZjCLc2YsYplTivtn5qtfHQC6Zr3tW2q
rtOnXUyqbmc=
=k0DO
-----END PGP SIGNATURE-----

--Sig_/QBGvLxCRTN5c8dqsECI56lT--
