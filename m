Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F72CC433F5
	for <linux-raid@archiver.kernel.org>; Sun, 20 Mar 2022 14:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbiCTOzn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 20 Mar 2022 10:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiCTOzk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 20 Mar 2022 10:55:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6311D63CA
        for <linux-raid@vger.kernel.org>; Sun, 20 Mar 2022 07:54:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 079D6210E0;
        Sun, 20 Mar 2022 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647788055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EyNj30Fn9vSmg7NxkzkmgVVxunu+znSdEDkb36/JsMs=;
        b=HmxbczaLvddMI1zeyZJ/HYZYxGQ17+xt3MQNk/ZHG6klzXyYD/m4ulfsGi7bMgDrQja5jK
        wnCJfxb8XfnvS+23r9YlD0Ty1T2615gZTesHzuaCsxvUSbbU3vlybnC0Yssbz57jFhD67p
        xKSkCNPV4AHSrPf+3NekWAYwZJX1Zz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647788055;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EyNj30Fn9vSmg7NxkzkmgVVxunu+znSdEDkb36/JsMs=;
        b=8oDVJUst9V9HV6XgYG8i8r725NF5d3a4MBgdfYmVCUPi8Q6sIH6abZxqRTF4NEX7JT/T4A
        hea1vH1GPHYgUpCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 49C5913479;
        Sun, 20 Mar 2022 14:54:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FjsjBhVAN2LWCAAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 20 Mar 2022 14:54:13 +0000
Message-ID: <9b759431-d69b-0634-93bd-774718477717@suse.de>
Date:   Sun, 20 Mar 2022 22:54:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 3/4] mdadm: Update config man regarding default files and
 multi-keyword behavior
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
 <20220318082607.675665-4-lukasz.florczak@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220318082607.675665-4-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/18/22 4:26 PM, Lukasz Florczak wrote:
> Simplify default and alternative config file and directory location references
> from mdadm(8) as references to mdadm.conf(5). Add FILE section in config man
> and explain order and conditions in which default and alternative config files
> and directories are used.
>
> Update config man behavior regarding parsing order when multiple keywords/config
> files are involved.
>
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>


Tested and verified on openSUSE,

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


