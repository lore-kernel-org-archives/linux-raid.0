From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 reshape is stuck
Date: Mon, 25 May 2015 13:50:01 +1000
Message-ID: <20150525135001.43d1083a@notabene.brown>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
	<2043891461.15360424.1431673224036.JavaMail.zimbra@redhat.com>
	<20150521094837.6a2d29c4@notabene.brown>
	<1552584910.2141570.1432179477679.JavaMail.zimbra@redhat.com>
	<1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GPHRbI4A38cB+3+tHD4siHF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GPHRbI4A38cB+3+tHD4siHF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 May 2015 08:31:58 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

>=20
>=20
> ----- Original Message -----
> > From: "Xiao Ni" <xni@redhat.com>
> > To: "NeilBrown" <neilb@suse.de>
> > Cc: linux-raid@vger.kernel.org
> > Sent: Thursday, May 21, 2015 11:37:57 AM
> > Subject: Re: raid5 reshape is stuck
> >=20
> >=20
> >=20
> > ----- Original Message -----
> > > From: "NeilBrown" <neilb@suse.de>
> > > To: "Xiao Ni" <xni@redhat.com>
> > > Cc: linux-raid@vger.kernel.org
> > > Sent: Thursday, May 21, 2015 7:48:37 AM
> > > Subject: Re: raid5 reshape is stuck
> > >=20
> > > On Fri, 15 May 2015 03:00:24 -0400 (EDT) Xiao Ni <xni@redhat.com> wro=
te:
> > >=20
> > > > Hi Neil
> > > >=20
> > > >    I encounter the problem when I reshape a 4-disks raid5 to raid5.=
 It
> > > >    just
> > > >    can
> > > > appear with loop devices.
> > > >=20
> > > >    The steps are:
> > > >=20
> > > > [root@dhcp-12-158 mdadm-3.3.2]# mdadm -CR /dev/md0 -l5 -n5 /dev/loo=
p[0-4]
> > > > --assume-clean
> > > > mdadm: /dev/loop0 appears to be part of a raid array:
> > > >        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> > > > mdadm: /dev/loop1 appears to be part of a raid array:
> > > >        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> > > > mdadm: /dev/loop2 appears to be part of a raid array:
> > > >        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> > > > mdadm: /dev/loop3 appears to be part of a raid array:
> > > >        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> > > > mdadm: /dev/loop4 appears to be part of a raid array:
> > > >        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> > > > mdadm: Defaulting to version 1.2 metadata
> > > > mdadm: array /dev/md0 started.
> > > > [root@dhcp-12-158 mdadm-3.3.2]# mdadm /dev/md0 -a /dev/loop5
> > > > mdadm: added /dev/loop5
> > > > [root@dhcp-12-158 mdadm-3.3.2]# mdadm --grow /dev/md0 --raid-device=
s 6
> > > > mdadm: Need to backup 10240K of critical section..
> > > > [root@dhcp-12-158 mdadm-3.3.2]# cat /proc/mdstat
> > > > Personalities : [raid6] [raid5] [raid4]
> > > > md0 : active raid5 loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loo=
p0[0]
> > > >       8187904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/=
6]
> > > >       [UUUUUU]
> > > >       [>....................]  reshape =3D  0.0% (0/2046976)
> > > >       finish=3D6396.8min
> > > >       speed=3D0K/sec
> > > >      =20
> > > > unused devices: <none>
> > > >=20
> > > >    It because the sync_max is set to 0 when run the command --grow
> > > >=20
> > > > [root@dhcp-12-158 mdadm-3.3.2]# cd /sys/block/md0/md/
> > > > [root@dhcp-12-158 md]# cat sync_max
> > > > 0
> > > >=20
> > > >    I tried reproduce with normal sata devices. The progress of resh=
ape is
> > > >    no problem. Then
> > > > I checked the Grow.c. If I use sata devices, in function reshape_ar=
ray,
> > > > the
> > > > return value
> > > > of set_new_data_offset is 0. But if I used loop devices, it return =
1.
> > > > Then
> > > > it call the function
> > > > start_reshape.
> > >=20
> > > set_new_data_offset returns '0' if there is room on the devices to re=
duce
> > > the
> > > data offset so that the reshape starts writing to unused space on the
> > > array.
> > > This removes the need for a backup file, or the use of a spare device=
 to
> > > store a temporary backup.
> > > It returns '1' if there was no room for relocating the data_offset.
> > >=20
> > > So on your sata devices (which are presumably larger than your loop
> > > devices)
> > > there was room.  On your loop devices there was not.
> > >=20
> > >=20
> > > >=20
> > > >    In the function start_reshape it set the sync_max to reshape_pro=
gress.
> > > >    But in sysfs_read it
> > > > doesn't read reshape_progress. So it's 0 and the sync_max is set to=
 0.
