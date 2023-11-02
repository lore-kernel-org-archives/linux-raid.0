Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB78C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  2 Nov 2023 13:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345965AbjKBNGH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Nov 2023 09:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjKBNGF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Nov 2023 09:06:05 -0400
X-Greylist: delayed 5908 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Nov 2023 06:06:01 PDT
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEB3BD
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 06:06:01 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SLkdg14Qqz9R1X
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 00:05:59 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SLkdf3yHgz9QtK
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 00:05:58 +1100 (AEDT)
Message-ID: <1b453db1-b260-4e0b-978e-f15928d10151@eyal.emu.id.au>
Date:   Fri, 3 Nov 2023 00:05:56 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: problem with recovered array
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
 <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au>
 <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
 <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au>
 <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
 <ZUNfK1jqBNsm97Q-@vault.lan>
 <22339749-c498-459e-9dbe-c12859be0580@eyal.emu.id.au>
 <CAAMCDecMvSN9KnNhu3QyRQah016uJhg_vXtjO90WECBCMr8W9w@mail.gmail.com>
From:   eyal@eyal.emu.id.au
In-Reply-To: <CAAMCDecMvSN9KnNhu3QyRQah016uJhg_vXtjO90WECBCMr8W9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02/11/2023 22.57, Roger Heflin wrote:
> you need the iostat  data from the disks under md127 to see what
> mdraid is having to do to internally.   Get the list of sd devices and
> do iostat -x  | grep -E 'Device|sdX|sxy|sdz'    (putting into the list
> the whole non-partitioned sd devices in your array)

I do have iostat running on the components too, and the writing mostly reflects what md127 sees.
However, while there are no reads on md127, there is often some on the components,
very visible in the last two iostat minutes. Is there some RUW going, on the components?

Here is a snippet, when things were slow:

## meminfo data:
2023-11-02 23:05:07 Dirty:           1037680 kB
2023-11-02 23:05:17 Dirty:           1037288 kB
2023-11-02 23:05:27 Dirty:           1036560 kB
2023-11-02 23:05:37 Dirty:           1036064 kB
2023-11-02 23:05:47 Dirty:           1035720 kB
2023-11-02 23:05:57 Dirty:           1035732 kB
2023-11-02 23:06:07 Dirty:           1035860 kB
2023-11-02 23:06:17 Dirty:           1035708 kB
2023-11-02 23:06:27 Dirty:           1035648 kB
2023-11-02 23:06:37 Dirty:           1035388 kB
2023-11-02 23:06:47 Dirty:           1035336 kB
2023-11-02 23:06:57 Dirty:           1035248 kB
2023-11-02 23:07:07 Dirty:           1037312 kB
2023-11-02 23:07:17 Dirty:           1037172 kB
2023-11-02 23:07:27 Dirty:           1035224 kB
2023-11-02 23:07:37 Dirty:           1035152 kB
2023-11-02 23:07:47 Dirty:           1035064 kB
2023-11-02 23:07:57 Dirty:           1025316 kB
2023-11-02 23:08:07 Dirty:           1020000 kB
2023-11-02 23:08:17 Dirty:           1019628 kB
2023-11-02 23:08:27 Dirty:           1019784 kB
2023-11-02 23:08:37 Dirty:           1019284 kB
2023-11-02 23:08:47 Dirty:           1018908 kB
2023-11-02 23:08:57 Dirty:           1018700 kB

## iostat
23:05:08 Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
23:05:08 md127             2.22         0.00        14.73         0.00          0        884          0
23:05:08 sdb               1.13         1.93        12.10         0.00        116        726          0
23:05:08 sdc               1.32         0.00        16.17         0.00          0        970          0
23:05:08 sdd               1.18         0.00         5.57         0.00          0        334          0
23:05:08 sde               0.83         0.00         1.50         0.00          0         90          0
23:05:08 sdf               0.83         0.00         1.50         0.00          0         90          0
23:05:08 sdg               1.27         4.47         5.97         0.00        268        358          0

