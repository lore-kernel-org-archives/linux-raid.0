From: NeilBrown <neilb@suse.de>
Subject: Re: raid 5 to raid 6 reshape gone bad
Date: Sun, 13 Nov 2011 14:35:04 +1100
Message-ID: <20111113143504.7b1f75b1@notabene.brown>
References: <E427BB45-7AA7-422C-AAFE-9778286BF64C@jetcom.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1H2Jvc5h01aa6mtkyCrlhRf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E427BB45-7AA7-422C-AAFE-9778286BF64C@jetcom.org>
Sender: linux-raid-owner@vger.kernel.org
To: Travis Brown <teb@jetcom.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1H2Jvc5h01aa6mtkyCrlhRf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Nov 2011 21:56:56 -0500 Travis Brown <teb@jetcom.org> wrote:

> I was reshaping my 5 drive raid 5 with spare to a raid 6 array when the d=
rive I was using for my backup went offline.  If that's not murphy's law, I=
 don't know what is.  The array is still up and usable, but I'm afraid to r=
eboot or doing anything to it, really.  Suggestions on getting this thing b=
ack to usable are very welcome.=20
>=20
> Thanks,
> Travis
>=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md126 : active raid6 sde3[0] sdf3[3] sdb3[1] sdd3[4] sdc3[2]
>       5856728064 blocks super 0.91 level 6, 512k chunk, algorithm 18 [5/4=
] [UUUU_]
>       [>....................]  reshape =3D  0.9% (19267584/1952242688) fi=
nish=3D623878.3min speed=3D51K/sec

1/ Don't Panic. =20
   You seem to have achieved this step quite effectively - congratulations.

2/ Stop the array cleanly.  Not having a backup will only cause possible
   corruption if the machine crashes while the reshape is happening.  The
   reshape has stopped so there is no chance for corruption.  But you still
   need to cleanly stop the array.
   (A subsequent version of mdadm may allow you to continue the reshape
   without the stop/restart step, but we aren't there yet).

3/ Make sure you have a version of mdadm which is at least 3.2.   I would
   suggest the latest:3.2.2.  You particularly need the --invalid-backup
   flag.

4/ Reassemble the array with e.g.

    mdadm --assemble /dev/md126 --backup=3D/some/file  \
    --invalid-backup /dev/sd[bcdef]3


   The  backup file does not need to exist (I think).  Maybe create an empty
   file and use that just to be safe.
   The "--invalid-backup" flag says to mdadm "Yes, I know the backup file is
   currently invalid and you cannot restore anything from it.  I happen to
   know that there is no need to restore anything because I did a clean
   shutdown.  Just use the backup file for making new backups as you contin=
ue
   the reshape".

NeilBrown


>=20
> /dev/md126:
>         Version : 0.91
>   Creation Time : Wed Nov 10 20:19:03 2010
>      Raid Level : raid6
>      Array Size : 5856728064 (5585.41 GiB 5997.29 GB)
>   Used Dev Size : 1952242688 (1861.80 GiB 1999.10 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 126
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sat Nov 12 21:55:46 2011
>           State : clean, degraded, recovering
>  Active Devices : 4
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>          Layout : left-symmetric-6
>      Chunk Size : 512K
>=20
>  Reshape Status : 0% complete
>      New Layout : left-symmetric
>=20
>            UUID : 3fd8b303:7727aa3b:c5d110f2:f9137e1d
>          Events : 0.124051
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       67        0      active sync   /dev/sde3
>        1       8       19        1      active sync   /dev/sdb3
>        2       8       35        2      active sync   /dev/sdc3
>        3       8       83        3      active sync   /dev/sdf3
>        4       8       51        4      spare rebuilding   /dev/sdd3--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/1H2Jvc5h01aa6mtkyCrlhRf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIUAwUBTr867jnsnt1WYoG5AQJ7lg/1GBv+Nh+XgsOxY4yP/r1NAVkqfaacGMoP
CvfpUO/i/4d1ss1FZutwKZS15m96cr6kuGvbqyLI8HOOGvdumUFleCkXDEKiNsWs
jf0RAAGX/YFzctSELlkr4tfwNePF/jP18zeaSkjE2TT/4zf11fmeDyEjXhu0F9u9
P46B9sP5d89nlFqMEA6Oa6YTF2Dtcj+YN04a9bv6hKTMAIc9l23oYOTyYojWt97a
bvhJz2mY+C096adYrCaz7zru53qWImI9H4HNq9yKhanOSW+XC068AFo+LqVoqPH0
WTvKOtvPrTEkVkQsSkg9x8Qet/QYVVO9E+opgg3p3MjXgpbl783ZDN/aH0hF5+xN
LOLgclm4hdpDGB2Ut1OzOUFv1422H8bJ76Vrb+DBg7XLUNK6rYL0RoZQyUCoSgai
6rZeNopAHpmJT6VAUBDgNe9Q08TPnGTk42Wt6Msoq2d4t0nnLgoX6vWmud2hpU3S
5bIXMejcnBstTUKW+gFXS2NbLeapSbQVX62722F6qh+WqVm26whFG+gqFsVCTEeg
PpArQyuDe0NhK/G+yeglOzzHDDv4rYxNDNLAE/ji+HXrir+4NrLTjh3Yv2cxWRzE
NiR865wDj21v6RAkhDUys4OWNy6ww0A3MJTxRyMEUMwAL4w2+sruFyspXbfxM0zH
FS1zkFCQJQ==
=jX5c
-----END PGP SIGNATURE-----

--Sig_/1H2Jvc5h01aa6mtkyCrlhRf--
