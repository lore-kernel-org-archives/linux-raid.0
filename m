Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EC5C7618E
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 07:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjDXHDD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 03:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjDXHCw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 03:02:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA772D79
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 00:02:47 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5051abd03a7so5789324a12.2
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 00:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682319766; x=1684911766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A6I9yoFOPKCqVzasT8wEQPMwfAPO0EdY70bI4rZNlrc=;
        b=rG9qH3NZpBqkacUSIlW6HdexVHcT/RxHj3ruFpKE67+GRwTqXRXiCIkPHO4phDK7an
         vHNY7RjPa7dQrVxQtWucd1UNmMFOlOA40fM4rDBKD7FGCYxsp2PeMY29oynsWW5+Ju9w
         J4mpUILYT95WnRliPVkLuNl5IHF/RrTgvUuJXiQQyNJ0nFQe1Le7lFliKKXf6gZYLTrz
         P3I+CJ6WsCpvffLdF9jrFS/muKvzkwA9eVu4gkEs1pzMyEZGhKq7RwXLLLKifbItQiFW
         PTVTkAsZ2we0956Csq2yQMRWexvzi+HUzOhB0P8xIK96+GmWQaWTEywfaLbA/f1/Bkgv
         m1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682319766; x=1684911766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A6I9yoFOPKCqVzasT8wEQPMwfAPO0EdY70bI4rZNlrc=;
        b=fFw8dTIDOAD1XgMMAlmOUGlKYQAVBb+m9R73OCqFbHZqXke+en2RaCQcW9um7l9AjT
         W2/P58iBBvEv7rp7h22SDtnULHDffKw7ROBF8aPPvosHCpymImu9bakl1gnNcketpXgO
         QTk26Hw71Snx0Mlh10iNaIYaQW7yWb6qig0hheAt9VKUoWWMqWpzjFj+QD252+t6gr9X
         EUl/Dq7tqIQGyJy3QxEqZA0/FM8/kUsT3fdvIBvA3rEimCpznvdrzyjanEnuDkr6EBiE
         77wIviot9wRvXjVrXDXuBXjDjS5MDgEU4WvuHzWumcFh5W5zR/DdNsC09wgkNEp4TFG2
         FlyQ==
X-Gm-Message-State: AAQBX9fnIW+xYMYl91sdDweXFu5Jw4qXFxHvaswrdYKtkgbvmB1S2ANF
        YDGUetHHQBcjk5A9jfqyn12AH4DCBJSyJAcaNJkHJd9ibtjPGw==
X-Google-Smtp-Source: AKy350aapFSYnZ+QaFNZhNSmF0ZrRjD+QwT8S9eKxaINKoIM/tP5um9jpQQEJbeGLaAWD+Sg0EKRi8aU+1SKOcncqIs=
X-Received: by 2002:a05:6402:419:b0:509:c1c2:373e with SMTP id
 q25-20020a056402041900b00509c1c2373emr7141303edv.8.1682319766195; Mon, 24 Apr
 2023 00:02:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <81f8ff93-28be-c520-f497-aeefa5a6f879@thelounge.net> <CAFig2cuCgNRZcm6q4=BQ8ikmCcoZiTJDtqwd5gs73qiHq19GVw@mail.gmail.com>
In-Reply-To: <CAFig2cuCgNRZcm6q4=BQ8ikmCcoZiTJDtqwd5gs73qiHq19GVw@mail.gmail.com>
From:   Jove <jovetoo@gmail.com>
Date:   Mon, 24 Apr 2023 09:02:35 +0200
Message-ID: <CAFig2cs1qtYxqMkCHRY+sFwY4E1rBC0KGS0RFWnjt67UF4wgwQ@mail.gmail.com>
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> I do doubt this is the cause of my problems though.

Just to clarify, migrating an array from a 3 disk raid5 to a 4 disk
raid6 should be fine?

On Sun, Apr 23, 2023 at 9:32=E2=80=AFPM Jove <jovetoo@gmail.com> wrote:
>
> That comment was because I misunderstood the actual function
> of the argument. It should have been 5, not 4 or 3 :).
>
> I do doubt this is the cause of my problems though.
>
> On Sun, Apr 23, 2023 at 9:19=E2=80=AFPM Reindl Harald <h.reindl@thelounge=
.net> wrote:
> >
> >
> >
> > Am 23.04.23 um 21:09 schrieb Jove:
> > > I've added two drives to my raid5 array and tried to migrate
> > > it to raid6 with the following command:
> > >
> > > mdadm --grow /dev/md0 --raid-devices 4 --level 6
> > > --backup-file=3D/root/mdadm_raid6_backup.md
> > >
> > > This may have been my first mistake, as there are only 5
> > > drives. it should have been --raid-devices 3, I think.
> >
> > how do you come to the conclusion 3 when there are 5 drives? you tell i=
t
> > how much drives there are and pretty sure after "mdadm --add" you can
> > skip "--raid-devices" entirely because it knows how many drives there a=
re
> >
> > https://raid.wiki.kernel.org/index.php/Growing
