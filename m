From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: BUGREPORT: mdadm v2.0-devel - can't create array using version
 1 superblock, possibly related to previous bugreport
Date: Wed, 4 May 2005 15:59:16 +1000
Message-ID: <17016.25780.914854.293277@cse.unsw.edu.au>
References: <42775D47.4000805@dtbb.net>
	<17016.3902.917012.297224@cse.unsw.edu.au>
	<4278271B.1020408@dtbb.net>
	<17016.12489.9021.728737@cse.unsw.edu.au>
	<427858EB.4070501@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tyler on Tuesday May 3
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 3, pml@dtbb.net wrote:
> What kernel are you using Neil, and what patches to the kernel if any, 
> and which patches to mdadm 2.0-devel?  

2.6.12-rc2-mm1  and a few patches to mdadm, but none significant to
your current issue.

The reason it worked for me is that I tried raid6 and you tried raid5.
To make it work with raid5 you need the following patch.  I haven't
actually tested it as my test machine has had odd hardware issues for
ages (only causing problems at reboot, but for a test machine, that is
often..) and it is finally being looked at.

Let me know if this gets you further.

NeilBrown


 ----------- Diffstat output ------------
 ./super1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./super1.c~current~ ./super1.c
--- ./super1.c~current~	2005-05-04 12:06:33.000000000 +1000
+++ ./super1.c	2005-05-04 15:54:59.000000000 +1000
@@ -411,7 +411,7 @@ static int init_super1(void **sbp, mdu_a
 
 	sb->utime = sb->ctime;
 	sb->events = __cpu_to_le64(1);
-	if (info->state & MD_SB_CLEAN)
+	if (info->state & (1<<MD_SB_CLEAN))
 		sb->resync_offset = ~0ULL;
 	else
 		sb->resync_offset = 0;
