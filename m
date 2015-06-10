From: Neil Brown <neilb@suse.de>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Wed, 10 Jun 2015 11:57:21 +1000
Message-ID: <20150610115721.64c474fa@home.neil.brown.name>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
	<wrfjzj4glajs.fsf@jes.lga.redhat.com>
	<20150610101942.0bc26a25@home.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150610101942.0bc26a25@home.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

On Wed, 10 Jun 2015 10:19:42 +1000 Neil Brown <neilb@suse.de> wrote:

> So it looks like some sort of race.  I have other evidence of a race
> with the resync/reshape thread starting/stopping.  If I track that
> down it'll probably fix this issue too.

I think I have found just such a race.  If you request a reshape just
as a recovery completes, you can end up with two reshapes running.
This causes confusion :-)

Can you try this patch?  If I can remember how to reproduce my race
I'll test it on that too.

Thanks,
NeilBrown

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 83532fe84205..03f460a1de60 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4146,6 +4146,7 @@ static int raid10_start_reshape(struct mddev
*mddev) 
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0e49b2c94bdd..59e44e99eef3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7368,6 +7368,7 @@ static int raid5_start_reshape(struct mddev
*mddev) 
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	mddev->sync_thread = md_register_thread(md_do_sync, mddev,

