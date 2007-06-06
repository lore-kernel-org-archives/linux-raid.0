From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: RE:   RAID 6 grow problem
Date: Wed, 6 Jun 2007 10:38:49 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0706061021530.5806@gheavc.wnzcbav.cig>
References: <1501701006.1181142416422.JavaMail.root@gateway.korstad.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1501701006.1181142416422.JavaMail.root@gateway.korstad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Korstad <dan@korstad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 6 Jun 2007, Daniel Korstad wrote:

>  You say you have a RAID with three drive (I assume RAID5) with a read 
> performance of 133MB/s.  There are lots of variables, file system 
> type, cache tuning, but that sounds very reasonable to me.

I just did the math quickly - assuming each drive can sustain (give or 
take) 70MB/s, and I'm using a 3-drive raid5, then (block device) reads 
will only use 2 of those 3 drives resulting in a maximum of 140MB/s. 
I've measured (consistently) 133MB/s using dd (again, with iflag=direct) 
and a blocksize of 768K, so I'm OK with that.

A question posed by a friend is this: assuming 64K blocks, if I read a 
single stripe from a raid (128K, right?) then two drives will be used 
(say, drive A and drive B). If I want the "next" 128K then which drives 
are most likely to be used? Drive A will now have the parity block in 
it's "next" block for head position, but drive B has the next data 
block. Nobody knows where drive C is. Does raid5 use an algorithm 
similar to raid1 in that it chooses the 2 drives whose heads are closest 
or does it utilize some other algorithm? 

> Here is a site with some test for RAID5 and 8 drives in the set using 
> high end hardware raid.

> http://www.rhic.bnl.gov/hepix/talks/041019pm/schoen.pdf
> 8 drives RAID 5 7200 rpm SATA drives = ~180MB/s

I would have expected a peak transfer rate (sustained, block, linear 
access) of MAX(8*70,533) which is 533MB/s, assuming 64bit, 66MHz bus and 
70MB/s drives.

I recently completed a series of some 800+ tests on a 4 disk raid5 
varying the I/O scheduler, readahead of the components, readahead of the 
raid, bitmap present or not, and filesystem and arrived at some fairly 
interesting results. I hope to throw them together in a more usable form 
in the near future.

--
Jon Nelson <jnelson-linux-raid@jamponi.net>
