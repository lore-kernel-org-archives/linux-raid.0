Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20379C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 15 Mar 2022 12:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348373AbiCOMkp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Mar 2022 08:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348358AbiCOMko (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Mar 2022 08:40:44 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8303137E
        for <linux-raid@vger.kernel.org>; Tue, 15 Mar 2022 05:39:30 -0700 (PDT)
Received: from [192.168.0.7] (ip5f5ae8f9.dynamic.kabel-deutschland.de [95.90.232.249])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3695861EA1927;
        Tue, 15 Mar 2022 13:39:26 +0100 (CET)
Message-ID: <91ed523b-9518-1beb-039d-ab00b1bb0b44@molgen.mpg.de>
Date:   Tue, 15 Mar 2022 13:39:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 1/2] mdadm: Respect config file location in man.
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org, colyli@suse.de
References: <20220315085549.59693-1-lukasz.florczak@linux.intel.com>
 <20220315085549.59693-2-lukasz.florczak@linux.intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220315085549.59693-2-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Lukasz,


Thank you for your patches.

Am 15.03.22 um 09:55 schrieb Lukasz Florczak:

It’d be great if you removed the dot/period at the end of the git commit 
message summaries [1]. (Also in second patch.)

> Default config file location could differ depending on OS (e.g. Debian family).

What is it an Debian?

> This patch takes default config file into consideration when creating mdadm.man
> file as well as mdadm.conf.man.
> 
> Rename mdadm.conf.5 to mdadm.conf.5.in. Now mdadm.conf.5 is generated automatically.
> 
> Additionally update config help in ReadMe.c.
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> ---
>   .gitignore                      |  1 +
>   Makefile                        |  7 ++++++-
>   ReadMe.c                        | 11 ++++++-----
>   mdadm.8.in                      | 16 ++++++++--------
>   mdadm.conf.5 => mdadm.conf.5.in |  2 +-
>   5 files changed, 22 insertions(+), 15 deletions(-)
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
> diff --git a/ReadMe.c b/ReadMe.c
> index 81399765..b7357b97 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -613,7 +613,6 @@ char Help_incr[] =
>   ;
>   
>   char Help_config[] =
> -"The /etc/mdadm.conf config file:\n\n"
>   " The config file contains, apart from blank lines and comment lines that\n"
>   " start with a hash(#), array lines, device lines, and various\n"
>   " configuration lines.\n"
> @@ -636,10 +635,12 @@ char Help_config[] =
>   " than a device must match all of them to be considered.\n"
>   "\n"
>   " Other configuration lines include:\n"
> -"  mailaddr, mailfrom, program     used for --monitor mode\n"
> -"  create, auto                    used when creating device names in /dev\n"
> -"  homehost, policy, part-policy   used to guide policy in various\n"
> -"                                  situations\n"
> +"  mailaddr, mailfrom, program, monitordelay    used for --monitor mode\n"

Looks like an independent fix. Please separate into a separate commit.

> +"  create, auto                                 used when creating device names in /dev\n"
> +"  homehost, policy, part-policy                used to guide policy in various\n"
> +"                                               situations\n"
> +"\n"
> +"For more details see mdadm.conf(5).\n"
>   "\n"
>   ;
>   
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

The rest looks good.


Kind regards,

Paul


[1]: https://chris.beams.io/posts/git-commit/
