From: "Grantham, Ewan R." <egrantham@swri.org>
Subject: Looking for some help with device options
Date: Wed, 26 May 2004 06:04:08 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <AF4CBD49C827BA4F9BDD00E297CD804802624917@adsms01.dyn.datasys.swri.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am setting up a test machine for some writing I am doing, and the idea
is to do some RAID things without messing up my main machine and array
:-)

For the test machine I have three external firewire drives. The
"opportunity" here is that two of them are 200 Gigs, and the other one
is 80 Gigs.

My first thought is to break each drive up into multiple 40 Gig
partitions, and then RAID-5 all the partitions. Would I then be N-1
based on partition size (so 440 Gigs) or N-1 based on the largest device
(i.e. 280 Gigs)? Also, would setting up a RAID this way cause lousy
performance and possibly be less stable - or am I worrying too much?

Finally - any other "interesting" ideas for setting up the space? I
thought about mixing RAID types on the drives so that I would have a
RAID-5 of 80 Gig partitions, and then RAID-1 the remaining 120 Gig on
the two 200 Gig drives. But that strikes me as going particularly far
out on the limb.

Thanks for your help,
Ewan

