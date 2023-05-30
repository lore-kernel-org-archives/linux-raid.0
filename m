Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D82FC77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 00:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjE3AyG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 20:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjE3AyA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 20:54:00 -0400
Received: from out-63.mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEDDDB
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 17:53:56 -0700 (PDT)
Message-ID: <5cc6370a-1207-9b15-87c0-b817fa6b1b95@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685408032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=raewohYXruiak00wZe+WsMm/a95EGX7SMG8dQ3QdRoQ=;
        b=sXHeIqqGHitFlieys+Gtqj82wqENk71iHV40TOaEfbHMEUdKjl8q6Wog1ol9oARGH+LmWI
        Tul3pp5VBqBOuz2Nn/5KimyjWxFVOW5wtkfRdBPVQFTT5H5S2uGubOGA3HynUkD+o+b+7j
        +r4RD09ItMxBPxpeVNDerPV+PUunNUo=
Date:   Tue, 30 May 2023 08:53:44 +0800
MIME-Version: 1.0
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Xiao Ni <xni@redhat.com>
Cc:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
 <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
 <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
 <CALTww29N5-WFKH9JG8yzcYyHy5v+5D-NR2jd=fe5fG6tAF2_-w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CALTww29N5-WFKH9JG8yzcYyHy5v+5D-NR2jd=fe5fG6tAF2_-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/29/23 21:51, Xiao Ni wrote:
> I can reproduce this after setting /sys/block/md126/queue/iostats to
> 0. But if I comment md_account_bio, this can't be reproduced. If
> setting iostats to 0, md_account_bio only checks the bit
> QUEUE_FLAG_IO_STAT of the request queue of md126.

I don't get why the issue can't be reproduced after comment md_acount_bio
out manually, the only difference between it and disable iostats is that 
chunk
aligned read bio still record time.

> In chunk_aligned_read, it can split the original bio and returns the
> split bio if it can't do the align read. Are there problems in this
> case?

Not sure.

Thanks,
Guoqing

