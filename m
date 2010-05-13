From: Neil Brown <neilb@suse.de>
Subject: Re: reshaping raid6 in-place
Date: Thu, 13 May 2010 12:08:08 +1000
Message-ID: <20100513120808.4129aa40@notabene.brown>
References: <alpine.LRH.2.00.1005121857150.2432@appaloosa.temp555.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1005121857150.2432@appaloosa.temp555.com>
Sender: linux-raid-owner@vger.kernel.org
To: Frank Corrao <fcorrao@temp555.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 12 May 2010 19:10:35 -0400 (EDT)
Frank Corrao <fcorrao@temp555.com> wrote:

> I have a 5-disk raid5 array which I recently reshaped to raid6 while 
> simultaneously adding a 6th disk.  mdadm (3.1.1) reported that the 
> kernel I was running at the time (2.6.30) wasn't safe to perform the 
> in-place portion of the reshaping.  The array was partitionally 
> converted to raid6, but I believe the Q blocks are all on the last 
> device I added.  mdadm seems to report the algorithm as 
> left-symmetric-6 as opposed to left-symmetric.  Today I upgraded to 
> 2.6.32 and mdadm 3.1.2 and attempted to complete the re-shaping but ran 
> into a snag:
> 
> $ sudo ./mdadm -v --grow /dev/md2 -l 6 -n 6 -p left-symmetric
> mdadm: /dev/md2: Something wrong - reshape aborted
> 
> Is my syntax correct?
> 
> Frank

This is a 32bit host isn't it???  You would have thought I would have learned
by now, but it seems not.  'blocks' in Grow.c is "unsigned long" and should
really be "unsigned long long".

Also your syntax is incomplete.  You need a backup-file for that reshape.
mdadm would have told you that if it hadn't confused itself first.

This patch should help you.

NeilBrown

diff --git a/Grow.c b/Grow.c
index 0916c5d..d1a7b63 100644
--- a/Grow.c
+++ b/Grow.c
@@ -418,15 +418,15 @@ int bsb_csum(char *buf, int len)
 	return __cpu_to_le32(csum);
 }
 
-static int child_grow(int afd, struct mdinfo *sra, unsigned long blocks,
+static int child_grow(int afd, struct mdinfo *sra, unsigned long long blocks,
 		      int *fds, unsigned long long *offsets,
 		      int disks, int chunk, int level, int layout, int data,
 		      int dests, int *destfd, unsigned long long *destoffsets);
-static int child_shrink(int afd, struct mdinfo *sra, unsigned long blocks,
+static int child_shrink(int afd, struct mdinfo *sra, unsigned long long blocks,
 			int *fds, unsigned long long *offsets,
 			int disks, int chunk, int level, int layout, int data,
 			int dests, int *destfd, unsigned long long *destoffsets);
-static int child_same_size(int afd, struct mdinfo *sra, unsigned long blocks,
+static int child_same_size(int afd, struct mdinfo *sra, unsigned long long blocks,
 			   int *fds, unsigned long long *offsets,
 			   unsigned long long start,
 			   int disks, int chunk, int level, int layout, int data,
@@ -514,7 +514,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	int nrdisks;
 	int err;
 	int frozen;
-	unsigned long a,b, blocks, stripes;
+	unsigned long long a,b, blocks, stripes;
 	int cache;
 	unsigned long long array_size;
 	int changed = 0;
@@ -1262,7 +1262,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 /* FIXME return status is never checked */
 int grow_backup(struct mdinfo *sra,
 		unsigned long long offset, /* per device */
-		unsigned long stripes, /* per device */
+		unsigned long long stripes, /* per device */
 		int *sources, unsigned long long *offsets,
 		int disks, int chunk, int level, int layout,
 		int dests, int *destfd, unsigned long long *destoffsets,
@@ -1522,7 +1522,7 @@ static void validate(int afd, int bfd, unsigned long long offset)
 	}
 }
 
-static int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
+static int child_grow(int afd, struct mdinfo *sra, unsigned long long stripes,
 		      int *fds, unsigned long long *offsets,
 		      int disks, int chunk, int level, int layout, int data,
 		      int dests, int *destfd, unsigned long long *destoffsets)
@@ -1550,7 +1550,7 @@ static int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
 	return 1;
 }
 
-static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
+static int child_shrink(int afd, struct mdinfo *sra, unsigned long long stripes,
 			int *fds, unsigned long long *offsets,
 			int disks, int chunk, int level, int layout, int data,
 			int dests, int *destfd, unsigned long long *destoffsets)
@@ -1586,14 +1586,14 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
 	return 1;
 }
 
-static int child_same_size(int afd, struct mdinfo *sra, unsigned long stripes,
+static int child_same_size(int afd, struct mdinfo *sra, unsigned long long stripes,
 			   int *fds, unsigned long long *offsets,
 			   unsigned long long start,
 			   int disks, int chunk, int level, int layout, int data,
 			   int dests, int *destfd, unsigned long long *destoffsets)
 {
 	unsigned long long size;
-	unsigned long tailstripes = stripes;
+	unsigned long long tailstripes = stripes;
 	int part;
 	char *buf;
 	unsigned long long speed;
@@ -1960,7 +1960,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	int backup_list[1];
 	unsigned long long backup_offsets[1];
 	int odisks, ndisks, ochunk, nchunk,odata,ndata;
-	unsigned long a,b,blocks,stripes;
+	unsigned long long a,b,blocks,stripes;
 	int backup_fd;
 	int *fds;
 	unsigned long long *offsets;

