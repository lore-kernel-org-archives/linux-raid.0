Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFFDC77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 02:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjE3CND (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 22:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjE3CNC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 22:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55986B7
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 19:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685412735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1K1aCzV0zRtiC7o8O2vY9aMsic4fx4f4rc0IMTdsQB4=;
        b=DRjHHFa1dRHJx+O3hU5AmCKs6pAJ71I8YZjrCQJQhTRXpB8Rot1OkCJmAuIPML1VMSDZRW
        N671vrhJSMPdcPsbDO+bNmNf6S7DR2jHsOmUaJihuqfs7UeUQeq72MuDS9YQNCdru0Y0ng
        0xVys5VR1dADCd/NERk4uLgC6Xd2UsA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-waETJhMrPHWOpF4c4r_BOw-1; Mon, 29 May 2023 22:12:09 -0400
X-MC-Unique: waETJhMrPHWOpF4c4r_BOw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-256563a2097so1215247a91.0
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 19:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685412728; x=1688004728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1K1aCzV0zRtiC7o8O2vY9aMsic4fx4f4rc0IMTdsQB4=;
        b=dpGiXIPdbPwc3Zi7F3r6nHGlJTcRALjzMUETH32ltUSlWeh6AEx1GCb+3uzFneurqF
         5Ibn8r0fGymXD3KHQq9hxDGPGvFihkg1mhetVp8QG3DWEetV5CAJHMTvbHRsbU+qmzJ2
         ug5frLjfbUZw1uym+PWKthKEfQFMgejOIWV+ogOuvjHPRtNwDva88oW6QJoMRjnM/bPA
         pwGpT9BGd2f8HpWVh6sg3IeDvez7bdQeMb1Stht4SEaJMofnAYQiwwo+3TxYucHBeSZ9
         JG8DF0m6gqBTelzTrZQuq2BOjL19AfO+ulptu3NmQ5SPc2PbZplZD2OOaEh8jL7acgDa
         aaVA==
X-Gm-Message-State: AC+VfDyUBxAz68qPXauM9oNGPMBDTVs5VRyhaU1xd3DUKbnj1uFo+fi/
        stC6/IbsS+MPdqoo0pdCiIr2p+I3TsgBKp6IMVuaRIREzhDkIIz6Mr+Ch6dyeP5ooQNC36wDB9U
        NIuofxF+JsTLWTARFI1W3BBabgpVpCavS347Zgw==
X-Received: by 2002:a17:902:b901:b0:1ac:6d4c:c265 with SMTP id bf1-20020a170902b90100b001ac6d4cc265mr972849plb.28.1685412728114;
        Mon, 29 May 2023 19:12:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Yo8YpNhM9angPlk1AynZl3bqOwxL1W6B11telsRxu+6LoeEzjSbAWkLmhJpPlNeaT3uXyiJ4UqYrzYBz8gno=
X-Received: by 2002:a17:902:b901:b0:1ac:6d4c:c265 with SMTP id
 bf1-20020a170902b90100b001ac6d4cc265mr972837plb.28.1685412727822; Mon, 29 May
 2023 19:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev> <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev> <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev> <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
 <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev> <CALTww2_vmryrM1V+Cr8FKj3TRv0qEGjYNzv6nStj=LnM8QKSuw@mail.gmail.com>
 <73b79a2d-95fe-dac0-9afc-8937d723ffdf@linux.dev> <495541d3-3165-6d4b-f662-3690139229e9@huaweicloud.com>
In-Reply-To: <495541d3-3165-6d4b-f662-3690139229e9@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 30 May 2023 10:11:56 +0800
Message-ID: <CALTww2_wphLSHV6RAOO05gs0QO8H9di-s_yJRm0b=D7JmjjbUg@mail.gmail.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 30, 2023 at 10:02=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2023/05/30 9:36, Guoqing Jiang =E5=86=99=E9=81=93:
> >
> >
> > On 5/29/23 16:40, Xiao Ni wrote:
> >> It's the data which customers read that can be wrong. So it's a
> >> dangerous thing. Because customers use the data directly. If it's true
> >> it looks like there is a race between non aligned read and recovery
> >> process.
> >
> > But did you get similar report from customer from the past years? I am =
not
> > sure it is reasonable to expect the md5sum should be match under such
> > conditions (multiple processes do write/read with recovery in progress)=
.

I didn't get a similar report these years besides this one.

> >
> > Maybe the test launched 32 processes in parallel is another factor, not
> > sure
> > it still happens with only 1 process which means only do read after wri=
te.
>
> May I ask if these processes write the same file with same offset? It's
> insane if they do... If not, this cound be a problem.

They write to different files. One process writes to its own file.

>
> >
> > Anyway, I think io accounting is irrelevant.
>
> Yes, I can't figure out why io accounting can be involved.

Thanks, I'll look more.

Regards
Xiao
>
> Thanks,
> Kuai
> >
> > Thanks,
> > Guoqing
> > .
> >
>

