From: NeilBrown <neilb@suse.de>
Subject: Re: Hot-replace for RAID5
Date: Tue, 15 May 2012 22:13:13 +1000
Message-ID: <20120515221313.7610372d@notabene.brown>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<CAAOsTSmi17VF2B5-4PJ9GNfxD-EQaY7LbL_8hwr1FvBoBj1VvA@mail.gmail.com>
	<4FACBCCC.4060802@hesbynett.no>
	<CAAOsTSmwcXPhHqQ3QyS0_8ijXaC3E4bGtWJn1wrwRFeUpxu8tQ@mail.gmail.com>
	<CAAOsTSmS6uFFe1e1y+39fxHOEFWZEsM7thcPwoeV6FTNiPkM_Q@mail.gmail.com>
	<20120513091901.5265507f@notabene.brown>
	<CAAOsTSk7dDcMGGJgAJ6GSDU2WpsJPTS3Vb80WKy6CObwtemfgQ@mail.gmail.com>
	<CAAOsTSkVwCkY3YAKPTDFo2uZoG6S6Et0DYtDzk+QNfy+N3kMag@mail.gmail.com>
	<20120514081523.2f38dbb8@notabene.brown>
	<CAAOsTSm3aQFydumTfAVr2DQZoxcENvzpfyS8zbNdxUcnFsDkpQ@mail.gmail.com>
	<CAAOsTSkTXy0zP0OBBOPg7+=nc0Acshz2jrsB8fTF55VNeUEHxg@mail.gmail.com>
	<20120515204322.4ee77ea4@notabene.brown>
	<CAAOsTSmMrs2bHDbFrND4-iaxwrTA0WySd_AVaK+KXZ-XZsysag@mail.gmail.com>
	<20120515212820.14db2fd2@notabene.brown>
	<CAAOsTSm3XFRbRpfatRi5tVdO1Jz_pHqb3RS6b7UyVNdDSnk8Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FQj70nWCsGkJWvwy4UuwEH7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSm3XFRbRpfatRi5tVdO1Jz_pHqb3RS6b7UyVNdDSnk8Fw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FQj70nWCsGkJWvwy4UuwEH7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 15 May 2012 13:56:58 +0200 Patrik Horn=EDk <patrik@dsl.sk> wrote:

> Anyway increasing it to 5K did not help and drives don't seem to be
> fully utilized.
>=20
> Does the reshape work something like this:
> - Read about X =3D (50M / N - 1 / stripe size) stripes from drives and
> write them to the backup-file
> - Reshape X stripes one by another sequentially
> - Reshaping stripe by reading chunks from all drives, calculate Q,
> writing all chunks back and doing I/O for next stripe only after
> finishing previous one?
>=20
> So after increasing stripe_cache_size the cache should hold stripes
> after backing them and so reshaping should not need to read them from
> drives again?
>=20
> Cant the slow speed be caused by some synchronization issues? How are
> the stripes read for writing them to backup-file? Is it done one by
> one, so I/Os for next stripe are issued only after having read the
> previous stripe completely? Are they issued in maximum parallel way
> possible?

There is as much parallelism as I could manage.
The backup file is divided into 2 sections.
Write to one,  then the other, then invalidate the first and write to it et=
c.
So while one half is being written, the data in the other half is being
reshaped in the array.
Also the stripe reads are scheduled asynchronously and as soon as a stripe =
is
fully available, the Q is calculated and they are scheduled for write.

The slowness is due to continually having to seek back a little way to over
write what has just be read, and also having to update the metadata each ti=
me
to record where we are up to.

NeilBrown


>=20
> Patrik
>=20
>=20
> On Tue, May 15, 2012 at 1:28 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 15 May 2012 13:16:42 +0200 Patrik Horn=EDk <patrik@dsl.sk> wrot=
e:
> >
> >> Can I increase it during reshape by echo N >
> >> /sys/block/mdX/md/stripe_cache_size?
> >
> > Yes.
> >
> >
> >>
> >> How is the size determined? I have only 1027 while having 8 GB system =
memory...
> >
> > Not very well.
> >
> > It is set to 256, or the minimum size needed to allow the reshape to pr=
oceed
> > (which means about 4 chunks worth). =A0I should probably add some auto-=
sizing
> > but that sort of stuff is hard :-(
> >
> > NeilBrown
> >


--Sig_/FQj70nWCsGkJWvwy4UuwEH7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7JIWTnsnt1WYoG5AQJgUg/+P1932ZQkBtCFQnSR+PmBr8QQfBNUSXh7
7Z3HKxo70G9zPMrOSzWbS+64H452nQX7qPXEOYuJxOFAwQRoaAb9egdEV9T1aC9E
6wgci4k2k7odUYR+Y+F2G7ktDb5PmE401WvYSvwA5V9inIH3PRzHHDi4g1qaZqm+
3cYHcXf3Tm2HssoKLOI/glRTIRVy/vQdaOY8tOijtXnibROZycM00Fr4oH184Hv7
66mEMKZvRVBJfEO66AJKV3GKugHzC6n/X0mERGthRuQaFA09WlryXjUAyvPIIHqm
93gYiwJj6hbLV8w7yXXZX+772slfwufTBCGMWNuSFUmnnayaq86eH1H2IFLaIqJ1
IlLDbbT9SHbm6l14gAAe/gbDnm66KqrjJAdh9yf1iS5P0gMLrm3PgAI1k3brMOFU
eKDZRtPVSup1CPpTFWROH75MkXzAN8URE35UGnL3EMohCFrFBnoiQ10X3CzbCx4m
8D6MN6ovjss/o9pk8e7h7hQmvVcYV4hJCE7M+iogmKqCqbqgQa7iY+YrIFHa35qc
NG533YZE3HNnwjLylX2MnsaKnSQfls5yxTxqNqMGKhCrAlO69zYD1nljpTfVo8l5
eukrPE2mT6N/PpRJ9g2oPbxvP2RtIWFqETqsA8vbbCuTHloz3zkb7kQ6kuZyV96y
N6KC0zmZAuw=
=czBg
-----END PGP SIGNATURE-----

--Sig_/FQj70nWCsGkJWvwy4UuwEH7--
