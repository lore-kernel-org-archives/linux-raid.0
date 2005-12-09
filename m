From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 resync question BUGREPORT!
Date: Fri, 9 Dec 2005 15:49:17 +1100
Message-ID: <17305.3277.821697.223406@cse.unsw.edu.au>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs>
	<17300.56329.638969.509384@cse.unsw.edu.au>
	<004201c5f9fe$50cc41a0$0400a8c0@dcccs>
	<17300.58327.193597.248431@cse.unsw.edu.au>
	<035b01c5fc4b$416c98f0$0400a8c0@dcccs>
	<17304.50474.390938.734714@cse.unsw.edu.au>
	<001101c5fc75$a28cb230$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Friday December 9
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 9, djani22@dynamicweb.hu wrote:
> Hi,
> 
> After i get this on one of my disk node, imediately send this letter, and go
> to the hosting company, to see, is any message on the screen.
> But unfortunately nothing what i found.
> simple freeze.
> no message, no ping, no num lock!
> 
> The full message of  the node next reboot is here:
> http://download.netcenter.hu/bughunt/20051209/boot.log

Ahh.... Ok, I know the problem.
I had originally only tested bitmaps for raid5 and raid6 on a
single-processor machine.  When you try it on an SMP machine you get a
deadlock.
The following patch - which will be in 2.6.15 - fixes the problem.

Thanks for your testing.

NeilBrown

-------------------------------
Fix locking problem in r5/r6

bitmap_unplug actually writes data (bits) to storage, so we
shouldn't be holding a spinlock...

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c     |    2 ++
 ./drivers/md/raid6main.c |    2 ++
 2 files changed, 4 insertions(+)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c	2005-12-06 11:06:53.000000000 +1100
+++ ./drivers/md/raid5.c~current~	2005-12-06 11:07:10.000000000 +1100
@@ -1704,7 +1704,9 @@ static void raid5d (mddev_t *mddev)
 
 		if (conf->seq_flush - conf->seq_write > 0) {
 			int seq = conf->seq_flush;
+			spin_unlock_irq(&conf->device_lock);
 			bitmap_unplug(mddev->bitmap);
+			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = seq;
 			activate_bit_delay(conf);
 		}

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c	2005-12-06 11:06:53.000000000 +1100
+++ ./drivers/md/raid6main.c~current~	2005-12-06 11:07:10.000000000 +1100
@@ -1784,7 +1784,9 @@ static void raid6d (mddev_t *mddev)
 
 		if (conf->seq_flush - conf->seq_write > 0) {
 			int seq = conf->seq_flush;
+			spin_unlock_irq(&conf->device_lock);
 			bitmap_unplug(mddev->bitmap);
+			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = seq;
 			activate_bit_delay(conf);
 		}
