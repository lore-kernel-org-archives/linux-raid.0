Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DE8C61DA4
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 23:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbjBBXgQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 18:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjBBXgQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 18:36:16 -0500
X-Greylist: delayed 502 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Feb 2023 15:36:14 PST
Received: from mail-out-auth2.hosts.co.uk (mail-out-auth2.hosts.co.uk [212.84.127.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D045123
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 15:36:13 -0800 (PST)
Received: from host81-147-105-30.range81-147.btcentralplus.com ([81.147.105.30] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pNj7k-000ART-Dt;
        Thu, 02 Feb 2023 23:36:12 +0000
Message-ID: <3fd60eba-48b1-e6e3-ad44-1af14f67e69d@youngman.org.uk>
Date:   Thu, 2 Feb 2023 23:36:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: how to know a hard drive will mix well
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20230202124306.GH25616@jpo>
 <894cb7f7-eb13-69e8-8cd8-0f71dc34e489@youngman.org.uk>
 <5a19ad42-e66c-9757-4fe6-9e12c759b54a@plouf.fr.eu.org>
 <75cc693e-46a0-a206-2f6c-e97e44351fce@youngman.org.uk>
In-Reply-To: <75cc693e-46a0-a206-2f6c-e97e44351fce@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Replying to myself,

https://www.amazon.co.uk/Seagate-ST12000VN0008-4TB-ST4000VM000/dp/B07J351T2V/ref=sr_1_5?keywords=12tb+hard+drive&qid=1675380717&sprefix=12TB+has%2Caps%2C77&sr=8-5

https://www.amazon.co.uk/Plus-12TB-Internal-Hard-Drive/dp/B0BNJFHGHR/ref=sr_1_2?crid=MDH53LQ81TE3&keywords=wd+12TB+red+plus&qid=1675380788&sprefix=wd+12tb+red+plus%2Caps%2C64&sr=8-2

The Ironwolf is £50 - 20% - cheaper than the WD. Ditch the WD ...

Cheers,
Wol

On 02/02/2023 23:27, Wol wrote:
> On 02/02/2023 22:47, Pascal Hambourg wrote:
>> On 02/02/2023 at 19:52, Wols Lists wrote:
>>>
>>> Drives now are "Constant Head Speed" not constant rpm. I'm guessing, 
>>
>> Source ?
>>
>> "Constant linear velocity" (CLV, as opposed to "constant angular 
>> velocity" - CAV) is adapted for use requiring a constant transfer rate 
>> such as media recording or playback, not random access, and is mostly 
>> found in optical disc drives.
>>
>>> that what it means is that for the inner tracks it spins at 7200, and 
>>> as the heads move out, the rpms slow down to keep the speed the head 
>>> is going over the platter constant.
>>
>> It also implies that the spindle is able to accelerate from the lower 
>> speed (around 3600 RPM) to 7200 RPM or decelerate from 7200 to 3600 
>> RPM in less than the full stroke time, which is around 20 ms in order 
>> to not degrade the access time. It sounds highly unlikely to me.
> 
> Just tried to Google it. Did I say I didn't trust WD?
> 
> It sounds like it's marketing speak designed to re-define the meaning of 
> Revolutions Per Minute.
> 
> Apparently 7200rpm drives are being sold as "5400 class". Misleading 
> people who are prepared to take the speed hit, into buying a drive that 
> is power-hungry and noisy.
> 
> As the google page I saw said - "Why describe it as "5400-class" in a 
> spec sheet - the people who don't know what it means won't be reading 
> spec sheets, and the people who do read spec sheets won't know what the 
> hell it means and it is deceptive".
> 
> I'd go and look for another X300, or an Ironwolf. At least you'll know 
> what you're getting ...
> 
> Cheers,
> Wol
