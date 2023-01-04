Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB36C53210
	for <linux-raid@archiver.kernel.org>; Wed,  4 Jan 2023 15:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbjADPtQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Jan 2023 10:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbjADPtP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 Jan 2023 10:49:15 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A94395C5
        for <linux-raid@vger.kernel.org>; Wed,  4 Jan 2023 07:49:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672847337; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=FyR/TqQ+6hCMUDr0ZDOa46QAsXGb3j7dOZ4zv8dWJSAd5oAe4+c4C+nRLWDpA5F133sQPxwpv0EKdyxqWoLx/HjRkfnTYt9Vh+RACS1LwEgBOMNc9mPV3bPYbMsXhxlBHYeZhTa2ORfxNd9e+CgXT0loMXAjNyY8nbTVqOZCHfs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672847337; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=h+XIbmLiHN9O0vNFk50o0l/yfEyxqGCVljaoYStjKOA=; 
        b=TXmNwgu9q1uSRsZaBNzE9ikSu9DGWYuk4iv+6g62QU489JP9LBIN8D3o+I2azsiWBitccZG0SDdcNf0H3gPTqZ3xeVSx/DC1wPoP8DNYgZUwU1aRT0EymqKsrnMewsXtMg5KVhmi+hIixJPEZ3hmI7MC9GaTapp3shBHdnaRw+w=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672847335511532.1907010382436; Wed, 4 Jan 2023 16:48:55 +0100 (CET)
Date:   Wed, 4 Jan 2023 10:48:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 1/1] Don't handle change event against raw devices
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com
References: <20221230090748.53598-1-xni@redhat.com>
 <293f8482-8032-d857-2811-1fdd022b0742@molgen.mpg.de>
 <CALTww28mmnVwL_FWT6zXXEdSk=6B24zXVxji-Etm=SxFhjPnVg@mail.gmail.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <42c89d1a-44f8-1991-0a97-df7a0c06ffcc@trained-monkey.org>
In-Reply-To: <CALTww28mmnVwL_FWT6zXXEdSk=6B24zXVxji-Etm=SxFhjPnVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/30/22 05:37, Xiao Ni wrote:
> On Fri, Dec 30, 2022 at 6:20 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>>
>> Dear Xiao,
>>
>>
>> Thank you for the patch.
>>
>> Am 30.12.22 um 10:07 schrieb Xiao Ni:
>>
>> It’d be great if you described the problem.
> 
> Hi Paul
> 
> Thanks. I'll describe more in next version.
>>

Hi Xiao,

Did you post an updated version?

Thanks,
Jes



