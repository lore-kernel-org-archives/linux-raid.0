From: Eric Drew Hollins <gte275e@mail.gatech.edu>
Subject: RE: RAID1 (drive isn't detecting on boot)
Date: Thu, 30 Jan 2003 13:26:45 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.SOL.4.33.0301301326010.12729-100000@acmey.gatech.edu>
References: <A5974D8E5F98D511BB910002A50A66470580D5B7@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A5974D8E5F98D511BB910002A50A66470580D5B7@hdsmsx103.hd.intel.com>
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 30 Jan 2003, Cress, Andrew R wrote:

> You need to include your kernel version.

Sorry.  Kernel 2.4.20.

> Apparently you are running ok on hdg1 in degraded mode, but hde1 has an
> invalid superblock magic.
> You should be able to reconstruct the superblock on hde1 by using mdadm,
> then resync.

Ok, I will try that after I go and fail my Spanish test.  Thanks.



**** Eric Drew Hollins ****
**** Georgia Institute of Technology ****
**** 336198 GT Station, Atlanta, GA  30332 ****
**** W: http://jastermereel.org ****
**** C: 404.312.0685 ****


