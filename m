From: Neil Brown <neilb@suse.de>
Subject: Re: Strange RAID-5 rebuild problem
Date: Mon, 3 Mar 2008 11:33:36 +1100
Message-ID: <18379.18272.464486.925011@notabene.brown>
References: <656D8E57-804D-4A63-B9CA-D3C899616F61@it-loops.com>
	<3816592D-B75C-4B00-B3B7-65AE3B403DB0@it-loops.com>
	<20080301222326.GA20435@cthulhu.home.robinhill.me.uk>
	<2BABB51E-7701-44D4-AD07-6394CCF77941@it-loops.com>
	<A5F6B52A-00BB-4096-9A8D-367F61989186@it-loops.com>
	<244F7F54-081B-462E-A0AD-8E5E1056B90B@it-loops.com>
	<47CA7CE0.9050702@msgid.tls.msk.ru>
	<0D90EC1B-DE2A-4A9B-A63C-323838FF937A@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Guntsche on Sunday March 2
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guntsche <mike@it-loops.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids

On Sunday March 2, mike@it-loops.com wrote:
> 
> So apparently it does switch to read-write on the first write  
> request, but the rebuild is not continuing.

Yes. 
This bug is fixed by the following patch which I have just sent of for
inclusion in mainline.
The patches talks about "reshape" but it applies to "resync" too.

The workaround is to "mdadm -w" before the first write.

Thanks,
NeilBrown


Make sure a reshape is started when device switches to read-write.

A resync/reshape/recovery thread will refuse to progress when the
array is marked read-only.  So whenever it mark it not read-only, it
is important to wake up thread resync thread.
There is one place we didn't do this.

The problem manifests if the start_ro module parameters is set, and a
raid5 array that is in the middle of a reshape (restripe) is started.
The array will initially be semi-read-only (meaning it acts like it is
readonly until the first write).  So the reshape will not proceed.

On the first write, the array will become read-write, but the reshape
will not be started, and there is no event which will ever restart
that thread.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-02-22 15:46:25.000000000 +1100
+++ ./drivers/md/md.c	2008-02-22 15:46:52.000000000 +1100
@@ -5356,6 +5356,7 @@ void md_write_start(mddev_t *mddev, stru
 		mddev->ro = 0;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
+		md_wakeup_thread(mddev->sync_thread);
 	}
 	atomic_inc(&mddev->writes_pending);
 	if (mddev->in_sync) {
