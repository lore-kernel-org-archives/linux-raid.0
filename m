From: "Mark Klarzynski" <mark.k@computer-design.co.uk>
Subject: good drive / bad drive  (maxtor topic)
Date: Thu, 25 Nov 2004 11:46:06 -0000
Message-ID: <005301c4d2e4$5a0bb670$4500a8c0@MarkK>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


In the world of hardware raid we decide that a drive has failed based on
various criteria, one of which is the obvious 'has the drive responded'
within a set time.  This set time various depending on the drive, the
application, the load etc.  This 'timeout' value is realistically
between 6 and 10 seconds.  There is no real formula, just lots of
experience. Set it too short and drives will look failed too often, set
it too long and you risk allowing a suspect drive to continue.

Once we detect a timeout we have to decide what to with it. in SCSI we
issue a scsi bus rest (hardware reset on the bus).. the reason we do
this (and all hardware raid manufactures) is because life is just that
way. drives do lock up.   We issue up to 3 resets, and then fail.  This
is extremely effective and does exactly what it is supposed to do.
Often the drive will never cause an issue again. if it is faulty then it
will escalate and fail.

We have utilised countless sata drives, and timeouts are by far the most
significant failure we see and as sata (although its hard to tell much
else on sata).. but it is therefore imperative that the timeout values
are correct for the drive and the application.

But the point is that we do not see anywhere near the failure rates on
the Maxtor's that you guys are mentioning.  Also, if we trial sata's on
different hardware RAID's we see differing failure rates... (i.e. ICP
come in higher then 3ware, which are higher than the host independent
raids we have tested and so on)

So I am wondering if it is worth thinking about the timeout values?  And
what do you do once the drive has timed out?

I am seeing some tremendous work going on in this group and without a
doubt this community is going to propel MD to enterprise level raid one
day. so this is honestly meant as constructive and is based on way too
many years designing raid solutions. i.e. I'm not looking to start an
argument simply offering some information.





