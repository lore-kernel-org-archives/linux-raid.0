From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Tue, 03 Jul 2007 10:22:18 -0700
Message-ID: <468A85CA.2020405@ucolick.org>
References: <200707012321.48346.infomails@tronserver.dyndns.org> <200707031916.50502.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig98698B5696600FCD61AC6848"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707031916.50502.infomails@tronserver.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Frotscher <infomails@tronserver.dyndns.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig98698B5696600FCD61AC6848
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael Frotscher wrote:
> Hello all,
>
> I guess you can say that I'm at my wit's end. I really don't get it. An=
 RAID=20
> array is suppose to recognize its members purely by its uuid, isn't it?=
 So=20
> technically, I can remove a drive from one bus, reconnect it to another=
=20
> giving it a new device name and the array should not even need to sync.=

>
> Somehow it doesn't. Somehow the array remembers of which devices it's s=
upposed=20
> to be assembled and boots in degraded mode, funnily not always missing =
the=20
> swapped drive.
>
> Suppose I lose a whole ide-controller and want to restart the box with =
a=20
> seconday controller? That one would surely not have the devices hda thr=
ough=20
> hdd and my array would refuse to start.
>
> Does anyone have a suggestion of what I can try? Ok, the array runs fin=
e as=20
> long as it is connected to its original bus, but I really don't want to=
 take=20
> chances here.
>  =20
Funny, I did just this on my 10-disk raid5. 4 drives were moved from an
onboard sata controller to an Areca raid controller, and the array
didn't care. That was of course while the machine was down. If you fail
out a bunch of drives by having the controller go bad, that's probably
different.

cheers,

/Patrik



--------------enig98698B5696600FCD61AC6848
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGioXQT+KvsdUW5p8RAib5AJ9HJitZ4VjlKb83obHViY8KX3MWQQCfYIlS
mEQBPCWGkJf5JYL5mMx9B0M=
=nTLX
-----END PGP SIGNATURE-----

--------------enig98698B5696600FCD61AC6848--
