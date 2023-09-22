Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E58CE7A86
	for <linux-raid@archiver.kernel.org>; Fri, 22 Sep 2023 21:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjIVVFL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Sep 2023 17:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjIVVFJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Sep 2023 17:05:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F702E8
        for <linux-raid@vger.kernel.org>; Fri, 22 Sep 2023 14:05:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF16DC433C9
        for <linux-raid@vger.kernel.org>; Fri, 22 Sep 2023 21:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695416704;
        bh=8dn9RKMIszozNmZV+kxaV7QrkDMB/kGYg+OrG+RpinQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u32b9td6Uu3ubb4//2QBynAABwbK2hF2cD2M4RMK351eKhScKmDqK951mkeWtxH6I
         e+2OEGtzraEPnRnclBJF6dEDh+6qNm36divZgigHbuZ7vS4AC6IG/tiqs7vSLtVL8p
         Pu5YHt2+UJQkbf2WnOUfUyuqltpzPB8T0vuXSGblm3ObEM3BESvcaa6jNReYDpsw+D
         CR/i3Np5bzU1NbR1O31Z+JV71iMZBeiNxHX+4q7OyO2jR69lnx4Jq6KRnz4JTCz/Y8
         X/5kxY+djILYDWgC3i6QGTPtVC+8kz3d7yARIrEhXBS+jcVjskZ9Vz0zRAbznOLtoA
         4GyBWPY6ZRYdA==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-503012f4e71so5277033e87.0
        for <linux-raid@vger.kernel.org>; Fri, 22 Sep 2023 14:05:03 -0700 (PDT)
X-Gm-Message-State: AOJu0YzllO2ooG9sTHUql2mlLxMOUMGmcL+zQSjLsl1c68AXSbuwnF/v
        +4Lj9BMYDMazH1m1/txWUA+gCdr9Ojee04t4zOI=
X-Google-Smtp-Source: AGHT+IE5KXFGTVr9OQYaN/LCVoLYhxAmOwZ2URVDpj5TKtvGKMnEes9HfVcyWIhZL7H8NgLXs9l95KOamvZq28snrxw=
X-Received: by 2002:a19:674b:0:b0:500:7aba:4d07 with SMTP id
 e11-20020a19674b000000b005007aba4d07mr210674lfj.22.1695416702137; Fri, 22 Sep
 2023 14:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230913085502.17856-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20230913085502.17856-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 22 Sep 2023 14:04:49 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6qk=XbbOxtzr0FGVuZHLr4kbzODkTSPjcBmK4YYGWWKw@mail.gmail.com>
Message-ID: <CAPhsuW6qk=XbbOxtzr0FGVuZHLr4kbzODkTSPjcBmK4YYGWWKw@mail.gmail.com>
Subject: Re: [PATCH] md: do not require mddev_lock() for all options
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

Sorry for the late reply.

On Wed, Sep 13, 2023 at 1:55=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> We don't need to lock device to reject not supported request
> in array_state_store().
> Main motivation is to make a room for action does not require lock yet,
> like prepare to stop (see md_ioctl()).

I made some changes to the commit log:

    md: do not require mddev_lock() for all options

    We don't need to lock device to reject not supported request
    in array_state_store().
    Main motivation is to make a room for action does not require lock yet,
    like prepare to stop (see md_ioctl()).

But I am not sure what you meant by "make a room for action does not
require lock yet". Could you please explain?

Otherwise, the code looks reasonable to me.

Thanks,
Song
