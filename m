From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] Version 1 super block
Date: Mon, 24 Jan 2005 12:38:01 +1100
Message-ID: <16884.20857.878835.1376@cse.unsw.edu.au>
References: <41E9D66E.9080100@us.ibm.com>
	<1106323194.8425.4.camel@dyn95390186.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Tran on Friday January 21
Sender: linux-raid-owner@vger.kernel.org
To: Mike Tran <mhtran@us.ibm.com>
Cc: linux-raid@vger.kernel.org, kevcorry@us.ibm.com
List-Id: linux-raid.ids

On Friday January 21, mhtran@us.ibm.com wrote:
> Hello Neil,
> 
> I've been wondering if you had a chance to look at this patch.  Please
> let me know.

No I hadn't, but I have now.
> 
> On Sat, 2005-01-15 at 20:50, Mike Tran wrote:
> > Hello Neil,
> > 
> > I found 2 problems in the kernel MD driver:
> > 1) if disk index 0 is used, counting of max_dev is wrong

Yes, but I think that the correct fix is simply to add 1 to max_dev,
rather than setting it to max(max_dev, i).
It should really be renamed to "max_devs" (i.e. the maximum number of
devices) rather than "max_dev" (i.e. the maximum device number).
Possibly "num_slots" wold be an even better name...


> > 2) missing checksum calculation

Yes .... how did I miss that :-(


> > 
> > Please consider the attached patch for 2.6.10 kernel.


How about the following?
I'll add a changelog entry and forward it to Andrew shortly.

thanks,
NeilBrown



 ----------- Diffstat output ------------
 ./drivers/md/md.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-01-24 12:34:47.000000000 +1100
+++ ./drivers/md/md.c	2005-01-24 12:36:30.000000000 +1100
@@ -983,8 +983,8 @@ static void super_1_sync(mddev_t *mddev,
 
 	max_dev = 0;
 	ITERATE_RDEV(mddev,rdev2,tmp)
-		if (rdev2->desc_nr > max_dev)
-			max_dev = rdev2->desc_nr;
+		if (rdev2->desc_nr+1 > max_dev)
+			max_dev = rdev2->desc_nr+1;
 	
 	sb->max_dev = cpu_to_le32(max_dev);
 	for (i=0; i<max_dev;i++)
@@ -1001,6 +1001,7 @@ static void super_1_sync(mddev_t *mddev,
 	}
 
 	sb->recovery_offset = cpu_to_le64(0); /* not supported yet */
+	sb->sb_csum = calc_sb_1_csum(sb);
 }
 
 

