From: Greg Rasberry <rgreg-r@pacbell.net>
Subject: Software RAID level 1 issue
Date: Fri, 30 May 2003 10:53:45 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <01C32699.D5B0EE60.rgreg-r@pacbell.net>
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Linux raid mailing list' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a RedHat 9.0 server that went down. On re-start the server has 
started to come up just fine. It started re-syncing, the first of the raid 
partitions, the first one went buy fast, then the second took a day and the 
last drive (md2) has been working on the re-sync for four days (it is 
fairly large 70 Gig).  We are unable to use the server and cannot pull the 
data off of it because the drives have not mounted, etc.

I was wondering if anyone knows if this is normal, and/or how I can get 
around this problem. I understand that the re-sync is supposed to happen in 
the background?

I have only been using Linux for about a year and could really use some 
help with this, the system has been down for a week.
Thanks in advance for your help.

R,
Greg

