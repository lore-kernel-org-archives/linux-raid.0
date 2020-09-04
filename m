Return-Path: <SRS0=BPCQ=CN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573D2C43461
	for <linux-raid@archiver.kernel.org>; Fri,  4 Sep 2020 03:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24764206EF
	for <linux-raid@archiver.kernel.org>; Fri,  4 Sep 2020 03:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="Gvl13sGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgIDDhq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Sep 2020 23:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729655AbgIDDhn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Sep 2020 23:37:43 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4617CC061244
        for <linux-raid@vger.kernel.org>; Thu,  3 Sep 2020 20:37:43 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w7so3869914pfi.4
        for <linux-raid@vger.kernel.org>; Thu, 03 Sep 2020 20:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RDBivT1zfQv0O3iVB+KRFHB0Z59dgs/h1C7x1G/bRQ8=;
        b=Gvl13sGkiYt+EkNaBmsQnTQQrNwK9F/M1oK8igEERO1rl8lk+fB++ydLKH7LDYI9fp
         9tMj+8m9Hm0lQGG/SFu8+7G2WkYFuVKIcKpL6agiUSrTF0vF4aNmC98LBr6qx5JGX6MW
         /pvlwF2kl2pWwQGV1GQHtnKEh2mCwcFrJ5iPmNWJCkTxqfYK1bCea6brlFfvT6uVsSei
         ravUixPdyCXvrMYeG6eIBXIQ4oLAFC/QRpg/v6gxXVFiEmruJG8JEFZoR/IO3h/gazTy
         fQVnZhrmCeJLnBSR0G//MjpZqqy5AJ7nB57+52HAdZgw/BHkV8C67cg3PxjkdQyfeZ0U
         6RAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RDBivT1zfQv0O3iVB+KRFHB0Z59dgs/h1C7x1G/bRQ8=;
        b=K/haC5IqqHf1llMq3asRRgArOmnbDFxIDBa9kE9mkDvaiQmEjPyY5HU7WEZT1cw8h0
         P9RTdLvOC1OC1mGP/+ZI4lrlFWgKrP+Gepuwb09LktKg/oXd7o4PY28ZajqULFs6z33t
         ULDgONYGsGG4Fhgi5XapGvhQ3mnaklMamGvB2LLGCNyGDFw3jchoBuwNtPikMr/DG4yt
         sFfoTMRli/N82ocoydjT+oOjpWoED1RBnM+eEvEWG2rlaCckOjA25ZIsi7OAheHZbmsP
         Wj9e+90He7DUTDFrrpkbniPsWYWRCV/Cn0wFTaBl0Zeb97IIUmS7ODOkho/096v6lG70
         0NKQ==
X-Gm-Message-State: AOAM533GJfbD9Z6uMF4rtzohX4TwuQPJCwmDE39MUtvralcI4CxTESLS
        kDGIUBRKqGymqqZPpUdUr8XOpyvLUSAzugMT
X-Google-Smtp-Source: ABdhPJxI6H8vCMTY72jvIy9YCzPr/cetzerThA6LlK5QwY9XpNx8J88a9rrtyMjyBE8yXoZmhD4hEw==
X-Received: by 2002:a62:5a84:: with SMTP id o126mr6724961pfb.5.1599190662143;
        Thu, 03 Sep 2020 20:37:42 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p68sm4815870pfb.40.2020.09.03.20.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 20:37:41 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=f0=9f=92=a5_PANICKED=3a_Test_report_for_kernel_5?=
 =?UTF-8?Q?=2e9=2e0-rc3-020ad03=2ecki_=28block=29?=
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        linux-block@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
References: <cki.538AE6A321.BMB0X5ZYG5@redhat.com>
 <0f92c40e-b234-896c-0810-af36ee95e259@redhat.com>
 <18db2772-3f37-55a7-d92e-dbcbe92d2cc4@kernel.dk>
 <ad1bf306-6f23-9b7c-842f-766a6efbda3e@redhat.com>
 <1300213431.10047993.1599163090152.JavaMail.zimbra@redhat.com>
 <cc956f4c-9b71-2b02-80be-dd387316dad8@kernel.dk>
 <20200904032244.GA808936@T590>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9066ba15-f60e-50af-719b-691651449cf4@kernel.dk>
Date:   Thu, 3 Sep 2020 21:37:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904032244.GA808936@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/3/20 9:22 PM, Ming Lei wrote:
> It is one MD's bug, and percpu_ref_exit() may be called on one ref not
> initialized via percpu_ref_init(), and the following patch can fix the
> issue:

I really (REALLY) think this should be handled by percpu_ref_exit(), if
it worked before. Otherwise you're just setting yourself up for a world
of pain with other users, and we'll be fixing this fallout for a while.
I don't want to carry that. So let's just make it do the right thing,
needing to do this:

> +       if (mddev->writes_pending.percpu_count_ptr)
> +               percpu_ref_exit(&mddev->writes_pending);

is really nasty.

-- 
Jens Axboe

