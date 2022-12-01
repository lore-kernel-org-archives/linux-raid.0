Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABEFC43217
	for <linux-raid@archiver.kernel.org>; Thu,  1 Dec 2022 19:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiLAT7m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Dec 2022 14:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiLAT7V (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Dec 2022 14:59:21 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FDA1789E
        for <linux-raid@vger.kernel.org>; Thu,  1 Dec 2022 11:58:35 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id jn7so2636242plb.13
        for <linux-raid@vger.kernel.org>; Thu, 01 Dec 2022 11:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bq+cOWmPgTXC5pwruhO47YHph7K/2Z8ctl7GQmiISGA=;
        b=YK1i8LDjuJfxpA7vRElmWC4tHou2pxMcenSPEPxiSCY1cBlblvucLhKQ4ggfYNbT7k
         R5up2Q7dvVmBrOXexmokt2iMYkJ+UK8SdEqiaxfHg50y7ofXnsC1S3VJnJ13s7I0EGjD
         LU9XTOQmrPYCrkQlZ+loK9qOxO4Hrz2MsmuyLULalnJ/jteHWaqSdEBWE5uoLLTvaiYx
         OHWYc2ir7nnd4mEkVUQBr9usi48dZ0z/NLZ4jtHwEtxLfzSf/E/TLpSf+uIayfgSnyQP
         JmrFIl4gMYD410WjqSAIxyZbyl1QjZbgSgFOUn2kzzNoM2hCYpxZQZnkBr6m+nDyflSE
         /l7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bq+cOWmPgTXC5pwruhO47YHph7K/2Z8ctl7GQmiISGA=;
        b=qjtHEWoUefeeh8hU/uiJJ95Ow/96E8rHK8IPnXK8mJXCxRbDxqpiWAyHDEOm5T2eUA
         hA3zIdsCNA5QgWErpqNkHsmNdEF8RneLdvhJTxOqckEcl4tTYfiikffw4a35z/3Eb0lP
         C35H/FAUWVGQOaSaaxXTjGYPrd2O2rx1aP9j/spjFSdSYgmTDIw04Sb79jpJ6xacmika
         JkI6thVksO0ue1ol6SBOJwhyMdEBR8gbaYAQfkoR8jl5/w1xsuDPN6ABk2FnJh2N9k90
         lO6fcRGKo4SaR5sKoFQu+VaeykzseouBUIHk6CeNF/wyOfS/ymZTfqwdPF560CaAYa4V
         cB5w==
X-Gm-Message-State: ANoB5pmgeZcZ7bM7gJINIe8SMyrNmhGzv7iOSmC1NF76ELhso9aMFeyi
        eCkSlwEnbiUAioNCRODUk1P2757ELPgW6C2HzF2MfGCGzX0=
X-Google-Smtp-Source: AA0mqf7OaB1wVNXO0IGvScDR0xm8gc0ZLGuY16IkcjFEN7RHq7ZcrKLBWzXdg8UTfazfdMJWDkYVnM2z9ttuZzk5x5k=
X-Received: by 2002:a17:902:bcc7:b0:188:5c52:83e1 with SMTP id
 o7-20020a170902bcc700b001885c5283e1mr53275109pls.128.1669924714910; Thu, 01
 Dec 2022 11:58:34 -0800 (PST)
MIME-Version: 1.0
From:   Samuel Lopes <samuelblopes@gmail.com>
Date:   Thu, 1 Dec 2022 19:56:39 +0000
Message-ID: <CAA0v=ODquQnpPAO+0nakgR0JO6N5=9qy0mxkRZ+7vKfWggqKdQ@mail.gmail.com>
Subject: Re: Fwd: Recover RAID5
To:     linux-raid@vger.kernel.org, carlos@fisica.ufpr.br
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Carlos, thank you for your reply.

Unless I'm missing something the mdadm -E of each disk shows only my
last attempted information.

To make things worse this is a 4y old array and I added/removed
several disks with different mdadm versions so from what I have been
reading it seems each disk can have a different data-offset value
(correct?).

Also, is there a way to know what was the default data-offset for
different versions of mdadm?

Regards,
Samuel
