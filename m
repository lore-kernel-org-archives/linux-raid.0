Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CB1C7115C
	for <linux-raid@archiver.kernel.org>; Fri, 18 Aug 2023 15:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352457AbjHRPaz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Aug 2023 11:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378240AbjHRPak (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Aug 2023 11:30:40 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851324213
        for <linux-raid@vger.kernel.org>; Fri, 18 Aug 2023 08:30:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-68895e1fcc7so241567b3a.1
        for <linux-raid@vger.kernel.org>; Fri, 18 Aug 2023 08:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692372636; x=1692977436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1RNb0ecmY74sWmnc1SPv0PzO7TIw7Mgwb+xVpKXD5NE=;
        b=z0fD8lofrcHrsOn0kCsNRc2auhXGKC1Ya1v3P8qXXIggzeo+4MQhSTeBiEkVD7aSpo
         cgbBN1H8G/5uvDC0YztuTma7PhcmDJnvbExvGE7j6MJwgT3+mcDSlnZrpdr9Lfh2zKkQ
         DgADr1cEYtm4I/ba3Hw8lsPAty/npoK1pmBoMrH1ame+mSoqHtSRz28A73s3LC9cW+Ku
         pcPjLhkM8qK6NTOKjWe9ovNwc8ahjvBN7eZ+KFSYRXKGxWbW6Ms3uktJE+oIRpUb6G63
         +nIzGIJyGMYsRXdv3SgnHtTKqjxUvFeCB1FV56H/5mQbQ4sqGZ4AYwehRubaF/yqJsfD
         /90A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692372636; x=1692977436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1RNb0ecmY74sWmnc1SPv0PzO7TIw7Mgwb+xVpKXD5NE=;
        b=CgmkEsRZ34LC6dUO3ihDwT6T2fWrkHXN5lKZ+5BUXE7RVTHyMA4RrOu/FPd8Gk+0+n
         WUkmMn+sf82jw8MOPw1H5zpyjZgXzxJHTT4JfnNUwPphGW1ZkDHg73VmvMG/Y1Y6PDdg
         SVUamYbuWNLX7T4Vv7AMNn35Jg1+PtOkuyFG4dP//iu5l6/u8s1aAQFXbQtXSLcGnaR8
         7GHXuY9LZDqj1iwvX9YI1K6mTN9XGPdRWZW9AYa9DgP0jPlPTfqudYsweKT05cB0qWEV
         476+b8a2AHiNqH7jBuNZelEkDgrxBASuY/QjI4fuu7qEuNWxhstS2pewGNThcR+U7Q1X
         jHIQ==
X-Gm-Message-State: AOJu0Yya3039AJP0MNaBmJk8rFcTZBpaQUB8mjRr+Xl/DD5G0FUa2lRf
        FDV/ZNVRYm6m+vukhqcWgQCaVQ==
X-Google-Smtp-Source: AGHT+IEuTODbJ0rkN7aK+7gjqAocUDrxeD1pKZPZL4XGdf4SamqQDk81hV79qEPoSCe+WzSbln+EYQ==
X-Received: by 2002:a05:6a00:1c97:b0:686:bf43:60fa with SMTP id y23-20020a056a001c9700b00686bf4360famr3184077pfw.0.1692372635879;
        Fri, 18 Aug 2023 08:30:35 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i3-20020aa787c3000000b0068790c41ca2sm1689299pfo.27.2023.08.18.08.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Aug 2023 08:30:35 -0700 (PDT)
Message-ID: <9766d333-d233-48c3-9b6b-e511d7a094d4@kernel.dk>
Date:   Fri, 18 Aug 2023 09:30:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-next 20230817
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, David Jeffery <djeffery@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Xueshi Hu <xueshi.hu@smartx.com>
References: <F71A83B2-C4A5-4168-915C-546CF34CFF34@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <F71A83B2-C4A5-4168-915C-546CF34CFF34@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/17/23 10:51 PM, Song Liu wrote:
> Hi Jens,
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.6/block branch. The major changes are:
> 
> 1. Fix perf regression for raid0 large sequential writes, by Jan Kara;
> 2. Fix split bio iostat for raid0, by David Jeffery;
> 3. Various raid1 fixes, by Heinz Mauelshagen and Xueshi Hu. 

Pulled, thanks.

-- 
Jens Axboe

