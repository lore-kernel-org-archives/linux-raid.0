Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9179AC433FE
	for <linux-raid@archiver.kernel.org>; Mon, 16 May 2022 07:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbiEPHJe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 May 2022 03:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiEPHJW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 May 2022 03:09:22 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E61BE0DB
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 00:09:09 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nqUqo-0004ps-AY;
        Mon, 16 May 2022 08:09:06 +0100
Message-ID: <a58016bf-5bc2-4272-7250-33ef9b11b6b2@youngman.org.uk>
Date:   Mon, 16 May 2022 08:09:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: failed sector detected but disk still active ?
Content-Language: en-GB
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
 <Yn6BEym8s0kVLhD0@lazy.lzy>
 <994cb384-3782-dac2-898b-ea02816a904f@youngman.org.uk>
 <056cdd2b-e7c7-d9dc-8e33-cb0727e70d42@plouf.fr.eu.org>
 <169db918-cdc1-e461-f484-058f41cbab87@youngman.org.uk>
 <5e0aea05-0159-a184-d5ea-dee176939b1c@plouf.fr.eu.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <5e0aea05-0159-a184-d5ea-dee176939b1c@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 16/05/2022 07:47, Pascal Hambourg wrote:
> Le 15/05/2022 à 21:29, Wol a écrit :
>> On 15/05/2022 19:39, Pascal Hambourg wrote:
>>> Le 14/05/2022 à 15:46, Wols Lists a écrit :
>>>>
>>>> Or the rewrite fails, raid assumes the drive is faulty and kicks it 
>>>> out. That's why you should never use desktop drives unless you know 
>>>> EXACTLY what you are doing!
>>>
>>> What's wrong with desktop drives ?
>>
>> Once things start going wrong, they go pear-shaped very fast.
>>
>> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
> 
> I did not mean "in general", but in relation with "Or the rewrite fails, 
> raid assumes the drive is faulty and kicks it out".

Well, the timeout mismatch is directly responsible for a non-faulty 
drive being kicked out the array ...

Cheers,
Wol
