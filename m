From: NeilBrown <neilb@suse.de>
Subject: Re: Failed Array Rebuild advice Please
Date: Thu, 12 Apr 2012 12:25:55 +1000
Message-ID: <20120412122555.598c0e12@notabene.brown>
References: <1334097164.41181.YahooMailNeo@web125506.mail.ne1.yahoo.com>
	<20120411090219.78392784@notabene.brown>
	<1334117647.68845.YahooMailNeo@web125505.mail.ne1.yahoo.com>
	<20120411144302.35f13f3d@notabene.brown>
	<1334196647.20850.YahooMailNeo@web125501.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kdAosdFUTjZrL=rpq1fQQe6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334196647.20850.YahooMailNeo@web125501.mail.ne1.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/kdAosdFUTjZrL=rpq1fQQe6
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Apr 2012 19:10:47 -0700 (PDT) jahammonds prost
<gmitch64@yahoo.com> wrote:

> > I think it is best to recover, and then reshape later.
> =A0
> Which is what I did. The destructive badblocks ran fine overnight, with n=
o errors on the drives that were failed out of the array. Interestingly one=
 of the additional drives that I want to add took an additional 6 hours to =
run badblocks, so I need to look into that a bit.
> =A0
> I am having a bit of an issue with the reshape tho... When I try and add =
one of the 2 additional devices I want to add (I'm going to add them one at=
 a time), I get an error about the bitmap needing to be removed.
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0mdadm --grow /dev/md0 --raid-devices=3D16
> =A0=A0=A0=A0=A0=A0=A0=A0mdadm: Need to backup 93184K of critical section..
> =A0=A0=A0=A0=A0=A0=A0=A0mdadm: Cannot set device shape for /dev/md0: Devi=
ce or resource busy
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0Bitmap must be removed befor=
e shape can be changed
>=20
> Now, the docs (and indeed several websites when I googled) suggest that y=
ou can have a bitmap present on a grow, and the help suggests that you can =
even change it during a grow..
>=20
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0If the word internal is given, then the bitmap=
 is stored with the metadata on the array, and so is replicated on all devi=
ces.=A0 If the word none is given with --grow mode, then any bitmap that is=
 present is removed.
>=20
>=20
> Is there an issue with the array, or just in my understanding and google =
foo?

You cannot reshape an array while it has a bitmap attached.
This restriction will probably be removed in Linux 3.5

NeilBrown


>=20
> I am running on Centos 6 (2.6.32-220.7.1.el6.x86_64) with madam (mdadm - =
v3.2.2 - 17th June 2011)
>=20
>=20
> Thanks again.
>=20
>=20
>=20
> =A0
> ----- Original Message -----
> From: NeilBrown <neilb@suse.de>
> To: jahammonds prost <gmitch64@yahoo.com>
> Cc: Linux RAID <linux-raid@vger.kernel.org>
> Sent: Wednesday, 11 April 2012, 0:43
> Subject: Re: Failed Array Rebuild advice Please
>=20
> On Tue, 10 Apr 2012 21:14:07 -0700 (PDT) jahammonds prost
> <gmitch64@yahoo.com> wrote:
>=20
> > One other question as the badblocks progresses.
> > =A0
> > >=A0 It will then recovery both devices in parallel.
> >=20
> > How many additional devices can be done at the same time? I presume tha=
t I am going to have to=A0replace the 2 failed devices before I try and gro=
w the array by adding 3 additional drives? I so, how many=A0additional driv=
es can be rebuilt concurrently with a grow? Could I add 5 devices and not s=
ee too much of a performance hit? Or would it be more sensible to add them =
one at a time?
> >=20
>=20
> I think it is best to recover, and then reshape later.=A0 I cannot promis=
e that
> doing them both at once will work .... it might but I have a feeling that
> there might be problems.
>=20
> Adding three additional drives at once should work well enough in terms of
> performance.
> However I would only do it if I were very very confident of the drives.
> If you hit bad blocks you start losing drives, and if you have 3 drives t=
hat
> you haven't used before, the chance of losing them all during the reshape=
 -
> while still small - becomes a little too high for comfort.
>=20
> But if you have run heavy bad-blocks tests on them all and they appear to
> work, then adding 3 drives at once should be fine.
>=20
> NeilBrown


--Sig_/kdAosdFUTjZrL=rpq1fQQe6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4Y9Mznsnt1WYoG5AQKMww/7BlNaGhBSUsLgRKBYwcMW9i0+jlqkq88V
HCzrU7wTmoR/kX+3xKZnwaBpfjyI79b1/0c4v8xhH1qx5Y9oxWDyCHbrTX9df+9c
aR7cftCEwAeBiBpjzSl5Oh3sebpP2ggUKcz/nHHcA1J40AL48wxPKVenFbw3VU+F
Xpb4hl38ae7m74dEOdr7jmss4iaFcl73iMJlEmY1KpP74e7KWkyDnZkSOHWsXUvu
IbROAtKOOlJCDynZ0MBHXRot9BdxGLGp4fFrRoo74eTFJheeHFhdfTKEpZUgqLow
MEb2/WIVduXIYp6j0WrpJihgwV4y8U3KKR9bWxfhNm8RCh5TEa/iKwyFrqzOyB9r
1ZMcVXIChHvZUlqEVC9MY9Hm4PWmhpwYnIOrh5mkYyFeBqNzJZGSEcark9xy1jJJ
g5pjSmnQR8w6MWxeOOScJmcUwzh1rIVFRKc9IbKNkoTxgsX+DEGVapNI0KBbAGQE
1xn9Wq34rKGP5lCM3rz2M1Pk4OYacp3g19FOnL8hRdvSgwX5Nfnp0JqtLDWPxQCU
Zqek1Tx1wGAB5qI11nznwZFB+62n6eHCa+nluVA2njMFT068J5+24O1Lpfz0/PNl
uOMaSbuwG1g5XDCsxPjPBq9FN1dSTyLf2/14mKrmaAS/ziPqhGnkLWrkjlY+RTYS
hlat+WEFOKY=
=DfGW
-----END PGP SIGNATURE-----

--Sig_/kdAosdFUTjZrL=rpq1fQQe6--
