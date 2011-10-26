From: NeilBrown <neilb@suse.de>
Subject: Re: Question about mdadm commit
 d6508f0cfb60edf07b36f1532eae4d9cddf7178b "be more careful about add
 attempts"
Date: Thu, 27 Oct 2011 08:51:25 +1100
Message-ID: <20111027085125.747691a9@notabene.brown>
References: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rasso5/OV1KtieC+CNXnMuL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rasso5/OV1KtieC+CNXnMuL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Oct 2011 19:02:37 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Greetings everybody,
> I have a question about the following code in Manage.c:Manage_subdevs()
>=20
> disc.number =3D mdi.disk.number;
> if (ioctl(fd, GET_DISK_INFO, &disc) !=3D 0
>     || disc.major !=3D 0 || disc.minor !=3D 0
>     || !enough_fd(fd))
>     goto skip_re_add;
>=20
> I do not underatand why the checks: disc.major !=3D 0 || disc.minor !=3D 0
> are required. This basically means that the kernel already has an
> rdev->desc_nr equal to disc.number. But why fail the re-add procedure?
>=20
> Let's say that enough_fd() returns true, and we go ahead an issue
> ioctl(ADD_NEW_DISK). In this case, according to the kernel code in
> add_new_disk(), it will not even look at info->number. It will
> initialize rdev->desc_nr to -1, and will allocate a free desc_nr for
> the rdev later.
>=20
> Doing this with mdadm 3.1.4, where this check is not present, actually
> succeeds. I understand that this code was added for cases when
> enough_fd() returns false, which sounds perfectly fine to protect
> from.
>=20
> I was thinking that this code should actually check something like:
> if (ioctl(fd, GET_DISK_INFO, &disc) !=3D 0
>     || disk.raid_disk !=3D mdi.disk.raid_disk
>     || !enough_fd(fd))
>     goto skip_re_add;
>=20
> That is to check that the slot that was being occupied by the drive we
> are trying to add, is already occupied by a different drive (need also
> to cover cases of raid_disk <0, raid_disk >=3D raid_disks etc...) and
> not the desc_nr, which does not have any persistent meaning.
>=20
> Perhaps there are some compatibility issues with old kernels? Or
> special considerations for ... containers? non-persistent arrays?

The point of this code is to make --re-add fail unless mdadm is certain that
the kernel will accept the re-add, rather than turn the device into a spare.

If a device already exists with the same disk.number, a re-add cannot
succeed, so mdadm doesn't even try.

When you say in 3.1.4 it "actually succeeds" - what succeeds?  Does it re-a=
dd
the device to the array, or does it turn the device into a spare?
I particularly do not want --re-add to turn a device into a spare because
people sometimes use it in cases where it cannot work, their device gets
turned into a spare, and they lose information that could have been used to
reconstruct the array.

That that make sense?

NeilBrown


--Sig_/rasso5/OV1KtieC+CNXnMuL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqiA3Tnsnt1WYoG5AQJipg//fp8nQKQHA1mRinvHZwXR6fpEACi+NEh1
syk2Fc2y3xlgBp3GIsL4TNxemAxxxWzFVyJjy9ycGm2xsPo5RsfnO6i6MDMwfyvv
vW8Uh+rrpnz095IlcLHD5RYvj7obYgVqHfIn2YHU+xLC0WDKGRlgXjRkThD8srq3
oP3MIOh1uMgZxAEFBOKWnNESZFuovkFpWZbTnN/e1Qf+uM/z1+3wqIzYjDebGKsR
wSj+4Hu+/ltN1xEBtJuok9X4L2Owu+uyVpgm925uKCqCULqvIWYOya/28TRGOTGY
fvNCZOeWxFrUFH0HYTm/9NQfO7BDCBrIwfhggzQHInnw5vV0WBgPK+6Q+8utRNS1
Kd1MuOY6myo3Hac0gAATrmwgFG9Q3EL+St4OlgDPLA66IelzAZia+v3+44PXb/oG
ZSogEKfADy0jfT6SptQK67c7YPT0MUG583CAZVIm7dhDpw+PYP9SfWgvzhjLKu/q
J66rPywvPt6Ely/nCPsY2xeejYf6Oz+wFXinTumylbg1fTE7cRacNAvZK3nR5f4F
nKUwxuOKrlxJ5vgQjUGEFbRO7/BsGawTqrCyb1yCdov+H0LBV05wH8Guqd21xVFv
gsyuB9f7jiQ+8kI1SM8zZpcG0CuTcHHwoHCYYdDmFll4cta/IN+LEot4rx1Gl5KP
ASYE5lTsT08=
=QaIj
-----END PGP SIGNATURE-----

--Sig_/rasso5/OV1KtieC+CNXnMuL--
