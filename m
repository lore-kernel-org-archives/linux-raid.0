From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: memory leak with linux-3.14.16
Date: Sat, 16 Aug 2014 10:40:54 +0200
Message-ID: <201408160840.s7G8esgf025944@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
References: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear readers,

I am shrinking my raid10-array consiting of 16 2TB disks
to 13 disks right now. Reshaping runs for 2 hours and
I'm constantly obervng /proc/mdstat and /proc/meminfo

SUnreclaim is constantly growing while MemFree and
MemAvailable are decreasing.

Seems like linux 3.14.16 is leaking memory at a rate
of 4GB per 1TB of reshape data.

My machine has 32GB of RAM and if I interpolate the current
memory-values I will run out of mem at 80% of the reshape
operation. This is exactly what happened to me with
linux-3.14.12.

Do I need linux-3.14.17 ??

Kind regards

Peter Koch
