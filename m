Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEEBC4361B
	for <linux-raid@archiver.kernel.org>; Tue, 15 Dec 2020 16:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30192223D6
	for <linux-raid@archiver.kernel.org>; Tue, 15 Dec 2020 16:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgLOQg7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgLOQgt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Dec 2020 11:36:49 -0500
X-Greylist: delayed 985 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Dec 2020 08:36:08 PST
Received: from titan.nuclearwinter.com (titan.nuclearwinter.com [IPv6:2605:6400:20:950:ed61:983f:b93a:fc2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45A8C06179C
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 08:36:08 -0800 (PST)
Received: from [IPv6:2601:6c5:8001:2780:f5b9:6856:8fb8:83f3] ([IPv6:2601:6c5:8001:2780:f5b9:6856:8fb8:83f3])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id 0BFGJWVb021928
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 11:19:39 -0500
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com 0BFGJWVb021928
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1608049180;
        bh=MQmEPQQ2MVGeBq89gU4g58Ve4hiNjjW/sS3Xb/wdxp0=;
        h=To:From:Subject:Date:From;
        b=FIm2kMd4LFoMR4JAbdY7cwH5jVKAa6RNPyQQ9rH2i4JgLAPEYoAJOryHQKA+5MC29
         Gy/zJgFIJs80NhAn5LMKgcHpA2sKWTydfNOl1QSHsOYCK/DUDNgutMfUEppLvbI1AF
         7oPtiTT1uCDAQOlPMz20NammRI9zzzk30rAoZ+Wk=
To:     linux-raid <linux-raid@vger.kernel.org>
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: raid6 performance > 16 drives
Message-ID: <3f5d2de5-fd58-95ea-231b-8be760b75896@nuclearwinter.com>
Date:   Tue, 15 Dec 2020 11:19:32 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (titan.nuclearwinter.com [IPv6:2605:6400:20:950:ed61:983f:b93a:fc2b]); Tue, 15 Dec 2020 11:19:43 -0500 (EST)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I'm looking for advise on how to best configure mdraid with 16 or more 
drives. My goal is to maximize sequential read speed while maintaining a 
high level of fault tolerance (2 or more failures).

I had a 16 drive raid 6 array that performed reasonably well. Peak drive 
performance (check) was ~180MB/s which is not far from the native drive 
performance of ~200MB/s. I recently added 4 more drives and now the 
check performance is only 50MB/s per drive.

I had similar issues on another, older, system with 12 drives that I did 
solve by setting group_thread_cnt to 2 but in that case the md1_resync 
process was very close to 100% CPU. In this case it's only about 50%. On 
this (20 drive) system, setting group_thread_cnt to 2 caused performance 
to drop to 35MB/s.

md1 : active raid6 sdf1[10] sdh1[16] sdi1[17] sdb1[13] sdc1[12] sdg1[8] 
sda1[15] sde1[9] sdd1[11] sds1[18] sdn1[5] sdq1[6] sdj1[1] sdp1[14] 
sdk1[2] sdl1[3] sdt1[19] sdm1[0] sdr1[4] sdo1[7]
       140650080768 blocks super 1.2 level 6, 128k chunk, algorithm 2 
[20/20] [UUUUUUUUUUUUUUUUUUUU]
       [=============>.......]  check = 69.3% (5419742336/7813893376) 
finish=795.6min speed=50150K/sec
       bitmap: 0/4 pages [0KB], 1048576KB chunk

# cat /sys/block/md1/md/stripe_cache_size
32768

I have confirmed that this system can read from all 20 drives at top 
speed (200MB/s) simultaneously by running 20 dd's in parallel. So, this 
isn't a bus, CPU or memory bandwidth constraint of the system.

The array is mainly used for media files and accesses are large and 
sequential. This particular host is storing backups so maintaining high 
sequential performance is important in order to keep backup/restore time 
to a minimum.

I recall reading that the mdraid raid6 implementation was fundamentally 
single threaded and suffered from memory bandwidth constraints due to 
many necessary copy operations. How does one best avoid these 
constraints? Does chunk size matter?

Would raid 60 help? If I split this into two 10 drive raid6 arrays, 
would each array run on separate cores?

Any advise would be appreciated. Thank you.

--Larkin
