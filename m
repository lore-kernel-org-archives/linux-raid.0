Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD63C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 26 Mar 2022 18:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiCZSD4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 26 Mar 2022 14:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiCZSDz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 26 Mar 2022 14:03:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D15139CD5
        for <linux-raid@vger.kernel.org>; Sat, 26 Mar 2022 11:02:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e5so11314257pls.4
        for <linux-raid@vger.kernel.org>; Sat, 26 Mar 2022 11:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=niftyegg-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eQX42V6uV8mJDXWMPmX4Tsi0G5clbk+WRMk1xs5SL24=;
        b=MAUb5fwMHtVuYoo0NMJU9W80A+zOUXRgzgeOWwaq53/Z+RIhmZm+5pl/iT01CV59Qi
         X/tiNpg96gpJA6bKjx6jRozdgHfoMiG9ZmoGIsa8Jqqvb+8cG/zIeeyJT/U79afxFXpl
         BRJDrzeC4d/x6tztEVyWkY2mpibXCAzfMx07+Xe2RWsmWDMKUzg0hXPgg3qLWmbR8uMx
         x7CBHj58rwFK1CVNoGjFNOuMWGG5xi9Y9pZ93rrd/8mpAhBXk6Nf5xmQy68DUu4XUO/+
         CCrNx/7xAob8WCr47gN2SE//kMyjuBR7KtYBDmNmuIykmwM6Kk2O2tFICItfjYeWibXB
         ZA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eQX42V6uV8mJDXWMPmX4Tsi0G5clbk+WRMk1xs5SL24=;
        b=bJRquv8pT1VZA7pe8zH35QNfDPlmv2BoN1hYYRQX85/jBHSwSYWqW0uXMEOGvUK52h
         NywFRcEZptPRxIjZnU12qgk7vYHvK7zAlENBnsny11S/BW80QNXT31t+7Ee5UgXkoFAk
         1JnXCTKLxaiM2vTc89NM2EdbNR4xghzkGL9HWvHTCTS5s/IOuyrGFQqMGJSAM+DSIENI
         H9rTOC8vtBRqDrxzW8oWG/QQtfFD21aNwIMiv3w+wUWn3m/2oxxrW+3uUSZLBZJ73rB3
         zTathFai+NuFBbNdhzEwDV7ByXKWSn5V6ygfd/9MUsQ4kDrmzFpYh1XnAt6w65XwNR48
         hBgA==
X-Gm-Message-State: AOAM533czrsItGIsADMcTGE8H7nivh0gv1bklBCu3O+kdJBbeNX6jen0
        DHm7YwsDhQwbMeLeINHernOhKL0O6PZkSoQAKWqB2haX0AmwIQ==
X-Google-Smtp-Source: ABdhPJyBkClH6El8dwQhWeJLHHjdUszHr60o+eqe8rjiNrJ/G6qcSUVCn0bezj9jqzM5+JMnbgtRqaHCQa0osEvVoDw=
X-Received: by 2002:a17:902:e84b:b0:154:6222:98ad with SMTP id
 t11-20020a170902e84b00b00154622298admr18278341plg.26.1648317737011; Sat, 26
 Mar 2022 11:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220318030855.GV3131742@merlins.org>
In-Reply-To: <20220318030855.GV3131742@merlins.org>
From:   Tom Mitchell <mitch@niftyegg.com>
Date:   Sat, 26 Mar 2022 11:01:40 -0700
Message-ID: <CAAMy4UQWbYMfHa--vdWr8=+P=B20jiBVthZgUxsEb=8B1uYVgA@mail.gmail.com>
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
To:     Marc MERLIN <marc@merlins.org>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Mar 17, 2022 at 8:41 PM Marc MERLIN <marc@merlins.org> wrote:
>
> old drive:
...
>    8      128 5860522584 sdi
>    8      129 5860521543 sdi1
...
> new drive:
> Device Model:     ST6000VN001-2BB186
>    8      160 5860522580 sdk
>    8      161 5860521536 sdk1
>
> New drive is 4 sectors shorter, so I assume
...

The one option I did not see is resizing the filesystem (smaller) to
make an easy match.

In this case there is a second new disk big enough to back up all the
data so that is
the first task.

Shrinking a filesystem (resize2fs) does have some risks so backup first.

It is sort of nice to leave modest unused space when setting up a new disk.

Also back up to the new disk formatted correctly then invert the question and
add the old disk with matched size partitions to mirror to.

It all depends on the backup strategy. Clonezilla?


-- 

          T o m    M i t c h e l l  (on NiftyEgg[.]com )
