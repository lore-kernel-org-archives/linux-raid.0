Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C9FC4332F
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 13:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 636EA6128A
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 13:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhJRNIR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Oct 2021 09:08:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhJRNIN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 18 Oct 2021 09:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634562362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nRhJk87FKbSqIBDHrwN6febckhjDCMLOcpZxLYbrTZ4=;
        b=Bh6bhkslcQnf1lf+A6IxRrpqigm23mb+FLNVUts5rxe/Hcrfm69UMx31I0VSGo89WgNTo1
        DvMYTg6QD34u+bNfKyVi4VsT76IPSXYdiwus5nJika8VcVbOX4BaDM5/Ih36azjVe5zr9D
        i4X0v6ZrbPGedlBCBI7Rneh2q5OVL9I=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-r7kOHPwZOjGrljdWQbZSug-1; Mon, 18 Oct 2021 09:06:00 -0400
X-MC-Unique: r7kOHPwZOjGrljdWQbZSug-1
Received: by mail-ed1-f69.google.com with SMTP id cy14-20020a0564021c8e00b003db8c9a6e30so14311561edb.1
        for <linux-raid@vger.kernel.org>; Mon, 18 Oct 2021 06:06:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nRhJk87FKbSqIBDHrwN6febckhjDCMLOcpZxLYbrTZ4=;
        b=iZ6xnvnUSqxFi733OPoUvsAU4xuvqf6+MM5X/n5rhlFWNwABEo6M/+UX4FSLCf8Wy+
         JO+VDixCncl5X2pD6cT3CfbBVqyEqvblkHGLvHhQuRg6jBqP5T74itKOarWKTgib5f+e
         q1BzPUNrP/jPRJfemmr91iTwMAUYQrDKAGVWeMR2Yq+UTbcCnuocK5nRk/MNTkhIw7Ol
         JcgkmyJb1ITaDFelI+YIuAuPQuYGFXvFbk8Qje3RJBAYcuUsOlnjb9BOYF8sP+ztR/FK
         bGbqB3shx21UxSIVSVkQMSgTVbGrWkIL5b4wagdN5mYbhaZXsXXErcMScMrESs1U1npu
         4OJg==
X-Gm-Message-State: AOAM532Lnx2yx/wHsV6iGuUebLlJIuGgq7cH6rUI7IbZL90ftfbZeWM0
        jUuwBukoKll75mn2VIusZfXzW07Qgi8kkbjpu20d8mzNjwDaUUp3UXmZEPEs2JNLK08Kv5vTp0b
        XykbsXBq7iz2VqJr4xBnHI7vxSgGxGgCuCUocSQ==
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr30591086ejc.239.1634562359583;
        Mon, 18 Oct 2021 06:05:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBm5Nsm6FTDoAuSI0L8PPmoH+wRbKOYmtHRZ7lOmEhtnRZsg08/GLr/APQ454TqjKxR/CDlyjPpZxE62CmTe8=
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr30591065ejc.239.1634562359354;
 Mon, 18 Oct 2021 06:05:59 -0700 (PDT)
MIME-Version: 1.0
References: <1634289920-5037-1-git-send-email-xni@redhat.com>
 <92351bf8-b0e3-89da-48c0-993b0dc29db2@linux.intel.com> <CALTww28pOiSBMA3ozM+CpM2E4mNFf2kpfGO5o3zN1oEu21tYCw@mail.gmail.com>
 <34bc33db-101f-9306-01fe-6d6dde23a695@linux.intel.com>
In-Reply-To: <34bc33db-101f-9306-01fe-6d6dde23a695@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 18 Oct 2021 21:05:47 +0800
Message-ID: <CALTww2-1SL=3XStCOgUpKRnaeDE06Bm5vzMOCwr2cr0-u37CVw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, Nigel Croxon <ncroxon@redhat.com>,
        Fine Fan <ffan@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 18, 2021 at 7:52 PM Tkaczyk, Mariusz
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> There is a code:
>         if (create && !regular && !preferred) {
>                 static char buf[30]; <- this variable will survive retry.
>                 snprintf(buf, sizeof(buf), "%d:%d", major, minor);
>                 regular = buf;
>         }
> but seems that it is not a case for this scenario. I suspected that
> this was used because when gathering container name:
>
>                 container = map_dev_preferred(major(devid), minor(devid),
>                                               1, c->prefer);
>
> 'create' is explicitly set to 1. That is why I expect to have 'container'
> declared in static area. Make sense?
>

I c.

>
> >>
> >> This whole block should be moved from Detail() code to separate
> >> function, which determines if device or replacement is in sync.
> >
> > A good suggestion. Put it into the change I mentioned above, is it ok?
> >
> Agree. So, will you take care about all improvements later (after release)?
>

I plan to do this after you talk about them. If you want to fix them, I can help
to review too. I'll ping you when I'm ready to do this to check if you
start doing
it.

Best Regards
Xiao

