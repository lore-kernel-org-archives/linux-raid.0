From: NeilBrown <neilb@suse.de>
Subject: Re: Update to mdadm V3.2.5 => RAID starts to recover (reproducible)
Date: Mon, 2 Sep 2013 11:35:34 +1000
Message-ID: <20130902113534.34f434f3@notabene.brown>
References: <CAE65G7kMP2rFLGuO1rfsFp7V-rHGz-3K+VWuLMZqmGUPANyqcQ@mail.gmail.com>
	<20130826155202.7a11dff5@notabene.brown>
	<CAE65G7kb_xveCrzqedbkFUc=OUh-KDJ-K58SrmTWeGhgkN1vEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zKMBe5tVHFZOOnMyKH6zYE."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE65G7kb_xveCrzqedbkFUc=OUh-KDJ-K58SrmTWeGhgkN1vEQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Baer <synthetic.gods@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zKMBe5tVHFZOOnMyKH6zYE.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Aug 2013 11:55:09 +0200 Andreas Baer <synthetic.gods@gmail.com>
wrote:

> On 8/26/13, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 22 Aug 2013 15:20:06 +0200 Andreas Baer <synthetic.gods@gmail.c=
om>
> > wrote:
> >
> >> Short description:
> >> I've discovered a problem during re-assembly of a clean RAID. mdadm
> >> throws one disk out because this disk apparently shows another disk as
> >> failed. After assembly, RAID starts to recover on existing spare disk.
> >>
> >> In detail:
> >> 1. RAID-6 (Superblock V0.90.00) created with mdadm V2.6.4 and with 7
> >> active disks and 1 spare disk (disk size: 1 TB), fully synced and
> >> clean.
> >> 2. RAID-6 stopped and re-assembled with mdadm V3.2.5, but during that
> >> one disk is thrown out.
> >>
> >> Manual assembly command for /dev/md0, relevant partitions are
> >> /dev/sd[b-i]1:
> >> # mdadm --assemble --scan -vvv
> >> mdadm: looking for devices for /dev/md0
> >> mdadm: no RAID superblock on /dev/sdi
> >> mdadm: no RAID superblock on /dev/sdh
> >> mdadm: no RAID superblock on /dev/sdg
> >> mdadm: no RAID superblock on /dev/sdf
> >> mdadm: no RAID superblock on /dev/sde
> >> mdadm: no RAID superblock on /dev/sdd
> >> mdadm: no RAID superblock on /dev/sdc
> >> mdadm: no RAID superblock on /dev/sdb
> >> mdadm: no RAID superblock on /dev/sda1
> >> mdadm: no RAID superblock on /dev/sda
> >> mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 7.
> >> mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 6.
> >> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 5.
> >> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
> >> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> >> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> >> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
> >> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
> >> mdadm: ignoring /dev/sdb1 as it reports /dev/sdi1 as failed
> >> mdadm: no uptodate device for slot 0 of /dev/md0
> >> mdadm: added /dev/sdd1 to /dev/md0 as 2
> >> mdadm: added /dev/sde1 to /dev/md0 as 3
> >> mdadm: added /dev/sdf1 to /dev/md0 as 4
> >> mdadm: added /dev/sdg1 to /dev/md0 as 5
> >> mdadm: added /dev/sdh1 to /dev/md0 as 6
> >> mdadm: added /dev/sdi1 to /dev/md0 as 7
> >> mdadm: added /dev/sdc1 to /dev/md0 as 1
> >> mdadm: /dev/md0 has been started with 6 drives (out of 7) and 1 spare.
> >>
> >> I finally made a test by modifying mdadm V3.2.5 sources to not write
> >> any data to any superblock and to simply exit() somewhere in the
> >> middle of assembly process to be able to reproduce this behavior
> >> without any RAID re-creation/synchronization.
> >> So using mdadm V2.6.4 /dev/md0 assembles without problems and if I
> >> switch to mdadm V3.2.5 it shows the same messages as above.
> >>
> >> The real problem:
> >> I have more than a single machine receiving a similar software update
> >> so I need to find a solution or workaround around this problem. By the
> >> way, from another test without an existing spare disk, there seems to
> >> be no 'throwing out'-problem when switching from V2.6.4 to V3.2.5.
> >>
> >> It would also be a great help if someone could explain the reason
> >> behind the relevant code fragment for rejecting a device, e.g. why is
> >> only the 'most_recent' device important?
> >>
> >> /* If this device thinks that 'most_recent' has failed, then
> >>   * we must reject this device.
> >>   */
> >> if (j !=3D most_recent &&
> >>     content->array.raid_disks > 0 &&
> >>     devices[most_recent].i.disk.raid_disk >=3D 0 &&
> >>     devmap[j * content->array.raid_disks +
> >> devices[most_recent].i.disk.raid_disk] =3D=3D 0) {
> >>     if (verbose > -1)
> >>         fprintf(stderr, Name ": ignoring %s as it reports %s as
> >> failed\n",
> >>             devices[j].devname, devices[most_recent].devname);
> >>     best[i] =3D -1;
> >>     continue;
> >> }
> >>
> >> I also attached some files showing some details about related
> >> superblocks before and after assembly as well as about RAID status
> >> itself.
> >
> >
> > Thanks for the thorough report.  I think this issue has been fixed in
> > 3.3-rc1
> > You can fix it for 3.2.5 by applying the following patch:
> >
> > diff --git a/Assemble.c b/Assemble.c
> > index 227d66f..bc65c29 100644
> > --- a/Assemble.c
> > +++ b/Assemble.c
> > @@ -849,7 +849,8 @@ int Assemble(struct supertype *st, char *mddev,
> >  		devices[devcnt].i.disk.minor =3D minor(stb.st_rdev);
> >  		if (most_recent < devcnt) {
> >  			if (devices[devcnt].i.events
> > -			    > devices[most_recent].i.events)
> > +			    > devices[most_recent].i.events &&
> > +			    devices[devcnt].i.disk.state =3D=3D 6)
> >  				most_recent =3D devcnt;
> >  		}
> >  		if (content->array.level =3D=3D LEVEL_MULTIPATH)
> >
> > The "most recent" device is important as we need to choose one to compa=
re
> > all
> > others again.  The problem is that the code in 3.2.5 can sometimes choo=
se a
> > spare, which isn't such a good idea.
> >
> > The "most recent" is also important because when a collection of device=
s is
> > given to the kernel it will give priority to some information which is =
on
> > the
> > last device passed in.  So we make sure that the last device given to t=
he
> > kernel is the "most recent".
> >
> > Please let me know if the patch fixes your problem.
> >
> > NeilBrown
>=20
> First of all, thanks for your very helpful 'most recent disk' explanation.
>=20
> Sadly, the patch didn't fix my problem because the event counters are
> really equal on all disks (inclusive spare) and the first disk that is
> checked is the spare disk so there is no reason to set another disk as
> 'most recent disk', but I improved your patch a little bit by
> providing more output and created also an own solution, but that needs
> review because I'm not sure if it can be done like that.
>=20
> Patch 1: Your solution with more output
> Diff: mdadm-3.2.5-noassemble-patch1.diff
> Assembly: mdadm-3.2.5-noassemble-patch1.txt
>=20
> Patch 2: My proposed solution
> Diff: mdadm-3.2.5-noassemble-patch2.diff
> Assembly: mdadm-3.2.5-noassemble-patch2.txt


