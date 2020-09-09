Return-Path: <SRS0=aYZJ=CS=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB18C2BC11
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 01:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58B3C21D6C
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 01:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIIBly (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Sep 2020 21:41:54 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34324 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbgIIBlv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Sep 2020 21:41:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id u13so877930pgh.1;
        Tue, 08 Sep 2020 18:41:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=byR9WnvqpYwL1yow9thkW4L60d0gD846RGIBD/OTG4o=;
        b=XTThqSrdmqc8zg2OfP7GeftMyr5r7OCp4ySHK6ocIk0fmVHAInfjhwfdkLherby85j
         HH+LWbcoByfEEvIbz0+hPSJqlKHIaOoz57+SzdjR4AWE1CJfLd4pV6JaQUTGj5rEN0WY
         hlLLJHEvspDpuum8m43XDRGbUI9URazRwvsrzPMCVsYTiRNRwm+oXLW2acThhVSJnrft
         GGsdVU/X73Ctj6GVoKllxOLPGwHcErEMwW1VKi6A2tdOquYZRr+AtvkPLm1SjdI+I/OR
         KoHt4hYQAdkcga/YxGr75qIthvaTLyy0FyzQFUiTj9uP2fKaa9EmKDTuBB1G4S7pSr9H
         sQcg==
X-Gm-Message-State: AOAM530UUUuq0i68TE/5dq7ODYa8jwOPgBgS8JvrPtbRRqJbFbyR4Yy+
        fWSdHDV2kPijsxQ1s7R7/8hY3f/x82k=
X-Google-Smtp-Source: ABdhPJx7mIO/Z4bJ4JdCzw1dTsyFLFoRaa7yDpRuxRg9O/b/JLqdrjRNUqb3a1ivorAqvh4tnBoiVA==
X-Received: by 2002:a17:902:7c07:: with SMTP id x7mr1347425pll.119.1599615710805;
        Tue, 08 Sep 2020 18:41:50 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:fb09:e536:da63:a7cd? ([2601:647:4000:d7:fb09:e536:da63:a7cd])
        by smtp.gmail.com with ESMTPSA id l19sm627773pff.8.2020.09.08.18.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 18:41:49 -0700 (PDT)
Subject: Re: [PATCH V3 1/3] percpu_ref: add percpu_ref_inited() for MD
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        Veronika Kabatova <vkabatov@redhat.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Sagi Grimberg <sagi@grimberg.me>, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>
References: <20200908012351.1092986-1-ming.lei@redhat.com>
 <20200908012351.1092986-2-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <83765d8a-bae3-41d3-5f35-329727022843@acm.org>
Date:   Tue, 8 Sep 2020 18:41:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200908012351.1092986-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2020-09-07 18:23, Ming Lei wrote:
> +bool percpu_ref_inited(struct percpu_ref *ref)
> +{
> +	return percpu_count_ptr(ref) != NULL;
> +}
> +EXPORT_SYMBOL_GPL(percpu_ref_inited);

Wouldn't percpu_ref_initialized() be a better name?

How about adding kernel-doc documentation?

Thanks,

Bart.
