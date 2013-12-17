From: NeilBrown <neilb@suse.de>
Subject: Re: Chunk size change stop/restart
Date: Wed, 18 Dec 2013 09:32:10 +1100
Message-ID: <20131218093210.46a208a2@notabene.brown>
References: <20131217190019.GA1883@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xvf97GenlKEK9Me9y.PG+ZM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131217190019.GA1883@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/xvf97GenlKEK9Me9y.PG+ZM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Dec 2013 20:00:19 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi all,
>=20
> I started the process of changing the chunk
> size of a RAID-5 array (5 HDDs).
>=20
> Unfortunately, I unwisely choose a quite slow
> device for the backup file.
>=20
> Is it possible, without stopping the array, to
> stop the "reshape", move the backup file to a
> faster place and restart the process?

You might be able to kill the mdadm which over-sees the reshape, move the
file, then use --grow --continue to continue the reshape.
But I've never tested this and suspect that something would go wrong.

Stopping, moving, and re-assembling should work.

Being patient also works,  but can be very difficult.

NeilBrown

--Sig_/xvf97GenlKEK9Me9y.PG+ZM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUrDQ6jnsnt1WYoG5AQIb2w/+KpG5ki5iQfQR9PLzbaRGrk3TSvIY7lbZ
TuRIknu/6VTOhN3rJUTgziuy0uK/1mOC1SA14eS7SQuxuURXMrB0qJ7CIWLyWgnq
hCP8ZnNKkok2B2EQBllBhwx6WAB4RCso3PTEZPlQsXzjEH5cHeTSMDOJee+Ly3xs
8K8fnU7Hdld0MSIuC6ag4iGpDhyCSPU5xt96xvnV4mAHlhBRBSPK4Fa1R7rnRwR8
gBonizuRNShjjsPXhuM0RuUQLGISxEJqPQeL9FrXVFJEK3tsM27HdV2HPdXvC7lP
6hRIbqlJT0FeL43CmrFvxq/L643ZTcYzEqrTTEKf2nr2fn1I7w9+DFAoJSdMCsMY
F3/EYwwF/hct8McubtpyY24BiZJMVqEiful9ESeIe/tmEes8JKa3wlUj63g1EIt2
93HkN/iDc7mnms0i4iKyeMcib4w05d0zEgV9cVwaXG3jkfsgggv+j9RQLL5buiCk
qy5/FPRM1HCBMy6sEklTw/vMhDTO3LhNKGHlqTrmFKFWEPi1PTtL9qpWRLFV5SBi
fPMlB0JhHzW15r+fm58iO1ILb/iHt/SIJfMBM+f7q5RmwT8Hmtk0KusHi+MozVAz
1iyks5yYqZRjb7DyV73qENQu+j0uhWV7GZB4ANsjME1qVlZfjctlz/cRP5hcaeYi
l7cn+lUu0Xc=
=C2T3
-----END PGP SIGNATURE-----

--Sig_/xvf97GenlKEK9Me9y.PG+ZM--