Thanks for the testing and suggestions.  I see what I missed now.
Can you check if this patch works please?

Thanks.
NeilBrown

diff --git a/Assemble.c b/Assemble.c
index 227d66f..9131917 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -215,7 +215,7 @@ int Assemble(struct supertype *st, char *mddev,
 	unsigned int okcnt, sparecnt, rebuilding_cnt;
 	unsigned int req_cnt;
 	int i;
-	int most_recent =3D 0;
+	int most_recent =3D -1;
 	int chosen_drive;
 	int change =3D 0;
 	int inargv =3D 0;
@@ -847,8 +847,9 @@ int Assemble(struct supertype *st, char *mddev,
 		devices[devcnt].i =3D *content;
 		devices[devcnt].i.disk.major =3D major(stb.st_rdev);
 		devices[devcnt].i.disk.minor =3D minor(stb.st_rdev);
-		if (most_recent < devcnt) {
-			if (devices[devcnt].i.events
+		if (devices[devcnt].i.disk_state =3D=3D 6) {
+			if (most_recent < 0 ||
+			    devices[devcnt].i.events
 			    > devices[most_recent].i.events)
 				most_recent =3D devcnt;
 		}

--Sig_/zKMBe5tVHFZOOnMyKH6zYE.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUiPrZjnsnt1WYoG5AQLYbw/+KgGsHn8jrewEcoapn5sK4QI01Qi4V/7o
KRvnVVY+N5yrMWGF9/2iVVcCRmhg5P46EJb7rfBDQZ5hpZ+mYfdz0dlogfCQYKU2
m6RLmHZSPxcltvAuNsdvQtj//G6lMCKFefGAYvSiiPX2bsEis2r3VF6cZzAhC3fn
F3EQo2swuVRnOXnuCPGKbpkyNl6/5ZWcSJB/4pbdBcV0knF8wk3MnOcQAdZW5eHT
ZGM727LVLKc+h+gKpU8ulENRZPI7FPS2T1cyeVFnt+nI0P02Of9cBbEXe9zwf1lu
7WosiZmAyXdJaSvfXqWSCzwQ2CjOwqE7qVjikvuztstfS2y06X6efkID6XVzCdtz
xjoHfERGJYZS2SFJsRec5v/TH+06Wm733FMN8v7mZTjadCAFiQw0gL5JFxNFB7+F
cVLbbMaMaqUpHrzG4bo5U7ew9b0P74/oR8RT6Gg+kF5Tj42vCs7JHurTmyPm/wZv
kZ8WO36shl4NWohrZzHvSGM9IgXkyRsELZOyJ0dF4X9jSq4R1MX0nL50CSpIUQSh
Y7A0/s5yETtnmTtr8eSLx3EawsPongkaQfp/pFXBfFH91s1ntu0hFvis0G5ASg72
EX7wZ/8UkW1OdOvWbmPV5dIG4EBan4073q6XdMpIfbGW0vURyqevWnibgSj3Ttfu
ZejXXI/bHuA=
=G37e
-----END PGP SIGNATURE-----

--Sig_/zKMBe5tVHFZOOnMyKH6zYE.--
