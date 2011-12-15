From: NeilBrown <neilb@suse.de>
Subject: Re: ''force'' continutation of a rebuild?
Date: Fri, 16 Dec 2011 07:53:37 +1100
Message-ID: <20111216075337.43b1e07c@notabene.brown>
References: <3b2qr8xpq2.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XYgkMs7k4J4KXoxBar1.zh0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3b2qr8xpq2.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/XYgkMs7k4J4KXoxBar1.zh0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011 12:36:19 -0800 Keith Keller
<kkeller@wombat.san-francisco.ca.us> wrote:

>=20
> Hello all,
>=20
> I have another seminewbie question.  I had an issue, likely hardware
> related, which forced me to reboot a machine with a RAID6 during a
> rebuild after a previous drive failure.  Now, after some other hardware
> issues, I've been able to successfully assemble the array, but it
> seems to be in an odd state:
>=20
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.01
>   Creation Time : Thu Sep 29 21:26:35 2011
>      Raid Level : raid6
>      Array Size : 13671797440 (13038.44 GiB 13999.92 GB)
>   Used Dev Size : 1953113920 (1862.63 GiB 1999.99 GB)
>    Raid Devices : 9
>   Total Devices : 11
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Thu Dec 15 12:19:41 2011
>           State : clean, degraded
>  Active Devices : 8
> Working Devices : 11
>  Failed Devices : 0
>   Spare Devices : 3
>=20
>      Chunk Size : 64K
>=20
>            Name : 0
>            UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
>          Events : 102730
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        6       8      113        1      active sync   /dev/sdh1
>       11       8      177        2      spare rebuilding   /dev/sdl1
>        3       8       65        3      active sync   /dev/sde1
>        4       8       81        4      active sync   /dev/sdf1
>        9       8      145        5      active sync   /dev/sdj1
>       10       8       97        6      active sync   /dev/sdg1
>        7       8      129        7      active sync   /dev/sdi1
>        8       8      161        8      active sync   /dev/sdk1
>=20
>       12       8      225        -      spare   /dev/sdo1
>       13       8       49        -      spare   /dev/sdd1
>=20
> # cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md0 : active raid6 sdd1[13](S) sdb1[0] sdo1[12](S) sdk1[8] sdi1[7]
> sdg1[10] sdj1[9] sdf1[4] sde1[3] sdl1[11] sdh1[6]
>       13671797440 blocks super 1.1 level 6, 64k chunk, algorithm 2 [9/8]
> [UU_UUUUUU]
>      =20
> unused devices: <none>
>=20
> I'm interpreting this as that a member is missing, but for some reason
> the rebuild on sdl1 has not restarted.=20

Golly, you must be running an ancient kernel ... I fixed this bug at least 2
days ago...  Though admittedly I haven't submitted the fix yet so maybe you
have a good excuse :-)


If you remove both spares:
  mdadm /dev/md0 --remove /dev/sdo1 /dev/sdd1

the rebuild should start.  You can then add them back again "--add".

http://neil.brown.name/git?p=3Dmd;a=3Dcommitdiff;h=3Dbd8c7cf40d56ca9ce3a6f7=
2886914193674258d1


> What would be the next logical step to take?=20

Send an email to linux-raid asking who broke what..  Oh wait, you did that.

NeilBrown



> I've found some posts which imply that setting sync_action
> to repair will work, but I'm a little wary of doing that without knowing
> how risky that is.  Or, reading Documentation/md.txt, perhaps I should
> set it to "recover"?  Or "resync", since it's possible the array was not
> shut down cleanly?
>=20
> FWIW, I have started the array, activated the LVM volume, and am running
> xfs_repair -n (which is not supposed to do any writes), but otherwise
> haven't risked modifying the filesystem (e.g., by mounting it).  So far
> the xfs_repair seems fine, and has not reported any errors.
>=20
> Thanks for your help (and patience).
>=20
> --keith
>=20


--Sig_/XYgkMs7k4J4KXoxBar1.zh0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTupeUTnsnt1WYoG5AQJ42A/9E8EJQl/0FAiu01zZk/whQZlk7pN9NMDV
XcRCfA7O3faheqUH/R+6K4RWHdMVfdVI6200OrX3XI81dZQ9gQz6ZgcspNk7CwO0
ooIjOtu/OcuQ3/MgsbHcagsUdAgUY/Dw3enff8sDOj1GVRecd8KGG0nrEA4UwnAv
jVAuddqmSXPeahe1CFNi9UN0NPTfhEKUjj4f3H3fRpBNm8Ir1UyD+Me+j3Vg8SQQ
XQYuzQXiYyElyXduCljdmOPo3pfBZjXGXtnjIlpqQdWPgp07cGnJmLhRLacSEf3V
/Vv03b2UmGD94WyG4z5d9XdKslV7geJcYFy1p/rf0qp05BGSM5qWw2CIRdTLG6BS
sq1aojv2hQHT2mWtDKQdbQcBZnzxOv8WHL2eps3RD5Y2Qqq08d6ITTaypYWOtW9H
uGl99gVc/n6GJWgoad/Hbi+nGH4grMoytILNWVS7nXZ/r1ERlPgJDUycXXg9aOm8
le8ILtrCXtGLqRCB666P8JJV7FFGGlopQFwdvxhtX7KDXEvCLWZG+N2sM/Csd0UG
eIvtxu24i6CpBsWGjVGivvlJrBHbNRuEPgMsfxsdFaVR3ZXxJLS9fWnL5BBLGoN9
q0FFlQwJNTjRFhhoaQKBF5pK/QytNRc7HsNjcJXqR78kteiZjsKmYfZixO9kcVz5
hpklaVuyFX4=
=o8d1
-----END PGP SIGNATURE-----

--Sig_/XYgkMs7k4J4KXoxBar1.zh0--
