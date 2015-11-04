From: Xiao Ni <xni@redhat.com>
Subject: Re: raid6 stuck at reshape
Date: Wed, 4 Nov 2015 02:36:26 -0500 (EST)
Message-ID: <1721474289.3226622.1446622586738.JavaMail.zimbra@redhat.com>
References: <CAD1MkcxpYFx061bSzhTq_43tTPe_3Wz1unPP9LYRGrJJHXPnPw@mail.gmail.com> <1730338122.3157361.1446618347884.JavaMail.zimbra@redhat.com> <CAD1Mkcxb3RsQVUntVzYUtA+RuNLKNqYnejEaB+Q6b5Dof=+Gug@mail.gmail.com> <CAD1Mkcw2MdVsTqYkuyoMZpoRXqJidbkJhP+W+D6gvdsEDTBgZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAD1Mkcw2MdVsTqYkuyoMZpoRXqJidbkJhP+W+D6gvdsEDTBgZA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?B?0JjQstCw0L0g0JjRgdCw0LXQsg==?= <1@crownet.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When you run ps auxf | grep md, can you see a progress is stuck?
If you find it you can check the reason with crash utility.=20


----- Original Message -----
> From: "=D0=98=D0=B2=D0=B0=D0=BD =D0=98=D1=81=D0=B0=D0=B5=D0=B2" <1@cr=
ownet.ru>
> To: linux-raid@vger.kernel.org
> Sent: Wednesday, November 4, 2015 2:44:10 PM
> Subject: Fwd: raid6 stuck at reshape
>=20
> 1.  cat /sys/block/md3/md/sync_max
> 8192
> 2. no selinux
> 3.
> after recreate of array:
> # mdadm --grow --bitmap=3Dnone /dev/md3
> # mdadm --grow /dev/md3 --raid-devices=3D12 --backup-file=3D/home/rai=
d/md3.backup
> mdadm: Need to backup 106496K of critical section..
> mdadm: Recording backup file in /run/mdadm failed: File exists
> ...
> # cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] [lin=
ear]
> md3 : active raid6 sdn[11] sdm[10] sdl[9] sdj[8] sdg[7] sdh[6] sdi[5]
> sdk[4] sdf[3] sde[2] sdd[1] sdc[0]
>       26328453120 blocks super 1.2 level 6, 4096k chunk, algorithm 2
> [12/12] [UUUUUUUUUUUU]
>       [>....................]  reshape =3D  0.0% (_4096_/2925383680)
> finish=3D3758695.2min speed=3D12K/sec
>=20
> no changes.
>=20
> 2015-11-04 13:25 GMT+07:00 Xiao Ni <xni@redhat.com>:
> > Hi
> >
> > You can check the sync_max whether it's 0.
> >
> > [root@storageqe-19 ~]# cd /sys/block/md1/md/
> > [root@storageqe-19 md]# cat sync_max
> > 0
> >
> > And check selinux:
> > [root@storageqe-19 ~]# systemctl status mdadm-grow-continue@md1.ser=
vice
> > =E2=97=8F mdadm-grow-continue@md1.service - Manage MD Reshape on /d=
ev/md1
> >    Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.ser=
vice;
> >    static; vendor preset: disabled)
> >    Active: failed (Result: exit-code) since Tue 2015-11-03 03:39:11=
 EST;
> >    21h ago
> >   Process: 2353 ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/=
%I
> >   (code=3Dexited, status=3D2)
> >  Main PID: 2353 (code=3Dexited, status=3D2)
> >
> > Nov 03 03:39:10 storageqe-19.rhts.eng.bos.redhat.com systemd[1]: St=
arted
> > Manage MD Reshape on /dev/md1.
> > Nov 03 03:39:10 storageqe-19.rhts.eng.bos.redhat.com systemd[1]: St=
arting
> > Manage MD Reshape on /dev/md1...
> > Nov 03 03:39:11 storageqe-19.rhts.eng.bos.redhat.com systemd[1]:
> > mdadm-grow-continue@md1.service: main process exite...ENT
> > Nov 03 03:39:11 storageqe-19.rhts.eng.bos.redhat.com systemd[1]: Un=
it
> > mdadm-grow-continue@md1.service entered failed...te.
> > Nov 03 03:39:11 storageqe-19.rhts.eng.bos.redhat.com systemd[1]:
> > mdadm-grow-continue@md1.service failed.
> > Hint: Some lines were ellipsized, use -l to show in full.
> >
> > I think this is a selinux-policy problem. And you can try reshape a=
 md
> > without bitmap.
> > It can success without bitmap.
> >
> > ----- Original Message -----
> >> From: "=D0=98=D0=B2=D0=B0=D0=BD =D0=98=D1=81=D0=B0=D0=B5=D0=B2" <1=
@crownet.ru>
> >> To: linux-raid@vger.kernel.org
> >> Sent: Wednesday, November 4, 2015 1:53:17 PM
> >> Subject: raid6 stuck at reshape
> >>
> >> 1. init state:
> >> md3 : active raid6 sdm[10] sdl[9] sdj[8] sdg[7] sdh[6] sdi[5] sdk[=
4]
> >> sdf[3] sde[2] sdd[1] sdc[0]
> >>       26328453120 blocks super 1.2 level 6, 4096k chunk, algorithm=
 2
