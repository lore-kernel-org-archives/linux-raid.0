From: Michael Guntsche <mike@it-loops.com>
Subject: RAID5 Disk access question
Date: Thu, 26 Nov 2009 15:29:19 +0100
Message-ID: <20091126142919.GA25044@gibson.comsick.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

I am running a RAID5 setup here for 3 years now. Reading the mail "Raid10 disc-activity every five seconds" in the ML archives made me curious what my system was doing since I already noticed that it was accessing the disks quite often.
Running lm-profiler I saw that md1_raid5 was continuously accessing
(every second) my disks even when the system was idle. 
Furthermore it showed that it was always accessing the same block on all devices at the same time. 
It turned out that this is the RAID superblock. Now my question. 
Is this normal behaviour even if NO writes are taking place on
the Raid itself?

Please CC me on replies since I am not subscribed to the list.

Kind regards,
Michael

