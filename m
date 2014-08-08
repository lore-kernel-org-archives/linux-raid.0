From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: parallel access to RAID10-array
Date: Fri, 8 Aug 2014 19:27:21 +0200
Message-ID: <201408081727.s78HRLJh018160@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
References: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear readers,

I read somewhere that linux raid1-mirroring will not improve
the read performance of a single process but it will allow two
separate processes to access the data at the same time.

So when I access a 2-disk raid1-mirror with a single dd-process
one drive will show disc-activity only. And if I kill the dd and
restart it again, then the other disk will show activity.

This lead me to the conclusion that a linux raid10-array with
near-2 layout and an even number of drives will show the same
behaviour. One single process will use one half of the drives.
And a second process might use the other half in parallel.

This seems to be wrong. A single dd on my 16-drive raid10-array 
will use all 16 drives and reads 704 MB/s.

So here's my question: Does it make sense to create a raid10-array
with near-2 layout and 2 drives only? Will such an array have
twice the read-performance of a 2-drive raid1 mirror?

Will a raid10-array with near-3 layout have 3 times the read
performance of a single drive?

Is there a way to create a raid10-array such that it will NOT
use all drives but one half only?

What about write-mostly for raid10-arrays?

Kind regards

Peter Koch
