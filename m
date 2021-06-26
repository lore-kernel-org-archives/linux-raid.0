Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84148C49EA5
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 13:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6284261C35
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 13:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhFZNPk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 26 Jun 2021 09:15:40 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:22353 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhFZNPk (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 26 Jun 2021 09:15:40 -0400
Received: from host86-157-72-169.range86-157.btcentralplus.com ([86.157.72.169] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lx87Y-0004IN-B5; Sat, 26 Jun 2021 14:13:16 +0100
Subject: Re: 4-disk RAID6 (non-standard layout) normalise hung, now all disks
 spare
To:     Jason Flood <3mu5555@gmail.com>, 'Phil Turmel' <philip@turmel.org>,
        linux-raid@vger.kernel.org
References: <007601d769ba$ced0e870$6c72b950$@gmail.com>
 <6d412bf3-a7b9-1f08-2da9-96d34d8f112b@turmel.org>
 <00f101d76a7b$bdb3fc50$391bf4f0$@gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <df60eb5f-b1c0-b3f8-4985-3cb8d9dcc531@youngman.org.uk>
Date:   Sat, 26 Jun 2021 14:13:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <00f101d76a7b$bdb3fc50$391bf4f0$@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 26/06/2021 12:09, Jason Flood wrote:
>      Reshape Status : 99% complete
>       Delta Devices : -1, (5->4)
>          New Layout : left-symmetric
> 
>                Name : Universe:0
>                UUID : 3eee8746:8a3bf425:afb9b538:daa61b29
>              Events : 184255
> 
>      Number   Major   Minor   RaidDevice State
>         6       8       16        0      active sync   /dev/sdb
>         7       8       32        1      active sync   /dev/sdc
>         5       8       48        2      active sync   /dev/sdd
>         4       8       64        3      active sync   /dev/sde

Phil will know much more about this than me, but I did notice that the 
system thinks there should be FIVE raid drives. Is that an mdadm bug?

That would explain the failure to assemble - it thinks there's a drive 
missing. And while I don't think we've had data-eating trouble, 
reshaping a parity raid has caused quite a lot of grief for people over 
the years ...

However, you're running a recent Ubuntu and mdadm - that should all have 
been fixed by now.

Cheers,
Wol
