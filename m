From: Doug Ledford <dledford@redhat.com>
Subject: Re: Software RAID5 write issues
Date: Wed, 10 Jun 2009 16:57:00 -0400
Message-ID: <1244667422.21347.210.camel@firewall.xsintricity.com>
References: <AB9F712C-7A3F-4832-B60B-AB56DE448F14@crc.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-phpfJQIiulul88LHECPU"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AB9F712C-7A3F-4832-B60B-AB56DE448F14@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-phpfJQIiulul88LHECPU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 03:17 +1000, Steven Haigh wrote:
> Hi all,
>=20
> After a week and a bit of googling, experimenting and frustration I'm =20
> posting here and hoping I can get some clues on what could be wrong =20
> with my 5 disk RAID5 SATA array.
>=20
> The array in question is:
> md1 : active raid5 sdg1[0] sdf1[1] sde1[3] sdd1[2] sdc1[4]
>        1172131840 blocks level 5, 1024k chunk, algorithm 2 [5/5] [UUUUU]
>=20
> All 5 drives are connection to a sil_sata controller (a 3112 & a 3114) =20
> set up as a simple SATA controller (ie no RAID here).
>=20
> Once the system buffer is full, write speeds to the array are usually =20
> under 20MB/sec.
>=20
> I am currently running CentOS 5.3 (kernel =20
> 2.6.18-128.1.10.el5.centos.plus).
>=20
> I have lodged a bug report against RHEL 5.3, as I believe something is =20
> not quite right here, but haven't been able to narrow down the exact =20
> issue.
> 	https://bugzilla.redhat.com/show_bug.cgi?id=3D502499
>=20
> Using bonnie++ to benchmark the array, it shows sequential block reads =20
> at 90MB/sec but writes at 11MB/sec across the RAID5 array - a =20
> difference I really didn't expect.
>=20
> Any pointers on how to try to tackle this one and figure out the root =20
> cause of the problem would be VERY helpful!

OK, so I read the bug report.  There are two distinctly different
problems you are experiencing.  One, is a slow down specific to our
recent kernels.  The slow down in your case takes your normally abysmal
raid and makes it even worse.  The original bug report was mainly about
the slowdown, so I'll address that in the bug report.  However, in
regards to your raid setup, I'll try to address why your array performs
so poorly regardless of kernel version and maybe that will help you
build up a better raid setup.

You have 4 motherboard SATA ports, and 4 SATA ports on a PCI card.
Right now you have your two OS drives on motherboard SATA ports, two of
the five raid5 drives on motherboard SATA ports, and the three remaining
raid5 drives on the PCI card SATA ports.  You need to get as many of the
raid5 SATA disks on motherboard ports as possible.  I would decide if
you are more concerned about the raid5 array performing well (common, as
it's usually the data you access most often) or the base OS array
performing well (not so common, as it gets loaded largely into cache and
doesn't get hit nearly so often as the data drive).  If you can deal
with slowing down the OS drives, then I would move one of the OS drives
to the PCI card and move one of the raid5 drives to the motherboard SATA
port (and whichever drive you just moved over to the PCI card, I would
mark it's raid1 arrays as write-mostly so that you don't read from it
normally).  If your BIOS will allow you to select drives on the PCI card
as boot drives, and you can tolerate the slow down, then I would move
both of the OS drives to the PCI card (and don't worry about using
write-mostly on the raid1 arrays any more) and get 4 of the 5 raid5
drives onto motherboard SATA ports.

Your big problem is that with 3 out of 5 raid5 drives on that PCI card,
and sharing bandwidth, your total theoretical raid speed is abysmal.
When the three drives are sharing bandwidth on the card, they tend to
split it up fairly evenly.  That means each drive gets roughly 1/3 of
the PCI card's total available bandwidth over the PCI bus, which is
generally poor in the first place.  Understand that a slow drive drags
down *all* the drives in a raid5 array.  The faster drives just end up
idling while waiting on the slower drive to finish its work (the faster
drives will run ahead up to a point, then they eventually just get so
far ahead that there isn't anything else for them to do until the
slowest drive finishes up its stuff so old block requests can be
completed, etc).  On the other hand, if you get 4 of the 5 drives on the
motherboard ports, then that 5th drive on the PCI card won't be
splitting bandwidth up and the overall array performance will shoot up
(assuming the OS drives aren't also heavily loaded).

If you move one OS drive to the PCI card, then that leaves two raid5
drives on the card.  In that case, I would seriously consider dropping
back to a 4 drive array if you can handle the space reduction.  I would
also seriously consider using raid4 instead of raid5 depending on your
normal usage pattern.  If the data on the raid5 array is written once
and then read over and over again, a raid4 can be beneficial in that you
can stick the parity drive off on the PCI card and it won't be read from
unless there is a drive failure or one the rare occasions when you write
new data.  If, on the other hand, you write lots of new data, then
either don't use raid4, or put the parity drive on a motherboard port
where it won't hog so much bandwidth on the PCI card.  Ideally, I would
say get both OS drives on the PCI card, and if you need all 5 drives for
the data raid, then use raid4 with the parity on the PCI card if the
array is mostly static, use raid5 otherwise.  If you only move one OS
drive to the PCI card and still have two raid5 drives on the PCI card,
then again think about whether your data is static or not and possibly
use raid4 in an attempt to reduce the traffic on the PCI card.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-phpfJQIiulul88LHECPU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkowHhwACgkQQ9aEs6Ims9jPtACggp/kRY5PsigjkHYn9xmYnxLO
o2wAnRpAhsXe+k+AWytLDr43FU/9998n
=wun3
-----END PGP SIGNATURE-----

--=-phpfJQIiulul88LHECPU--

