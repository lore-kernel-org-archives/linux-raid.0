From: Tim Small <tim@buttersideup.com>
Subject: Re: disk testing
Date: Fri, 17 Sep 2004 10:18:37 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <414AABED.9040403@buttersideup.com>
References: <20040917025005.DC7F1395B@xprdmailfe9.nwk.excite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040917025005.DC7F1395B@xprdmailfe9.nwk.excite.com>
To: hfranklin97@excite.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

harry wrote:

>Tim and Neil have suggested (apparently correctly) that the disk had a bad sector and the firmware remapped it when I wrote to it. My question is, how many spare sectors does the typical disk have?
>
Good question.  The drive technical documentation (if you can get it) 
may tell you.  I think I low-level formatted a 70G SCSI drive a few 
weeks ago, which had a couple of percent in its default setup (on SCSI, 
you can change the spare portion when you low-level format, if you want to).

I think that it's impossible to tell with xATA drives (at least without 
vendor-specific tools) as the detail is hidden by the firmware, at a 
guess (and it is a complete guess) I would say that it wouldn't be more 
than 0.5% of the drive capacity.  I think that the low-level formatting 
geometry puts a certain percentage of the total raw capacity aside for 
spare sectors - a certain number of these are used up for 
manufacture-time defects (i.e. unusable sectors due to imperfections in 
the platters) when the drive is low-level formatted in the factory, and 
the rest of the spare sectors (down to some manufacturer define minimum 
below which the drive fails QC) are left for in-service spares.  BICBW.

> More importantly, since the sector has been remapped, recreating the raid5 array worked fine, but is a failure right out of the box normal? I was going to return it but since its working now I'm not sure if I should or not.
>  
>
Well, that's a difficult choice - here are some things that may help you 
to decide:

. Do the SMART read-retry counts etc. seem to be noticeably higher than 
the other drives in the array, or are they increasing quicker (or for 
"rate" variables, are they lower, or decreasing, as some drives 
represent these "1 failure every x operations" style counters)?
. How long does the warranty run for?
. Will the mfr, or your supplier actually take the drive back in its 
current condition?  -  If you run their "factory revalidation test" or 
whatever they call it, the drive will probably pass now
. How much is your time to replace it worth vs. the cost of the drive 
(or the cost of the drive once its warranty has expired).

If it was me, I'd be inclined to leave it in place, but return it if I 
got another failure on a different part of the disk (if an adjacent 
sector fails this may be OK), or if the drive looked to be deteriorating 
quickly.


If SMART support for libata was complete, I'd be inclined to get smartd 
to run an extended self-test on the drive every week.  As it is, you may 
want to do this manually a couple of times on the drive to see what 
difference this makes to the SMART counters (smartctl -t long)..

Another option is to put in a cron job that does "dd if=/dev/sdx 
of=/dev/null" once a week for all drives in the array (e.g. every Sunday 
night, or some other quiet period for the computer) to give the drives a 
similar work out to the SMART long test (albeit with a lot more work for 
the CPU, and buses) - this way, you get to check that all sectors are 
readable (and the firmware may get the chance to correct failing sectors 
before they become unreadable - if the drive firmware support this).


Tim.

