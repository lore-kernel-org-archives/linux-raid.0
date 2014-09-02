From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 data corruption during resync
Date: Wed, 3 Sep 2014 09:55:07 +1000
Message-ID: <20140903095507.032e8c6d@notabene.brown>
References: <20A5228D-DD63-4A6C-B2C6-B0C38996E636@gmail.com>
	<EAC50175-42D9-43BA-ADE2-1A50BD0581CB@redhat.com>
	<18B7DF88-26D1-44B8-8F72-2159A2DF868D@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/iORKGBerWYSXZVBd6uu=Xak"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18B7DF88-26D1-44B8-8F72-2159A2DF868D@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>
Cc: Brassow Jonathan <jbrassow@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iORKGBerWYSXZVBd6uu=Xak
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Sep 2014 15:07:26 -0700 Eivind Sarto <eivindsarto@gmail.com> wrot=
e:

>=20
> On Sep 2, 2014, at 12:24 PM, Brassow Jonathan <jbrassow@redhat.com> wrote:
>=20
> >=20
> > On Aug 29, 2014, at 2:29 PM, Eivind Sarto wrote:
> >=20
> >> I am seeing occasional data corruption during raid1 resync.
> >> Reviewing the raid1 code, I suspect that commit 79ef3a8aa1cb1523cc231c=
9a90a278333c21f761 introduced a bug.
> >> Prior to this commit raise_barrier() used to wait for conf->nr_pending=
 to become zero.  It no longer does this.
> >> It is not easy to reproduce the corruption, so I wanted to ask about t=
he following potential fix while I am still testing it.
> >> Once I validate that the fix indeed works, I will post a proper patch.
> >> Do you have any feedback?
> >>=20
> >> =E2=80=94 drivers/md/raid1.c	2014-08-22 15:19:15.000000000 -0700
> >> +++ /tmp/raid1.c	2014-08-29 12:07:51.000000000 -0700
> >> @@ -851,7 +851,7 @@ static void raise_barrier(struct r1conf=20
> >> 	 *    handling.
> >> 	 */
> >> 	wait_event_lock_irq(conf->wait_barrier,
> >> -			    !conf->array_frozen &&
> >> +			    !conf->array_frozen && !conf->nr_pending &&
> >> 			    conf->barrier < RESYNC_DEPTH &&
> >> 			    (conf->start_next_window >=3D
> >> 			     conf->next_resync + RESYNC_SECTORS),
> >=20
> > This patch does not work - at least, it doesn't fix the issues I'm seei=
ng.  My system hangs (in various places, like the resync thread) after comm=
it 79ef3a8.  When testing this patch, I also added some code to dm-raid.c t=
o allow me to print-out some of the variables when I encounter a problem.  =
After applying this patch and printing the variables, I see:
> > Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: start_next_window =
=3D 12288
> > Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: current_window_reque=
sts =3D -46
> > 5257
> > Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: next_window_requests=
 =3D -11562
> > Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: nr_pending =3D 0
> > Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: nr_waiting =3D 0
> > Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: nr_queued  =3D 0
> > Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: barrier =3D 1
> > Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: array_frozen =3D 0
> >=20
> > Some of those values look pretty bizarre to me and suggest the accounti=
ng is pretty messed up.
> >=20
> > brassow
> >=20
>=20
> After reviewing commit 79ef3a8aa1cb1523cc231c9a90a278333c21f761 I notice =
that wait_barrier() will now only exclude writes.  User reads are not exclu=
ded even if the fall within the resync window.
> The old implementation used to exclude both reads and writes while resync=
-IO is active.
> Could this be a cause of data corruption?
>=20

Could be.
=46rom read_balance:

	if (conf->mddev->recovery_cp < MaxSector &&
	    (this_sector + sectors >=3D conf->next_resync))
		choose_first =3D 1;
	else
		choose_first =3D 0;

This used to be safe because a read immediately before next_resync would wa=
it
until all resync requests completed.  But now that read requests don't block
it isn't safe.
Probably best to make this:

    choose_first =3D (conf->mddev->recovery_cp < this_sector + sectors);

Can you test that?

Thanks,
NeilBrown

--Sig_/iORKGBerWYSXZVBd6uu=Xak
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVAZY2znsnt1WYoG5AQL/YA/+JRa1+eQwHMI/+jj4s+3hnlOzDSA1I8w7
CvGNrNEhJMCUnNZkZMUuVk0cHljdhvkkvW4c13jo09fEoGRkW+0HHlmo8qKGl1VI
EmVPZHePmBYNz6BKXHAo1wXvIHVhH4XNLMkiTMRF9mpJYZ36IiMvh8aClYnJrHTx
hlc2J8q7N1/WUOGFaaFI8yy4TSv14Mi1Tj+NfNGHOy4LgrfPiXqQc0Bzhdq/uNec
wugpcvhvWFEhVrAyN1Rrr7XwWdPsGJfZgkwK5Tdsj/p0AzKXbOAmiSU0B/qQu5mo
qfzqrecFO7PfUR2RSmMJIZxjOhcmCQ35PjdypWE5f72ZWmGbZtijullvaYnghuuy
n1SA24vX+pu0GdCBCUEDQfPy3gi9l3WtcyCHUeV+af5PTfPog9gi2E+mve0WeYv4
GfiwzmzpTxwgTast/KGASxOePH2w25YuecYc0dlLw8UjzUb+71RNHtSP2PiQY0nq
Ry021X7MOcyH+J35Xbds6V68rIHBIaqGAR2HRv/H3wgeTAhc7L0xeQ66XfzodkZx
klYRKCxrROLNykt83C3N5MLFz4DwA5ObvMwweSQVC5Lo8Nn6Tbt7qLmsqfCr0Iu8
8BM8W9xEZybDBWTrDuoXuFgwihDmZbsKT01hYd7FINOW+gyLfir7L4WrSvKCpnnc
dIb1ulAR5Hk=
=Vzw6
-----END PGP SIGNATURE-----

--Sig_/iORKGBerWYSXZVBd6uu=Xak--
