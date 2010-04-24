From: Neil Brown <neilb@suse.de>
Subject: Re: superblock error after power failure ---on an old system
Date: Sat, 24 Apr 2010 21:47:44 +1000
Message-ID: <20100424214744.284ccadc@notabene.brown>
References: <h2g4dfc23d1004240409s2409f02i2b99c50473ae4301@mail.gmail.com>
	<i2z4dfc23d1004240418k4fb43ed6q10a3624ae9fb008@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <i2z4dfc23d1004240418k4fb43ed6q10a3624ae9fb008@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wierdl =?UTF-8?B?TcOhdMOp?= <wierdlmate@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 24 Apr 2010 06:18:57 -0500
Wierdl M=C3=A1t=C3=A9 <wierdlmate@gmail.com> wrote:

> Hello,
>=20
> I have an old Dell Poweredge 2500 server running Fedora Core 3. The
> server=C2=A0 had one of its power units failed, and (I think) as a re=
sult,
> the raid arrays got damaged: three of them stayed alive (though
> degraded), but one is not accessible. Unfortunately, the server only
> has a floppy drive which doesn't work now, and so I cannot get any
> files, command outputs directly off the box.=C2=A0 I copy it all from=
 the
> screen.
>=20
> The array I cannot access is md3. It has the shared libraries on it s=
o
> many commands do not work. In particular, I cannot have remote access
> to the box.
>=20
> =C2=A0The output of
>=20
> mdadm -Es
>=20
> is (I am not copying the UUIDs)
>=20
> ARRAY /dev/md0 level=3Draid1 num-devices=3D2 devices=3D/dev/sdb2,/dev=
/sdc2
> ARRAY /dev/md2 level=3Draid1 num-devices=3D2 devices=3D/dev/sda6,/dev=
/sdc3
> ARRAY /dev/md3 level=3Draid5 num-devices=3D3 devices=3D/dev/sda3,/dev=
/sdb1,/dev/sdc1
> ARRAY /dev/md1 level=3Draid1 num-devices=3D2 devices=3D/dev/sda1,/dev=
/sda2
>=20
> Also
>=20
> md0=C2=A0 mounted at /
> md2 mounted at /var
> md1=C2=A0 mounted at /boot
> md3 should be mounted at /home
>=20
> # cat /proc/mdstat
> Personalities: raid1 raid5
> md1: active raid1 sda2[1] sda1[0]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 104320 blocks [2/2] =
[UU]
>=20
> md2: active raid1 sda6[0]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 513984 blocks [2/1] =
[U_]
>=20
> md0: active raid1 sdc2[1]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1534080 blocks [2/1] [_U]
>=20
> unused devices: none
>=20
> # mdadm --detail /dev/md3
> mdadm: md device /dev/md3 does not appear to be active
>=20
> At somebody's suggestion I tried
>=20
> mdadm --assemble --scan /dev/md0
>=20
> and got
>=20
> /dev/sda has no superblock - assembly aborted
>=20
> Then tried
>=20
> mdadm =C2=A0--force --run /dev/md3
>=20
> and got
>=20
> failed to run array /dev/md3: Invalid argument
>=20
> I finally tried
>=20
> # mdadm --assemble /dev/md3 /dev/sda3 /dev/sdb1 /dev/sdc1
> mdadm: device 1 in=C2=A0 /dev/md3 has wrong state superblock, but /de=
v/sdb1 seems ok

That looks close.  Just add "--force" to that and it will probably get
you going.

NeilBrown


>=20
> Thanks for any help. I certainly would give remote access to a helpin=
g
> hand, but unfortunately the box cannot run sshd: the shared libraries
> are on the md3 array.
>=20
> M=C3=A1t=C3=A9
>=20
> M=C3=A1t=C3=A9 Wierdl
> Dept of Math Sci, Univ of Memphis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
