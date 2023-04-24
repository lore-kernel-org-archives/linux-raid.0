Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0ACC77B61
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 15:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjDXPlP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 11:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjDXPlO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 11:41:14 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0AA1FC8
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 08:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=fuduimbCUhLbAghT7CSfwowmbJUYKSuKGCC1iuvJ1FA=; b=ZWQXgcrowidg0HhGq5Zq2p+y9s
        uJIzHzt5ndHsbiXaXjbSD4cC10RLpmDi+oa1U5CH9mPxWt4vRmIjfX6XKenIasuEw707DjwIAqpLb
        VrkJsFbPp+cpggpxUus9VzUiJDo70c/PPEqVZ0jmg+VKcPbzw5c4rlO58KQVgeFosgw+Lwg7DZSdV
        lvxy/Mh5bE1u7qyf6+HLresMcyIEY4NT6Dc2+yJGxVuckUHt0nwyRNFKI421E9nPIsBEyrywDCH5m
        s11VVMkPXu0SIFk971PTngCxiJki+Lhy1cZ6H6QagUIGio8adT6IPNiDyfZPGAjLd/sbftjP+3eB0
        /nb2jidQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1pqyJG-00HG6w-TS; Mon, 24 Apr 2023 09:40:59 -0600
Message-ID: <ad936a03-5f9e-7465-3565-7902069bd5fc@deltatee.com>
Date:   Mon, 24 Apr 2023 09:40:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Song Liu <song@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-raid@vger.kernel.org, David Sloan <David.Sloan@eideticom.com>
References: <20230417171537.17899-1-jack@suse.cz>
 <9a1e2e05-72cd-aba2-b380-d0836d2e98dd@deltatee.com>
 <CAPhsuW76n5w7AJ5Ee6foGgm4U2FpRDfpMYhELS7=gJE5SeGwAA@mail.gmail.com>
 <20230420112613.l5wyzi7ran556pum@quack3>
 <c5830dd8-57c5-0d94-a48d-d85f154607e0@deltatee.com>
 <CAPhsuW5aaaTL1Ed-wKb82DKSSqg+ckC0MboaOLSUuaiGmTYTuA@mail.gmail.com>
 <e6343cab-01e3-77da-8380-137703344768@deltatee.com>
 <ZEYllY6ZHZX+q9ZC@infradead.org>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <ZEYllY6ZHZX+q9ZC@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@infradead.org, song@kernel.org, jack@suse.cz, linux-raid@vger.kernel.org, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH] md/raid5: Improve performance for sequential IO
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023-04-24 00:45, Christoph Hellwig wrote:
> On Thu, Apr 20, 2023 at 02:10:02PM -0600, Logan Gunthorpe wrote:
>>> I am hoping to make raid5_make_request() a little faster for non-rotational
>>> devices. We may not easily observe a difference in performance, but things
>>> add up. Does this make sense?
>>
>> I guess. But without a performance test that shows that it makes an
>> improvement, I'm hesitant about that. It could also be that it helps a
>> tiny bit for non-rotational disks, but we just don't know.
>>
>> Unfortunately, I don't have the time right now to do these performance
>> tests.
> 
> FYI, SSDs in general do prefer sequential write streams.  For most you
> won't see a different in write performance itself, but it will help with
> reducing GC overhead later on.

Thanks. Yes, my colleague was able to run performance testing on this
patch and didn't find any degradation with Jan's optimization turned on.
So I don't think it's worth doing this only for rotational disks and
Jan's original patch makes sense.

Logan
