From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 9/9] mdadm: 'dump' support
Date: Thu, 16 May 2013 15:11:59 +1000
Message-ID: <20130516151159.70fe0aee@notabene.brown>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
	<20110826021445.28015.63357.stgit@localhost6.localdomain6>
	<20110830125803.19ad660b@notabene.brown>
	<20110830121203.Horde.wvD-Spk8pphOXLdzcMjKT1A@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1PU61CRBI2p6iiZ.7eosha_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110830121203.Horde.wvD-Spk8pphOXLdzcMjKT1A@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander =?ISO-8859-1?Q?K=FChn?= <alexander.kuehn@nagilum.de>
Cc: Dan Williams <djbw@fb.com>, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/1PU61CRBI2p6iiZ.7eosha_
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Aug 2011 12:12:03 +0200 Alexander K=FChn
<alexander.kuehn@nagilum.de> wrote:

>=20
> Zitat von NeilBrown <neilb@suse.de>:
>=20
> > On Thu, 25 Aug 2011 19:14:45 -0700 Dan Williams <dan.j.williams@intel.c=
om>
> > wrote:
> >
> >>   mdadm -E /dev/sda --dump=3Dfoo
> >>
> >> Creates a sparse file image of /dev/sda named foo with a copy of the
> >> metadata instance found by -E.
> >>
> >> When used in the opposite direction:
> >>
> >>   mdadm -E foo --dump=3D/dev/sda
> >>
> >> ...can restore metadata to a given block device, assuming it is
> >> identical size to the dump file.
> >
> > Suppose we did have a separate 'restore' function - what would it look =
like?
> > An option to create?
> >
> >   mdadm --create --restore=3Dsome-directory /dev/sda /dev/sdb
> >
>=20
> Yes, from a UI perspective having separate dump/restore options is =20
> better. Since there is also dump(8)/restore(8) it would also keep the =20
> nomenclature.
> Otherwise I would rather name it "copy-metadata" or something as with =20
> copying the user is or should be aware that the order or arguments =20
> matters.
> Alex.

Nearly two years later, I've committed some functionality based on this.

mdadm --dump=3D/root/md /dev/*

will create files in /root/md/ with metadata from any device with metadata
recognised by mdadm.

mdadm --restore=3D/root/md /dev/*

will restore it all.

More details in the man page.
http://git.neil.brown.name/git?p=3Dmdadm.git;a=3Dblob;f=3Dmdadm.8.in;h=3Dc8=
559dae8e789a30e0c4ee826745a42980629977;hb=3D74db60b00a43a5ae636477c10c24e92=
3e76049ce

NeilBrown

--Sig_/1PU61CRBI2p6iiZ.7eosha_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUZRqnznsnt1WYoG5AQL0uA//de53QvuhAQRQGbxuMcrVl1+rjbOi8DbI
DtWyHAI1DnoUQzTo90zOhcJsQQHJZcdjkOmt0T1AAyOmzKi66cF7x0CrOq+pU+L9
WOInIaTDQVcyzQE1gugmQFWTplPhXh+/qz5U3nfzHLgPEoVbG0FDGlMdtbKyS1nt
+EzToW5nI55fy0IroHn8lVjm3yQUqb8NNMWyQb4NNlXk2+piymYvwwk8xhhVRKyz
SYtL7duec+uUQg+pOFiznstWRSBAhl8o2AbcmD27HAtvOphWsJWGppPVc+SlZ+XD
jn6vTsZC39TUsUbPvf8Qvp7yh2dE033cn/epE8WNGjczppzvoVE7ub12FawFK2mZ
4vneYGIcdIkZa/GCXMnTEahQp/01laSEJ0Ny8q/odsaV8rO+aNZqRR1DvozbCC9F
PPlsam61fZpTG0TMBjzy/27iMJI2GPP6NH77jOnsZqF4NoEidRUqjvFWOV1sU+w/
gx/Ynvbg6fdCH4mQ0KgGfK0zuAp4zBQceVLvms4dqO1j1/wrzN37Qep20zm17qrS
dAFM1ViANVB1uT2MgJETj39ytsU/UPvQvKivhDo4hsOmnLvS0wvhRv6Of/EukDPT
X7MNenXf3NTAnUMSfgm/2ZSTjxl+VOqHMxuQHzL1zpX6fcabABUqKC6asIDTMq67
TSlTY2GEUuo=
=CYB4
-----END PGP SIGNATURE-----

--Sig_/1PU61CRBI2p6iiZ.7eosha_--
