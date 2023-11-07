Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFF0C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 21:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbjKGVtT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 16:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjKGVtS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 16:49:18 -0500
Received: from SMTP.sabi.co.uk (SMTP.sabi.co.UK [185.17.255.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0838F10D0
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 13:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=root.for.sabi.co.uk; s=dkim-00; h=From:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version;
        bh=IEICYczDx4Wl1DwTC1/E4yT9cN3teKlH5ptG0eUb80M=; b=MIPI4Sglx2xOXYlfjAOvU4qcXu
        xiN427BOTPHiOT8d7+nek6aoRVQwOhGt4BXQIzowJmWIJSY3zOFhwzaaCvYv6d6KINcrROswHvTNi
        giZ0W7gH7zPiNrFyMknMN6plQg1z2u88nki+qvcLAWGKANGObBoOEBIY7V5XJjpR0b6eEMt6APyx2
        syP8BrDYeoPh6L7Q9yqUn5sMTwE6rpPtEF9FeI+/oztyxX4Wr/LsJ+V9+4yaM2EvosDvdkvhJHQXY
        q++Qst5C4IbnNlv5gvhTJUs7BDL4nfJVroFqA0bL6p6NUss8m2aM6zaKImuNmgSopEHYQQEbH6fGn
        ht4ecIZw==;
Received: from [87.254.0.135] (helo=petal.ty.sabi.co.uk)
        by SMTP.sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
        id 1r0TPK-007MC5-6wby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Tue, 07 Nov 2023 21:14:46 +0000
Received: from localhost ([127.0.0.1] helo=petal.ty.sabi.co.uk)
        by petal.ty.sabi.co.uk with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
        id 1r0TPF-000aev-D0
        for <linux-raid@vger.kernel.org>; Tue, 07 Nov 2023 21:14:41 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25930.43201.247015.388374@petal.ty.sabi.co.uk>
Date:   Tue, 7 Nov 2023 21:14:41 +0000
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: extremely slow writes to degraded array
In-Reply-To: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> 7 disks raid6 array(*1). boot, root and swap on a separate
> SSD. [...] One disk was removed recently and sent for
> replacement. The system felt OK but a few days later I noticed
> an issue... I started copying the full dataset (260GB 8,911k
> files). [...] 4GB (system limit) dirty blocks were created,
> which took 12h to clear.

The MD RAID set is performing well as designed. The achievable
speed is very low except on special workloads, but that low
speed is still good performance for that design, which is close
to optimal for maximizing wait times on your workload.
Maximizing storage wait times is a common optimization in many
IT places.
https://www.sabi.co.uk/blog/17-one.html?170610#170610
https://www.sabi.co.uk/blog/15-one.html?150305#150305

> [...] The copy completed fast but the kthread took about 1.5
> hours at 100%CPU to clear the dirty blocks.
> - When copying more files (3-5GB) the rsync was consuming
>   100%CPU and started pausing every few files (then killed). A
> - 'dd if=/dev/zero of=/data1/no-backup/old-backups/100GB'
>   completed quickly, no issues. [...]
[...]
> +  100.00%     1.60%  [kernel]  [k] ext4_mb_regular_allocator
> +   67.08%     5.93%  [kernel]  [k] ext4_mb_find_good_group_avg_frag_lists
> +   62.47%    42.34%  [kernel]  [k] ext4_mb_good_group
> +   22.51%    11.36%  [kernel]  [k] ext4_get_group_info
> +   19.70%    10.80%  [kernel]  [k] ext4_mb_scan_aligned

My guess is that the filesystem residing on that RAID set is
nearly full, has lots of fragmentation, has lots of small files
and likely two out of three or even all three. Those are also
common optimizations used in many IT places to maximize storage
wait times.

https://www.techrepublic.com/forums/discussions/low-disk-performance-after-reching-75-of-disk-space/
https://www.spinics.net/lists/linux-ext4/msg26470.html
