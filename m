Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7578C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jan 2022 13:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbiASNWd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jan 2022 08:22:33 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17072 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354783AbiASNW0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jan 2022 08:22:26 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1642598538; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=LUL1K2hGxdq+BshU3mZcnXxBSxKY62/km8ZIxIxu8Z3G2bGeOzoLqO1/bl/v3yAUadeUQceDEIREAnPx90MfbuEexS+E8/boJAyzEFq66OFBmITdx8SE680SM5OIvwTEij2l2q8lQJ+UyDq9P8NFMvfa+iA3m6eeE8rAtQR7boE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1642598538; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=wuaVoITNm9ZgHjsTOgHLWCCm68EQEEtTINFPQ7MSqnY=; 
        b=PRqp009lggmrF0PLcdjBpItGAnDCqhz1sM+XcdUz04HXHtBIatNvadmd2I3rW4JT8h4myNTMQPQkeaCLzOYyCqXeaBkGRFC9fb/XviEhVnwSk0Cj8RaxAqcqr4orG+sw/zVOyA0rPm3uKblX2gA5TpwNirTTReXT6ylDilIMFVM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1642598536571136.285935625344; Wed, 19 Jan 2022 14:22:16 +0100 (CET)
Message-ID: <2263d913-f062-9ae0-9830-7c628e5eaeb7@trained-monkey.org>
Date:   Wed, 19 Jan 2022 08:22:14 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] udev: adapt rules to systemd v247
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20220114154433.7386-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220114154433.7386-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/14/22 10:44, Mariusz Tkaczyk wrote:
> New events have been added in kernel 4.14 ("bind" and "unbind").
> Systemd maintainer suggests to modify "add|change" branches.
> This patches implements their suggestions. There is no issue yet because
> new event types are not used in md.
> 
> Please see systemd announcement for details[1].
> 
> [1] https://lists.freedesktop.org/archives/systemd-devel/2020-November/045646.html
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Hi Mariusz,

It looks fine to me, but it does raise the question how does this change
affect anyone building mdadm running an older systemd since you're
removing most of the add|change triggers in this patch?

Thanks,
Jes

> ---
>  udev-md-raid-arrays.rules        | 2 +-
>  udev-md-raid-assembly.rules      | 5 +++--
>  udev-md-raid-safe-timeouts.rules | 2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/udev-md-raid-arrays.rules b/udev-md-raid-arrays.rules
> index 13c9076e..2967ace1 100644
> --- a/udev-md-raid-arrays.rules
> +++ b/udev-md-raid-arrays.rules
> @@ -3,7 +3,7 @@
>  SUBSYSTEM!="block", GOTO="md_end"
>  
>  # handle md arrays
> -ACTION!="add|change", GOTO="md_end"
> +ACTION=="remove", GOTO="md_end"
>  KERNEL!="md*", GOTO="md_end"
>  
>  # partitions have no md/{array_state,metadata_version}, but should not
> diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
> index d668cddd..39b4344b 100644
> --- a/udev-md-raid-assembly.rules
> +++ b/udev-md-raid-assembly.rules
> @@ -30,8 +30,9 @@ LABEL="md_inc"
>  
>  # remember you can limit what gets auto/incrementally assembled by
>  # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
> -ACTION=="add|change", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
> -ACTION=="add|change", ENV{MD_STARTED}=="*unsafe*", ENV{MD_FOREIGN}=="no", ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"
> +ACTION!="remove", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
> +ACTION!="remove", ENV{MD_STARTED}=="*unsafe*", ENV{MD_FOREIGN}=="no", ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"
> +
>  ACTION=="remove", ENV{ID_PATH}=="?*", RUN+="BINDIR/mdadm -If $name --path $env{ID_PATH}"
>  ACTION=="remove", ENV{ID_PATH}!="?*", RUN+="BINDIR/mdadm -If $name"
>  
> diff --git a/udev-md-raid-safe-timeouts.rules b/udev-md-raid-safe-timeouts.rules
> index 12bdcaa8..2e185cee 100644
> --- a/udev-md-raid-safe-timeouts.rules
> +++ b/udev-md-raid-safe-timeouts.rules
> @@ -50,7 +50,7 @@ ENV{DEVTYPE}!="partition", GOTO="md_timeouts_end"
>  
>  IMPORT{program}="/sbin/mdadm --examine --export $devnode"
>  
> -ACTION=="add|change", \
> +ACTION!="remove", \
>    ENV{ID_FS_TYPE}=="linux_raid_member", \
>    ENV{MD_LEVEL}=="raid[1-9]*", \
>    TEST=="/sys/block/$parent/device/timeout", \
> 

