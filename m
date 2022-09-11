Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CF3ECAAA1
	for <linux-raid@archiver.kernel.org>; Sun, 11 Sep 2022 11:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiIKLgL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Sep 2022 07:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiIKLgI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 11 Sep 2022 07:36:08 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C5836DDD
        for <linux-raid@vger.kernel.org>; Sun, 11 Sep 2022 04:36:06 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id x10so7437350ljq.4
        for <linux-raid@vger.kernel.org>; Sun, 11 Sep 2022 04:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=mGRuhu0M/cDXEak5SFcr8UabzAc35oG4qt55lav4BvY=;
        b=IgihWEaL44pgU/Z2rJ/5XsB8k8HwmzEG57G6sCPGrESHDV/MVCx2zqxmxHUKf4kyJ1
         9bTzMJOPh/enbCS8InFo0UVlqGen+knIghCFhBzwo8KydX57vNLCl5aL14UeJXzyKsvL
         Ue4hFXeSMNL5iW7pVLGN2jbkfE61NcSw4bW/GE74D+biEBuPztpZ+OLcEN3vpj7Tm+V9
         Dx4UBoBeOaYpK6jy+7PoHP95zUHEWprOlSzzP/Fj28j5KS1f0l+nBaVjjSiHJ0xBhy67
         dutAPMfa15peKxnIAqRgSz05WxdDQhO719kM9uLylNwIToC4INx8xRCBWWxj35gzJsEA
         HjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=mGRuhu0M/cDXEak5SFcr8UabzAc35oG4qt55lav4BvY=;
        b=AD2Dlge/CuMGKZcn0kn2bICN8qWOMXLMMIj+71hpjve/pJcVgnjolYxV8jBHvWAHS+
         wa9NPMuRnNhQy2QwucSTK9X8lrOTLzqwCXQquC+YkC/hMuHpfqyWktie4uwPa+h6Cn8s
         HZ6uu2nIOLyWbzGISQBY0N/iusfnPY2++saVgE6xHZixPbcBzpW9MAviho1Fsp4gxEvu
         LtACTnUoFnzlz/e0Dh0AVXPXy+1BkjqssoYtJaGIhya5bEbeW6cUVf8Yz/UKfksy5y+t
         hBJpVcCVA8l/U73WJUiG/T2jXrzWHu1mPbCkDNCiJkCnbhy2/S5ttF+kOm4bk6y4X/C+
         TVAw==
X-Gm-Message-State: ACgBeo2U3NcI12iYfGJ+WJWbeRPVBCgDlAjU0Gku8AkL3y2QCsbj0JO+
        N6KZBEwZcqYtKxeANrap05gkYGTiAyAdEAfPWeqx4bRi
X-Google-Smtp-Source: AA6agR6e4SHBsV6ptxG/em7hEG0fWrvBGuXZZ+zEaG0MgUyKi6Sy8Dt31K6pzMRUWUNNewdsslzsMREq22nVx3TC9Bs=
X-Received: by 2002:a2e:a550:0:b0:25f:9ae6:e40f with SMTP id
 e16-20020a2ea550000000b0025f9ae6e40fmr6601944ljn.408.1662896165245; Sun, 11
 Sep 2022 04:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <53f5754d-e3e2-a8ba-bedb-07eb2b594595@thelounge.net>
In-Reply-To: <53f5754d-e3e2-a8ba-bedb-07eb2b594595@thelounge.net>
From:   Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date:   Sun, 11 Sep 2022 13:35:51 +0200
Message-ID: <CAJH6TXi=pCvV2xcyWcOD4KVDP6BcoPdgdMqhSwyW9BMVEhtzYA@mail.gmail.com>
Subject: Re: 3 way mirror
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Il giorno dom 11 set 2022 alle ore 12:52 Reindl Harald
<h.reindl@thelounge.net> ha scritto:
> just throw it out of the array - on a RAID 1 with two disk you have
> still redundancy and i won't trust a disk which recognized that it has
> errors on it's own

Why ? if it's just a single sector, the rest of the disk could be used
properly until the replacement.

> what's the point of "can i delay" when you have no other options? :-)

The option is: i've ordered the new disk, it should arrive this thursday.
If i'm still on the safe side, i'll wait, if not, i'll replace with
the first disk I have here, even if slower