23:06:08 Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
23:06:08 md127             2.75         0.00        36.20         0.00          0       2172          0
23:06:08 sdb               1.30         4.47        22.40         0.00        268       1344          0
23:06:08 sdc               1.13         0.00        14.40         0.00          0        864          0
23:06:08 sdd               1.13         0.80        14.20         0.00         48        852          0
23:06:08 sde               0.82         8.53         9.73         0.00        512        584          0
23:06:08 sdf               0.87         8.53         7.13         0.00        512        428          0
23:06:08 sdg               0.75         8.53         1.20         0.00        512         72          0

23:07:08 Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
23:07:08 md127             2.30         0.00        10.93         0.00          0        656          0
23:07:08 sdb               1.17         2.13         5.82         0.00        128        349          0
23:07:08 sdc               1.12         0.00         5.35         0.00          0        321          0
23:07:08 sdd               1.35         4.33         9.68         0.00        260        581          0
23:07:08 sde               1.00         4.33         5.68         0.00        260        341          0
23:07:08 sdf               0.82         0.00         3.95         0.00          0        237          0
23:07:08 sdg               1.00         4.33         5.68         0.00        260        341          0

23:08:08 Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
23:08:08 md127            13.55         0.13       238.73         0.00          8      14324          0
23:08:08 sdb               1.92        36.47        72.25         0.00       2188       4335          0
23:08:08 sdc               1.78        27.67        66.38         0.00       1660       3983          0
23:08:08 sdd               2.25        47.67        95.52         0.00       2860       5731          0
23:08:08 sde               2.03        43.87        77.72         0.00       2632       4663          0
23:08:08 sdf               1.73        49.20        59.65         0.00       2952       3579          0
23:08:08 sdg               1.72        29.80        56.45         0.00       1788       3387          0

23:09:08 Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
23:09:08 md127             3.22         0.00        59.47         0.00          0       3568          0
23:09:08 sdb               1.88        26.60        36.00         0.00       1596       2160          0
23:09:08 sdc               1.82        32.53        13.60         0.00       1952        816          0
23:09:08 sdd               1.83        17.07        41.80         0.00       1024       2508          0
23:09:08 sde               1.10         9.07        33.40         0.00        544       2004          0
23:09:08 sdf               0.93        21.93         3.80         0.00       1316        228          0
23:09:08 sdg               0.90        15.20         6.73         0.00        912        404          0

> The slowness of clearing dirty and what perf top showed (ext4* calls)
> indicates it is creating entries for small files and putting data in
> those files.   Creating entries for small files requires a lot of both
> read and write seeks and seeks are expensive.   At most I would expect
> you to be able to rsync/copy around 30-50 files/second (when the array
> is healthy and once the size gets small enough the mb/sec does not
> matter anymore as the seeks dominate).

My experience is that the array can handle all of this easily, and I never noticed
any hiccups.

> On my array I do a nightly copy in of data written during the day to a
> SSD (security cams).   And without any array issues that makes my
> array really busy.   Anything wrong with the array and that process
> takes several times as long.

What I see here is that a few seconds of usual work take a few hours to perform.
This does not look like the array is stressed, something more substantial is going on.

