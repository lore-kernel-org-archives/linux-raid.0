From: rrk <rrk@prairie.lakes.com>
Subject: raid1 creation problems
Date: Fri, 11 Jun 2004 07:50:44 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C9AAA4.4020603@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

why would mdadm be creating a md device (raid1) that was larger than the 
partition table?
these are two identical seagate 120's --debian 2.4.26 with raid compiled in.
i have built the partition tables with fdisk cfdisk and parted same 
problem everytime . everything is fine
up until i boot at which time it say's the superblock is larger than the 
partition by about 20 or 30 blocks
I have built several other raid1 system's  over the last year and have 
not seen this problem before.
to add the drives to the array i boot under a recuse disk and sync under 
the rescue disk. same mdadm
version as they were built with. The partition tables match in all cases 
-- with fdisk i kept everything on cyl
boundaries.

where and how does mdadm check partition size?
thanks
rob 

