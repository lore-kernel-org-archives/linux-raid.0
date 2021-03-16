Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3F8C433E6
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 20:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8FC864D9D
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 20:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhCPU1L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 16:27:11 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17224 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhCPU0X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Mar 2021 16:26:23 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1615926374; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=XZGsDQmVLwYPPzxrBXLsJVlBbG7jwG++Xt/vEMe+hQoUC17fINmCSkTALluAPQwIBuHC1QU70N8gcJHEzBSylqc0iDyYDSispsh7kbXA6f+LGUUsl4C/UFRkBJDfB4iod8QcwBU/JPCKe77qMnKXQBlalqIz/DMfL34glvoB+v8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615926374; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=b+f/OqXFF5cidV5lUdjlprMoUZZrNyX4ZT247I5Zeu4=; 
        b=gUT3f3KOIzoy2FelVBcftVlJ13YLdjMuby5rtF9z4ggj43HFL8dI+V/73XxMvaKsyGwhUMQObq05HvHbnjhJHZkdr1lAIJlMwAVkHD9g3S07dtWuvGumv9IIa7mqb2kGBwLGpz3xPK0WhV0c+bUbHoILtx+cDvUZjj9m6II/JPk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615926372141902.2962961973266; Tue, 16 Mar 2021 21:26:12 +0100 (CET)
Subject: Re: [PATCH v2] imsm: nvme multipath support
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210312093016.7886-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <149777c0-03c8-6a0f-0d2c-64836539c7da@trained-monkey.org>
Date:   Tue, 16 Mar 2021 16:26:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210312093016.7886-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/12/21 4:30 AM, Mariusz Tkaczyk wrote:
> From: Blazej Kucman <blazej.kucman@intel.com>
> 
> Add support for nvme devices which are represented
> via nvme-subsystem.
> Print warning when multi-path disk is added to RAID.
> 
> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  platform-intel.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++-
>  platform-intel.h |  2 ++
>  super-intel.c    | 38 ++++++++++++++---------
>  3 files changed, 104 insertions(+), 15 deletions(-)
> 

Applied!

Thanks,
Jes


