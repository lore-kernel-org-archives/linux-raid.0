Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C179C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 08:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36B760C40
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 08:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhBQIx4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Feb 2021 03:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBQIxx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Feb 2021 03:53:53 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6722C061574
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 00:53:12 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id n11so2835202uap.10
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 00:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5jOsamckWNjO9AHxBIuLZbQoCQ6fAozjYX66GZLvOB0=;
        b=jTnGrPWsFhJqq+EWqX8IShazDY1r7kYZMv5SfA0GOvEvUD4D/0zaCzBCvEDGtZqUh4
         y1xzu/m9IGFGPx4L7LWy/NjgTkkvS7nQ03JKx8Khv+nrR6S/KgOR/A7N8F/hCYSAqTwW
         asbkGtGE467s9Vzel7uyVvFq89RsI5PUYsWl3AeqYPqw4TbLTe/e5r6IOmNWaBv6FkX/
         m2EA+ECYkrOFqTXs6ymmPTJBw3xa/QnG9hxhwi5lxR4iSeDf8Uk3Cn9hdupAcRUUZwEv
         8ut8J1dg1gt+Xp7ueWrMOD8IhoV6cl4yiWz7Xiv2qh5FIUMaDzYlsyt4VOej/q/+gYYJ
         89eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5jOsamckWNjO9AHxBIuLZbQoCQ6fAozjYX66GZLvOB0=;
        b=ZlmlhCRDPofCR5lHoTRGzsAxe/W+aDMzRL32OCE5L49sfLILClwfMn6YAp9uZu7Ypg
         kdEimYVacstmfJ6U5Rxqpdrn2KFCZTJKznkjQLPbqVl6HckLlScLAYr4wjUd2IHWQNrw
         7r99GJ/ayj6rLx5qL6ZhDw5dtrBdoPSN/IzD/wTCFZNL95UYc6qLiTL2qsKVJhJaxdXS
         Vq17iwl31/dA0F0lvFJ4tVqG6GB8XkRs3Cn8RIgCi/94U3CCYXLJkY6nRXYSR8O6x1RC
         0k9t6YHhqnK7dd7QaptZilQzP2/KmyImtbaN+S9/vcUSU58rmBorA48eF9dV+0DBEnFe
         tyhA==
X-Gm-Message-State: AOAM532FUwIQvZ4/7g1Wis0Dn1bM3WQCMF+AIxHOckT6+oQF8RhG06Rr
        0sWwq8EyrVS7QClZcvMgzSpIIXNbJuRqTL78jWpHYVlMlXY=
X-Google-Smtp-Source: ABdhPJw30EQmsjVzJzO9bc2UkREZ0txSvEo9gQBAswk/P+ihqNpF/j9vwfgMAYW97FOl/sgeR9zLonhWjYfqNQJHVMM=
X-Received: by 2002:ab0:6614:: with SMTP id r20mr13975930uam.68.1613551991171;
 Wed, 17 Feb 2021 00:53:11 -0800 (PST)
MIME-Version: 1.0
References: <CAC6SzHLHq9yX+dtcYwYyhfoTufFYohg_ZMmaSv6-HVt4e-m-hA@mail.gmail.com>
 <20210217110923.62fd685f@natsu>
In-Reply-To: <20210217110923.62fd685f@natsu>
From:   d tbsky <tbskyd@gmail.com>
Date:   Wed, 17 Feb 2021 16:52:59 +0800
Message-ID: <CAC6SzHKj8J9nSAcvtFvAC4o1_iQCEhpY9R5305RA1nzB6bFKPA@mail.gmail.com>
Subject: Re: use ssd as write-journal or lvm-cache?
To:     Roman Mamedov <rm@romanrm.net>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Roman Mamedov <rm@romanrm.net>
>
> On Wed, 17 Feb 2021 11:27:58 +0800
> Why not both? It's not like you have to use the entire SSD for one or the
> other. And it's very unlikely anything will be bottlenecked by concurrent
> access to the SSD from both mechanisms.

   if I use both, then data may write twice to the same ssd, it seems waste.

> Choosing one, I would prefer LVM caching, since it also gives benefit for
> reads. And the mdadm write journal feature sounds[1] more like of a
> reliability, not a performance enhancement.

   at final stage data write to disk with any kind of cache. so if the
data can write to disk with optimized method,
it seems speed up the whole thing. read-cache is fine, but I don't
know how much benefit it will bring.

> In any case, in order to not add a single point of failure to the array,
> better rely not on SSD being a "datacenter" one (anything can fail), but use a
> RAID1 of two SSDs.

   yes raid1 is must. "datacenter" ssd can protect the ssd-cache so it
won't suffer with power outage. so I think I can enable write-back
mode safely.
