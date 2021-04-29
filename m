Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBEAC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 15:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598E561447
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 15:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240734AbhD2Pdb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhD2Pda (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Apr 2021 11:33:30 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBEEC06138B
        for <linux-raid@vger.kernel.org>; Thu, 29 Apr 2021 08:32:41 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id n2so100498870ejy.7
        for <linux-raid@vger.kernel.org>; Thu, 29 Apr 2021 08:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tq1RhUhQsj9uSInBkIDi6ChUUP4BU8aP1qJCG3nl+14=;
        b=BIUBu/MMkmeeK9z7QOnRduoV5wLsM8QsIHJaokf00ojF8Qeg2SmVYK2TK2pW7Khl5I
         9SEMhgzLcrtEUtp+ixELdcvi201mN4cxXydDBbd/UKW8jCqcaqUwx76axq5/49RApDYX
         09Pf6x9BVuRfDh/oebi9BjkEOeL7NuA0heSnF83pAZxHKi+gQ8rbLzQlExm3SjeAV0TX
         boZcTSIY8ckrsqzapR87uqsYjaU0sVqSU8IGCTJgIaFxMtTQEgDE87ANOGlwThHTfs0Q
         exO36gzKi+qnUGYGWwiSICGkI9uIS5CxYM/1XOp0q6njLxPhfG8DvlGu3Sg3brE48BO7
         ONXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tq1RhUhQsj9uSInBkIDi6ChUUP4BU8aP1qJCG3nl+14=;
        b=VZ+efb/fXw5/qsetu/hwx2xPuJ6OEefwIFcQhZticFTz0ShJIzqzOi8282tjHhcRLW
         0oPueh24CeW24KDT04vulO6H5BfGdFb3IvYSjc2VEdQzf0L+h/SWZVQvN9jU6gQNc3JJ
         zhpBo3LUobI/MzLqQVKxiG4j/TGHkLY034tiTRae3g15FN/oc/PvIiF+UTLcqj5pYSgi
         Hn6vcN4JQ+PSFCCDPr8f+Elw1p0AhqzU9BWX70i4QVXwU0tBpvNB5+MG2gJdHePRAa7o
         JC9T8d7NsOkMTTCkDuFdoJZWtMu6Z8l6TwaHt4TYdUwOojKQhH3nc6umbWCEaeZd2J56
         mHNA==
X-Gm-Message-State: AOAM531V2IHz6LJxXPFkuYaXjdOVa6sA6Lyo5pAWflgSIHGriixtZ3vP
        x8P9YFiJm4G1pBhK/quNZA/mAx7LsOVwKu85JbuvW6iCL2Q=
X-Google-Smtp-Source: ABdhPJzI63a50+qogFUsufhn90CgQ7eahBsx4xUL6GyMdd1lwNzsJIz6B9a4Tlh4J+44x9Cjj5mX8p9figuc6zAdKc4=
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr421351ejb.239.1619710360497;
 Thu, 29 Apr 2021 08:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6SzHLDYhQDtfQMYozN6EBYB=nsKvB77hmyByZNr9uTpQH+KQ@mail.gmail.com>
 <7903054.T7Z3S40VBb@matkor-hp>
In-Reply-To: <7903054.T7Z3S40VBb@matkor-hp>
From:   d tbsky <tbskyd@gmail.com>
Date:   Thu, 29 Apr 2021 23:32:29 +0800
Message-ID: <CAC6SzH+JM9EWiB9kQNPaSm8prX-hK3N7D7yzB3Po3nS43fZJ3A@mail.gmail.com>
Subject: Re: add new disk with dd
To:     Mateusz <mateusz-lists@ant.gliwice.pl>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Mateusz <mateusz-lists@ant.gliwice.pl>
> Should in most cases [1], but IMHO it's good idea to
> mdadm --zero-superblock /dev/YOU_ARE_SURE_IS_ONE_YOU_WANT_TO_ADD
> before adding disk already used somewhere else.

   "madam --zero-superblock" is great.  I will add it to my procedure.
   thanks a lot for the hint!

> BTW,  IMHO it's better to clone partition layout, and than install bootloaders
> instead of dding disk.

   yes. but sometimes dd is easy, especially for mbr layout.
anyway I think your suggestion "--zero-superblock" make things safe
with new and old disks.

   thanks again for your kindly help.
