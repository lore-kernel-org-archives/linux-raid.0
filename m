From: martin f krafft <madduck@madduck.net>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 18:21:45 +1300
Message-ID: <20100218052145.GA7178@lapse.rw.madduck.net>
References: <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100218102407.49f73d67@notabene.brown>
 <20100218025809.GA20358@khazad-dum.debian.net>
 <20100218032610.GB1991@lapse.rw.madduck.net>
 <1266465801.11568.183.camel@localhost.localdomain>
 <20100218044004.GC5136@lapse.rw.madduck.net>
 <20100218161012.704b43a6@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100218161012.704b43a6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2010.02.18.1810 +1300]:
> You would put it in /etc/mdadm.conf
> The format would be something like:
>=20
>   ARRAY /dev/md/root uuid=3Dxxxx:xxxx:xxxx:xxxx
>=20
> and any array found with that uuid would be assembled as /dev/md/root

No, we mean using the UUID of the root filesystem (vol_id, not
mdadm's UUID) as the homehost identifier, instead of the hostname.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"never speak disrespectfully of society.
 only people who can't get into it do that."
                                                        -- oscar wilde
=20
spamtraps: madduck.bogus@madduck.net

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkt8zmkACgkQIgvIgzMMSnWB0gCfVbPnN7SJ+SiSXBMDn8C5UV8b
BXYAoNnDCisjhSDatqUIFkzLhSz8s7ak
=HFyO
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
