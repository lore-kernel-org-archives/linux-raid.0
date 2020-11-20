Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11616C5519F
	for <linux-raid@archiver.kernel.org>; Fri, 20 Nov 2020 13:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92E0422272
	for <linux-raid@archiver.kernel.org>; Fri, 20 Nov 2020 13:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKX+NjEv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgKTNUw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Nov 2020 08:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgKTNUv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Nov 2020 08:20:51 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D310C0613CF
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2020 05:20:51 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id o21so12834619ejb.3
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2020 05:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2JVoeH9W343CY6VYltYsMeilR4GodF+MwsJF6CU6oDE=;
        b=VKX+NjEvGLg61RpBM10pRlFkMCOUTGm81VxIbJQ5Gt1r/Zsq/iFLudLCsHo1bSpyvI
         z3xQ6cm8Wo0MrUneiaswmWPN7mBBkRxAQTN3bkvtUM8W+smnSOpBfQ3q1xNtaRSZK/xM
         5YIbDYoPUgidd/J6ttpjpKuX1sKbMCCcQtFEWfhZs3Ay+Q06o3YXf2SauaPe27Q5z8la
         GWPaNONHyH90VzJytgqP9E0QaSO7OV06tL31C0PTfLvK4MSwuMYP9f/iN8UMWA3zux6l
         1AJ40eeSbA84WM5tN2jtJVgD090oEpdo9nw4WMRghnx4e8kRK8Kk9Hsi8ojLsfmr+6Be
         0s8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2JVoeH9W343CY6VYltYsMeilR4GodF+MwsJF6CU6oDE=;
        b=bs/qrmWRzX+8rd3VLSOSpfNGYRIV5C2QPGJ/1JOy0S7wlahSkRzNO4K2eYBRBtAIoU
         ynIr7G1Xp+c+102pwyZ4qlAk1d7F2K6SBrgQ5qWve/ySn5scDgai/bpKezeQF/RGqZl/
         W+UzC83H3nFFa7WPPD7I9Ywr8CrGlFeO1nkNfFAbakaxNVE21F8U8nOveg/Ah4ySjpQv
         BBr84FLeIHFpdc5fbxyiP6sBJksCeQVTiJ/0gr2/Yo2CXv4nogk+cEX+uVuLtyq3quWi
         TeUsCYYem+BYKmhBbpQLNWrqDvCojv6pT+pqdZAGmq8ZxuH5Ug9EmL78Yxu53fJ8B9hD
         KWZw==
X-Gm-Message-State: AOAM532midLmNm5s7C9MPFoqvJiHkZcowsLA2tXvqyIgBwqDmYpZwKwS
        iDqimUH6NJEqWiRT8Y17XVi4P8yymHYjR8EvVsQ=
X-Google-Smtp-Source: ABdhPJwBRm1ORTalMxyqwf34YMf8hwuzpH2Gdd0oCrQ8TOejAAZsM+1p+VwVBz3IrqB0MrYlpYJGLxb8xZQBhZ93Go4=
X-Received: by 2002:a17:906:e15:: with SMTP id l21mr34072375eji.509.1605878450088;
 Fri, 20 Nov 2020 05:20:50 -0800 (PST)
MIME-Version: 1.0
References: <5EAED86C53DED2479E3E145969315A23856EEA12@UMECHPA7B.easf.csd.disa.mil>
In-Reply-To: <5EAED86C53DED2479E3E145969315A23856EEA12@UMECHPA7B.easf.csd.disa.mil>
From:   Vitaly Mayatskih <v.mayatskih@gmail.com>
Date:   Fri, 20 Nov 2020 08:20:39 -0500
Message-ID: <CAGF4SLiN3C2+PkBd8OqWR5FgNG2RSTPO_EHUSYTyPRD4w7pPAA@mail.gmail.com>
Subject: Re: Nr_requests mdraid
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Nov 16, 2020 at 12:27 PM Finlayson, James M CIV (USA)
<james.m.finlayson4.civ@mail.mil> wrote:

> Thank you for the tip.  My raid5 performance (after creating 32 partition=
s per SSD) and running 64  9+1 (2 in reality) stripes is up to 11.4M 4K ran=
dom read IOPS, out of 17M that the box is capable, which I'm happy with, be=
cause I can't NUMA the raid stripes as I would the individual SSDs themselv=
es.   However, when I perform the RAID0 striping to make the "RAID50 from h=
ell", my performance drops to 7.1M 4K random read IOPS.   Any suggestions? =
 The last RAID50, again won't let me generate the queue depth.

This is something not currently supported for non-blk-mq disks. Best
you could do is to recompile your kernel with a bigger BLKDEV_MAX_RQ.

--=20
wbr, Vitaly
