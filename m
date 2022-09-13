Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166C5C54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 04:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiIMECn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 00:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiIMECl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 00:02:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA76652E72
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 21:02:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j6-20020a17090a694600b00200bba67dadso10095629pjm.5
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 21:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=b0tG/cqxkJEMIvokrm2R928o84swVDtCf47uSGlN4/Q=;
        b=nWl6+SuuqIx5dZ8zaxk2o/CwBBs0igRGeLckMZxsM0C2wZyIequdXFHvxHDWljkD6Z
         UKLu94XkxzAsCrPonaZPJAxPO5upvcVyOR4wKQNc1qSP8pDIYIXzgnb96uxFy+/fnRhx
         U62IoXuO6WxSRlYrGnI6X5niS5uNqBfHvqsyUgd2TR1xrIttCVVnAz4YR4q5zBlQeAk9
         awzGrTvQnkrAncMA3vA8L39Z1hzbgXcgb6VjuPzzyXkd4Xcq9g0KJgNEXNB4FmB5fWrb
         2E2W4bFJC77OOgUsj9IuwhNvF52TwwOnkCs404HydvGvdeEqromNVxsg8vsxQSiImmzz
         uUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=b0tG/cqxkJEMIvokrm2R928o84swVDtCf47uSGlN4/Q=;
        b=IQgf+1WU6G02mNRg+9iTNDuSHs9pSYimeT1lHpKzr0NP6h54ubRjBkaQJA8zvAWV9k
         vsenWn/2tl3R6tv+d6yif745IAIDPrJR0oUKuCA4uKe1Xw6hF6OFmHd1YR+DtgXLchJY
         NUuhWH6fyB9T0114JdPQIox0F/9DTP3cC3Iu4jROT2ypIJT+2KZS5+bqX5C0PDpMVugi
         3pedivD7PER08IheUmpR3aRxLP+omnWzRdcv9VFghg0oKZQUg+3tscv0KEcmTqU6lKf6
         UuvqqtwLaPtJpn7bLYWN3lzA2JQyRR3ylDjmnBFZuxnHifllz/geu8zMUDEFdClHUQ8m
         ZVFg==
X-Gm-Message-State: ACgBeo0ncxhQo/8Kf5XFX9t/Ozg4XOXVOfgkqc2RwjGg62w5nqt34ePG
        9xzhRrtCjvsCjmxdSzZo2qW6YvkRcVCCcnowUo8nVigo
X-Google-Smtp-Source: AA6agR4xFTXt0BbHUN1+3Yya9WrHVWrjwLTJX1qnvzNZkBgmGsG5FD8BoIGEqSTm89d8EMAR8HAk0ky62U50wZNg7l8=
X-Received: by 2002:a17:90a:d3c2:b0:202:acc2:1686 with SMTP id
 d2-20020a17090ad3c200b00202acc21686mr1872131pjw.126.1663041760232; Mon, 12
 Sep 2022 21:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org> <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org> <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
 <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org> <87k0688l6i.fsf@vps.thesusis.net>
In-Reply-To: <87k0688l6i.fsf@vps.thesusis.net>
From:   Luigi Fabio <luigi.fabio@gmail.com>
Date:   Tue, 13 Sep 2022 00:02:08 -0400
Message-ID: <CAJJqR21N2G5-nN_Ef+2W51FmQ40e8WbZfmrN6c42rdid2T_GoA@mail.gmail.com>
Subject: Re: RAID5 failure and consequent ext4 problems
To:     Phillip Susi <phill@thesusis.net>
Cc:     Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 12, 2022 at 3:09 PM Phillip Susi <phill@thesusis.net> wrote:
> Every time I think about this I find myself amayzed that it does seem to
> be so stable, and wonder how that can be.  The drives are all enumerated
> in paralell these days so the order they get assigned in should be a
> total crap shoot, shouldn't it?
Well, there are several possible explanations, but persistence is
desireable - so evidently enumeration occurs according to controller
order in a repeatable way until something changes in the configuration
- or until you change kernel, someone does something funny with a
driver and the order changes. In 28 years of using Linux, however,
this has happened.. rarely, save for before things were sensible WAY
back when.

LF
