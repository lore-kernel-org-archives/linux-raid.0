From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: Manually fail a disk?
Date: Sun, 19 Jan 2003 16:08:59 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030119210859.GB18651@rdlg.net>
References: <20030119132953.GA18651@rdlg.net> <20030119144321.D9B7E3B808@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030119144321.D9B7E3B808@jaded.cynicism.com>
To: Derek Vadala <derek@cynicism.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



raidsetsetfaulty gave back an error (scrolled off the screen and the
machine has since seized up.  raidhotremove pretty much hung up trying
to get disk access.  I was hoping I could tell the kernel or the md
driver to mark it bad and take it out of the array.


Thus spake Derek Vadala (derek@cynicism.com):

> >   I've got a disk that's starting to fail hard.  It's generating alot of
> > errors in dmesg and /var/log/messages.  If the raid disk gets any usage
> > it'll lock up the box it's spewing errors so fast.  I can't get out to
> > physically yank the disk until Tues but need it off-lined now.  Is there
> > a way to tell mdtools (version 0.42-33) to mark a disk faulty and not
> > use it?
>=20
> I'll assume this is a RAID-1 or RAID-5 and that you're not trying this on
> a non-redundant array...
>=20
>=20
> # mdadm /dev/md0 --fail /dev/sda1
> # mdadm /dev/md0 --remove /dev/sda1
>=20
> The first command fails /dev/sda1 (a member of /dev/md0) and the second
> command removes it from /dev/md0.
>=20
> If you are using raidtools try:
>=20
> # raidsetfaulty /dev/md0 /dev/sda1
> # raidhotremove /dev/md0 /dev/sda1
>=20
> --
> Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: FC96D405
                              =20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.
FYI:
 perl -e 'print $i=3Dpack(c5,(41*2),sqrt(7056),(unpack(c,H)-2),oct(115),10)=
;'


--U+BazGySraz5kW0T
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+KxPrPvY/pfyW1AURAlg1AJ9H0tbVPYpH7XdwO6NLBclo+mFUDwCeI/Xb
R1AwhZX5S/i7p7k3V8ew5t8=
=WW6c
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
