From: Michael Stumpf <mjstumpf@pobox.com>
Subject: 2 drive dropout (and raid 5), simultaneous, after 3 years
Date: Wed, 08 Dec 2004 15:02:50 -0600
Message-ID: <41B76BFA.4030000@pobox.com>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've got a an LVM cobbled together of 2 RAID-5 md's.  For the longest 
time I was running with 3 promise cards and surviving everything 
including the occasional drive failure, then suddenly I had double drive 
dropouts and the array would go into a degraded state.

10 drives in the system, Linux 2.4.22, Slackware 9, mdadm v1.2.0 (13 mar 
2003)

I started to diagnose; fdisk -l /dev/hdi  returned nothing for the two 
failed drives, but "dmesg" reports that the drives are happy, and that 
the md would have been automounted if not for a mismatch on the event 
counters (of the 2 failed drives).

I assumed that this had something to do with my semi-nonstandard 
application of a zillion (3) promise cards in 1 system, but I never had 
this problem before.  I ripped out the promise cards and stuck in 3ware 
5700s, cleaning it up a bit and also putting a single drive per ATA 
channel.  Two weeks later, the same problem crops up again.

The "problematic" drives are even mixed; 1 is WD, 1 is Maxtor (both 120gig).

Is this a known bug in 2.4.22 or mdadm 1.2.0?  Suggestions?


--------------------------------------------
My mailbox is spam-free with ChoiceMail, the leader in personal and corporate anti-spam solutions. Download your free copy of ChoiceMail from www.choicemailfree.com

