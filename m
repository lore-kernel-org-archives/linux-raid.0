Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC211C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 13:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82869616EB
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 13:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhEKNOp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 May 2021 09:14:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:21775 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhEKNOo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 11 May 2021 09:14:44 -0400
IronPort-SDR: UV0pxapyLoTddh3WTCE/AGUPzmffoA0jpwBMTP9v59l4IsB4XyrK7Rge2NNQSbmgRpI56JDJFd
 LSd/HsCSCeFw==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="284927953"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="284927953"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 06:13:38 -0700
IronPort-SDR: V+BoSjxs4FzKaaLZWK2UTmLwB4fskikLbEW+veZHw8MmgHtOXVWyUv0G/fd4dG4VSQaTsEB195
 CMm2Rh2au06Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="471119838"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 11 May 2021 06:13:30 -0700
Received: from [10.249.129.187] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.129.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id E0DE0580906;
        Tue, 11 May 2021 06:13:25 -0700 (PDT)
Subject: Re: Kernel bug in async_xor_offs during RAID5 recovery
To:     Xiao Ni <xni@redhat.com>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <d58a9209-b2a2-6f2a-73ea-a90c0970daf3@linux.intel.com>
 <3e5b79fd-f4ec-1db4-bddb-c3cdb7124497@redhat.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <bdb2be6e-fd1b-ef5a-1de7-222e4b981ae2@linux.intel.com>
Date:   Tue, 11 May 2021 15:13:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <3e5b79fd-f4ec-1db4-bddb-c3cdb7124497@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Xiao,
I simplified the scenario.

On 06.05.2021 12:57, Xiao Ni wrote:
> Hi Oleksandr Shchirskyi
> 
> Can this only happen with PPL, imsm and nvme disks? My machine doesn't support 
> creating raid device with nvme devices.
Could you try to create array with IMSM_NO_PLATFORM=1?

> And rotational disks don't have /sys/block/nvme1n1/device/device/remove. What's 
> the meaning about setting 1
> to the remove file?
> 
> I tried to create the imsm raid with rotational disks and ppl. Then remove and 
> add disk to trigger recovery. It works
> well.
I verified that drive removal is not crucial here.
The main trick here is to impose the PPL recovery. I did that by following
scenario:
1. Create array (I was able to reproduce it with 1Gb size):
#mdadm -CR imsm -e imsm -n3 /dev/nvme[456]n1
#mdadm -CR vol2 -l5 -n3 /dev/nvme[456]n1 -z 1G -c64 --assume-clean 
--consistency-policy=ppl

2. Get mdmon pid:
# ps -ef | grep mdmon

3. Write data to the drive, and kill mdmon after that (this will force
array to stay dirty):
#dd of=/dev/md126 if=/dev/urandom bs=4M oflag=direct; kill -9 {mdmon_pid}

4. Stop Array:
# mdadm -Ss

5. Start Array:
# mdadm -As

Thanks,
Mariusz
