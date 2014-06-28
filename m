From: NeilBrown <neilb@suse.de>
Subject: Re: Understanding raid array status: Active vs Clean
Date: Sat, 28 Jun 2014 15:29:39 +1000
Message-ID: <20140628152939.367e4b2d@notabene.brown>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
	<20140529151658.3bfc97e5@notabene.brown>
	<1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
	<20140529160623.5b9e37e5@notabene.brown>
	<CAG__1a5j-0O7LOb6opz4MLPCjbxRNDXiaG6W=Xxt3JJ9eXfRRA@mail.gmail.com>
	<CAG__1a5XK1yt70ox_12hLjpBpY=YRcaJ6-MYHiEJ_RTpxFujoA@mail.gmail.com>
	<20140618150326.GA28569@cthulhu.home.robinhill.me.uk>
	<CAG__1a7m2BakDGUtP==YunzmBr8WDXVVv4i2WE=sYhBNKYjM1w@mail.gmail.com>
	<CAG__1a7zGbxzkR_a2ci4rw3xacxGYt07aBiAsFjGPYowXBPCcQ@mail.gmail.com>
	<CAG__1a4kX1gM+ntmcLkevCm6kwVbgSMGmPi-ec6+b1RGKznouw@mail.gmail.com>
	<20140623120102.7d85ac52@notabene.brown>
	<CAG__1a7T2atsQ1eQMhR1Wp6xd72fNdyf5XX+kbihRbY1Urd0Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U2y3X.sEaJH44c+d=c3FBOy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a7T2atsQ1eQMhR1Wp6xd72fNdyf5XX+kbihRbY1Urd0Ww@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/U2y3X.sEaJH44c+d=c3FBOy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Jun 2014 05:01:00 +0200 George Duffield
<forumscollective@gmail.com> wrote:

> >> > changing the value to 0.500:
> >> > # echo 0.503 > /sys/block/md0/md/safe_mode_delay
> >> >
> >> > makes no difference to the array state.
> >
> > What if you write a smaller number?  e.g. 0.1
>=20
> No change to array state.
>=20
> > What does /sys/block/md0/md/array_state show?
>=20
> Funnily enough, it shows Clean


Ahh - I found it.
In get_array_info() in drivers/md/md.c:

	if (mddev->in_sync)
		info.state =3D (1<<MD_SB_CLEAN);
	if (mddev->bitmap && mddev->bitmap_info.offset)
		info.state =3D (1<<MD_SB_BITMAP_PRESENT);


that last line should be "|=3D".

Because you have a bitmap, the 'clean' state is being hidden.

Though if you have a bitmap, the 'clean' state isn't really important becau=
se
the bitmap knows which regions are 'clean' and which are not.

But it should be fixed.  I'll send a patch next week.

Thanks for persisting.

NeilBrown

--Sig_/U2y3X.sEaJH44c+d=c3FBOy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU65Swznsnt1WYoG5AQLY9xAAjXteE1BSeL7RUZNOcaVCMVvXIMJ7rj+l
x1/Htc7Rz/VCZb5dFIIONZOp00rqgzyfF4rD4xb+I0vZ8poeiULRdreexpxSfna1
7bLrCWfGsdgCF6LI1ngeTXiz4T/016CdE6MFZmukbNzh2JOP7CGxBQuLsPhlXY/p
78e3s5icet3Ijs2OiTiLL8VLHA2s4KKcIhYnm4AgBwQLHd9Kdkav8AKjSDgFzh9p
oOqS0k8eCQljI7OmBDKvmdHzrOlZ9sxicXqjM5RvkyFspgDyUCgXDO1j/VR6CJ6e
D0fe8Tr4WJqZFi4RCdXAEgEh4XziN3jnDaKS/nxgxhCQiFcdmr020hyyyOLQJ+nJ
8Zgws12/Q1MbvfflKMovKfBYO3H9aViVoXqS/SZ1zOsGReHwjS41du074W7ZnGUN
xBJys+MfDcfScFQdpYd3WSCSjAAZ7Oi0GoAEG/C+fjKX5mmL/TzuzHVhRqQEYxSR
9qoJTQ8kevGJp1dJqi/p9+LDsqHBAB34m7oTKTQZWE9QK3vKUuOq9zVCl85VBOzN
qs29/hPqsROCFpnjrt0GosHHiqw2yLl0IcnyrSxxL34rwUpZdOix8cRa0ZJtnfL/
V1RTZGqBABnFXLe5s6jfyVXALCM3cCmXh6LXEUAWltQgby1hKOVims/vHtadPoYD
zegTUob6YvA=
=njh2
-----END PGP SIGNATURE-----

--Sig_/U2y3X.sEaJH44c+d=c3FBOy--
