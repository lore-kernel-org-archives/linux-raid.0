From: NeilBrown <neilb@suse.de>
Subject: Re: MD component device renaming with udev and MD on full disk
Date: Tue, 25 Nov 2014 13:55:09 +1100
Message-ID: <20141125135509.4f32aea2@notabene.brown>
References: <546FB1B7.3050304@cse.yorku.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6C=8QHbOadu3V1zV=zuVM=G"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <546FB1B7.3050304@cse.yorku.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Keltz <jas@cse.yorku.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6C=8QHbOadu3V1zV=zuVM=G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Nov 2014 16:42:15 -0500 Jason Keltz <jas@cse.yorku.ca> wrote:

> Hi.
>=20
> I have two questions about MD..
>=20
> 1) I've written a udev rule to remap /dev/sdX devices on my system to=20
> /dev/cXeYsZpA (controller, enclosure, slot, partition) mapping. When I=20
> reboot the system, I see that all the devices in /dev are appropriately=20
> renamed.  If I look at /proc/mdstat, it still has the kernel names of=20
> the devices (/dev/sdX) even though those devices no longer exist.  If I=20
> do an mdadm --detail /dev/mdX the system reports the proper device name=20
> makeup.  I manually failed a device, and I got the correct device name=20
> in the email.  I'm just wondering what command I would execute to make=20
> /proc/mdstat update the devices in its output?

Names in /dev/ are link symlinks.  They point to the device (which is
identified by a pair of numbers: e.g. 8,1), but they aren't the device itse=
lf.

block device 8,1 is always "sda1" to the kernel, whether you access it thro=
ugh
a block-special file called "/dev/sda1" or "/dev/box-of-bits".

The names reported by /proc/mdstat are the kernel's internal names for the
devices.  You cannot get it to use the names that you have created in /dev.

"mdadm -D" is the best way to describe an array in terms of names that you
have chosen.


>=20
> 2) Unrelated to 1) -- the argument re: using MD on full devices versus=20
> partitions has been around for a long time.  I've been experimenting=20
> with using it on full devices.  One of the arguments that I've read for=20
> not using full devices is that apparently, if you have two devices that=20
> are identical, but one of them is slightly smaller than the other due to=
=20
> say, bad sectors, then these disks can't be used together in one MD=20
> because they are different sizes. I'm wondering how valid that argument=20
> is?  Surely it would make sense if MD was using full devices for it to=20
> actually stop short of the end of the disk for situations like these...

There is no validity at all in that argument.
md is quite happy using devices of different sizes and will ignore extra
space provided on the larger device.

If you had an array with two devices of size X, and got a new device of size
"X - delta", then it is true that the new device cannot be used in the arra=
y.
I think I have read a suggestion of creating partitions smaller than the
device so that when the "X - delta" device is used, it is still big enough
for that smaller partition.

There are two reasons why this is an invalid argument for using partitions:
1/ modern drives have standardised sizes.  If you have a size-X device, then
   you will not find a size-"X - delta" device unless "delta" is very big.

2/ you can use the --size option of mdadm to make the array use less than
   the total space on the device to allow for later reconfigurations.

There are other valid  reasons for preferring whole devices or partitions,
such as some tool or other might get confused by one of the arrangements
(e.g. lilo or and installer).  And some people might be more comfortable wi=
th
one than the other.
But the size issue is completely irrelevant.

NeilBrown


>=20
> Thanks for any help you can provide.
>=20
> Jason.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/6C=8QHbOadu3V1zV=zuVM=G
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHPvjTnsnt1WYoG5AQI0gA/9Hd6KBS78Eh+NaK2mW0SZaEZ4FS1m3WN6
hgiaFS6gALCnAdFjPbNmBgcq5tsFwzrjTpZji90lwitNz8ezy0/EjRVWIrwKzOkJ
cDl8TacIkkRoZ05CWHUAbfVS58Q68AS+ZOb/AkbidYiq1qo+0W7pG8+yuHGRLjkL
zOBvN+k3Xo7i2dJPOstgDVdXAa4RvFxrLun3ManiKKT6VlJs3Azp9OS/0azFKuG2
GKH133vr0nrTYfZnD4wTXQjVhM1/BNPx2kUYYgDLrsFmvoAzQ/I/gIAzvctmEk7m
3wW+tJX5mnHORT5d0ZXNrHj2N5UyeFwefPvCSw2EACTMcA6UoCU81q/EPopps+Oe
zcssG45pBuchizJkMxYoFjKIsjCNE41x/Zs8PpZbuchMksawKFAveK52BMO+KvNy
fAv/q23ZvjWDlDYunEPdiR2GwhpMbeUvtohrxRMEJad6E7lqqO3Kqv5EBh3akosO
upVSt7uvtY8PwHHGw+4tnK3UyJ9UL4GdoCl+E4JoDXmVkgUrrl1cnlG5K+gf2l77
/8VPGfcnpyYFjrVGdSEYe361VTIKvVmTcOTzmoJYkWdhGh7RYQ+OiHEaOenJjsYq
EpH7UlN0ujfx+vobQjjagjjek8SVC4AWiSWIKoXhfwXO3jYNsmfsKaDj3eLWCfwS
B9PakvkIsc4=
=+7Cb
-----END PGP SIGNATURE-----

--Sig_/6C=8QHbOadu3V1zV=zuVM=G--
