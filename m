From: Neil Brown <neilb@suse.de>
Subject: Re: Bug in 2.6.17 / mdadm 2.5.1
Date: Mon, 26 Jun 2006 11:06:51 +1000
Message-ID: <17567.13099.133933.397389@cse.unsw.edu.au>
References: <20060624104745.GA6352@defiant.crash>
	<20060625135926.GA6253@defiant.crash>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ronald Lembcke on Sunday June 25
Sender: linux-raid-owner@vger.kernel.org
To: Ronald Lembcke <es186@fen-net.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 25, es186@fen-net.de wrote:
> Hi!
> 
> There's a bug in Kernel 2.6.17 and / or mdadm which prevents (re)adding
> a disk to a degraded RAID5-Array.

Thank you for the detailed report.
The bug is in the md driver in the kernel (not in mdadm), and only
affects version-1 superblocks.  Debian recently changed the default
(in /etc/mdadm.conf) to use version-1 superblocks which I thought
would be OK (I've some testing) but obviously I missed something. :-(

If you remove the "metadata=1" (or whatever it is) from
/etc/mdadm/mdadm.conf and then create the array, it will be created
with a version-0.90 superblock has had more testing.

Alternately you can apply the following patch to the kernel and
version-1 superblocks should work better.

NeilBrown

-------------------------------------------------
Set desc_nr correctly for version-1 superblocks.

This has to be done in ->load_super, not ->validate_super

### Diffstat output
 ./drivers/md/md.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-06-26 11:02:43.000000000 +1000
+++ ./drivers/md/md.c	2006-06-26 11:02:46.000000000 +1000
@@ -1057,6 +1057,11 @@ static int super_1_load(mdk_rdev_t *rdev
 	if (rdev->sb_size & bmask)
 		rdev-> sb_size = (rdev->sb_size | bmask)+1;
 
+	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH))
+		rdev->desc_nr = -1;
+	else
+		rdev->desc_nr = le32_to_cpu(sb->dev_number);
+
 	if (refdev == 0)
 		ret = 1;
 	else {
@@ -1165,7 +1170,6 @@ static int super_1_validate(mddev_t *mdd
 
 	if (mddev->level != LEVEL_MULTIPATH) {
 		int role;
-		rdev->desc_nr = le32_to_cpu(sb->dev_number);
 		role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
 		switch(role) {
 		case 0xffff: /* spare */
