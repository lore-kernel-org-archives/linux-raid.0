From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How to force raid to stop, cleanly? More info
Date: Thu, 10 Apr 2003 09:12:01 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16020.43201.103642.149492@notabene.cse.unsw.edu.au>
References: <16019.29496.215437.669497@notabene.cse.unsw.edu.au>
	<200304091822.LAA16207@washington.seas.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephen C Woods on Wednesday April 9
To: Stephen C Woods <scw@seas.ucla.edu>
Cc: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday April 9, scw@seas.ucla.edu wrote:
> Neil,
>    Thanks a lot, it raid did shutdown cleanly and restarted just fine,
> looks like JFS isn't quite mature enough yet.
> 
>    With that in mind fiddling with fdisk implies that one can
> subpartition a raid device, the FAQ doesn't seem to have any info, so
> before we go and tear down what we already have.
> 
>    Does the md driver support partitions in a meaningful/useful way?

Not without patches.

If you look around
   http://www.cse.unsw.edu.au/~neilb/patches/linux-stable/
you should find a collection of patches.

You particularly need MdPart and MdpMajor but they probably depend on
most of the other Md or Raid patches in the set.
With this, the first 16 md devices can each be partitioned into upto
15 partitions.
You use major device '60' and minor devices:
  0-15 for md0
  15-31 for md1
etc.

  60,0 is much the same as 9,0
  60,1 is the first partition
  etc.

There are no matching patches for 2.5 yet.  I'm waiting to see what
happens when the 32-bit device number stuff settles down.

NeilBrown
