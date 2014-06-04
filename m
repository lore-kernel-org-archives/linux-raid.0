From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [RFC PATCH 4/4] mdadm: introduce '--use-requestfn' create/assembly option
Date: Wed,  4 Jun 2014 19:10:02 +0200
Message-ID: <1401901802-16296-5-git-send-email-sebastian.riemer@profitbricks.com>
References: <20140602202050.14903534@notabene.brown>
 <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Sebastian Parschauer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

With that option it is possible to tell the kernel via the writable
module parameter 'rq_mode' that it should use the request function
mode (request-by-request) instead of the default make request
function mode (bio-by-bio). The advantage is that a scheduler can
be used and the block layer cares for statistics.

Signed-off-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 Assemble.c |    4 ++++
 Create.c   |    4 ++++
 ReadMe.c   |    3 +++
 mdadm.c    |    5 +++++
 mdadm.h    |    3 +++
 util.c     |   34 ++++++++++++++++++++++++++++++++++
 6 files changed, 53 insertions(+)

diff --git a/Assemble.c b/Assemble.c
index a57d384..d35d218 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1275,6 +1275,10 @@ int Assemble(struct supertype *st, char *mddev,
 		       mddev ? mddev : "further assembly");
 		return 1;
 	}
+	if (set_rq_mode(c->use_requestfn) != 0) {
+		pr_err("Cannot set the request function mode - cannot assemble.\n");
+		return 1;
+	}
 
 	if (devlist == NULL)
 		devlist = conf_get_devs();
diff --git a/Create.c b/Create.c
index 330c5b4..dc576f1 100644
--- a/Create.c
+++ b/Create.c
@@ -138,6 +138,10 @@ int Create(struct supertype *st, char *mddev,
 		pr_err("This level does not support spare devices\n");
 		return 1;
 	}
+	if (set_rq_mode(c->use_requestfn) != 0) {
+		pr_err("Cannot set the request function mode.\n");
+		return 1;
+	}
 
 	if (subdevs == 1 && strcmp(devlist->devname, "missing") != 0) {
 		/* If given a single device, it might be a container, and we can
diff --git a/ReadMe.c b/ReadMe.c
index bd8c85e..ecb829f 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -150,6 +150,7 @@ struct option long_options[] = {
     {"force",	  0, 0, Force},
     {"update",	  1, 0, 'U'},
     {"freeze-reshape", 0, 0, FreezeReshape},
+    {"use-requestfn", 0, 0, UseRequestFn},
 
     /* Management */
     {"add",       0, 0, Add},
@@ -372,6 +373,7 @@ char Help_create[] =
 "  --name=       -N   : Textual name for array - max 32 characters\n"
 "  --bitmap-chunk=    : bitmap chunksize in Kilobytes.\n"
 "  --delay=      -d   : bitmap update delay in seconds.\n"
+"  --use-requestfn    : Tell the kernel to process requests instead of bios.\n"
 "\n"
 ;
 
@@ -456,6 +458,7 @@ char Help_assemble[] =
 "  --update=     -U   : Update superblock: try '-A --update=?' for option list.\n"
 "  --no-degraded      : Assemble but do not start degraded arrays.\n"
 "  --readonly    -o   : Mark the array as read-only. No resync will start.\n"
+"  --use-requestfn    : Tell the kernel to process requests instead of bios.\n"
 ;
 
 char Help_manage[] =
diff --git a/mdadm.c b/mdadm.c
index be990b8..35ff339 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -652,6 +652,11 @@ int main(int argc, char *argv[])
 		case O(INCREMENTAL, FreezeReshape):
 			c.freeze_reshape = 1;
 			continue;
+		case O(CREATE, UseRequestFn):
+		case O(ASSEMBLE, UseRequestFn):
+		case O(INCREMENTAL, UseRequestFn):
+			c.use_requestfn = 1;
+			continue;
 		case O(CREATE,'u'): /* uuid of array */
 		case O(ASSEMBLE,'u'): /* uuid of array */
 			if (ident.uuid_set) {
diff --git a/mdadm.h b/mdadm.h
index c0726bf..bb9f043 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -343,6 +343,7 @@ enum special_options {
 	Dump,
 	Restore,
 	Action,
+	UseRequestFn,
 };
 
 enum prefix_standard {
@@ -417,6 +418,7 @@ struct context {
 	char	*backup_file;
 	int	invalid_backup;
 	char	*action;
+	int	use_requestfn;
 };
 
 struct shape {
@@ -1355,6 +1357,7 @@ extern int remove_disk(int mdfd, struct supertype *st,
 		       struct mdinfo *sra, struct mdinfo *info);
 extern int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info);
 unsigned long long min_recovery_start(struct mdinfo *array);
+extern int set_rq_mode(int use_requestfn);
 
 extern char *human_size(long long bytes);
 extern char *human_size_brief(long long bytes, int prefix);
diff --git a/util.c b/util.c
index 7937eb6..b9c6cc3 100644
--- a/util.c
+++ b/util.c
@@ -1968,3 +1968,37 @@ void reopen_mddev(int mdfd)
 	if (fd >= 0 && fd != mdfd)
 		dup2(fd, mdfd);
 }
+
+/*
+ * 0: make request fn mode (bio-by-bio)
+ * 1: request fn mode (request-by-request)
+ */
+#define BIO_MODE "0\n"
+#define REQ_MODE "1\n"
+
+int set_rq_mode(int use_requestfn)
+{
+	int fd, rv = 0;
+	ssize_t size, wbytes;
+	char *mode;
+
+	fd = open("/sys/module/md_mod/parameters/rq_mode", O_WRONLY);
+	if (fd < 0) {
+		if (errno != ENOENT || use_requestfn)
+			rv = 1;
+		goto out;
+	}
+	if (use_requestfn) {
+		mode = REQ_MODE;
+		size = sizeof(REQ_MODE);
+	} else {
+		mode = BIO_MODE;
+		size = sizeof(BIO_MODE);
+	}
+	wbytes = write(fd, mode, size);
+	if (wbytes != size)
+		rv = 1;
+	close(fd);
+out:
+	return rv;
+}
-- 
1.7.9.5

