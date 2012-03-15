From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Date: Thu, 15 Mar 2012 10:39:44 +0800
Message-ID: <CANejiEX=-y6Kgtmfg1efqn_Ufdnn=Ls-4Nne3RYAWdt07+4o2A@mail.gmail.com>
References: <20120312030412.375458948@fusionio.com>
	<alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de>
	<4F5EFEB6.4060402@kernel.org>
	<alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de>
	<CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
	<alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de>
	<CANejiEW=a1piMYvSYM5GmtxKsWYpZj+kjnmNsNUDmW9ydDBjBw@mail.gmail.com>
	<alpine.LRH.2.02.1203140839590.28358@diagnostix.dwd.de>
	<CANejiEXP9ORKTfE4O9khaHSp-Y8yOQU1LLUD5Q5pBJOGR+A-aA@mail.gmail.com>
	<alpine.LRH.2.02.1203142101290.6232@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1203142101290.6232@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-raid.ids

2012/3/15 Holger Kiehl <Holger.Kiehl@dwd.de>:
> On Wed, 14 Mar 2012, Shaohua Li wrote:
>
>> Maybe the discard runs slow with small size request in the disk.
>> please drop patch "blk: add plug for blkdev_issue_discard" and try again.
>> Since
>> we can't do merge, the plug just introduces latency.
>>
> Tried again without the patch applied, but there is only a very small
> performance increase (520->600 agains 4000 fps without discard).
>
> The benchmark creates lots of small files (2 KiB) and deletes them again.
>
>
>> if it doesn't help, please capture a blktrace when you do the benchmark
>> and
>> send it to me.
>>
> Ok, I will do this tomorrow. Need some sleep :-)
>
> Thanks for your work on supporting discard in MD!
I tried your benchmark, create 2000k 2k files and delete them and
follows a sync.
the discard runs pretty fast for both raid 0/1. So can't reproduce the
issue. I'm using
a fusionio card though. I'm afraid nothing I can do till get you blktrace.

Thanks,
Shaohua
