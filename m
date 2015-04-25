From: NeilBrown <neilb@suse.de>
Subject: Re: Massive RAID-1 desync
Date: Sat, 25 Apr 2015 17:25:27 +1000
Message-ID: <20150425172527.21a34428@notabene.brown>
References: <1919189912.18202330.1429908372364.JavaMail.zimbra@laposte.net>
	<1810942606.18204832.1429908469113.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/fv9TqDI/1STiPJK=R+f0sz1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1810942606.18204832.1429908469113.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: cau2jeaf1honoq@laposte.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fv9TqDI/1STiPJK=R+f0sz1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 22:47:49 +0200 (CEST) cau2jeaf1honoq@laposte.net wrote:

> Something is happening here. I don't know what, but I'm having
> fun trying to guess.
>=20
> The root file system (ext3) is on a 4 x 30 GB RAID-1 array. A
> couple hours after boot, the kernel detected something wrong in
> the file system and decided to remount it read-only.
>=20
> Comparing the component partitions finds many differences with a
> very uneven distribution :
>=20
> - sda1 and sdb1 are identical except for 4 bytes in the last
>   70 kB,

Perfectly normal.  Metadata is at the end, at least 64K from the end and 64K
aligned.

>=20
> - sdd1 is identical to sda1 and sdb1 except for about 67,000
>   differences in the last 70 kB.

Following the metadata is between 60K and 124K of nothing.  It could easily
be completely different on different devices.


>=20
> - sdc1 is grossly out of sync with about 300 million differences
>   with the others, all of them in the first 450 MB or so.

sdc1 is sick.
Maybe it has hardware problems.  Maybe some hacker broke into your machine
and wrote garbage to it.  Or maybe you triggered a bug that no one else has
ever come across (unlikely, but possible).

>=20
> I'm not sure what to make of this. The knee-jerk thought would
> be "/dev/sdc1 is the odd man out so sdc must be faulty". But
> that disk participates in other arrays without problems, I don't
> see anything obviously bad in its SMART data and the kernel
> messages just before the remount were actually about sda.

And what were those messages about sda?

>=20
> To be honest, I don't have a clear idea of how things got where=20
> they are. Since writing to a RAID-1 array writes the same data
> to all devices, how can you have so many differences ?

Cosmic rays?  EMP?

I actually think that the most likely explanation is that someone was
careless and wrote something to sdc that they didn't mean to.  But I'm
probably wrong.  I like guessing too.

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/fv9TqDI/1STiPJK=R+f0sz1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTtBbjnsnt1WYoG5AQKC6A/+Kh4y5/G5ggfO2CHqEDaLl3QJn+PoLK0w
pdzyZdnqPVGxRdwAEXzTrih4saijBQO3BL7VCoNGz6Z137n+F9Egfe6rW4HO8fI4
mxLXOkKN1ut4K7Vsof+O9JLN43UtZKz4rVF2dbzPBfm8fRdGl4HFC+hy639AxiRn
6AeLsfK58XGIGCwsIwXwViKh6My3RkG/uL8bZH/eBo58WNmICGfJ7RCOO9Sq60ft
zioa54sE2UoyhDiKf60S6VlPUOTp9X5Ouo6vpRBI88HWJRR5/WtbWXWzSWwnG47P
xHRCxpgvlKjMGkywq61JtawDQuOV54GCwrE2MmWMg9oht5D9qVrouc+QtbYr6ZOp
870LuWIyddjmdnf2v6DbYOuGZFoS50Viw3kG24j0NYcB1BEoJWSkF4AqOFrlyL1g
B1Pu00W3GDFBGzBZgaq5qNvXI0OKH+scBRAqfhbf/giT1DyPbOxHcj1hBTpMFOqh
Pxj7dGPbnfFolWLgfNKCJUtPAOkTMkbheConr8wo8gsrfbPOxRvEA1mWD8UUU3Gl
r4fpgBoMcEBDYsbnKXq2tofDP4hqPDBDTOOICAFVRZmbTXIuxmPYTrQdi+DrXWf9
4OZk2OW57e4n9V+BIar6NH//qal0hf2hh+xjR0WM0k8qldU0YcAA04m5oNP/9n85
V8gImNbUTIM=
=C1sw
-----END PGP SIGNATURE-----

--Sig_/fv9TqDI/1STiPJK=R+f0sz1--
