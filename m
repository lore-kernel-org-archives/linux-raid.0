From: NeilBrown <neilb@suse.de>
Subject: Re: raid 5 to raid 6 reshape gone bad
Date: Mon, 14 Nov 2011 17:07:23 +1100
Message-ID: <20111114170723.13111cc8@notabene.brown>
References: <E427BB45-7AA7-422C-AAFE-9778286BF64C@jetcom.org>
	<20111113143504.7b1f75b1@notabene.brown>
	<30AB4A6F-B40A-43BB-80E5-FDAC2AE2FF97@jetcom.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s7llxf2PgdU7Xdd70aYU8jk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30AB4A6F-B40A-43BB-80E5-FDAC2AE2FF97@jetcom.org>
Sender: linux-raid-owner@vger.kernel.org
To: Travis Brown <teb@jetcom.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/s7llxf2PgdU7Xdd70aYU8jk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 13 Nov 2011 09:53:52 -0500 Travis Brown <teb@jetcom.org> wrote:

> So I have the RAID rebuilding and the the output of /proc/mdstat look ok =
(I think):
>=20
> root@bravo:~# cat /proc/mdstat=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md126 : active raid6 sde3[0] sdd3[4] sdf3[3] sdb3[1]
>       5856728064 blocks super 0.91 level 6, 512k chunk, algorithm 18 [5/3=
] [UU_U_]
>       [>....................]  reshape =3D  2.0% (39448064/1952242688) fi=
nish=3D7375.5min speed=3D4321K/sec
>      =20
> md11 : active raid6 sde2[0] sdb2[1] sdd2[4] sdc2[2] sdf2[3]
>       3180672 blocks level 6, 64k chunk, algorithm 2 [5/5] [UUUUU]
>      =20
> md10 : active raid1 sde1[0] sdb1[1] sdd1[4] sdf1[3] sdc1[2]
>       208704 blocks [5/5] [UUUUU]
>      =20
> unused devices: <none>
>=20
>=20
>=20
> But mdadm --detail /dev/md126 now shows I have a drive removed:

That is unfortunate.  It looks like sdc3 didn't make it back into the array
when you re-assembled it.  I wonder why not?   Any kernel logs from when you
started the array.

Your RAID6 is now double-degraded so another failure would be bad.  Should =
be
unlikely though.
As soon as the reshape finished you need to see about adding sdc3 back in to
the array so that it rebuilds.  The rebuild will be a lot faster than the
reshape is.

Best thing to do now is to just leave it reshaping.  However if there are
some really important files that you could conveniently back up, now might =
be
a good time, just in case.

NeilBrown




>=20
> /dev/md126:
>         Version : 0.91
>   Creation Time : Wed Nov 10 20:19:03 2010
>      Raid Level : raid6
>      Array Size : 5856728064 (5585.41 GiB 5997.29 GB)
>   Used Dev Size : 1952242688 (1861.80 GiB 1999.10 GB)
>    Raid Devices : 5
>   Total Devices : 4
> Preferred Minor : 126
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sun Nov 13 09:50:52 2011
>           State : active, degraded, recovering
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>          Layout : left-symmetric-6
>      Chunk Size : 512K
>=20
>  Reshape Status : 2% complete
>      New Layout : left-symmetric
>=20
>            UUID : 3fd8b303:7727aa3b:c5d110f2:f9137e1d
>          Events : 0.172355
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       67        0      active sync   /dev/sde3
>        1       8       19        1      active sync   /dev/sdb3
>        2       0        0        2      removed
>        3       8       83        3      active sync   /dev/sdf3
>        4       8       51        4      spare rebuilding   /dev/sdd3
>=20
> Is that expected?
>=20
> Thanks again. I am pretty confident all my data is there, and I do have a=
 (1-day old) backup of the important stuff, but the other 2.5TB of stuff is=
