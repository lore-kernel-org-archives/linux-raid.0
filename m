Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA73C48BC2
	for <linux-raid@archiver.kernel.org>; Sun, 27 Jun 2021 11:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3E25619B6
	for <linux-raid@archiver.kernel.org>; Sun, 27 Jun 2021 11:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhF0LM1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Jun 2021 07:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhF0LM0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Jun 2021 07:12:26 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A3CC061574
        for <linux-raid@vger.kernel.org>; Sun, 27 Jun 2021 04:10:01 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m2so12744200pgk.7
        for <linux-raid@vger.kernel.org>; Sun, 27 Jun 2021 04:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:in-reply-to:subject:date:message-id:mime-version
         :content-transfer-encoding:content-language:thread-index;
        bh=z6Gz0ZpdJh+z+xHEBPyBPK/kKOzmCAGa72FKj4ztHhQ=;
        b=cZMONAbOrLHmUXzLnU0MJ9QDB1NhnZp2gsS3nPBexWeOV3iRruuYhlM1CndTofxhgt
         ET6tAwChca7R4EjfX+co3l7bUgrxXebm3SHAO86FcxnK8LEozqhgKTj+b6olMIZ6p/vz
         1TqtDHLN1yNzqnHO4KNvXjyu6CnX/SyUEl6ykbntUlJvooXSEDodAGkkgzxdewKMaIuY
         +0yvJwSTG/7bPT4zb03MllJFKkdixvndZagDF20GlUobXViX+cFoLa/IgrA241VGpDFl
         l3hIMXudUogcSDCeSqX+5rUkk74K3RDmfa1HSVdf03KnvcMFD9yeuze4i9X1piKKBf4Z
         kOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=z6Gz0ZpdJh+z+xHEBPyBPK/kKOzmCAGa72FKj4ztHhQ=;
        b=nhmdY6X0XoZ1IE21im7ooSUA2EdlNyoRzNUW6xakLJ1VeKDadBs3cBHV0yjeg2GG/4
         /1gUJl8IlUkkjuGBn8EVJc0SEYDLGTDJjb8QLBweVuTq2RIx/+aJvzB+Va9O9LB4jZHD
         l7mm/cVcG0OcZHR/WTWwNBPH826hW1iHle8JRwwBA3P/pECYVWoRMISYzZO42XX8g0NX
         k8aM5SKyc32IMIokqSIBdKthjM2qRivzqen6ASNP5j4kkmkQ/gAM9yPAuOdZdlpZ7Fyr
         VPjw95OJaVSARrpYP97ZF1+VZMDnAcAbiIFiReFlVPAyBQnzDjOME6Gi6SHkqC9drEZw
         lVBw==
X-Gm-Message-State: AOAM531xPa7Z6C3y5VPyjckwMq815nMq6y8YsKdGHD24MkOiQoqzi6lm
        Y4zghyYex9j32qaWFGGeGaR6t1dIU96HchgL
X-Google-Smtp-Source: ABdhPJzq7hHvkco2Qzzi3ojW/D/Hy9GvZlF7fzwzx7dRIjDwK6RyvSvZ3Vh8a+HJWtthg9NuJgFEqg==
X-Received: by 2002:a63:f009:: with SMTP id k9mr18439125pgh.356.1624792201214;
        Sun, 27 Jun 2021 04:10:01 -0700 (PDT)
Received: from EdgarII ([58.164.17.235])
        by smtp.gmail.com with ESMTPSA id p38sm9410633pfh.151.2021.06.27.04.09.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jun 2021 04:10:00 -0700 (PDT)
From:   "Jason Flood" <3mu5555@gmail.com>
To:     "'Phil Turmel'" <philip@turmel.org>,
        "'antlists'" <antlists@youngman.org.uk>,
        <linux-raid@vger.kernel.org>
References: <007601d769ba$ced0e870$6c72b950$@gmail.com> <6d412bf3-a7b9-1f08-2da9-96d34d8f112b@turmel.org> <00f101d76a7b$bdb3fc50$391bf4f0$@gmail.com> <df60eb5f-b1c0-b3f8-4985-3cb8d9dcc531@youngman.org.uk> <011e281f-7ea3-9491-29fd-5e1574aa5819@turmel.org>
In-Reply-To: <011e281f-7ea3-9491-29fd-5e1574aa5819@turmel.org>
Subject: RE: 4-disk RAID6 (non-standard layout) normalise hung, now all disks spare
Date:   Sun, 27 Jun 2021 21:09:57 +1000
Message-ID: <004b01d76b44$f8ff7b80$eafe7280$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-au
Thread-Index: AQGNx8sXAjFFTjp8y/bre2t4Ys80RwKF0iigAf62j18BY1FllAI3KL+zq3n7xDA=
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good morning Phil, Wol,

> So force was sufficient to assemble.  But you are still stuck at 99%.

> Look at the output of ps to see if mdmon is still running (that is the =
background process that actually reshapes stripe by stripe).  If not, =
look in your logs for clues as to why it died.

> If you can't find anything significant, the next step would be to =
backup the currently functioning array to another system/drive =
collection and start from scratch.  I wouldn't trust anything else with =
the information available.

> Phil

Will do, thanks. I have a few assignments due next weekend so I may not =
be able to report back for a week.

> ps.  Convention on kernel.org mailing lists is to NOT top-post, and to =
trim unnecessary context.

Sorry. First time on a mailing list since well before Outlook was =
invented!

Thanks again, Phil and Wol.

