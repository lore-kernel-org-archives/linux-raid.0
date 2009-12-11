From: Matt Tehonica <matt.tehonica@mac.com>
Subject: Re: mdadm creating raid5 with all spare disks
Date: Thu, 10 Dec 2009 20:01:17 -0500
Message-ID: <6E2CD5BC-5F08-44A0-869C-1875DF5CCA9F@mac.com>
References: <1D0665FE-138F-480F-9872-48C94CEBC5C2@mac.com>
 <20091211071006.56270ebf@notabene.brown>
 <91296851101702456968380052308470713510-Webmail@me.com>
 <4B2196B0.2090604@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B2196B0.2090604@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Dec 10, 2009, at 7:47 PM, Richard Scobie <richard@sauce.co.nz> wrote:

> Matthew Tehonica wrote:
>
>> After about 5 minutes, I try to cat /proc/mdstat again and it just  
>> freezes and sits there with the cursor flashing.  At this point, I  
>> can do anything with mdadm, not even like a --detail on another  
>> array on the system.  Just sits there and flashes.  I've tried with  
>> a bunch of different disks and same thing all the time.  Here is a  
>> section from my kern.log.  Dec 10 19:01:07 ghostrider kernel: [ 1338.011320 
>> ] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c  
>> 1669:mvs_abort_task:rc= 5
>> Dec 10 19:01:07 ghostrider kernel: [ 1338.011330] /build/buildd/ 
>> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
>> Dec 10 19:01:07 ghostrider kernel: [ 1338.011343] /build/buildd/ 
>> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
>> Dec 10 19:01:07 ghostrider kernel: [ 1338.011349] /build/buildd/ 
>> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
>> Dec 10 19:01:07 ghostrider kernel: [ 1338.011443] /build/buildd/ 
>> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
>> Dec 10 19:01:07 ghostrider kernel: [ 1338.011449] /build/buildd/ 
>> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
>> Dec 10 19:01:07 ghostrider kernel: [ 1338.011461] end_request: I/O  
>> error, dev sdf, sector 0
>> Dec 10 19:01:07 ghostrider kernel: [ 1338.011472] md: super_written  
>> gets error=-5, uptodate=0
>
> Looks like the drives are being dropped by the controller.
>
> I believe there was some recent discussion here about mv_sas, md and  
> failures under heavy I/O load.
>
> Regards,
>
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks Richard!  After some more review I found many people with this  
problem and appears the linux-scsi devs submitted patches mid last  
month. Building the latest kernel as we speak!
