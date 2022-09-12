Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F3DC6FA83
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 13:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiILNC3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiILNC2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 09:02:28 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9062F20BEA
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 06:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc
        :To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wk0WDl5OtBGE4xcqmZPAXz9/VVArHW2/xo2BZ0sn4QY=; b=nLbOwSF/rooBh6Wvc7kn/bcZ8P
        mG6d7TwJV4MEbA/M3nCROYekXs6vHDwtopUmqhP/sTcWvmghHJ5eqOVMpDGxbxSzzt2zDuk/VDvgV
        UX6t5mlrReEL2prW9ZhROFDy5wGshu9DXZbTClzagnfd1GgMm40B8bzveD+skCJ0hZzyWHiiw1vEB
        sq8Hs0BBGrPX2Agg8U48ZRHMinQywx0sz6AIycWPp16+j4dMDJwrsUF/I7W410FLVDjdbpK9Sl7wn
        lmvBwAYewaqI+vbPeuKHYM8GB9h0rmnBkTmIv/zpm8i74wpj0++1Z0hM24TCvFeyHM0T5SvHwJLAi
        5viW6P0w==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oXj4r-0006M3-Tt; Mon, 12 Sep 2022 13:02:17 +0000
Message-ID: <1f778c1f-6767-e581-0846-505edf01ed68@turmel.org>
Date:   Mon, 12 Sep 2022 09:02:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: 3 way mirror
Content-Language: en-US
To:     Roman Mamedov <rm@romanrm.net>,
        Reindl Harald <h.reindl@thelounge.net>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <53f5754d-e3e2-a8ba-bedb-07eb2b594595@thelounge.net>
 <CAJH6TXi=pCvV2xcyWcOD4KVDP6BcoPdgdMqhSwyW9BMVEhtzYA@mail.gmail.com>
 <dcef59a2-b8f6-ef8b-2fd6-2c8bfdfba4ad@thelounge.net>
 <2bcebfce-6def-38f8-99be-1f5702905f94@youngman.org.uk>
 <fe532dc9-daef-e096-f729-d1cd752f18d2@thelounge.net>
 <20220912142624.63ba4b5c@nvm>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <20220912142624.63ba4b5c@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/12/22 05:26, Roman Mamedov wrote:
> On Mon, 12 Sep 2022 10:16:55 +0200
> Reindl Harald <h.reindl@thelounge.net> wrote:
> 
>>> That's called paranoia
>>
>> that's called common sense
>>
>>> ALL drives have hiccups when there's absolutely
>>> nothing wrong with them. What are the manufacturer's error figures?
>>> Expect at least one error every two or three complete passes of pretty
>>> much every large big disk nowadays?
>> i don't expect any SMART error at all and if one hits after years of
>> uptime fine that the drive don't fail completly - but would i trust it? no!
> 
> I have multiple drives (Hitachi) which have developed around 3 to 10
> reallocated sectors, and then just continue to work for years, not increasing
> those further. Throwing them away would be uneconomical. Not always a
> reallocated sector is a sign of impeding failure, what you need to look for is
> if there is more than one, and the count is increasing quickly.

Concur. I do not replace drives for reallocated sectors until they reach 
double digits.  Modern drives are expected to do this.

> Generally though, if you are way too concerned about individual drive failures,
> it could be a sign that you do not have a robust enough backup scheme in place.

Heh.

Phil

