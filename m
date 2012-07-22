From: NeilBrown <neilb@suse.de>
Subject: Re: Problem recovering failed Intel Rapid Storage raid5 volume
Date: Mon, 23 Jul 2012 09:08:56 +1000
Message-ID: <20120723090856.2738a2fc@notabene.brown>
References: <CAHijsZt-CZ4BhjLU2sdWaGRtDa6bXjz0Bx+RRqoGRzvD6N6yvA@mail.gmail.com>
	<CAHijsZvPb5PZLmKxUwV4iZ-UOUfpGP_Hf9afaWdX34iO86EHKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/D=KR_EmzfZwm8S09KzVHD11"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHijsZvPb5PZLmKxUwV4iZ-UOUfpGP_Hf9afaWdX34iO86EHKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Khurram Hassan <kfhassan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/D=KR_EmzfZwm8S09KzVHD11
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jul 2012 21:00:19 +0500 Khurram Hassan <kfhassan@gmail.com> wrot=
e:

> I have this 3 disk raid5 volumne on an Asus motherboard sporting an
> Intel Rapid Storage chipset. The problem began when I noticed in
> windows that one of the hard disks (the first one in the array) was
> marked as failed in the Intel raid utility. I shutdown the system to
> remove the hard disk and removed the cables for the faulty hard disk.
> But I made a mistake and remove the cables for one of the working hard
> disks. So when I booted, it showed the raid volume as failed. I
> quickly shutdown the system and corrected the mistake. But it
> completely hosed my raid volume. When I booted the system up again,
> both of the remaining 2 hard disks were showed as offline.
>=20
> I read the raid recovery section in the wiki and installed ubuntu
> 12.04 on a separate non-raid hard disk (after completely disconnecting
> the offline raid5 volume). Then I reconnected the 2 hard disks and
> booted ubuntu. Then I gave the following commands:
>=20
> 1) mdadm --examine /dev/sd[bc] > raid.status
> 2) mdadm --create --assume-clean -c 128 --level=3D5 --raid-devices=3D3
> /dev/md1 missing /dev/sdb /dev/sdc
>=20
> It gave the following output:
>     mdadm: /dev/sdb appears to be part of a raid array:
>         level=3Dcontainer devices=3D0 ctime=3DThu Jan  1 05:00:00 1970
>     mdadm: /dev/sdc appears to be part of a raid array:
>         level=3Dcontainer devices=3D0 ctime=3DThu Jan  1 05:00:00 1970
>     Continue creating array? y
>     mdadm: Defaulting to version 1.2 metadata
>     mdadm: array /dev/md1 started.
>=20
> But the raid volume is not accessible. mdadm --examine /dev/md1 gives:
>=20
>     mdadm: No md superblock detected on /dev/md1.
>=20
> Worse, upon booting the system, the raid chipset message says the 2
> hard disk are non-raid hard disks. Have I completely messed up the
> raid volume? Is it not recoverable at all?

Possibly :-(

You had an array with Intel-specific metadata.  This metadata is stored at
the end of the device.

When you tried to "--create" the array, you did not ask for intel metadata =
so
you got the default v1.2 metadata.  This metadata is stored at the beginning
of the device (a 1K block, 4K from the start).
So this would have over-written a small amount of filesystem data.

Also when you --create an array, mdadm erases any other metadata that it
finds to avoid confusion.  So it will have erased the Intel metadata from t=
he
end.

Your best hope is to recreate the array correctly with intel metadata.  The
filesystem will quite possibly be corrupted, but you might get some or even
all of your data back.

Can you post the "raid.status".  That would help be certain we are doing the
right thing.
Something like
  mdadm --create /dev/md/imsm -e imsm -n 3 missing /dev/sdb /dev/sdc
  mdadm --create /dev/md1 -c 128 -l 5 -n 3 /dev/md/imsm

might do it  ... or might not.  I'm not sure about creating imsm arrays with
missing devices.  Maybe you still list the 3 devices rather than just the
container.  I'd need to experiment.  If you post the raid.status I'll see if
I can work out the best way forward.

NeilBrown


--Sig_/D=KR_EmzfZwm8S09KzVHD11
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAyICDnsnt1WYoG5AQK6cQ//XhGBi0K95J7Ei/HPK3Xwu3EJQfhyMdGy
l2Er70vGm4N3oxrphEXKNeryBDaZejB0KRihAIX6rrfVw9+UgKe3KKKn4L4npI11
fcFT3wTJVcmz2SI3jrdQmtNDgmuK8PvWmu5NODyI2I90l3l99MUkAvzYQUkIcffg
ZmRaYUQGRGLC4X89zEn9kQLrR/ZE9WQeY7nBXUzD3/xTPgLp7U4yEVxTAdHZlXWe
ulkT64WnlKwbRpNxFZLsyh+WpK6IcmJnAqEqsirgdYrH8wkVJbCLtiLwLiy2i6ow
K9WW52ixTRWvqNA/tq5md9PAZVD2dgB+Wn6Oaf0pQhlRw/SJDzvY3W8CsqEDWr1p
84GqG7KchGNlQouwml5iIjzFkenXx1peRb5+TYfJLXtOYECWFVRUijSlbdUq/tyJ
h2mPRq6egvLplKusCra+FGi99pTgH4H94PUc4pfMuaz0ZIE1YZupJShq5N5H+6AZ
QwdRC+bDY8Wdysumym2Jh1AXC7o4UAC9QY2G4mgzHcLc8JPXepqaQFKWirHQoqx3
fi46SBGCppbtesSnw5gcrJiNk0Sga68E4v3jOqnwxyvXaLZ3/HVyC1bF6Tr7Vcdx
/zci1v1q8mQ6f/24I70TeGQrAu8qKTYHSiYxYT8n0FryG9Ch6TvjuKNKaNibGylv
isQis2/mXQY=
=5BFe
-----END PGP SIGNATURE-----

--Sig_/D=KR_EmzfZwm8S09KzVHD11--
