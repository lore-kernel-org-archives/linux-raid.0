Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEA0C3DA7A
	for <linux-raid@archiver.kernel.org>; Fri,  6 Jan 2023 07:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjAFHyG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 Jan 2023 02:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAFHyE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 Jan 2023 02:54:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AFA26DE
        for <linux-raid@vger.kernel.org>; Thu,  5 Jan 2023 23:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672991597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7AXtjSM+Ub9/9ddRJZ7s/pu3qexmGynVkfcj6WVBkqs=;
        b=Rg7VdUbYWrmd0k8PE8DxlGt6PBCGDmxTBjfXwErjHUcvYr5EWCxH8wT1vq9UfdVHXAWdmI
        uSqLfEHUsPdsd61CcoHoFToKSNg45snpbI7+ltZ6MkjHD4uE7ggEURfNMYgHnJ9DbkYnPR
        x3rF4gvJxH3xYTvB1kraPAGt1WEU4eo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-275-_Ozl5ID_OgmQdKft3N7b_Q-1; Fri, 06 Jan 2023 02:53:15 -0500
X-MC-Unique: _Ozl5ID_OgmQdKft3N7b_Q-1
Received: by mail-pf1-f199.google.com with SMTP id x28-20020a056a000bdc00b005826732edb6so493913pfu.22
        for <linux-raid@vger.kernel.org>; Thu, 05 Jan 2023 23:53:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7AXtjSM+Ub9/9ddRJZ7s/pu3qexmGynVkfcj6WVBkqs=;
        b=8Jo9LQpMaelQMLMbryUwGr5n0GujA5t5oRETN3YA66N7iC39cs16VHst59/pNLP0+K
         38bRFyDEkDsc22twjLwqzrU64bxizSj0NwJgZWY/Th+hDojDoOjBvpTx3dIlOCTdIwB8
         Anah03ZU5v1N4NaPDozeEg0fs8wnlW2q5+0CsRrfE8ES5SvZxfDs3UXpl4eakmBkL87k
         h9mx6D0qA7V2jL02sChCE3h5uVPeXlwRrrZO9ndo564jLZcpuaR5b+ITUvTkX/3ZlMCA
         m602su8qJPFnC9iLw2hwYIHlPCHUKEIYYJsCYbx8/Q/iQBmge0z2yiv6JSGN9+HcXEIS
         6p+A==
X-Gm-Message-State: AFqh2krrSHCx76BVUuxbLXfdBwjo5bwtjcyIjDkG+ndXrv4ieQZ9BLAv
        IUMrFcWE+GyUaTRLDaA+I0z4IIPmdusjDlyBJn+D4g9LXMD+vVzQRCJbkLwXL1q7XnSEDuGULfO
        z1oZS3i0Kd9IBfO+JNO7DZg==
X-Received: by 2002:a17:902:b68c:b0:192:4ed3:e919 with SMTP id c12-20020a170902b68c00b001924ed3e919mr55336366pls.34.1672991594019;
        Thu, 05 Jan 2023 23:53:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt9rRbFJSnybS1MEv+chAr4Zt8Yf3lSg+Qx+sZNIHOxF16VtRvdi1fz6egbayauGEZwlPX3Vg==
X-Received: by 2002:a17:902:b68c:b0:192:4ed3:e919 with SMTP id c12-20020a170902b68c00b001924ed3e919mr55336350pls.34.1672991593713;
        Thu, 05 Jan 2023 23:53:13 -0800 (PST)
Received: from [10.72.12.125] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z1-20020a170902ccc100b00192a8d795f3sm260357ple.192.2023.01.05.23.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 23:53:12 -0800 (PST)
Message-ID: <85822a83-f4cc-b699-d589-b6c5590b3f98@redhat.com>
Date:   Fri, 6 Jan 2023 15:53:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH mdadm v6 0/7] Write Zeroes option for Creating Arrays
From:   Xiao Ni <xni@redhat.com>
To:     Logan Gunthorpe <logang@deltatee.com>,
        Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20221123190954.95391-1-logang@deltatee.com>
 <CALTww2_veP=bkpz5Z03VjmF=0dH-D9WqD2+K5A9cBiK5Pb-USg@mail.gmail.com>
In-Reply-To: <CALTww2_veP=bkpz5Z03VjmF=0dH-D9WqD2+K5A9cBiK5Pb-USg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes

