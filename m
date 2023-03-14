Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA4BC74A44
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 07:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCNHfR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 03:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCNHfQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 03:35:16 -0400
Received: from out-32.mta0.migadu.com (out-32.mta0.migadu.com [IPv6:2001:41d0:1004:224b::20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FE57EA26
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 00:35:15 -0700 (PDT)
Message-ID: <af276fee-83ef-9ea1-9cac-780b8ec4d36c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678779309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=edTL1ChsFLgLp+9Mx158bJIu0pMvObDSKpDy9vl1sV4=;
        b=nQNsxHPmKx6VtUcwYs2j8QYlLBChciqk12ca27qhGTt/i7Gtf8fMNJ6ZXdNPjOli119aeT
        aGegS/eRPxxwkpn3UFkawZaPHiQMtJxzQK84uR3WOs9nom8kqQZprz9McvMce2cKzO3HzG
        5j5GflqYin/YEFI0WULy+c4Q//Tfb5Y=
Date:   Tue, 14 Mar 2023 15:35:08 +0800
MIME-Version: 1.0
Subject: Re: Bug in reshape+discard?
To:     Benjamin Sonntag <benjamin@octopuce.fr>,
        linux-raid <linux-raid@vger.kernel.org>
References: <1132955858.4035.1677965762570.JavaMail.zimbra@z1.octopuce.fr>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <1132955858.4035.1677965762570.JavaMail.zimbra@z1.octopuce.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 3/5/23 05:36, Benjamin Sonntag wrote:
> Hi everyone,
>
> I think we found a bug in the mdadm code here at Octopuce.

Probably something wrong inside md raid.

> I'm reporting it here, please tell me if that's not the right place to report it, or if you need any other information.
>
> This bug "hangs" processes in the Device-busy (D) state forever, until we reboot. It has been tested on both a debian 5.10 an 6.0 Linux kernel

Do you mean it happened on both kernel versions? Could you share
relevant stacks by "cat /proc/${pid of D state process}/stack''?

> How to trigger the bug:
>
> - create a raid5 or raid6 block device using mdadm
> mdadm --create /dev/md0 -l 5 -n 3 /dev/sd{a,b,c}2
>
> - create a partition on it and mount it USING DISCARD/TRIM (important) (the underlying device must support trim)
> mkfs.ext4 /dev/md0
> mount /dev/md0 /mnt -o discard
>
> - create a few files
> for i in $( seq 1 1000 ) ; do dd if=/dev/zero of=/mnt/$i bs=10M count=1 ; done
>
> - expand the raid by adding a new drive
> mdadm --add /dev/md0 /dev/sdd2
> mdadm --grow /dev/md0 -n 4
>
> - the last command will start a "reshape" operation on md0
> - DURING THE RESHAPE (it's important) erase some file (it goes fine)
> rm /mnt/* -rf
>
> - THEN, still during the reshape (important) try to sync or fsync
> sync
>
> - the sync process get stuck in the D state. no way to kill it until reboot
> (in fact, any process that does sync during the reshape after some files were deleted will get stuck, such as mariadbd or rsyslog...)
>
> - If you don't mount with discard your partition, the 'sync' works properly
>
>
> An easy way to circumvent this problem:
>
> - before reshaping, remount without discard
> mount /mnt -o remount,nodiscard
>
> - after the reshaping ends, remount with discard
> mount /mnt -o remount,discard
>
>
> We don't really know how to start searching for a solution, since it requires knowing the internal of MD & Discard pretty well :/ (and I'm definitely not a kernel coder ;) )
>
> thanks for your help on this issue,

Assume reshape + discard works with previous kernel version, maybe
you can try to bisect kernel tree to see which commit might caused
the bug.

Thanks,
Guoqing
