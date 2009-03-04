From: Dylan Distasio <interzone@gmail.com>
Subject: Question on Raid 5 array initial creation times
Date: Tue, 3 Mar 2009 23:58:51 -0500
Message-ID: <3513de790903032058o231d9083n20092b78ed241d3b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I wanted to check to see if anyone could provide a rough estimate of
how long a RAID 5 initial build should take under mdadm.

I am creating a RAID 5 array with 5x1TB Western Digital Black 7200RPM
SATA drives on the following system:

Ubuntu 8.10 / ext3 filesystem on array and OS drive
1 gig of PC3200 RAM
AMD Athlon 64 3200+
Nforce4 motherboard

I am getting a minimum speed of approximately 14000K/sec with an
estimated finish time of roughly 19 hrs from now.

Is this a reasonable speed for creating a RAID 5 array with mdadm?

Thanks.
