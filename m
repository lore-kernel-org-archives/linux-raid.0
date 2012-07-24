From: Alex <mysqlstudent@gmail.com>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Tue, 24 Jul 2012 10:02:50 -0400
Message-ID: <CAB1R3siQ6iVVNuQKkfCh4F5MFOS6qn61iaOhkcyytaO8optynA@mail.gmail.com>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com>
	<50071C0A.8080307@tmr.com>
	<CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com>
	<20120719091611.22e16100@natsu>
	<500818D5.4080208@tmr.com>
	<20120720070801.498902ba@notabene.brown>
	<CAB1R3sgV9e9Ngvh+H6VtDB=mSfvPC8S3hafOncasz+EmTWRA-A@mail.gmail.com>
	<500CCF90.5030002@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <500CCF90.5030002@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

>>>> That's a good argument for not using "whole disk" array members, a
>>>> partition can
>>>> be started at a good offset and may perform better. As for the speed,
>>>> since it
>>>> is reconstructing the array data (hope the other drives are okay), every
>>>> block
>>>> written requires three blocks read and a reconstruct in cpu and memory.
>>>> You can
>>>> use "blockdev" to increase readahead, and set the devices to use the
>>>> deadline
>>>> scheduler, that _may_ improve things somewhat, but you have to read
>>>> three block
>>>> to write one, so it's not going to be fast.
>>>>
>>>
>>> Read-ahead has absolutely no effect in this context.
>>>
>>> Read-ahead is a function of the page cache.  When filling the page cache,
>>> read-ahead suggests how much more to be read than has been asked for.
>>>
>>> resync/recovery does not use the page cache, consequently the readahead
>>> setting is irrelevant.
>>>
>>> IO scheduler choice may make a difference.
>>
>>
>> It's already set for cfq. I assume that would be the preferred over
>> deadline?
>>
>> I set it on the actual disk devices. Should I also set it on md0/1
>> devices as well? It is currently 'none'.
>>
>> /sys/devices/virtual/block/md0/queue/scheduler
>
> For what it's worth, my experience has beem that deadline works better for
> writes to arrays. In arrays with only a few drives, sometimes markedly
> better.

Guys, it thought it would be worth it to follow up and let you know
that the array eventually did rebuild successfully, and is now fully
functional. It took about 4 full days to rebuild the 3.0T 4-disk RAID5
at about 4M/sec, sometimes much slower.

Thanks again,
Alex
