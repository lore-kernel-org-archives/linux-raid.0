Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4E4C77B6E
	for <linux-raid@archiver.kernel.org>; Thu, 13 Apr 2023 12:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjDMMKr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Apr 2023 08:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDMMKp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Apr 2023 08:10:45 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068C46183
        for <linux-raid@vger.kernel.org>; Thu, 13 Apr 2023 05:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dQPoEAFiYrVyVxQAl0yvV0sbnG2ppWqxx/JO7L4ruRw=; b=DIrFX3g3v56qu3Xi2Gaj56Mw7U
        /jCwDcDfauJRCP7rqRMr0oX5RdX3UJI6h8lGBcOegWM9Pi0mfbSuP55isLHUiywgvq1shDJW43ZBu
        jCpsCbBZhBthw/i8hRsJFCWCV877udVtpLrial8hc7paeAk6/B94eCEHJfaGVtCJFN/kFeNeKBbRr
        58Fczz5M4IqcdFHCdfPV8pdZAnrZnvqR/RXkOU/UvJUfTWPRMx9295FtlMDehcbDF3jYiyjtotIfc
        40wrBXWJUEdOgteNMTjhbjs+c1Y54jHn85cWv4KwX6kCL57798UZ26zgFocE2cBG8N4/O1LLt/kRh
        ufQQJvHg==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1pmvmj-0006rW-U2; Thu, 13 Apr 2023 12:10:41 +0000
Message-ID: <c8118b2f-8951-97c7-badb-a57583857cff@turmel.org>
Date:   Thu, 13 Apr 2023 08:10:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Recover data from accidentally created raid5 over raid1
To:     Moritz Rosin <moritz@itrosinen.de>, Wol <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org, John Stoffel <john@stoffel.org>,
        NeilBrown <neilb@suse.com>
References: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
 <25653.47458.489415.933722@quad.stoffel.home>
 <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
 <83e691b8-4127-4691-da03-3c43d50f7a5c@turmel.org>
 <7ae36a36-05ce-0ae8-25c0-7757b9f0f62e@itrosinen.de>
 <9eecbba85eda547083fe907b398d52ed@itrosinen.de>
Content-Language: en-US
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <9eecbba85eda547083fe907b398d52ed@itrosinen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/13/23 02:10, Moritz Rosin wrote:
> Good Morning everyone.
> 
> Thank god I have very good news, since I managed to get access to 
> (hopefully most of) the data.
> I want to share the path I took with you for further reference.
> 
> First thing I tried was to use "foremost" directly on the raid array 
> (/dev/md0) that had no partition table.
> That was just partially successful since it ran *verry* slowly and 
> produced mixed results. Many broken files, no dir structure, no filenames.
> But there were files that came out correctly (content wise) - so I had 
> hope.
> 
> Following your advice I then start off on this page: 
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID 
> (chapter "Making the harddisks read-only using an overlay file").
> With what you assumed, that the data should be there on the raw disks, I 
> created overlays as explained.
> One note here: In step 3 the page used "blockdev --getsize ...." but in 
> my version (2.36.1) that parameter is marked as "deprecated" an didn't 
> work. I had to use "blockdev --getsz" instead.
> 
> Having the overlays I fiddled around and ended up using "testdisk", let 
> it analyze the overlay device "/dev/mapper/sdX1". After selecting "EFI 
> GPT" partition type, it found a partition table I was able to use.
>  From here on the process was pretty straight forward. testdisk showed 
> the disk's old file structure and I was able to copy the "lost" files to 
> a backup hdd.
> The process is still running but spot tests were pretty promising that 
> most of the data can be recovered.
> 
> When backup has finished. I will completely re-create the array and 
> start with a clean setup :-)
> 
> Thanks again for your support, input and thoughts.
> 
> Best
> Moritz

Good morning Moritz,

That's great news.  Thanks for reporting back.

Phil

