From: Andre Noll <maan@systemlinux.org>
Subject: Re: 16 HDDs too much for RAID6?
Date: Fri, 7 Mar 2008 11:33:27 +0100
Message-ID: <20080307103327.GB29734@skl-net.de>
References: <20080306100128.8daad6bd.taeuber@bbaw.de> <20080306094559.GA29734@skl-net.de> <20080306115559.63ac361d.taeuber@bbaw.de> <20080306161621.GD32242@skl-net.de> <20080307084146.GA9653@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080307084146.GA9653@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:41, Luca Berra wrote:
> >I think this is what is confusing mdadm. Your "DEVICE partitions"
> >line instructs mdadm to consider all devices in /proc/partitions,
> >so it finds both sdy and sdi.
> in this case i believe the error message would be different

Well, the code that causes the warning Lars is seeing is

	if (best[i] >=3D0 &&
	    devices[best[i]].i.events
	    =3D=3D devices[devcnt].i.events
	    && (devices[best[i]].i.disk.minor
		!=3D devices[devcnt].i.disk.minor)
	    && st->ss->major =3D=3D 0
	    && info.array.level !=3D -4) {
		/* two different devices with identical superblock.
		 * Could be a mis-detection caused by overlapping
		 * partitions.  fail-safe.
		 */
		fprintf(stderr, Name ": WARNING %s and %s appear"
			" to have very similar superblocks.\n"
			"      If they are really different, "
			"please --zero the superblock on one\n"
			"      If they are the same or overlap,"
			" please remove one from %s.\n",
			devices[best[i]].devname, devname,
			inargv ? "the list" :
			   "the\n      DEVICE list in mdadm.conf"
			);
		if (must_close) close(mdfd);
		return 1;
	}

IMHO this can be triggered by having two devices nodes (sdy and sdi,
whatever) that correspond to the same physical device, no?

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH0Rn3Wto1QDEAkw8RAqXkAJ44pyc4o5lxjoXtNM+R3NAKcxTZowCglDGk
M9vYK+l7DHnH7zIGoU+yU5o=
=cxxW
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
