From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 03:41:08 +0600
Message-ID: <20100611034108.6a2cdbc4@natsu>
References: <4C1128C2.4020105@meetinghouse.net>
	<20100611005743.43664e5b@natsu>
	<4C11578B.8010202@meetinghouse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4ELId/txoWIMsXWC9tFOX5K"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C11578B.8010202@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4ELId/txoWIMsXWC9tFOX5K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Jun 2010 17:22:19 -0400
Miles Fidelman <mfidelman@meetinghouse.net> wrote:

> > Do you currently have a write intent bitmap in the array? I think it can
> > reduce the need for recovery by an order of magnitude in some cases. Ch=
eck
> > man mdadm for --bitmap if you don't use it yet.
> >   =20
> Just went through the process of turning it on for all my arrays. =20
> Incredibly painless and quick.  Now I get to wait and see if it helps=20
> the next time I have a crash/reboot event.

I assume you went with "internal" bitmap, in which case if you notice that
write speed on the arrays became significantly lower, the first thing you
should look at is increasing the --bitmap-chunk size (I use 131072).

It is possible to use an external bitmap on an independent device (which has
almost zero performance impact), but in this case it could be non-trivial to
100% ensure that such a device is mounted and accessible at the moment duri=
ng
boot-up when md arrays are being started, especially if one of those arrays
also hosts the root FS.

--=20
With respect,
Roman

--Sig_/4ELId/txoWIMsXWC9tFOX5K
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwRW/QACgkQTLKSvz+PZwhNoQCgi216EQj+fVxAan3AIzWUsDiI
uBwAn3n4maWHXudpnKS3hNAWE8Z39pR7
=B/k4
-----END PGP SIGNATURE-----

--Sig_/4ELId/txoWIMsXWC9tFOX5K--
