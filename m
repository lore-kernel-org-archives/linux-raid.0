From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Oops with 2.5.27 (swapper)
Date: Mon, 22 Jul 2002 13:47:50 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15675.32870.835514.223427@notabene.cse.unsw.edu.au>
References: <1027271675.619.6.camel@sector17.home.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christian Thalinger on  July 21
To: Christian Thalinger <twisti@complang.tuwien.ac.at>
Cc: Reuben Farrelly <reuben@reub.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  July 21, twisti@complang.tuwien.ac.at wrote:
> Yesterday i've tried 2.5.27 and got this oops during boot (oops written
> down by hand):


This should fix it.

Thanks,
NeilBrown

--- drivers/md/md.c	2002/07/18 12:08:58	1.19
+++ drivers/md/md.c	2002/07/22 03:46:53
@@ -847,7 +847,7 @@ static void sync_sbs(mddev_t * mddev)
 		MD_BUG();
 		return;
 	}
-	rdev = list_entry(&mddev->disks.next, mdk_rdev_t, same_set);
+	rdev = list_entry(mddev->disks.next, mdk_rdev_t, same_set);
 	sb = rdev->sb;
 
 	memset(sb, 0, sizeof(*sb));
