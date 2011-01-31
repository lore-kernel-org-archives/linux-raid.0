From: NeilBrown <neilb@suse.de>
Subject: Re: [native] Bug report -cannot create a native raid on devel-3.2
Date: Mon, 31 Jan 2011 11:17:36 +1100
Message-ID: <20110131111736.1e0dd925@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D17701BD41@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17701BD41@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Fri, 28 Jan 2011 15:30:23 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Hi Neil,
> Creation of a native raid fails:
> mdadm -CR /dev/md/aaa -n 2 -l 1 /dev/sdb /dev/sdc
> mdadm: ADD_NEW_DISK for /dev/sdb failed: Invalid argument.
> In /var/log/messages:
> md: sdb does not have a valid v1.2 superblock, not importing!
> 
> 
> This on top on devel-3.2.
> The bug is probably connected with fix 1cc7f4feb9a979 "Don't close fds in write_init_super".
> In the call to get_dev_size from write_init_super1 the di->fd descriptor is zero and get_dev_size returns with error.
> One of the first steps in load_super1 is call  free_super1(st). free_super1 releases st->info pointer and closes(di->fd);
> 
> The sequence in write_init_super1:
> for (di = st->info; di && ! rv ; di = di->next) {
> ....
> 
> 1060                 if (load_super1(&refst, di->fd, NULL)==0) {
> 1076 
>   <..cut..>
> 1077                 if (!get_dev_size(di->fd, NULL, &dsize))
> 1078                         return 1;
> < ...cut ... >
> }
> 
> 
> Thanks,
> Marcin Labun

Thanks for testing and reporting the bug.

There are two different issues here - both related to the commit you
identified.
The following patch fixed them.  I will commit it with proper comment shortly.

Thanks,
NeilBrown

diff --git a/Create.c b/Create.c
index 7c6979a..a0669fe 100644
--- a/Create.c
+++ b/Create.c
@@ -823,7 +823,6 @@ int Create(struct supertype *st, char *mddev,
 						Name ": ADD_NEW_DISK for %s "
 						"failed: %s\n",
 						dv->devname, strerror(errno));
-					st->ss->free_super(st);
 					goto abort;
 				}
 				break;
@@ -866,10 +865,10 @@ int Create(struct supertype *st, char *mddev,
 			map_unlock(&map);
 
 			flush_metadata_updates(st);
+			st->ss->free_super(st);
 		}
 	}
 	free(infos);
-	st->ss->free_super(st);
 
 	if (level == LEVEL_CONTAINER) {
 		/* No need to start.  But we should signal udev to
diff --git a/super1.c b/super1.c
index 8a89d3b..50a5f48 100644
--- a/super1.c
+++ b/super1.c
@@ -1019,11 +1019,13 @@ static unsigned long choose_bm_space(unsigned long devsize)
 	return 4*2;
 }
 
+static void free_super1(struct supertype *st);
+
 #ifndef MDASSEMBLE
 static int write_init_super1(struct supertype *st)
 {
 	struct mdp_superblock_1 *sb = st->sb;
-	struct supertype refst;
+	struct supertype *refst;
 	int rfd;
 	int rv = 0;
 	unsigned long long bm_space;
@@ -1055,10 +1057,9 @@ static int write_init_super1(struct supertype *st)
 
 		sb->events = 0;
 
-		refst =*st;
-		refst.sb = NULL;
-		if (load_super1(&refst, di->fd, NULL)==0) {
-			struct mdp_superblock_1 *refsb = refst.sb;
+		refst = dup_super(st);
+ 		if (load_super1(refst, di->fd, NULL)==0) {
+			struct mdp_superblock_1 *refsb = refst->sb;
 
 			memcpy(sb->device_uuid, refsb->device_uuid, 16);
 			if (memcmp(sb->set_uuid, refsb->set_uuid, 16)==0) {
@@ -1071,8 +1072,9 @@ static int write_init_super1(struct supertype *st)
 				if (get_linux_version() >= 2006018)
 					sb->dev_number = refsb->dev_number;
 			}
-			free(refsb);
+			free_super1(refst);
 		}
+		free(refst);
 
 		if (!get_dev_size(di->fd, NULL, &dsize))
 			return 1;
@@ -1207,8 +1209,6 @@ static int compare_super1(struct supertype *st, struct supertype *tst)
 	return 0;
 }
 
-static void free_super1(struct supertype *st);
-
 static int load_super1(struct supertype *st, int fd, char *devname)
 {
 	unsigned long long dsize;
