Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33A0C433E6
	for <linux-raid@archiver.kernel.org>; Fri, 29 Jan 2021 20:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7A2264E05
	for <linux-raid@archiver.kernel.org>; Fri, 29 Jan 2021 20:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhA2UjK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Jan 2021 15:39:10 -0500
Received: from smtp1.math.uni-bielefeld.de ([129.70.45.10]:54352 "EHLO
        smtp1.math.uni-bielefeld.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233287AbhA2UjK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 29 Jan 2021 15:39:10 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2021 15:39:09 EST
Received: from [192.168.0.100] (tmo-111-25.customers.d1-online.com [80.187.111.25])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (3072 bits) server-digest SHA256)
        (Client did not present a certificate)
        by smtp1.math.uni-bielefeld.de (Postfix) with ESMTPSA id 983BF602A4
        for <linux-raid@vger.kernel.org>; Fri, 29 Jan 2021 21:31:35 +0100 (CET)
To:     linux-raid@vger.kernel.org
From:   Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Subject: Problem with initial sync of a RAID1 with 4Kn drives
Message-ID: <87ddf15f-e133-47b4-32f6-64a8c7b9d993@math.uni-bielefeld.de>
Date:   Fri, 29 Jan 2021 21:31:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello folks,

I recently got two new Seagate drives, Seagate Exos X X16, which are 
able to switch into native 4K mode. I used the Seagate tools to trigger 
the switch, and now want to use the two drives in a RAID1.

I proceeded to create the md device:
mdadm --create --verbose --level=1 --metadata=1.2 --raid-devices=2 
/dev/md/onyx-new /dev/sda /dev/sdb

As soon as the initial sync starts the kernel log begins to fill up with 
errors. Here's part of the kernel log:
https://gist.github.com/tobiasjakobi/d5b5f1638d23765d5e1fecf0dfbcea3e

This is a 5.10.11 vanilla kernel, but it also happens with the 5.9.y 
series. As you can see I already patched the kernel to include 
additional information:
DEBUG: 40801 1 7

This is just a simple print() in sd_setup_read_write_cmnd().
printk("DEBUG: %x %x %x\n", blk_rq_pos(rq), blk_rq_sectors(rq), mask);

So it seems that neither the position nor the number of sectors is 
aligned to eight. I assume that the md subsystem is supposed to handle this?

I then double-checked for sizes for the underlying block devices and the 
md device itself:
cat 
/sys/block/{sda,sdb,md126}/queue/{hw_sector_size,logical_block_size,physical_block_size}
4096

So it's 4K for all of them.

Here's the hdparm output for one of the drives:
https://gist.github.com/tobiasjakobi/a52cf5d4461db35c1f474c6a69b0782a

The drives themselves are fine, I can use them properly as standalone 
devices, so I rule out a hardware error.

Any hints how to further triage this? Also would it help to open a bug 
on the kernel bugtracker?

Thanks in advance!

With best wishes,
Tobias Jakobi

