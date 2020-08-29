Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCC1C433E6
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 03:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3F1C2078A
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 03:12:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=verizon.net header.i=@verizon.net header.b="WW0yoMRp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgH2DMs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 23:12:48 -0400
Received: from sonic306-3.consmr.mail.bf2.yahoo.com ([74.6.132.42]:34973 "EHLO
        sonic306-3.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgH2DMr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 23:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verizon.net; s=a2048; t=1598670761; bh=ks0wru3C1fKXHSoVH4uzRhsnHhZ3XnrEyCPuRw+5kUw=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=WW0yoMRpy8F2FFQkIqWJwpF2My/a0lJ5xnjy9iNAmp2Bo6wT1oQzyVhkOevSjX04TsSBuuPlnxkYqrLI+K62KkMFSIYGaIlKtoPQLk3fpTFLVTzJ4WvnjKKSO+R3m3nSW2bYEb/1SS0z/UA8GpM7mz7Am31iZG84u7s2z2uG1c6YRMIFhJqInbMqsN4ntklDDAR/V44FcqX5XEA6gNbF4KaouuY3R8J7TB5PQwLqclRwJ8xX/YaEhYc23wHlbTjflF8+EdK+UdgR0znXfrV8XLN6zY4M1fzFSBw+UXkYDBFlSpC33yeNcykg5Bq0W7PQCuRCoX/98jEt53KsRBUecw==
X-YMail-OSG: J3FapCQVM1n7YuRLom1Ont1E29.UApt4HDrFwMxAXLSjbFPx6bF26Jnu89xLefs
 9g4bsVzvfhKE4JHAnxVP0FDqpkoLgzs.2ZBUL27c_ZukpWRF_I4TmifzmJMhnvW8niKPqcg8v75f
 JoF3juFAPBinoV242gsimwB4CNzw3X2AuJhMRU6SZxPdVRRv6dXtouYO1orjcfgQ.Yea4Q95P1mS
 i37uAkqqwSzT83JB3VSIw1vU7M9aWF.6doOKtM3VfL86ChEKns_wKUkuZ7xUZ.pX_YcISAV75Hvd
 7tsUHS7574nIdJbEEAL9CmsqhxTmhQSzvierl.LWffuKzpSYoSt2gpYTGJ6UweY6D6sPqsOXCxnf
 L31pTIhEdUi58ijrhMyQVJgx0ufHgG3BCz0COmPqrNYrVuerPx9QEZ478jHJT5.6hj1stpZ9sN.C
 0qVMKIb2WObxZFrB2A3p1PfjPbCo.KcGHY3a34q4.5SJKVQns64Y_.pnQm_jvd60_LmMdIDoRk8p
 yy.h2oUKJabkViKiEaggzX4UDy4cJA.4HNAM3dAP3C1DEXvhrGdrfmyOqMvVJkZSR7fFkvMsZ30q
 nDxMcZDo5QCNvaOGCMzyUaz_5NtVLhA2XAlZ8XRBMViO3E4aj.c0Z9MVVR3jrWCwjW_1q4Rn3uDm
 WU7hYQ45ZJUlHT9g6zHC7BrMsTX4tZ8nlxP9WsplI2dYLITYqapSYJ9SoQLRXgwuZCHVOzi.7OKz
 u_qNnMtqXy5djcuwBK9X1Uq9OgSwCZT3dYjepIStLH2myJX8j5cUyoh9zhhZi2rxR0CVupLIkrAK
 1.hAiyAh6YN4wtDgFb1Rc9FvOkW5X4ukQ_oUvhE5knKaUByQBiBL9LzR7kXaShr91YXZ7ZlVFSl9
 ZzFSMW6GsSVGgDQKfqdinfk5s5_2tUJCiPp.H6NQQLbwyGlsSb9_dXfAiQQEYBPbG25z40uI3uRo
 wpRTPtmxrvDDepNDkwRhtfqbn36iJspibKnF._RBAl7MYrCcgxnGBiUoipAA7DtklGOQyi7jnia1
 l1JBPV0ErYCQUPmHOaoHvEZ3h914.nakV18rpG.8sYDsjULtJ4ZmesPxdsRMS5ohw7XGuUxEym5u
 .CaXq842_UNxK_RD3H5Qjnro.QmlnZgdTKZIP7K8ih8DdWtLef_QsVsn.FDchx5gWjjXkaS8sAT5
 XqpzOXyzQct35THmGFhYYaGC6DWDXkHyDCw8Kf5k52.1mhN0SMoajw4_MV8oAuUXR3HQdXhcluP9
 vi5U0dVaZ1l3hn.blCgJwML.Huo0GrdX3EGo9b04WUL8m189fLSgqv2iysYszbbxwIbk3Ykm1z32
 2spR3doCkTcJfF8f1fBPeQ8Pw39sD2uOHJXLU7lxdgMUd6Tnqoc62zBkV4WaxFjBQYLAYL.Cpd.R
 5PcV4EwW4_Mgrq3f_u9Ei8PsQ7.xRIkZOQjXqzv6p.wBPT.zxJfJAerNEmSB4aVxI.nEFm4Snf1t
 U9Zvjx7CR6AXeQOvQ7E4dxX75TdYydosOKzdgFWPqJjb2pIUr5G2GIyd4ca8ZlrCzfqMP3vmaxTG
 p56wP
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Sat, 29 Aug 2020 03:12:41 +0000
Received: by smtp409.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 644ca2f2c7ebddf0a35b1e3db2077e7f;
          Sat, 29 Aug 2020 03:12:36 +0000 (UTC)
Subject: Re: Best way to add caching to a new raid setup.
To:     Roger Heflin <rogerheflin@gmail.com>,
        Ram Ramesh <rramesh2400@gmail.com>
Cc:     antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
 <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
From:   "R. Ramesh" <rramesh@verizon.net>
Message-ID: <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net>
Date:   Fri, 28 Aug 2020 22:12:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Mailer: WebService/1.1.16565 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/28/20 7:01 PM, Roger Heflin wrote:
> Something I would suggest, I have found improves my mythtv experience
> is:  Get a big enough SSD to hold 12-18 hours of the recording or
> whatever you do daily, and setup the recordings to go to the SSD.    i
> defined use the disk with the highest percentage free to be used
> first, and since my raid6 is always 90% plus the SSD always gets used.
> Then nightly I move the files from the ssd recordings directory onto
> the raid6 recordings directory.  This also helps when your disks start
> going bad and getting badblocks, the badblocks *WILL* cause mythtv to
> stop recording shows at random because of some prior choices the
> developers made (sync often, and if you get more than a few seconds
> behind stop recording, attempting to save some recordings).
>
> I also put daily security camera data on the ssd and copy it over to
> the raid6 device nightly.
>
> Using the ssd for recording much reduces the load on the slower raid6
> spinning disks.
>
> You would have to have a large number of people watching at the same
> time as the watching is relatively easy load, compared to the writes.
>
> On Fri, Aug 28, 2020 at 5:42 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>> On 8/28/20 5:12 PM, antlists wrote:
>>> On 28/08/2020 18:25, Ram Ramesh wrote:
>>>> I am mainly looking for IOP improvement as I want to use this RAID in
>>>> mythtv environment. So multiple threads will be active and I expect
>>>> cache to help with random access IOPs.
>>> ???
>>>
>>> Caching will only help in a read-after-write scenario, or a
>>> read-several-times scenario.
>>>
>>> I'm guessing mythtv means it's a film server? Can ALL your films (or
>>> at least your favourite "watch again and again" ones) fit in the
>>> cache? If you watch a lot of films, chances are you'll read it from
>>> disk (no advantage from the cache), and by the time you watch it again
>>> it will have been evicted so you'll have to read it again.
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
>> Mythtv is a sever client DVR system. I have a client next to each of my
>> TVs and one backend with large disk (this will have RAID with cache). At
>> any time many clients will be accessing different programs and any
>> scheduled recording will also be going on in parallel. So you will see a
>> lot of seeks, but still all will be based on limited threads (I only
>> have 3 TVs and may be one other PC acting as a client) So lots of IOs,
>> mostly sequential, across small number of threads. I think most cache
>> algorithms should be able to benefit from random access to blocks in SSD.
>>
>> Do you see any flaws in my argument?
>>
>> Regards
>> Ramesh
>>
I was hoping SSD caching would do what you are suggesting without daily 
copying. Based on Wol's comments, it does not. May be I misunderstood 
how SSD caching works.  I will try it any way and see what happens. If 
it does not do what I want, I will remove caching and go straight to disks.

Ramesh
