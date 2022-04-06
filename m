Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CB0C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 10:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242304AbiDFKIM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 06:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345694AbiDFKG6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 06:06:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C07A167D6
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 23:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649226932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rm5ZcYRG9yo1Jj2BdA6/avZk1CyKfinSMrTDramV4ec=;
        b=egeXnP1hYD9pENenRHMylEl7lLf8zVt6PeUtd5m2TvzNfYqXd2HQSOGGDW/HwENk7tMa2b
        CmcT4vbvNh+ey3xwoEHLG4K0pMNAtnT6rXaBsk4K0/9JKy6xWJnB0yb3pK15ll8OyncVvI
        ONETh4EQfYE3MCFSxRbA/hd7XaUCzrc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-j-HBeg_mPoeOuD6Pod620g-1; Wed, 06 Apr 2022 02:35:31 -0400
X-MC-Unique: j-HBeg_mPoeOuD6Pod620g-1
Received: by mail-ej1-f72.google.com with SMTP id sd5-20020a1709076e0500b006e6e277d2b4so645002ejc.14
        for <linux-raid@vger.kernel.org>; Tue, 05 Apr 2022 23:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rm5ZcYRG9yo1Jj2BdA6/avZk1CyKfinSMrTDramV4ec=;
        b=10UHy/R2zzT9xir4g9Zo3xigEAkgR7xEvh1yFN1iO5IXZjrxXZMpPH8wgPRLv/lc+B
         F5e+dr9Z5O553Wc3FOnurq96jVnLHcFuD1MHLhrn7WQr4n51EEJKqGIX56fe5Z1UyA3t
         QdYkWQrX/NzJKBNGjKFkCMd7JjRwZZKMvmCpdYAsdBvCd42sjUdTYFVRISvrWLe9sAS7
         JlRkB6ebUpuIpL11YCm1WOwgXRGu+PytHP+IoNbnyyhXBOuXrwJStkQPVAeFN1QcmNhB
         O57BIPR8EpwSA3aFv/UtDAzFKPO/MNu/NMExQXv28HpwqRMbHpG7c/aP6IgMe2Iu34nv
         L5EQ==
X-Gm-Message-State: AOAM533ZJ6pVKAleDhXyHy1Zi5KZxMNFvJ+Lfu6IGoph+XpX9F5KCQkN
        wg0o1jYdLT5rl935hjx/J/r7OTTMUq5kae+DnsulGu5zAu7czB1OREJooqia9J6+rhuFmxxxQ6O
        f1Hl3eNTg+lhndZ/BTCwBj9bVGxj9en8/GiVLpg==
X-Received: by 2002:a17:907:d02:b0:6e0:4f1d:7ab1 with SMTP id gn2-20020a1709070d0200b006e04f1d7ab1mr6810601ejc.716.1649226929843;
        Tue, 05 Apr 2022 23:35:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdpv7VeUVoNDX0dsrhvNzzqQc60bqDcgPlfIZdV+awoCOlx5y5acJnndUmrhc5hpSPz/tSIBZWj8F01Mbcpk8=
X-Received: by 2002:a17:907:d02:b0:6e0:4f1d:7ab1 with SMTP id
 gn2-20020a1709070d0200b006e04f1d7ab1mr6810589ejc.716.1649226929634; Tue, 05
 Apr 2022 23:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220215133415.4138-1-colyli@suse.de>
In-Reply-To: <20220215133415.4138-1-colyli@suse.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 6 Apr 2022 14:36:13 +0800
Message-ID: <CALTww28aKNSAj9a7kyYxPEJgUMRA5f0DGjc=X-SrRY5c5p6jyQ@mail.gmail.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes

Could you merge this patch.

On Tue, Feb 15, 2022 at 9:34 PM Coly Li <colyli@suse.de> wrote:
>
> For mdadm's systemd configuration, current systemd KillMode is "none" in
> following service files,
> - mdadm-grow-continue@.service
> - mdmon@.service
>
> This "none" mode is strongly againsted by systemd developers (see man 5
> systemd.kill for "KillMode=" section), and is considering to remove in
> future systemd version.
>
> As systemd developer explained in disuccsion, the systemd kill process
> is,
> 1. send the signal specified by KillSignal= to the list of processes (if
>    any), TERM is the default
> 2. wait until either the target of process(es) exit or a timeout expires
> 3. if the timeout expires send the signal specified by FinalKillSignal=,
>    KILL is the default
>
> For "control-group", all remaining processes will receive the SIGTERM
> signal (by default) and if there are still processes after a period f
> time, they will get the SIGKILL signal.
>
> For "mixed", only the main process will receive the SIGTERM signal, and
> if there are still processes after a period of time, all remaining
> processes (including the main one) will receive the SIGKILL signal.
>
> From the above comment, currently KillMode=control-group is a proper
> kill mode. Since control-gropu is the default kill mode, the fix can be
> simply removing KillMode=none line from the service file, then the
> default mode will take effect.
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Benjamin Brunner <bbrunner@suse.com>
> Cc: Franck Bui <fbui@suse.de>
> Cc: Jes Sorensen <jes@trained-monkey.org>
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Xiao Ni <xni@redhat.com>
> ---
>  systemd/mdadm-grow-continue@.service | 1 -
>  systemd/mdmon@.service               | 1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-continue@.service
> index 5c667d2..9fdc8ec 100644
> --- a/systemd/mdadm-grow-continue@.service
> +++ b/systemd/mdadm-grow-continue@.service
> @@ -14,4 +14,3 @@ ExecStart=BINDIR/mdadm --grow --continue /dev/%I
>  StandardInput=null
>  StandardOutput=null
>  StandardError=null
> -KillMode=none
> diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
> index 85a3a7c..7753395 100644
> --- a/systemd/mdmon@.service
> +++ b/systemd/mdmon@.service
> @@ -25,4 +25,3 @@ Type=forking
>  # it out) and systemd will remove it when transitioning from
>  # initramfs to rootfs.
>  #PIDFile=/run/mdadm/%I.pid
> -KillMode=none
> --
> 2.31.1
>

Acked-by: Xiao Ni <xni@redhat.com>

