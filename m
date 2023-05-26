Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB37C77B7A
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 06:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242079AbjEZGU7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 02:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjEZGU6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 02:20:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CE0125
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 23:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685082011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QFJlj1BPHkI6/iGAXwI5gohYCvBN/+PCSR6wLLpPDz4=;
        b=ZvUbN2CjhCDElRcsfj/auzya4fcWQIfl7KSmqtpSNin9CrkdJz8gLC67by4iDgkaNXY1jl
        Y9TH4o18FjVrtfi+z1JLCfIL08COOzpu3rG18+fMMAOr/baEKZUGr49nC4o8hSdzTBeCUq
        4Hf6zUG+PWZ/tpH0W7oqEX6hmBdnDKI=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-h8RlqgPkN9aVxEPvVzfjEQ-1; Fri, 26 May 2023 02:20:09 -0400
X-MC-Unique: h8RlqgPkN9aVxEPvVzfjEQ-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-530277cf88bso441735a12.3
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 23:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685082008; x=1687674008;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QFJlj1BPHkI6/iGAXwI5gohYCvBN/+PCSR6wLLpPDz4=;
        b=NIxrUjweDSdRFSJzjlz3mq3Z04rxNnMDZmdZMzff74k8KFg97FEgX6RvFfdQwOVSyw
         aRmPT56oi/AGOTQQNTa7bOaFwXBFz7mRA1fwHHqzxPOg9HBAJv5Y4Qz5WRASCPtEK21+
         w7gdpi9vMrlKPgMT4LmZrveE+Dz0BsrJ41gxuR3eph/UVpeq7EnaZvVrvO84rbC2aIGc
         58bdRu7VWKB2yWAy3kwgZme3hb5bh6AZqKk5YAakv2rFvJMeRlBrXSLCCdgfYPt32DsF
         d5Evcg2xpdaotjt+ZPfBtddJ67ZhcYk4bd8KyevxyvIy+3jSm2gM48glhOLVneGDfitd
         dz3w==
X-Gm-Message-State: AC+VfDxAdc7IzgNrB9K3JEfdFcckfDprRs0c6BGxQjQjVlaiGvEQMqDS
        5QgbsUoqoBVxOCswbOUh50ZhoFj9i/9mrlLUsqLh3ju4DuJNz/qcBAPJVt1HWpd1AU8wo1OeeYp
        LKqNpsAPii6bXNvh6F0zrMrtRWp38e/gz
X-Received: by 2002:a17:902:d2c7:b0:1ae:622c:e754 with SMTP id n7-20020a170902d2c700b001ae622ce754mr1233241plc.68.1685082007960;
        Thu, 25 May 2023 23:20:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4LchfNCfqzYj7Dhk6Sb8MPcdSVoWrnGpp3OKx0cD0soPEwHLed/dyxCg7UEcgz8wVWC6ieww==
X-Received: by 2002:a17:902:d2c7:b0:1ae:622c:e754 with SMTP id n7-20020a170902d2c700b001ae622ce754mr1233231plc.68.1685082007608;
        Thu, 25 May 2023 23:20:07 -0700 (PDT)
Received: from [10.72.13.146] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id iw10-20020a170903044a00b001aaed524541sm2405318plb.227.2023.05.25.23.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 May 2023 23:20:07 -0700 (PDT)
Message-ID: <d8bbed36-2eb6-b80f-8d13-4b92ba02999f@redhat.com>
Date:   Fri, 26 May 2023 14:20:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     d tbsky <tbskyd@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
 <CAC6SzHJc6CquhF=XsqKsjTtRNNvoAymd7LjzqMTn13dkbHzerg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
In-Reply-To: <CAC6SzHJc6CquhF=XsqKsjTtRNNvoAymd7LjzqMTn13dkbHzerg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


在 2023/5/26 上午11:56, d tbsky 写道:
> Xiao Ni <xni@redhat.com>
>> We found a problem recently. The read data is wrong when recovery
>> happens. Now we've found it's introduced by patch 10764815f (md: add
>> io accounting for raid0 and raid5). I can reproduce this 100%. This
>> problem exists in upstream. The test steps are like this:
> sorry for the interruption. but I wonder if any current RHEL version
> has this problem?
> I hope it is safe since I can not find it in bugzilla.
>

Hi

There is a bug https://bugzilla.redhat.com/show_bug.cgi?id=2183033 that 
points this problem.

Regards

Xiao

