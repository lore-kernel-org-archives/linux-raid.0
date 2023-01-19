Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03506C004D4
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 17:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjASRMJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 12:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjASRMA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 12:12:00 -0500
X-Greylist: delayed 594 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Jan 2023 09:11:50 PST
Received: from ipv6test5.plus.com (postbox.buttersideup.com [IPv6:2001:470:1b4a:32::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833428F6C5
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 09:11:50 -0800 (PST)
Received: from [IPV6:2001:470:1b4a::5e6] (custard.lan [IPv6:2001:470:1b4a::5e6])
        by ipv6test5.plus.com (Postfix) with ESMTPSA id 18CB8499B31F;
        Thu, 19 Jan 2023 17:01:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buttersideup.com;
        s=2021022401; t=1674147712; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n9fYTXrDGnJsEdcbyAxaYY0od9h35xFUJg4RmbzSrag=;
        b=DNVtcW/zBAqc4o04v70pRjQL+AI9TKuS5XcXmm1gKDAxbXPrABbZExkkw/u0SZGQz4y9ju
        t9blaVvKYZCLxIju2LIQrovyvyWfWL50Cjjquwdlkr/JdEVFgGuDqHqf/EHUT3TSSNidZ9
        kL2mJwpoU9oiUpvNWQQ6zVOGNOIUOeY=
Message-ID: <b67d871b-e8bf-f13a-81b5-e8e87f47a35d@buttersideup.com>
Date:   Thu, 19 Jan 2023 17:01:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Question on sdds
Content-Language: en-GB
To:     Roman Mamedov <rm@romanrm.net>, o1bigtenor <o1bigtenor@gmail.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf599Vr2tEgpmURTbK09uesM6PYYof1ngCFkvAUmcHnowVA@mail.gmail.com>
 <20230119213540.0da26fbb@nvm>
From:   Tim Small <tim@buttersideup.com>
In-Reply-To: <20230119213540.0da26fbb@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Some drives also support nvme-device-self-test and and nvme-*-log commands.

Tim.

On 19/01/2023 16:35, Roman Mamedov wrote:
> On Thu, 19 Jan 2023 10:12:03 -0600
> o1bigtenor <o1bigtenor@gmail.com> wrote:
> 
>> There is smartmontools for testing the health of hdds.
>>
>> Is there something comparable for sdds?
>> (Thinking this includes nvme, sdds, usb sticks, m2 listed drives
>> (is that in this group) or any similar.)
> 
> smartmontools does support NVMe and SATA SSDs no problem.
> 
> It does not support USB flash sticks, SD cards and eMMC storage.
> 
