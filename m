From: Roy Waldspurger <rlists@frameandfocus.com>
Subject: Re: Clarifications about check/repair, i.e. RAID SCRUBBING
Date: Fri, 02 Jun 2006 10:46:35 -0700
Message-ID: <4480797B.1000605@frameandfocus.com>
References: <447FF458.6030802@frameandfocus.com> <17536.7877.532121.626175@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17536.7877.532121.626175@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, Matt Hartman <m@lafayettezerosix.com>
List-Id: linux-raid.ids

Thanks for clearing things up, Neil.  Looks like I will be issuing 
weekly "repairs" on most of the arrays.

Cheers,

-- roy


Neil Brown wrote:
> On Friday June 2, rlists@frameandfocus.com wrote:
> 
>>In any regard:
>>
>>I'm talking about triggering the following functionality:
>>
>>echo check > /sys/block/mdX/md/sync_action
>>echo repair > /sys/block/mdX/md/sync_action
>>
>>On a RAID5, and soon a RAID6, I'm looking to set up a cron job, and am 
>>trying to figure out what exactly to schedule.  The answers to the 
>>following questions might shed some light on this:
>>
>>1. GENERALLY SPEAKING, WHAT IS THE DIFFERENCE BETWEEN THE "CHECK" AND 
>>"REPAIR" COMMANDS?
>>The "md.txt" doc mentions for "check" that "a repair may also happen for 
>>some raid levels."
>>Which RAID levels, and in what cases?  If I perform a "check" is there a 
>>cache of bad blocks that need to be fixed that can quickly be repaired 
>>by executing the "repair" command?  Or would it go through the entire 
>>array again?  I'm working with new drives, and haven't come across any 
>>bad blocks to test this with.
> 
> 
> 'check' just reads everything and doesn't trigger any writes unless a
> read error is detected, in which case the normally read-error handing
> kicks in.  So it can be useful on a read-only array.
> 
> 'repair' does that same but when it finds an inconsistency is corrects
> it by writing something.
> If any raid personality had not be taught to specifically understand
> 'check', then a 'check' run would effect a 'repair'.  I think 2.6.17
> will have all personalities doing the right thing.
> 
> check doesn't keep a record of problems, just a count.  'repair' will
> reprocess the whole array.
> 
> 
> 
>>2. CAN "CHECK" BE RUN ON A DEGRADED ARRAY (say with N out of N+1 disks 
>>on a RAID level 5)?  I can test this out, but was it designed to do 
>>this, versus "REPAIR" only working on a full set of active drives? 
>>Perhaps "repair" is assuming that I have N+1 disks so that parity can be 
>>WRITTEN?
> 
> 
> No, check on a degraded raid5, or a raid6 with 2 missing devices, or a
> raid1 with only one device will not do anything.  It will terminate
> immediately.   After all, there is nothing useful that it can do.
> 
> 
>>3. RE: FEEDBACK/LOGGING: it seems that I might see some messages in 
>>dmesg logging output such as "raid5:read error corrected!", is that 
>>right?  I realize that "mismatch_count" can also be used to see if there 
>>was any "action" during a "check" or "repair."  I'm assuming this stuff 
>>doesn't make its way into an email.
> 
> 
> You are correct on all counts.  mdadm --monitor doesn't know about
> this yet. ((writes notes in mdadm todo list)).
> 
> 
>>4. DOES "REPAIR" PERFORM READS TO CHECK THE ARRAY, AND THEN WRITE TO THE 
>>ARRAY *ONLY WHEN NECESSARY* TO PERFORM FIXES FOR CERTAIN BLOCKS?  (I 
>>know, it's sorta a repeat of question number 1+2).
>>
> 
> 
> repair only writes when necessary.  In the normal case, it will only
> read every blocks.
> 
> 
> 
>>5. IS THERE ILL-EFFECT TO STOP EITHER "CHECK" OR "REPAIR" BY ISSUING "IDLE"?
> 
> 
> No.
> 
> 
>>6. IS IT AT ALL POSSIBLE TO CHECK A CERTAIN RANGE OF BLOCKS?  And to 
>>keep track of which blocks were checked?  The motivation is to start 
>>checking some blocks overnight, and to pick-up where I left off the next 
>>night...
> 
> 
> Not yet.  It might be possible one day.
> 
> 
>>7. ANY OTHER CONSIDERATIONS WHEN "SCRUBBING" THE RAID?
>>
> 
> 
> Not that I am aware of.
> 
> NeilBrown
> 
> 
> 
>>Sorry for some of these questions being so similar in nature.  I just 
>>want to make sure I understand it correctly.
>>
>>Neil, again, a BIG thanks for this new functionality.  I'm looking 
>>forward to putting a system in place to exercise my drives!
>>
>>Cheers,
>>
>>-- roy
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

