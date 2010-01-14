From: Brett Russ <bruss@netezza.com>
Subject: deeper understanding of non-fresh
Date: Thu, 14 Jan 2010 10:05:52 -0500
Message-ID: <hinbsg$euv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We're seeing cases of kicking non-fresh drives from arrays upon 
assemble, forcing full md recovery which takes hours.  To that end, I've 
done some research to understand what this means and why it's happening.

From: http://comments.gmane.org/gmane.linux.raid/17971 non-fresh means:
"The 'event' count is too small.  Every event that happens on an array 
causes the event count to be incremented.  If the event counts on 
different devices differ by more than 1, then the smaller number is 
'non-fresh'."
where an event is:
"- switch from clean to dirty
- switch from dirty to clean
- a device fails
- a spare finishes recovery
things like that."

This is confirmed in this post as well:
http://permalink.gmane.org/gmane.linux.raid/9005 where Neil advises:
"'non-fresh' means that it doesn't seem to up-to-date with respect to 
the other drives in the array.  Use "mdadm --examine /dev/sda1" and 
compare that with "mdadm --examine /dev/sdc1" to see what the difference 
is.  It is probably the Event count.
To re-incorporate sda1 into the array, use
     mdadm /dev/md0 -a /dev/sda1"


We'd appreciate a deeper understanding of non-fresh as it relates to the 
event counters, bitmap, and resync vs. recovery. Here are some specific 
questions following an initial look at the raid1 code.  We're using 
superblock v1.0 and an on-device bitmap.

1) It appears the bitmap continues to be set on a degraded unit.  Is 
this true?  If so:
1a) Does a copy of the bitmap reside on every member of the array?
1b) Can the "fresh" members of the md serve a valid resync bitmap to the 
"non-fresh" members upon detecting the non-fresh condition, thus 
inducing the (quick) resync instead of the (very long) recovery?

To summarize, we are looking to leverage the bitmap to resync, instead 
of kicking out, a previous member of the array.

Thanks,
Brett

