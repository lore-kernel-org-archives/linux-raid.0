From: Chris Zimmerman <czimmer@mclaneco.com>
Subject: Re: Perhaps this has been answered before...
Date: 21 Aug 2002 13:07:22 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1029953242.31114.76.camel@zimmerman>
References: <Pine.OSF.4.30.0208212024340.15250-100000@soul.helsinki.fi>
	<3D63D0BD.50005@hum.auc.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-QMHT7L1Az9bt0MpQ6l4S"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D63D0BD.50005@hum.auc.dk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-QMHT7L1Az9bt0MpQ6l4S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

So where can I get the appropriate kernel patches for 2.4 and will I
have to update raidtools?=20

Thanks,=20
Chris Zimmerman=20


On Wed, 2002-08-21 at 12:41, Mads Peter Bach wrote:
    Mikael Johansson wrote:
   =20
    >=20
    > On 21 Aug 2002, Chris Zimmerman wrote:
    >=20
    >=20
    >>/dev/md0       swap        swap        defaults   0   0
    >>
    >=20
    >>raiddev /dev/md0
    >>        raid-level              1
    >>
    >=20
    > Having your swap space as RAID-1 is redundant indeed :-) You will be
    > better off changing it to RAID-0.
   =20
   =20
    Only if you don't care what happens when a disk crashes. With RAID-1,=20
    you'll be able to survive, with RAID-0 your system will crash, when it=20
    can't access the swap partition.
   =20
    =20
    > I however do not see why this should freeze your machine.
   =20
   =20
    Me neither. Swap on RAID-1 works fine for me (though on 2.4).
   =20
    Regards,
    Mads
   =20
    -
    To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
    the body of a message to majordomo@vger.kernel.org
    More majordomo info at  http://vger.kernel.org/majordomo-info.html
   =20
   =20
   =20

--=-QMHT7L1Az9bt0MpQ6l4S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA9Y9ba9u4GRRZAJ2YRAtwLAKDLjlFE+zBqRjwFc8LT2IpK+rdZUgCbBZSy
QQznwdBb6qz55rNXbeZ/7rc=
=Lz7p
-----END PGP SIGNATURE-----

--=-QMHT7L1Az9bt0MpQ6l4S--
