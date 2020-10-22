Return-Path: <SRS0=HOAI=D5=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D1CC388F2
	for <linux-raid@archiver.kernel.org>; Thu, 22 Oct 2020 11:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B7402227F
	for <linux-raid@archiver.kernel.org>; Thu, 22 Oct 2020 11:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q5ydDBur"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897514AbgJVLog (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Oct 2020 07:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897511AbgJVLof (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Oct 2020 07:44:35 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF902C0613CE
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 04:44:34 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id e20so1173806otj.11
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 04:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v2Cm0wefpioWXXOmASl2yxjCXaQFEt8mHtIEMTOw3Lg=;
        b=Q5ydDBur6UmZ7A078kwhbSKsjHU8+GrqyvuHvWlioSf3+6UEmprET+EjglSmQP0F7n
         U4HmNawhoBXho2V8c/+ydJl3H0GXIGdzloHbGjk75VUVn9raVf7Vlmss8vHNNpElCiUw
         BBageYpXSW7/jTFCSfCUg3eeEN31bF7/r19WYh23ONpB4jT/2YjZkGi+WAmodP58Ro3e
         XNhLWFslkwb7rqb0NZiv44vrwPXVrEkVQLEAbTuKmgbzOF4FKDpm62YF7MJRjheGDYPz
         VuIjhwcgI5BT1KN12iQFRucT+3xBcx8rFtI4Hy0fsXPNG8NiRQX9DcKIiP33J91+oWvX
         aE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v2Cm0wefpioWXXOmASl2yxjCXaQFEt8mHtIEMTOw3Lg=;
        b=DFzJb3T565W6vYlxr3dhgZaeS35gs8TWWZnF0uJo9d9c3PlbI42ML9dSBM4MOz/c38
         StVovJRqf2Btlbs/uyZRzh+JkAcW/tV79JCyGpC5BsCzCe/I404ZWbogQxIAF09SgDKe
         oBaPgtaOKtyeDNrG12AtHA7cydnvcuwy4n83OnRcBJdxsi9T8BN0Mr/GU4bFQdgql3qP
         ulVCl43VDCu88S1/ujMvpkSgV/IZ1vSM1qTCpR+PW+4PsSET+tou///i2ALWDWlfJQZy
         q72ZtGM4NhwHrIea8HHrDpF1qD0pp5YfpbW/qfQ6JVtKo+53WTSSZgRw/gpGAk5ewNUN
         OsVA==
X-Gm-Message-State: AOAM530OlqnkUTFBLen70T0X7Y6qiWJTZ8MLrgV6p2zmmUluLA7Xx9ni
        zvof35Jxvjm/WSVw4Y2xXjlD55+ETNqLlFPvcDuUmXpqqiY=
X-Google-Smtp-Source: ABdhPJy/eBoRlszZHUvNbGg5mdEkNgaxxpgQZEt1aSCDfL1YXbsrR2X7Y7BODcvf1yxDSweClOlPoSmOh5Xhfu/t7dU=
X-Received: by 2002:a05:6830:140b:: with SMTP id v11mr1640228otp.92.1603367074218;
 Thu, 22 Oct 2020 04:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <ED0868EE-9B90-4CE6-A722-57E0486A71FF@creamfinance.com>
In-Reply-To: <ED0868EE-9B90-4CE6-A722-57E0486A71FF@creamfinance.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Thu, 22 Oct 2020 13:44:23 +0200
Message-ID: <CA+res+SvZWmCuWdcQA95WPG4wi3kChLmzAH2jKXW3TK5pL=WQg@mail.gmail.com>
Subject: Re: mdraid: raid1 and iscsi-multipath devices - never faults but should!
To:     Thomas Rosenstein <thomas.rosenstein@creamfinance.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thomas Rosenstein <thomas.rosenstein@creamfinance.com> =E4=BA=8E2020=E5=B9=
=B410=E6=9C=8822=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=8812:28=E5=86=
=99=E9=81=93=EF=BC=9A
>
> Hello,
>
> I'm trying todo something interesting, the structure looks like this:
>
> xfs
> - mdraid
>    - multipath (with no_path_queue =3D fail)
>      - iscsi path 1
>      - iscsi path 2
>    - multipath (with no_path_queue =3D fail)
>      - iscsi path 1
>      - iscsi path 2
>
> During normal operation everything looks good, once a path fails (i.e.
> iscsi target is removed), the array goes to degraded, if the path comes
> back nothing happens.
>
> Q1) Can I enable auto recovery for failed devices?
>
> If the device is readded manually (or by software) everything resyncs
> and it works again. As all should be.
>
> If BOTH devices fail at the same time (worst case scenario) it gets
> wonky. I would expect a total hang (as with iscsi, and multipath
> queue_no_path)
>
> 1) XFS reports Input/Output error
> 2) dmesg has logs like:
>
> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block
> 41472, async page read
> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block
> 41473, async page read
> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block
> 41474, async page read
> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block
> 41475, async page read
> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block
> 41476, async page read
> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block
> 41477, async page read
> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block
> 41478, async page read
>
> 3) mdadm --detail /dev/md127 shows:
>
> /dev/md127:
>             Version : 1.2
>       Creation Time : Wed Oct 21 17:25:22 2020
>          Raid Level : raid1
>          Array Size : 96640 (94.38 MiB 98.96 MB)
>       Used Dev Size : 96640 (94.38 MiB 98.96 MB)
>        Raid Devices : 2
>       Total Devices : 2
>         Persistence : Superblock is persistent
>
>         Update Time : Thu Oct 22 09:23:35 2020
>               State : clean, degraded
>      Active Devices : 1
>     Working Devices : 1
>      Failed Devices : 1
>       Spare Devices : 0
>
> Consistency Policy : resync
>
>                Name : v-b08c6663-7296-4c66-9faf-ac687
>                UUID : cc282a5c:59a499b3:682f5e6f:36f9c490
>              Events : 122
>
>      Number   Major   Minor   RaidDevice State
>         0     253        2        0      active sync   /dev/dm-2
>         -       0        0        1      removed
>
>         1     253        3        -      faulty   /dev/dm-
>
> 4) I can read from /dev/md127, but only however much is in the buffer
> (see above dmesg logs)
>
>
> In my opinion this should happen, or at least should be configurable.
> I expect:
> 1) XFS hangs indefinitly (like multipath queue_no_path)
> 2) mdadm shows FAULTED as State

>
> Q2) Can this be configured in any way?
you can enable the last device to fail
9a567843f7ce ("md: allow last device to be forcibly removed from RAID1/RAID=
10.")
>
> After BOTH paths are recovered, nothing works anymore, and the raid
> doesn't recover automatically.
> Only a complete unmount and stop followed by an assemble and mount makes
> the raid function again.
>
> Q3) Is that expected behavior?
>
> Thanks
> Thomas Rosenstein
