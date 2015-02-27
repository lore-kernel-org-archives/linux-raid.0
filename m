From: NeilBrown <neilb@suse.de>
Subject: Re: raid0: "clean" state on drive failure/removal
Date: Sat, 28 Feb 2015 08:56:25 +1100
Message-ID: <20150228085625.7377171a@notabene.brown>
References: <B9FF37F8E2D7894A9493A5314D0816FC242755A9@SACMBXIP01.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wRw9wSarWNX2ZNr838y_juk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B9FF37F8E2D7894A9493A5314D0816FC242755A9@SACMBXIP01.sdcorp.global.sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sushma Gurram <Sushma.Gurram@sandisk.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/wRw9wSarWNX2ZNr838y_juk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Feb 2015 20:54:32 +0000 Sushma Gurram <Sushma.Gurram@sandisk.com>
wrote:

> Hi,
>=20
> A basic question on raid0 behavior.
>=20
> When a drive fails/removed in a raid0 array, =E2=80=9Cmdadm =E2=80=93deta=
il=E2=80=9D reports the array
> state as clean instead of failed.
>=20
> It appears that the drive is whacked out of the array, but that array slot
> continues to show =E2=80=9Cactive sync=E2=80=9D state.
>=20
> I/O to the failed drive errors out. However, it appears that I/O to other=
 drives
> in the raid0 array would succeed. How would the user know about the array=
 state
> and potential data loss? Should the array information be cached, drive
> failure/removals be monitored and checked against the cached information?

The user would know about potential data loss in *exactly* they same way as
if half the sectors on a single hard-drive stopped working.

i.e. the filesystem would complain.

>=20
> Could anyone please explain the reason for this behavior of not reporting=
 a
> raid0 array as failed?

RAID0 is not really RAID - there is no redundancy.
So it isn't treated like RAID.

RAID0 is simply a mapping off linear addresses onto multiple devices.
There is no sense in which the array as a whole "fails", or any value in
marking a device as "failed".

If there is something wrong, then IO requests will fail.  Not necessarily a=
ll
IO requests, but some.  Just like a normal drive that has partially failed.

NeilBrown

>=20
> Thanks,
> Sushma
>=20
> ________________________________
>=20
> PLEASE NOTE: The information contained in this electronic mail message is=
 intended only for the use of the designated recipient(s) named above. If t=
he reader of this message is not the intended recipient, you are hereby not=
ified that you have received this message in error and that any review, dis=
semination, distribution, or copying of this message is strictly prohibited=
. If you have received this communication in error, please notify the sende=
r by telephone or e-mail (as shown above) immediately and destroy any and a=
ll copies of this message in your possession (whether hard copies or electr=
onically stored copies).
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/wRw9wSarWNX2ZNr838y_juk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPDoCTnsnt1WYoG5AQIVrRAAltOYL8WCqSug6qoiYZegTdxW2jwjVYXR
cBn0KyBW1NqlKbbxwQpqlX9jsfwvPkAyAg6dHGy1AfM7tXcqWBaBjSHlBzR5XbfY
HNN2pTvrEz8YBQ7R963A0j6y/JoXO2NPe6J9FiQ7gLca10VPuA8XXCCRAgRU+QJg
zaRYWGWfV4IWvb0B7UeZ78HTgwC4pyhgOWqmawQS31OpalZ+4lMjmp/cXg1/ONDY
Uar7BuJm3/wkY80F5TnVgj1WsE59tccaBPdvW1ultlx97NR93fq+XnWY2SalJY+k
KRq4c4bXv7ydzcjq1gm+ht35Rp8I6OS+j/aYyjHodldL0qNeVzX/BlqrS+KlRutO
vnodJZtmHodGMHb4LF32vgyQHs+KuL1pVGzThKnMlGoh7Cn8stV5qhyMJouBEUWv
rMJE/679Di8JLVm1kAR+fBhBpAY7pJ2mDxL/1MozKHoZawSc0buapobYedrYaD1E
AiuGvHD7NSiR+syhRttRSlVo4YjtLbK1sX57Ry3kTd+uXKi7CZfejgdrVhuOcTHq
w/0IXwe1VAM3draj2DYl26qd9yA7BhqGTP0gfuH17epAdyGUiP6rLQP52KF5Crpl
3uecxovU7McpIGprkazOHrHW0xKNehzkUq47AYZsK8I4zUCBSwkM348JJ5M5bQqL
DGqrAc9gNbI=
=l1Z/
-----END PGP SIGNATURE-----

--Sig_/wRw9wSarWNX2ZNr838y_juk--
