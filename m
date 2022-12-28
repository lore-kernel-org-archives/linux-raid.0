Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A965FC3DA7D
	for <linux-raid@archiver.kernel.org>; Wed, 28 Dec 2022 14:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiL1O74 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Dec 2022 09:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiL1O7u (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Dec 2022 09:59:50 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589D511C2F
        for <linux-raid@vger.kernel.org>; Wed, 28 Dec 2022 06:59:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672239584; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Iv53F7ioxdLkxajvc3iGrVR5v7CqFihKd7y8N+vr3Xg3ToJ/B6+kiSsQDhKP97/gEphdcSpNUeEmymOlFFxCAj+2JmshUOq7xUXOxPYtLsL2Wg7p0w+5Hsd/YpFKaIzvrgGRAKGFJC/d+cqxme8zyjjYSDHtXoBOx9Oy/vY5LRg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672239584; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=i1EtiH6wtX79MQE1bG+MSONt6J72ElseQibyy4S6bKk=; 
        b=hA9CCJnzcohOeL9EP9k8EL+2lnpt0SwctJAT47BZDixOZMzpdhtozHfDyCXDgv4bXWgML5bUab5MueYqJg3OmzqQzKJqR76FkclX7AvDGBDL9uK3RqrW0z5EybePtarKU4dKbdFn44HnzheZxvgYNPuwG+jctmuMyqjAJrvH3QY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672239582837957.6064679231546; Wed, 28 Dec 2022 15:59:42 +0100 (CET)
Message-ID: <3e493bcf-79af-2680-f5e9-162e8f67d43a@trained-monkey.org>
Date:   Wed, 28 Dec 2022 09:59:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH V2] Grow: fix possible memory leak
Content-Language: en-US
To:     Blazej Kucman <blazej.kucman@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20221221125254.17932-1-blazej.kucman@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20221221125254.17932-1-blazej.kucman@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/21/22 07:52, Blazej Kucman wrote:
> In function Grow_addbitmap, struct mdinfo
> may be allocated but is not freed
> in few exit paths. Add free 'mdi' variable
> in missing exit paths to avoid possible memory leak.
> 
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>  Grow.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes


