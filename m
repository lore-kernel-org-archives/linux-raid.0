From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 7 - Print "deprecated" warning when START_ARRAY is used.
Date: Fri, 06 Feb 2004 16:35:51 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Aoyed-00083F-00@notabene>
References: <20040206162532.30220.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The "START_ARRAY" ioctl depends on major/minor numbers (as stored
in the raid superblock) are stable over reboots, which is increasingly
untrue.
There are better ways to start an array (e.g. with mdadm) so we 
mark the ioctl as deprecated for 2.6, and will remove it in 2.7.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-02-06 16:17:55.000000000 +1100
+++ ./drivers/md/md.c	2004-02-06 16:17:55.000000000 +1100
@@ -2419,6 +2419,14 @@ static int md_ioctl(struct inode *inode,
 		/* START_ARRAY doesn't need to lock the array as autostart_array
 		 * does the locking, and it could even be a different array
 		 */
+		static int cnt = 3;
+		if (cnt > 0 ) {
+			printk(KERN_WARNING 
+			       "md: %s(pid %d) used deprecated START_ARRAY ioctl. "
+			       "This will not be supported beyond 2.6\n",
+			       current->comm, current->pid);
+			cnt--;
+		}
 		err = autostart_array(new_decode_dev(arg));
 		if (err) {
 			printk(KERN_WARNING "md: autostart %s failed!\n",
