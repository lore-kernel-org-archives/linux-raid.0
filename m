From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 3 of 6] Make md work a bit better with devfs
Date: Mon, 07 Feb 2005 13:44:19 +1100
Message-ID: <E1Cxyst-0004fi-JC@notabene.cse.unsw.edu.au>
References: <20050207133555.17870.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


- set ->devfs_name
- create initial devfs names slightly differently so
  as not to conflict
- re-read partition table when an array is assembled at boot
  time - not sure why this is needed, but it is.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c     |    9 ++++++---
 ./init/do_mounts_md.c |   10 ++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-07 13:32:00.000000000 +1100
+++ ./drivers/md/md.c	2005-02-07 13:32:22.000000000 +1100
@@ -1518,10 +1518,13 @@ static struct kobject *md_probe(dev_t de
 	}
 	disk->major = MAJOR(dev);
 	disk->first_minor = unit << shift;
-	if (partitioned)
+	if (partitioned) {
 		sprintf(disk->disk_name, "md_d%d", unit);
-	else
+		sprintf(disk->devfs_name, "md/d%d", unit);
+	} else {
 		sprintf(disk->disk_name, "md%d", unit);
+		sprintf(disk->devfs_name, "md/%d", unit);
+	}
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 	disk->queue = mddev->queue;
@@ -3773,7 +3776,7 @@ int __init md_init(void)
 	for (minor=0; minor < MAX_MD_DEVS; ++minor)
 		devfs_mk_bdev(MKDEV(mdp_major, minor<<MdpMinorShift),
 			      S_IFBLK|S_IRUSR|S_IWUSR,
-			      "md/d%d", minor);
+			      "md/mdp%d", minor);
 
 
 	register_reboot_notifier(&md_notifier);

diff ./init/do_mounts_md.c~current~ ./init/do_mounts_md.c
--- ./init/do_mounts_md.c~current~	2005-02-07 13:31:05.000000000 +1100
+++ ./init/do_mounts_md.c	2005-02-07 13:32:22.000000000 +1100
@@ -232,6 +232,16 @@ static void __init md_setup_drive(void)
 			err = sys_ioctl(fd, RUN_ARRAY, 0);
 		if (err)
 			printk(KERN_WARNING "md: starting md%d failed\n", minor);
+		else {
+			/* reread the partition table.
+			 * I (neilb) and not sure why this is needed, but I cannot
+			 * boot a kernel with devfs compiled in from partitioned md 
+			 * array without it
+			 */
+			sys_close(fd);
+			fd = sys_open(name, 0, 0);
+			sys_ioctl(fd, BLKRRPART, 0);
+		}
 		sys_close(fd);
 	}
 }
