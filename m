Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450CBC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 16 May 2022 06:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiEPGsJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 May 2022 02:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbiEPGsI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 May 2022 02:48:08 -0400
Received: from mallaury.nerim.net (smtp-100-sunday.noc.nerim.net [178.132.17.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11A31DF6A
        for <linux-raid@vger.kernel.org>; Sun, 15 May 2022 23:48:05 -0700 (PDT)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id A63D6DB17C;
        Mon, 16 May 2022 08:47:56 +0200 (CEST)
Message-ID: <5e0aea05-0159-a184-d5ea-dee176939b1c@plouf.fr.eu.org>
Date:   Mon, 16 May 2022 08:47:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: failed sector detected but disk still active ?
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
 <Yn6BEym8s0kVLhD0@lazy.lzy>
 <994cb384-3782-dac2-898b-ea02816a904f@youngman.org.uk>
 <056cdd2b-e7c7-d9dc-8e33-cb0727e70d42@plouf.fr.eu.org>
 <169db918-cdc1-e461-f484-058f41cbab87@youngman.org.uk>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <169db918-cdc1-e461-f484-058f41cbab87@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 15/05/2022 à 21:29, Wol a écrit :
> On 15/05/2022 19:39, Pascal Hambourg wrote:
>> Le 14/05/2022 à 15:46, Wols Lists a écrit :
>>>
>>> Or the rewrite fails, raid assumes the drive is faulty and kicks it 
>>> out. That's why you should never use desktop drives unless you know 
>>> EXACTLY what you are doing!
>>
>> What's wrong with desktop drives ?
> 
> Once things start going wrong, they go pear-shaped very fast.
> 
> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

I did not mean "in general", but in relation with "Or the rewrite fails, 
raid assumes the drive is faulty and kicks it out".
