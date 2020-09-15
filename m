Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C342C2D0E3
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 19:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26C422078D
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 19:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LEkey4w7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgIOTrm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 15:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727907AbgIOTmw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Sep 2020 15:42:52 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E68C061788
        for <linux-raid@vger.kernel.org>; Tue, 15 Sep 2020 12:34:36 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id h9so1053843ooo.10
        for <linux-raid@vger.kernel.org>; Tue, 15 Sep 2020 12:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=+Dxx6PYnegi0JUWn77nGavhOHgDfLV14zJxgf8wHOW8=;
        b=LEkey4w7FjpmXb6bx11nahcPzhtldJBsWrLOZPtVy7apdDsR2laAHJ48KF1YWnCz/Z
         MM96JOQTKF0hYS3nGE8BkmKsK9kM0fYgXW9+jGlXnsm/2e9FPgdVxRJW14fAe0sfR+Lq
         ZnNxiJxU7wX/ST2oCkdaNIVniq7i9kWoIRNs1p1MvijE6Y4q1L/JT79gen//Z3y9ZNF3
         o08dCCw5hYd9NpOLFolb5B4k2vC8/AoINeta5UCueAyuECJL8xj/e+WcD/Z63ntr3rBZ
         oS17fF6vav02OYE4wwDXm1G8pPDXnQ3Pe4WPBdOqSXT/oWCfYhqHyduCi4ZI+2ROGVQi
         da+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+Dxx6PYnegi0JUWn77nGavhOHgDfLV14zJxgf8wHOW8=;
        b=nJwpbphbg2j1evlqmg1GPubdoaIhQGKtfZjMVAmPNCoKPG5FSfMZECTDLkHXOarEN+
         uWA915eO/5x7PedRB3MVtDw38dsq37PWc4cg8/i1jXkpagnVvR7fGjzvRI1CTSSmwI64
         4XAqESpy2Dy/V58F7NJM8cUEy0kk4wF8ZLIkQFVbEg+JD3qumyxZ615PH8Qvb8M4ulFi
         b4UMsKbXzmBbgHWxSwpaTr4K9LNzpKnlPhwfuJ+H61vsvN/LfGTc0tWc14zhBfSw/EG0
         ECr+F3U65f2GRaXjccj5EAFfOgy8aHKr5IPeTlsYBG8+JO7xL4TYSgvgUSMt8U8tNR8/
         q8mQ==
X-Gm-Message-State: AOAM531t+9iufipWjqiky+qVKK1HiPxMWYZQY6nUhUyFqGECefFNo3Gi
        rL/rHNsKvY0SgCN7r5Nz0y/9UwqIpsQ=
X-Google-Smtp-Source: ABdhPJy9CMU6y6Ig6++3vV7X6IiG0lajPx9nAbZGAp7hHcsCydMStnxbT8iPXBvtIOIj4YxZHSfASw==
X-Received: by 2002:a4a:751a:: with SMTP id j26mr15355670ooc.14.1600198475832;
        Tue, 15 Sep 2020 12:34:35 -0700 (PDT)
Received: from [192.168.3.75] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id q14sm6279517ota.41.2020.09.15.12.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 12:34:35 -0700 (PDT)
Subject: Re: Linux raid-like idea
To:     John Stoffel <john@stoffel.org>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
 <5F54146F.40808@youngman.org.uk>
 <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
 <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
 <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
 <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
 <24413.1342.676749.275674@quad.stoffel.home>
 <9ba44595-8986-0b22-7495-d8a15fb96dbd@youngman.org.uk>
 <24414.5523.261076.733659@quad.stoffel.home>
 <5F5E425B.3040501@youngman.org.uk>
 <24416.8802.152441.102558@quad.stoffel.home>
 <CAAMCDefi-Y8joeobCJt-9_a8cDpeVWDsfGeVxXFWuQiwH2G0JQ@mail.gmail.com>
 <24417.718.670043.535084@quad.stoffel.home>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <f677f8d6-a831-7a85-3089-221723f021c5@gmail.com>
Date:   Tue, 15 Sep 2020 14:34:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <24417.718.670043.535084@quad.stoffel.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/15/20 1:07 PM, John Stoffel wrote:
>>>>>> "Roger" == Roger Heflin <rogerheflin@gmail.com> writes:
>>> I've been looking at them for a while now, but hesitating
>>> because... not sure why.  I'm using a CoolerMaster case with five
>>> 5.25" bays, plus a 3.5" bay external, and another three or four
>>> internal 3.5" bays.  Works great.  Nice and plain and not flashing
>>> lights or other bling.  And not too loud either.  Which is good.
>>>
>>> But I've used crappy drive cages before, crappy hot swap ones.  Not
>>> good.  And I think it's time I just went with a 4U rack mount with a
>>> bunch of hot swap bays, if I could only find one that wasn't an arm
>>> and a leg.
>>>
> Roger> I have had good luck with the ICY DOCK brand how swap I have 4
> Roger> different 4 bay-3bay ones spanning 6+ years and they all seem
> Roger> to just work.  And each newer version seemed to have improved
> Roger> design from the prior ones (plugs easier to get to, and such).
>
> Thanks for the recommendation!  I'll be looking at these for
> sure. Just wish my case could hold two of them.  It would be nice if
> they made a 2.5 x 5.25" to 4 x 3.5" disk carrier, so I could stuff two
> of them into my 5 exposed 5.25" bays.  *grin*
John,

   Drive cages come in varity of sizes. You have 1 to 1, 2 to 3, 3 to 4 
and 4 to 5. Mix and match to fill all 5 bays with best density of 3.5 
inch bays.  Here is one example and I am sure you can find many.

https://www.newegg.com/p/pl?d=hot+swap+bay&N=100007599%20600551589&name=SSD+%2F+HDD+Accessories&Order=4

I have three cages, two istar and 1 icy doc. My icy dock lost one bay. 
The others are holding a bit better. So, YMMV. However, expect them to 
have noisy fans. You may want to change to quieter/reliable ones.


Regards
Ramesh
