From: "Buechler, Mark R" <Mark_R_Buechler@bausch.com>
Subject: RAID1, backup & BCV
Date: Wed, 19 Jun 2002 08:39:59 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <D3BC284A3EACD5119CDF0002A53F8B971FFC2B@blmsrocopc02.bausch.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was wondering if Linux RAID had anything like what EMC corporation calls a
BCV (Business Continuity Volume). A BCV is simply a second or third mirror
which is synced up with the main devices and then broken off and kept as a
backup. You can then at any point restore from the BCV mirror by doing a
reverse sync from it to the main devices. This is a very handy thing when it
comes to shared disk. You can sync a mirror on one system, break it and
mount it up on another to back it up and all without having to stop any
applications on the primary server or put any excessive load on it.

I was wondering if there were plans for this sort of functionality or if
anyone has given it any thought.

- Mark.


EMAIL DISCLAIMER 

Please Note: The information contained in this message may be privileged and
confidential, protected from disclosure, and/or intended only for the use of
the individual or entity named above. If the reader of this message is not
the intended recipient, or an employee or agent responsible for delivering
this message to the intended recipient, you are hereby notified that any
disclosure, distribution, copying or other dissemination of this
communication is strictly prohibited. If you received this communication in
error, please immediately reply to the sender, delete the message and
destroy all copies of it.

Thank You
