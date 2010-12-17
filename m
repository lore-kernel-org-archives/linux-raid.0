From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: integrity verification on raid-5?
Date: Fri, 17 Dec 2010 21:24:37 +0000
Message-ID: <20101217212436.GA11425@cthulhu.home.robinhill.me.uk>
References: <4D0BD140.6040205@feystorm.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D0BD140.6040205@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Dec 17, 2010 at 02:08:16PM -0700, Patrick H. wrote:

> Is there a way to do integrity verification on a raid-5 array? I'm=20
> working on building a storage system on SSDs under raid-5 and want to be=
=20
> able to perform periodic integrity checks. Basically just check the=20
> drives to make sure that they match what the parity drive has.
> After a bit of googling I saw other people wanting the same thing but=20
> nobody with any result. I dont see why this cant be done, but is there=20
> any tool to do so?

There's built-in functionality to do this.  To start the check, run:
    echo check > /sys/block/mdX/md/sync_action

You can check progress by catting /proc/mdstat, and the number of errors
is reported at the end in /sys/block/mdX/md/mismatch_cnt.  To rewrite
the parity data for any mismatches, use "repair" instead of "check" in
the first command.

Currently, there's no easy way to find out what file(s) are affected by
the mismatches though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk0L1RQACgkQShxCyD40xBJZWgCfVzZ/esa3YFE7oyS1WYGqaaWG
K/sAoLlD+/wMZf0A9dEXpbc+xyLDSZhf
=AhFt
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
