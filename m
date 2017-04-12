From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/2] md: allow creation of mdNNN arrays via
 md_mod/parameters/new_array
Date: Wed, 12 Apr 2017 16:26:13 +1000
Message-ID: <149197837299.19936.14922734851405940379.stgit@noble>
References: <149197804398.19936.12809382889200123725.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149197804398.19936.12809382889200123725.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

The intention when creating the "new_array" parameter and the
possibility of having array names line "md_HOME" was to transition
away from the old way of creating arrays and to eventually only use
this new way.

The "old" way of creating array is to create a device node in /dev
and then open it.  The act of opening creates the array.
This is problematic because sometimes the device node can be opened
when we don't want to create an array.  This can easily happen
when some rule triggered by udev looks at a device as it is being
destroyed.  The node in /dev continues to exist for a short period
after an array is stopped, and opening it during this time recreates
the array (as an inactive array).

Unfortunately no clear plan for the transition was created.  It is now
time to fix that.

This patch allows devices with numeric names, like "md999" to be
created by writing to "new_array".  This will only work if the minor
number given is not already in use.  This will allow mdadm to
support the creation of arrays with numbers > 511 (currently not
possible) by writing to new_array.
mdadm can, at some point, use this approach to create *all* arrays,
which will allow the transition to only using the new-way.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9fe930109012..c3d3bae947a1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5164,6 +5164,14 @@ static void no_op(struct percpu_ref *r) {}
 
 static int md_alloc(dev_t dev, char *name)
 {
+	/* If dev is zero, name is the name of a device to allocate with
+	 * an arbitrary minor number.  It will be "md_???"
+	 * If dev is non-zero it must be a device number with a MAJOR of
+	 * MD_MAJOR or mdp_major.  In this case, if "name" is NULL, then
+	 * the device is being created by opening a node in /dev.
+	 * If "name" is not NULL, the device is being created by
+	 * writing to /sys/module/md_mod/parameters/new_array.
+	 */
 	static DEFINE_MUTEX(disks_mutex);
 	struct mddev *mddev = mddev_find(dev);
 	struct gendisk *disk;
@@ -5189,7 +5197,7 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->gendisk)
 		goto abort;
 
-	if (name) {
+	if (name && !dev) {
 		/* Need to ensure that 'name' is not a duplicate.
 		 */
 		struct mddev *mddev2;
@@ -5203,6 +5211,11 @@ static int md_alloc(dev_t dev, char *name)
 			}
 		spin_unlock(&all_mddevs_lock);
 	}
+	if (name && dev)
+		/*
+		 * Creating /dev/mdNNN via "newarray", so adjust hold_active.
+		 */
+		mddev->hold_active = UNTIL_STOP;
 
 	error = -ENOMEM;
 	mddev->queue = blk_alloc_queue(GFP_KERNEL);
@@ -5279,21 +5292,30 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 
 static int add_named_array(const char *val, struct kernel_param *kp)
 {
-	/* val must be "md_*" where * is not all digits.
-	 * We allocate an array with a large free minor number, and
+	/* val must be "md_*" or "mdNNN".
+	 * For "md_*" we allocate an array with a large free minor number, and
 	 * set the name to val.  val must not already be an active name.
+	 * For "mdNNN" we allocate an array with the minor number NNN
+	 * which must not already be in use.
 	 */
 	int len = strlen(val);
 	char buf[DISK_NAME_LEN];
+	unsigned long devnum;
 
 	while (len && val[len-1] == '\n')
 		len--;
 	if (len >= DISK_NAME_LEN)
 		return -E2BIG;
 	strlcpy(buf, val, len+1);
-	if (strncmp(buf, "md_", 3) != 0)
-		return -EINVAL;
-	return md_alloc(0, buf);
+	if (strncmp(buf, "md_", 3) == 0)
+		return md_alloc(0, buf);
+	if (strncmp(buf, "md", 2) == 0 &&
+	    isdigit(buf[2]) &&
+	    kstrtoul(buf+2, 10, &devnum) == 0 &&
+	    devnum <= MINORMASK)
+		return md_alloc(MKDEV(MD_MAJOR, devnum), NULL);
+
+	return -EINVAL;
 }
 
 static void md_safemode_timeout(unsigned long data)


