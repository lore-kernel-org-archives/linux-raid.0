From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 20 Oct 2007 11:36:36 -0400
Message-ID: <1192894596.1666.135.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>
	 <20071020150729.GB17431@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KfQ7sxEhpsRreQGY6lrB"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071020150729.GB17431@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Iustin Pop <iusty@k1024.org>
Cc: John Stoffel <john@stoffel.org>, Michael Tokarev <mjt@tls.msk.ru>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-KfQ7sxEhpsRreQGY6lrB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-20 at 17:07 +0200, Iustin Pop wrote:
> On Sat, Oct 20, 2007 at 10:52:39AM -0400, John Stoffel wrote:
> > Michael> Well, I strongly, completely disagree.  You described a
> > Michael> real-world situation, and that's unfortunate, BUT: for at
> > Michael> least raid1, there ARE cases, pretty valid ones, when one
> > Michael> NEEDS to mount the filesystem without bringing up raid.
> > Michael> Raid1 allows that.
> >=20
> > Please describe one such case please.
>=20
> Boot from a raid1 array, such that everything - including the partition
> table itself - is mirrored.

That's a *really* bad idea.  If you want to subpartition a raid array,
you really should either run lvm on top of raid or use a partitionable
raid array embedded in a raid partition.  If you don't, there are a
whole slew of failure cases that would result in the same sort of
accidental access and data corruption that I talked about.  For
instance, if you ever ran fdisk on the disk itself instead of the raid
array, fdisk would happily create a partition that runs off the end of
the raid device and into the superblock area.  The raid subsystem
autodetect only works on partitions labeled as type 0xfd, so it would
never search for a raid superblock at the end of the actual device, and
that means that if you boot from a rescue CD that doesn't contain an
mdadm.conf file that specifies the whole disk device as a search device,
then it is guaranteed to not start the device and possibly try and
modify the underlying constituent devices.  All around, it's just a
*really* bad idea.

I've heard several descriptions of things you *could* do with the
superblock at the end, but as of yet, not one of them is a good idea if
you really care about your data.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-KfQ7sxEhpsRreQGY6lrB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHGiCDTzP9PM7pjw8RAkerAJ98dqOrKcaKmocMBF9FqL3+TP0soQCfQNeZ
3laYqpzdfHlvcuXb0aimgBI=
=W1bN
-----END PGP SIGNATURE-----

--=-KfQ7sxEhpsRreQGY6lrB--

