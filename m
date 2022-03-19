Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91860C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 19 Mar 2022 10:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242661AbiCSKPm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 19 Mar 2022 06:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiCSKPl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 19 Mar 2022 06:15:41 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A16F1AFE85
        for <linux-raid@vger.kernel.org>; Sat, 19 Mar 2022 03:14:20 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nVW6D-0004LL-Fo;
        Sat, 19 Mar 2022 10:14:18 +0000
Message-ID: <01d2c8c5-46ea-f69e-e285-da0abe6cd594@youngman.org.uk>
Date:   Sat, 19 Mar 2022 10:14:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
Content-Language: en-GB
To:     Marc MERLIN <marc@merlins.org>, Roman Mamedov <rm@romanrm.net>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid@vger.kernel.org
References: <20220319041020.GW3131742@merlins.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20220319041020.GW3131742@merlins.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19/03/2022 04:10, Marc MERLIN wrote:
>> If you find it needs more than the size of sdk1, as an emergency measure you
>> could wipe off the partition table and add the entire sdk as the array member.

> Yeah, I thought of that, just don't really like it, and not sure if
> mdadm -can looks for raw drives in addition to partitions
> 
mdadm has absolutely no trouble with that at all. All it cares about is 
if something is a block device - if it finds an mdadm signature at the 
start of a block device it will use it.

The problem is the eejits out there who assume that all physical drives 
must be partitioned. And we know from experience that there are eejits 
out there who assume that any drive without an MBR or GPT just *must* be 
unused and it's *perfectly* *okay* to write said MBR or GPT *without* 
*asking*. Just trashing your mdadm (or lvm, or whatever yada ydad) 
signature in the process.

It's not common, but we do get calls to recover arrays where the 
signature has gone missing because the owner made the mistake of 
upgrading their system (Windows, linux, whatever) and the upgrade 
stomped all over the array.

Cheers,
Wol
