Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3970CC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 18:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16EC661438
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 18:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhEMSWi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 May 2021 14:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhEMSWg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 May 2021 14:22:36 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BBEC061574
        for <linux-raid@vger.kernel.org>; Thu, 13 May 2021 11:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uQiY4bLmoli3ohSmBsWyb69uKugtW3xNOmfKeR+AnXg=; b=j7evy8vWfnZmzi/8lnLfQ6xKI5
        6rWRtzqi+J3i2SGGm/pbMG0eK51Zs5hsHeru5hzL27qqQXhQY+OGSrpUIJ+SG0Fr/GsbARbkChE6v
        XpcJHPHyAJuQb6XNigO6F9gDcEfoNhuF8TQlgsDOfsq3+0WMBNOCIcrS/ymFFbQk7Ps8XeyC2fpI/
        E2x444cDZvyHtgpWWCnCcDV+3ma4vRy+91RXq0qP7INrkAXIXWP0eSoasSL4Fy9DuCPGgdMGnYr/H
        grnOdfxAnspKIrjzRRyaGxNyZH6BIVDvEQpE2QXBM3aSM7M7pLL4D737AkRwhi5DoCV/OOTqEd/cG
        6Tl56hAw==;
Received: from [12.35.44.237] (helo=[172.30.2.77])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1lhFxc-0007tK-BH; Thu, 13 May 2021 18:21:24 +0000
Subject: Re: raid10 redundancy
To:     Phillip Susi <phill@thesusis.net>,
        Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     d tbsky <tbskyd@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net>
 <87a6oyr64b.fsf@vps.thesusis.net>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <3f3fd663-77e4-8c23-eb22-1b8223eaf277@turmel.org>
Date:   Thu, 13 May 2021 14:21:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87a6oyr64b.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/13/21 11:38 AM, Phillip Susi wrote:
> 
> Roy Sigurd Karlsbakk writes:
> 
>> Basically, the reason to use raid10 over raid6 is to increase
>> performance. This is particularly important regarding rebuild
>> times. If you have a huge raid-6 array with large drives, it'll take a
>> long time to rebuild it after a disk fails. With raid10, this is far
>> lower, since you don't need to rewrite and compute so
>> much. Personally, I'd choose raid6 over raid10 in most setups unless I
> 
> How do you figure that?  Sure, raid6 is going to use more CPU time but
> that isn't going to be a bottleneck unless you are using some blazing
> fast NVME drives.  Certainly with HDD the rebuild time is simply how
> long it takes to write all of the data to the new disk, so it's going to
> be the same either way.
> 

No, rebuild isn't just writing to the new disk.  You have to read other 
disks to get the data to write.  In raid6, you must read at least n-2 
drives, compute, then write.  In raid10, you just read the other drive 
(or one of the other drives when copies>2), then write.

Phil
