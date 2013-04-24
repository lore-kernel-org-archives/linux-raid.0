From: NeilBrown <neilb@suse.de>
Subject: Re: RAID50 boot problems
Date: Thu, 25 Apr 2013 09:35:40 +1000
Message-ID: <20130425093540.1a2e8dc2@notabene.brown>
References: <20130424221219.5fa086e3@notabene.brown>
	<6325382.2.1366806579476.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Z3O088ZJuufeOo06f1q8+3h"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6325382.2.1366806579476.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

--Sig_/Z3O088ZJuufeOo06f1q8+3h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Apr 2013 14:29:39 +0200 (CEST) Roy Sigurd Karlsbakk
<roy@karlsbakk.net> wrote:

> > Sorry, that should be --name, not --path.
>=20
> roy@raidtest:~$ cat /proc/mdstat=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md0 : active raid5 vdc[1] vdb[0] vdd[3]
>       2096000 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>      =20
> md1 : active raid5 vdf[1] vdg[3] vde[0]
>       2096000 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>      =20
> unused devices: <none>
> roy@raidtest:~$ udevadm info --query=3Dproperty --name=3D/dev/md0
.....
> ID_FS_TYPE=3Dlinux_raid_member
....
> roy@raidtest:~$ udevadm info --query=3Dproperty --name=3D/dev/md1
...
> ID_FS_TYPE=3Dlinux_raid_member
....

So that all looks good.

> > Can you put your initrd (or initramfs or whatever Ubuntu calls it)
> > somewhere
> > that I can down load it? Or just email it to me, it's probably only
> > about 10Meg.
>=20
> Here are the ones for 12.04 x86 and 13.04 amd64. The same happen on both
>=20
> 12.04 http://karlsbakk.net/tmp/initrd.img-3.2.0-40-generic-pae
> 13.04 http://karlsbakk.net/tmp/initrd.img-3.8.0-19-generic
>=20

Strangely etc/mdadm/mdadm.conf in the 12.04 image lists the 2 RAID5s and the
RAID0, but the file in 13.04 only lists to 2 RAID5s.  I don't think that
makes a difference, but it is strange.

scripts/local-premount/mdadm contains "wait_for_udev" so that should be
enough...

Wait a bit.  I just noticed that 64-md-raid.rules only runs=20
   /sbin/mdadm --incremental $tempnode
on ACTION=3D=3D"add".
The RAID5 arrays aren't ready immediately and you need to catch=20
   ACTION=3D=3D"change"
Yes, that's horrible and inconsistent but that is life.

It would be worth adding an extra line:

ACTION=3D=3D"change", RUN+=3D"/sbin/mdadm --incremental $tempnode"

I'm not sure how to do that.  Maybe just modify the file in the root
filesystem and  run mkinitrd or mkinitramfs or whatever the command is.

Though if that is the problem, then I cannot see what just setting a
rootdelay would help.

NeilBrown

--Sig_/Z3O088ZJuufeOo06f1q8+3h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXhsTDnsnt1WYoG5AQIzRhAAiNLUgDf65kAnzdNkWUZFZwK8hXMrUgGb
jz3SICk0lKvPTQ5sUrD/hEaXvbY7AMR9nO8+Dtp6g7VSlYPNsXJpoAedoJJLg8BU
nCyJNkYON7dzf+yx/0SrWzZsoQSd0ByosusjQvb85B71ZQjPHfuX6S1uzHsAoUQ3
6jhzjgNpTR96lSQHGkDklIiVSPvpGpiWP9arsFm9LaZvMQRJPdNTVPKOzybJqCYW
T7aaGUcsKXaXuTcNfmenl0+rTRv9ZeaFZSm5gbCrgBwwPbJBc64i3IWeGxYIKn4h
nyuYSWlwxJ6BWdS9I8qlGCO7+e48lpXuIuBUNeaqyDiRYPOBLFQ44DstTuDrlRS1
im5JePe4/h2fYOYLKROO2QolHpF/KPFmvnAXMV+gg3F/I26R9pFuEH3JACkUh4a3
CuKKaDIffDkmvyA6NZrF7KCRnzaIlUPPQo38KL4dRBtHP878BL+BapKR0fN+Lxpm
YYDzvPEBEPAjzxhEBFB6StGxFrYH1N8ZvBz8WmP6DvBm681fbq+3QE1nvvDbhK/5
D58p332Td6HlFDcmCL79zTgED5utIQDXOkc4+S9J0zBzo/n6r4n8GJLNpgOm6rTW
1p3w9dSvD0GHQieafHXlA7ur+GruN7GlEdxwqufpe9v9bZfO+ERismTuY4k+dTpA
yCdJK+hzF+s=
=jEny
-----END PGP SIGNATURE-----

--Sig_/Z3O088ZJuufeOo06f1q8+3h--
