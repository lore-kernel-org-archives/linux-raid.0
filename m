From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md - 3 of 3 - Don't check a device size before bd_get in md.c
Date: Thu, 20 Mar 2003 10:37:57 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15992.65365.197323.672025@notabene.cse.unsw.edu.au>
References: <E18tH4s-0008ID-00@notabene.cse.unsw.edu.au>
	<20030313092209.GD32759@marowsky-bree.de>
	<15984.20890.240751.857817@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.53L.0303191613010.6210@freak.distro.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marcelo Tosatti on Wednesday March 19
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Lars Marowsky-Bree <lmb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 19, marcelo@conectiva.com.br wrote:
> 
> Its already on my tree.

Great.  This will fix it up.

Thanks.
NeilBrown


Fix compile errors/warnings in md

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-20 09:58:02.000000000 +1100
+++ ./drivers/md/md.c	2003-03-20 10:33:04.000000000 +1100
@@ -2422,7 +2422,7 @@ static int hot_add_disk(mddev_t * mddev,
 		printk(KERN_WARNING "md%d: disk size %d blocks < array size %d\n",
 				mdidx(mddev), size, mddev->sb->size);
 		err = -ENOSPC;
-		gotot abort_export;
+		goto abort_export;
 	}
 	bind_rdev_to_array(rdev, mddev);
 
@@ -3066,7 +3066,7 @@ int md_error(mddev_t *mddev, kdev_t rdev
 	return 0;
 }
 
-static int status_unused(struct seq_file *seq)
+static void status_unused(struct seq_file *seq)
 {
 	int i = 0;
 	mdk_rdev_t *rdev;
