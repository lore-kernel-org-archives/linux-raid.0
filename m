Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E4DC433E6
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 22:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E60207DA
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 22:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgH1W7k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 18:59:40 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:54468 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgH1W7j (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 18:59:39 -0400
Received: from host86-157-102-164.range86-157.btcentralplus.com ([86.157.102.164] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kBnLL-000B5w-5b; Fri, 28 Aug 2020 23:59:36 +0100
Subject: Re: Best way to add caching to a new raid setup.
To:     Ram Ramesh <rramesh2400@gmail.com>,
        antlists <antlists@youngman.org.uk>,
        "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <6872a42c-5c27-e38a-33ab-10ec01723961@youngman.org.uk>
Date:   Fri, 28 Aug 2020 23:59:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/08/2020 23:40, Ram Ramesh wrote:
> On 8/28/20 5:12 PM, antlists wrote:
>> On 28/08/2020 18:25, Ram Ramesh wrote:
>>> I am mainly looking for IOP improvement as I want to use this RAID in 
>>> mythtv environment. So multiple threads will be active and I expect 
>>> cache to help with random access IOPs.
>>
>> ???
>>
>> Caching will only help in a read-after-write scenario, or a 
>> read-several-times scenario.
>>
>> I'm guessing mythtv means it's a film server? Can ALL your films (or 
>> at least your favourite "watch again and again" ones) fit in the 
>> cache? If you watch a lot of films, chances are you'll read it from 
>> disk (no advantage from the cache), and by the time you watch it again 
>> it will have been evicted so you'll have to read it again.
>>
>> The other time cache may be useful, is if you're recording one thing 
>> and watching another. That way, the writes can stall in cache as you 
>> prioritise reading.
>>
>> Think about what is actually happening at the i/o level, and will 
>> cache help?
>>
>> Cheers,
>> Wol
> 
> Mythtv is a sever client DVR system. I have a client next to each of my 
> TVs and one backend with large disk (this will have RAID with cache). At 
> any time many clients will be accessing different programs and any 
> scheduled recording will also be going on in parallel. So you will see a 
> lot of seeks, but still all will be based on limited threads (I only 
> have 3 TVs and may be one other PC acting as a client) So lots of IOs, 
> mostly sequential, across small number of threads. I think most cache 
> algorithms should be able to benefit from random access to blocks in SSD.
> 
> Do you see any flaws in my argument?
> 
I don't think you've understood mine. Doesn't matter what the cache 
algorithm is, the whole point of caching is that - when reading - it is 
only a benefit if the different threads are reading THE SAME bits of 
disk. So if your 3 TVs and the PC are accessing different tv programs, 
caching won't be much use, as all the reads will be cache misses.

As for writing, caching can let you prioritise reading so you don't get 
stutter while watching. And it'll speed things up if you watch while 
recording.

But basically, caching will really only benefit you if (a) your cache is 
large enough to hold all your favourite films so they don't get evicted 
from cache, or (b) you're in the habit of watching while recording, or 
(c) two or more tvs are in the habit of watching the same program.

The question is not "how many simultaneous threads do I have?", but "how 
many of my disk i/os are going to be cache misses?" Your argument 
actively avoids that question. I suspect the answer is "most of them".

Cheers,
Wol
