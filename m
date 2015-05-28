From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 reshape is stuck
Date: Thu, 28 May 2015 16:49:23 +1000
Message-ID: <20150528164923.2cd4af02@notabene.brown>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
	<427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com>
	<20150527100253.221ab553@notabene.brown>
	<20150527111004.5f136f23@notabene.brown>
	<2129908770.5092770.1432726084717.JavaMail.zimbra@redhat.com>
	<20150527213449.6e017deb@notabene.brown>
	<476656362.5105083.1432728264276.JavaMail.zimbra@redhat.com>
	<20150528085958.0f95e323@notabene.brown>
	<45685228.5717919.1432794771906.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/v9kOtvILBG+5lr9ztyrpAJ3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45685228.5717919.1432794771906.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/v9kOtvILBG+5lr9ztyrpAJ3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 May 2015 02:32:51 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

>=20
>=20
> ----- Original Message -----
> > From: "NeilBrown" <neilb@suse.de>
> > To: "Xiao Ni" <xni@redhat.com>
> > Cc: linux-raid@vger.kernel.org
> > Sent: Thursday, May 28, 2015 6:59:58 AM
> > Subject: Re: raid5 reshape is stuck
> >=20
> > On Wed, 27 May 2015 08:04:24 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> >=20
> > >=20
> > >=20
> > > ----- Original Message -----
> > > > From: "NeilBrown" <neilb@suse.de>
> > > > To: "Xiao Ni" <xni@redhat.com>
> > > > Cc: linux-raid@vger.kernel.org
> > > > Sent: Wednesday, May 27, 2015 7:34:49 PM
> > > > Subject: Re: raid5 reshape is stuck
> > > >=20
> > > > On Wed, 27 May 2015 07:28:04 -0400 (EDT) Xiao Ni <xni@redhat.com> w=
rote:
> > > >=20
> > > >=20
> > > > > [root@intel-waimeabay-hedt-01 mdadm]# cat
> > > > > /usr/lib/systemd/system/mdadm-grow-continue\@.service
> > > > > #  This file is part of mdadm.
> > > > > #
> > > > > #  mdadm is free software; you can redistribute it and/or modify =
it
> > > > > #  under the terms of the GNU General Public License as published=
 by
> > > > > #  the Free Software Foundation; either version 2 of the License,=
 or
> > > > > #  (at your option) any later version.
> > > > >=20
> > > > > [Unit]
> > > > > Description=3DManage MD Reshape on /dev/%I
> > > > > DefaultDependencies=3Dno
> > > > >=20
> > > > > [Service]
> > > > > ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I
> > > > > --backup-file=3D/root/tmp0
> > > >=20
> > > > Please remove the ---backup-file=3D/root/tmp0 for further testing. =
 The
