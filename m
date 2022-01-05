Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD18C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jan 2022 03:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbiAEDHk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Jan 2022 22:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbiAEDHk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Jan 2022 22:07:40 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE1FC061761
        for <linux-raid@vger.kernel.org>; Tue,  4 Jan 2022 19:07:40 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id x10so57477446oix.6
        for <linux-raid@vger.kernel.org>; Tue, 04 Jan 2022 19:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HIVhGwise128DLIwr3R3IQxs77/SwngSfauco86IkTg=;
        b=P7oECmhIFawhtgKU0m+9gNeNrtXaycqFmtkp5A1mFtjZMC1EYEy5v4Yeqq6p2nnXGc
         Jda7AKe/paY2hCb9TVlZRjoPAjcGSdL3QAiJYLbfvHjvEFpN6oSOBMpFN6HF2ES/qJir
         B+mJJdQryjwtDZ3AYC773opQPvC1RlkTwpTfozjhESW3l8vtFqppfdhN3QIotoCIsSSV
         6hdQiTBSbXYfC4gXFOv+VNqcPMNw439G2LuPFZAi9tuXryiXs1lm7fES+m5emUXQsj7Y
         8veAu4TSh9N8Vd6peG0LesmlcuTB3Fi+Gv1jO8a4u8QQVy9fQn+IHVxPVfeAYd4TUeoL
         sPpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HIVhGwise128DLIwr3R3IQxs77/SwngSfauco86IkTg=;
        b=btTFGGeXbl8n6t1dioNkRuqUy7ZuOuyh9NARLlXV643fQnvvlMt1/0WkcSncnaVq/P
         dOTodrJR76dL11kbWPiSPCJQejwuBGV0cTshYyYCLza4epTBM5N1lI6FtyBsF+h9MoFD
         kIaRaYE0hGqkRL5ljmj51cyMa5wKYjDrQYCYD6AdIC9v4tt3w+nd7qi9JOJt8NiHpqX1
         IMoQUtn1GrGeJwU2J36EuTfu8cAUAB47OgvpcxtUvo/tZ7CeWPE26tM5plRJCHTh2FA0
         grQ50u1rC3RwlNBI0XBWBArig1ObSrYT18H+zjezv9sVqeq6+PU9FIDEnLuina3wecu4
         Ol7A==
X-Gm-Message-State: AOAM5312wQd7m3cgi1re1HvlfuE6RamDVn3lecky5bCLzHZDQ8mqCpIp
        XhjfzVLKoMEI2HRMeSQDnYluT6m2m00=
X-Google-Smtp-Source: ABdhPJwIis4kg3W+sxTsWv1Z0ycVSZ96Ufxzul/8ywCIF7pbZBxBeaniYTJVeEALEg7HnHszTZA5Ag==
X-Received: by 2002:a05:6808:1150:: with SMTP id u16mr1064991oiu.74.1641352059323;
        Tue, 04 Jan 2022 19:07:39 -0800 (PST)
Received: from [192.168.0.92] (cpe-70-94-157-206.satx.res.rr.com. [70.94.157.206])
        by smtp.gmail.com with ESMTPSA id k1sm8491007otj.61.2022.01.04.19.07.38
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 19:07:39 -0800 (PST)
Subject: mdadm regression tests fail
From:   Bruce Dubbs <bruce.dubbs@gmail.com>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <c4c17b11-16f4-ef70-5897-02f923907963@gmail.com>
Message-ID: <f6db0bed-2f6c-d98c-c413-583030909700@gmail.com>
Date:   Tue, 4 Jan 2022 21:07:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c4c17b11-16f4-ef70-5897-02f923907963@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I am trying to document the mdadm-4.2 installation procedures for our book,
https://www.linuxfromscratch.org/blfs/view/svn/postlfs/mdadm.html

For testing, I am doing a simple:

    make
    sudo ./test --keep-going --logdir=test-logs --save-logs

But I get failures for about half the tests.

Digging in a bit I just ran:

   sudo ./test --tests=00raid0 --logdir=test-logs

This is the first test that fails.  With some hacking, it appears that the first
portion of this test that fails is:

     mdadm -CR $md0 -e0.90 -l0 -n4 $dev0 $dev1 $dev2 $dev3

This resolves to

     mdadm -CR /dev/md0 -e0.90 -l0 -n4 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3

There is not a lot of error output in the test, so I manually ran:

     dd if=/dev/zero of=/tmp/mdtest0 count=20000 bs=1K
     losetup /dev/loop0 /tmp/mdtest0

For /dev/loop[0123]

Then I ran

     mdadm -CR /dev/md0 -e0.90 -l0 -n4 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
     mdadm: 0.90 metadata does not support layouts for RAID0

My question is whether the regression tests in the tarball are valid for mdadm-4.2?

     -- Bruce Dubbs
        linuxfromscratch.org

Note: The kernel is version 5.15.12.

