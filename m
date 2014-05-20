From: NeilBrown <neilb@suse.de>
Subject: Re: System freeze triggered by RAID 10 resync and high io
Date: Wed, 21 May 2014 09:26:08 +1000
Message-ID: <20140521092608.7775d4e3@notabene.brown>
References: <e4069b67814807d1782d8658cfb6f922@posteo.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jVmqpJk6ZyOVJaa=g0GHU.A"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e4069b67814807d1782d8658cfb6f922@posteo.de>
Sender: linux-raid-owner@vger.kernel.org
To: christian.schwarz@posteo.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jVmqpJk6ZyOVJaa=g0GHU.A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 May 2014 23:24:36 +0200 christian.schwarz@posteo.de wrote:

> Hello,
>=20
> I have an issue with stalling writes that within a few seconds=20
> ultimately lead to a full system freeze. Since all writes fail once the=20
> condition has been triggered, there is no log output. Also dmesg remains=
=20
> without errors.
>=20
> My setup is as follows:
>=20
> md127 : active raid10 sda1[0] sdd1[3] sdc1[2] sdb1[1]
>        3907023872 blocks super 1.2 512K chunks 2 near-copies [4/4]=20
> [UUUU]
>=20
> Linux 3.14.2-hardened-r1 #4 SMP PREEMPT

Fixed by upstream commit

commit cc13b1d1500656a20e41960668f3392dda9fa6e2
Author: NeilBrown <neilb@suse.de>
Date:   Mon May 5 13:34:37 2014 +1000

    md/raid10: call wait_barrier() for each request submitted.


which will be in 3.15, and hopefully will appear in the next 3.14.y release
(it isn't in 3.14.4).

NeilBrown


>=20
> Dell Poweredge T20 Server
>=20
>=20
> To trigger this condition, a resync of the array has to be running and=20
> high disk IO needs to be performed in addition. The condition is=20
> triggered regardless of the resync speed (tested with 1, 10 and 100=20
> MB/s). I also tried different io schedulers and a non-preempt kernel.
>=20
>=20
> Someone else over at Fedora reported a similiar problem:=20
> http://www.spinics.net/linux/fedora/fedora-kernel/msg05163.html
>=20
>=20
> How can I help with providing additional information so you can locate=20
> the problem?
>=20
>=20
> Thanks,
>=20
> Christian
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/jVmqpJk6ZyOVJaa=g0GHU.A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3vkkDnsnt1WYoG5AQKV5A//UBMqhUyMDgtLiJxPOSOGDFz9yB4DDb8/
t6zvC03o6wa79rht130IZwJhlpgSTcLmtKg06VnE0zvS/S3t0o1kJmAMxXhVEA7P
XGtEbxspSBjiAM/kxcG4Ni5xahV+9jHhbkqMlBUQMURBq94Vob2ud+D0gRpKdfDW
iwWrzIgyKZQuJEguT8c5tYYdRhT9Z7fJ5sjlJuASC+Hz4bOq82JKVK+nvj9yoJkm
Fe45Oud6kxFdNrrzbJzCLXA8qpEmRaaVW1SKMQbpORXxJqr5rG9vnu8OO8K11+w4
/QtRguFAXEDZ0LrQS/p5ja0IS72IP0XclXCCr6XSNCp2diRkwRSA62MpTdrgl7jo
yeOHtAzQn4Nxl3gwChlxhuXc5o+pQ1lzotN8OunVsjof6iThVo84wcfHsAPGki1U
JKBPx7ruSLQWDY7xXL1klGZML4SjS0rg/wkMbi0QjDzg9ZDqItxDLp66WwRYQN1f
ozaFvFAKv1j+YfseVS+gbyDvunXLeQtjQz+nBqt/n5/okiy3XKaut6t0KEt00JPr
KC0F8l7hKK7o3kiPbfuGRjPr94QbCbQijl9sWqUWhKuSpUJc+yhhGkZb8lkgNiTT
/G11irjwUWFqHzQhkch4G2M/GAGqK9f5+1ZOESHzK1XvSHOOojqngYRDrm60JkpG
npJv2HzITdk=
=FaJG
-----END PGP SIGNATURE-----

--Sig_/jVmqpJk6ZyOVJaa=g0GHU.A--
