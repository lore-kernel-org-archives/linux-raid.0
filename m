From: Ronny Adsetts <ronny.adsetts@amazinginternet.com>
Subject: Re: RAID mirror, resyncing from bad disk
Date: Mon, 14 Sep 2009 10:00:48 +0100
Message-ID: <4AAE0640.2060007@amazinginternet.com>
References: <4AAD45AE.6060503@amazinginternet.com> <4AAD5510.2060505@anonymous.org.uk> <70ed7c3e0909131549y196c06c9m7d91f73bf5adeac2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5438F7E642A549679C3FC071"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909131549y196c06c9m7d91f73bf5adeac2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Linux RAID ML <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5438F7E642A549679C3FC071
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Majed B. said at 13/09/2009 23:49:
> If your data is backed up, doing everything from scratch is your best
> bet, and I'll tell you why you shouldn't try to patch up your current
> situation:

I know this is the best way forward, however finding time to do this is h=
arder. Obviously, if push comes to shove, I'll have to do it. Just trying=
 to avoid it.

> 1) Have you written a single byte to the array(s) when the first disk
> was thrown out of the array?
> If yes, then adding it again will be equal to adding a new hard disk.
> If no, then why was it trying to resync? I think it's already flagged
> dirty but you've got 99.2% worth of data...

The good disk was kicked because of a configuration error. There have bee=
n writes since then (on the /var partition) hence the required resync.

> 2) Your disk that is currently running the RAID1 array has bad sectors.=

> If you try to clone that, you'll fail to clone all sectors, which
> means loss of data.

Understood.

> 3) Ignoring bad sectors means you'll end up with corrupt Physical
> Volumes under the LVM (Since your arrays are Physical Volumes of the
> LVM). This will also cause problems with the filesystem.

The bad sector is in an unallocated part of the PV - there are no LVs on =
it. Thankfully the bad sector is right at the end of the disk.

> I would suggest buying TWO new disks and reinstall everything and
> restore your backup(s) then data. It's better than spending numerous
> hours trying to find out why a service isn't working, then after days
> you realize that some binaries are corrupt or the config files.

I can checksum all the binaries and compare to a known good system and th=
e config files are all backed up. I've rebooted recently and it all works=
 now with the bad sector present, so I'm not concerned about this since i=
t seems unlikely to happen.

> The reason I say TWO new disks, is that you already have one disk with
> bad sectors, and the other popped out of the array for a reason. Do
> not add the 2nd disk until you're truly sure there's nothing wrong
> with it (run smartd and execute short and long tests, try to read the
> whole disk a few times using dd: dd if=3D/dev/sdc of=3D/de/null bs=3D10=
M).
>=20
> If you see link errors in the kernel/dmesg, change your SATA cables.

I've run SMART tests on the good disk and it appears fine. I'll do a dd o=
f the whole disk to verify before I reuse it.

Ronny
--=20
Ronny Adsetts
Technical Director
Amazing Internet Ltd, London
t: +44 20 8607 9535
f: +44 20 8607 9536
w: www.amazinginternet.com

Registered office: UK House, 82 Heath Road, Twickenham TW1 4BW
Registered in England. Company No. 4042957=20



--------------enig5438F7E642A549679C3FC071
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkquBkgACgkQ/j4uMRUAlJ+e2gCdEAQwkJ0N7dtBcCFvZhHyS42K
ABoAoPG6k4uZiRYdF3kKOjSPuPbUt7/B
=Pre4
-----END PGP SIGNATURE-----

--------------enig5438F7E642A549679C3FC071--
