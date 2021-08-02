Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F2DC4338F
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F41060F4B
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhHBOe5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:34:57 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17057 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbhHBOey (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Aug 2021 10:34:54 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627914880; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=PmllIUVl0Q9zu1pGiz+TxCIXitcElujysWIXUvJITXy1W30ogMChcS9NJCEouKg1dFa5a0Qab6MKZoIoaszjm8stVFt0cREjVbBAEm5E72v+LTDVIdFxVS4KZo9ztuBIcGPV22VzEf8F1AUGXo/LnZUJA1R4Pw+Rn4nmsFuRA7A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627914880; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8OdkwZ/IPA8/7RO7vkAIwa7dd5AQ/3FADKRyEdy0ZB0=; 
        b=YP5cedoCm5zPdmWIgp6mE/aYXpTXO1wsE0aY+U4Vw0JI/a5QO+v6rDU4wrvAbbCBxPb5p4dun/BlDKnIEh8mQtlTByScJFzRA4EigIvlIEjjYoaHOHI0L56mTUslCwEe6CMa3vYwPFGObJ3PhYLZnqMmpCWPjTnOYG4qtBaBTl8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627914880021569.0995172989291; Mon, 2 Aug 2021 16:34:40 +0200 (CEST)
Subject: Re: [PATCH 1/5] tests: remove raid0 tests for 0.90 metadata version
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc:     linux-raid@vger.kernel.org
References: <20210722182733.GA24996@oracle.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <eecd7f0b-2d6c-44ac-92f8-33c600e13c3d@trained-monkey.org>
Date:   Mon, 2 Aug 2021 10:34:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210722182733.GA24996@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/22/21 2:27 PM, Sudhakar Panneerselvam wrote:
> Some of the test cases fail because raid0 creation fails with the error,
> "0.90 metadata does not support layouts for RAID0" added by commit,
> 329dfc28debb. Removing the 0.90 test to make these test cases to work.
> 
> removed 04r0update test completely as it is specific to raid0 for 0.9
> version.
> 
> '04update-metadata' and '03r0assem' still fails at a different place after
> this change which will be fixed in an upcoming commit.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  tests/00raid0           | 11 --------
>  tests/00readonly        |  4 +++
>  tests/03r0assem         | 72 -------------------------------------------------
>  tests/04r0update        | 20 --------------
>  tests/04update-metadata |  2 +-
>  5 files changed, 5 insertions(+), 104 deletions(-)
>  delete mode 100644 tests/04r0update

I'm really happy to see effort put into updating the test suite. However
rather than removing tests, it would be nice to turn it around and make
a test that make sure we do not allow creating a 0.9 raid0 array with
layouts.

Cheers,
Jes
