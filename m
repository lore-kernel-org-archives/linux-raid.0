From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] Add failfast support.
Date: Fri, 25 Nov 2016 10:55:49 +1100
Message-ID: <87polka0vu.fsf@notabene.neil.brown.name>
References: <147944614789.3302.1959091446949640579.stgit@noble> <20161122020238.qtuxwo5etcwmts4r@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161122020238.qtuxwo5etcwmts4r@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Allow per-device "failfast" flag to be set when creating an
array or adding devices to an array.

When re-adding a device which had the failfast flag, it can be removed
using --nofailfast.

failfast status is printed in --detail and --examine output.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

Hi Jes,
 this patch adds mdadm support for the failfast functionality that
Shaohua recently included in his for-next.
Hopefully the man-page additions provide all necessary context.
If there is anything that seems to be missing, I'll be very happy to
add it.

Thanks,
NeilBrown


 Create.c      |  2 ++
 Detail.c      |  1 +
 Incremental.c |  1 +
 Manage.c      | 20 +++++++++++++++++++-
 ReadMe.c      |  2 ++
 md.4          | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 md_p.h        |  1 +
 mdadm.8.in    | 32 +++++++++++++++++++++++++++++++-
 mdadm.c       | 11 +++++++++++
 mdadm.h       |  5 +++++
 super0.c      | 12 ++++++++----
 super1.c      | 13 +++++++++++++
 12 files changed, 148 insertions(+), 6 deletions(-)
 mode change 100755 =3D> 100644 mdadm.h

diff --git a/Create.c b/Create.c
index 1594a3919139..bd114eabafc1 100644
=2D-- a/Create.c
+++ b/Create.c
@@ -890,6 +890,8 @@ int Create(struct supertype *st, char *mddev,
=20
 				if (dv->writemostly =3D=3D 1)
 					inf->disk.state |=3D (1<<MD_DISK_WRITEMOSTLY);
+				if (dv->failfast =3D=3D 1)
+					inf->disk.state |=3D (1<<MD_DISK_FAILFAST);
=20
 				if (have_container)
 					fd =3D -1;
diff --git a/Detail.c b/Detail.c
index 925e4794c983..509b0d418768 100644
=2D-- a/Detail.c
+++ b/Detail.c
@@ -658,6 +658,7 @@ This is pretty boring
 			}
 			if (disk.state & (1<<MD_DISK_REMOVED)) printf(" removed");
 			if (disk.state & (1<<MD_DISK_WRITEMOSTLY)) printf(" writemostly");