> > > > patch I
> > > > provided should make that unnecessary.
> > > >=20
> > > > > StandardInput=3Dnull
> > > > > StandardOutput=3Dnull
> > > > > StandardError=3Dnull
> > > >=20
> > > > Could you try removing these - that might allow error messages to a=
ppear.
> > > > I wonder why I included them - they shouldn't be needed.
> > > >=20
> > > > Thanks,
> > > > NeilBrown
> > > >=20
> > > >=20
> > >=20
> > > [root@intel-waimeabay-hedt-01 mdadm]# mdadm -CR /dev/md0 -l5 -n4
> > > /dev/loop[0-3] --assume-clean
> > > mdadm: /dev/loop0 appears to be part of a raid array:
> > >        level=3Draid5 devices=3D5 ctime=3DWed May 27 02:45:08 2015
> > > mdadm: /dev/loop1 appears to be part of a raid array:
> > >        level=3Draid5 devices=3D5 ctime=3DWed May 27 02:45:08 2015
> > > mdadm: /dev/loop2 appears to be part of a raid array:
> > >        level=3Draid5 devices=3D5 ctime=3DWed May 27 02:45:08 2015
> > > mdadm: /dev/loop3 appears to be part of a raid array:
> > >        level=3Draid5 devices=3D5 ctime=3DWed May 27 02:45:08 2015
> > > mdadm: Defaulting to version 1.2 metadata
> > > mdadm: array /dev/md0 started.
> > > [root@intel-waimeabay-hedt-01 mdadm]# mdadm /dev/md0 -a /dev/loop4
> > > mdadm: added /dev/loop4
> > > [root@intel-waimeabay-hedt-01 mdadm]# mdadm --grow /dev/md0
> > > --raid-devices=3D5
> > > mdadm: Need to backup 6144K of critical section..
> > > [root@intel-waimeabay-hedt-01 mdadm]# cat /proc/mdstat
> > > Personalities : [raid6] [raid5] [raid4]
> > > md0 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
> > >       1532928 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5]
> > >       [UUUUU]
> > >       [>....................]  reshape =3D  0.0% (0/510976) finish=3D=
532.2min
> > >       speed=3D0K/sec
> > >      =20
> > > unused devices: <none>
> > > [root@intel-waimeabay-hedt-01 mdadm]# cat
> > > /usr/lib/systemd/system/mdadm-grow-continue\@.service
> > > #  This file is part of mdadm.
> > > #
> > > #  mdadm is free software; you can redistribute it and/or modify it
> > > #  under the terms of the GNU General Public License as published by
> > > #  the Free Software Foundation; either version 2 of the License, or
> > > #  (at your option) any later version.
> > >=20
> > > [Unit]
> > > Description=3DManage MD Reshape on /dev/%I
> > > DefaultDependencies=3Dno
> > >=20
> > > [Service]
> > > ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I
> > > #StandardInput=3Dnull
> > > #StandardOutput=3Dnull
> > > #StandardError=3Dnull
> > > KillMode=3Dnone
> > >=20
> > >=20
> > > The problem still exist. And there are messages in /var/log/messages
> > >=20
> > > May 27 08:03:29 intel-waimeabay-hedt-01 systemd:
> > > mdadm-grow-continue@md0.service: main process exited, code=3Dexited,
> > > status=3D1/FAILURE
> > > May 27 08:03:29 intel-waimeabay-hedt-01 systemd: Unit
> > > mdadm-grow-continue@md0.service entered failed state.
> > >=20
> >=20
> > Does
> >   systemctl status -l mdadm-grow-continue@md0.service
> >=20
> > report anything different.  That was the result I expected from removin=
g the
> > Standard*=3Dnull lines.
> >=20
> > I assume the new mdadm is installed in /usr/sbin/mdadm.
> >=20
> > Thanks,
> > NeilBrown
> >=20
>=20
> Yes! There are some new messages:
> [root@intel-waimeabay-hedt-01 ~]# systemctl status -l mdadm-grow-continue=
@md0.service
> mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
>    Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service; =
static)
>    Active: failed (Result: exit-code) since Thu 2015-05-28 02:30:50 EDT; =
2s ago
>   Process: 26618 ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I (c=
ode=3Dexited, status=3D1/FAILURE)
>  Main PID: 26618 (code=3Dexited, status=3D1/FAILURE)
>=20
> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]=
: Started Manage MD Reshape on /dev/md0.
> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com mdadm[2661=
8]: mdadm: Need to backup 6144K of critical section..
> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com mdadm[2661=
8]: mdadm: array: cannot open component /dev/vcs6
> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]=
: mdadm-grow-continue@md0.service: main process exited, code=3Dexited, stat=
us=3D1/FAILURE
> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]=
: Unit mdadm-grow-continue@md0.service entered failed state.

any idea why it cannot open it?

The message is probably coming from reshape_prepare_fdlist()
Could you get those "pr_err"s to print out errno as well?
The device really has to exist, because mdadm has managed to find that name
in /dev.  Could this be a 'selinux' related issue?  I can only think that it
might be a permission problem but root shouldn't have those.

Thanks,
NeilBrown

--Sig_/v9kOtvILBG+5lr9ztyrpAJ3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWa6dDnsnt1WYoG5AQJ0iw//azKMrK3Ixp4nMdahxIX2kMMIUMYpx6D0
SQ4D/BnaqTtCRCy5mNMgUvey7Pw+Sd1dgdNFy3YrjI3Atm2jWYBl8w32qtJ3slMZ
Ia0MukqTq3IJItpTotnmPgM9dRgPYwzeddvWsWjJSLRDJ4CfXhpFMGiluvQnZ9Cu
HXkGpOgHzdRKwzfFKoWG5YEAPuCtZWk0NHSlk3lS9fbGHCDJDMHX2lcxPicE8OY/
CTNLfK8oano9GizN5rPatX2YfxHH1mbVhyGAHjRbi4jzDCBiYxoZzANfAY9jSbRM
pP9w9bV6oSXdel9Z9HDKq7pRXk7vadQ4Aa2DV0+kN/2707J4XD64fGhBcoe5zQKe
a8yKPE5O6+2plj2T6eCHX/j+soORNgDKJukRrcM4HAopJ8symdgcr+I6/kEJNphO
Q/JCBS4+4jyz5t419Q3kA7ljAVC0xmysO0MLkf+CVzMxWc0g+6WcovZE8iu66zJv
/wu11G8YA5LDGhmAFBuPEp42Ii4uzcJxdcC9DR7QS+VL/LDLSUewrYu2RFwLwajU
MsgH0/tsq6u0mB+8BRQJoR/QHNcxD4TYZgh+yOg0DGeLInucS9BOEIjN5vsaTSPf
SzEJqTylCoYvi7jtXMKHjJ6/krBXWtgB+/UY6olwBFgmzgrdvoyHEE2FuRlEAAXP
1BLZO2OpfAo=
=76W6
-----END PGP SIGNATURE-----

--Sig_/v9kOtvILBG+5lr9ztyrpAJ3--