> > > > Why
> > > > it need to set the
> > > > sync_max at this? I'm not sure about this.
> > >=20
> > > sync_max is set to 0 so that the reshape does not start until the bac=
kup
> > > has
> > > been taken.
> > > Once the backup is taken, child_monitor() should set sync_max to "max=
".
> > >=20
> > > Can you  check if that is happening?
> > >=20
> > > Thanks,
> > > NeilBrown
> > >=20
> > >=20
> >=20
> >   Thanks very much for the explaining. The problem maybe is fixed. I tr=
ied
> >   reproduce this with newest
> > kernel and newest mdadm. Now the problem don't exist. I'll do more test=
s and
> > give the answer above later.
> >=20
>=20
> Hi Neil
>=20
>    As you said, it doesn't enter child monitor. The problem still exist.
>=20
> The kernel version :
> [root@intel-canoepass-02 tmp]# uname -r
> 4.0.4
>=20
> mdadm I used is the newest git code from git://git.neil.brown.name/mdadm.=
git
>=20
>   =20
>    In the function continue_via_systemd the parent find pid is bigger tha=
n 0 and
> status is 0. So it return 1. So it have no opportunity to call child_moni=
tor.

If continue_via_systemd succeeded, that implies that=20
  systemctl start mdadm-grow-continue@mdXXX.service

succeeded.  So=20
   mdadm --grow --continue /dev/mdXXX

was run, so that mdadm should call 'child_monitor' and update sync_max when
appropriate.  Can you check if it does?


>=20
>=20
>    And if it want to set sync_max to 0 until the backup has been taken. W=
hy does not=20
> set sync_max to 0 directly, but use the value reshape_progress? There is =
a little confused.

When reshaping an array to a different array of the same size, such as a
4-driver RAID5 to a 5-driver RAID6, then mdadm needs to backup, one piece at
a time, the entire array (unless it can change data_offset, which is a
relatively new ability).

If you stop an array when it is in the middle of such a reshape, and then
reassemble the array, the backup process need to recommence where it left o=
ff.
So it tells the kernel that the reshape can progress as far as where it was
up to before.  So 'sync_max' is set based on the value of 'reshape_progress=
'.
(This will happen almost instantly).

Then the background mdadm (or the mdadm started by systemd) will backup the
next few stripes, update sync_max, wait for those stripes to be reshaped, t=
hen
discard the old backup, create a new one of the few stripes after that, and
continue.

Does that make it a little clearer?

And in response to your other email:
>     Does it should return 1 when pid > 0 and status is not zero?

No.  continue_via_systemd should return 1 precisely when the 'systemctl'
command was successfully run.  So 'status' must be zero.


Thanks,
NeilBrown




>=20
> Best Regards
> Xiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/GPHRbI4A38cB+3+tHD4siHF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKb6Tnsnt1WYoG5AQKTDw//bmuRUvcMAYRPaU/QAIA8h5mrPisuTv8+
5DkqsB3Gtg4uGDSvxC4vnXK0NFpuScS71QDBKCTE6P/ITvzOrZ+6dBNDYn8HI2iP
Mnd65xaMu0q1RaB+F0D5OJZOhc729ThVnGaDc5ytPUdpyg/xXTeN/lgZwSgB/Gx0
QQIiJCAiaOSVXPwg+S6AIcDOKCA6VtgCaZBTH6TmKdaiLJbLLsrpjNNc3s3Sop3U
erllDqTVqdtVc+TsfEvRyCpZ89id9tcdOfqJcqOiWHKxVHmn4ML/ZY75Oj7h6R04
yawgLCsj5D4QC3jErFx2oJIhGGyZZhM1g7P4nphi1prHwJ6QZFtMbuN1MTt1sAI1
zzCUDVoqE3gpuKAe/V41wxg/WIRiuOD/EnjBanBPQp5vicHD3YbE0sBu7d3skC0B
WHEMypfFpaV41NXPMC3J0Nlw7rvJGgG3aAr7aLgYvqv0zFrZZaRmx/pyq6l2a/jy
35B7kO3/nxX/05BwjlDS6vVwQOSyANxcdRfZIPRJBWZ2qwCqhAYDF1cHBVQdiuQg
zY1O4cyjKMB9GksY1y5sxwTFIto5ELNdgLknqx5J0CefaZkI/mBq7KM+x7Zbd/tg
qsN0BOVd7drNyxaBAyfs3/2UBAx2dQcocjqblGgiTfemow8P5TsBdui86P751XM1
DI9+fcCCo1s=
=td3o
-----END PGP SIGNATURE-----

--Sig_/GPHRbI4A38cB+3+tHD4siHF--
