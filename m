From: NeilBrown <neilb@suse.de>
Subject: Re: read-ahead for md/lvm combination
Date: Sun, 13 May 2012 07:32:40 +1000
Message-ID: <20120513073240.2d292ec4@notabene.brown>
References: <4FAD2866.8070209@pocock.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SvxDonyfJtpSNwc2xFe7WMg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAD2866.8070209@pocock.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SvxDonyfJtpSNwc2xFe7WMg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 May 2012 14:55:34 +0000 Daniel Pocock <daniel@pocock.com.au> wro=
te:

>=20
>=20
> While I was adding the SCTERC settings to my rc.local, I had a look over
> /sbin/blockdev --setra ... settings
>=20
> I do things like this, for example:
>=20
> /sbin/blockdev --setra 8192 /dev/mapper/myvg-large_media_files
>=20
> What about
> - the devices /dev/sd[ab]2
> - the md device, /dev/md2  (which is the PV for LVM) ?
>=20
> Would it be correct to leave /dev/sd[ab]2 and /dev/md2 at defaults, and
> only specify larger sizes for LVs that need it?  Or should I even make
> /dev/sd[ab]2 and /dev/md2 smaller than the default value (256)?

The read-ahead setting is interpreted by the pagecache.
So it only makes sense to set in on a device which is directly mounted or
accessed via /dev/XXX.

On other devices - such as the media device beneath and md array - you can
set the read-ahead to anything or nothing and it will have no effect at all.

NeilBrown

>=20
>=20
> Those disks are SATA - but I'm also planning to add in some SSDs and
> RAID1 them with md - they will hold things like source code and home
> directories (to make compiling and NFS home directories faster).  Can
> anyone comment on the read ahead config or any other aspect of such a pla=
n?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/SvxDonyfJtpSNwc2xFe7WMg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT67W+Dnsnt1WYoG5AQJxSg//cFPhbmSBP6ZX12z1+qVHFSzujHdTgXD3
xKBvz8MwtbynU55ofMtDa254g/qq2EdzvfqUmPB3QRQf6XnJ54Bh+eZ3pKywMTgZ
gSOL2osZRP40E4bxVYkFNlACzzoLveNxzDqJpnkbCJl6S4crs1ilXEu/ZcF6JsEW
vXHUpGTtBRa15WaK7v85AD2wQflRLbl6gDwY1sJzOLwe1r4yhdqsevZ+b7p5baUJ
mzykBMBsT1xcWSWnFzCxe0Tsc4s80vUOoegmPtXEXXiVHPd1YIQijepmcmR5vm+9
Vdjdr87pPuqIyTe0tDDqbqT0P8lF9/yeNUnE9Yb0ySv8dlbp9tSJqsp43OKrPuHS
4i5QslE4+g4hAyY6jVOzSthFf8vPYP3JzrQ6R6PzDgnbeiBocBIavXIHrcDvISYB
g9dIDvW+7NA3oo0L1gStbUD92ffKd5vIdsM+PUTxKHxX7BHAuS9Agjesn3OkwTlf
4wfpR8n0jT2f6RObw+wPWpPVAHhrM9IHrSg/HIqda1Kgyle6cG+O4rUyLlB2hHFN
cWRuLhGqkgrzbXpgnrsjo/b0a22trvSJJuAzfLJo+662XReMig8pqavTrHu5fpvI
Olk/mty/PSvm3PKeshaYp+InF+1dODGfXeU1bbo+UiFvw99vTKC79Qweh6lXtdJ8
68hK4ULTuQk=
=p+fz
-----END PGP SIGNATURE-----

--Sig_/SvxDonyfJtpSNwc2xFe7WMg--
