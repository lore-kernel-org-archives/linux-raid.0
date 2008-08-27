From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID not auto-assembling?
Date: Wed, 27 Aug 2008 16:13:07 -0400
Message-ID: <1219867987.27033.7.camel@firewall.xsintricity.com>
References: <fa037c550808252233u175c7ca8g37ff6fa0c214e12f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hm8jGSeW21ai+Nxgg+yj"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa037c550808252233u175c7ca8g37ff6fa0c214e12f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sean Hildebrand <silverwraithii@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-Hm8jGSeW21ai+Nxgg+yj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-26 at 01:33 -0400, Sean Hildebrand wrote:
> I have a 3-disk RAID5, with a consistent superblock, and partitions
> are all 0xFD.
>=20
> The array isn't recognized by mdadm at boot or when I manually ask it
> to assemble /dev/md0 without specifying partitions. The three
> partitions are always /dev/sd[abc]1.

You didn't mention what distribution/OS you are using, but this problem
is distribution specific.

If you use any of the Red Hat OSes, then you probably need to configure
your system to start the array at boot up.  This is especially true if
this is the first array you've ever had on the system.

Start off by creating a simple /etc/mdadm.conf file.  A couple lines
that read:

DEVICE partitions
MAILADDR root

is sufficient to start.  Then, while your md array is up and running,
execute the following command:

mdadm -Db /dev/md0 >> /etc/mdadm.conf

This will add the information for your array to the end of the
mdadm.conf file.  Once you've done that, recreate the initrd for your
kernel by using this command:

VER=3D`uname -r`
mkinitrd -v -f /boot/initrd-${VER}.img ${VER}

Now, when you reboot, the system should start up your raid array
automatically.

Note: if your raid array isn't needed in order for the system to mount
the / partition, then you can skip remaking the initrd image, just
creating an entry in /etc/mdadm.conf is enough to cause the system
initscript to start the array at bootup.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-Hm8jGSeW21ai+Nxgg+yj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAki1tVMACgkQTzP9PM7pjw+zeQCYzAe115TZfmHOX73IyAmME/Cw
NACfY4dCytqqBCf4giU14Jog92nBid0=
=RJXn
-----END PGP SIGNATURE-----

--=-Hm8jGSeW21ai+Nxgg+yj--