+			if (disk.state & (1<<MD_DISK_FAILFAST)) printf(" failfast");
 			if (disk.state & (1<<MD_DISK_JOURNAL)) printf(" journal");
 			if ((disk.state &
 			     ((1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC)
diff --git a/Incremental.c b/Incremental.c
index cc01d41e641a..75d95ccc497a 100644
=2D-- a/Incremental.c
+++ b/Incremental.c
@@ -1035,6 +1035,7 @@ static int array_try_spare(char *devname, int *dfdp, =
struct dev_policy *pol,
 			devlist.next =3D NULL;
 			devlist.used =3D 0;
 			devlist.writemostly =3D 0;
+			devlist.failfast =3D 0;
 			devlist.devname =3D chosen_devname;
 			sprintf(chosen_devname, "%d:%d", major(stb.st_rdev),
 				minor(stb.st_rdev));
diff --git a/Manage.c b/Manage.c
index 1b7b0c111c83..429d8631cd23 100644
=2D-- a/Manage.c
+++ b/Manage.c
@@ -683,8 +683,13 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *=
dv,
 			disc.state |=3D 1 << MD_DISK_WRITEMOSTLY;
 		if (dv->writemostly =3D=3D 2)
 			disc.state &=3D ~(1 << MD_DISK_WRITEMOSTLY);
+		if (dv->failfast =3D=3D 1)
+			disc.state |=3D 1 << MD_DISK_FAILFAST;
+		if (dv->failfast =3D=3D 2)
+			disc.state &=3D ~(1 << MD_DISK_FAILFAST);
 		remove_partitions(tfd);
=2D		if (update || dv->writemostly > 0) {
+		if (update || dv->writemostly > 0
+			|| dv->failfast > 0) {
 			int rv =3D -1;
 			tfd =3D dev_open(dv->devname, O_RDWR);
 			if (tfd < 0) {
@@ -700,6 +705,14 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *=
dv,
 				rv =3D dev_st->ss->update_super(
 					dev_st, NULL, "readwrite",
 					devname, verbose, 0, NULL);
+			if (dv->failfast =3D=3D 1)
+				rv =3D dev_st->ss->update_super(
+					dev_st, NULL, "failfast",
+					devname, verbose, 0, NULL);
+			if (dv->failfast =3D=3D 2)
+				rv =3D dev_st->ss->update_super(
+					dev_st, NULL, "nofailfast",
+					devname, verbose, 0, NULL);
 			if (update)
 				rv =3D dev_st->ss->update_super(
 					dev_st, NULL, update,
@@ -964,6 +977,8 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			disc.state |=3D (1 << MD_DISK_JOURNAL) | (1 << MD_DISK_SYNC);
 		if (dv->writemostly =3D=3D 1)
 			disc.state |=3D 1 << MD_DISK_WRITEMOSTLY;
+		if (dv->failfast =3D=3D 1)
+			disc.state |=3D 1 << MD_DISK_FAILFAST;
 		dfd =3D dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
 		if (tst->ss->add_to_super(tst, &disc, dfd,
 					  dv->devname, INVALID_SECTORS))
@@ -1009,6 +1024,8 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
=20
 	if (dv->writemostly =3D=3D 1)
 		disc.state |=3D (1 << MD_DISK_WRITEMOSTLY);
+	if (dv->failfast =3D=3D 1)
+		disc.state |=3D (1 << MD_DISK_FAILFAST);
 	if (tst->ss->external) {
 		/* add a disk
 		 * to an external metadata container */
@@ -1785,6 +1802,7 @@ int move_spare(char *from_devname, char *to_devname, =
dev_t devid)
 	devlist.next =3D NULL;
 	devlist.used =3D 0;
 	devlist.writemostly =3D 0;
+	devlist.failfast =3D 0;
 	devlist.devname =3D devname;
 	sprintf(devname, "%d:%d", major(devid), minor(devid));
=20
diff --git a/ReadMe.c b/ReadMe.c
index d3fcb6132fe9..8da49ef46dfb 100644
=2D-- a/ReadMe.c
+++ b/ReadMe.c
@@ -136,6 +136,8 @@ struct option long_options[] =3D {
     {"bitmap-chunk", 1, 0, BitmapChunk},
     {"write-behind", 2, 0, WriteBehind},
     {"write-mostly",0, 0, WriteMostly},
+    {"failfast",  0, 0,  FailFast},
+    {"nofailfast",0, 0,  NoFailFast},
     {"re-add",    0, 0,  ReAdd},
     {"homehost",  1, 0,  HomeHost},
     {"symlinks",  1, 0,  Symlinks},
diff --git a/md.4 b/md.4
index f1b88ee6bb03..5bdf7a7bd375 100644
=2D-- a/md.4
+++ b/md.4
@@ -916,6 +916,60 @@ slow).  The extra latency of the remote link will not =
slow down normal
 operations, but the remote system will still have a reasonably
 up-to-date copy of all data.
=20
+.SS FAILFAST
+
+From Linux 4.10,
+.I
+md
+supports FAILFAST for RAID1 and RAID10 arrays.  This is a flag that
+can be set on individual drives, though it is usually set on all
+drives, or no drives.
+
+When
+.I md
+sends an I/O request to a drive that is marked as FAILFAST, and when
+the array could survive the loss of that drive without losing data,
+.I md
+will request that the underlying device does not perform any retries.
+This means that a failure will be reported to
+.I md
+promptly, and it can mark the device as faulty and continue using the
+other device(s).
+.I md
+cannot control the timeout that the underlying devices use to
+determine failure.  Any changes desired to that timeout must be set
+explictly on the underlying device, separately from using
+.IR mdadm .
+
+If a FAILFAST request does fail, and if it is still safe to mark the
+device as faulty without data loss, that will be done and the array
+will continue functioning on a reduced number of devices.  If it is not
+possible to safely mark the device as faulty,
+.I md
+will retry the request without disabling retries in the underlying
+device.  In any case,
+.I md
+will not attempt to repair read errors on a device marked as FAILFAST
+by writing out the correct.  It will just mark the device as faulty.
+
+FAILFAST is appropriate for storage arrays that have a low probability
+of true failure, but will sometimes introduce unacceptable delays to
+I/O requests while performing internal maintenance.  The value of
+setting FAILFAST involves a trade-off.  The gain is that the chance of
+unacceptable delays is substantially reduced.  The cost is that the
+unlikely event of data-loss on one device is slightly more likely to
+result in data-loss for the array.
+
+When a device in an array using FAILFAST is marked as faulty, it will
+usually become usable again in a short while.
+.I mdadm
+makes no attempt to detect that possibility.  Some separate
+mechanism, tuned to the specific details of the expected failure modes,
+needs to be created to monitor devices to see when they return to full
+functionality, and to then re-add them to the array.  In order of
+this "re-add" functionality to be effective, an array using FAILFAST
+should always have a write-intent bitmap.
+
 .SS RESTRIPING
=20
 .IR Restriping ,
diff --git a/md_p.h b/md_p.h
index 0d691fbc987d..dc9fec165cb6 100644
=2D-- a/md_p.h
+++ b/md_p.h
@@ -89,6 +89,7 @@
 				   * read requests will only be sent here in
 				   * dire need
 				   */
+#define	MD_DISK_FAILFAST	10 /* Fewer retries, more failures */
=20
 #define MD_DISK_REPLACEMENT	17
 #define MD_DISK_JOURNAL		18 /* disk is used as the write journal in RAID-5=
/6 */
diff --git a/mdadm.8.in b/mdadm.8.in
index 3c0c58f95f35..aa80f0c1a631 100644
=2D-- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -747,7 +747,7 @@ subsequent devices listed in a
 .BR \-\-create ,
 or
 .B \-\-add
=2Dcommand will be flagged as 'write-mostly'.  This is valid for RAID1
+command will be flagged as 'write\-mostly'.  This is valid for RAID1
 only and means that the 'md' driver will avoid reading from these
 devices if at all possible.  This can be useful if mirroring over a
 slow link.
@@ -762,6 +762,25 @@ mode, and write-behind is only attempted on drives mar=
ked as
 .IR write-mostly .
=20
 .TP
+.BR \-\-failfast
+subsequent devices listed in a
+.B \-\-create
+or
+.B \-\-add
+command will be flagged as  'failfast'.  This is valid for RAID1 and
+RAID10 only.  IO requests to these devices will be encouraged to fail
+quickly rather than cause long delays due to error handling.  Also no
+attempt is made to repair a read error on these devices.
+
+If an array becomes degraded so that the 'failfast' device is the only
+usable device, the 'failfast' flag will then be ignored and extended
+delays will be preferred to complete failure.
+
+The 'failfast' flag is appropriate for storage arrays which have a
+low probability of true failure, but which may sometimes
+cause unacceptable delays due to internal maintenance functions.
+
+.TP
 .BR \-\-assume\-clean
 Tell
 .I mdadm
@@ -1452,6 +1471,17 @@ that had a failed journal. To avoid interrupting on-=
going write opertions,
 .B \-\-add-journal
 only works for array in Read-Only state.
=20
+.TP
+.BR \-\-failfast
+Subsequent devices that are added or re\-added will have
+the 'failfast' flag set.  This is only valid for RAID1 and RAID10 and
+means that the 'md' driver will avoid long timeouts on error handling
+where possible.
+.TP
+.BR \-\-nofailfast
+Subsequent devices that are re\-added will be re\-added without
+the 'failfast' flag set.
+
 .P
 Each of these options requires that the first device listed is the array
 to be acted upon, and the remainder are component devices to be added,
diff --git a/mdadm.c b/mdadm.c
index cca093318d8d..3c8f273c8254 100644
=2D-- a/mdadm.c
+++ b/mdadm.c
@@ -90,6 +90,7 @@ int main(int argc, char *argv[])
 	int spare_sharing =3D 1;
 	struct supertype *ss =3D NULL;
 	int writemostly =3D 0;
+	int failfast =3D 0;
 	char *shortopt =3D short_options;
 	int dosyslog =3D 0;
 	int rebuild_map =3D 0;
@@ -295,6 +296,7 @@ int main(int argc, char *argv[])
 					dv->devname =3D optarg;
 					dv->disposition =3D devmode;
 					dv->writemostly =3D writemostly;
+					dv->failfast =3D failfast;
 					dv->used =3D 0;
 					dv->next =3D NULL;
 					*devlistend =3D dv;
@@ -351,6 +353,7 @@ int main(int argc, char *argv[])
 			dv->devname =3D optarg;
 			dv->disposition =3D devmode;
 			dv->writemostly =3D writemostly;
+			dv->failfast =3D failfast;
 			dv->used =3D 0;
 			dv->next =3D NULL;
 			*devlistend =3D dv;
@@ -417,6 +420,14 @@ int main(int argc, char *argv[])
 			writemostly =3D 2;
 			continue;
=20
+		case O(MANAGE,FailFast):
+		case O(CREATE,FailFast):
+			failfast =3D 1;
+			continue;
+		case O(MANAGE,NoFailFast):
+			failfast =3D 2;
+			continue;
+
 		case O(GROW,'z'):
 		case O(CREATE,'z'):
 		case O(BUILD,'z'): /* size */
diff --git a/mdadm.h b/mdadm.h
old mode 100755
new mode 100644
index 240ab7f831bc..d47de01f725b
=2D-- a/mdadm.h
+++ b/mdadm.h
@@ -383,6 +383,8 @@ enum special_options {
 	ConfigFile,
 	ChunkSize,
 	WriteMostly,
+	FailFast,
+	NoFailFast,
 	Layout,
 	Auto,
 	Force,
@@ -516,6 +518,7 @@ struct mddev_dev {
 				 * Not set for names read from .config
 				 */
 	char writemostly;	/* 1 for 'set writemostly', 2 for 'clear writemostly' */
+	char failfast;		/* Ditto but for 'failfast' flag */
 	int used;		/* set when used */
 	long long data_offset;
 	struct mddev_dev *next;
@@ -821,6 +824,8 @@ extern struct superswitch {
 	 *   linear-grow-update - now change the size of the array.
 	 *   writemostly - set the WriteMostly1 bit in the superblock devflags
 	 *   readwrite - clear the WriteMostly1 bit in the superblock devflags
+	 *   failfast - set the FailFast1 bit in the superblock
+	 *   nofailfast - clear the FailFast1 bit
 	 *   no-bitmap - clear any record that a bitmap is present.
 	 *   bbl       - add a bad-block-log if possible
 	 *   no-bbl    - remove any bad-block-log is it is empty.
diff --git a/super0.c b/super0.c
index 55ebd8bc7877..938cfd95fa25 100644
=2D-- a/super0.c
+++ b/super0.c
@@ -232,14 +232,15 @@ static void examine_super0(struct supertype *st, char=
 *homehost)
 		mdp_disk_t *dp;
 		char *dv;
 		char nb[5];
=2D		int wonly;
+		int wonly, failfast;
 		if (d>=3D0) dp =3D &sb->disks[d];
 		else dp =3D &sb->this_disk;
 		snprintf(nb, sizeof(nb), "%4d", d);
 		printf("%4s %5d   %5d    %5d    %5d     ", d < 0 ? "this" : nb,
 		       dp->number, dp->major, dp->minor, dp->raid_disk);
 		wonly =3D dp->state & (1 << MD_DISK_WRITEMOSTLY);
=2D		dp->state &=3D ~(1 << MD_DISK_WRITEMOSTLY);
+		failfast =3D dp->state & (1<<MD_DISK_FAILFAST);
+		dp->state &=3D ~(wonly | failfast);
 		if (dp->state & (1 << MD_DISK_FAULTY))
 			printf(" faulty");
 		if (dp->state & (1 << MD_DISK_ACTIVE))
@@ -250,6 +251,8 @@ static void examine_super0(struct supertype *st, char *=
homehost)
 			printf(" removed");
 		if (wonly)
 			printf(" write-mostly");
+		if (failfast)
+			printf(" failfast");
 		if (dp->state =3D=3D 0)
 			printf(" spare");
 		if ((dv =3D map_dev(dp->major, dp->minor, 0)))
@@ -581,7 +584,8 @@ static int update_super0(struct supertype *st, struct m=
dinfo *info,
 	} else if (strcmp(update, "assemble")=3D=3D0) {
 		int d =3D info->disk.number;
 		int wonly =3D sb->disks[d].state & (1<<MD_DISK_WRITEMOSTLY);
=2D		int mask =3D (1<<MD_DISK_WRITEMOSTLY);
+		int failfast =3D sb->disks[d].state & (1<<MD_DISK_FAILFAST);
+		int mask =3D (1<<MD_DISK_WRITEMOSTLY)|(1<<MD_DISK_FAILFAST);
 		int add =3D 0;
 		if (sb->minor_version >=3D 91)
 			/* During reshape we don't insist on everything
@@ -590,7 +594,7 @@ static int update_super0(struct supertype *st, struct m=
dinfo *info,
 			add =3D (1<<MD_DISK_SYNC);
 		if (((sb->disks[d].state & ~mask) | add)
 		    !=3D (unsigned)info->disk.state) {
=2D			sb->disks[d].state =3D info->disk.state | wonly;
+			sb->disks[d].state =3D info->disk.state | wonly |failfast;
 			rv =3D 1;
 		}
 		if (info->reshape_active &&
diff --git a/super1.c b/super1.c
index d3234392d453..87a74cb94508 100644
=2D-- a/super1.c
+++ b/super1.c
@@ -77,6 +77,7 @@ struct mdp_superblock_1 {
 	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
 	__u8    devflags;        /* per-device flags.  Only one defined...*/
 #define WriteMostly1    1        /* mask for writemostly flag in above */
+#define FailFast1	2        /* Device should get FailFast requests */
 	/* bad block log.  If there are any bad blocks the feature flag is set.
 	 * if offset and size are non-zero, that space is reserved and available.
 	 */
@@ -430,6 +431,8 @@ static void examine_super1(struct supertype *st, char *=
homehost)
 		printf("          Flags :");
 		if (sb->devflags & WriteMostly1)
 			printf(" write-mostly");
+		if (sb->devflags & FailFast1)
+			printf(" failfast");
 		printf("\n");
 	}
=20
@@ -1020,6 +1023,8 @@ static void getinfo_super1(struct supertype *st, stru=
ct mdinfo *info, char *map)
 	}
 	if (sb->devflags & WriteMostly1)
 		info->disk.state |=3D (1 << MD_DISK_WRITEMOSTLY);
+	if (sb->devflags & FailFast1)
+		info->disk.state |=3D (1 << MD_DISK_FAILFAST);
 	info->events =3D __le64_to_cpu(sb->events);
 	sprintf(info->text_version, "1.%d", st->minor_version);
 	info->safe_mode_delay =3D 200;
@@ -1377,6 +1382,10 @@ static int update_super1(struct supertype *st, struc=
t mdinfo *info,
 		sb->devflags |=3D WriteMostly1;
 	else if (strcmp(update, "readwrite")=3D=3D0)
 		sb->devflags &=3D ~WriteMostly1;
+	else if (strcmp(update, "failfast") =3D=3D 0)
+		sb->devflags |=3D FailFast1;
+	else if (strcmp(update, "nofailfast") =3D=3D 0)
+		sb->devflags &=3D ~FailFast1;
 	else
 		rv =3D -1;
=20
@@ -1713,6 +1722,10 @@ static int write_init_super1(struct supertype *st)
 			sb->devflags |=3D WriteMostly1;
 		else
 			sb->devflags &=3D ~WriteMostly1;
+		if (di->disk.state & (1<<MD_DISK_FAILFAST))
+			sb->devflags |=3D FailFast1;
+		else
+			sb->devflags &=3D ~FailFast1;
=20
 		random_uuid(sb->device_uuid);
=20
=2D-=20
2.10.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYN34FAAoJEDnsnt1WYoG5ID0P/izer4LWSe4Xk2uCMFPvs4vk
H1u3K5/2cUxexNQRMPNrhpHHLRUqfU38/rAfyoOTdvnpdEDBsGoQWaVnNFbeByAi
4jQouEPakkQLu1AasgR2G8egX3eP3KO0RZziqpwlYi/lfVw8Qbv7jMDIBxYieHdT
dCrRjVOasUIJdvYk1bOpgvu8ktvMwThFzc4BEROF+Nj72iff8Wpcqmh9raP0J7UI
9b/V+2Wm0ABuBtcSrx9lEseaVsCSsWBRgvg/M8fnEE4enbmd00y7C0umsQEiyruE
H12NO7tbwvgxLJci2jUyiGK4d445PrD2ZeIx00Eh5WP7fVBZ382Nj+Ls3/5V2msC
sMoqaYvtYCXpB+ZQoFqC9NqMN2k3BzUqjyJXThaIJ1c7q75cEXpheASp0t1+kR2i
aroIs9nM+EO9T85TWN1RRuJbqowPFbQexzXl1uEksktaao/tL3Abgvl7AYLY/3vL
Bl5Pwuz5ZCeRVasGryfj7mnXlbulE/C7qCFjAoBNqyxRNrVttfM8oeUwYoZKB7GO
6YCxDbMBpjwTRHHSVlq/gjx66pdnAGlesFBzJYUVvAF3TmXun2ZRLWjLV8GZy8xQ
KX6qzQxuZSXNorMeOuhUljbW98asJnDit54m9itU5FZ/JaSSTd1tcU2VdkA3jlA6
wRjwyLyg5NDX74jWrVOI
=6CMV
-----END PGP SIGNATURE-----
--=-=-=--
