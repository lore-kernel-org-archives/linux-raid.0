Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BA7C4361B
	for <linux-raid@archiver.kernel.org>; Sun, 20 Dec 2020 18:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F0F22AAF
	for <linux-raid@archiver.kernel.org>; Sun, 20 Dec 2020 18:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgLTSmL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 20 Dec 2020 13:42:11 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17209 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgLTSmK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 20 Dec 2020 13:42:10 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1608489682; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=bxFA9R7rrX8a2ElN8nCVXQ79qlvGVK6s1tghR36aJhcmXyHx5dv0VDI74OFwp6clleNETf4Hbq6YsLoDUasobbokiPPExOOmfLnHsZxLf49sqUClsYeD4eEHjlObyKhgSukLttvKhjJ+E+8dnvqpfh8IQM+guzaNL+qD0MCUj6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1608489682; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gixsIN96pBjVBzX61pEaacI514zug63TkA5uif6ZMzI=; 
        b=lCt1AsOPaw1HugiP37tBuj8cri1+3WxP6mhRgoMdh4zpNnKNUZ0y+K5oMrxwl5u6BDWJ4Eke1R9K4FFgTIqMY5IDgyV1lSRQKWpw2JxFDEW+TfiyQLKCBh/BTmiydNS6SN4Gi/a8PHkongf1m4EUvGZDB/ypzWKCfxQoQ+khGIM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-108-46-250-244.nycmny.fios.verizon.net [108.46.250.244]) by mx.zoho.eu
        with SMTPS id 1608489680447643.311147570458; Sun, 20 Dec 2020 19:41:20 +0100 (CET)
Subject: Re: [PATCH] Incremental: Remove redundant spare movement logic
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20201211112838.10900-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <ea0def9e-0170-33f9-b0aa-90c273383130@trained-monkey.org>
Date:   Sun, 20 Dec 2020 13:41:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201211112838.10900-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/11/20 6:28 AM, Mariusz Tkaczyk wrote:
> If policy is set then mdmonitor is responsible for moving spares.
> This logic is reduntant and potentialy dangerus, spare could be moved at
> initrd stage depending on drives appearance order.
> 
> Remove it.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Applied!

Thanks,
Jes


