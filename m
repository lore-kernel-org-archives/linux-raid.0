From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: 3 disk raid-5 without parity
Date: Mon, 14 Jun 2004 21:45:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16589.36817.228645.72611@cse.unsw.edu.au>
References: <20040614111920.GA17785@middle.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jurriaan on Monday June 14
To: Jurriaan <thunder7@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 14, thunder7@xs4all.nl wrote:
> I am trying to convince my boss our new database-server wants raid-0+1,
> not raid-5, and I got an idea while reading endless articles about
> raid-5 being slow when writing and management not listening.

You want numbers, not abstract arguments.

Configure your server with raid5 and do some performance measurements
- preferably with your database suite.
Then reconfigure with raid 0+1 and test again.

Show the numbers to your boss.  You get to choose which numbers to
show :-)

> 
> suppose you make a 3-disc raid-5 without parity:
> 
> data    disc1 disc2 disc3
> A       A     A     B
> B       B     C     C
> 
> How would that perform compared to raid-5 and raid-0+1?

Should be slightly better than raid1 of 2 drives, and slower than raid
0+1 on 4 drives.  How it compares with raid-5 depends largely on load
characteristics.  With only 3 drives, some loads will very often
provide raid5 with both data blocks in a stripe, and so no pre-reading
will be needed.

I hope to release a "raid10" module for 2.6 within a couple of weeks.
raid10 is basically a combination of raid1 and raid0 all in one module
with some interesting geometry possibilities.  This particular
geometry is one of the possibilities.

> 
> There is a problem with extending this: you need groups of 3 disks.
> Then again, compared to raid-0+1 you need fewer disks.

There is no problem extending this. 
With 4 discs it would be
  A A B B
  C C D D
which is a lot like raid0 over raid1
With 5 disks is would be
  A A B B C
  C D D E E
or, if you wanted more redundancy:
  A A A B B
  B C C C D
  D D E E E

The more discs you have, the faster it should be.

> 
> Has this ever been implemented? Even better, benchmarked?

Implemented:  I'm fairly sure it has.  Not in Linux just yet.
Benchmarks: I don't know of any details.

NeilBrown
