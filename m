Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3C0C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 08:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 131B0610E5
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 08:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhHSIWX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Aug 2021 04:22:23 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13446 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbhHSIWW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Aug 2021 04:22:22 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GqyLv6F40zdcHs;
        Thu, 19 Aug 2021 16:17:59 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 16:21:42 +0800
Received: from [10.174.179.184] (10.174.179.184) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 16:21:42 +0800
Message-ID: <07c4f930-cc9b-2fe8-7d01-04ff383ef90e@huawei.com>
Date:   Thu, 19 Aug 2021 16:21:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0
From:   Wu Guanghao <wuguanghao3@huawei.com>
Subject: Re: [PATCH]mdadm: fix coredump of mdadm --monitor -r
To:     <linux-raid@vger.kernel.org>, <jsorensen@fb.com>,
        <mariusz.tkaczyk@linux.intel.com>, <jes@trained-monkey.org>
CC:     <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>
References: <41edfa76-4327-7468-b861-1c1140ee9725@huawei.com>
In-Reply-To: <41edfa76-4327-7468-b861-1c1140ee9725@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.184]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ping

在 2021/8/16 15:24, Wu Guanghao 写道:
> Hi,
> 
> The --monitor -r option requires a parameter, otherwise a null pointer will be manipulated
> when converting to integer data, and a coredump will appear.
> 
> # mdadm --monitor -r
> Segmentation fault (core dumped)
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  ReadMe.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/ReadMe.c b/ReadMe.c
> index 06b8f7e..070a164 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
>   *     found, it is started.
>   */
> 
> -char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
> +char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
>  char short_bitmap_options[]=
> -               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
> +               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
>  char short_bitmap_auto_options[]=
> -               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
> +               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:RSow1tye:k";
> 
>  struct option long_options[] = {
>      {"manage",    0, 0, ManageOpt},
> --
> 2.23.0
> .
> 
