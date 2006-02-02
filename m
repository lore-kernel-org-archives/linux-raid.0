From: David Liontooth <liontooth@cogweb.net>
Subject: RAID 16?
Date: Wed, 01 Feb 2006 21:59:07 -0800
Message-ID: <43E19FAB.4000603@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


We're wondering if it's possible to run the following --

  * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card
  * the OS will see these are four normal drives
  * use md to configure them into a RAID 6 array

Would this work? Would it be better than RAID 15? We're looking for a
very high redundancy system.

This is on a Debian system running the 2.6 kernel. We're contemplating
running EVMS on top.

Dave


