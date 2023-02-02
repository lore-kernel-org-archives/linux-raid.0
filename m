Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7D6C61DA4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Feb 2023 03:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjBCDF2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 22:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjBCDF1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 22:05:27 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8388193
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 19:05:25 -0800 (PST)
Received: from host81-147-105-30.range81-147.btcentralplus.com ([81.147.105.30] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pNiz1-000B7g-C8;
        Thu, 02 Feb 2023 23:27:12 +0000
Message-ID: <75cc693e-46a0-a206-2f6c-e97e44351fce@youngman.org.uk>
Date:   Thu, 2 Feb 2023 23:27:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: how to know a hard drive will mix well
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20230202124306.GH25616@jpo>
 <894cb7f7-eb13-69e8-8cd8-0f71dc34e489@youngman.org.uk>
 <5a19ad42-e66c-9757-4fe6-9e12c759b54a@plouf.fr.eu.org>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <5a19ad42-e66c-9757-4fe6-9e12c759b54a@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02/02/2023 22:47, Pascal Hambourg wrote:
> On 02/02/2023 at 19:52, Wols Lists wrote:
>>
>> Drives now are "Constant Head Speed" not constant rpm. I'm guessing, 
> 
> Source ?
> 
> "Constant linear velocity" (CLV, as opposed to "constant angular 
> velocity" - CAV) is adapted for use requiring a constant transfer rate 
> such as media recording or playback, not random access, and is mostly 
> found in optical disc drives.
> 
>> that what it means is that for the inner tracks it spins at 7200, and 
>> as the heads move out, the rpms slow down to keep the speed the head 
>> is going over the platter constant.
> 
> It also implies that the spindle is able to accelerate from the lower 
> speed (around 3600 RPM) to 7200 RPM or decelerate from 7200 to 3600 RPM 
> in less than the full stroke time, which is around 20 ms in order to not 
> degrade the access time. It sounds highly unlikely to me.

Just tried to Google it. Did I say I didn't trust WD?

It sounds like it's marketing speak designed to re-define the meaning of 
Revolutions Per Minute.

Apparently 7200rpm drives are being sold as "5400 class". Misleading 
people who are prepared to take the speed hit, into buying a drive that 
is power-hungry and noisy.

As the google page I saw said - "Why describe it as "5400-class" in a 
spec sheet - the people who don't know what it means won't be reading 
spec sheets, and the people who do read spec sheets won't know what the 
hell it means and it is deceptive".

I'd go and look for another X300, or an Ironwolf. At least you'll know 
what you're getting ...

Cheers,
Wol
