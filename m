Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFFEC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 17 May 2022 14:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347401AbiEQO6P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 May 2022 10:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346439AbiEQO6K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 May 2022 10:58:10 -0400
Received: from mallaury.nerim.net (smtp-102-tuesday.noc.nerim.net [178.132.17.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 044444AE26
        for <linux-raid@vger.kernel.org>; Tue, 17 May 2022 07:58:06 -0700 (PDT)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id D4EDBDB18A;
        Tue, 17 May 2022 17:09:59 +0200 (CEST)
Message-ID: <26b37f8d-7f6b-dc43-c494-6d4370365b27@plouf.fr.eu.org>
Date:   Tue, 17 May 2022 16:57:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: failed sector detected but disk still active ?
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
 <Yn6BEym8s0kVLhD0@lazy.lzy>
 <994cb384-3782-dac2-898b-ea02816a904f@youngman.org.uk>
 <056cdd2b-e7c7-d9dc-8e33-cb0727e70d42@plouf.fr.eu.org>
 <169db918-cdc1-e461-f484-058f41cbab87@youngman.org.uk>
 <5e0aea05-0159-a184-d5ea-dee176939b1c@plouf.fr.eu.org>
 <a58016bf-5bc2-4272-7250-33ef9b11b6b2@youngman.org.uk>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <a58016bf-5bc2-4272-7250-33ef9b11b6b2@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 16/05/2022 à 09:09, Wols Lists a écrit :
> On 16/05/2022 07:47, Pascal Hambourg wrote:
>> Le 15/05/2022 à 21:29, Wol a écrit :
>>> On 15/05/2022 19:39, Pascal Hambourg wrote:
>>>> Le 14/05/2022 à 15:46, Wols Lists a écrit :
>>>>>
>>>>> Or the rewrite fails, raid assumes the drive is faulty and kicks it 
>>>>> out. That's why you should never use desktop drives unless you know 
>>>>> EXACTLY what you are doing!
>>>>
>>>> What's wrong with desktop drives ?
>>>
>>> Once things start going wrong, they go pear-shaped very fast.
>>>
>>> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>>
>> I did not mean "in general", but in relation with "Or the rewrite 
>> fails, raid assumes the drive is faulty and kicks it out".
> 
> Well, the timeout mismatch is directly responsible for a non-faulty 
> drive being kicked out the array ...

Thanks, I overlooked that line :
"the RAID code recomputes the block and tries to write it back to the 
disk. The disk is still trying to read the data and fails to respond".

On the other hand, I have seen faulty drives report success on write to 
an unreadable block then failing immediate read at the same location.
