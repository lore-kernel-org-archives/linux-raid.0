From: Jody McIntyre <scjody@sun.com>
Subject: Re: [PATCH v2 05/11] md/raid5: add scribble region for buffer lists
Date: Mon, 08 Jun 2009 13:25:35 -0400
Message-ID: <20090608172535.GA28448@clouds>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
 <20090519005951.4104.27062.stgit@dwillia2-linux.ch.intel.com>
 <18983.26015.413162.445846@notabene.brown>
 <e9c3a7c20906051219x122f443dtc7836f0c16ae9f27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
In-reply-to: <e9c3a7c20906051219x122f443dtc7836f0c16ae9f27@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com, hpa@zytor.com
List-Id: linux-raid.ids

On Fri, Jun 05, 2009 at 12:19:07PM -0700, Dan Williams wrote:
> One of the design goals was to prevent the occurrence of the
> softlockup watchdog events which seem to trigger on large raid6
> resyncs.  A per-cpu scheme would still require preempt_disable() while
> the calculation is active, so perhaps we just need a call to
> cond_resched() in raid5d to appease the scheduler.

FWIW we added this to the patches shipped with Lustre:

Index: linux-2.6.18-128.1.1/drivers/md/raid5.c
===================================================================
--- linux-2.6.18-128.1.1.orig/drivers/md/raid5.c
+++ linux-2.6.18-128.1.1/drivers/md/raid5.c
@@ -2987,6 +2987,8 @@ static void raid5d (mddev_t *mddev)
 		handle_stripe(sh, conf->spare_page);
 		release_stripe(sh);
 
+		cond_resched();
+
 		spin_lock_irq(&conf->device_lock);
 	}
 	PRINTK("%d stripes handled\n", handled);

I thought most of these issues were gone in more recent kernels, but we
haven't tested RAID on anything other than RHEL 4+5 extensively (Lustre
doesn't support sufficiently new kernels yet.)

Cheers,
Jody
