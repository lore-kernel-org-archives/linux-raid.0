From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: md faster than h/w?
Date: Mon, 16 Jan 2006 12:37:40 +0800
Message-ID: <43CB2314.5000203@fastmail.co.uk>
References: <dq7jii$n1c$1@sea.gmane.org> <Pine.LNX.4.44.0601131720090.24299-100000@coffee.psychology.mcmaster.ca> <20060114212341.GB20464@lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060114212341.GB20464@lug.udel.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@lug.udel.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ross Vandegrift wrote:
> On Sat, Jan 14, 2006 at 01:40:53AM -0500, Mark Hahn wrote:
>>> Initially, we were getting 'hdparm -t' numbers around 80MB/s, but this 
>>> was when we were testing /dev/sdb1 - the (only) partition on the device. 
>>> When we started testing /dev/sdb, it increased significantly to around 
>>> 180MB/s. I'm not sure what to conclude from this.
>> there are some funny interactions between partitions, filesystems 
>> and low-level parameters like readahead.
> 
> Hmmm, I'm not convinced, though it could be that the disks in my
> workstation are not fast enough.
> 
> I used hdparm and your iorate program to compare the performance on my
> fastest disk (7200rpm, ATA100).  The difference between partition vs.
> disk is definitely within the margin of error: 2-3MB/sec when I'm
> averaging around 50MB/sec.
> 
> I'd be suspicious of much more difference between the two...

In which case, I'm suspicious - using 'hdparm -t' on h/w RAID0 (4 disks) :

/dev/sdb:
  Timing buffered disk reads:  536 MB in  3.00 seconds = 178.57 MB/sec
/dev/sdb1:
  Timing buffered disk reads:  100 MB in  3.01 seconds =  33.19 MB/sec

That's a big difference in my book.

However, with bonnie++, using filesystems created on the above devices,
I get similar numbers :

/dev/sdb:

--Sequential Input--
-Per Chr- --Block--
K/sec %CP K/sec %CP
38586  76 126818  15

/dev/sdb1:

--Sequential Input-
-Per Chr- --Block--
K/sec %CP K/sec %CP
38185  76 127569  15

After running that, I reran hdparm, and it reported ~40MB for *both*
/dev/sdb and /dev/sdb1.
Then I unmount /dev/sdb and it's back up to 155MB/s !?!?!

It's not making any sense to me :(

Strange. I guess I should just ignore 'hdparm -t'?

Max.
