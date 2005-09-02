From: NeilBrown <neilb@suse.de>
Subject: [PATCH md ] Make sure the new 'sb_size' is set properly device added without pre-existing superblock.
Date: Fri, 2 Sep 2005 22:48:37 +1000
Message-ID: <1050902124837.1650@suse.de>
References: <20050902224642.1518.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looks like I should run my test suite with both mdadm-1.12 and mdadm-2.0,
as this slipped through my testing.  (The bug is in code that
didn't reach 2.6.13.  Only -mm is affected).

Thanks,
NeilBrown


### Comments for Changeset

There are two ways to add devices to an md/raid array.

  It can have superblock written to it, and then given to the md driver,
  which will read the superblock (the new way)

or

  md can be told (through SET_ARRAY_INFO) the shape of the array, and
  the told about individual drives, and md will create the required
  superblock (the old way).

The newly introduced sb_size was only set for drives being added the
new way, not the old ways.  Oops :-(

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-09-02 16:00:04.000000000 +1000
+++ ./drivers/md/md.c	2005-09-02 19:29:31.000000000 +1000
@@ -2303,6 +2303,8 @@ static int add_new_disk(mddev_t * mddev,
 		else
 			rdev->in_sync = 0;
 
+		rdev->sb_size = MD_SB_BYTES;
+
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
 			set_bit(WriteMostly, &rdev->flags);
 
