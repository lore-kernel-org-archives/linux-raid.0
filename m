From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: a question about how to repair raid5
Date: Mon, 26 Nov 2012 12:50:55 +0000
Message-ID: <20121126125055.GA29049@cthulhu.home.robinhill.me.uk>
References: <201211262032343900581@meganovo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201211262032343900581@meganovo.com>
Sender: linux-raid-owner@vger.kernel.org
To: hanguozhong <hanguozhong@meganovo.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Nov 26, 2012 at 08:32:38 +0800, hanguozhong wrote:

> Hi, every one:
> I have a question about how to repair raid5.
> Days ago, I received a email from the monitor of mdadm.=20
> The email told me that there were lots of mismatch_cnt in the array.=20
> Then I tried to find the solution of this problem on Google. Most solutio=
ns were as the following:
>=20
> #echo repair /sys/block/md0/md/sync_action
> #echo "check" > /sys/block/md0/md/sync_action
> #cat /sys/block/md0/md/mismatch_cnt
>=20
> I did repair the array like the above.=20
> But I found that it took lots of time to "repair" and "check" the array.=
=20
> Why there was a "check" after "repair"I did not know. And it spent as muc=
h time as "repair".
> Is it redundant? Anyone can help me?

That's the correct process, yes. The "check" will verify whether the
parity block for each stripe is correct, whereas the "repair" will also
rewrite any parity blocks which don't match. You rerun the "check" after
the "repair" to ensure that everything has been repaired correctly (if
there's still mismatches then it would point towards a problem with your
setup somewhere). Both are doing a full read of all disks, so will take
about the same time (the number of additional writes that the "repair"
needs to do should not impact on the time significantly).

HTH,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCzZa4ACgkQShxCyD40xBJ4xQCgwxFh5LuFoZCz0eP7IX90E+Je
vJ4AoK0ofVVZxR3n89Wjkknz7Cbpb/mp
=UD8z
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
