From: NeilBrown <neilb@suse.de>
Subject: Re: Raid10 multi core scaling
Date: Mon, 2 Dec 2013 17:22:07 +1100
Message-ID: <20131202172207.7400e03a@notabene.brown>
References: <20131126105859.Horde.-ppIIPYRo99SlH7zGogGx_A@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1sFYHpflWeQJF__FWLReAI/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131126105859.Horde.-ppIIPYRo99SlH7zGogGx_A@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1sFYHpflWeQJF__FWLReAI/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Nov 2013 10:58:59 +0000 Pedro Teixeira <finas@aeiou.pt> wrote:

> =C2=A0=C2=A0 I created a Raid10 array with 16 sata 1TB disks and the array
> performance
> seems to be limited by the md0_raid10 taking 99% of one core and not
> scalling to other cores. I tried overclocing the cpu cores and this lead =
to
> a small increase in performance ( but md0_raid10 keeps eating 99% of one
> core ).

Are you really talking about general array performance, or just resync
performance?

Because md0_raid10 doesn't do much work for normal IO so that should scale =
to
multiple processors.
I'm not sure that optimising resync to use more than one processor is really
much of a priority - is it?

NeilBrown


>=20
> =C2=A0 =C2=A0I'm using:
> =C2=A0 =C2=A0=C2=A0- a phenom X6 at 3600mhz
> =C2=A0 =C2=A0=C2=A0- 16 seagate SSHDs ( sata3 7200RPM with 8GB ssd cache )
> =C2=A0 =C2=A0=C2=A0- 4x marvell 9230 sata3 controllers ( 4 ports each ) p=
cie 2.0 2x
> lanes.
> =C2=A0 =C2=A0=C2=A0- 8GB ram
> =C2=A0 =C2=A0=C2=A0- custom 3.12 kernel and mdadm compiled from latest so=
urce
>=20
> =C2=A0 =C2=A0what I did to test performance was to force a check on the a=
rray, and
> this
> leads to mdadm reporting a speed of about 990000K/sec. The hard disks
> report a 54% utilization. ( Overclocking the cpu by 200mhz increases the
> resync speed a bit and the hdd's utilizartion to about 58% )
>=20
> =C2=A0 =C2=A0If I do the same with a raid5 array instead of raid10, them =
resync
> speed
> will be almost double of raid10, the harddisk utilization reported will be
> 98-100% and I can see at least two cores being used.
>=20
> _________________________________________________________________________=
_______
> Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
> http://www.aeiou.pt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/1sFYHpflWeQJF__FWLReAI/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpwnDznsnt1WYoG5AQKJ0hAAspPTraAvhGhygW0rqQExzPq2oeTIPMHa
7vXvfIFeLFvmY2w/tX5o8zCayrTWBLFxYFyX7Kl4IeEAQB/vYhKxQqZJTiNhSeA+
2ZxPaoMgrUSuhXUKpAq0nahZhdbeJwmvkl45ogsf3YwsaDdapF1W6REL47z8l3Rz
QCpeGAuUTSVLz9cOvqSF2Nw8Svi1I2ZvwmQrHqSAJQDZznkUXazMdjKT4ibysreM
Txyd4qKPip/Nm8e47VkBdKetwnf0VniCRGCqo5JG7kmSl+e8A9hBgpM7IZnI14WB
Y6QyzvJil2i2PQ49LO0ebNnIp9Sd5dT8pV5xiUbJIe4tXJGSVfnGuJkJATqezdNr
f1jWP62TSXt/hlpODJ6Srz155zUdvfMc50K2IRTuq88MaQVN0CbytiQnMUsEPqCq
GUUa76K78Q7TbxqQmTlRI4bdYhlk3CHZHEwrlxkS885uPK++0pyooLdqEZOmV0Ug
RFnceqgT6g/z1wekMLko9SbneSrEbJx+Uyb3MOiIrWxF6TTxBoD2w5MQJIynyTOY
OcifOcU9ssle89nTTQGT0FMgx5enPceRIrMVqSEkmFfOxMgoqT8i45LLD6KxuDig
dETOe/gUzcSam5LvAKESlNxbBwMNXkRNgj2r9qQ451ooaN+bTyJH0RZmnFt94HBS
tVgNY8QJ9XA=
=o2i7
-----END PGP SIGNATURE-----

--Sig_/1sFYHpflWeQJF__FWLReAI/--