> ---
>   mdadm.8.in      | 30 +++++++++--------------
>   mdadm.conf.5.in | 65 ++++++++++++++++++++++++++++++++++++++++++++-----
>   2 files changed, 71 insertions(+), 24 deletions(-)
>
> diff --git a/mdadm.8.in b/mdadm.8.in
> index d41b3ca7..d6af73b7 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -266,14 +266,11 @@ the exact meaning of this option in different contexts.
>   
>   .TP
>   .BR \-c ", " \-\-config=
> -Specify the config file or directory.  Default is to use
> -.B {CONFFILE}
> -and
> -.BR {CONFFILE}.d ,
> -or if those are missing then
> -.B {CONFFILE2}
> -and
> -.BR {CONFFILE2}.d .
> +Specify the config file or directory.  If not specified, default config file
> +and default conf.d directory will be used.  See
> +.BR mdadm.conf (5)
> +for more details.
> +
>   If the config file given is
>   .B "partitions"
>   then nothing will be read, but
> @@ -2008,11 +2005,9 @@ The config file is only used if explicitly named with
>   .B \-\-config
>   or requested with (a possibly implicit)
>   .BR \-\-scan .
> -In the later case,
> -.B {CONFFILE}
> -or
> -.B {CONFFILE2}
> -is used.
> +In the later case, default config file is used.  See
> +.BR mdadm.conf (5)
> +for more details.
>   
>   If
>   .B \-\-scan
> @@ -3341,16 +3336,15 @@ on Monitor mode.
>   
>   .SS {CONFFILE} (or {CONFFILE2})
>   
> -The config file lists which devices may be scanned to see if
> -they contain MD super block, and gives identifying information
> -(e.g. UUID) about known MD arrays.  See
> +Default config file.  See
>   .BR mdadm.conf (5)
>   for more details.
>   
>   .SS {CONFFILE}.d (or {CONFFILE2}.d)
>   
> -A directory containing configuration files which are read in lexical
> -order.
> +Default directory containing configuration files.  See
> +.BR mdadm.conf (5)
> +for more details.
>   
>   .SS {MAP_PATH}
>   When
> diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
> index 83edd008..dd331a6a 100644
> --- a/mdadm.conf.5.in
> +++ b/mdadm.conf.5.in
> @@ -88,7 +88,8 @@ but only the major and minor device numbers.  It scans
>   .I /dev
>   to find the name that matches the numbers.
>   
> -If no DEVICE line is present, then "DEVICE partitions containers" is assumed.
> +If no DEVICE line is present in any config file,
> +then "DEVICE partitions containers" is assumed.
>   
>   For example:
>   .IP
> @@ -272,6 +273,10 @@ catenated with spaces to form the address.
>   Note that this value cannot be set via the
>   .I mdadm
>   commandline.  It is only settable via the config file.
> +There should only be one
> +.B MAILADDR
> +line and it should have only one address.  Any subsequent addresses
> +are silently ignored.
>   
>   .TP
>   .B PROGRAM
> @@ -286,7 +291,8 @@ device.
>   
>   There should only be one
>   .B program
> -line and it should be give only one program.
> +line and it should be given only one program.  Any subsequent programs
> +are silently ignored.
>   
>   
>   .TP
> @@ -295,7 +301,14 @@ The
>   .B create
>   line gives default values to be used when creating arrays, new members
>   of arrays, and device entries for arrays.
> -These include:
> +
> +There should only be one
> +.B create
> +line.  Any subsequent lines will override the previous settings.
> +
> +Keywords used in the
> +.I CREATE
> +line and supported values are:
>   
>   .RS 4
>   .TP
> @@ -475,8 +488,8 @@ The known metadata types are
>   
>   .B AUTO
>   should be given at most once.  Subsequent lines are silently ignored.
> -Thus an earlier config file in a config directory will over-ride
> -the setting in a later config file.
> +Thus a later config file in a config directory will not overwrite
> +the setting in an earlier config file.
>   
>   .TP
>   .B POLICY
> @@ -594,6 +607,7 @@ The
>   line lists custom values of MD device's sysfs attributes which will be
>   stored in sysfs after the array is assembled. Multiple lines are allowed and each
>   line has to contain the uuid or the name of the device to which it relates.
> +Lines are applied in reverse order.
>   .RS 4
>   .TP
>   .B uuid=
> @@ -621,7 +635,46 @@ is running in
>   .B \-\-monitor
>   mode.
>   .B \-d/\-\-delay
> -command line argument takes precedence over the config file
> +command line argument takes precedence over the config file.
> +
> +If multiple
> +.B MINITORDELAY
> +lines are provided, only first non-zero value is considered.
> +
> +.SH FILES
> +
> +.SS {CONFFILE}
> +
> +The default config file location, used when
> +.I mdadm
> +is running without --config option.
> +
> +.SS {CONFFILE}.d
> +
> +The default directory with config files. Used when
> +.I mdadm
> +is running without --config option, after successful reading of the
> +.B {CONFFILE}
> +default config file. Files in that directory
> +are read in lexical order.
> +
> +
> +.SS {CONFFILE2}
> +
> +Alternative config file that is read, when
> +.I mdadm
> +is running without --config option and the
> +.B {CONFFILE}
> +default config file was not opened successfully.
> +
> +.SS {CONFFILE2}.d
> +
> +The alternative directory with config files. Used when
> +.I mdadm
> +is runninng without --config option, after reading the
> +.B {CONFFILE2}
> +alternative config file whether it was successful or not. Files in
> +that directory are read in lexical order.
>   
>   .SH EXAMPLE
>   DEVICE /dev/sd[bcdjkl]1


