From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH] max_dev bug in super_1_sync
Date: Mon, 21 Feb 2005 14:31:39 -0500
Message-ID: <421A371B.7040802@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080408080002040802030603"
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080408080002040802030603
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Neil,

I don't know if you've seen this one yet, but it looks like there's a 
small bug in super_1_sync. Patch attached.

--
Paul

--------------080408080002040802030603
Content-Type: text/plain;
 name="md_max_dev_bug.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_max_dev_bug.diff"

--- linux-2.6.11-rc3-mm2-patch-all-write-mostly/drivers/md/md.c	Mon Feb 21 12:23:32 2005
+++ linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug/drivers/md/md.c	Mon Feb 21 14:22:21 2005
@@ -1018,7 +1018,7 @@ static void super_1_sync(mddev_t *mddev,
 	
 	sb->max_dev = cpu_to_le32(max_dev);
 	for (i=0; i<max_dev;i++)
-		sb->dev_roles[max_dev] = cpu_to_le16(0xfffe);
+		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	
 	ITERATE_RDEV(mddev,rdev2,tmp) {
 		i = rdev2->desc_nr;

--------------080408080002040802030603--
