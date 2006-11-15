From: "Danny Sung" <dsung@lantronix.com>
Subject: Raid1 uses partially reconstructed drive
Date: Wed, 15 Nov 2006 15:53:01 -0800
Message-ID: <2F0FC2A92C0B154BB406D5E74CB3E6930336BDC1@3putt.int.lantronix.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Perhaps this is the problem addressed in the 2.6.18.2 patch... But I
thought I'd post it here just in case.

I was cloning some drives, and ended up creating a 1 drive RAID1 array.
After that was built, I decided to add my spare drive and allow the
reconstruction to take care of things.  As soon as I saw that
reconstruction was taking place, I shutdown the system, put the drives
away and closed the case.

To my surprise, when I booted, I encountered numerous disk errors.
Apparently the system decided to ues the partially reconstructed drive
as the primary!  And of course, it had no knowledge that reconstruction
needed to continue.  My data was hosed and I had to restart the cloning
process.

This was using on an FC5 system, using kernel 2.6.18.
(2.6.18-1.2200-smp).


This appears to be the same issue that Doug Ledford had in his posting
"mdadm-2.5.4 issues and 2.6.18.1 kernel md issues"


(appologies for the disclaimer below... Please don't hate us because we
have lawyers).
**********************************************************************
This e-mail is the property of Lantronix. It is intended only for the person or entity to which it is addressed and may contain information that is privileged, confidential, or otherwise protected from disclosure. Distribution or copying of this e-mail, or the information contained herein, to anyone other than the intended recipient is prohibited.

