From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mdadm creating raid5 with all spare disks
Date: Fri, 11 Dec 2009 13:47:44 +1300
Message-ID: <4B2196B0.2090604@sauce.co.nz>
References: <1D0665FE-138F-480F-9872-48C94CEBC5C2@mac.com> <20091211071006.56270ebf@notabene.brown> <91296851101702456968380052308470713510-Webmail@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <91296851101702456968380052308470713510-Webmail@me.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Tehonica <matt.tehonica@mac.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matthew Tehonica wrote:

> After about 5 minutes, I try to cat /proc/mdstat again and it just freezes and sits there with the cursor flashing.  At this point, I can do anything with mdadm, not even like a --detail on another array on the system.  Just sits there and flashes.  I've tried with a bunch of different disks and same thing all the time.  Here is a section from my kern.log.  
> 
> Dec 10 19:01:07 ghostrider kernel: [ 1338.011320] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> Dec 10 19:01:07 ghostrider kernel: [ 1338.011330] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> Dec 10 19:01:07 ghostrider kernel: [ 1338.011343] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> Dec 10 19:01:07 ghostrider kernel: [ 1338.011349] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> Dec 10 19:01:07 ghostrider kernel: [ 1338.011443] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> Dec 10 19:01:07 ghostrider kernel: [ 1338.011449] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> Dec 10 19:01:07 ghostrider kernel: [ 1338.011461] end_request: I/O error, dev sdf, sector 0
> Dec 10 19:01:07 ghostrider kernel: [ 1338.011472] md: super_written gets error=-5, uptodate=0

Looks like the drives are being dropped by the controller.

I believe there was some recent discussion here about mv_sas, md and 
failures under heavy I/O load.

Regards,

Richard
