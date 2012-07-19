From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Thu, 19 Jul 2012 10:25:25 -0400
Message-ID: <500818D5.4080208@tmr.com>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com> <50071C0A.8080307@tmr.com> <CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com> <20120719091611.22e16100@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120719091611.22e16100@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Alex <mysqlstudent@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Roman Mamedov wrote:
> On Wed, 18 Jul 2012 22:44:06 -0400
> Alex <mysqlstudent@gmail.com> wrote:
>
>> I'm not sure what stats I could provide to troubleshoot this further.
>> At this rate, the 2.7T array will take a full day to resync. Is that
>> to be expected?
> 1) did you try increasing stripe_cache_size?
>
> 2) maybe it's an "Advanced Format" drive, the RAID partition is not properly
> aligned?
>
That's a good argument for not using "whole disk" array members, a partition can 
be started at a good offset and may perform better. As for the speed, since it 
is reconstructing the array data (hope the other drives are okay), every block 
written requires three blocks read and a reconstruct in cpu and memory. You can 
use "blockdev" to increase readahead, and set the devices to use the deadline 
scheduler, that _may_ improve things somewhat, but you have to read three block 
to write one, so it's not going to be fast.

-- 
Bill Davidsen <davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010


