From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: RAID1, backup & BCV
Date: Wed, 19 Jun 2002 08:55:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CDF05CB9FCA0C845B9778F9E463C4761255390@cinshrexc01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: "Buechler, Mark R" <Mark_R_Buechler@bausch.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We had a triple mirror setup on our production box to do almost what you
are describing.  We wouldn't do reverse sync, but we had a triple mirror
throughout the day and then broke off one of the devices at night with
mdctl (now mdadm) and backed it up.  After the backup we resynced and
again had a triple mirror.

I don't see a problem with the reverse sync, but you would have to
script something like that.  No fancy GUI stuff or scripts pre-made like
EMC.

Regards,
Andy.

Andrew Rechenberg
Infrastructure Team, Sherman Financial Group
arechenberg (at) shermanfinancialgroup.com



-----Original Message-----
From: Buechler, Mark R [mailto:Mark_R_Buechler@bausch.com] 
Sent: Wednesday, June 19, 2002 8:40 AM
To: 'linux-raid@vger.kernel.org'
Subject: RAID1, backup & BCV


I was wondering if Linux RAID had anything like what EMC corporation
calls a BCV (Business Continuity Volume). A BCV is simply a second or
third mirror which is synced up with the main devices and then broken
off and kept as a backup. You can then at any point restore from the BCV
mirror by doing a reverse sync from it to the main devices. This is a
very handy thing when it comes to shared disk. You can sync a mirror on
one system, break it and mount it up on another to back it up and all
without having to stop any applications on the primary server or put any
excessive load on it.

I was wondering if there were plans for this sort of functionality or if
anyone has given it any thought.

- Mark.


EMAIL DISCLAIMER 

Please Note: The information contained in this message may be privileged
and confidential, protected from disclosure, and/or intended only for
the use of the individual or entity named above. If the reader of this
message is not the intended recipient, or an employee or agent
responsible for delivering this message to the intended recipient, you
are hereby notified that any disclosure, distribution, copying or other
dissemination of this communication is strictly prohibited. If you
received this communication in error, please immediately reply to the
sender, delete the message and destroy all copies of it.

Thank You
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
