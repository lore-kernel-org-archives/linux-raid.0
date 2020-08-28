Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22CEC433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 15:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEC1320872
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 15:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgH1Ple (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 11:41:34 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:40249 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgH1Pl2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 11:41:28 -0400
Received: from host86-157-102-164.range86-157.btcentralplus.com ([86.157.102.164] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kBgVK-0001Dg-9G; Fri, 28 Aug 2020 16:41:27 +0100
Subject: Re: increase size of raid
To:     grumpy@mailfence.com, linux-raid@vger.kernel.org
References: <nycvar.QRO.7.76.2008241430040.28072@tehzcl5.tehzcl-arg>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <d6a5a32d-07e7-cd77-8e1d-55216f98bc15@youngman.org.uk>
Date:   Fri, 28 Aug 2020 16:41:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <nycvar.QRO.7.76.2008241430040.28072@tehzcl5.tehzcl-arg>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/08/2020 20:33, grumpy@mailfence.com wrote:
> i have 2 6tb drives
> i use a 3tb partition on each drive for raid 1
> i want to increase the size of the partitions
> what are the steps for this that will result in the least likelihood of 
> me screw'n up my system
> thanks

Seeing as no-one else has commented - you don't happen to have a spare 
disk by any chance? In that case you simply create a new 6TB partition 
on your new disk, and do a replace. You can then rinse and repeat with 
the disk you've just freed.

Otherwise, what I think you do is ... SHUT DOWN THE ARRAY. I *think* you 
can increase the partition size by deleting the old 3TB partition then 
just creating a new one starting in exactly the same place. Do it on one 
disk, test it by restarting the array. If it works, rinse and repeat on 
the second disk.

You now have a 3TB array on 2 6TB partitions. You should be able to do 
an "mdadm --grow" on the array - no need to specify the size as it 
should default to 6TB - to make a 6TB array. There are reports that 
might fail - a reboot should fix that - and you can now grow your 
filesystem to use the whole array.

Cheers,
Wol
