From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: PROBLEM: software RAID breakage under 2.6.1-mm4
Date: Sun, 18 Jan 2004 16:04:47 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16394.5103.675762.904141@notabene.cse.unsw.edu.au>
References: <Pine.GSO.4.58.0401171318560.10877@denali.ccs.neu.edu>
	<16393.46697.630398.566295@notabene.cse.unsw.edu.au>
	<Pine.GSO.4.58.0401171919250.10717@denali.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim Faulkner on Saturday January 17
To: Jim Faulkner <jfaulkne@ccs.neu.edu>
Cc: linux-raid@vger.kernel.org, akpm@osdl.org
List-Id: linux-raid.ids

On Saturday January 17, jfaulkne@ccs.neu.edu wrote:
> 
> Oops, sorry about that, you are right, on older kernels md2 is setup
> using raidstart in the Gentoo boot scripts, not during the autodetection
> phase.  As a matter of fact, the dmesg output for older kernels (included
> below) is very similar to what I posted earlier.
> 
> However, there is still a behavioral change here.  On 2.6.1-mm2 and below,
> I did not have to run "raidstop /dev/md2" before running "raidstart
> /dev/md2".  On 2.6.1-mm4 I do.  I'm not sure if this change is intentional
> or not, and of course its not a big deal for me to modify my boot scripts.
> 

Ok, that makes sense.  I was a bit over-enthusiasitic with on of the
patches that I recently submitted.  This call the do_md_stop really is
needed after all.

Thanks,
NeilBrown



 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-16 20:34:48.000000000 +1100
+++ ./drivers/md/md.c	2004-01-18 16:03:23.000000000 +1100
@@ -1766,8 +1766,10 @@ static void autorun_array(mddev_t *mddev
 	printk("\n");
 
 	err = do_md_run (mddev);
-	if (err)
+	if (err) {
 		printk(KERN_WARNING "md :do_md_run() returned %d\n", err);
+		do_md_stop(mddev, 0);
+	}
 }
 
 /*
