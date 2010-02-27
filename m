From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 2/3] fix compiler warnings
Date: Sat, 27 Feb 2010 14:53:03 +0100
Message-ID: <20100227135303.GA24207@maude.comedia.it>
References: <cover.1267264723.git.bluca@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1267264723.git.bluca@comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

one instance of uninitialized variable.
unused results from read/write which we don't care about.
one instance of unused result from posix-memalign which is checked
further down in the code.

Signed-off-by: Luca Berra <bluca@comedia.it>
---
   Grow.c     |    7 ++++---
   mdmon.c    |    2 +-
   restripe.c |    2 +-
   3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Grow.c b/Grow.c
index 74b63b6..5806fc3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1096,7 +1096,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
   			/* set them all just in case some old 'new_*' value
   			 * persists from some earlier problem
   			 */
-			int err;
+			int err = 0;
   			if (sysfs_set_num(sra, NULL, "chunk_size", nchunk) < 0)
   				rv = 1, err = errno;
   			if (!rv && sysfs_set_num(sra, NULL, "layout", nlayout) < 0)
@@ -1414,8 +1414,9 @@ int wait_backup(struct mdinfo *sra,
   
   static void fail(char *msg)
   {
-	write(2, msg, strlen(msg));
-	write(2, "\n", 1);
+	ssize_t rc;
+	rc = write(2, msg, strlen(msg));
+	rc = write(2, "\n", 1);
   	exit(1);
   }
   
diff --git a/mdmon.c b/mdmon.c
index 31d45fd..70fbd0b 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -176,7 +176,7 @@ static void try_kill_monitor(pid_t pid, char *devname, int sock)
   	fl = fcntl(sock, F_GETFL, 0);
   	fl &= ~O_NONBLOCK;
   	fcntl(sock, F_SETFL, fl);
-	read(sock, buf, 100);
+	n = read(sock, buf, 100);
   }
   
   void remove_pidfile(char *devname)
diff --git a/restripe.c b/restripe.c
index f673206..d885e76 100644
--- a/restripe.c
+++ b/restripe.c
@@ -565,7 +565,7 @@ int restore_stripes(int *dest, unsigned long long *offsets,
   
   	int data_disks = raid_disks - (level == 0 ? 0 : level <= 5 ? 1 : 2);
   
-	posix_memalign((void**)&stripe_buf, 4096, raid_disks * chunk_size);
+	i = posix_memalign((void**)&stripe_buf, 4096, raid_disks * chunk_size);
   	if (zero == NULL) {
   		zero = malloc(chunk_size);
   		if (zero)
-- 
1.7.0

-- 
Luca Berra -- bluca@comedia.it
          Communication Media & Services S.r.l.
   /"\
   \ /     ASCII RIBBON CAMPAIGN
    X        AGAINST HTML MAIL
   / \
