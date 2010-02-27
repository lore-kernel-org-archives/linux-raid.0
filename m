From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 3/3] workaround unused results
Date: Sat, 27 Feb 2010 14:53:48 +0100
Message-ID: <20100227135348.GC24207@maude.comedia.it>
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

errors from these tough unlikely should be checked
when it is not clear how to bailout from a funcion just create a
variable named discard_result and use it to please gcc

Signed-off-by: Luca Berra <bluca@comedia.it>
---
   Grow.c |   23 +++++++++++++++--------
   1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/Grow.c b/Grow.c
index 5806fc3..8dbe139 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1269,6 +1269,7 @@ int grow_backup(struct mdinfo *sra,
   	int odata = disks;
   	int rv = 0;
   	int i;
+	ssize_t discard_result;
   	unsigned long long new_degraded;
   	//printf("offset %llu\n", offset);
   	if (level >= 4)
@@ -1334,10 +1335,10 @@ int grow_backup(struct mdinfo *sra,
   						((char*)&bsb.sb_csum2)-((char*)&bsb));
   
   		lseek64(destfd[i], destoffsets[i] - 4096, 0);
-		write(destfd[i], &bsb, 512);
+		discard_result = write(destfd[i], &bsb, 512);
   		if (destoffsets[i] > 4096) {
   			lseek64(destfd[i], destoffsets[i]+stripes*chunk*odata, 0);
-			write(destfd[i], &bsb, 512);
+			discard_result = write(destfd[i], &bsb, 512);
   		}
   		fsync(destfd[i]);
   	}
@@ -1368,6 +1369,7 @@ int wait_backup(struct mdinfo *sra,
   	int fd = sysfs_get_fd(sra, NULL, "sync_completed");
   	unsigned long long completed;
   	int i;
+	ssize_t discard_result;
   
   	if (fd < 0)
   		return -1;
@@ -1406,7 +1408,7 @@ int wait_backup(struct mdinfo *sra,
   			bsb.sb_csum2 = bsb_csum((char*)&bsb,
   						((char*)&bsb.sb_csum2)-((char*)&bsb));
   		lseek64(destfd[i], destoffsets[i]-4096, 0);
-		write(destfd[i], &bsb, 512);
+		discard_result = write(destfd[i], &bsb, 512);
   		fsync(destfd[i]);
   	}
   	return 0;
@@ -1453,8 +1455,10 @@ static void validate(int afd, int bfd, unsigned long long offset)
   			free(abuf);
   			free(bbuf);
   			abuflen = len;
-			posix_memalign((void**)&abuf, 4096, abuflen);
-			posix_memalign((void**)&bbuf, 4096, abuflen);
+			if(posix_memalign((void**)&abuf, 4096, abuflen))
+				fail("cannot allocate memory");
+			if(posix_memalign((void**)&bbuf, 4096, abuflen))
+				fail("cannot allocate memory");
   		}
   
   		lseek64(bfd, offset, 0);
@@ -1508,8 +1512,9 @@ static int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
   {
   	char *buf;
   	int degraded = 0;
+	int discard_result;
   
-	posix_memalign((void**)&buf, 4096, disks * chunk);
+	discard_result = posix_memalign((void**)&buf, 4096, disks * chunk);
   	sysfs_set_num(sra, NULL, "suspend_hi", 0);
   	sysfs_set_num(sra, NULL, "suspend_lo", 0);
   	grow_backup(sra, 0, stripes,
@@ -1536,8 +1541,9 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
   	unsigned long long start;
   	int rv;
   	int degraded = 0;
+	int discard_result;
   
-	posix_memalign((void**)&buf, 4096, disks * chunk);
+	discard_result = posix_memalign((void**)&buf, 4096, disks * chunk);
   	start = sra->component_size - stripes * chunk/512;
   	sysfs_set_num(sra, NULL, "sync_max", start);
   	sysfs_set_str(sra, NULL, "sync_action", "reshape");
@@ -1574,9 +1580,10 @@ static int child_same_size(int afd, struct mdinfo *sra, unsigned long stripes,
   	char *buf;
   	unsigned long long speed;
   	int degraded = 0;
+	int discard_result;
   
   
-	posix_memalign((void**)&buf, 4096, disks * chunk);
+	discard_result = posix_memalign((void**)&buf, 4096, disks * chunk);
   
   	sysfs_set_num(sra, NULL, "suspend_lo", 0);
   	sysfs_set_num(sra, NULL, "suspend_hi", 0);
-- 
1.7.0

-- 
Luca Berra -- bluca@comedia.it
          Communication Media & Services S.r.l.
   /"\
   \ /     ASCII RIBBON CAMPAIGN
    X        AGAINST HTML MAIL
   / \
