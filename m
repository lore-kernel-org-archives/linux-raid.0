Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2840EC678DB
	for <linux-raid@archiver.kernel.org>; Tue,  7 Mar 2023 09:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCGJnD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Mar 2023 04:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCGJnC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Mar 2023 04:43:02 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0B955BF
        for <linux-raid@vger.kernel.org>; Tue,  7 Mar 2023 01:42:58 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id BD2C260027689;
        Tue,  7 Mar 2023 10:42:55 +0100 (CET)
Message-ID: <2829d42b-1619-b13b-acd1-6331af783fbe@molgen.mpg.de>
Date:   Tue, 7 Mar 2023 10:42:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 08/34] md: don't initilize statics/globals to 0/false
 [ERROR]
To:     Heinz Mauelshagen <heinzm@redhat.com>
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com, xni@redhat.com,
        dkeefe@redhat.com
References: <cover.1678136717.git.heinzm@redhat.com>
 <0692170434769af589854c961ece89a44414c698.1678136717.git.heinzm@redhat.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <0692170434769af589854c961ece89a44414c698.1678136717.git.heinzm@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Heinz,


Thank you for your patch.

Am 06.03.23 um 22:27 schrieb heinzm@redhat.com:
> From: Heinz Mauelshagen <heinzm@redhat.com>

There is a small typo in the commit message summary: initi*a*lize.

> Signed-off-by: heinzm <heinzm@redhat.com>

Please also use the full name in the Signed-off-by line.

> ---
>   drivers/md/md.c    | 2 +-
>   drivers/md/raid0.c | 2 +-
>   drivers/md/raid5.c | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e6ff0da6ebb6..9dc1df40c52d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5563,7 +5563,7 @@ static struct kobj_type md_ktype = {
>   	.default_groups	= md_attr_groups,
>   };
>   
> -int mdp_major = 0;
> +int mdp_major;
>   
>   static void mddev_delayed_delete(struct work_struct *ws)
>   {
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 582457cea439..11b9815f153d 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -19,7 +19,7 @@
>   #include "raid0.h"
>   #include "raid5.h"
>   
> -static int default_layout = 0;
> +static int default_layout;
>   module_param(default_layout, int, 0644);
>   
>   #define UNSUPPORTED_MDDEV_FLAGS		\
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 00151c850a35..d0b6a97200fa 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -64,7 +64,7 @@
>   
>   #define RAID5_MAX_REQ_STRIPES 256
>   
> -static bool devices_handle_discard_safely = false;
> +static bool devices_handle_discard_safely;
>   module_param(devices_handle_discard_safely, bool, 0644);
>   MODULE_PARM_DESC(devices_handle_discard_safely,
>   		 "Set to Y if all devices in each array reliably return zeroes on reads from discarded regions");

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
