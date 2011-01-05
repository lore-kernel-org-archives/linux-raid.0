From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] Assemble: allow to assemble spares on their own
Date: Wed, 5 Jan 2011 13:58:55 +1100
Message-ID: <20110105135855.478982e9@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759F4E@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759F4E@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Tue, 4 Jan 2011 14:06:30 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From eb737197e6a3a43f6724003900a87410acec9495 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Tue, 4 Jan 2011 12:18:18 +0100
> Subject: [PATCH 2/2] Assemble: allow to assemble spares on their own
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> If we find spares but no members of given array
> we create container with just spares.
> 
> This allows auto assemble to pick up all lose imsm spares when there
> is no config file.
> When there is a valid config file and any array is assembled from it
> we don't try auto assembly so we will not assemble spares that don't
> match any array.
> To remedy this we must add
> ARRAY metadata=imsm UUID=00000000:00000000:00000000:00000000
> to config file.
> This container will include all remaining spares.

Thanks.
I have made some modifications resulting in the following patch.

The main problem was that your code explicitly mentioned "imsm" in generic
code.  That is always the wrong thing to do.  One day we might have a
different metadata type that has the same sort of floating spare, in which
case the imsm spares need to be handled separately to the new type of spares.

So:
 I move the place where ->used is set to '3' so that st gets set.
So if we see and IMSM device, we will create an IMSM array at that point,
though it might end up being a container of spares.

I removed the 'else' so that the original loop searching for 'used == 3'
always runs. If we just set up an array of spares, then it will find nothing,
but that is no loss.  This avoids the need to indent it further.

As mentioned earlier, I added a test for 'auto_assem'.

Thanks,
NeilBrown

commit ed7fc6b4d91a5342886ba6fe6d175f69f0875d3b
Author: Anna Czarnowska <anna.czarnowska@intel.com>
Date:   Wed Jan 5 13:54:18 2011 +1100

    Assemble: allow to assemble spares on their own
    
    If we find spares but no members of given array
    we create container with just spares.
    
    This allows auto assemble to pick up all lose imsm spares when there
    is no config file.
    When there is a valid config file and any array is assembled from it
    we don't try auto assembly so we will not assemble spares that don't
    match any array.
    To remedy this we must add
    ARRAY metadata=imsm UUID=00000000:00000000:00000000:00000000
    to config file.
    This container will include all remaining spares.
    
    Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Assemble.c b/Assemble.c
index 7ef9dc3..532335e 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -489,17 +489,23 @@ int Assemble(struct supertype *st, char *mddev,
 					   homehost, update,
 					   report_missmatch ? devname : NULL))
 				goto loop;
-
-			if (!memcmp(content->uuid, uuid_zero, sizeof(int[4]))) {
-				/* this is imsm_spare - do not set st */
-				tmpdev->used = 3;
-				goto loop;
-			}
 				
 			if (st == NULL)
 				st = dup_super(tst);
 			if (st->minor_version == -1)
 				st->minor_version = tst->minor_version;
+
+			if (memcmp(content->uuid, uuid_zero,
+				   sizeof(int[4])) == 0) {
+				/* this is a floating spare.  It cannot define
+				 * an array unless there are no more arrays of
+				 * this type to be found.  It can be included
+				 * in an array of this type though.
+				 */
+				tmpdev->used = 3;
+				goto loop;
+			}
+
 			if (st->ss != tst->ss ||
 			    st->minor_version != tst->minor_version ||
 			    st->ss->compare_super(st, tst) != 0) {
@@ -557,6 +563,25 @@ int Assemble(struct supertype *st, char *mddev,
 			tst->ss->free_super(tst);
 	}
 
+	/* Check if we found some imsm spares but no members */
+	if (auto_assem && (!st || !st->sb))
+		for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
+			if (tmpdev->used != 3)
+				continue;
+			tmpdev->used = 1;
+			content = &info;
+
+			if (!st->sb) {
+				/* we need sb from one of the spares */
+				int dfd = dev_open(tmpdev->devname, O_RDONLY);
+				if (dfd < 0 ||
+				    st->ss->load_super(st, dfd, NULL))
+					tmpdev->used = 2;
+				if (dfd > 0)
+					close(dfd);
+			}
+		}
+
 	/* Now reject spares that don't match domains of identified members */
 	for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
 		struct stat stb;
@@ -892,8 +917,10 @@ int Assemble(struct supertype *st, char *mddev,
 		if (content->array.level != LEVEL_MULTIPATH)
 			if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
 				if (!(devices[j].i.disk.state
-				      & (1<<MD_DISK_FAULTY)))
+				      & (1<<MD_DISK_FAULTY))) {
+					devices[j].uptodate = 1;
 					sparecnt++;
+				}
 				continue;
 			}
 		/* If this devices thinks that 'most_recent' has failed, then
