Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7D4CDB465
	for <linux-raid@archiver.kernel.org>; Mon, 16 Oct 2023 08:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjJPIOw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Oct 2023 04:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbjJPIOs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Oct 2023 04:14:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76376A2
        for <linux-raid@vger.kernel.org>; Mon, 16 Oct 2023 01:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697444041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6d++sD38iQKKHSeLwtvaZxw3lzKd9FUh1dqOfwyd/ac=;
        b=WQx4czH0PCEiR3g6fm2F1ugEnnfVwD2ISYbpEwtjvOaURGvdV3AvlkM/DRTyz4OVgVczX6
        gNw8i5s8vWVY4MJnA2Sm6TvNxPlnlAAA9nYJQv3XHruD7NVE56SMCcO4PX94AgDjR5kHN8
        RC4woRpGITnjyQYu/oaR6zxcvx7xIgg=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-BnHOorW1MLqOx1VRciXuKQ-1; Mon, 16 Oct 2023 04:14:00 -0400
X-MC-Unique: BnHOorW1MLqOx1VRciXuKQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-27d5ef03892so1717313a91.0
        for <linux-raid@vger.kernel.org>; Mon, 16 Oct 2023 01:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697444039; x=1698048839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6d++sD38iQKKHSeLwtvaZxw3lzKd9FUh1dqOfwyd/ac=;
        b=oChG9lE7vv/ryffy12/SWalUXd1G/rHAhpEGqRMiFtmlPfaLsXthCLaskLvL/CAKU1
         o0UTZbeTLcZP/Ul/aKNtyA/hqylWdBW67eeQ5yN2AvC+Yykymr1o+ecH9iYiDM92/mFu
         KHYAK/z7pXQBTtZHHWy4RE3H3ryN9TF3M8mKxB5w7Vk9hE8V5t9pB4PGK6r/wfxLVXI/
         FLptzbDhRPn02NzosUyUGzMCPJez4LQ4DxyskwXvfGapcqbp5/lrhgl0vYT/5k/oXv2R
         q7m0CW7AuGsKsagn6LQSYLYUF58mpAFuzzhLL7nWXUzBH8ktENEDfChzhhCDH0J2Nlfz
         uOBw==
X-Gm-Message-State: AOJu0YxeRALxUADqAx7uTOfScXR+kFfInsZPkKRYQazUNn2y5aeG9jmT
        yayVs8yebcR4/2aTcx7qZJAxL++g/sHr00IxMaQlwar2GI8Cqejq9ecLAOpQb+YpgbNEIMgXmyF
        O7RhH8AsrNvACJNkaR/bAD6tpgipOqCb94czCmg==
X-Received: by 2002:a17:90a:530f:b0:27c:ea44:928d with SMTP id x15-20020a17090a530f00b0027cea44928dmr17289026pjh.45.1697444039207;
        Mon, 16 Oct 2023 01:13:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFz0sD7fFgyvKkQwFEj1B6mkeKotsaP6svcm2aI8vhqRCjbi6TThbD3V6ohNUWMAedW27SeusMxU+eJRd3fub0=
X-Received: by 2002:a17:90a:530f:b0:27c:ea44:928d with SMTP id
 x15-20020a17090a530f00b0027cea44928dmr17289015pjh.45.1697444038912; Mon, 16
 Oct 2023 01:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20231011130522.78994-1-xni@redhat.com> <20231013113034.0000298a@linux.intel.com>
 <CALTww282t6UMePRPPmoxyxBpedbjWC=9ojjHQx8o8sJttnzvSA@mail.gmail.com>
 <20231013135935.00005679@linux.intel.com> <CALTww29C_kS9e9hxbz+GFWVvAci1CZSfHxWTigD3zCYdZghmYw@mail.gmail.com>
 <20231013154402.00003976@linux.intel.com> <645BDF69-0798-4CBB-B2FF-65B1AEF3A787@suse.de>
In-Reply-To: <645BDF69-0798-4CBB-B2FF-65B1AEF3A787@suse.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 16 Oct 2023 16:13:48 +0800
Message-ID: <CALTww2_4CCcB=6pB+REwhcNxpsfKb9Qh4aWTqroS9jU9K6MgGQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if
 sb->layout is set
To:     Coly Li <colyli@suse.de>
Cc:     jes@trained-monkey.org, linux-raid <linux-raid@vger.kernel.org>,
        NeilBrown <neilb@suse.de>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Oct 13, 2023 at 11:54=E2=80=AFPM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2023=E5=B9=B410=E6=9C=8813=E6=97=A5 21:44=EF=BC=8CMariusz Tkaczyk <mari=
usz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Fri, 13 Oct 2023 20:12:38 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> >
> >>>>> So, it forces the calculations made by Neil back but I think that w=
e can
> >>>>> simply compare dev_size and data_offset between members.
> >>>>
> >>>> We don't need to consider the compatibility anymore in future?
> >>>>
> >>> Not sure if I get your question correctly. This property is supported=
 now so
> >>> why we should? It is already there so we are safe to set it.
> >>
> >> I asked because you said we can remove the check in future. So I don't
> >> know why we don't need the check in future. The check here should be
> >> the kernel version check, right?
> >
> >
> > We are not supporting old kernels forever. At some point of time, we wo=
uld
> > decide that kernels older than 5.5 are no longer a valid case and then =
we will
> > free to remove verification. If we are not supporting something older t=
han the
> > version where it was added, we can assume that MD_RAID0_LAYOUT is alway=
s
> > available and we don't need to care anymore, right?
> >
> > Here a recent example:
> > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3Df8d2c=
4286a
>
> Just FYI, we still support Linux v4.12 based kernel for SLES12-SP5.
>
> Coly Li
>

Hi all

Thanks for the explanation.

Best Regards
Xiao

