From: Brian Schwarz <Brian.Schwarz@veritas.com>
Subject: RE: Software RAID level 1 issue
Date: Fri, 30 May 2003 11:28:19 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Greg Rasberry' <rgreg-r@pacbell.net>, 'Linux raid mailing list' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greg,

Can't help you with the LVM specifics, but I would suggest investigating
functionality called Dirty Region Logging (DRL). I know we have a feature in
the VERITAS Volume Manager that tracks changes at a block level so the
resync can happen much more quickly. Think of it as similar to a transaction
log or Redo log in Oracle. Not sure if LVM has the same type of
functionality. Won't help you this time, but will save you next time. One
trade-off is that it costs you some I/Os to write and clear the log, would
recommend putting the log on a RAID 10 volume. More info on VERITAS Volume
Manager at www.veritas.com/linux.

Regards,

-Brian


-----Original Message-----
From: Greg Rasberry [mailto:rgreg-r@pacbell.net]
Sent: Friday, May 30, 2003 10:54 AM
To: 'Linux raid mailing list'
Subject: Software RAID level 1 issue


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

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
