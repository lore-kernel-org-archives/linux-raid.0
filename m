From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-10 keeps aborting
Date: Thu, 13 Jun 2013 13:31:44 +1000
Message-ID: <20130613133144.6bfb8ab1@notabene.brown>
References: <51AC1440.7020505@zytor.com>
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
	<20130613131051.25d5730d@notaben!
 e.brown>
	<51B938CF.5070303@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UcW2NpGEa2yRZKmW0+a=rmu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B938CF.5070303@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Lawrence <joe.lawrence@stratus.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/UcW2NpGEa2yRZKmW0+a=rmu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Jun 2013 20:13:19 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/12/2013 08:10 PM, NeilBrown wrote:
> >=20
> > Promising - thanks.
> >=20
> > However should we do the same thing in raid5.c too? As far as I can
> > tell, the default set by blk_set_stacking_limits() (which md calls)
> > is to allow WRITE_SAME if all all underlying devices do. But I'm
> > pretty sure raid5 will do the wrong thing with a WRITE_SAME
> > request.
> >=20
>=20
> Yes, if raid5 also bounces the array if the WRITE SAME request fails
> at the device we need to do the same thing there.
>=20
> 	-hpa
>=20

Thanks. I've modified the patch and tagged it for -stable.

NeilBrown

--Sig_/UcW2NpGEa2yRZKmW0+a=rmu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUbk9IDnsnt1WYoG5AQJVTg/+PEParPyH94Io3D0ToxlbdIwRGVqwaBA7
kiLMEfPnUN5ToFnNENBUAQbVwBfuNqQ+CWEsTdGqdHBxHx9mUD9zCMILh+L20YaH
i5svsQ5ajI2IZDQ02mWnmpC8J+QTjgRs/nnyXAW833B3Ui2EVN/4ycDtcASQCYYf
7gLKCnQTil8x3NZxzX3tNjMHW6HOEV3ntiwpB7uJYvbnAVp1OCdlllnI2/E2RFge
wY1uoxxTvXsL4mq1bbcAOsyn/iakABDhr5fQMbpBcnI5XLBvFMdS6zS8kWn4H5Dl
u2++H5hxdRTpu9yROrjYfSZ09aF3sD5oGR7zPlrEdU5ZHLFRIA+ewmB19Mm9Ekhz
GvWQPZP/B8hzcK2CQ1FFz1LAxlTovunjTuA4rBaQj11F1ZtxR2VEW/LZGKNOu0Lh
/muhobV8+T2Ijs9b/MjLY3CDl1blc3tYIrwLjW42kTT5H8vYK8s1g5kWP9bCm7C6
8rCQv0+vECm2gi5raWceMemLqO6hUtG8mD0f+c1D0UeTroHGeerAYNSH4YxQJLAa
TWcOCGSVW8eflPQ+K1iz/eoGdJR7cw7FI/hU4pJoqbnl6rPiNf57coobU5MjQ9wm
bSpYDA2v7XtxbssxXrtafbUygOr+tlWHgS9KRI9n+TdHl1M+0Vk2fswjvEpyJJbS
M6pSVIogmGQ=
=N90Q
-----END PGP SIGNATURE-----

--Sig_/UcW2NpGEa2yRZKmW0+a=rmu--
