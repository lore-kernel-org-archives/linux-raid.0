Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02138C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 25 Oct 2021 11:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDA7860EDF
	for <linux-raid@archiver.kernel.org>; Mon, 25 Oct 2021 11:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhJYLDx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Oct 2021 07:03:53 -0400
Received: from smarthost01c.ixn.mail.zen.net.uk ([212.23.1.22]:48356 "EHLO
        smarthost01c.ixn.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232642AbhJYLDw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 25 Oct 2021 07:03:52 -0400
Received: from [82.71.70.4] (helo=aawcs.co.uk)
        by smarthost01c.ixn.mail.zen.net.uk with esmtp (Exim 4.90_1)
        (envelope-from <john@aawcs.co.uk>)
        id 1mexjM-0002uA-WB
        for linux-raid@vger.kernel.org; Mon, 25 Oct 2021 11:01:29 +0000
Received: from [192.168.1.200] ( [192.168.1.200])
          by aawcs.co.uk with ESMTP (Mailtraq/2.17.7.3560) id AWCS4B5C02EF
          for linux-raid@vger.kernel.org; Mon, 25 Oct 2021 12:02:33 +0100
Subject: Missing Superblocks
References: <de712291-fa08-b35a-f8fb-6d18b573f3f4@aawcs.co.uk>
To:     linux-raid <linux-raid@vger.kernel.org>
From:   John Atkins <John@aawcs.co.uk>
Organization: AAW Control Systems
X-Forwarded-Message-Id: <de712291-fa08-b35a-f8fb-6d18b573f3f4@aawcs.co.uk>
Message-ID: <a5f362c3-122e-d0ac-1234-d4852e43adfa@aawcs.co.uk>
Date:   Mon, 25 Oct 2021 12:01:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <de712291-fa08-b35a-f8fb-6d18b573f3f4@aawcs.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Hops: 1
X-Originating-smarthost01c-IP: [82.71.70.4]
Feedback-ID: 82.71.70.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good-day All
I "have" an array RAID6 6drives 1 spare. The OS got corrupted on reboot.
On a fresh install the array is non detectable. Investigation shows that 
out of the 6 active drives only the first one has a valid super block 
the rest look to be corrupt. My assumption is that this might be down to 
the fact that I raided on raw drives /dev/sdX and not on partitions 
/dev/sdX1. Is this recoverable or should I load from a backup?
I assumed trying to create using --assume-clean should work but 
currently the only drive with a super block shows as busy except it is 
not mounted.
Many Thanks
John Atkins
