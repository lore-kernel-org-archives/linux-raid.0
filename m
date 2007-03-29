From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
Date: Thu, 29 Mar 2007 04:11:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
 <17931.23488.160031.119117@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934021AbXC2ILk@vger.kernel.org>
In-Reply-To: <17931.23488.160031.119117@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 29 Mar 2007, Neil Brown wrote:

> On Tuesday March 27, jpiszcz@lucidpixels.com wrote:
>> I ran a check on my SW RAID devices this morning.  However, when I did so,
>> I had a few lftp sessions open pulling files.  After I executed the check,
>> the lftp processes entered 'D' state and I could do 'nothing' in the
>> process until the check finished.  Is this normal?  Should a check block
>> all I/O to the device and put the processes writing to a particular device
>> in 'D' state until it is finished?
>
> No, that shouldn't happen.  The 'check' should notice any other disk
> activity and slow down if anything else is happening on the device.
>
> Did the check run to completion?  And if so, did the 'lftp' start
> working normally again?
Yes it did and the lftp did start working normally again.

>
> Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
> running at?
Around 44MB/s.

I do use the following optimization, perhaps a bad idea if I want other 
processes to 'stay alive'?

echo "Setting minimum resync speed to 200MB/s..."
echo "This improves the resync speed from 2.1MB/s to 44MB/s"
echo 200000 > /sys/block/md0/md/sync_speed_min
echo 200000 > /sys/block/md1/md/sync_speed_min
echo 200000 > /sys/block/md2/md/sync_speed_min
echo 200000 > /sys/block/md3/md/sync_speed_min
echo 200000 > /sys/block/md4/md/sync_speed_min



>
> NeilBrown
>