n't really /that/ important, but I don't want to have to explain to the wif=
e why all her favorite episodes of NCIS that she recorded are gone :)
>=20
> Thanks,
> Travis
>=20
> On Nov 12, 2011, at 10:35 PM, NeilBrown wrote:
>=20
> > On Sat, 12 Nov 2011 21:56:56 -0500 Travis Brown <teb@jetcom.org> wrote:
> >=20
> >> I was reshaping my 5 drive raid 5 with spare to a raid 6 array when th=
e drive I was using for my backup went offline.  If that's not murphy's law=
, I don't know what is.  The array is still up and usable, but I'm afraid t=
o reboot or doing anything to it, really.  Suggestions on getting this thin=
g back to usable are very welcome.=20
> >>=20
> >> Thanks,
> >> Travis
> >>=20
> >> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [=
raid4] [raid10]=20
> >> md126 : active raid6 sde3[0] sdf3[3] sdb3[1] sdd3[4] sdc3[2]
> >>      5856728064 blocks super 0.91 level 6, 512k chunk, algorithm 18 [5=
/4] [UUUU_]
> >>      [>....................]  reshape =3D  0.9% (19267584/1952242688) =
finish=3D623878.3min speed=3D51K/sec
> >=20
> > 1/ Don't Panic. =20
> >   You seem to have achieved this step quite effectively - congratulatio=
ns.
> >=20
> > 2/ Stop the array cleanly.  Not having a backup will only cause possible
> >   corruption if the machine crashes while the reshape is happening.  The
> >   reshape has stopped so there is no chance for corruption.  But you st=
ill
> >   need to cleanly stop the array.
> >   (A subsequent version of mdadm may allow you to continue the reshape
> >   without the stop/restart step, but we aren't there yet).
> >=20
> > 3/ Make sure you have a version of mdadm which is at least 3.2.   I wou=
ld
> >   suggest the latest:3.2.2.  You particularly need the --invalid-backup
> >   flag.
> >=20
> > 4/ Reassemble the array with e.g.
> >=20
> >    mdadm --assemble /dev/md126 --backup=3D/some/file  \
> >    --invalid-backup /dev/sd[bcdef]3
> >=20
> >=20
> >   The  backup file does not need to exist (I think).  Maybe create an e=
mpty
> >   file and use that just to be safe.
> >   The "--invalid-backup" flag says to mdadm "Yes, I know the backup fil=
e is
> >   currently invalid and you cannot restore anything from it.  I happen =
to
> >   know that there is no need to restore anything because I did a clean
> >   shutdown.  Just use the backup file for making new backups as you con=
tinue
> >   the reshape".
> >=20
> > NeilBrown
> >=20
> >=20
> >>=20
> >> /dev/md126:
> >>        Version : 0.91
> >>  Creation Time : Wed Nov 10 20:19:03 2010
> >>     Raid Level : raid6
> >>     Array Size : 5856728064 (5585.41 GiB 5997.29 GB)
> >>  Used Dev Size : 1952242688 (1861.80 GiB 1999.10 GB)
> >>   Raid Devices : 5
> >>  Total Devices : 5
> >> Preferred Minor : 126
> >>    Persistence : Superblock is persistent
> >>=20
> >>    Update Time : Sat Nov 12 21:55:46 2011
> >>          State : clean, degraded, recovering
> >> Active Devices : 4
> >> Working Devices : 5
> >> Failed Devices : 0
> >>  Spare Devices : 1
> >>=20
> >>         Layout : left-symmetric-6
> >>     Chunk Size : 512K
> >>=20
> >> Reshape Status : 0% complete
> >>     New Layout : left-symmetric
> >>=20
> >>           UUID : 3fd8b303:7727aa3b:c5d110f2:f9137e1d
> >>         Events : 0.124051
> >>=20
> >>    Number   Major   Minor   RaidDevice State
> >>       0       8       67        0      active sync   /dev/sde3
> >>       1       8       19        1      active sync   /dev/sdb3
> >>       2       8       35        2      active sync   /dev/sdc3
> >>       3       8       83        3      active sync   /dev/sdf3
> >>       4       8       51        4      spare rebuilding   /dev/sdd3--
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/s7llxf2PgdU7Xdd70aYU8jk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsCwGznsnt1WYoG5AQJQ5hAAt39L8izcDpyedgCD+io6ykIRjeUOIK9y
JRaknrBnnHHbAcg2G6Fr7nJ2auaTAVctIaKlTptiFHBAIJFBzJXQyKxpyrN88VYp
qg3PQeduP6lbl8SJm+DFjSIhjxBbxPx6Zr8ACTF6BRoZSkDDehM4BHVX8kXg0CU0
THJ3CTe+gKn+dcNkefpnPWlC1Vj2IyXBDo2B0P3ha0g4/8yzcgw8zfMeAMwZRijR
Tb5bSTKdoNbYtjfGWNnEi7JblVnbT+J7l6QLUYoGZim2xQ7Kr0vZICXzMRTVpfPP
BHWPHcDAiPhDOPZrRlFhmvNwllUNO/MR2SWpbSGOmduCiFds9sW3HjC82VraY1yk
rbFtlcZ4/UwQEaI2mbR0ru8pau1tYZ3ocTi0ADoJAKfBL+P0sRFDLp1xkO0s6gt7
pg02FnOuJbSGQB2NmwG/93l7xdwvkm/f8IEGvS5S4CUuJ3L4AsiW9SihxWuFU/5/
Hc7Iwh+Z04cQ4pLQJn1l8+bFH9em3C9Nu+BJneDZs/U0Cv+A8NsbVV6wZ2WiRbIP
zsWBwvVlapkYQXv9GOXKzHMAEGljsYnw295Og1NIuM0BOQI0WglKLKPP7qC2Y33q
Wr9lJwFsrRhq0gta4xxyxmIvLhDq7AIIzNYqL+yw8Skwe7VOQsa2d+0r+qkudAEG
/oJBtEo+vNw=
=7fiQ
-----END PGP SIGNATURE-----

--Sig_/s7llxf2PgdU7Xdd70aYU8jk--
