Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBCEC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 01:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240798AbhLNBNB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhLNBNA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Dec 2021 20:13:00 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61178C061574
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 17:13:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id x7so13153295pjn.0
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 17:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=vAC+Rw4a69/rpb5Nh0iBK0RCrPWJInbx41m/jeE6rxQ=;
        b=EIbImRPxS/G9EqGBD7m96Oa/U/ZT9EF670UTLECL/seH1WKE113n/F2RESGQM7VnDv
         RpCRRd9csrkMsiwbh+Vw9FZGhuQB5rVO8GbLL/IbkHaiyH9hkoXkrcviJATh1USTLlH3
         ga9OHG6VkxznlSqq0piisRzBRUXVJNP14RLlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vAC+Rw4a69/rpb5Nh0iBK0RCrPWJInbx41m/jeE6rxQ=;
        b=qUJ/yGdqdmj/yU6oV+icdQYWgqn2bzTgnbPR/x1IyErmlm+8NJ9ruhJHmwXy4eXY6e
         dnKF9jclmYqRXedvO2ZRW9KyD2onAoCnglggP5HfXkI8uVEY/iq9o7qqaPSsomvzk1Ga
         3DO8B/1cnhOMjMqqswO8i5jHTkJWmOcUghEBkDV9dQM5QCvNRf1aMVMWsHMKIfghxWDw
         yCKnA3P7FcHWRLGuMfMOlzVk7Djxs4pbm5dRJ95KrsgSCRg4SMGejvUVUNTZEVv7jKPM
         hYItIMoe/hF/4xO6f3Wf2EzU+kM01t0/6IoAebP40+ItDCgCWxM1LXHHlrnl9ADauKS6
         L9Fw==
X-Gm-Message-State: AOAM531npNehNiK2t128iA3MC5El0kEoT7vjp2QwqVuCqwJr09o2iQZo
        Bk26v9p1RFy//YrqS9y9hLpJ/g==
X-Google-Smtp-Source: ABdhPJyY8LX0bg5exIZukmbesR5sYAMwO/B8Zq1pTblJSWyHQ6Rl9i+6BgstTom/gEDdbigpZw77Aw==
X-Received: by 2002:a17:90a:657:: with SMTP id q23mr1954113pje.21.1639444379858;
        Mon, 13 Dec 2021 17:12:59 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id j1sm14174854pfu.47.2021.12.13.17.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 17:12:59 -0800 (PST)
Message-ID: <255f6109-55ee-a54e-066a-9690da9412ce@digitalocean.com>
Date:   Mon, 13 Dec 2021 18:12:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
 <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
 <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com>
 <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
 <998a933f-e3af-2f2c-79c6-ae5a75f286de@digitalocean.com>
 <b70fded5-8f65-7767-25c1-d45b1dcbbddf@kernel.dk>
 <78d5f029-791e-6d3f-4871-263ec6b5c09b@digitalocean.com>
 <CAPhsuW6VsNPcG3VSLPk-zq16GYp1CN=X0jk9AGveAWaCBLgoig@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW6VsNPcG3VSLPk-zq16GYp1CN=X0jk9AGveAWaCBLgoig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/13/21 6:11 PM, Song Liu wrote:
> On Mon, Dec 13, 2021 at 4:53 PM Vishal Verma <vverma@digitalocean.com> wrote:
> [...]
>> What kernel base are you using for your patches?
>>
>> These were based out of for-5.16-tag (037c50bfb)
> Please rebase on top of md-next branch from here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
>
> Thanks,
> Song
Ack, will do!