Just a reminder about this series of patches.

Regards

Xiao

在 2022/11/24 下午1:38, Xiao Ni 写道:
> On Thu, Nov 24, 2022 at 3:10 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>> Hi,
>>
>> This is the next iteration of the patchset to add a zeroing option
>> which bypasses the inital sync for arrays. This version of the patch
>> set fixes an unitialized variable bug in v5.
>>
>> This patch set adds the --write-zeroes option which will imply
>> --assume-clean and write zeros to the data region in each disk before
>> starting the array. This can take some time so each disk is done in
>> parallel in its own fork. To make the forking code easier to
>> understand this patch set also starts with some cleanup of the
>> existing Create code.
>>
>> We tested write-zeroes requests on a number of modern nvme drives of
>> various manufacturers and found most are not as optimized as the
>> discard path. A couple drives that were tested did not support
>> write-zeroes at all but still performed similarly with the kernel
>> falling back to writing zero pages. Typically we see it take on the
>> order of one minute per 100GB of data zeroed.
>>
>> One reason write-zeroes is slower than discard is that today's NVMe
>> devices only allow about 2MB to be zeroed in one command where as
>> the entire drive can typically be discarded in one command. Partly,
>> this is a limitation of the spec as there are only 16 bits avalaible
>> in the write-zeros command size but drives still don't max this out.
>> Hopefully, in the future this will all be optimized a bit more
>> and this work will be able to take advantage of that.
>>
>> Logan
>>
>> --
>>
>> Changes since v5:
>>     * Ensure 'interrupted' is initialized in wait_for_zero_forks().
>>       (as noticed by Xiao)
>>     * Print a message indicating that the zeroing was interrupted.
>>
>> Changes since v4:
>>     * Handle SIGINT better. Previous versions would leave the zeroing
>>       processes behind after the main thread exitted which would
>>       continue zeroing in the background (possibly for some time).
>>       This version splits the zero fallocate commands up so they can be
>>       interrupted quicker, and intercepts SIGINT in the main thread
>>       to print an appropriate message and wait for the threads
>>       to finish up. (as noticed by Xiao)
>>
>> Changes since v3:
>>     * Store the pid in a local variable instead of the mdinfo struct
>>      (per Mariusz and Xiao)
>>
>> Changes since v2:
>>
>>     * Use write-zeroes instead of discard to zero the disks (per
>>       Martin)
>>     * Due to the time required to zero the disks, each disk is
>>       now done in parallel with separate forks of the process.
>>     * In order to add the forking some refactoring was done on the
>>       Create() function to make it easier to understand
>>     * Added a pr_info() call so that some prints can be done
>>       to stdout instead of stdour (per Mariusz)
>>     * Added KIB_TO_BYTES and SEC_TO_BYTES helpers (per Mariusz)
>>     * Added a test to the mdadm test suite to test the option
>>       works.
>>     * Fixed up how the size and offset are calculated with some
>>       great information from Xiao.
>>
>> Changes since v1:
>>
>>     * Discard the data in the devices later in the create process
>>       while they are already open. This requires treating the
>>       s.discard option the same as the s.assume_clean option.
>>       Per Mariusz.
>>     * A couple other minor cleanup changes from Mariusz.
>>
>> --
>>
>> Logan Gunthorpe (7):
>>    Create: goto abort_locked instead of return 1 in error path
>>    Create: remove safe_mode_delay local variable
>>    Create: Factor out add_disks() helpers
>>    mdadm: Introduce pr_info()
>>    mdadm: Add --write-zeros option for Create
>>    tests/00raid5-zero: Introduce test to exercise --write-zeros.
>>    manpage: Add --write-zeroes option to manpage
>>
>>   Create.c           | 564 +++++++++++++++++++++++++++++++--------------
>>   ReadMe.c           |   2 +
>>   mdadm.8.in         |  16 ++
>>   mdadm.c            |   9 +
>>   mdadm.h            |   7 +
>>   tests/00raid5-zero |  12 +
>>   6 files changed, 435 insertions(+), 175 deletions(-)
>>   create mode 100644 tests/00raid5-zero
>>
>>
>> base-commit: 8b668d4aa3305af5963162b7499b128bd71f8f29
>> --
>> 2.30.2
>>
> For the series, reviewed-by Xiao Ni <xni@redhat.com>

