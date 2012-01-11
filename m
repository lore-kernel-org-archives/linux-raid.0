From: NeilBrown <neilb@suse.de>
Subject: Re: Renaming MD devices (metadata=1.1)
Date: Wed, 11 Jan 2012 17:20:47 +1100
Message-ID: <20120111172047.6af5571f@notabene.brown>
References: <4F0BD6EA.8010007@grm.polymtl.ca>
	<4F0C1A03.8020509@ziu.info>
	<4F0D272A.2060000@grm.polymtl.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7cp1Mg9U_eyp34jb.d1Il5="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0D272A.2060000@grm.polymtl.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Gilbert Kowarzyk <kowarzyk@grm.polymtl.ca>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7cp1Mg9U_eyp34jb.d1Il5=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jan 2012 01:07:38 -0500 Gilbert Kowarzyk <kowarzyk@grm.polymtl.c=
a>
wrote:

> Hello,
>=20
> Thanks for the quick answer. My replies are below.
>=20
>=20
> >> # mdadm --examine --scan /dev/sdc1
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
> >> ARRAY /dev/md/9 metadata=3D1.1 UUID=3D0fa7f737:7806ca61:fb89edd6:14aa3=
51a
> >> name=3Dxyz.homelinux.com:9
> >> <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >>
> >> # mdadm --examine --scan /dev/sdd1
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
> >> ARRAY /dev/md/9 metadata=3D1.1 UUID=3D0fa7f737:7806ca61:fb89edd6:14aa3=
51a
> >> name=3Dxyz.homelinux.com:9
> >> <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >>
> >> # mdadm --detail --scan
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
> >> ARRAY /dev/md/xyz.homelinux.com:9 metadata=3D1.1
> >> name=3Dxyz.homelinux.com:9 UUID=3D0fa7f737:7806ca61:fb89edd6:14aa351a
> >> <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> # blkid
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
> >> /dev/md127: UUID=3D"c301cf13-cfaf-4f56-887e-c648caf5a931" TYPE=3D"ext4"
> >> <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> in /etc/fstab I have:
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
> >> UUID=3Dc301cf13-cfaf-4f56-887e-c648caf5a931 /DATA    ext4  defaults 1 2
> >> <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> and in /etc/mdadm.conf I have:
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
> >> ARRAY /dev/md/xyz.homelinux.com:9 metadata=3D1.1
> >> name=3Dxyz.homelinux.com:9 UUID=3D0fa7f737:7806ca61:fb89edd6:14aa351a
> >> <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >>
> >> To me, the line that looks suspicious is the one we get from "mdadm
> >> - --detail --scan". All the devices that "look right" say "ARRAY
> >> /dev/md/X" where X is a number.
> >>
> >> I fixed this temporarily by stopping the array and re-assembling it wi=
th:
> >>
> >> mdadm --assemble /dev/md9 --name=3D9 --update=3Dname /dev/sdc1 /dev/sd=
d1
> >>
> >=20
> > You updated name stored in the metadata, and assembled the array
> > explicitly requesting particular standard name. But the names directly
> > under /dev are managed/assigned by udev.
> >=20
> > As the /dev/md9 was explicitly given in this form, the MD_DEVNAME was
> > not present in 'mdadm --detail --export' output, thus /dev/md/9 was not
> > created by mdadm's udev rules - but it would have been if you had done
> > mdadm --assemble /dev/md/9 ...
>=20
> Ok, I think I follow this, but I am not sure.
>=20
> What you are saying is that I am getting /dev/md127 because it's not
> being created by udev right?

You are getting md127 because you asked for "/dev/md/xyz.home.linux.com:9"
so it gave you that (look in /dev/md) but it needs to give an 'mdXX' name to
the kernel so it chose 127 (because that is where it starts looking for free
numbers) and used that.  Don't worry about  the /dev/mdXX.  You asked for
"/dev/md/xyz.home.linux.com:9' in mdadm.conf,  you got, so just use it and
ignore the rest.



