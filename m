From: Bernd Fischer <bernd@begu.net>
Subject: Re: Looking for some help with device options
Date: Wed, 26 May 2004 18:31:29 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40B4C661.2000904@begu.net>
References: <AF4CBD49C827BA4F9BDD00E297CD804802624917@adsms01.dyn.datasys.swri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AF4CBD49C827BA4F9BDD00E297CD804802624917@adsms01.dyn.datasys.swri.edu>
To: "Grantham, Ewan R." <egrantham@swri.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Grantham, Ewan R. wrote:

> My first thought is to break each drive up into multiple 40 Gig
> partitions, and then RAID-5 all the partitions. Would I then be N-1
> based on partition size (so 440 Gigs) or N-1 based on the largest device
> (i.e. 280 Gigs)? Also, would setting up a RAID this way cause lousy
> performance and possibly be less stable - or am I worrying too much?

You would get 440 G, but at at price. Having more than one part of a 
RAID5 set on the same drive means that if that drive fails, the whole 
array does. Having more than one part of the array on every drive in 
effect triples the danger of data loss.


> Finally - any other "interesting" ideas for setting up the space? I
> thought about mixing RAID types on the drives so that I would have a
> RAID-5 of 80 Gig partitions, and then RAID-1 the remaining 120 Gig on
> the two 200 Gig drives. But that strikes me as going particularly far
> out on the limb.

Again, insufficient redundancy on the RAID-5. If you don't care about 
that, just use linear RAID or LVM to join partitions of arbitrary sizes. 
  Otherwise, you lose diskspace and cpu time for no benefit at all.

My setup would be a couple of RAID-1 or 5 devices across all three disks 
for the system and vital data, all the leftover bits joined up in a 
linear RAID for the not-so-vital stuff. It all depends on what the 
machine is suposed to do, though.


Bernd Fischer

