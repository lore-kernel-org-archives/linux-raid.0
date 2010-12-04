From: Neil Brown <neilb@suse.de>
Subject: Re: Degraded Array
Date: Sat, 4 Dec 2010 17:44:57 +1100
Message-ID: <20101204174457.4249ba23@notabene.brown>
References: <83.63.13137.69AA9FC4@cdptpa-omtalb.mail.rr.com>
	<AANLkTikd91t=aHK-CkV8TfqctA-np0YzDu79AtzAtZnK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikd91t=aHK-CkV8TfqctA-np0YzDu79AtzAtZnK@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 4 Dec 2010 07:26:36 +0300 "Majed B." <majedb@gmail.com> wrote:

> You have a degraded array now with 1 disk down. If you proceed, more
> disks might pop out due to errors.
>=20
> It's best to backup your data, run a check on the array, fix it then
> try to resume the reshape.

Backups are always a good idea, but are sometimes impractical.

I don't think running a 'check' would help at all.  A 'reshape' will do=
 much
the same sort of work, and more.

It isn't strictly true that the array is '1 disk down'.  Parts of it ar=
e 1
disk down, parts are 2 disks down.  As the reshape progresses more and =
more
will be 2 disks down.  We don't really want that.

This case isn't really handled well at present.  You want to do a 'reco=
very'
and a 'reshape' at the same time.  This is quite possible, but doesn't
currently happen when you restart a reshape in the middle (added to my =
todo
list).

I suggest you:
 - apply the patch below to mdadm.
 - assemble the array with --update=3Drevert-reshape.  You should give
   it a --backup-file too.
 - let the reshape complete so you are back to 13 devices.
 - add  a spare and let it recovery
 - then add a spare and reshape the array.

Of course you needed to be running a new enough kernel to be able decre=
ase
the number of devices in a raid5.

NeilBrown


>=20
> On Sat, Dec 4, 2010 at 5:42 AM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
> >
> > Hello everyone.
> >
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
I was just growing one of my RAID6 arrays from 13 to 14
> > members.=C2=A0 The array growth had passed its critical stage and h=
ad been
> > growing for several minutes when the system came to a screeching ha=
lt.=C2=A0 It
> > hit the big red switch, and when the system rebooted, the array ass=
embled,
> > but two members are missing.=C2=A0 One of the members is the new dr=
ive and the
> > other is the 13th drive in the RAID set.=C2=A0 Of course, the array=
 can run well
> > enough with only 12 members, but it=E2=80=99s definitely not the be=
st situation,
> > especially since the re-shape will take another day and a half.=C2=A0=
 Is it best
> > I go ahead and leave the array in its current state until the re-sh=
ape is
> > done, or should I go ahead and add back the two failed drives?
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>=20
>=20
>=20
> --
> =C2=A0 =C2=A0 =C2=A0=C2=A0 Majed B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



commit 12bab17f765a4130c7bd133a0bbb3b83f3f492b0
Author: NeilBrown <neilb@suse.de>
Date:   Sat Dec 4 17:37:14 2010 +1100

    Support reverting of reshape.
   =20
    Allow --update=3Drevert-reshape to do what you would expect.
   =20
    FIXME
    needs review.  Think about interface and use cases.
    Document.

diff --git a/Assemble.c b/Assemble.c
index afd4e60..c034e37 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -592,6 +592,12 @@ int Assemble(struct supertype *st, char *mddev,
 	/* Ok, no bad inconsistancy, we can try updating etc */
 	bitmap_done =3D 0;
 	content->update_private =3D NULL;
+	if (update && strcmp(update, "revert-reshape") =3D=3D 0 &&
+	    (content->reshape_active =3D=3D 0 || content->delta_disks <=3D 0)=
) {
+		fprintf(stderr, Name ": Cannot revert-reshape on this array\n");
+		close(mdfd);
+		return 1;
+	}
 	for (tmpdev =3D devlist; tmpdev; tmpdev=3Dtmpdev->next) if (tmpdev->u=
sed =3D=3D 1) {
 		char *devname =3D tmpdev->devname;
 		struct stat stb;
diff --git a/mdadm.c b/mdadm.c
index 08e8ea4..7cf51b5 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -662,6 +662,8 @@ int main(int argc, char *argv[])
 				continue;
 			if (strcmp(update, "devicesize")=3D=3D0)
 				continue;
+			if (strcmp(update, "revert-reshape")=3D=3D0)
+				continue;
 			if (strcmp(update, "byteorder")=3D=3D0) {
 				if (ss) {
 					fprintf(stderr, Name ": must not set metadata type with --update=3D=
byteorder.\n");
@@ -688,7 +690,8 @@ int main(int argc, char *argv[])
 			}
 			fprintf(outf, "Valid --update options are:\n"
 		"     'sparc2.2', 'super-minor', 'uuid', 'name', 'resync',\n"
-		"     'summaries', 'homehost', 'byteorder', 'devicesize'.\n");
+		"     'summaries', 'homehost', 'byteorder', 'devicesize',\n"
+		"     'revert-reshape'.\n");
 			exit(outf =3D=3D stdout ? 0 : 2);
=20
 		case O(INCREMENTAL,NoDegraded):
diff --git a/super0.c b/super0.c
index ae3e885..01d5cfa 100644
--- a/super0.c
+++ b/super0.c
@@ -545,6 +545,19 @@ static int update_super0(struct supertype *st, str=
uct mdinfo *info,
 	}
 	if (strcmp(update, "_reshape_progress")=3D=3D0)
 		sb->reshape_position =3D info->reshape_progress;
+	if (strcmp(update, "revert-reshape") =3D=3D 0 &&
+	    sb->minor_version > 90 && sb->delta_disks !=3D 0) {
+		int tmp;
+		sb->raid_disks -=3D sb->delta_disks;
+		sb->delta_disks =3D - sb->delta_disks;
+		tmp =3D sb->new_layout;
+		sb->new_layout =3D sb->layout;
+		sb->layout =3D tmp;
+
+		tmp =3D sb->new_chunk;
+		sb->new_chunk =3D sb->chunk_size;
+		sb->chunk_size =3D tmp;
+	}
=20
 	sb->sb_csum =3D calc_sb0_csum(sb);
 	return rv;
diff --git a/super1.c b/super1.c
index 0eb0323..805777e 100644
--- a/super1.c
+++ b/super1.c
@@ -781,6 +781,19 @@ static int update_super1(struct supertype *st, str=
uct mdinfo *info,
 	}
 	if (strcmp(update, "_reshape_progress")=3D=3D0)
 		sb->reshape_position =3D __cpu_to_le64(info->reshape_progress);
+	if (strcmp(update, "revert-reshape") =3D=3D 0 && sb->delta_disks) {
+		__u32 temp;
+		sb->raid_disks =3D __cpu_to_le32(__le32_to_cpu(sb->raid_disks) + __l=
e32_to_cpu(sb->delta_disks));
+		sb->delta_disks =3D __cpu_to_le32(-__le32_to_cpu(sb->delta_disks));
+		printf("REverted to %d\n", (int)__le32_to_cpu(sb->delta_disks));
+		temp =3D sb->new_layout;
+		sb->new_layout =3D sb->layout;
+		sb->layout =3D temp;
+
+		temp =3D sb->new_chunk;
+		sb->new_chunk =3D sb->chunksize;
+		sb->chunksize =3D temp;
+	}
=20
 	sb->sb_csum =3D calc_sb_1_csum(sb);
 	return rv;

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
