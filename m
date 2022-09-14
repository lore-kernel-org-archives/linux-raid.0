Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC88C6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 14:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiINOOU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 10:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiINOOT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 10:14:19 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD0220BC0
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 07:14:18 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id k10so25408367lfm.4
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 07:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=hg4Nny/X/9a1nHRrkMuP9ZMqsdvm2vK4jOk8n3522gM=;
        b=cwbu0z6XEyV2SA4ciTm4FuEYnmB/icRL4ZHI2SOooSo6Wo27JiLf6qAjDZ+5bKIDGZ
         c8pwxCow3TQOPPZ++jqF/7S0tW5/wY0hVVgfP7c9e2DS+JUccLNQ/GTz4B96GBk2voXS
         uAMEdI9GkV0Kv43hgtk5JN/tDV1VuSShmachUA3wKAy+YHiHG4U9xZ8Yb4kiZzyrrNA4
         wBl37XgNarL69EtiIrKTOXmEpI+CX+GytAnN4fzgxDqnRaSnchxq6Okg28cQvY04dtn/
         Iw9CoySxGE1d3Xhw0KhaKfER/Shj291W9mIDgV/96X4U/MBf6IkgzdxNuK3Cq3uFKk5k
         wBqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hg4Nny/X/9a1nHRrkMuP9ZMqsdvm2vK4jOk8n3522gM=;
        b=xwOZxEqI3rqunuZzlDZeqy5V0ehfyfsTUGBnOt+jED3iaGD3ezGKynYnGmf1bbdMzu
         y1IKmYymSeHVKM7B8VVkoWYsVvwYpBroxghCYcsTORutTOVQcuEya1jNyQE87SUYQBds
         6mmkC/68BSZIZgvB6AvIbskrVWxlgToNdMMkj+VvsY6jLSRy/kOgA2ycHDL/SR3vboUV
         GCbIDUJRs/zvktAXfUROPBGzE1WYkJjevhKhguXQIzj1uZXGdJG3AMtzZYqjrMXCVia5
         TOBu0r+7qmUlfGnbToHIca/ardsTBkCHfB2hs5MQR9PaEXSVrbtGaIu9ut9g0zKiJdpO
         G9Ew==
X-Gm-Message-State: ACgBeo0sKLyzVgYnU+9k9YXV0S4b6lo0CcdoEHyfjmAta2bfVMI0vB+2
        YPl6rQAimjkrPcxDZm2zv4jt8gxxz8ipUANZ6Fo=
X-Google-Smtp-Source: AA6agR7iRP7AYPnG5C7IB/lbFycLkFJ6e8jLbdbKFMfu6AxW/BKxKesS9DxvjW0ouqM3hAR5zZEbEDzGJsThddtZuUU=
X-Received: by 2002:a05:6512:1684:b0:47f:5f27:b006 with SMTP id
 bu4-20020a056512168400b0047f5f27b006mr11962897lfb.225.1663164856968; Wed, 14
 Sep 2022 07:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220831175729.1020-1-oldium.pro@gmail.com> <20220914145407.00000d6a@intel.linux.com>
 <f5df5996-579d-0873-ab1f-a0f617db508d@trained-monkey.org>
In-Reply-To: <f5df5996-579d-0873-ab1f-a0f617db508d@trained-monkey.org>
From:   =?UTF-8?B?T2xkxZlpY2ggSmVkbGnEjWth?= <oldium.pro@gmail.com>
Date:   Wed, 14 Sep 2022 16:13:41 +0200
Message-ID: <CALdrqOSMFBB5zz=fyT4EUP1GC1W87wjEzSE58SfT0xPDxTQGUg@mail.gmail.com>
Subject: Re: [PATCH v2] mdadm: added support for Intel Alderlake RST on VMD platform
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     Kinga Tanska <kinga.tanska@linux.intel.com>,
        linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>,
        mariusz.tkaczyk@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

st 14. 9. 2022 v 15:46 odes=C3=ADlatel Jes Sorensen <jes@trained-monkey.org=
> napsal:
>
> On 9/14/22 08:54, Kinga Tanska wrote:
> > On Wed, 31 Aug 2022 19:57:29 +0200
> > Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:
> >
> >> Alderlake RST on VMD uses RstVmdV UEFI variable name, so detect it.
> >>
> >> Signed-off-by: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com>
> >> ---
> >>  platform-intel.c | 18 +++++++++++++-----
> >>  1 file changed, 13 insertions(+), 5 deletions(-)
> >>
> >
> > Reviewed-by: Kinga Tanska <kinga.tanska@linux.intel.com>
> >
> >
> >
> > Looks good to me. I've checked this patch with basic VMD test scope and
> > I didn't find any defect.
>
> Applied!
>
> Kinga, thanks for testing.

Thanks Jes and Kinga! Great to see it merged :-)

Oldrich.
