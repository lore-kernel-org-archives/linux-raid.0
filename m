From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Avoid a deadlock when removing a device from an md
 array via sysfs.
Date: Mon, 2 Apr 2007 18:53:04 +1000
Message-ID: <17936.50288.892586.831178@notabene.brown>
References: <20070402174319.30997.patches@notabene>
	<1070402074417.31093@suse.de>
	<20070402010141.3ad5516d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Monday April 2
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-raid.ids

On Monday April 2, akpm@linux-foundation.org wrote:
> 
> What guarantees that *rdev is still valid when delayed_delete() runs?

Because that is how kobjects and krefs work.  There is an embedded
refcount etc etc..

> 
> And what guarantees that the md module hasn't been rmmodded when
> delayed_delete() tries to run?

Good point.  Nothing.  Maybe this patch is needed.

Thanks,
NeilBrown

---------------------------
Avoid a deadlock when removing a device from an md array via sysfs. - fix

Make sure any delayed_delete calls finish before module unload.
For simplicity, flush the queue when we stop the array.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-04-02 17:38:46.000000000 +1000
+++ ./drivers/md/md.c	2007-04-02 18:49:24.000000000 +1000
@@ -3410,6 +3410,9 @@ static int do_md_stop(mddev_t * mddev, i
 				sysfs_remove_link(&mddev->kobj, nm);
 			}
 
+		/* make sure all delayed_delete calls have finished */
+		flush_scheduled_work();
+
 		export_array(mddev);
 
 		mddev->array_size = 0;