> >> [11/11] [UUUUUUUUUUU]
> >>       bitmap: 0/22 pages [0KB], 65536KB chunk
> >>
> >> 2. mdadm /dev/md3 -a /dev/sdn
> >> mdadm --grow /dev/md3 --raid-devices=3D12
> >> --backup-file=3D/home/raid/md3.backup
> >>
> >> md3 : active raid6 sdn[11] sdm[10] sdl[9] sdj[8] sdg[7] sdh[6] sdi=
[5]
> >> sdk[4] sdf[3] sde[2] sdd[1] sdc[0]
> >>       26328453120 blocks super 1.2 level 6, 4096k chunk, algorithm=
 2
> >> [12/12] [UUUUUUUUUUUU]
> >>       [>....................]  reshape =3D  0.0% (0/2925383680)
> >> finish=3D3047274.6min speed=3D0K/sec
> >>       bitmap: 0/22 pages [0KB], 65536KB chunk
> >>
> >> # ps aux|grep md3
> >> root      5232 _54.8_  0.0      0     0 ?        R    10:55  56:43
> >> [md3_raid6]
> >> root      6956 _98.4_  0.4  53904 49896 ?        RL   11:01  96:29
> >> mdadm --grow /dev/md3 --raid-devices=3D12
> >> --backup-file=3D/home/raid/md3.backup
> >>
> >> # cat /sys/block/md3/md/reshape_position
> >> 81920
> >>
> >> what can I do about it?
> >>
> >> P.S. If I stop the array, it can no longer be assembled:
> >> # mdadm -S /dev/md3
> >> # mdadm -A /dev/md3
> >> mdadm: :/dev/md3 has an active reshape - checking if critical sect=
ion
> >> needs to be restored
> >> mdadm: Failed to restore critical section for reshape, sorry.
> >>
> >> mdadm --assemble /dev/md3 -vv --backup-file /home/raid/md3.backup =
-f
> >> mdadm: looking for devices for /dev/md3
> >> ...
> >> mdadm: /dev/sdn is identified as a member of /dev/md3, slot 11.
> >> mdadm: /dev/sdl is identified as a member of /dev/md3, slot 9.
> >> mdadm: /dev/sdg is identified as a member of /dev/md3, slot 7.
> >> mdadm: /dev/sdm is identified as a member of /dev/md3, slot 10.
> >> mdadm: /dev/sdj is identified as a member of /dev/md3, slot 8.
> >> mdadm: /dev/sdk is identified as a member of /dev/md3, slot 4.
> >> mdadm: /dev/sdf is identified as a member of /dev/md3, slot 3.
> >> mdadm: /dev/sdd is identified as a member of /dev/md3, slot 1.
> >> mdadm: /dev/sdi is identified as a member of /dev/md3, slot 5.
> >> mdadm: /dev/sdh is identified as a member of /dev/md3, slot 6.
> >> mdadm: /dev/sde is identified as a member of /dev/md3, slot 2.
> >> mdadm: /dev/sdc is identified as a member of /dev/md3, slot 0.
> >> mdadm: :/dev/md3 has an active reshape - checking if critical sect=
ion
> >> needs to be restored
> >> mdadm: restoring critical section
> >> mdadm: Error restoring backup from md3.backup
> >> mdadm: Failed to restore critical section for reshape, sorry.
> >>
> >> # mdadm --assemble /dev/md3 -vv --invalid-backup -f
> >> ...
> >> mdadm: :/dev/md3 has an active reshape - checking if critical sect=
ion
> >> needs to be restored
> >> mdadm: No backup metadata on device-11
> >> mdadm: Failed to find backup of critical section
> >> mdadm: continuing without restoring backup
> >> mdadm: added /dev/sdd to /dev/md3 as 1
> >> mdadm: added /dev/sde to /dev/md3 as 2
> >> mdadm: added /dev/sdf to /dev/md3 as 3
> >> mdadm: added /dev/sdk to /dev/md3 as 4
> >> mdadm: added /dev/sdi to /dev/md3 as 5
> >> mdadm: added /dev/sdh to /dev/md3 as 6
> >> mdadm: added /dev/sdg to /dev/md3 as 7
> >> mdadm: added /dev/sdj to /dev/md3 as 8
> >> mdadm: added /dev/sdl to /dev/md3 as 9
> >> mdadm: added /dev/sdm to /dev/md3 as 10
> >> mdadm: added /dev/sdn to /dev/md3 as 11
> >> mdadm: added /dev/sdc to /dev/md3 as 0
> >> mdadm: failed to RUN_ARRAY /dev/md3: Invalid argument
> >>
> >> I had to create array again.
> >> After that the array is operating normally, but I still can't grow=
 it.
> >>
> >> P.S.S. kernel: 3.14.56
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
