Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008BFC433F5
	for <linux-raid@archiver.kernel.org>; Sun, 20 Mar 2022 09:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbiCTJ40 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 20 Mar 2022 05:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiCTJ40 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 20 Mar 2022 05:56:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9565E255B0
        for <linux-raid@vger.kernel.org>; Sun, 20 Mar 2022 02:55:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0F259210ED;
        Sun, 20 Mar 2022 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647770101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/bur4lxFGZc+G/WNjNC2jYVrWDirYw1CVVqjtcV8r0=;
        b=LqfcHUB//2WgWY0U6AaBdmB152OR7A9JvA2TF3WABt+kOl419jgiN772NC3Eac4AT7mKRX
        VTyBXtfqK+Z4vkrccAhbNzxWrpeg9NN7PpGPHAYcP2JWPY8RBz/HKAebbIw/F8dUfs7T99
        gzNKijfPmxEEcfBJ7VMaGiP5bUxBKEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647770101;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/bur4lxFGZc+G/WNjNC2jYVrWDirYw1CVVqjtcV8r0=;
        b=BdA8h7lWSUgdlJ1eHjAwLFH97hlnxWYXHawHeOxJA5uiLKt0RUY4nVFZFtKOUoAWk45UD0
        VQG+LvV5zEDsEQCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5F7B713419;
        Sun, 20 Mar 2022 09:54:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vq1hAfP5NmIxNQAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 20 Mar 2022 09:54:59 +0000
Message-ID: <51ee6419-9ae4-04a5-1a69-e3fd1b9f0d04@suse.de>
Date:   Sun, 20 Mar 2022 17:54:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 1/4] mdadm: Respect config file location in man
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
 <20220318082607.675665-2-lukasz.florczak@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220318082607.675665-2-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/18/22 4:26 PM, Lukasz Florczak wrote:
> Default config file location could differ depending on OS (e.g. Debian family).
> This patch takes default config file into consideration when creating mdadm.man
> file as well as mdadm.conf.man.
>
> Rename mdadm.conf.5 to mdadm.conf.5.in. Now mdadm.conf.5 is generated automatically.
>
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>


I test and verify the change under openSUSE.


Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


> ---
>   .gitignore                      |  1 +
>   Makefile                        |  7 ++++++-
>   mdadm.8.in                      | 16 ++++++++--------
>   mdadm.conf.5 => mdadm.conf.5.in |  2 +-
>   4 files changed, 16 insertions(+), 10 deletions(-)
>   rename mdadm.conf.5 => mdadm.conf.5.in (99%)
>
> diff --git a/.gitignore b/.gitignore
> index 217fe76d..8d791c6f 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -3,6 +3,7 @@
>   /*-stamp
>   /mdadm
>   /mdadm.8
> +/mdadm.conf.5
>   /mdadm.udeb
>   /mdassemble
>   /mdmon
> diff --git a/Makefile b/Makefile
> index 2a51d813..bf126033 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -227,7 +227,12 @@ raid6check : raid6check.o mdadm.h $(CHECK_OBJS)
>   
>   mdadm.8 : mdadm.8.in
>   	sed -e 's/{DEFAULT_METADATA}/$(DEFAULT_METADATA)/g' \
> -	-e 's,{MAP_PATH},$(MAP_PATH),g'  mdadm.8.in > mdadm.8
> +	-e 's,{MAP_PATH},$(MAP_PATH),g' -e 's,{CONFFILE},$(CONFFILE),g' \
> +	-e 's,{CONFFILE2},$(CONFFILE2),g'  mdadm.8.in > mdadm.8
> +
> +mdadm.conf.5 : mdadm.conf.5.in
> +	sed -e 's,{CONFFILE},$(CONFFILE),g' \
> +	-e 's,{CONFFILE2},$(CONFFILE2),g'  mdadm.conf.5.in > mdadm.conf.5
>   
>   mdadm.man : mdadm.8
>   	man -l mdadm.8 > mdadm.man
> diff --git a/mdadm.8.in b/mdadm.8.in
> index be902dba..d41b3ca7 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -267,13 +267,13 @@ the exact meaning of this option in different contexts.
>   .TP
>   .BR \-c ", " \-\-config=
>   Specify the config file or directory.  Default is to use
> -.B /etc/mdadm.conf
> +.B {CONFFILE}
>   and
> -.BR /etc/mdadm.conf.d ,
> +.BR {CONFFILE}.d ,
>   or if those are missing then
> -.B /etc/mdadm/mdadm.conf
> +.B {CONFFILE2}
>   and
> -.BR /etc/mdadm/mdadm.conf.d .
> +.BR {CONFFILE2}.d .
>   If the config file given is
>   .B "partitions"
>   then nothing will be read, but
> @@ -2009,9 +2009,9 @@ The config file is only used if explicitly named with
>   or requested with (a possibly implicit)
>   .BR \-\-scan .
>   In the later case,
> -.B /etc/mdadm.conf
> +.B {CONFFILE}
>   or
> -.B /etc/mdadm/mdadm.conf
> +.B {CONFFILE2}
>   is used.
>   
>   If
> @@ -3339,7 +3339,7 @@ uses this to find arrays when
>   is given in Misc mode, and to monitor array reconstruction
>   on Monitor mode.
>   
> -.SS /etc/mdadm.conf
> +.SS {CONFFILE} (or {CONFFILE2})
>   
>   The config file lists which devices may be scanned to see if
>   they contain MD super block, and gives identifying information
> @@ -3347,7 +3347,7 @@ they contain MD super block, and gives identifying information
>   .BR mdadm.conf (5)
>   for more details.
>   
> -.SS /etc/mdadm.conf.d
> +.SS {CONFFILE}.d (or {CONFFILE2}.d)
>   
>   A directory containing configuration files which are read in lexical
>   order.
> diff --git a/mdadm.conf.5 b/mdadm.conf.5.in
> similarity index 99%
> rename from mdadm.conf.5
> rename to mdadm.conf.5.in
> index 74a21c5f..83edd008 100644
> --- a/mdadm.conf.5
> +++ b/mdadm.conf.5.in
> @@ -8,7 +8,7 @@
>   .SH NAME
>   mdadm.conf \- configuration for management of Software RAID with mdadm
>   .SH SYNOPSIS
> -/etc/mdadm.conf
> +{CONFFILE}
>   .SH DESCRIPTION
>   .PP
>   .I mdadm