>=20
>=20
> >> Then the mdadm --detail --scan line says:
> >> ARRAY /dev/md/9 metadata=3D1.1 name=3Dxyz.homelinux.com:9
> >> UUID=3D0fa7f737:7806ca61:fb89edd6:14aa351a
> >>
> >> ... which makes more sense to me (it looks like the other ones.
> >>
> >> Yet, when I reboot the computer this "temporarily fixed" array returns
> >> to /dev/md127.
> >=20
> > But you should have proper, permanent name (as a symlink) under /dev/md/
>=20
> I just checked, and indeed I do. The symlinks I have under /dev/md/ are
> exactly the ones relating to the md devices I am having problems with
> renaming.
> There are no symlinks for the other md devices.
>=20
>=20
> > Autoassembly (be it -I used with modern mdadm's udev rules) or -A will
> > try to honor the device name if the name is in standard format, so for
> > mdadm.conf with ARRAY /dev/md/9 ... - you will (usually) get /dev/md9 -
> > but this it's not really worth chasing after or relying on (and what if
> > the name is already taken ?).
> >=20
> > Just write:
> >=20
> > ARRAY /dev/md/somename UUID=3D0fa7f737:7806ca61:fb89edd6:14aa351a
> > ARRAY somename UUID=3D0fa7f737:7806ca61:fb89edd6:14aa351a
> >=20
> > in which case 'somename' will be created under /dev/md/ regardless of
> > the name stored in the metadata, or just
> >=20
> > ARRAY UUID=3D0fa7f737:7806ca61:fb89edd6:14aa351a
> >=20
> > so the metadata (without hostname prefix) will be used.
>=20
> so expliciting the metadata=3Dx is not needed? What's its use?

Documentation.
It doesn't hurt, and I want "mdadm -Db" to report it, so if I allow it in
mdadm.conf then it is easier to use the output of "mdadm -Db" in mdadm.conf.


>=20
>=20
> > So to sum it up - if '9' is what you're after - then the ARRAY line with
> > just UUID is all you should be needing - and you should always get
> > /dev/md/9 (pointing to something else assigned dynamically).
> >=20
> > If udevd is not running (hardly interesting case anymore), then mdadm
> > will fall back to the pre-udev behavior and setup the nodes itself,
> > though the rules are slightly different then.
>=20
> I just left ARRAY UUID=3D0fa7f737:7806ca61:fb89edd6:14aa351a in
> /etc/mdadm.conf, rebooted, and it's still appearing as /dev/md127.

Just as I would expect.  You didn't ask for a specific number, so it just
chose an arbitrary one.

>=20
> So I am not sure why... What may I be missing?

Don't know.  Maybe you are expecting something that isn't needed.

What exactly do you want?  And why?

NeilBrown


--Sig_/7cp1Mg9U_eyp34jb.d1Il5=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTw0qPznsnt1WYoG5AQKLTw/+NClyBUJwI25dkCtU6/1DKOQ6JZbPvwjv
wMLbfGRU6gBPk4RtGayih8HdrW9U/0HUI0Er0O3K2Eqw8l1brhBfu+V1GqkoC7JO
VeUiXDcx34J2t/1MK79TkEF7Dwye96AHeKRVfieLbgq8Si5Xw99m7Uv9eEkbON7b
+Z+BdaQXql9uexnhF98SIdBsXN/zkHC9olHS7gjSCQ6ksQw26TEp/PRHtdO4fsYj
tcv9ACGDxxgI6d5tSaLt3KAS/krdTM9sbSWg4wUM+jg5ztsbY+SyRW35IR02FObq
78LGwjAF6M/8RYGPsO6ZxpRE7BgTkuPp+nmvco83Tk9lDmH+AO3EroucW1jGXnwy
IPMPpAjGppgoihtE5dFjsQ15hFUCms/ELh+YEf15/WhgZV5emUETZJMWEhqWPlba
wagJh0ks/NTP9tTYprIkIyzjr1f0aeLjMvRaWBW6ubSebSmClZE11K8Zwk01Xkxc
/XkU9uzvRktyOwasDOewyQdIjv3Z9+4hj2pe7XGVJ6WW6pXkZetxiwRrYDij0fJm
v5lXEOJx7UyRNrjQ5NSwMPSMbjj/+bSLNfWZhU009IBf1FKMvz0jVI4lAXpSr8fA
JmymoIwh5xJVno7JiSmrOV9V3gz292J8z+9/Ex9P00lDa4CqbC5UrcHgaYjjB89g
wmjEFz0W66M=
=l4xQ
-----END PGP SIGNATURE-----

--Sig_/7cp1Mg9U_eyp34jb.d1Il5=--
