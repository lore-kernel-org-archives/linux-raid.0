From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Where is the performance bottleneck?
Date: Wed, 31 Aug 2005 22:24:25 +1000
Message-ID: <4315A179.8070102@yahoo.com.au>
References: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de> <20050829202529.GA32214@midnight.suse.cz> <Pine.LNX.4.61.0508301919250.25574@diagnostix.dwd.de> <20050831071126.GA7502@midnight.ucw.cz> <20050831072644.GF4018@suse.de> <Pine.LNX.4.61.0508311029170.16574@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932511AbVHaMYK@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0508311029170.16574@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Jens Axboe <axboe@suse.de>, Vojtech Pavlik <vojtech@suse.cz>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Holger Kiehl wrote:

> 3236497 total                                      1.4547
> 2507913 default_idle                             52248.1875
> 158752 shrink_zone                               43.3275
> 121584 copy_user_generic_c                      3199.5789
>  34271 __wake_up_bit                            713.9792
>  31131 __make_request                            23.1629
>  22096 scsi_request_fn                           18.4133
>  21915 rotate_reclaimable_page                   80.5699
            ^^^^^^^^^

I don't think this function should be here. This indicates that
lots of writeout is happening due to pages falling off the end
of the LRU.

There was a bug recently causing memory estimates to be wrong
on Opterons that could cause this I think.

Can you send in 2 dumps of /proc/vmstat taken 10 seconds apart
while you're writing at full speed (with 2.6.13 or the latest
-git tree).

A dump of /proc/zoneinfo and /proc/meminfo while the write is
going on would be helpful too.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.

Send instant messages to your online friends http://au.messenger.yahoo.com 