> On Thu, Nov 2, 2023 at 6:34 AM <eyal@eyal.emu.id.au> wrote:
>>
>> On 02/11/2023 19.34, Johannes Truschnigg wrote:
>>> Hi list,
>>>
>>> for the record, I do not think that any of the observations the OP made can be
>>> explained by non-pathological phenomena/patterns of behavior. Something is
>>> very clearly wrong with how this system behaves (the reported figures do not
>>> at all match the expected performance of even a degraded RAID6 array in my
>>> experience) and how data written to the filesystem apparently fails to make it
>>> into the backing devices in acceptable time.
>>>
>>> The whole affair reeks either of "subtle kernel bug", or maybe "subtle
>>> hardware failure", I think.
>>>
>>> Still, it'd be interesting to know what happens when writes to the array thru
>>> the file system are performed with O_DIRECT in effect, i.e., using `dd
>>> oflag=direct status=progress ...` - does this yield any observable (via
>>> `iostat` et al.) thruput to the disks beneath? What transfer speeds does `dd`
>>> report this way with varying block sizes? Are there no concerning messages in
>>> the debug ringbuffer (`dmesg`) at this time?
>>>
>>> I'm not sure how we'd best learn more about what the participating busy kernel
>>> threads (Fedora 38 might have more convenient devices up its sleeve than
>>> ftrace?) are spending their time on in particular, but I think that's what's
>>> needed to be known to pin down the underlying cause of the problem.
>>
>> To clarify what may be lost on this thread.
>>
>> I can dd to this fs just fine, The Dirty count does not go above about 4GB. The machine has 32KB.
>> It is cleared very fast. Tested writing 100GB.
>>
>> The Dirty blocks rise to the max then drain quickly.
>>
>> 2023-11-02 21:28:27 Dirty:               236 kB
>> 2023-11-02 21:28:37 Dirty:                 8 kB
>> 2023-11-02 21:28:47 Dirty:                40 kB
>> 2023-11-02 21:28:57 Dirty:                68 kB
>> 2023-11-02 21:29:07 Dirty:               216 kB
>> 2023-11-02 21:29:17 Dirty:               364 kB
>> 2023-11-02 21:29:27 Dirty:                20 kB
>> 2023-11-02 21:29:37 Dirty:                48 kB
>> 2023-11-02 21:29:47 Dirty:                24 kB
>> 2023-11-02 21:29:57 Dirty:                36 kB
>> 2023-11-02 21:30:07 Dirty:                28 kB
>> 2023-11-02 21:30:17 Dirty:                52 kB
>> 2023-11-02 21:30:27 Dirty:                36 kB
>> 2023-11-02 21:30:37 Dirty:           4112980 kB
>> 2023-11-02 21:30:47 Dirty:           3772396 kB
>> 2023-11-02 21:30:57 Dirty:           3849688 kB
>> 2023-11-02 21:31:07 Dirty:           3761132 kB
>> 2023-11-02 21:31:17 Dirty:           3846216 kB
>> 2023-11-02 21:31:27 Dirty:           3855060 kB
>> 2023-11-02 21:31:37 Dirty:           3902212 kB
>> 2023-11-02 21:31:47 Dirty:           4173524 kB
>> 2023-11-02 21:31:57 Dirty:           3849856 kB
>> 2023-11-02 21:32:07 Dirty:           3940632 kB
>> 2023-11-02 21:32:17 Dirty:           2212008 kB
>> 2023-11-02 21:32:27 Dirty:               244 kB
>> 2023-11-02 21:32:37 Dirty:               288 kB
>> 2023-11-02 21:32:47 Dirty:                60 kB
>>
>> rsync'ing a large tree into this same fs is different.
>> When killed less than 3GB were copied. Mostly small files in many directories.
>> Something like 92,059 files using 2,519MB.
>>
>> Note how slowly the dirty blocks are cleared.
>>
>> 2023-11-02 21:36:28 Dirty:               296 kB
>> 2023-11-02 21:36:38 Dirty:            277412 kB
>> 2023-11-02 21:36:48 Dirty:            403928 kB
>> 2023-11-02 21:36:58 Dirty:            606916 kB
>> 2023-11-02 21:37:08 Dirty:            753888 kB
>> 2023-11-02 21:37:18 Dirty:            641624 kB
>> 2023-11-02 21:37:28 Dirty:            744560 kB
>> 2023-11-02 21:37:38 Dirty:            946864 kB
>> 2023-11-02 21:37:48 Dirty:           1355964 kB
>> 2023-11-02 21:37:58 Dirty:           2365632 kB
>> 2023-11-02 21:38:08 Dirty:           2451948 kB
>> ### at this point the rsync was cancelled as I see the kthread start
>> 2023-11-02 21:38:18 Dirty:           2451752 kB
>> 2023-11-02 21:38:28 Dirty:           2440496 kB
>> 2023-11-02 21:38:38 Dirty:           2440308 kB
>> 2023-11-02 21:38:48 Dirty:           2440136 kB
>> 2023-11-02 21:38:58 Dirty:           2440036 kB
>> 2023-11-02 21:39:08 Dirty:           2440240 kB
>> 2023-11-02 21:39:18 Dirty:           2405768 kB
>> 2023-11-02 21:39:28 Dirty:           2405784 kB
>> 2023-11-02 21:39:38 Dirty:           2406012 kB
>> 2023-11-02 21:39:48 Dirty:           2405908 kB
>> 2023-11-02 21:39:58 Dirty:           2405848 kB
>> 2023-11-02 21:40:08 Dirty:           2405876 kB
>> 2023-11-02 21:40:18 Dirty:           2405704 kB
>> 2023-11-02 21:40:28 Dirty:           2405628 kB
>> 2023-11-02 21:40:38 Dirty:           2405544 kB
>> 2023-11-02 21:40:48 Dirty:           2405484 kB
>> 2023-11-02 21:40:58 Dirty:           2405416 kB
>> 2023-11-02 21:41:08 Dirty:           2405412 kB
>> 2023-11-02 21:41:18 Dirty:           2405240 kB
>> 2023-11-02 21:41:28 Dirty:           2405148 kB
>> 2023-11-02 21:41:38 Dirty:           2405132 kB
>> 2023-11-02 21:41:48 Dirty:           2404428 kB
>> 2023-11-02 21:41:58 Dirty:           2405056 kB
>> 2023-11-02 21:42:08 Dirty:           2404944 kB
>> 2023-11-02 21:42:18 Dirty:           2404904 kB
>> 2023-11-02 21:42:28 Dirty:           2404316 kB
>> 2023-11-02 21:42:38 Dirty:           2395340 kB
>> 2023-11-02 21:42:48 Dirty:           2394540 kB
>> 2023-11-02 21:42:58 Dirty:           2394368 kB
>> 2023-11-02 21:43:08 Dirty:           2394520 kB
>> 2023-11-02 21:43:18 Dirty:           2394132 kB
>> 2023-11-02 21:43:28 Dirty:           2394032 kB
>> 2023-11-02 21:43:38 Dirty:           2394276 kB
>> 2023-11-02 21:43:48 Dirty:           2386960 kB
>> 2023-11-02 21:43:58 Dirty:           2387420 kB
>> 2023-11-02 21:44:08 Dirty:           2386620 kB
>> 2023-11-02 21:44:18 Dirty:           2386828 kB
>> 2023-11-02 21:44:28 Dirty:           2386104 kB
>> 2023-11-02 21:44:38 Dirty:           2386328 kB
>> 2023-11-02 21:44:48 Dirty:           2382520 kB
>> 2023-11-02 21:44:58 Dirty:           2382024 kB
>> 2023-11-02 21:45:08 Dirty:           2381344 kB
>> 2023-11-02 21:45:18 Dirty:           2380776 kB
>> 2023-11-02 21:45:28 Dirty:           2380424 kB
>> 2023-11-02 21:45:38 Dirty:           2379672 kB
>> 2023-11-02 21:45:48 Dirty:           2380180 kB
>> 2023-11-02 21:45:58 Dirty:           2373272 kB
>> 2023-11-02 21:46:08 Dirty:           2372416 kB
>> 2023-11-02 21:46:18 Dirty:           2372052 kB
>> 2023-11-02 21:46:28 Dirty:           2372176 kB
>> ... and so on
>>
>> At the same time I see the kthread in top:
>>
>>       PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
>> 1491995 root      20   0       0      0      0 R  97.3   0.0  12:50.67 kworker/u16:2+flush-9:127
>>
>> And iostat of md127 shows slow writing like this:
>>            Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
>> 21:59:52 md127             3.50         0.00        30.40         0.00          0        304          0
>> 22:00:02 md127             3.10         0.00        31.20         0.00          0        312          0
>> 22:00:12 md127             2.00         0.00        64.40         0.00          0        644          0
>> 22:00:22 md127             3.40         0.00        22.80         0.00          0        228          0
>>
>> So, why the slow clearing of the dirty blocks?
>>
>> I will leave the machine to clear it into the night...
>>
>> BTW, if I try to shutdown in this situation, it will get stuck, and if I force a sysrq boot I get
>> an array of all spares on restart. At least this is what happened twice already.
>>
>> HTH
>>
>> --
>> Eyal at Home (eyal@eyal.emu.id.au)
>>

-- 
Eyal at Home (eyal@eyal.emu.id.au)

