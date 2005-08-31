From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Where is the performance bottleneck?
Date: Thu, 01 Sep 2005 03:25:36 +1000
Message-ID: <4315E810.4030305@yahoo.com.au>
References: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de> <20050829202529.GA32214@midnight.suse.cz> <Pine.LNX.4.61.0508301919250.25574@diagnostix.dwd.de> <20050831071126.GA7502@midnight.ucw.cz> <20050831072644.GF4018@suse.de> <Pine.LNX.4.61.0508311029170.16574@diagnostix.dwd.de> <4315A179.8070102@yahoo.com.au> <Pine.LNX.4.61.0508311524190.16574@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964892AbVHaRZR@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0508311524190.16574@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Jens Axboe <axboe@suse.de>, Vojtech Pavlik <vojtech@suse.cz>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Holger Kiehl wrote:

> meminfo.dump:
> 
>    MemTotal:      8124172 kB
>    MemFree:         23564 kB
>    Buffers:       7825944 kB
>    Cached:          19216 kB
>    SwapCached:          0 kB
>    Active:          25708 kB
>    Inactive:      7835548 kB
>    HighTotal:           0 kB
>    HighFree:            0 kB
>    LowTotal:      8124172 kB
>    LowFree:         23564 kB
>    SwapTotal:    15631160 kB
>    SwapFree:     15631160 kB
>    Dirty:         3145604 kB

Hmm OK, dirty memory is pinned pretty much exactly on dirty_ratio
so maybe I've just led you on a goose chase.

You could
     echo 5 > /proc/sys/vm/dirty_background_ratio
     echo 10 > /proc/sys/vm/dirty_ratio

To further reduce dirty memory in the system, however this is
a long shot, so please continue your interaction with the
other people in the thread first.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.

Send instant messages to your online friends http://au.messenger.yahoo.com 
