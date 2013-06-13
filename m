From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-10 keeps aborting
Date: Thu, 13 Jun 2013 13:10:51 +1000
Message-ID: <20130613131051.25d5730d@notabene.brown>
References: <51AC1440.7020505@zytor.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com>
	<yq1y5art543.fsf@sermon.lab.mkp.net>
	<CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com>
	<yq1d2s1rcb7.fsf@sermon.lab.mkp.net>
	<51AE2A8C.4080508@zytor.com>
	<yq18v2prbum.fsf@sermon.lab.mkp.net>
	<CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com>
	<51AE3441.3000208@zytor.com>
	<CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com>
	<51AEA4FE.3060900@zytor.com>
	<yq1mwr4pd9f.fsf@sermon.lab.mkp.net>
	<20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com>
	<yq1bo7ioe6e.fsf@sermon.lab.mkp.net>
	<20130610101505.33b32d07@jlaw-desktop.mno.stratus.com>
	<20130612131543.1c79e077@notabene.brown>
	<51B7F41F.9000605@zytor.com>
	<yq17ghzjti4.fsf@sermon.lab.mkp.net>
	<51B885B8.9040600@zytor.com>
	<yq1txl3iejr.fsf@sermon.lab.mkp.net>
	<51B8897C.8000801@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w9HzK82LzoOEWBU4=ntz=ZD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B8897C.8000801@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Lawrence <joe.lawrence@stratus.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/w9HzK82LzoOEWBU4=ntz=ZD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Jun 2013 07:45:16 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/12/2013 07:34 AM, Martin K. Petersen wrote:
> >>>>>> "hpa" =3D=3D H Peter Anvin <hpa@zytor.com> writes:
> >=20
> > hpa> The second question is if we should disable WRITE SAME for raid1/10
> > hpa> (what about raid0?) for 3.10/stable or if your patch really is
> > hpa> sufficient... "just adds another heuristic" makes me nervous.
> >=20
> > I think we should disable 1+10 in stable until we get the recovery
> > scenario sorted out.
> >=20
> > I don't believe there are any problems with raid0.
> >=20
>=20
> How does this look?
>=20
> 	-hpa
>=20

Promising - thanks.

However should we do the same thing in raid5.c too?
As far as I can tell, the default set by blk_set_stacking_limits() (which md
calls) is to allow WRITE_SAME if all all underlying devices do.
But I'm pretty sure raid5 will do the wrong thing with a WRITE_SAME request.

??

Thanks,
NeilBrown

--Sig_/w9HzK82LzoOEWBU4=ntz=ZD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUbk4Oznsnt1WYoG5AQJ1FRAAuf5+tpwXMDMW0DXSF2pOc9shi5w5bOH4
PdxyKDN4FKw56O3FSGRfnsTLuP1EN9yQFkKBbAvuaW1nO5g9zdl1d0Dr21Soq3al
DMp/ort3Mi57hQHD3a/CdN5X5NX//+o6s8AR+6aSs4/oaAHxKFHzstW4FL9uxU2M
EFXGMBkN5+9gqjvMNOu1tUCTIAO0LbJBh9b+sbWKONvoqE9VldC0EPK2zFmLtaUM
XXxTZcLMvXMpFFNqDkiT9AYzrhqj1QqWmPzezT7hD0eZE9OKrF0qvXEWqEuUqWC7
P+LmXPRnNeQ0J4gEpZWlXT+qeGGE/ZQ/5enz6/qNFCp/8y5B9RIDJ42Lu4ZpSizk
Nbnl05Uw2APWVb/8QuJLryOiKXBgYIhjX9aL+Z7BW9IKSQz0bwA2Q52ACRxw10W9
wYlnvdVaE8qI/5uFrAwAovv3qmWfyj+46N5PAh7kl9ib0RXd7cZ2rUnmGGGeVMmI
KexydSy77OjiM5WRszxvv50FVpu9QRKNcCwboeeM9gmGRtJhJiHXd9KDUH7fPk/T
zqrNVMxm63ZeefDlBWAqqzD+VM/GuWu1i/tAibsKRDmCMzHjti5WUen4wYymHD1C
4b06mEYmXEVLHs2LAePBjI68sTaMJwrUhE+6FhI27TRnfcwGyUrbCzbXdot9U1hX
wB1qk5hoOvE=
=xnQK
-----END PGP SIGNATURE-----

--Sig_/w9HzK82LzoOEWBU4=ntz=ZD--
