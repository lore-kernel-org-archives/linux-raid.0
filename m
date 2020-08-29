Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4502DC433E6
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 03:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 116BA20757
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 03:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=verizon.net header.i=@verizon.net header.b="l+rdxsEU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgH2DIa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 23:08:30 -0400
Received: from sonic313-15.consmr.mail.bf2.yahoo.com ([74.6.133.125]:45176
        "EHLO sonic313-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgH2DI2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 23:08:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verizon.net; s=a2048; t=1598670507; bh=1kY/gash/7dpI5vzoL5ZHW9MN1X+DZFmJCFVX4Lfdx0=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=l+rdxsEUkra1D/royQVRc6AIgkq8U7i0hj+gO9qLN2T/q2+R/3/hIZTncZPrD6Gdc/F80DfnibvouRJH3RbxF8OU+7k+60qM1F+OkkP9+6bC6xBYSYU5QeR3krYtcVj856I7Ut69cD2fBEODNt38ptWNpwt9FEr77Vzp8hjPijcM9z2updbdDEQ5q/LY8+LXqHPY4E/nzA0Xl5La01+iw0LhajnIAs3KCKXdUbb5kWBQF9jt+iplDz2N7QUloiHlAjK4WJkkmLTAP7SEFkf1KK1ItPJHwjtnIG/yG7JoijVMwOVN89dcDM2erkKn3CG7S7hg3XJKyDJ2XDHLyrtSKA==
X-YMail-OSG: tYiOjd4VM1lh0uOc2L1IX3rBNlVZC2pUP8IB3ob99ZPhxepg.h1wfuwPm9Ia9CJ
 GZf1Yd4nWB7OCTFjWgelTnq7S3GU0wDRRpimGTKp5hHuX_7_H_VvI6GZOoELNge40w.0NC8ZwgZ4
 5g7avnI_lj0sZ6V5iZKg0i_rNpc0P5lADcx3HdAEshAovL5NL2LvccQ7ZGkJBPD6UnUbXVuTgGk_
 tmYtjDzt8T5fX4e10lT4r5WKuQh2TGgmb703RV5EJteKNec3wEfJWGQUBu4J.1ZVsdZmQV9UUNHY
 GXkDcHmT6BwgFwtPILz38ScJCCT2H3W0KS02iCPUxB7WRg.YMS.dHOVHQWarPBGxUiVArqBghMix
 G56.AbahTe9QhLfsXhrOdUqjVgYpNT9ih5qGeFBgiRop9jLHOMXeZPj_h1AVNGwvdC1HJI.tU.mT
 OBTlTYlJcr8rlbdH.4m70f5mLfOrsZ8uZj5s7pZiByNiUqrcdwBNP9n7S8iNjEXKuvEXWr.UEnbw
 uxgT_ny_quJ__st5drpSuuJmW5RvFb_Ys14HtPEw5.Vjt_ketMXCSSNxqVCuPNcvnmdP6IEmTOdX
 ZD8sMjzyyy368mI6j.3gJCClbCQHe0H0MzfdHYnUBIp8B2HMkJ8XBQ5gVddKyBjik3yAD8xYtONq
 pbjC2B.2xnEHLoRScgWaVGDKLvJXUmgeAAGXikhdBNe0bAgum4f3M3lvoJ0WM1O4Has8q8tHFXpl
 jXjNJ0.6cX5S0W5JYgIzYqQXmxwbweFZfivR1ysabfTvo9pnyQu1.tKaNJ.cYnOYvzYRQCUgU4aG
 VjzlP41mTwokTect0NtiVWzDzFludcaksAKHGvOPgeIkDBavaa2NyCAt_wQKg16CfpOtemXB5BJt
 IOn26cYxv.DeVPKqQspHoiOEJT1QIK2rjee77gAnHR_x5Ox11A8l.t2S2c1ha8BBLLJgcVz4p47C
 JdoArvwgLitH0dcjKa5r9QmSdlv5R4uxMb7GVJWxh48dfyT1pBO3P.u53_qjC0jkNzAP6nxBGET8
 Ry98GsE25d6xAgDCwHXYZcVMYejd10HLvLvqilzgCT0Ee0iU31vw80h0Pd_pelZNnkR_FaMNsO4_
 WU3Uq0LarHzouSOxV3Wr0lHIZppE8e0Hg_FyING.c21BZD49TguKdQENlfi7OMsww44sx23Q3s5g
 Idz.zyl7TNQdsILP46iYD.pZyXl14LKwpdo_9ednGJm292uMoGkNjMrCrISRLK9Jn.iKhrOCItsc
 mr0ZITZW7VYNsLiDQNwIOq9mfLUxRONQ03tAGhuatl88Uk_npnmMQpeDNTi9_JFbODBaa6e3ZWYO
 5jdBj1upihPq3t7w58PtrQ4lQ28ySEwmhXiKGXMIYxR06p1yDkWuewQ7Kn5UG_k57_I1Jt6IWKYi
 d5iucIU.nztAmzCCdbWLEMVXLOd_sY94BUQDyuJfE54KcABk7K46UthrilgHVvK4smFvE5mkJRQH
 fTYgAfXM.BSXRUK12J4bPmjzWVkTQh5VW307gUiZmQfj9jN1tvXzFaDJZd.cKhxRdIkQdIA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Sat, 29 Aug 2020 03:08:27 +0000
Received: by smtp411.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 6f6db2dc0f143195a64dc0787d8fa9f2;
          Sat, 29 Aug 2020 03:08:23 +0000 (UTC)
Subject: Re: Best way to add caching to a new raid setup.
To:     antlists <antlists@youngman.org.uk>,
        Ram Ramesh <rramesh2400@gmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
 <6872a42c-5c27-e38a-33ab-10ec01723961@youngman.org.uk>
From:   "R. Ramesh" <rramesh@verizon.net>
Message-ID: <d0aeb41b-09d4-b756-05ee-f0b3da486532@verizon.net>
Date:   Fri, 28 Aug 2020 22:08:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6872a42c-5c27-e38a-33ab-10ec01723961@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.16565 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/28/20 5:59 PM, antlists wrote:
> On 28/08/2020 23:40, Ram Ramesh wrote:
>> On 8/28/20 5:12 PM, antlists wrote:
>>> On 28/08/2020 18:25, Ram Ramesh wrote:
>>>> I am mainly looking for IOP improvement as I want to use this RAID 
>>>> in mythtv environment. So multiple threads will be active and I 
>>>> expect cache to help with random access IOPs.
>>>
>>> ???
>>>
>>> Caching will only help in a read-after-write scenario, or a 
>>> read-several-times scenario.
>>>
>>> I'm guessing mythtv means it's a film server? Can ALL your films (or 
>>> at least your favourite "watch again and again" ones) fit in the 
>>> cache? If you watch a lot of films, chances are you'll read it from 
>>> disk (no advantage from the cache), and by the time you watch it 
>>> again it will have been evicted so you'll have to read it again.
>>>
>>> The other time cache may be useful, is if you're recording one thing 
>>> and watching another. That way, the writes can stall in cache as you 
>>> prioritise reading.
>>>
>>> Think about what is actually happening at the i/o level, and will 
>>> cache help?
>>>
>>> Cheers,
>>> Wol
>>
>> Mythtv is a sever client DVR system. I have a client next to each of 
>> my TVs and one backend with large disk (this will have RAID with 
>> cache). At any time many clients will be accessing different programs 
>> and any scheduled recording will also be going on in parallel. So you 
>> will see a lot of seeks, but still all will be based on limited 
>> threads (I only have 3 TVs and may be one other PC acting as a 
>> client) So lots of IOs, mostly sequential, across small number of 
>> threads. I think most cache algorithms should be able to benefit from 
>> random access to blocks in SSD.
>>
>> Do you see any flaws in my argument?
>>
> I don't think you've understood mine. Doesn't matter what the cache 
> algorithm is, the whole point of caching is that - when reading - it 
> is only a benefit if the different threads are reading THE SAME bits 
> of disk. So if your 3 TVs and the PC are accessing different tv 
> programs, caching won't be much use, as all the reads will be cache 
> misses.
>
> As for writing, caching can let you prioritise reading so you don't 
> get stutter while watching. And it'll speed things up if you watch 
> while recording.
>
> But basically, caching will really only benefit you if (a) your cache 
> is large enough to hold all your favourite films so they don't get 
> evicted from cache, or (b) you're in the habit of watching while 
> recording, or (c) two or more tvs are in the habit of watching the 
> same program.
>
> The question is not "how many simultaneous threads do I have?", but 
> "how many of my disk i/os are going to be cache misses?" Your argument 
> actively avoids that question. I suspect the answer is "most of them".
>
> Cheers,
> Wol

I do not know how SSD caching is implemented. I assumed it will be 
somewhat similar to memory cache (L2 vs L3 vs L4 etc). I am hoping that 
with SSD caching, reads/writes to disk will be larger in size and 
sequential within a file (similar to cache line fill in memory cache 
which results in memory bursts that are efficient). I thought that is 
what SSD caching will do to disk reads/writes. I assumed, once reads 
(ahead) and writes (assuming writeback cache) buffers data sufficiently 
in the SSD, all reads/writes will be to SSD with periodic well organized 
large transfers to disk. If I am wrong here then I do not see any point 
in SSD as a cache. My aim is not to optimize by cache hits, but optimize 
by preventing disks from thrashing back and forth seeking after every 
block read. I suppose Linux (memory) buffer cache alleviates some of 
that. I was hoping SSD will provide next level. If not, I am off in my 
understanding of SSD as a disk cache.

Regards
Ramesh

