From: Shaohua Li <shli@kernel.org>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Fri, 4 Dec 2015 10:51:55 -0800
Message-ID: <20151204185155.GA3590@kernel.org>
References: <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
 <565F03F2.3070803@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
 <565F1035.10800@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
 <565F136F.2090709@turmel.org>
 <CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
 <F7761B9B1D11B64BBB666019E9378117FDDF77@CFWEX01.americas.cray.com>
 <566059E8.60804@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDE157@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FDE157@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>
Cc: Phil Turmel <philip@turmel.org>, Dallas Clement <dallas.a.clement@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 04, 2015 at 01:40:02PM +0000, Robert Kierski wrote:
> It turns out the problem I'm experiencing is related to thread count.  When I run XDD with a reasonable queuedepth parameter (32), I get horrible performance.  When I run it with a small queuedepth (1-4), I get expected performance.
> 
> Here are the command lines:
> 
> Horrible Performance:
> xdd -id commandline -dio -maxall -targets 1 /dev/md0 -queuedepth 32  -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
> 
> GOOD Performance:
> xdd -id commandline -dio -maxall -targets 1 /dev/md0 -queuedepth 1 -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
> 
> BEST Performance:
> xdd -id commandline -dio -maxall -targets 1 /dev/md0 -queuedepth 3 -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
> 
> BAD Performance
> xdd -id commandline -dio -maxall -targets 1 /dev/md1 -queuedepth 5 -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential

the performance issue only happens for directIO write, right? did you check
buffered write? The directIO case doesn't delay write, so will create more
read-modify-write. you can check with below debug code.


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 45933c1..d480cc3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5278,10 +5278,10 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 			}
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if ((!sh->batch_head || sh == sh->batch_head) &&
-			    (bi->bi_rw & REQ_SYNC) &&
-			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-				atomic_inc(&conf->preread_active_stripes);
+//			if ((!sh->batch_head || sh == sh->batch_head) &&
+//			    (bi->bi_rw & REQ_SYNC) &&
+//			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+//				atomic_inc(&conf->preread_active_stripes);
 			release_stripe_plug(mddev, sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
