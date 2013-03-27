From: Vlad Cerny <vcerny@md-com.com>
Subject: RAID hot_replace behavior with another disk failure
Date: Wed, 27 Mar 2013 13:46:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.58.1303271344420.30908@omega.rcomp.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I am trying to understand how the hot replace works because I suffered
damages from multiple disk failures before.

I initiated data migration from an active disk to a spare in RAID6
(echo want_replacement) and the source disk failed. The procedure continued
reconstructing the data from the other disks and finished as expected.

I tested hot replace when another active disk failed during the procedure.
The procedure finished, marked the original drive as faulty.
(in kernel 3.4.11 the array remained degraded, even when adding
additional spare, under 3.8.4 the automatic rebuild was performed after
adding a spare).

In an event of another disk failure I expected the hot replace to cancel
the copy from the source functioning disk to the spare, and initiate
the array rebuild using the spare.

Is my expectation wrong?
Thank you,

Vlad
