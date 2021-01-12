Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DC6C433E6
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 00:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3B0422D6D
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 00:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbhALAht (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhALAhs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Jan 2021 19:37:48 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9970C061575
        for <linux-raid@vger.kernel.org>; Mon, 11 Jan 2021 16:37:07 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 3so457590wmg.4
        for <linux-raid@vger.kernel.org>; Mon, 11 Jan 2021 16:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IkCieQnymAf8hkTcuuBRrqBS0WxMmJCHDZ0WMrtYWTo=;
        b=dfT4LJFNtJwcEeo0IAPU9T6EJkLW+8VTOIu5T6OslW9EIc3krx/13GJ1voxQ0Eo2/6
         2TPyvblIXJw8o9rZkfVqU4qceemGycHinSPwxhqCT8smiFbRe1SLx3iSzHNWB3J8Luj/
         vuk8KsE3QUkWP3NB3dRKj9EIZwoJ2Qyta7aTWB+iRfpxYrDLdD9VeMVSEp1UHV+w4vxX
         9N3FoaKSu8aSRQ1bvnp/h14F7Qdt6SC8NrZrlqkNVPLTsD6sgVjpgdBgsmeDPPQvyoqh
         riNF/oPBKgCKV3S28q4I3EXeYvex0AXuaIKx5gNrb9EOoy8yTtQXf8IEnD6sAHC6r2nL
         J9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IkCieQnymAf8hkTcuuBRrqBS0WxMmJCHDZ0WMrtYWTo=;
        b=db0Ff18l9bxxNMi5Fc701MFBBZVsc0p1v5pbtZjV9IbnN2VN3798p6944YWyTHULOu
         jsuUQ4IQsO7ktqETOUOXDjkaacyd0nTvskzwV6Cr9iJzNlIxHqTgROyHeZmDVFhnUSOz
         mBcRKLy0VyH2srazJ7yxK8aTwTTKIORNGo7FhS2qlkw+eCXMfUnNy9+I6v1fgCbkKyhd
         CsSK2KDayRFr/skn86YJJufWOBxlfx6EpJE7f0ve+zDTEXqJ/rVrFb+OORYhBm8CwofG
         wfdyZ5/8X9EZx1t9wBO3WEs2K84xdvvF1cvVFQEY/XiDCaKFJCvcjZskhA4UuTzHD/io
         cieA==
X-Gm-Message-State: AOAM533hcrKlc2uoX+BCs+4ayb3QaTMZQ+XmiS6CBdK2ZGb1wOrDnGqs
        4sF6wJW13S+mLMxvG8gbcEYhegkNxiIkiw==
X-Google-Smtp-Source: ABdhPJzoRobN1XMhYmPMGCxa24USZNzCk94/N+JjEIEwyo8Kixv6pDjce0j2SZG0m1Ka7G4aAe1xUg==
X-Received: by 2002:a1c:9684:: with SMTP id y126mr1089379wmd.2.1610411826080;
        Mon, 11 Jan 2021 16:37:06 -0800 (PST)
Received: from ?IPv6:240e:304:2c80:9157:bc1a:d197:711d:3085? ([240e:304:2c80:9157:bc1a:d197:711d:3085])
        by smtp.gmail.com with ESMTPSA id v4sm2229456wrw.42.2021.01.11.16.37.04
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 16:37:05 -0800 (PST)
Subject: Re: "md/raid10:md5: sdf: redirecting sector 2979126480 to another
 mirror"
To:     linux-raid@vger.kernel.org
References: <20210106232716.GY3712@bitfolk.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <a5c10248-9835-dec9-2ac2-a72b9a49deff@cloud.ionos.com>
Date:   Tue, 12 Jan 2021 01:36:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210106232716.GY3712@bitfolk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 1/7/21 00:27, Andy Smith wrote:
> Hi,
> 
> "md/raid10:md5: sdf: redirecting sector 2979126480 to another
> mirror"
> 
> I've actually been seeing these messages very occasionally across
> many machines for years but have never found anything wrong so kept
> putting investigation of it to the bottom of my TODO list. I have
> even in the past upon seeing this done a full scrub and check and
> found no issue.
> 
> Having just seen one of them again now, and having some spare time I
> tried to look into it.
> 
> So, this messages comes from here:
> 
>      https://github.com/torvalds/linux/blob/v5.8/drivers/md/raid10.c#L1188
> 
> but under what circumstances does it actually happen?
> 
> This time, as with the other times, I cannot see any indication of
> read error (i.e. no logs of that) and no problems apparent in SMART
> data.
> 
> err_rdev there can only be set inside the block above that starts
> with:
> 
> 
>      if (r10_bio->devs[slot].rdev) {
>          /*
>           * This is an error retry, but we cannot
>           * safely dereference the rdev in the r10_bio,
>           * we must use the one in conf.
> 
> …but why is this an error retry? Nothing was logged so how do I find
> out what the error was?
> 

This is because handle_read_error also calls raid10_read_request, pls 
see commit 545250f2480 ("md/raid10: simplify handle_read_error()").

I guess it is better to distinguish the caller to avoid the normal read 
path prints the message too (if it is the problem).

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1115,7 +1115,7 @@ static void regular_request_wait(struct mddev 
*mddev, struct r10conf *conf,
  }

  static void raid10_read_request(struct mddev *mddev, struct bio *bio,
-                               struct r10bio *r10_bio)
+                               struct r10bio *r10_bio, bool read_err)
  {
         struct r10conf *conf = mddev->private;
         struct bio *read_bio;
@@ -1128,7 +1128,7 @@ static void raid10_read_request(struct mddev 
*mddev, struct bio *bio,
         struct md_rdev *err_rdev = NULL;
         gfp_t gfp = GFP_NOIO;

-       if (slot >= 0 && r10_bio->devs[slot].rdev) {
+       if (read_err && slot >= 0 && r10_bio->devs[slot].rdev) {
                 /*
                  * This is an error retry, but we cannot
                  * safely dereference the rdev in the r10_bio,
@@ -1495,7 +1495,7 @@ static void __make_request(struct mddev *mddev, 
struct bio *bio, int sectors)
         memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);

         if (bio_data_dir(bio) == READ)
-               raid10_read_request(mddev, bio, r10_bio);
+               raid10_read_request(mddev, bio, r10_bio, false);
         else
                 raid10_write_request(mddev, bio, r10_bio);
  }
@@ -2586,7 +2586,7 @@ static void handle_read_error(struct mddev *mddev, 
struct r10bio *r10_bio)
         rdev_dec_pending(rdev, mddev);
         allow_barrier(conf);
         r10_bio->state = 0;
-       raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
+       raid10_read_request(mddev, r10_bio->master_bio, r10_bio, true);
  }

Thanks,
Guoqing
