Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA953E95A63
	for <linux-raid@archiver.kernel.org>; Sat,  7 Oct 2023 13:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343878AbjJGNgR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 7 Oct 2023 09:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343627AbjJGNgQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 7 Oct 2023 09:36:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CE9B6
        for <linux-raid@vger.kernel.org>; Sat,  7 Oct 2023 06:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696685734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MXj9rS8v0TkfWzARTx2VBQmkmyGARZ5jkAmS4tVb1ds=;
        b=gF2BAIkKccJkjUVoQGaeJCgCvlKuuFlFEpVzOO0vyXT503Gg07PfRd+7RTrG2KB9Pmpkri
        INez+GLN+XRn5li0GfF1MHnQ5Qx1D5E69rErSTQFFCifPiw7VSVjTNgRZKrFBYXbON1gIg
        4OA3IwJR2u3uT7fufMqKgMTZXBJQRLg=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-tqgIbOqrO5aOk3n_Xet6Kw-1; Sat, 07 Oct 2023 09:35:31 -0400
X-MC-Unique: tqgIbOqrO5aOk3n_Xet6Kw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-27731a63481so3046031a91.2
        for <linux-raid@vger.kernel.org>; Sat, 07 Oct 2023 06:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696685730; x=1697290530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MXj9rS8v0TkfWzARTx2VBQmkmyGARZ5jkAmS4tVb1ds=;
        b=ovzyBVeP48KSQFRajzp1FPUzrQjN5NAbsSulUGaCZPQ+ITv6CCbYSu4N9ELn6OOaXB
         ybZXEP3tG2iB2Ih+VDg2OV+TaPfB6AZfYqPYhz74LKJF53GAgTEGFDDK8C1ucV6eHsyK
         CcBCOyr7pY3bf8Gri+2kAW+FIBoJaQqU/IaaMe4JIV2yJaQaf0FV+GdnvvpSakJfPdwd
         JbFT8z61rXzoL/L8icApUcolPkLyuxzl7OtDcOeCdzFzPulYulflMJjlCjyoP+QPZ8Gc
         QDXtHVGazU4Bdsp+RUMGXx2UPjpU0/1ZN7MDmlE84VPEtix7wJqupUipTUHgGVgs4E0I
         l/aQ==
X-Gm-Message-State: AOJu0Yyl1v1yEdUUMzHsbBCECUCIsVC3EIiUhynlQ/4aZo6D4LAyzVxA
        nFICBwI93UT/eWTJQ1eNT8qOWc4mT+dOGZmAohMZ/CsOAZP8E3PIzncmZqGZBCMJUxQ3g4+5myK
        AjUaGSJDLsAgmgjsQ8ak4J7NoWcWrRDU8IKqJ687lSA68Tw==
X-Received: by 2002:a17:90b:4ad0:b0:274:a021:9383 with SMTP id mh16-20020a17090b4ad000b00274a0219383mr10843654pjb.17.1696685730515;
        Sat, 07 Oct 2023 06:35:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/WA2EedV0hqRi5do8zC9LYr/0J/CLru1FYcb2M43hpagGXagaQiJWm6Zcq+niQOyzsinUzCz1AI9Jguc71A0=
X-Received: by 2002:a17:90b:4ad0:b0:274:a021:9383 with SMTP id
 mh16-20020a17090b4ad000b00274a0219383mr10843643pjb.17.1696685730217; Sat, 07
 Oct 2023 06:35:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230927025219.49915-1-xni@redhat.com> <20230927025219.49915-2-xni@redhat.com>
 <20230928112448.000010f6@linux.intel.com>
In-Reply-To: <20230928112448.000010f6@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Sat, 7 Oct 2023 21:35:18 +0800
Message-ID: <CALTww2_EKnO=uE81=3O48rPCfebkFXAGSQVW+w4FWZ3jH15T-g@mail.gmail.com>
Subject: Re: [PATCH 1/4 v2] mdadm/tests: Fix regular expression failure
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 28, 2023 at 5:25=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Wed, 27 Sep 2023 10:52:16 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > The test fails because of the regular expression.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  tests/06name | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tests/06name b/tests/06name
> > index 4d5e824d3e0e..86eaab69e3a1 100644
> > --- a/tests/06name
> > +++ b/tests/06name
> > @@ -3,8 +3,8 @@ set -x
> >  # create an array with a name
> >
> >  mdadm -CR $md0 -l0 -n2 --metadata=3D1 --name=3D"Fred" $dev0 $dev1
> > -mdadm -E $dev0 | grep 'Name : [^:]*:Fred ' > /dev/null || exit 1
> > -mdadm -D $md0 | grep 'Name : [^:]*:Fred ' > /dev/null || exit 1
> > +mdadm -E $dev0 | grep 'Name : Fred' > /dev/null || exit 1
> > +mdadm -D $md0 | grep 'Name : Fred' > /dev/null || exit 1
> >  mdadm -S $md0
> >
> >  mdadm -A $md0 --name=3D"Fred" $devlist
>
> Hello Xiao,
> I can see that it is not sent first time. Previous version was moved by m=
e to
> the "awaiting_upstream" state on patchwork but I forgot to answer.
> You don't need to send it again. I'm ignoring this one. Anyway, here my
> approval:
>
> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>
> https://patchwork.kernel.org/project/linux-raid/patch/20230907085744.1896=
7-1-xni@redhat.com/

Thanks for the information :)

Regards
Xiao
>
> Thanks,
> Mariusz
>

