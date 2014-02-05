From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid6check.c: reduce verbosity
Date: Thu, 6 Feb 2014 09:30:12 +1100
Message-ID: <20140206093012.69fa4332@notabene.brown>
References: <20140201160334.GA9378@lazy.lzy>
	<20140204161025.579257b1@notabene.brown>
	<20140205191845.GA11653@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qWXDGGph9ggvYMdKHP/qLX6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140205191845.GA11653@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qWXDGGph9ggvYMdKHP/qLX6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Feb 2014 20:18:45 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> On Tue, Feb 04, 2014 at 04:10:25PM +1100, NeilBrown wrote:
> > On Sat, 1 Feb 2014 17:03:34 +0100 Piergiorgio Sartor
> > <piergiorgio.sartor@nexgo.de> wrote:
> >=20
> > > This patch removes some printouts, which
> > > are not really useful here.
> > > These could be re-added later, in case a
> > > verbosity parameter will be provided.
> > >=20
> > > Signed off: piergiorgio.sartor@nexgo.de
> > >=20
> > > diff -uNrp a/raid6check.c b/raid6check.c
> > > --- a/raid6check.c	2014-01-23 19:36:23.151837870 +0100
> > > +++ b/raid6check.c	2014-02-01 16:56:14.123771170 +0100
> > > @@ -188,8 +188,6 @@ int check_stripes(struct mdinfo *info, i
> > >  	while (length > 0) {
> > >  		int disk[chunk_size >> CHECK_PAGE_BITS];
> > > =20
> > > -		printf("pos --> %llu\n", start);
> > > -
> > >  		err =3D lock_stripe(info, start, chunk_size, data_disks, sig);
> > >  		if(err !=3D 0) {
> > >  			if (err !=3D 2)
> > > @@ -221,7 +219,6 @@ int check_stripes(struct mdinfo *info, i
> > >  			int disk =3D geo_map(i, start, raid_disks, level, layout);
> > >  			blocks[i] =3D stripes[disk];
> > >  			block_index_for_slot[disk] =3D i;
> > > -			printf("%d->%d\n", i, disk);
> > >  		}
> > > =20
> > >  		qsyndrome(p, q, (uint8_t**)blocks, data_disks, chunk_size);
> > >=20
> > >=20
> >=20
> > This and other 3 all applied - thanks.
> >=20
> > NeilBrown
>=20
> Hi Neil,
>=20
> thanks for the update.
>=20
> It seems the patch removing the commented code
> (the one you complained about), was not added.
>=20
> Below the patch again.
>=20
> Thanks,
>=20
> bye,
>=20
> --- --- --- --- ---
>=20
> This patch will remove some legacy code.
> It is part of the verbosity "cleanup".
> In any case, if information about the P
> and Q parity mismatches is required, it
> should go inside the code handling page
> size blocks, not full stripe size.
>=20
> Signed off: piergiorgio.sartor@nexgo.de
> diff -uNrp a/raid6check.c b/raid6check.c
> --- a/raid6check.c      2014-01-20 19:48:10.435721613 +0100
> +++ b/raid6check.c      2014-01-23 19:36:23.151837870 +0100
> @@ -231,15 +231,7 @@ int check_stripes(struct mdinfo *info, i
>                 block_index_for_slot[diskP] =3D data_disks;
>                 blocks[data_disks+1] =3D stripes[diskQ];
>                 block_index_for_slot[diskQ] =3D data_disks+1;
> -/* Do we really need the code below? */
> -#if 0
> -               if (memcmp(p, stripes[diskP], chunk_size) !=3D 0) {
> -                       printf("P(%d) wrong at %llu\n", diskP, start);
> -               }
> -               if (memcmp(q, stripes[diskQ], chunk_size) !=3D 0) {
> -                       printf("Q(%d) wrong at %llu\n", diskQ, start);
> -               }
> -#endif
> +
>                 raid6_collect(chunk_size, p, q, stripes[diskP], stripes[d=
iskQ], results);
>                 raid6_stats(disk, results, raid_disks, chunk_size);
>=20
>=20
>=20
>=20

Thanks for the reminder.  This one is now applied.

NeilBrown

--Sig_/qWXDGGph9ggvYMdKHP/qLX6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUvK7dDnsnt1WYoG5AQJnrA//cefYaxWjH/9HXSwoZQE4PAFAcOj1DO02
OUimCZ5YriNEAw1LkZsh97c8lpP/OXj/Ees9WFOjuAIoKYlfbqKfUGNFpgHy0izO
YrawQXEMz4/of9jmrMClq97UeNJzH2TU+C20VpSOR4864C7vFAuLZEtjJHVL+dYv
q/faF0fVpRUGN3hhWGYoNaTOn+SLtb5uVa5FGPTAUcpNYU6n1U13k8Hl2PaS9FGu
qY6Hs3ux7qEq7MhVMB9JjMv4P4GfD7kMJttXf4RyEPqMdhEVcCilNfHw69o4D7eV
URb8reHX5AOD+6t75u+M1+VPkXTe6P6GZmfEasl3IjFXvs2Km/fdubEFxcDJRRsm
7h2Ao4opvtMAUZnd0tyx/xgQawoV8/SUsVSPpDcPprYGOcwZte0eB9Fljq0a1e78
NV2eBnTqiUwxCXsOsmNR0owHMknEgu5FboR7Dnep/H8mxttVofO3v4H/MMCOD46N
DZV4H7GDvE6xtVHalz9YxgkPMPMnzr23x8VZKNbNrXK/GM13aKaV4M2QQy0IHlJv
MKIzhf+MuLSm9P5Ee8XV2cQ6f3HPfC9e5Hq8tpH68lTcUhF/ejNB767/RPxcyjSh
0VmZ6qN0ulNTD23dpUWfaiocSKLpmGvvk7UD0FdLErwTnPxBBeBg7m5U/TJPVakV
+M8RffWbbKA=
=VGAI
-----END PGP SIGNATURE-----

--Sig_/qWXDGGph9ggvYMdKHP/qLX6--
