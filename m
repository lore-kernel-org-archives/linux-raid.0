From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: RAID6 and crashes
Date: Thu, 10 Jun 2010 14:02:42 -0400
Message-ID: <4C1128C2.4020105@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Folks,

I just recently converted a server from a basic Debian Lenny 
installation to a virtualized platform (Debian Lenny, Xen 3, Debian 
Lenny DomUs).

I also converted my underlying disk environment from RAID1 to a mix of 
RAID1 (for Dom0) and RAID6/LVM/DRBD for the domUs.  All the RAID is 
implemented using md.  (Yes I realize there's a performance hit - but it 
seemed like a good idea at the time, and with volumes mounted with 
"noatime" the performance is acceptable, though I'm sort of thinking now 
of moving to RAID10).

Anyway, I'm still working out some instabilities in my virtualized 
environment, and I seem to have a crash/reboot event maybe once a day 
(still trying to track that down).

In some, but not all cases, I find the machine comes up with the RAID6 
volume marked dirty, and an automatic resync gets initiated - which 
takes several hours to complete, and drags performance way down while 
it's going on.

Which leads to two questions:

1. Are there any known problems with md-based RAID6 that might, 
themselves, lead to a crash/reboot? (I always suspect complicated, 
low-level functions that are critical to everything).

2.  Are there any settings that can reduce the likelihood of a RAID 
volume being dirty after a crash?  (The crash/reboot isn't that much of 
a problem - the several hours of degraded performance ARE a problem.)

Thanks Very Much,

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


