From: Gabriel Ambuehl <gabriel_ambuehl@buz.ch>
Subject: Timeout until degrade of RAID5 array
Date: Sun, 7 Jun 2009 21:19:22 +0200
Message-ID: <200906072119.22807.gabriel_ambuehl@buz.ch>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear List
Apologies if this is a FAQ but googling for an hour did not yield much of a 
result. 

My situation:
I have a NAS running 4 WD greenpower drives in RAID5. This works all nice and 
dandy, but since I do not actually need the NAS 90% of the time, I figured I 
would allow the drives to spin down to save on both power, noise and heat 
budget.

This works most of the times, but I've seen a few cases by now where one drive 
was kicked out of the array upon wake up. My assumption is the drive took a 
little too long to wake up and hence hit some form of a time out especially 
because I could easily rebuild the array with the same drive.

So Is there any way to increase the time that md would wait until removing a 
drive from an array?

Thanks for your time and kind regards,
Gabriel
