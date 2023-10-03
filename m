Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06F7E7545C
	for <linux-raid@archiver.kernel.org>; Tue,  3 Oct 2023 18:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbjJCS1N (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Oct 2023 14:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjJCS1M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Oct 2023 14:27:12 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5BD95
        for <linux-raid@vger.kernel.org>; Tue,  3 Oct 2023 11:27:09 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7a24c86aae3so18339939f.0
        for <linux-raid@vger.kernel.org>; Tue, 03 Oct 2023 11:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696357629; x=1696962429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qBfipitWeRhOKLDcyMbaTtWBr7dtU15Gd1DbyWw24K0=;
        b=MlBgdh6iEkKpoTLw3d1CedPRliEOLYUmZCiLk5iUrE8rxzZ+vj+m6IPSj8nFwtkYFO
         s+92dtP2NcCdVX0gGvBvM/GuMXzs0uhbPEV18+pFEpB3zUk4wc1P1j8hlbh/a7Kqa0mx
         8wXu7OmLEs4QcHqXfJEm76rKw6QI7IMlsMs2vu6o4rLd6/1+iJP/Dv8AbGZRcQoK4gwO
         CrCr58/aoQTF9xcxxAKpiljhXiF9QXgFMQOs9l8dA0r4Ctuej9jddMg3vsCBKvgsmNZZ
         W2WtYzwmB3iKprSR+GIqfyCMsiNa2nEoLuqSYNZ0iDo+Y+4aYAu5YEsoMRZxwOtU+F4D
         xnLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696357629; x=1696962429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBfipitWeRhOKLDcyMbaTtWBr7dtU15Gd1DbyWw24K0=;
        b=kkZO2auSM5xgZeJ8WHkAbnY9DOuLmsWuOCHzlvDdrGEoGROLjAQcSOx9EGR5bgAvLm
         PRpCwYyHJaVHx/N3PHMX2iQYgX+8fcacxIFvKIYOTR/dl++GBEhtxyblfnx43K73cJvF
         3smuXDlP87f0R7+F2ZR63p01NEoXMtxY0x8H56uvG7ApQwyMdl0lWqi2aBGZhDMMZQ5D
         W6gsDQW8UVXG+PdISXsDJL5Kjgf9zf6w5T5oODC8JVHo8mlCizlEcopCjimUZK5F88fB
         xyIz3nZMWZh91tQ71GN/XgKX4oTNC68Gd7oGTZRee5sGpG3HYQi2TZGfsx8En7qQgVKf
         XWig==
X-Gm-Message-State: AOJu0YziC8uCyMiM5/hPPrOLU3moWxUrwYAYEQdTNUlRC2kanLEI7r2W
        xxG45+RAgfhkC20iPDnK+t4ZrXQ+vnM0W1tS+uA=
X-Google-Smtp-Source: AGHT+IECJFsx/v6W8KAeFE5KOYxmbmOBnh7fiv3HEamE2Tpah/5toKz9jVII4vWpi8RdAlqM7yG8zQ==
X-Received: by 2002:a92:d3cb:0:b0:345:e438:7381 with SMTP id c11-20020a92d3cb000000b00345e4387381mr258829ilh.2.1696357628968;
        Tue, 03 Oct 2023 11:27:08 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f7-20020a056638118700b0043a180a7a94sm481720jas.121.2023.10.03.11.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 11:27:08 -0700 (PDT)
Message-ID: <3983b490-0bf2-4def-b3b9-b5a9b3f3cce8@kernel.dk>
Date:   Tue, 3 Oct 2023 12:27:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-fixes 20231003
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     David Jeffery <djeffery@redhat.com>,
        John Pittman <jpittman@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>
References: <FC0B0CA1-11A6-4CA8-B0DD-27F884CCBC95@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <FC0B0CA1-11A6-4CA8-B0DD-27F884CCBC95@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/3/23 11:35 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following commit for md-fixes on top of your
> block-6.6 branch. This change fixes an issue reported by Redhat. 

Pulled, thanks.

-- 
Jens Axboe


