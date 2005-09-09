From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Fri, 9 Sep 2005 17:40:06 +1000
Message-ID: <17185.15446.481054.508746@cse.unsw.edu.au>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
	<Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
	<17184.43156.113155.811612@cse.unsw.edu.au>
	<Pine.LNX.4.63.0509081525380.30261@filesrv1.baby-dragons.com>
	<17184.56377.773388.978710@cse.unsw.edu.au>
	<Pine.LNX.4.63.0509082000030.31748@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Go7VRqf4PI"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Thursday September 8
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Go7VRqf4PI
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

On Thursday September 8, babydr@baby-dragons.com wrote:
> > What happens if you then
> >  mdadm /dev/md_d0 -a /dev/sda[pqrs]
> > ??
> 
>  	Getting stranger & stranger .
> 
> root@devel-0:~ # mdadm /dev/md_d0 -a /dev/sda[pqrs]
> mdadm: re-added /dev/sdap
> 

Hmm.. mdadm bug.

> root@devel-0:~ # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] [raid10]
> md_d0 : active raid5 sdap[36] sdc[0] sdao[40] sdan[34] sdam[33] 
> sdal[32] sdak[31] sdaj[30] sdah[29] sdag[28] sdaf[27] sdae[26] 
> sdad[25] sdac[24] sdab[23] sdaa[22] sdz[21] sdy[20] sdw[19] sdv[18] 
> sdu[17] sdt[16] sds[15] sdr[14] sdq[13] sdp[12] sdo[11] sdn[10] sdl[9] 
> sdk[8] sdj[7] sdi[6] sdh[5] sdg[4] sdf[3] sde[2](F) sdd[1]
>        1244826240 blocks level 5, 64k chunk, algorithm 2 [36/35]
> [UU_UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]

Hmm.. obviously hot-add isn't enough to trigger the rebuild in that
kernel.


Attached are three patches.
The first two are needed by 2.6.12.5 to make sure resync happens (this
is particularly a problem for version-1 superblocks) or just upgrade
to 2.6.13.

The last fixes mdadm-v2.0 so that when you add /dev/sda[pqrs] it
actually adds all of them, and so that when you --assemble a version-1
array with spares, the spares actually get included.

NeilBrown



--Go7VRqf4PI
Content-Type: text/plain
Content-Disposition: inline;
	filename="349MdHotAddFix"
Content-Transfer-Encoding: 7bit

Status: ok

Make sure recovery happens when add_new_disk is used for hot_add

Currently if add_new_disk is used to hot-add a drive to a degraded
array, recovery doesn't start ... because we didn't tell it to.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 files changed, 2 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-05-31 13:40:35.000000000 +1000
+++ ./drivers/md/md.c	2005-05-31 13:40:34.000000000 +1000
@@ -2232,6 +2232,8 @@ static int add_new_disk(mddev_t * mddev,
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err)
 			export_rdev(rdev);
+
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		if (mddev->thread)
 			md_wakeup_thread(mddev->thread);
 		return err;

--Go7VRqf4PI
Content-Type: text/plain
Content-Disposition: inline;
	filename="418MdWakeThread"
Content-Transfer-Encoding: 7bit

Status: ok

Make sure resync gets started when array starts.

We weren't actually waking up the md thread after setting
MD_RECOVERY_NEEDED when assembling an array, so it is possible to
lose a race and not actually start resync.

So add a call to md_wakeup_thread, and while we are at it, remove
all the "if (mddev->thread)" guards as md_wake_thread does its own
checking.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c	2005-08-26 17:00:30.000000000 +1000
+++ ./drivers/md/md.c~current~	2005-08-26 17:00:39.000000000 +1000
@@ -256,8 +256,7 @@ static inline void mddev_unlock(mddev_t 
 {
 	up(&mddev->reconfig_sem);
 
-	if (mddev->thread)
-		md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->thread);
 }
 
 mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
@@ -1726,6 +1725,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->in_sync = 1;
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
 	
 	if (mddev->sb_dirty)
 		md_update_sb(mddev);
@@ -2255,8 +2255,7 @@ static int add_new_disk(mddev_t * mddev,
 			export_rdev(rdev);
 
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-		if (mddev->thread)
-			md_wakeup_thread(mddev->thread);
+		md_wakeup_thread(mddev->thread);
 		return err;
 	}
 

--Go7VRqf4PI
Content-Type: text/plain
Content-Disposition: inline;
	filename="patch"
Content-Transfer-Encoding: 7bit


diff ./Assemble.c~current~ ./Assemble.c
--- ./Assemble.c~current~	2005-09-05 10:55:01.000000000 +1000
+++ ./Assemble.c	2005-09-09 16:24:50.000000000 +1000
@@ -119,6 +119,7 @@ int Assemble(struct supertype *st, char 
 	struct mdinfo info;
 	struct mddev_ident_s ident2;
 	char *avail;
+	int nextspare = 0;
 	
 	vers = md_get_version(mdfd);
 	if (vers <= 0) {
@@ -320,6 +321,11 @@ int Assemble(struct supertype *st, char 
 			i = devcnt;
 		else
 			i = devices[devcnt].raid_disk;
+		if (i+1 == 0) {
+			if (nextspare < info.array.raid_disks)
+				nextspare = info.array.raid_disks;
+			i = nextspare++;
+		}
 		if (i < 10000) {
 			if (i >= bestcnt) {
 				unsigned int newbestcnt = i+10;

diff ./Manage.c~current~ ./Manage.c
--- ./Manage.c~current~	2005-09-05 10:54:55.000000000 +1000
+++ ./Manage.c	2005-09-09 16:04:12.000000000 +1000
@@ -288,7 +288,7 @@ int Manage_subdevs(char *devname, int fd
 						if (ioctl(fd, ADD_NEW_DISK, &disc) == 0) {
 							if (verbose >= 0)
 								fprintf(stderr, Name ": re-added %s\n", dv->devname);
-							return 0;
+							continue;
 						}
 						/* fall back on normal-add */
 					}


--Go7VRqf4PI--
