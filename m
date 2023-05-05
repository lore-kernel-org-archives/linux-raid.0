Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB6EC77B75
	for <linux-raid@archiver.kernel.org>; Fri,  5 May 2023 07:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjEEHbp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 May 2023 03:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjEEHbf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 May 2023 03:31:35 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D8F17FEC
        for <linux-raid@vger.kernel.org>; Fri,  5 May 2023 00:31:25 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id a1e0cc1a2514c-77d049b9040so12712852241.1
        for <linux-raid@vger.kernel.org>; Fri, 05 May 2023 00:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683271884; x=1685863884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9/9JuvyVhZw9zXhGtLhH8ui7PtgkXlKB7tdImiMwA0=;
        b=r2E0guD+qO9lRdYd1kumnsZXyi2WuxEvkAbKkdb+IOGwM7YTVrz6p7dwj5FQsgRL6D
         DVl7FTtJPeLW9H5wPukaR+/I37Ik8n8VxSGZwD43rQvxRbHDTQ6jkHVrbp6NivqsF6is
         4SCHeenzGf1Pk9XxXE87qgj4MBPqMKFh66lGr+2ECOpC6cRZxzuycwi3SwGrd/BD1UOf
         V97rWLQ7bE22kBtO8Dx9b6IRM4e/7SCFFxsApu8uhwJft9JuNCWjwAHlLNMoyUAXMMn5
         xbq+WJFisaaSc1++JjdoxTIWr06G6qS0X8GB6xSC7oQjYLECcHSyIn7fJVodSdkZRzcg
         eGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683271884; x=1685863884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9/9JuvyVhZw9zXhGtLhH8ui7PtgkXlKB7tdImiMwA0=;
        b=hXbLgBenTcDqxPJHhNKVSOTAFVgvVl90zNAf4BEcBRAn39+K5G83lHI9AQi2PlMHEK
         eQB9sAJJqEDLojACtQxCwmd3XsMEAUzElNC5KSkC9AtQkq35wZX6A9C4L5fq7bRG+0pi
         kTpcQIa2TCRaxRCNKrRfUonIAuqHpCG4BqWLE+e8CCGDla/jmy9ECasUj0IZsCnEuG++
         dAu87b6Oo1QLZKgrp7ESZ9E42cgNSfe9KAaS5lF2ChGOL66zc+joIl4j9wfya7fJoQ3i
         oSmiVsbuJIzRx0NpIeF1pf1qTVECZSSLzoV1JBp/TKnKsfupLDPgQaAt7W+8SPZelLW/
         HyCQ==
X-Gm-Message-State: AC+VfDw+hdXXZZdSQ5oBUGleEE37Q4i8WgC4lDsJd5+rvw2580rTMELf
        THhneHfVTYa0lrRitDK4OuXk8Uw1ilzRklLEFWkYjp7h3sK1xg==
X-Google-Smtp-Source: ACHHUZ6yLdOyngGmryssXxCyXIEWjcacj2Hof9s8R9Xpm2ultlyCiYhP+XUAw8U1Mrbmk1zXriVspefqz0OwkV7Ryaw=
X-Received: by 2002:a67:c403:0:b0:42e:28b2:aa99 with SMTP id
 c3-20020a67c403000000b0042e28b2aa99mr426147vsk.14.1683271884122; Fri, 05 May
 2023 00:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230216044134.30581-1-kev.friedberg@gmail.com>
 <CAEJbB426WWdu5KESE1T+T0JHSKx3CGjUcpdZ5yhppsxyXNJDvw@mail.gmail.com>
 <20230320093545.000016cc@linux.intel.com> <20230428093056.00006ca2@intel.linux.com>
In-Reply-To: <20230428093056.00006ca2@intel.linux.com>
From:   Kevin Friedberg <kev.friedberg@gmail.com>
Date:   Fri, 5 May 2023 03:31:11 -0400
Message-ID: <CAEJbB41BxMdU1bYWAhHh8KLL2_P_M5DCJaDBt3f_YdphmpN4yQ@mail.gmail.com>
Subject: Re: [PATCH] enable RAID for SATA under VMD
To:     Kinga Tanska <kinga.tanska@linux.intel.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Apr 28, 2023 at 3:31=E2=80=AFAM Kinga Tanska
<kinga.tanska@linux.intel.com> wrote:

> Hi,
>
> We've been able to test this change and we haven't found problems.
>
> Regards,
> Kinga

Great!  What are the next steps to get it included in a future release?
