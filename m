From: Raz <raziebe@gmail.com>
Subject: raid0 zones
Date: Thu, 26 Mar 2009 19:17:36 +0200
Message-ID: <5d96567b0903261017u515b8e00qc12368e7f82b73f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil Hello
I sincerely hope you will answer this email.As i understand , raid0
zones are aimed for cases where the disks are not symmetric ( or
partitions ) in their sizes.
But this means imbalanced IO. An inbalanced IO, from my application
perspective is a disaster.
I am wondering whether zone number greater than 1 may be an option in mdadm.
I will most thankful for your opinion on this matter.

PS
I managed to expand raid0 ( very very experimental , and only with zone
nr == 1).
I still have to learn how to write the superblocks though because I
cannot re-assemble the raid, and behave according to md rules.
