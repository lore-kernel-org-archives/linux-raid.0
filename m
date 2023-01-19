Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C32C00A5A
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 16:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjASQNG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 11:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjASQMx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 11:12:53 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDAF1738
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 08:12:40 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-4a263c4ddbaso34804737b3.0
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 08:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0c2KwWfrLbprAq2rCQdTT/yzTRvuDYOR9r174GzEEn4=;
        b=mnFuGo6llnwnIAGx2uyaREupU1SbNq1X4nz+cgwYTeDJHk738Hf8D/VEpcTvPmjAiI
         uRTN8KAAKUUV4DitLj1bh8s0X33SY8iF8dPwUz4d+Qamffd1/zSJstHcgEUn4j1ang/z
         w2lthBLeoUPXQ5silBi6HtvwqrqOilOwgxSYX9+YgayansBGvK+me/x4QsWEtXb3+Qfz
         bzyi5sgM6peXzckqPdSDV2RpFh+FPIvqlx67ceFK2r9+N5oDRqxriBIi2s7gzDjhfveL
         YWxDNy9/yRfLm5QBqIn4ptj5Nw7QFw3ctyk0cdguvdURgNiyFNQq8EoB+NhyQqB+gO8V
         G3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0c2KwWfrLbprAq2rCQdTT/yzTRvuDYOR9r174GzEEn4=;
        b=soPBA1LkAQ50xaf9i/Hnh7NJ42pAiycej9VwHCu7P7i5Ez0BBqAKOznqoXHA9DuKkz
         cC6dQx0Q1U/Pij82ZTlvlk/G1B8soX2GeRFIV5IsoLvAOG4bW7x9CCkFquzFIOCfeZ0V
         yYTmcMkMWVq4EmLKdSOAQSM/vIpjJ67Nuxe2gsApUhaAtVh6mwc/1jG/7/gQ8POKIcLE
         h4heB87XOLVOdaoowdDhdRnnF1QRHOfF86n1JrxEQ0fN/5fEtc4mCPV8gZp2fAYSZdyX
         LlbzKPA5Hu1mOwBFtsaiKd8KYVZrvqCJMXqIauj82BaQkUU3HKlIDPJM6VeeobV+or5u
         WzIQ==
X-Gm-Message-State: AFqh2kprRnez9EH5m8SNF8/18n6sYauEQdFWjvqNMNyvh3ygPBMPzB2s
        uPsir0LZ8WN3I8mq2ah/+eY1+Q3yORUz221P0gzuuylrGKs=
X-Google-Smtp-Source: AMrXdXsvflZ0ZInWhZo0O5peJGJ75T0hSf9votdbqkiVbRZcJUXISHvyjui4JATgLidMxl+jdahPBqqkFsK/ho6SNTk=
X-Received: by 2002:a0d:f286:0:b0:4dd:a57f:292 with SMTP id
 b128-20020a0df286000000b004dda57f0292mr1522089ywf.501.1674144759365; Thu, 19
 Jan 2023 08:12:39 -0800 (PST)
MIME-Version: 1.0
From:   o1bigtenor <o1bigtenor@gmail.com>
Date:   Thu, 19 Jan 2023 10:12:03 -0600
Message-ID: <CAPpdf599Vr2tEgpmURTbK09uesM6PYYof1ngCFkvAUmcHnowVA@mail.gmail.com>
Subject: Question on sdds
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Greetings

There is smartmontools for testing the health of hdds.

Is there something comparable for sdds?
(Thinking this includes nvme, sdds, usb sticks, m2 listed drives
(is that in this group) or any similar.)

TIA
