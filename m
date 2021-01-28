Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A70C433DB
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jan 2021 21:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EACF660235
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jan 2021 21:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhA1Vuu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:50:50 -0500
Received: from moglen4.apt.columbia.edu ([160.39.60.15]:37876 "EHLO
        mx.sflc.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231531AbhA1Vur (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 28 Jan 2021 16:50:47 -0500
Received: from [10.65.72.101] (onering.p.sflc.info [10.65.72.101])
        by mx.sflc.info (Postfix) with ESMTPSA id 107F2C1F520;
        Thu, 28 Jan 2021 16:50:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=softwarefreedom.org;
        s=dkim; t=1611870606; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPHKMOMpfYVcMbHR4zJexyxChHhHTvr/0UQhXhUUvWA=;
        b=HSSJEOAS42k9KEdcVpBzb+yTf582pH0YylLte3h1xNzDWVASGiG0XOIh9pmMpgLGZrTfSQ
        3+i0TMP00sIwuzqRyEn7SsO7bZs/NQRriDHyIHb7+ILKzGa6U+EA/L9o1HNeqDYA3mHIkT
        jOdaa9+Ay8Ge7b5ASVvwUAPXD8cDWYM=
To:     antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <09505ed1-ad29-28f1-627e-8a6a0b8df3a4@softwarefreedom.org>
 <bfbf7ae7-b443-4559-38ba-d7b9710792ba@youngman.org.uk>
From:   Daniel Gnoutcheff <gnoutchd@softwarefreedom.org>
Subject: Re: "attempt to access beyond end of device" when reshaping raid10
 from near=2 to offset=2
Message-ID: <d1ff4b3c-a05e-5712-8edd-05d9046f7701@softwarefreedom.org>
Date:   Thu, 28 Jan 2021 16:50:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <bfbf7ae7-b443-4559-38ba-d7b9710792ba@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/27/21 7:59 PM, antlists wrote:
> I seem to remember this coming up very recently. And I also seem to 
> remember them coming up with fixes but I'm not sure if it's solved.
> 
> So if you search the archive you should find a recent thread and an 
> update should fix it properly soon.
> 
> Oh - and as for Stretch, old mdadm and Ubuntu are known to be, shall we 
> say, problematic when you reshape an array, so please try not to ... :-)

Thanks for warning me about reshapes on stretch.  I was in fact planning 
some reshapes on a production stretch system.  I shall reconsider. :)

I would be curious to read the thread in which the raid10 layout reshape 
issue has already been discussed, but I've not been able to find it.  I 
tried 'raid10 reshape', 'raid10 layout reshape', 'raid layout reshape', 
and 'reshape "attempt to access beyond end of device"' in the search box 
at [1], and I've skimmed the subject lines for the last two month's 
worth of messages, but I couldn't find anything applicable.  Are there 
other terms I should try?

[1] https://www.spinics.net/lists/raid/

Many thanks,
-- 
Daniel Gnoutcheff
Systems Administrator
Software Freedom Law Center
