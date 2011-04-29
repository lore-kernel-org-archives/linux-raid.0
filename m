From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Fri, 29 Apr 2011 05:39:40 +0100
Message-ID: <1304051980.3105.46.camel@localhost>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-8RJ44Dw6X/aTR+iFO+z9"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jameson Graef Rollins <jrollins@finestructure.net>
Cc: 624343@bugs.debian.org, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-8RJ44Dw6X/aTR+iFO+z9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-04-27 at 09:19 -0700, Jameson Graef Rollins wrote:
> Package: linux-2.6
> Version: 2.6.38-3
> Severity: normal
>=20
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>=20
> As you can see from the kern.log snippet below, I am seeing frequent
> messages reporting "bio too big device md0 (248 > 240)".
>=20
> I run what I imagine is a fairly unusual disk setup on my laptop,
> consisting of:
>=20
>   ssd -> raid1 -> dm-crypt -> lvm -> ext4
>=20
> I use the raid1 as a backup.  The raid1 operates normally in degraded
> mode.  For backups I then hot-add a usb hdd, let the raid1 sync, and
> then fail/remove the external hdd.=20

Well, this is not expected to work.  Possibly the hot-addition of a disk
with different bio restrictions should be rejected.  But I'm not sure,
because it is safe to do that if there is no mounted filesystem or
stacking device on top of the RAID.

I would recommend using filesystem-level backup (e.g. dirvish or
backuppc).  Aside from this bug, if the SSD fails during a RAID resync
you will be left with an inconsistent and therefore useless 'backup'.

> I started noticing these messages after my last sync.  I have not
> rebooted since.
>=20
> I found a bug report on the launchpad that describes an almost
> identical situation:
>=20
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/320638
>=20
> The reporter seemed to be concerned that their may be data loss
> happening.  I have not yet noticed any, but of course I'm terrified
> that it's happening and I just haven't found it yet.  Unfortunately
> the bug was closed with a "Won't Fix" without any resolution.
>=20
> Is this a kernel bug, or is there something I can do to remedy the
> situation?  I haven't tried to reboot yet to see if the messages stop.
> I'm obviously most worried about data loss.  Please advise!

The block layer correctly returns an error after logging this message.
If it's due to a read operation, the error should be propagated up to
the application that tried to read.  If it's due to a write operation, I
would expect the error to result in the RAID becoming desynchronised.
In some cases it might be propagated to the application that tried to
write.

If the error is somehow discarded then there *is* a kernel bug with the
risk of data loss.

> I am starting to suspect that these messages are in face associated with
> data loss on my system.  I have witnessed these messages occur during
> write operations to the disk, and I have also started to see some
> strange behavior on my system.  dhclient started acting weird after
> these messages appeared (not holding on to leases) and I started to
> notice database exceptions in my mail client.
>
> Interestingly, the messages seem to have gone away after reboot.  I will
> watch closely to see if they return after my next raid1 sync.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-8RJ44Dw6X/aTR+iFO+z9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATbpBBOe/yOyVhhEJAQqDOQ/7BkbbBX9OpHznrRjBFtkC1pFsNTOd+Uwf
xNEL6BHG0wXomwzYAY0KiPe+/zMeQW3YNBwv+rVZDdyJfFd6xzqgNRnzxN13jdu2
Oh51qr11ePFwy4QfDX9F4hv2aHO0OdOgtHUOnpltOqqBMTDW163n/+e9p0ZgOKDG
FCUhryIp7xGdMdoJZ0v9HOBf1/U08p3e1o90N449QCIlI5ATCXQqnVeJxIe4F8W9
4+42rnTQkFHcbr1U4b65+Fk/GzJ/cjR0G1DibFUa1Ud6K0AsRgRKjuf3WLVIQ0cm
YVSatduODV+6qSTUNWKoG4+ftyimSf7mwL1GFZVpnHfYpQG8xrXq745bRSYe9tfb
SS5Gu40JCBGkXOFGUinzerSBf9p73vA4pb/nqwkPg7tvKT9+QhxojMOxoWaKjf/n
4sWMe/eNeVH7vIbr9l/D28ZiHURD0QOakdNFR/sVIzgIpJEjqed4BNS/96D9e14g
UgLoSBXyT5yc8Co3poTtbX0R9FwKceEy8E4IdDAWivAPDII/FSbnVIq1DhEWxfDk
m+pfgf+brHOAnXy76oYARZOGUufe04CmhOPbYwa24RKQkbv88NuAJ02+9owg650h
lsl/qc08AIkOVgVet09aRgCTC1uXOqKnzVq4V2c8O76XEttMWnYZzyyuhYgRpv4w
UobnxSWD01s=
=aJZF
-----END PGP SIGNATURE-----

--=-8RJ44Dw6X/aTR+iFO+z9--
