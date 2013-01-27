From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Sun, 27 Jan 2013 20:05:57 +0000
Message-ID: <20130127200557.GA10960@cthulhu.home.robinhill.me.uk>
References: <20130127192656.634892005AD@gemini.denx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130127192656.634892005AD@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Jan 27, 2013 at 08:26:56 +0100, Wolfgang Denk wrote:

> I have seen "mismatch_cnt is not 0" warnings in the past, but that has
> always been with RAID 1 arrays, and with relatively small numbers on
> /sys/block/md*/md/mismatch_cnt; my understanding was that this was not
> actually critical.
>=20
> However, after updating to Fedora 18, I get this message from all
> updated
> systems that have RAID 6 arrays, and with _huge_ numbers of
> mismatch_cnt, like that:
>=20
<-snip->
> # cat /sys/block/md0/md/mismatch_cnt
> 362732152
>=20
Is this after having run a check, or just after boot? I've seen some odd
numbers at times, but they've gone away after running a check
(presumably something not being initialised).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEFiKQACgkQShxCyD40xBK20gCdFUQFtTG/OmBg0V665JNBgH7G
F+0AnAw71PUcWsy+QqsoN2lA+VL7NbQJ
=KpmR
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
