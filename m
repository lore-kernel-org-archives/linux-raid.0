From: NeilBrown <neilb@suse.de>
Subject: Re: Possible data corruption after rebuild
Date: Wed, 11 Jul 2012 10:27:23 +1000
Message-ID: <20120711102723.44dbcb0d@notabene.brown>
References: <CAB1R3sjHtWwE7=MOqTzS7omiE-ebxqBPNaMMh-+_AYw3WgLtxg@mail.gmail.com>
	<20120709101624.3dc4cdab@notabene.brown>
	<CAB1R3sipyxthDSh2AMU6b4pYnG00satTXFqqHaLnvUw2msxcXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZiAUfkgdpwz_iNqMG.C/AJk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sipyxthDSh2AMU6b4pYnG00satTXFqqHaLnvUw2msxcXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ZiAUfkgdpwz_iNqMG.C/AJk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jul 2012 13:53:01 -0400 Alex <mysqlstudent@gmail.com> wrote:

> Hi,
>=20
> >> I had a situation where after rebooting all three drives of a RAID5
> >> array were marked as spares. I rebuild the array using "mdadm -C
> >> /dev/md1 -e 1.1 --level 5 -n 3  --chunk 512 --assume-clean /dev/sda2
> >> /dev/sdb2 /dev/sdc2" and mdstat showed it was again assembled. The
> >> filesystem types on /dev/sdb were all "Linux" instead of "Linux raid
> >> autodetect", so I changed them back.
> >
> > You've been bitten by http://neil.brown.name/blog/20120615073245
>=20
> Ugh, that sucks. I actually performed much of what you described
> before hearing from you, but didn't realize the device order was so
> important and the kernel wouldn't be able to determine it on its own.
>=20
> If it wasn't a production system that I had to get back online before
> Monday morning, I would have been less hasty and waited a bit longer
> for guidance.
>=20
> > So md1 is all happy again is it?
>=20
> I actually broke that array previously and turned sda1 into an ext4
> because I couldn't get fc15 to properly boot from RAID1 with grub
> reliably.
>=20
> >> When I tried to fsck it to be sure it was intact, it prompted me that
> >> there was a problem with the superblock, and I answered Yes to "Fix?".
> >
> > Always use "fsck -n" to check if something is intact!!
>=20
> As I think I mentioned in my post, I had previously experienced
> something similar to this, and you helped me through it, but it was
> much easier situation. The filesystem was intact with only rebuilding
> the array. This time, when the array was intact, I didn't know I had
> any other option other than proceed with the fsck to attempt to fix
> the filesystem anyway.
>=20
> The last thing I thought was the issue was a kernel bug, and my
> exhaustive googling still left me without anything useful.
>=20
> > As fsck thought it recognised a filesystem it is very likely that the f=
irst
> > device is correct, so just try swapping the other to and issuing a new
> > --create command.  Then "fsck -n".
>=20
> I still have an image of all three disks on three new identical disks.
>=20
> I'm pretty sure I tried all permutations of the three devices, and
> fsck complained on each of them. I'm pretty sure I screwed it up along
> the way with fscking.
>=20
> If I deleted the journal with fsck, and it started complaining about
> the root inode missing, is there anything else that could possibly
> recover the data, or is it surely gone now?

My knowledge of ext3/4 and related tools isn't good enough to be able to
answer that, but it doesn't sound good.

When did you take the image onto the three new disks?  Before or after you
tried to "fsck" ?

Do you have the "mdadm --examine" output from before the disaster?

NeilBrown

--Sig_/ZiAUfkgdpwz_iNqMG.C/AJk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/zIaznsnt1WYoG5AQKnRxAAkTL3v1xcYb2VFzQT+Of9GuIF3JoZg8he
gYOaqZhxHkEBPEx7Gk7BeJZk3kyHnk8YTsezUu+Acc0uDVtBcCDsqjihNFgVxCxl
kvUv1jKbeCG6j7vhDAc3el1mV5+4zhA/ge3v+84fzKXeYPi/FWgfXje+ohNyTXw9
hSG7GgAZ6TUCKMUx5t1nz5Qfs6+q1oktw5xLzBoG0x7Rt5zeecgF0w3mfMdrwUIb
/392QrSV4d2hdLeetFXlXFrLWCvA25Vrjx/2Wo1ce99sYCd9UpHuXbLkVso9S79V
zto+GKrwX+fI9T8QYe9KsZ0SEBr2P/ByeTXHHq90YSiLFT1WnxEiAhb3RfCMqrJQ
9hy6yQ0MsDK/Q3J7oCXLj1Z1tQTRmcRSq4bMplk7aP60steta4H5vmGg11DBr10X
3RmQP0CT8ZVcFik5y/QVPfM1S1QkxXBSZck7CqolS9S+JxLnyLiGMYB3IdUsGd+c
CGtP+wQzY9a+nHhE+jcpkIrB4p9EwPpFmkh2rv6jCmp713oyUCbSoAjIoCtd+EBc
KZ4RnRtP43LdFmwztqzNSUEX9TJHAUyBNTFDITGxoYyeYT1a2eVnZ3sNLHObOIfc
61CVSi4WVBUwyD+VJWqfO16R65IILnS6xLTW8RWDwkbx/MqoRPCSovuQevE6vrbi
zin/l6gVHfg=
=tsBA
-----END PGP SIGNATURE-----

--Sig_/ZiAUfkgdpwz_iNqMG.C/AJk--
