From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] mdadm: remove journal with "remove-journal"
Date: Wed, 15 Mar 2017 11:28:50 -0700
Message-ID: <20170315182850.3628010-2-songliubraving@fb.com>
References: <20170315182850.3628010-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170315182850.3628010-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

When journal device of an array fails, the array is forced into read-only
mode. To make the array normal without adding another journal device, we
need to remove journal _feature_ from the array.

This patch is the mdadm part of removing journal feature for an array with
failed or missing journal.

Two flags are added to GET_ARRAY_INFO:
  1. MD_SB_HAS_JOURNAL: meaning the array have journal feature;
  2. MD_SB_JOURNAL_REMOVABLE: meaning the journal is faulty or missing

When both flags are set, mdadm will use ioctl SET_ARRAY_INFO to clear
MD_SB_HAS_JOURNAL, and thus remove journal feature from the array.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Manage.c | 26 ++++++++++++++++++++++++++
 ReadMe.c |  1 +
 mdadm.c  |  9 ++++++++-
 mdadm.h  |  3 +++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index 289b7ce..26c7dca 100644
--- a/Manage.c
+++ b/Manage.c
@@ -189,6 +189,32 @@ int Manage_run(char *devname, int fd, struct context *c)
 	return IncrementalScan(c, nm);
 }
 
+int Manage_remove_journal(char *devname, int fd, int verbose)
+{
+	mdu_array_info_t array;
+
+	if (ioctl(fd, GET_ARRAY_INFO, &array) != 0)
+		return 1;
+
+	if (!(array.state & (1<<MD_SB_HAS_JOURNAL))) {
+		pr_err("%s does not have journal. No need to remove.\n",
+		       devname);
+		return 1;
+	} else if (!(array.state & (1<<MD_SB_JOURNAL_REMOVABLE))) {
+		pr_err("Cannot remove active journal. Please fail it and try again.\n");
+		return 1;
+	}
+
+	array.state &= ~(1<<MD_SB_HAS_JOURNAL);
+
+	if (ioctl(fd, SET_ARRAY_INFO, &array)) {
+		pr_err("Failed to add remove journal feature.\n");
+		return 1;
+	}
+
+	return 0;
+}
+
 int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 {
 	/* Stop the array.  Array must already be configured
diff --git a/ReadMe.c b/ReadMe.c
index 50d3807..acc4180 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -164,6 +164,7 @@ struct option long_options[] = {
     {"add-spare", 0, 0, AddSpare},
     {"add-journal", 0, 0, AddJournal},
     {"remove",    0, 0, Remove},
+    {"remove-journal",    0, 0, RemoveJournal},
     {"fail",      0, 0, Fail},
     {"set-faulty",0, 0, Fail},
     {"replace",   0, 0, Replace},
diff --git a/mdadm.c b/mdadm.c
index d6ad8dc..3ad413f 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -194,6 +194,7 @@ int main(int argc, char *argv[])
 		case AddJournal:
 		case 'r':
 		case Remove:
+		case RemoveJournal:
 		case Replace:
 		case With:
 		case 'f':
@@ -994,6 +995,9 @@ int main(int argc, char *argv[])
 			}
 			c.runstop = -1;
 			continue;
+		case O(MANAGE,RemoveJournal):
+			c.remove_journal = 1;
+			continue;
 		case O(MANAGE,'t'):
 			c.test = 1;
 			continue;
@@ -1387,6 +1391,9 @@ int main(int argc, char *argv[])
 			rv = Manage_run(devlist->devname, mdfd, &c);
 		if (!rv && c.runstop < 0)
 			rv = Manage_stop(devlist->devname, mdfd, c.verbose, 0);
+		if (!rv && c.remove_journal > 0)
+			rv = Manage_remove_journal(devlist->devname, mdfd,
+						   c.verbose);
 		break;
 	case ASSEMBLE:
 		if (devs_found == 1 && ident.uuid_set == 0 &&
@@ -1906,7 +1913,7 @@ static int misc_list(struct mddev_dev *devlist,
 				mdfd = open_dev(dv->devname);
 				if (mdfd >= 0) break;
 			case 1:
-				mdfd = open_mddev(dv->devname, 1);  
+				mdfd = open_mddev(dv->devname, 1);
 		}
 		if (mdfd>=0) {
 			switch(dv->disposition) {
diff --git a/mdadm.h b/mdadm.h
index 71b8afb..e5acc49 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -390,6 +390,7 @@ enum special_options {
 	AddSpare,
 	AddJournal,
 	Remove,
+	RemoveJournal,
 	Fail,
 	Replace,
 	With,
@@ -512,6 +513,7 @@ struct context {
 	char	*action;
 	int	nodes;
 	char	*homecluster;
+	int	remove_journal;
 };
 
 struct shape {
@@ -1293,6 +1295,7 @@ extern int Manage_ro(char *devname, int fd, int readonly);
 extern int Manage_run(char *devname, int fd, struct context *c);
 extern int Manage_stop(char *devname, int fd, int quiet,
 		       int will_retry);
+extern int Manage_remove_journal(char *devname, int fd, int verbose);
 extern int Manage_subdevs(char *devname, int fd,
 			  struct mddev_dev *devlist, int verbose, int test,
 			  char *update, int force);
-- 
2.9.3

