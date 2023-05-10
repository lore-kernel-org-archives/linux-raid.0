Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5794C77B7D
	for <linux-raid@archiver.kernel.org>; Wed, 10 May 2023 06:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbjEJGvQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 May 2023 02:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbjEJGvP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 May 2023 02:51:15 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DC0270B
        for <linux-raid@vger.kernel.org>; Tue,  9 May 2023 23:51:13 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4QGQfQ0nr1zXKh;
        Wed, 10 May 2023 08:51:05 +0200 (CEST)
Message-ID: <80eebba8-5506-f7f5-721e-876f39f1ebc9@thelounge.net>
Date:   Wed, 10 May 2023 08:51:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: how to set md device to specific group at boot
Content-Language: en-US
To:     Benjammin2068 <benjammin2068@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <cb1e4326-f5bd-c3c1-f262-d0106c19cb88@gmail.com>
 <455d9008-b04a-6645-edae-633bc4c01c18@gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <455d9008-b04a-6645-edae-633bc4c01c18@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 10.05.23 um 03:57 schrieb Benjammin2068:
> On 5/9/23 8:25 PM, Benjammin2068 wrote:
> 
>> Hey all,
>>
>> I can't seem to find the answer (looking all around via google)...
>>
>> I have a couple of RAID drives (/dev/md123, /dev/md124) I set up a 
>> long time ago (storage arrays) by hand... And have worked fine.
>>
>> Tthey mount as root:root but I need them as root:disk

normally the filesystem defines owner/group

>> I can't seem to find where to change that.

what about uid=,gid= in the fstab?
works at least for vfat/sshfs

> The arrays I made weren't explicitly listed -- AUTO was assembling them

that's obvious by /dev/md123 and make sure you rebuild that initrd to 
contain the changed /etc/mdadm.conf

