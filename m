Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B5EC04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 21:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiG1VPz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 17:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiG1VPy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 17:15:54 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95B7C52
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 14:15:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659042925; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=a7n4zQJ4owAeufkCYe/MYvph6V6AC6Lji7ixjn2rSbb56ClKT/k/9lr0R+CWVjnHHfTboM3V84MxLWp1IIRuTItixYXJwUgkx5izBHLeC0hffBouu6mt5gUa0/G7808Y8ybmIeNm876DNsr0tYJiCjejTjlzEujfBP4FfVX9CAg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1659042925; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=OJQl8F60wpSMixKJPCyIpI0zyiM4vXimsJvKgCHnTbs=; 
        b=b23l7938ei9YFAVbLqRL2E0ztz+a0l2sGdAev2XQNMSnvLnmVZYNzlCLmTX0apY3FEDn0Vr3EsXxI+8nz5tnnIgTHWvXj2MUZDH3Y043YaKhjRj3zm8gSTjhiiR20iLyu9Iou5AXzaJAOl1JwOF0pjEHjIDtRKgZ+jKpjaZ7pOU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1659042923362918.4059749581562; Thu, 28 Jul 2022 23:15:23 +0200 (CEST)
Message-ID: <e4affbf6-621c-4bdd-b8dd-b4a60ef1b0a6@trained-monkey.org>
Date:   Thu, 28 Jul 2022 17:15:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/5 v2] parse_layout_faulty: fix memleak
Content-Language: en-US
To:     Wu Guanghao <wuguanghao3@huawei.com>, linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linfeilong@huawei.com, lixiaokeng@huawei.com
References: <fd86d427-2d3e-b337-6de8-d70dcbbd6ce1@huawei.com>
 <00ae6b42-b561-6542-0421-4ab8542d5d75@huawei.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <00ae6b42-b561-6542-0421-4ab8542d5d75@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/8/22 23:06, Wu Guanghao wrote:
> char *m is allocated by xstrdup but not free() before return, will cause
> a memory leak.
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  util.c | 3 +++
>  1 file changed, 3 insertions(+)

Hi Wu

This no longer seems to apply, would you mind rebasing and resending the
series?

Thanks,
Jes

> diff --git a/util.c b/util.c
> index cc94f96e..46b04afb 100644
> --- a/util.c
> +++ b/util.c
> @@ -427,8 +427,11 @@ int parse_layout_faulty(char *layout)
>         int ln = strcspn(layout, "0123456789");
>         char *m = xstrdup(layout);
>         int mode;
> +
>         m[ln] = 0;
>         mode = map_name(faultylayout, m);
> +       free(m);
> +
>         if (mode == UnSet)
>                 return -1;
> 
> --
> 2.27.0

