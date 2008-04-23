From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: [patch] limit error rate
Date: Thu, 24 Apr 2008 00:55:17 +0200
Message-ID: <200804240055.17675.bernd-schubert@gmx.de>
References: <ftquac$82m$1@ger.gmane.org> <e9c3a7c20804221744m6600eccdy9934f58fb6ccded3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_V57DIFpCdvn8UPF"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20804221744m6600eccdy9934f58fb6ccded3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Boundary-00=_V57DIFpCdvn8UPF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Dan,

On Wednesday 23 April 2008, Dan Williams wrote:
> On Sat, Apr 12, 2008 at 11:16 AM, Bernd Schubert <bernd-schubert@gmx.de> 
wrote:
> > Hello,
> >
> >  last night we had scsi problems and a hardware raid
> >  unit was offlined during heavy i/o. While this happened we got for
> >  about 3 minutes a huge number messages like these
> >
> >  Apr 12 03:36:07 pfs1n14 kernel: [197510.696595] raid5:md7: read error
> > not correctable (sector 2993096568 on sdj2).
> >
> >  I guess the high error rate is responsible for not scheduling other
> >  events - during this time the system was not pingable and in the end
> >  also other devices run into scsi command timeouts causing problems on
> >  these unrelated devices as well.
> >
> >
> >  Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>
>
> Hi Bernd,
>
> This patch is whitespace damaged (tabs-->spaces).  Can you resend as
> an attachment?


hmm, don't know how I managed to do that. Probably copied it from the shell...
I have attached it this time. I also just added another printk_ratelimit().

Btw, from my point of view the 

if (printk_ratelimit())
	printk("print output");

looks odd. I just don't see why the API isn't

printk_ratelimit("print output");

Oh well, modifying this all over the code would give a huge almost useless 
patch _only_ improving the beauty of code.


Thanks,
Bernd

--Boundary-00=_V57DIFpCdvn8UPF
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="limit_read_error_not_correctable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="limit_read_error_not_correctable.patch"

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b162b83..60d3442 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1141,10 +1141,12 @@ static void raid5_end_read_request(struct bio * bi, int error)
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			rdev = conf->disks[i].rdev;
-			printk(KERN_INFO "raid5:%s: read error corrected (%lu sectors at %llu on %s)\n",
-			       mdname(conf->mddev), STRIPE_SECTORS,
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdevname(rdev->bdev, b));
+			if (printk_ratelimit())
+				printk(KERN_INFO "raid5:%s: read error corrected"
+				       " (%lu sectors at %llu on %s)\n",
+				       mdname(conf->mddev), STRIPE_SECTORS,
+				       (unsigned long long)(sh->sector + rdev->data_offset),
+				       bdevname(rdev->bdev, b));
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
@@ -1157,19 +1159,20 @@ static void raid5_end_read_request(struct bio * bi, int error)
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
-		if (conf->mddev->degraded)
+		if (conf->mddev->degraded && printk_ratelimit())
 			printk(KERN_WARNING "raid5:%s: read error not correctable (sector %llu on %s).\n",
 			       mdname(conf->mddev),
 			       (unsigned long long)(sh->sector + rdev->data_offset),
 			       bdn);
-		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
+		else if (test_bit(R5_ReWrite, &sh->dev[i].flags) && 
+			 printk_ratelimit())
 			/* Oh, no!!! */
 			printk(KERN_WARNING "raid5:%s: read error NOT corrected!! (sector %llu on %s).\n",
 			       mdname(conf->mddev),
 			       (unsigned long long)(sh->sector + rdev->data_offset),
 			       bdn);
 		else if (atomic_read(&rdev->read_errors)
-			 > conf->max_nr_stripes)
+			 > conf->max_nr_stripes && printk_ratelimit())
 			printk(KERN_WARNING
 			       "raid5:%s: Too many read errors, failing device %s.\n",
 			       mdname(conf->mddev), bdn);

--Boundary-00=_V57DIFpCdvn8UPF--
