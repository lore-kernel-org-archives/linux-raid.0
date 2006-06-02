From: Roy Waldspurger <rlists@frameandfocus.com>
Subject: Clarifications about check/repair, i.e. RAID SCRUBBING
Date: Fri, 02 Jun 2006 01:18:32 -0700
Message-ID: <447FF458.6030802@frameandfocus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil/folks,

I'm seeking some (hopefully) simple clarifications about the newer raid 
checking and scrubbing behavior present in more recent kernels.  I must 
say that I was more than pleased when I learned about the new 
functionality.  Kudos, Neil for this addition.  Unfortunately, because 
this is new it's not to be found in the FAQs or HOW-TOs... with the 
exception of the Gentoo "HOWTO Install on Software RAID".

I've looked at the following sources of info:
linux-2.6.16.19/Documentation/md.txt
linux-2.6.16.19/drivers/md:raid5.c and raid6main.c
(the raid5_end_read_request and raid6_end_read_request routines)

emails on the linux-raid mailing list, in particular:

http://lkml.org/lkml/2005/12/4/118
http://www.mail-archive.com/linux-raid@vger.kernel.org/msg04615.html
===============================================================

In any regard:

I'm talking about triggering the following functionality:

echo check > /sys/block/mdX/md/sync_action
echo repair > /sys/block/mdX/md/sync_action

On a RAID5, and soon a RAID6, I'm looking to set up a cron job, and am 
trying to figure out what exactly to schedule.  The answers to the 
following questions might shed some light on this:

1. GENERALLY SPEAKING, WHAT IS THE DIFFERENCE BETWEEN THE "CHECK" AND 
"REPAIR" COMMANDS?
The "md.txt" doc mentions for "check" that "a repair may also happen for 
some raid levels."
Which RAID levels, and in what cases?  If I perform a "check" is there a 
cache of bad blocks that need to be fixed that can quickly be repaired 
by executing the "repair" command?  Or would it go through the entire 
array again?  I'm working with new drives, and haven't come across any 
bad blocks to test this with.

2. CAN "CHECK" BE RUN ON A DEGRADED ARRAY (say with N out of N+1 disks 
on a RAID level 5)?  I can test this out, but was it designed to do 
this, versus "REPAIR" only working on a full set of active drives? 
Perhaps "repair" is assuming that I have N+1 disks so that parity can be 
WRITTEN?

3. RE: FEEDBACK/LOGGING: it seems that I might see some messages in 
dmesg logging output such as "raid5:read error corrected!", is that 
right?  I realize that "mismatch_count" can also be used to see if there 
was any "action" during a "check" or "repair."  I'm assuming this stuff 
doesn't make its way into an email.

4. DOES "REPAIR" PERFORM READS TO CHECK THE ARRAY, AND THEN WRITE TO THE 
ARRAY *ONLY WHEN NECESSARY* TO PERFORM FIXES FOR CERTAIN BLOCKS?  (I 
know, it's sorta a repeat of question number 1+2).

5. IS THERE ILL-EFFECT TO STOP EITHER "CHECK" OR "REPAIR" BY ISSUING "IDLE"?

6. IS IT AT ALL POSSIBLE TO CHECK A CERTAIN RANGE OF BLOCKS?  And to 
keep track of which blocks were checked?  The motivation is to start 
checking some blocks overnight, and to pick-up where I left off the next 
night...

7. ANY OTHER CONSIDERATIONS WHEN "SCRUBBING" THE RAID?

Sorry for some of these questions being so similar in nature.  I just 
want to make sure I understand it correctly.

Neil, again, a BIG thanks for this new functionality.  I'm looking 
forward to putting a system in place to exercise my drives!

Cheers,

-- roy
