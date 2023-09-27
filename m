Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F027E80A84
	for <linux-raid@archiver.kernel.org>; Wed, 27 Sep 2023 05:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjI0FBn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Sep 2023 01:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjI0FBA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Sep 2023 01:01:00 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C935FF4
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 21:29:32 -0700 (PDT)
Received: from [192.168.0.185] (ip5f5ae84f.dynamic.kabel-deutschland.de [95.90.232.79])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 68AAB61E5FE03;
        Wed, 27 Sep 2023 06:29:23 +0200 (CEST)
Message-ID: <b093b5be-2374-46f5-80b6-5247ef3de961@molgen.mpg.de>
Date:   Wed, 27 Sep 2023 06:29:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mdadm: Avoid array bounds check of gcc
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20230927025219.49915-1-xni@redhat.com>
 <20230927025219.49915-4-xni@redhat.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230927025219.49915-4-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Xiao,


Thank you for your patch.

Am 27.09.23 um 04:52 schrieb Xiao Ni:
> With gcc version 13.2.1 20230918 (Red Hat 13.2.1-3) (GCC), it reports error:
> super-ddf.c:1988:58: error: array subscript -1 is below array bounds of
> ‘struct phys_disk_entry[0]’ [-Werror=array-bounds=]

I wouldn’t wrap pasted lines.

> The subscrit is defined as int type. And it can be smaller than 0.

subscript?

> To avoid this error, add -Wno-array-bounds flag in Makefile.

Wouldn’t it be better to fix the error and not work around it by 
disabling the warning?


Kind regards,

Paul


> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 5eac1a4e9690..47da883a9fb9 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -50,7 +50,7 @@ ifeq ($(origin CC),default)
>   CC := $(CROSS_COMPILE)gcc
>   endif
>   CXFLAGS ?= -ggdb
> -CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> +CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -Wno-array-bounds
>   ifdef WARN_UNUSED
>   CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O3
>   endif
