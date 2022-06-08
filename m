Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94069C43334
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 22:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiFHW5l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 18:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbiFHW5g (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 18:57:36 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3BD996B9
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 15:57:35 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id z15so7432368uad.7
        for <linux-raid@vger.kernel.org>; Wed, 08 Jun 2022 15:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EbOhYTV+SofwDMG1FkSyM/ft1UFP+c8h6nzrLQ6X8rQ=;
        b=BpFAcTmBgj00NvfY8thTepzn6R1Tr2pVQ/xR40xjj7SoRpAd9zf3vNNLc5H8UREsik
         joybygMUe7Cumh5oU7Z8kjngDFxDwXgFZA8+6qDW8r8bRaZohoyaaF/1PG41rABkIU5C
         Ex+xt8qHKOtTppoCQKql0VrylKpixbvAUJJlRw1epeO2DATX43DwgkqK6bWArldD8td1
         Bsey6e+Lmv8p7oC54dqgIxRedH+ZrnAoLLLWuYXNXHML6gcq/Ms4mOgRQXdQKGqgjrjz
         IZfU7lRibnn3/DLh8Mzc4zka7Q7Dz+luv7n6GW+2YmoxitOntUE291R+KI+0hKFx1DAj
         RnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EbOhYTV+SofwDMG1FkSyM/ft1UFP+c8h6nzrLQ6X8rQ=;
        b=Nmd/JLkmw+4Wv/6Q/E54SYDGxBfRpV1Gvt9uepLCMGHT0NfgUy80z/Yzx7KfprK6mQ
         1fOnLlF3Kp7J8VkUi5G+yGJKnGjtKKLwDf6cQxZG1NMC5D+D2lCFIhKxnHEUAFoJd47w
         9DvVPN/GD/2BE5R/IsWMpWTMXvbJc+6Vq0AbCOs030piCOHkeRLEgT9V2E+G96+QXDSt
         JvmuVwv0dJXiCB4RA7/MMqpKPSGbKk1tXCJ72sV4Xey1sW2UQx5BVgcd4WSFlwH7MdSq
         +izqPwphCdx5JXB39BjOeZ4KX5GmjEGlVc/ac61lTJ4Tvx6yJzMn9U3mD1kAlQBtv8wU
         IGSg==
X-Gm-Message-State: AOAM533pf1f0ERjkg05jL6OfEmpcCYIKNVDI4MaP8EN7mMsH6BShE9X+
        cfkptm+x+w8vaxocTCZ7BJbyCHc3j4jJ4EcIoqUTsj4gQ8o=
X-Google-Smtp-Source: ABdhPJw3c8Lx87CYfgbbMuyQkcOG/a2yLTQ6s3zuTkkcjxvD7oLAfZkjXVh3OGsuVL2Xl2qML6nxXesG8XKStO3QSwE=
X-Received: by 2002:ab0:3394:0:b0:371:ffc:8a4b with SMTP id
 y20-20020ab03394000000b003710ffc8a4bmr20744201uap.79.1654729055011; Wed, 08
 Jun 2022 15:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <0fa973c1-2961-4f8f-99fa-b427a5c694fd@www.fastmail.com>
In-Reply-To: <0fa973c1-2961-4f8f-99fa-b427a5c694fd@www.fastmail.com>
From:   o1bigtenor <o1bigtenor@gmail.com>
Date:   Wed, 8 Jun 2022 17:56:59 -0500
Message-ID: <CAPpdf5-wEfpHnteLAG-EHD-we+b+0=KB7RcD=U9dw6K-_3f48w@mail.gmail.com>
Subject: Re: MD Array Unexpected Kernel Hang
To:     alan@braithwaite.dev
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 8, 2022 at 5:22 PM Alan Braithwaite <alan@braithwaite.dev> wrote:
>
Just someone learning who asked questions in the past here
>
> Please let me know if there's any more information I can provide.
>

smartmontools is very likely something that will give some more
information that (likely) will be asked for.
If not previous installed you might want to get and then look at
what it says about each drive. Often said information is asked
for when the low down and dirty work gets a happening.

HTH
