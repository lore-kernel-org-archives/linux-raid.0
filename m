From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: large devices (3ware)
Date: Wed, 21 Aug 2002 10:37:40 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0208211035120.1498-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am considering a 3ware 7500-12 (12 channel IDE raid controller) and 12 
120 gig drives in a single large RAID5. Am I correct that Linux (latest 
Redhat 7.3 shipped 2.4.18 kernel) can handle devices up to 2 terabyte and 
that this raid5 (1320 gig) would work as expected as one single file 
system (ext3) ? Anyone actually have something similar up and running and 
can verify that it works?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

