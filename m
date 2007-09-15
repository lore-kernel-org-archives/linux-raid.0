From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: MD RAID1 performance very different from non-RAID partition
Date: Sat, 15 Sep 2007 14:18:19 +0200
Message-ID: <87ejh03ywk.fsf@informatik.uni-tuebingen.de>
References: <46EB6D67.1000802@quo.to>
	<20070915070914.GA21515@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070915070914.GA21515@teal.hq.k1024.org> (Iustin Pop's message
	of "Sat, 15 Sep 2007 09:09:14 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Jordan Russell <jr-list-2007@quo.to>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Iustin Pop <iusty@k1024.org> writes:

> On Sat, Sep 15, 2007 at 12:28:07AM -0500, Jordan Russell wrote:
>> (Kernel: 2.6.18, x86_64)
>> 
>> Is it normal for an MD RAID1 partition with 1 active disk to perform
>> differently from a non-RAID partition?
>> 
>> md0 : active raid1 sda2[0]
>>       8193024 blocks [2/1] [U_]
>> 
>> I'm building a search engine database onto this partition. All of the
>> source data is cached into memory already (i.e., only writes should be
>> hitting the disk).
>> If I mount the partition as /dev/md0, building the database consistently
>> takes 18 minutes.
>> If I stop /dev/md0 and mount the partition as /dev/sda2, building the
>> database consistently takes 31 minutes.
>> 
>> Why the difference?
>
> Maybe it's because md doesn't support barriers whereas the disks
> supports them? In this case some filesystems, for example XFS, will work
> faster on raid1 because they can't force the flush to disk using
> barriers.
>
> Just a guess...
>
> regards,
> iustin

Shouldn't it be the other way around? With a barrier the filesystem
can enforce an order on the data written and can then continue writing
data to the cache. More data is queued up for write. Without barriers
the filesystem should do a sync at that point and have to wait for the
write to fully finish. So less is put into cache.

Or not?

MfG
        Goswin
