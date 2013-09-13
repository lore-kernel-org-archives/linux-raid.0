From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Sat, 14 Sep 2013 06:43:05 +1000
Message-ID: <20130914064305.0baadc69@notabene.brown>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dH3SDT3dNQkf_eshhq66pvj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dH3SDT3dNQkf_eshhq66pvj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Sep 2013 15:22:20 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hi Neil,
>=20
> I'm probably doing something wrong since it's a pretty critical bug
> but can't see what.
>=20
> I'm creating a RAID1 array with 1.2 metadata. After that I stop the
> array, and restart the array with only one disk. I write random data
> on the array and then stop it again:
>=20
> # mkfs.ext4 /dev/md125
> # mdadm --stop /dev/md125
> # mdadm -IRs /dev/loop0
> # mount /dev/md125 /mnt/
> # date >/mnt/foo
> # umount /mnt
> # mdadm --stop /dev/md125
>=20
> Finally I restart the array with the 2 disks (one disk is outdated)
> and mdadm happily activates the array without error. Note that I add
> the outdated disk first in that case:
>=20
> # mdadm -IRs /dev/loop1
> mdadm: /dev/loop1 attached to /dev/md/array1, which has been started.
> # mdadm -IRs /dev/loop0
> mdadm: /dev/loop0 attached to /dev/md/array1 which is already active.

That's a worry.  I'm not sure how to fix it.

I would probably suggest you don't use "-IR" to add devices.  That would ma=
ke
it a lot less likely to happen.


> # cat /proc/mdstat
> Personalities : [raid1]
> md125 : active raid1 loop0[0] loop1[1]
>       117056 blocks super 1.2 [2/2] [UU]
> # mount /dev/md125 /mnt
> # ls /mnt/
> [  457.321771] EXT4-fs error (device md125): ext4_lookup:1047: inode
> #2: comm ls: deleted inode referenced: 12
> ls: cannot access /mnt/1: Input/output error
>=20
> If I add the outdated disk last I got this:
> # mdadm -IRs /dev/loop0
> mdadm: /dev/loop0 attached to /dev/md/array1, which has been started.
> # mdadm -IRs /dev/loop1
> mdadm: can only add /dev/loop1 to /dev/md/array1 as a spare, and
> force-spare is not set.
> mdadm: failed to add /dev/loop1 to existing array /dev/md/array1:
> Invalid argument.
>=20
> which didn't tell me the reason why loop1 must be a spare.

It  must be a spare because it is out of date.


NeilBrown

>=20
> Is this expected ? If so could you enlight me ?
>=20
> Thanks


--Sig_/dH3SDT3dNQkf_eshhq66pvj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjN42Tnsnt1WYoG5AQLBJQ/+Lq4IsEvaNYXAKYhZKXeXULTKtpEPzxNN
lKusrS0j+fzN3NtZrtuCb/u61RaUuOjxHA1ddYHj8SDPqjrtxdGrKTAlPCPTLf8B
uNrx+rJMxJZaMD6vRvXlAuqbc/Q/eJiD8mfeMkbM68Mj22AtRKsyGif7RVLT52d5
wUUtDUYt0H85K1TVUfYmU07rIL/kxWQwJwVTmJRol/nwtFsiWU+TquHeRWq7hBAk
DPwmAqvlNT1dWdLefzDSjtwicevP9eQXSLdAyNG63EInQH2eJ/vXEhr9X6u4FDsy
MW/CnmG/g4+2vwIIsdfas8X5QDIsXrrKLFn4gIHUq+3Iu8d6X/uBs60yO3OUhcBi
RCunnxm8JjAVrDFf0+ZAhlc8C9hMfPhgXMWriJAAJyA1p3nfBd51Do9rJ2dtpq97
p8CO0Vg+JSMGWSu2lKOpj8AZlCWbNal9M2Y9ZniBi+v63byBOkaL62uj4l8fdPKs
hOR8Pf+fJO36iWaTyAGR1MXXnODbHzmezhQDpvLlpMvbVPj/Qwe6Amgl8IG1TMlv
xTgYvtYh4R3VarfcOiVrraef1+iYxs/j7ocebnP7q/JGj14fPGIqp53EYlAgTvT3
5nF1TEvLnre2GqVmektz/UXfZ4Kn1a5hQOIw19w0Dp5ynOuLVNBwg5C2zf4tE0Yz
TuGXIPkcjq8=
=uuQe
-----END PGP SIGNATURE-----

--Sig_/dH3SDT3dNQkf_eshhq66pvj--
