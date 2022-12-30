Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB7AC4167B
	for <linux-raid@archiver.kernel.org>; Fri, 30 Dec 2022 10:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbiL3KUq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Dec 2022 05:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiL3KUp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Dec 2022 05:20:45 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117B1AD
        for <linux-raid@vger.kernel.org>; Fri, 30 Dec 2022 02:20:42 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aefab.dynamic.kabel-deutschland.de [95.90.239.171])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 71CA060027FD1;
        Fri, 30 Dec 2022 11:20:39 +0100 (CET)
Message-ID: <293f8482-8032-d857-2811-1fdd022b0742@molgen.mpg.de>
Date:   Fri, 30 Dec 2022 11:20:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/1] Don't handle change event against raw devices
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org,
        ncroxon@redhat.com
References: <20221230090748.53598-1-xni@redhat.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221230090748.53598-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Xiao,


Thank you for the patch.

Am 30.12.22 um 10:07 schrieb Xiao Ni:

It’d be great if you described the problem.

> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   udev-md-raid-assembly.rules | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
> index 39b4344b8592..748ea05dadaa 100644
> --- a/udev-md-raid-assembly.rules
> +++ b/udev-md-raid-assembly.rules
> @@ -11,6 +11,11 @@ SUBSYSTEM!="block", GOTO="md_inc_end"
>   ENV{SYSTEMD_READY}=="0", GOTO="md_inc_end"
>   
>   # handle potential components of arrays (the ones supported by md)
> +# For member devices which are md/dm devices, we don't need to
> +# handle add event. Because md/dm devices need to do some init jobs.
> +# Then the change event happens.
> +# When adding md/dm devices, ID_FS_TYPE only be linux_raid_member

A verb is missing. Maybe: … can only be …

> +# after change event happens.
>   ENV{ID_FS_TYPE}=="linux_raid_member", GOTO="md_inc"
>   
>   # "noiswmd" on kernel command line stops mdadm from handling
> @@ -28,6 +33,11 @@ GOTO="md_inc_end"
>   
>   LABEL="md_inc"
>   
> +# We only handle add event on raw disks. If we handle change event on raw disk,
> +# the tool parted can't change partition table unless clear superblock on

1.  *the* partition table
2.  Please excuse my ignorance, but what is a “clear superblock”?

> +# member disks

Add a dot/period at the end of sentences?

> +ACTION=="change", KERNEL!="dm-*|md*", GOTO="md_inc_end"
> +
>   # remember you can limit what gets auto/incrementally assembled by
>   # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
>   ACTION!="remove", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
