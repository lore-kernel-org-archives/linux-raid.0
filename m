Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988ADC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 06:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbiEJGs7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 02:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237291AbiEJGs5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 02:48:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04292AC0F0
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 23:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A12561807
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 06:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B97C385C8
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 06:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652165095;
        bh=RxkZc3yzWYnEV7Jls3hutI16ajMUQR599oRWdw/yA0M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dGTsVmvTo2BGdhV3vnrHFFBFwMaOx7UzJAhNMswzMQw2Abyd7Fw/WxysT4Xp4Qpd5
         dpI2v02Qle8THT3YSgZo9B8MRsOCUN8WsfTwP5DmSuCSj4sxT6Yy1REcTTTNYHFIkt
         WSqE3A/GPOz8ijdDYa0iaybcIFiXIm59mWbde2UHg1Rtj9XRWFXSUmaDJ81YiknsP4
         o+VwcrHLKH0UAboJakDiwS8DmMpAsFqkKrRrZ4pI7Mqk7Ljz2Relt8Ygf9FRQZdvSU
         MuwwmfttCsZom/gZJsHBh/WbN6xgNq49BDHcJUYCACgH+03G+gWGFhAcFyqJUZhf/O
         RGAxDQXZHSpmg==
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-2ebf4b91212so168624247b3.8
        for <linux-raid@vger.kernel.org>; Mon, 09 May 2022 23:44:55 -0700 (PDT)
X-Gm-Message-State: AOAM531qlge6niBSmDTHfbEcNYI5zlqBcTvK58t1Isr5rn3CqLkFAz+R
        elvyHu9e800yFYgr76oMwzIOQjEE2l0VBiKqyIY=
X-Google-Smtp-Source: ABdhPJxi2+K++rMRdUbBMLzlTRUjph1UkBHjl3Zou4AucFI7JzgDhOLPKeaAdP3ggdxaoZbtUo8Rv6GzFXV2TPDc7ms=
X-Received: by 2002:a81:b8d:0:b0:2f7:cf33:e840 with SMTP id
 135-20020a810b8d000000b002f7cf33e840mr17689844ywl.73.1652165094663; Mon, 09
 May 2022 23:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev> <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
In-Reply-To: <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Mon, 9 May 2022 23:44:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
Message-ID: <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 9, 2022 at 1:09 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 5/9/22 2:37 PM, Song Liu wrote:
> > On Fri, May 6, 2022 at 4:37 AM Guoqing Jiang<guoqing.jiang@linux.dev>  wrote:
> >> From: Guoqing Jiang<guoqing.jiang@cloud.ionos.com>
> >>
> >> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> >> doesn't reconfigure array.
> >>
> >> And it could cause deadlock problem for raid5 as follows:
> >>
> >> 1. process A tried to reap sync thread with reconfig_mutex held after echo
> >>     idle to sync_action.
> >> 2. raid5 sync thread was blocked if there were too many active stripes.
> >> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
> >>     which causes the number of active stripes can't be decreased.
> >> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
> >>     to hold reconfig_mutex.
> >>
> >> More details in the link:
> >> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
> >>
> >> Let's call unregister thread between mddev_unlock and mddev_lock_nointr
> >> (thanks for the report from kernel test robot<lkp@intel.com>) if the
> >> reconfig_mutex is held, and mddev_is_locked is introduced accordingly.
> > mddev_is_locked() feels really hacky to me. It cannot tell whether
> > mddev is locked
> > by current thread. So technically, we can unlock reconfigure_mutex for
> > other thread
> > by accident, no?
>
> I can switch back to V2 if you think that is the correct way to do though no
> one comment about the change in dm-raid.

I guess v2 is the best at the moment. I pushed a slightly modified v2 to
md-next.

Thanks for working on this.
Song
