Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F73C61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 06:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCFGqK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 01:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCFGqJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 01:46:09 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5756E1CAE5
        for <linux-raid@vger.kernel.org>; Sun,  5 Mar 2023 22:46:06 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aeb9d.dynamic.kabel-deutschland.de [95.90.235.157])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DAA0C61CC457B;
        Mon,  6 Mar 2023 07:46:02 +0100 (CET)
Message-ID: <102971f0-d8f4-6309-ea11-198490b1e7e5@molgen.mpg.de>
Date:   Mon, 6 Mar 2023 07:45:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5/6] mdmon: Remove need for KillMode=none
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>
 <167745678753.16565.4556106790376379653.stgit@noble.brown>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <167745678753.16565.4556106790376379653.stgit@noble.brown>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Neil,


Thank you for your patch. Two minor comments below.

Am 27.02.23 um 01:13 schrieb NeilBrown:
> mdmon needs to keep running during the switchroot out of (at boot) and
> then back into (at shutdown) the initrd.  It runs until a new mdmon
> takes over.
> 
> Killmode=none is used to achieve this, with the help of --offroot which
> sets argv[0][0] to '@' which systemd understands.
> 
> This is needed because mdmon is currently run in system-mdmon.slice
> which conflicts with shutdown.target so without Killmode=none mdmon
> would get killed early in shutdown when system.mdmon.slice is removed.
> 
> As described in systemd.service(5), this conflict which shutdown can be

Small typo: … conflict with shutdown …?

> resolved by explicitly requesting system.slice, which is a natural
> counterpart to DefaultDependencies=no.
> 
> So add that, and also add IgnoreOnIsolate=true to avoid another possible
> source of an early death.  With these we no longer need KillMode=none
> which the systemd developers have marked as "deprecated".
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>   systemd/mdmon@.service |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
> index 3502fadc3fc4..3ab908c45a3b 100644
> --- a/systemd/mdmon@.service
> +++ b/systemd/mdmon@.service
> @@ -10,6 +10,9 @@ Description=MD Metadata Monitor on /dev/%I
>   DefaultDependencies=no
>   Before=initrd-switch-root.target
>   Documentation=man:mdmon(8)
> +# allow this to keep running after switchroot, until a new
> +# instance is started

Below you “format” the comment as a sentence – starting with capital 
letter and using a dot/period at the end.

> +IgnoreOnIsolate=true
>   
>   [Service]
>   # The mdmon starting in the initramfs (with dracut at least)
> @@ -22,4 +25,6 @@ ExecStart=BINDIR/mdmon --foreground --offroot --takeover %I
>   # it out) and systemd will remove it when transitioning from
>   # initramfs to rootfs.
>   #PIDFile=/run/mdadm/%I.pid
> -KillMode=none
> +# The default slice is system-mdmon.slice which Conflicts
> +# with shutdown, causing mdmon to exit early.  So use system.slice.
> +Slice=system.slice


Kind regards,

Paul
