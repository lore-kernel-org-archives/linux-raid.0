Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C599C6FD19
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 21:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjCMVVD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Mar 2023 17:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjCMVVB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Mar 2023 17:21:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8822196F
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 14:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38434614D0
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 21:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C993C4339B
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 21:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678742457;
        bh=gbrlD5ZXRF+macjCokztYLr/E9n8obE4+J/loo8DVk4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QoVTF4ZVKceYUEyxVdOXuea0Tgo70wA3yaYLvmBHfnfqImFq5Gi2fX7CR4SoFL61j
         K2nWXX0Lp0rwwKt2SlHoKXrJQfpFVhKFzhDt4QesX6pP3mlLXMAKph8ytQMAdsBr5F
         A/snv/l8qWh2WbLMB6+muB2wImTzAA7VGZWWNhBZO6PZk6Uc9gJCTDioIgr7OXKDlY
         sHJ3a5xT1iFfFdgQ/JR+Hd9PaCx/uN0pvHbNJvH4X2xFLix3ys5kfZytZwLr/Hh23e
         G1XfPf9PbokHykVGj5nPULv5uEDp5I+KGWB8qPnB4Dd5iOOp0drf82J9rc0oezuAzT
         QnlhZfVgy+hjw==
Received: by mail-lf1-f41.google.com with SMTP id n2so17423011lfb.12
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 14:20:57 -0700 (PDT)
X-Gm-Message-State: AO0yUKV6ISR4Y/f3407j54SQvI9TCdrnvlQxNAZwr3rk3jmVNLfv+B3R
        JWWW28goVvyjIsmcz9WHfKFCaEAVO25KrBLcbyM=
X-Google-Smtp-Source: AK7set+TJx6kU9GaQo/25SotjB00dmJQ5XAaeAMcCnm4nS3+55WGXhUn3ZmSgdVWObCLqKxdcgPUfXCEkdHAa1VlR7I=
X-Received: by 2002:a19:e019:0:b0:4d8:86c2:75ea with SMTP id
 x25-20020a19e019000000b004d886c275eamr5725922lfg.3.1678742455670; Mon, 13 Mar
 2023 14:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1678136717.git.heinzm@redhat.com> <5be00f6c-22ee-1af3-c5ed-d92863d7f442@linux.dev>
 <CAM23Vxqf-XMdoobeEyyk1MC=PzkWM=5w88jM8R-joxrrT82ukw@mail.gmail.com> <777de4f2-1b5d-aded-620d-4c14102a551f@linux.dev>
In-Reply-To: <777de4f2-1b5d-aded-620d-4c14102a551f@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Mon, 13 Mar 2023 14:20:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW403CvtNqALpBMi-SWOaPULybUF3xPSQa7e54+0pm74bA@mail.gmail.com>
Message-ID: <CAPhsuW403CvtNqALpBMi-SWOaPULybUF3xPSQa7e54+0pm74bA@mail.gmail.com>
Subject: Re: [PATCH 00/34] address various checkpatch.pl requirements
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Heinz Mauelshagen <heinzm@redhat.com>, linux-raid@vger.kernel.org,
        ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 7, 2023 at 5:37=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linux.d=
ev> wrote:
>
>
>
> On 3/8/23 01:22, Heinz Mauelshagen wrote:
> > As the MD RAID  subsystem is in active maintenance receiving
> > functional enhancements still, it is
> > hardly old in general,
>
> I might use the inappropriate word, let's say the 'existing' code.
> And I am not against use checkpatch (all the new patches
> should be checked by it I believe).
>
> > profits from coding (style) enhancements and
> > adoption of current APIs.
>
> This kind of patchset can also bring troubles, eg, people works
> for downstream kernel need more effort to backport fix patches
> due to conflict, I assume stable kernel could be affected as well.
>
> A more sensible way might be fix coding style issue while the
> adjacent code need to be changed because of new feature or bug
> etc. Anyway, just my 0.02$.

Agreed. These 1032 insertions(+) will make git-blame harder for
little benefit in style.

Thanks,
Song
