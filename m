From: Martin Wilck <mwilck@arcor.de>
Subject: Installing CentOS 6.4 on DDF fake RAID with mdadm
Date: Fri, 23 Aug 2013 23:15:02 +0200
Message-ID: <5217D0D6.5030801@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A recipe for installing CentOS 6.4 on DDF fake RAID members using mdadm
(not dmraid) can now be found on
https://raid.wiki.kernel.org/index.php/DDF_Fake_RAID.

I tested it successfully both on VMs and real hardware, but it needs
more testing.

Feedback and test results are welcome. Please don't use this on
production systems yet.

Regards
Martin
