From: NeilBrown <neilb@suse.de>
Subject: Re: Failed drive while converting raid5 to raid6, then a hard
 reboot
Date: Wed, 9 May 2012 06:48:58 +1000
Message-ID: <20120509064858.4e39c389@notabene.brown>
References: <CAFTzWnrQARaemDkMNe48zT8tipPmsVbt0ZFgfDTyrtUc9KjuZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BZPJmgFdV6G3IuxXiE=_yb9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFTzWnrQARaemDkMNe48zT8tipPmsVbt0ZFgfDTyrtUc9KjuZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?H=E1kon_G=EDslason?= <hakon.gislason@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/BZPJmgFdV6G3IuxXiE=_yb9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 13:59:56 +0000 H=E1kon G=EDslason <hakon.gislason@gmail=
.com>
wrote:

> Hello,
> I've been having frequent drive "failures", as in, they are reported
> failed/bad and mdadm sends me an email telling me things went wrong,
> etc... but after a reboot or two, they are perfectly fine again. I'm
> not sure what it is, but this server is quite new and I think there
> might be more behind it, bad memory or the motherboard (I've been
> having other issues as well). I've had 4 drive "failures" in this
> month, all different drives except for one, which "failed" twice, and
> all have been fixed with a reboot or rebuild (all drives reported bad
> by mdadm passed an extensive SMART test).
> Due to this, I decided to convert my raid5 array to a raid6 array
> while I find the root cause of the problem.
>=20
> I started the conversion right after a drive failure & rebuild, but as
> it had converted/reshaped aprox. 4%(if I remember correctly, and it
> was going really slowly, ~7500 minutes to completion), it reported
> another drive bad, and the conversion to raid6 stopped (it said
> "rebuilding", but the speed was 0K/sec and the time left was a few
> million minutes.
> After that happened, I tried to stop the array and reboot the server,
> as I had done previously to get the reportedly "bad" drive working
> again, but It=A0wouldn't=A0stop the array or reboot, neither could I
> unmount it, it just hung whenever I tried to do something with
> /dev/md0. After trying to reboot a few times, I just killed the power
> and re-started it.=A0Admittedly=A0this was probably not the best thing I
> could have done at that point.
>=20
> I have backup of ca. 80% of the data on there, it's been a month since
> the last complete backup (because I ran out of backup disk space).
>=20
> So, the big question, can the array be activated, and can it complete
> the conversion to raid6? And will I get my data back?
> I hope the data can be rescued, and any help I can get would be much
> appreciated!
>=20
> I'm fairly new to raid in general, and have been using mdadm for about
> a month now.
> Here's some data:
>=20
> root@axiom:~# mdadm --examine --scan
> ARRAY /dev/md/0 metadata=3D1.2 UUID=3Dcfedbfc1:feaee982:4e92ccf4:45e08ed1
> name=3Daxiom.is:0
>=20
>=20
> root@axiom:~# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : inactive sdc[6] sde[7] sdb[5] sda[4]
> =A0 =A0 =A0 7814054240 blocks super 1.2
>=20
> root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
> mdadm: /dev/md0 is already in use.
>=20
> root@axiom:~# mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
>=20
> root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
> mdadm: Failed to restore critical section for reshape, sorry.
> =A0 =A0 =A0 Possibly you needed to specify the --backup-file
>=20
> root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
> --backup-file=3D/root/mdadm-backup-file
> mdadm: Failed to restore critical section for reshape, sorry.

What version of mdadm are you using?

I suggest getting a newer one (I'm about to release 3.2.4, but 3.2.3 should
be fine) and if just that doesn't help, add the "--invalid-backup" option.

However I very strongly suggest you try to resolve the problem which is
causing your drives to fail.  Until you resolve that it will keep happening
and having it happen repeatly during the (slow) reshape process would not be
good.

Maybe plug the drives into another computer, or another controller, while t=
he
reshape runs?

NeilBrown



--Sig_/BZPJmgFdV6G3IuxXiE=_yb9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIUAwUBT6mGujnsnt1WYoG5AQKiwQ/2M8t51VHWD2TCt7hW2AfNYyU6EeDx/90n
/9GBDo9zpN+9GyuvtJ0frBNbqRbpPgaIzQM9gRIFJMM0d3smkFQxIsN4kaQG4QQy
72iTAQa/f1vl+8fBA/c/0MeAUP+g3Dv0llwKECUeYvmC9OJcYRnDZDSALAGfKw3a
NvD/Rf4I+ofy+gqY41NTzW1A3c/55X2suwWqAwj33c+JQDhLwNYMwuFc7e4bAgXh
vxw9hzH7LfIBF054UsnnK+yseE4mIPgkNgDzGCd5b4SVwMXxjRgJmCOukiaMCk0O
XlUHLQeeeFRCOslP02ZnI8sONTq49I1e6EZO/8c4RTHXqfQy7q/mNQAhRVwytR0f
uz+StVjpwzZ+UZgqthbHCtG/8sf0Ox2WliE7zH+wCiBeJAccJIdZowiWe/a/ZWZ2
kMCjwaGo/lEWO1RpEdmX1aJwyjNya2gC3RyRUvQjIh4OHDzmnPkxMAusBI+DlJ7H
MHl/r+VRf1okatgjhcGgKX6K0SMVB8qu8la6dIveWCkXfHGoXQCPgTPcctglwGaO
4Ai+E8M5zB41TrmsL5T4x/+kugnaeIkcF6IflvrdoWxD9OHaIA7L3+3lGPZPMn0W
OrnPuxcXui84H+zJGUc6li/JmZf5t7SJEbFlnYxm40wIToUvbDAB0Vphg12OSHl8
6FA5/SZylA==
=m28Z
-----END PGP SIGNATURE-----

--Sig_/BZPJmgFdV6G3IuxXiE=_yb9--
