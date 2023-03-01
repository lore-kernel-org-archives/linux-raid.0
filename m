Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9142AC64ED6
	for <linux-raid@archiver.kernel.org>; Wed,  1 Mar 2023 17:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjCAR5E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Mar 2023 12:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCAR5D (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Mar 2023 12:57:03 -0500
Received: from out-38.mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8994393C
        for <linux-raid@vger.kernel.org>; Wed,  1 Mar 2023 09:57:01 -0800 (PST)
Message-ID: <b109f953-fd46-6037-c976-f1690cb4ff8b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677693417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4zimWpfNtb0dZgZDcuP6cL+wRta+cPpHIomr/6asIG4=;
        b=UbZhmtUm29wi3/X12x8OWvfCIkPoyXOv/kW4kW4dRW8ygHgfPh06BZ/8zk1D2kSFhxmXns
        aNzlf1xMGFofn8+mGd4Vy7muYGJXuJKYvguWVB5AMhVnen8DeCRncxklqP49fMCMQuZIzx
        xoZjtuPhuKmZh6Spkls4eI0EnvYcdR4=
Date:   Wed, 1 Mar 2023 10:56:56 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v5 3/3] md: Use optimal I/O size for last bitmap page
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Reindl Harald <h.reindl@thelounge.net>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
References: <20230224183323.638-1-jonathan.derrick@linux.dev>
 <20230224183323.638-4-jonathan.derrick@linux.dev>
 <CALTww2_P6TaV7C5i2k5sUeHOpnqTxjFB-ZA98Y2re+17J5d7Kw@mail.gmail.com>
 <2f2ba1cb-a053-7494-ce42-4670b66baacf@linux.dev>
 <CALTww2-ie0Y+0JMQAASKwDhAwcmD-aOuf=_J_GD95ATUi7w-3Q@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
In-Reply-To: <CALTww2-ie0Y+0JMQAASKwDhAwcmD-aOuf=_J_GD95ATUi7w-3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/1/2023 5:36 AM, Xiao Ni wrote:
> On Wed, Mar 1, 2023 at 7:10 AM Jonathan Derrick
> <jonathan.derrick@linux.dev> wrote:
>>
>> Hi Xiao
>>
>> On 2/26/2023 6:56 PM, Xiao Ni wrote:
>>> Hi Jonathan
>>>
>>> I did a test in my environment, but I didn't see such a big
>>> performance difference.
>>>
>>> The first environment:
>>> All nvme devices have 512 logical size, 512 phy size, and 0 optimal size. Then
>>> I used your way to rebuild the kernel
>>> /sys/block/nvme0n1/queue/physical_block_size 512
>>> /sys/block/nvme0n1/queue/optimal_io_size 4096
>>> cat /sys/block/nvme0n1/queue/logical_block_size 512
>>>
>>> without the patch set
>>> write: IOPS=68.0k, BW=266MiB/s (279MB/s)(15.6GiB/60001msec); 0 zone resets
>>> with the patch set
>>> write: IOPS=69.1k, BW=270MiB/s (283MB/s)(15.8GiB/60001msec); 0 zone resets
>>>
>>> The second environment:
>>> The nvme devices' opt size are 4096. So I don't need to rebuild the kernel.
>>> /sys/block/nvme0n1/queue/logical_block_size
>>> /sys/block/nvme0n1/queue/physical_block_size
>>> /sys/block/nvme0n1/queue/optimal_io_size
>>>
>>> without the patch set
>>> write: IOPS=51.6k, BW=202MiB/s (212MB/s)(11.8GiB/60001msec); 0 zone resets
>>> with the patch set
>>> write: IOPS=53.5k, BW=209MiB/s (219MB/s)(12.2GiB/60001msec); 0 zone resets
>>>
>> Sounds like your devices may not have latency issues at sub-optimal sizes.
>> Can you provide biosnoop traces with and without patches?
>>
>> Still, 'works fine for me' is generally not a reason to reject the patches.
> 
> Yes, I can. I tried to install the biosnoop in fedora38 but it failed.
> These are the rpm packages I've installed:
> bcc-tools-0.25.0-1.fc38.x86_64
> bcc-0.25.0-1.fc38.x86_64
> python3-bcc-0.25.0-1.fc38.noarch
> 
> Are there other packages that I need to install?
> 
I've had issues with the packaged versions as well

Best to install from source:
https://github.com/iovisor/bcc/
https://github.com/iovisor/bcc/blob/master/INSTALL.md#fedora---source

> Regards
> Xiao
> 
