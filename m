From: Chris Webb <chris@arachsys.com>
Subject: Re: Trouble increasing md component size
Date: Fri, 20 Jun 2008 00:49:14 +0100
Message-ID: <20080619234914.GA24881@arachsys.com>
References: <20080618182622.GA29468@arachsys.com> <4859605D.90509@rabbit.us> <20080618200036.GB30682@arachsys.com> <18521.54665.166875.489547@notabene.brown> <20080619154520.GB3708@arachsys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080619154520.GB3708@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Chris Webb <chris@arachsys.com> writes:

> However, I'm not sure what the correct call to get the superblock written
> out at this point would be. I tried
> 
>   md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
>                  rdev->sb_page);
> 
> after updating sb->data_size as above, but that doesn't seem to do the right
> thing.

It works without the typo!

> +			((struct mdp_superblock_1 *) sb)->data_size = cpu_to_le64(rdev->size*2);

should read size*2 rather than rdev->size*2.

Cheers,

Chris.

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.24.4-md-rdev-size.patch"

--- linux-2.6.24.4/drivers/md/md.c	2008-03-24 18:49:18.000000000 +0000
+++ linux-2.6.24.4-mdplay/drivers/md/md.c	2008-06-20 00:44:50.000000000 +0100
@@ -1946,8 +1946,20 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 	unsigned long long size = simple_strtoull(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
-		return -EBUSY;
+	if (rdev->mddev->pers) {
+		mdp_super_t *sb;
+		if (rdev->sb_offset > rdev->data_offset/2) {
+			if (!size || size > rdev->sb_offset - rdev->data_offset/2)
+				size = rdev->sb_offset - rdev->data_offset/2;
+		} else if (!size || 2*size + rdev->data_offset > rdev->bdev->bd_inode->i_size >> 9)
+			size = ((rdev->bdev->bd_inode->i_size >> 9) - rdev->data_offset)/2;
+		sb = (mdp_super_t *) page_address(rdev->sb_page);
+		if (sb->major_version == 1) {
+			((struct mdp_superblock_1 *) sb)->data_size = cpu_to_le64(size*2);
+			md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
+					                 rdev->sb_page);
+		}
+	}
 	rdev->size = size;
 	if (size < rdev->mddev->size || rdev->mddev->size == 0)
 		rdev->mddev->size = size;

--82I3+IH0IqGh5yIs--
