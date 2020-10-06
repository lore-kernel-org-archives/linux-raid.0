Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED3CC4363D
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 22:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74ABD208C7
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 22:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgJFWYG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 18:24:06 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:46725 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgJFWYF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 6 Oct 2020 18:24:05 -0400
Received: from host86-157-96-171.range86-157.btcentralplus.com ([86.157.96.171] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kPvNL-0004dm-9G; Tue, 06 Oct 2020 23:24:04 +0100
Subject: Re: pls help/review: fed 32 | LVM over raid1, on SSDs & spinning
 disks
To:     Reindl Harald <h.reindl@thelounge.net>, linux-raid@zq3q.org,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <202010061607.096G7CgT4052287@epjdn.zq3q.org>
 <1f21b8cb-a9eb-74e8-24b5-550d016b6473@thelounge.net>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <1ab44a42-9824-b2f6-7acc-3de446a5cba4@youngman.org.uk>
Date:   Tue, 6 Oct 2020 23:24:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1f21b8cb-a9eb-74e8-24b5-550d016b6473@thelounge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 06/10/2020 18:00, Reindl Harald wrote:
> Am 06.10.20 um 18:07 schrieb linux-raid@zq3q.org:
>> Is it possible to get the 2MiB "bios boot" partition into raid1?
>> This seems to be the most vulnerable part of my setup.
> should be no problem when you have the same partitioning on all disks, 
> "BIOS boot" normally have no writes at boot time
> 
> RAID1 is handeled like a single disk at early boot
> 
> the only thing you need to do manually is install the bootloaer on all 
> disks and don#t forget repeat it after replace one
> 
Very much so ...

> the only thing i am not sure is the partition type, until now my setups 
> are MBR and sda1 is a RAID1 over all 4 disks

And the raid type. Is the bios boot accessed as part of the boot 
sequence - sounds like it must be :-) ?

Anything that might be accessed by something *before* linux is loaded, 
needs to be a 1.0 superblock. (I won't recommend 0.9 as it's obsolete.) 
That way, provided you ONLY access it to read, you can access the 
filesystem directly and bypass the raid by referencing the partition eg 
/dev/sda1. Then once linux has booted and mounted /dev/md1, any changes 
will be made to both partitions.

Cheers,
Wol
