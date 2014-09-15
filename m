From: NeilBrown <neilb@suse.de>
Subject: Re: Status of discard support in MD RAID
Date: Mon, 15 Sep 2014 13:46:22 +1000
Message-ID: <20140915134622.606855e9@notabene.brown>
References: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com>
	<26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/L4Einz7sMxDzyY1BfhhBWkD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Brassow Jonathan <jbrassow@redhat.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/L4Einz7sMxDzyY1BfhhBWkD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Sep 2014 18:46:04 -0600 Chris Murphy <lists@colorremedies.com>
wrote:

>=20
> On Sep 11, 2014, at 5:38 PM, Brassow Jonathan <jbrassow@redhat.com> wrote:
>=20
> > Neil (or anyone else),
> >=20
> > I know that trim/discard support was added back in 2012 (commit 9db9088=
0).  However, I thought there were still issues regarding what happens when=
 various sync operations occur.  I'd like to turn on discard support in dm-=
raid.c (a oneline patch) if things are in order.  I can enable any, all or =
none depending on your recommendation.  (I assume RAID1/10 is easier than t=
he parity RAIDs.)
>=20
> If all the controller and drive support it then it should pass through, b=
ut there's the problem whether the SSD supports deterministic trim. If it d=
oesn't, a check check > md/sync_action will report mismatches in md/mismatc=
h_cnt; and a repair will probably corrupt the volume. So you can still use =
trim with a drive that returns non-deterministic results with raid0/1/10, b=
ut you can't rely on the result of md/mismatch_cnt and you can't do repair =
type scrubs.
>=20
> For raid5/6, it's a problem to use trim if the drive returns non-determin=
istically for trimmed blocks. I'd think that in addition to DRAT being supp=
orted, it'd need to support DZAT.

md raid5/6 will not use trim unless the underlying device reports
"discard_zeros_data".  That is a Linux internal field name.  I don't know
exactly that it means in SCSI/SATA/whatever devices.

NeilBrown


>=20
> smartctl --identify=3Dwb /dev/diskX | grep -i trim
>=20
>=20
> Chris Murphy
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/L4Einz7sMxDzyY1BfhhBWkD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBZhDjnsnt1WYoG5AQJ8LRAAtC/71WCfMs+VFSdEOy50nAcmHGrDNvTm
UnsVCX3EaumLxrPiuMxpfHmlPrOjxQyWGEx43KVOLTlLrMheQrnS3siXM3r1gN5+
nujmNzsIJJeQ9A0/z68VSWni35BcWQ75aqVyNIYQc1bT8Vg25N57cO/Aeurk5hD4
cgK3eNC8R5BkWdP+5I6aqMatzJQtKu1ihWgFo5XDdhEXTJ8gR+8esx0mxIeJtToM
VYQXWuXthGJ+Aszuod4lF7Gcz7nL0u418VHfnYl81/wqjDHm/77dP/BHb26dxM/R
JExTsp9PRnuNmWB9i9fmiVf9UgvC34hGDuCZr6OtIWMuUkwKezj2NiwGsOMP+jbe
6/GRlcH78/zcQrCXWSZ+RX2Ty9THb1uyH+FM/nXk5s0+9JZqkpylXv3tEQckNHHb
iZeXt/TijS163DqRF64ucVUGjPFew0FngidfH+/yXBf6wANv9WYb50NTygdFqRJe
o+DPKbOTuu/+92ztB1hP+pn14yTHFfFZWk6eQq8ctiRqxqEa4xwA9BsYyGpcm1Tx
0H7N27rRoSC5YgUTBhOncl2Vl4rrUjZzzp+PyLB4RHVC9lbOBbl+3wXMACZmlLrU
agnfGHIn2VQkzuBudn1CNMK6p//sxdmsBftwpuJk5bhoCujzbRioP6sCLds9X6d+
3sLxGfJdVec=
=1pB0
-----END PGP SIGNATURE-----

--Sig_/L4Einz7sMxDzyY1BfhhBWkD--
