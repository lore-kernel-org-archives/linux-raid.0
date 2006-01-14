From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: md faster than h/w?
Date: Sat, 14 Jan 2006 16:26:13 +0800
Message-ID: <43C8B5A5.5010500@fastmail.co.uk>
References: <dq7jii$n1c$1@sea.gmane.org> <20060113144640.GA10566@lug.udel.edu> <43C851AD.80006@fastmail.co.uk> <20060114020523.GB24976@lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060114020523.GB24976@lug.udel.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@lug.udel.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ross Vandegrift wrote:
> On Sat, Jan 14, 2006 at 09:19:41AM +0800, Max Waterman wrote:
>> I still wonder where all the theoretical numbers went though.
>>
>> The scsi channel should be able to handle 320MB/s, and we should have 
>> enough disks to push that (each disk is 147-320MB/s and we have 4 of 
>> them) - theoretically.
> 
> LOL, they went where all theoretical performance numbers go.
> Whereever that is, and, lemme tell you it's not anywhere near me ::-).

:D Good to know, at least :)

> 
> While your disks claim 147-320MB/sec I'd bet a whole lot they aren't
> breaking 100MB/sec.  I don't think I've ever seen a single disk
> beat 80-90MB/sec of raw throughput.

That's about what I'm getting for a single disk.

> The maximum read throughput
> listed on storagereview.com is 97.4MB/sec:
> http://www.storagereview.com/php/benchmark/bench_sort.php

Ah, a good resource, thanks :)

> On top of that, disk seeks are going to make that go way down.
> 80MB/sec was on an extended read.  Seeking around costs time, which
> affects your throughput.

Indeed. Looking primarily at the 'Sequential Input/Block', this is the best output I've had from bonnie++ :

+------------------------------------------------------------------------+
|          |Sequential Output             |Sequential Input    |         |
|----------+------------------------------+--------------------|Random   |
|Size:Chunk|Per Char |Block     |Rewrite  |Per Char |Block     |Seeks    |
|Size      |         |          |         |         |          |         |
|----------+---------+----------+---------+---------+----------+---------|
|          |K/sec|%  |K/sec |%  |K/sec|%  |K/sec|%  |K/sec |%  |/ sec|%  |
|          |     |CPU|      |CPU|     |CPU|     |CPU|      |CPU|     |CPU|
|----------+-----+---+------+---+-----+---+-----+---+------+---+-----+---|
|2G        |48024|96 |121412|13 |59714|10 |47844|95 |200264|21 |942.8|1  |
+------------------------------------------------------------------------+

Anything interesting in those numbers?

> 
>> Why does the bandwidth seem to plateau with two disks - adding more into 
>> the raid0 doesn't seem to improve performance at all?
> 
> Lets say you read an 8MB file off a disk that runs at 40MB/sec.  That
> means it takes 0.2 seconds to stream that data.  If you stripe that
> disk, and in theory double read performance, you'll complete in 0.1
> seconds instead.
> 
> But if you read 8GB, that'll take you about 200 seconds.  Stripe it,
> and in theory you're down to 100 seconds.  Throw a third disk, you've
> dropped it to 66 seconds - a smaller payoff than the first disk.  If
> you add a fourth, you can in theory read it in 50 seconds.
> 
> So the second disk you added cut 100 seconds off the read time, but
> the fourth only cut off 16.  If we go back to back to the 8MB case,
> your second disk saved 0.1 seconds.  If you added a third, it saved
> 0.04 seconds.

OK. All makes sense. However, the 'hdparm -t' numbers (didn't try bonnie++)
did seem to actually go down (slightly - eg 170MB/s to 160MB/s) when I added
the 3rd disk.

> 
> This is probably what you're seeing.  And I'll bet you're close to the
> 8MB end of the scale than the 8GB end.

Well, with bonnie++, it said it was using a 'size' of either 2G (2.6.8) or
7G (2.6.15-smp). I'm not sure why it picked a different size...

>> Why do I get better numbers using the file for the while device (is 
>> there a better name for it), rather than for a partition (ie /dev/sdb is 
>> faster than /dev/sdb1 - by a lot)?
> 
> That's a bit weird and I don't have a good explanation.  I'd go to
> linux-kernel@vger.kernel.org with that information, some test cases,
> and I'll bet it's a bug.

OK, I'll take the referral for that, thanks :D

> 
> Was this true across kernel versions?
> 
>> Can you explain why raid1 would be faster than raid0? I don't see why 
>> that would be...
> 
> Though reading is the same in theory, I like RAID1 better ::-).  If I
> were you, I'd test all applicable configurations.  But of course we
> haven't even gotten into write speed...

My preference will probably be raid10 - ie raid0 2 drives, raid0
another 2 drives, and then raid1 both raid0s. My 5th disk can be a hot
spare. Round reasonable?

Alternatively, we could probably get a 6th disk and do raid1 on
disk #5 & #6 and install the OS on that - keeping the application
data separate. This would be ideal, I think. For some reason, I like
to keep os separate from application data.

Max.
