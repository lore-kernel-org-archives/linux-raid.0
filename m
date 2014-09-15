From: NeilBrown <neilb@suse.de>
Subject: Re: Status of discard support in MD RAID
Date: Mon, 15 Sep 2014 13:50:50 +1000
Message-ID: <20140915135050.0f0634c3@notabene.brown>
References: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com>
	<26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com>
	<5412B6D7.1060400@hesbynett.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WTE.VLO.AEfqzEL2W5_BsO8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5412B6D7.1060400@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Chris Murphy <lists@colorremedies.com>, Brassow Jonathan <jbrassow@redhat.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/WTE.VLO.AEfqzEL2W5_BsO8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Sep 2014 11:03:19 +0200 David Brown <david.brown@hesbynett.no>
wrote:

> On 12/09/14 02:46, Chris Murphy wrote:
> >=20
> > On Sep 11, 2014, at 5:38 PM, Brassow Jonathan <jbrassow@redhat.com>
> > wrote:
> >=20
> >> Neil (or anyone else),
> >>=20
> >> I know that trim/discard support was added back in 2012 (commit
> >> 9db90880).  However, I thought there were still issues regarding
> >> what happens when various sync operations occur.  I'd like to turn
> >> on discard support in dm-raid.c (a oneline patch) if things are in
> >> order.  I can enable any, all or none depending on your
> >> recommendation.  (I assume RAID1/10 is easier than the parity
> >> RAIDs.)
> >=20
> > If all the controller and drive support it then it should pass
> > through, but there's the problem whether the SSD supports
> > deterministic trim. If it doesn't, a check check > md/sync_action
> > will report mismatches in md/mismatch_cnt; and a repair will probably
> > corrupt the volume. So you can still use trim with a drive that
> > returns non-deterministic results with raid0/1/10, but you can't rely
> > on the result of md/mismatch_cnt and you can't do repair type
> > scrubs.
> >=20
> > For raid5/6, it's a problem to use trim if the drive returns
> > non-deterministically for trimmed blocks. I'd think that in addition
> > to DRAT being supported, it'd need to support DZAT.
> >=20
> > smartctl --identify=3Dwb /dev/diskX | grep -i trim
> >=20
> >=20
> > Chris Murphy
> >=20
>=20
> Would it be possible to change trim/discard commands into write zero
> blocks for some SSDs?=20

There is a BLKZEROOUT ioctl which writes zeros, using the 'WRITE SAME' SCSI
command if possible.

I suspect it would be quite easy to modify "fstrim" to use BLKZEROOUT
instead of BLKDISCARD.

NeilBrown


>  A number of SSD controllers support transparent
> compression, so writing large batches of zeros will result in very small
> writes to the actual flash, and the SSD controller will be able to
> recycle flash used by the overwritten logical blocks just as if they
> were trimmed.  Obviously writing zeros will take longer in transfer than
> trim commands, but the result on the disk would be similar and it would
> be guaranteed deterministic.
>=20
> David
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/WTE.VLO.AEfqzEL2W5_BsO8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBZiGjnsnt1WYoG5AQIGaQ//Ub5zBrDdoqZEU5wUiQaJkdmD+yDDzC0f
kLOqvUQ0AvRVkioJt1yEiQpnPaxohu3IF8UaUZ2Mn91VyWvDn9Hn02MUAo4GVY25
GoZEjgpe891+es4gb28o+AK/B+WnF/QcO1o5JprW7Ma63hcVKEZze/RlSfpSkKX3
Qh0GdKxzL76nR+PfLtq9Iav4kCSVtjkQha5kMTG+xSUVfztIO37OH8ZBWZpN5wSQ
8rRCXOelD8o4tw7KrG+wvUQhURnHIiWQ1tdZG+psHGcKwSA7XuZRXsd7ljcgp8zo
xaoVE45trjsA1TlYrTC+pHY+V049FU913BzrpN+48M+Jgad3/XhuJb4s8YR/iW+Z
JRg8N93Q7gvpfzrf/kG6OwUU99Q3MGBQb5IExZdtf7+6en8cFdihi+ICJ47OPaVt
uiKA2+BTlkzR5k6JCMf5Eov2qchsvCSj59MPY0oeYiAotETcUA7GeZ2ryQlOwwu0
onR/NSTMNyh0se8H2DI3Ab4+UQcbyOTe355TvYxfFJnqjpmPqnThoKTXbzLOLq7M
EN9QpqtHK5UaGM4s/j6VzvrM4pzrkREi/+FPNQBiKTLRCK7s3uT8L4tm6AFMEeKy
BggVd1tmJzB5tY6xLdXZkq3WtYPm1JupLTTnQOsWG/6QO8UYgdq7OL6Jx3IMY8rT
rB12wORoXtE=
=txOI
-----END PGP SIGNATURE-----

--Sig_/WTE.VLO.AEfqzEL2W5_BsO8--
