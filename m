Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB72C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jul 2022 16:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbiGYQak (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbiGYQah (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jul 2022 12:30:37 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE0F641A
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 09:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=v80hSsg09U5QiSVNa/44Fw0crFJzZ3cJaLp6nGR/l+c=; b=dGnXjYRn7DNgv5F8xXw9t4Ox4k
        /tTd2VefeWNPzGZkycxrurhVj+UV53oQvdl1Yf0goSlqdJnHXsl6XzMS7IOm18SGSJZjAt7eq4zRJ
        BlIAjRcEpy/ofCzSH5H7PCR9KPgrC3kWk+l8hdWOGreBJ7lueOiAfuYzNT+FDPvMmokr74QqR1Kty
        W4tlF1+iIQEehhm6SuOHhy8XpgCY4Nwkew3w3E+8Jkt9vurBazfgPfAz/dsf+bt/4YjkbMsaJHMbt
        ZxufB2SW4CnzQn/ogsa2ZQLUBCObjjJetHFOyqJPAg6BtJ4ZV36m3i8P47WSsjBWjJLStTrgwZr09
        5M/Mfy7A==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oG0yS-0002eA-ME; Mon, 25 Jul 2022 10:30:30 -0600
Message-ID: <8663e200-a825-d169-cb27-dff774f0a9ed@deltatee.com>
Date:   Mon, 25 Jul 2022 10:30:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
References: <20220723062429.2210193-1-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220723062429.2210193-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: md device allocation cleanups
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-23 00:24, Christoph Hellwig wrote:
> Hi all,
> 
> this small series cleans up the mddev allocation a bit by returning
> the structure to callers that want it instead of requiring another
> lookup.

I've reviewed and tested these two patches and they look good to me.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Thanks,

Logan
