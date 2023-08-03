Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7871CC001DF
	for <linux-raid@archiver.kernel.org>; Thu,  3 Aug 2023 11:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbjHCLmu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Aug 2023 07:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbjHCLms (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Aug 2023 07:42:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D059F1B2
        for <linux-raid@vger.kernel.org>; Thu,  3 Aug 2023 04:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691062921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c5ODUsR4mm908qnIEi7Vkb37sDA7MjaIlaTCiFjeyxU=;
        b=IrdKgkr/hYAwX2FyTNFNHiOrOrsM1HHsoOFOeIp1VvPwE5Fu83kPccTvpgiqDuHRp0Xfs4
        WfdEw5wLy79a0qj0isM7HywLUqfu9D9KwTWBumnxi49oqB26uGBFdGoLd/xKXhfmd+u0Pz
        RjOAO5aBHaQGhqJqopGEae6wz72/J7o=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-UCuMSGIhPzidM16pWwnANA-1; Thu, 03 Aug 2023 07:42:00 -0400
X-MC-Unique: UCuMSGIhPzidM16pWwnANA-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-268727b3197so665884a91.2
        for <linux-raid@vger.kernel.org>; Thu, 03 Aug 2023 04:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691062919; x=1691667719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c5ODUsR4mm908qnIEi7Vkb37sDA7MjaIlaTCiFjeyxU=;
        b=gxqkkZityDbvAc0/IsmqN6XyuMNZ7+20vYyXoRI0M8tZY3FxD4C9ltyf4SrEV9BSeu
         9nDpZoacNk/NUkKmaG+dX50aTotY0k+P6yQcXBYacAMARPv2uWEITTIIfMvC4gju/WQ+
         U9yFYEKJgcB2WnQ/mlvWJCRY5r2NLBQGZpirq1vS+mGXFUfmqnLVk+9AgDqyp9LFuVQP
         LoHClrhxeSNnl+Zlb7qXYCDeORzPhwD6HF0C/YWxsIE8CDgPQcYTzTJqSr1r8nU6GJJY
         fMXA0guEosxzlt5/xoupcnu/zTspVY6wzl+BsQ69UgXzC++k3BCgkvRFKE9tVhhKuv6d
         Xs5A==
X-Gm-Message-State: ABy/qLYapnZ605a4F4ka3a+tSPXLpR+7rbrkJqjpnIG7s5r9hUWG7IvL
        0qhjGLHQmF9RRCCUMlkJWXxd0NNjNBZvANMGNABKTvpHcYuhgtPyEdCZ09/0sQIG9W/J+mJiWL8
        DwOcUG1I+QzUHnOx67io3mbFn2j94t/2Mfb4kVoKTqP6Zxg==
X-Received: by 2002:a17:90a:64c9:b0:267:f99f:492f with SMTP id i9-20020a17090a64c900b00267f99f492fmr15456764pjm.48.1691062919136;
        Thu, 03 Aug 2023 04:41:59 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEYZKl1xCNOOzCFWlGtmc5VxjkwX9W2HjfnebL4NJPDv70hv0Kgvj4+ay+Uz57iREKRtSLskStCNly4RHz//vI=
X-Received: by 2002:a17:90a:64c9:b0:267:f99f:492f with SMTP id
 i9-20020a17090a64c900b00267f99f492fmr15456750pjm.48.1691062918813; Thu, 03
 Aug 2023 04:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww2_FrkmafTkObCX4W1SXVeJiy45h7TR68iHUMpzfAOseHQ@mail.gmail.com>
 <20230803090429.0000046a@linux.intel.com>
In-Reply-To: <20230803090429.0000046a@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 3 Aug 2023 19:41:47 +0800
Message-ID: <CALTww28VmeQXbTn4ONxE4Y9M3rR6OkQhcE6AMUkw_5LSOTPuLg@mail.gmail.com>
Subject: Re: The imsm regression tests fail
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 3, 2023 at 3:12=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Thu, 3 Aug 2023 11:27:57 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > Hi Mariusz
> >
> > Now most imsm regression tests fail.
> >
> > +++ /home/mdadm/mdadm --quiet --create --run /dev/md/vol0 --auto=3Dmd
> > --level=3D0 --size=3D5120 --chunk=3D64 --raid-disks=3D3 /dev/loop0 /dev=
/loop1
> > /dev/loop2 --auto=3Dyes
> > +++ rv=3D0
> > +++ case $* in
> > +++ cat /var/tmp/stderr
> > mdadm: timeout waiting for /dev/md/vol0
> >
> > +++ echo '**Fatal**: Array member /dev/md/vol0 not found'
> > **Fatal**: Array member /dev/md/vol0 not found
> >
> > Could you have a look at this problem?
> >
> > Best Regards
> > Xiao
> >
>
> Hi Xiao,
> Please provide (I guess it is md126):
> # mdadm -D --export /dev/md126
>
> If there is no MD_DEVNAME property then udev has no content to make the l=
ink.
>
> Do you have this one applied?
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3Def6236d=
a232e968dcf08b486178cd20d5ea97e2a
>
> Thanks,
> Mariusz
>

Hi Mariusz

I re-complied the codes and the failure disappeared. Thanks for your feedba=
ck.

Regards
Xiao

