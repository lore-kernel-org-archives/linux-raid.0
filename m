Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B834AC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 12:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242857AbhKXMND (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 07:13:03 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17256 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242715AbhKXMLP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Nov 2021 07:11:15 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637755679; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=LvJHhHL1FUZaVdTgjUnVs4VQiQRTl3qfDXXI42ltPdTpUY2lCebSOQj53rZ3FAooZ/NrJ3GAyRFCwiFY634wUXVioJYkq38GyUwhBIv40eRZDIuqZhI7QFeiAhY/Y2i7kYgSD0cU/q2hqfc+aEcXl4HJ/sVrlzp22vW6wXNq+GQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637755679; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Go7m5ts5IkyJxf7a0VefOLvVzbyX6EI7ssPWU6rGzGc=; 
        b=j/WyrlcCcYQdVeVSTw3jMFWcA5Y6ZNWOCvxSsD1JRTsQb2LNz62CFWDEu/x8z8ZspkSku4kcjYDxidxEZTf1gJhsggwFEYDsTg1QLT49VFcDupxf2y6Y1Ty+RlAWwp3Ul63CaV0QFFqFYeF2hcm5VXZBkl3DmpCN4aXtOBZaAEI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1637755676901947.8603728450965; Wed, 24 Nov 2021 13:07:56 +0100 (CET)
Subject: Re: [PATCH] Correct checking if file descriptors are valid
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20211124104833.27368-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <8c03d0e3-bdf0-31f6-4cfb-24fb2f352a2f@trained-monkey.org>
Date:   Wed, 24 Nov 2021 07:07:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211124104833.27368-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/21 5:48 AM, Mateusz Grzonka wrote:
> In some cases file descriptors equal to 0 are treated as invalid.
> Fix it.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Assemble.c    | 3 +--
>  Grow.c        | 5 +----
>  Incremental.c | 4 ++--
>  mdadm.c       | 3 +--
>  super-ddf.c   | 2 +-
>  5 files changed, 6 insertions(+), 11 deletions(-)

Applied!

Thanks,
Jes
