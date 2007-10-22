From: Nagilum <nagilum@nagilum.org>
Subject: Re: Fwd: issues rebuilding raid array.
Date: Mon, 22 Oct 2007 18:44:43 +0200
Message-ID: <20071022184443.2mn50tmug4swosoc@cakebox.homeunix.net>
References: <8a16822a0710220445i3175a624g5b92535ca3797517@mail.gmail.com>
	<8a16822a0710220446y1d360965m2f705842e5940932@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_55b7zi99xu4o";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8a16822a0710220446y1d360965m2f705842e5940932@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Redfern <sredfern@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_55b7zi99xu4o
Content-Type: multipart/mixed;
	boundary="=_55ixjbhph8so"
Content-Transfer-Encoding: 7bit

This message is in MIME format.

--=_55ixjbhph8so
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from sredfern@gmail.com ---------
     Date: Mon, 22 Oct 2007 21:46:08 +1000
     From: Sam Redfern <sredfern@gmail.com>
Reply-To: Sam Redfern <sredfern@gmail.com>
  Subject: Fwd: issues rebuilding raid array.
       To: linux-raid@vger.kernel.org


> The array was build using 2.6.18-7 Now i'm using  2.6.21-2
>
> I'm trying to recreate the raid array with the following command and
> this is the error I get:
>
> mca4:~# mdadm -Av /dev/md1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
> /dev/sdf /dev/sdg
> mdadm: looking for devices for /dev/md1
> mdadm: no RAID superblock on /dev/sdc
> mdadm: /dev/sdc has no superblock - assembly aborted
>
> So I figure, oh look the disk sdc has gone cactus, I'll just remove it
> from the list. One of the advantages of mdadm.
>
> mca4:~# mdadm -Av /dev/md1 /dev/sdb /dev/sdd /dev/sde /dev/sdf /dev/sdg
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sdb is identified as a member of /dev/md1, slot -1.
> mdadm: /dev/sdd is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sde is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdf is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sdg is identified as a member of /dev/md1, slot 4.
> mdadm: added /dev/sde to /dev/md1 as 1
> mdadm: no uptodate device for slot 2 of /dev/md1
> mdadm: no uptodate device for slot 3 of /dev/md1
> mdadm: added /dev/sdg to /dev/md1 as 4
> mdadm: added /dev/sdf to /dev/md1 as 5
> mdadm: failed to add /dev/sdb to /dev/md1: Invalid argument
> mdadm: added /dev/sdd to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 4 drives - not enough to start the array.
>
> If found this really difficult to understand considering that I can
> get the output of mdamd -E /dev/sdb (other disks included to overload
> you with information)
>
> mdadm -E /dev/sd[b-h]
>
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 4e3b82e1:f5604e19:a9c9775f:49745adf
>   Creation Time : Fri Oct  5 09:18:25 2007
>      Raid Level : raid5
>     Device Size : 312571136 (298.09 GiB 320.07 GB)
>      Array Size : 1562855680 (1490.46 GiB 1600.36 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 1
>
>     Update Time : Tue Oct 16 20:03:13 2007
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 80d47486 - correct
>          Events : 0.623738
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     6       8       16       -1      spare   /dev/sdb
>
>    0     0       8       80        0      active sync   /dev/sdf
>    1     1       8      128        1      active sync   /dev/.static/dev/s=
di
>    2     2       8      144        2      active sync   /dev/.static/dev/s=
dj
>    3     3       8       16        3      active sync   /dev/sdb
>    4     4       8       64        4      active sync   /dev/sde
>    5     5       8       96        5      active sync   /dev/sdg


> If anyone could offer a solution I'd be forever grateful, also to
> prove that supporting open source isn't all free labour I'll send you
> can choose one of 1 of 2 Nintendo DS games, the new radiohead album or
> a cree flash light. :)


----- End message from sredfern@gmail.com -----

Hey, this looks similar to what I recently had. =20
(http://www.mail-archive.com/linux-raid@vger.kernel.org/msg09306.html)
I my case a RAID5 reshape was interrupted and the new devices were =20
also marked spare with slot -1.
Apply the attached patch to mdadm-2.6.3, build then do:
  mdadm -S /dev/md1
  ./mdadm -Av /dev/md1 --update=3Dthis /dev/sd[b-g]
That should update the slot on /dev/sdb. Then:
  mdadm -S /dev/md1
  ./mdadm -Av /dev/md1 /dev/sd[bcdefg]

should bring back your array in degraded mode.
If it works send your gifts to Neil Brown <neilb@suse.de>, he wrote =20
the patch! :)
Good luck!


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_55ixjbhph8so
Content-Type: text/plain;
	charset=UTF-8;
	name="mdadm-2.6.3.patch"
Content-Disposition: attachment;
	filename="mdadm-2.6.3.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Grow.c b/Grow.c
index 825747e..8ad1537 100644
--- a/Grow.c
+++ b/Grow.c
@@ -978,5 +978,5 @@ int Grow_restart(struct supertype *st, struct mdinfo *in=
fo, int *fdlist, int cnt
 =09=09/* And we are done! */
 =09=09return 0;
 =09}
-=09return 1;
+=09return 0;
 }
diff --git a/mdadm.c b/mdadm.c
index 40fdccf..7e7e803 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -584,6 +584,8 @@ int main(int argc, char *argv[])
 =09=09=09=09exit(2);
 =09=09=09}
 =09=09=09update =3D optarg;
+=09=09=09if (strcmp(update, "this")=3D=3D0)=20
+=09=09=09=09continue;
 =09=09=09if (strcmp(update, "sparc2.2")=3D=3D0)=20
 =09=09=09=09continue;
 =09=09=09if (strcmp(update, "super-minor") =3D=3D 0)
diff --git a/super0.c b/super0.c
index 0396c2c..e33e623 100644
--- a/super0.c
+++ b/super0.c
@@ -394,6 +394,21 @@ static int update_super0(struct mdinfo *info, void *sbv=
, char *update,
 =09=09=09fprintf (stderr, Name ": adjusting superblock of %s for 2.2/sparc =
compatability.\n",
 =09=09=09=09 devname);
 =09}
+=09if (strcmp(update, "this") =3D=3D 0) {
+=09=09/* to fix a particular corrupt superblock.
+=09=09*/
+=09=09int i;
+=09=09for (i=3D0; i<10; i++)
+=09=09=09if (sb->disks[i].major =3D=3D sb->this_disk.major &&
+=09=09=09    sb->disks[i].minor =3D=3D sb->this_disk.minor) {
+=09=09=09=09if (sb->this_disk.number =3D=3D sb->disks[i].number)
+=09=09=09=09=09break;
+=09=09=09=09fprintf(stderr, Name ": Setting this disk from %d to %d\n",
+=09=09=09=09=09sb->this_disk.number, sb->disks[i].number);
+=09=09=09=09sb->this_disk =3D sb->disks[i];
+=09=09=09=09break;
+=09=09=09}
+=09}
 =09if (strcmp(update, "super-minor") =3D=3D0) {
 =09=09sb->md_minor =3D info->array.md_minor;
 =09=09if (verbose > 0)

--=_55ixjbhph8so--

--=_55b7zi99xu4o
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHHNN7AKWN2UY+sLwRAt/HAJ4l/NQIkZdyqEuViUq5ugOxxW6+wwCfec3p
B8dUgz9KD9LeB+qe5SN5DQc=
=JbgA
-----END PGP SIGNATURE-----

--=_55b7zi99xu4o--
