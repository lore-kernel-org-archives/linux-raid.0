Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6796CC77B60
	for <linux-raid@archiver.kernel.org>; Sun, 23 Apr 2023 19:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjDWTes (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 23 Apr 2023 15:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDWTee (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 23 Apr 2023 15:34:34 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A371CF1
        for <linux-raid@vger.kernel.org>; Sun, 23 Apr 2023 12:33:25 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-94f109b1808so649837866b.1
        for <linux-raid@vger.kernel.org>; Sun, 23 Apr 2023 12:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682278342; x=1684870342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/e5MUUw0ssUw/a1QsX45JG9NyZ0ErzEVtpgoN1kr+VU=;
        b=EYbHOJCQMag3wJmvbK1HGZu2V1Tug738bixTZmCt/RERNUF02IK+e6x5dLNLpB2r/5
         riPh96eL3G6lpHDbl+AkbEjuNSVIarxM5OB6yIomm6IBtJ6wAIEnJ64TJwPaBjmn280N
         V5fqE8nyJPcxACexkP/pSivCuwtlxA37sp0hUzdUvoI9aMBi0qNwlRPRQ4pfQYsvMpuS
         zdhzL07t0qY1LlDuVfe/639BL7chuBl63oyxHxpJlnDCwrdGtolM/CkdOQGgrmBjeg3y
         cgOKWHmoO13j+zOmLm0gtT+Ia2Agz0tnhxh6vpF1jU/aqlfycFA5YeWRx44+LrvYhaPc
         EBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682278342; x=1684870342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/e5MUUw0ssUw/a1QsX45JG9NyZ0ErzEVtpgoN1kr+VU=;
        b=Ms4hOt/ifyuoVUx8lKLgI/czTaNBozO4lvVYRZRt5jb9riaa+DzxcbbKuMnoRqznpf
         bzvfCvlcmhOrZ3pj20EJ2dnGaIr3f4cY5Aazco1OUwELbn9+CL/1lr0gK562i7rZXDtf
         PexDGSKzGWezRURN3FD18yZJJoAfqwVqx0RofqsYoG+rVbTIQFjfnKFkFTlWDLsFQE7u
         ZObhLJSzC0gIVBNmkpqeUVCuZAwIAHCLYOrxWwoTu8qTQwZWfLKWli8sLVj0l1KiERBe
         pNibWmiNMfDzxdoR2Gp6s5UnVD51OxHzTmE4effLruE3Ei6ZCsI4h1SD39tO0aEndZwr
         Ysng==
X-Gm-Message-State: AAQBX9eUGOcasvp2AVaLlp0dcSawSi7pI7dpnHetkDHyDU3+/NPMz1uV
        31JqIMtKLMMt+NEJ1eTm0CJjgxEgUej0zws3cqqCrYbC0Cs=
X-Google-Smtp-Source: AKy350YF9wSKMHq77DpcFc5gpjs5hir07+yLmeBfT5uvNMcG4PZB12HioPG0l35HsMFkra+AL11rpJVuEkvDr98w7qQ=
X-Received: by 2002:a17:907:3c11:b0:88a:1ea9:a5ea with SMTP id
 gh17-20020a1709073c1100b0088a1ea9a5eamr6850040ejc.65.1682278342336; Sun, 23
 Apr 2023 12:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <81f8ff93-28be-c520-f497-aeefa5a6f879@thelounge.net>
In-Reply-To: <81f8ff93-28be-c520-f497-aeefa5a6f879@thelounge.net>
From:   Jove <jovetoo@gmail.com>
Date:   Sun, 23 Apr 2023 21:32:11 +0200
Message-ID: <CAFig2cuCgNRZcm6q4=BQ8ikmCcoZiTJDtqwd5gs73qiHq19GVw@mail.gmail.com>
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

That comment was because I misunderstood the actual function
of the argument. It should have been 5, not 4 or 3 :).

I do doubt this is the cause of my problems though.

On Sun, Apr 23, 2023 at 9:19=E2=80=AFPM Reindl Harald <h.reindl@thelounge.n=
et> wrote:
>
>
>
> Am 23.04.23 um 21:09 schrieb Jove:
> > I've added two drives to my raid5 array and tried to migrate
> > it to raid6 with the following command:
> >
> > mdadm --grow /dev/md0 --raid-devices 4 --level 6
> > --backup-file=3D/root/mdadm_raid6_backup.md
> >
> > This may have been my first mistake, as there are only 5
> > drives. it should have been --raid-devices 3, I think.
>
> how do you come to the conclusion 3 when there are 5 drives? you tell it
> how much drives there are and pretty sure after "mdadm --add" you can
> skip "--raid-devices" entirely because it knows how many drives there are
>
> https://raid.wiki.kernel.org/index.php/Growing
