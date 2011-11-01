From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 1 Nov 2011 21:20:23 +0000
Message-ID: <20111101212023.GA20565@cthulhu.home.robinhill.me.uk>
References: <4EAF3F78.5060900@meetinghouse.net>
 <j8odkj$46h$1@dough.gmane.org>
 <4EAFEE95.6070608@meetinghouse.net>
 <4EAFF636.6060904@anonymous.org.uk>
 <j8p0g3$9r4$1@dough.gmane.org>
 <4EB052E6.4050400@meetinghouse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EB052E6.4050400@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Nov 01, 2011 at 04:13:26 -0400, Miles Fidelman wrote:

> David Brown wrote:
> >
> > No, md RAID10 does /not/ offer more redundancy than RAID1.  You are=20
> > right that md RAID10 offers more than RAID1 (or traditional RAID0 over=
=20
> > RAID1 sets) - but it is a convenience and performance benefit, not a=20
> > redundancy benefit.  In particular, it lets you build RAID10 from any=
=20
> > number of disks, not just two.  And it lets you stripe over all disks,=
=20
> > improving performance for some loads (though not /all/ loads - if you=
=20
> > have lots of concurrent small reads, you may be faster using plain=20
> > RAID1).
>=20
> wasn't suggesting that it does - just that it does things differently=20
> than normal raid 1+0 - for example, by doing mirroring and striping as a=
=20
> unitary operation, it works across odd number of drives - it also (I=20
> think) allows for more than 2 copies of a block (not completely clear=20
> how many copies of a block would be made if you specified a 16 drive=20
> array) - sort of what I'm wondering here
>=20
By default it'll make 2 copies, regardless how many devices are in the
array. You can specify how many copies you want though, so -n3 will give
you a near configuration with 3 copies, -n4 for four copies, etc.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk6wYpYACgkQShxCyD40xBJ/OQCbBpcALzZx+KpPwxvIEu0HrR9z
MKMAoJNU4X3XkcDnpnohzvL05fSFekGZ
=ficE
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
