Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525FBC77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 01:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjE3BhE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 21:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjE3BhD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 21:37:03 -0400
X-Greylist: delayed 2586 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 May 2023 18:37:00 PDT
Received: from out-11.mta0.migadu.com (out-11.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CA9D9
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 18:37:00 -0700 (PDT)
Message-ID: <73b79a2d-95fe-dac0-9afc-8937d723ffdf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685410618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5K9sqJCgffsrxOSbEhjl0+0oxeGnqYIdW8208AD+zCU=;
        b=bxL7skhHMqKdnocY1hlajGhMnSbAqd3YOPwXo7szMo/CRTY522RCV3vsrP2SpmTH0cV+bc
        8wl6RGSKftarWU1azMY8IiO+PE874TPocTwGOwuKKIbWv1orjat0Pq8K3sw33gVNj/uN2L
        hoUDPXjOjjeGc4PQP4rdDgz1hq/N3S0=
Date:   Tue, 30 May 2023 09:36:55 +0800
MIME-Version: 1.0
Subject: Re: The read data is wrong from raid5 when recovery happens
Content-Language: en-US
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
 <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
 <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev>
 <CALTww2_vmryrM1V+Cr8FKj3TRv0qEGjYNzv6nStj=LnM8QKSuw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CALTww2_vmryrM1V+Cr8FKj3TRv0qEGjYNzv6nStj=LnM8QKSuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/29/23 16:40, Xiao Ni wrote:
> It's the data which customers read that can be wrong. So it's a
> dangerous thing. Because customers use the data directly. If it's true
> it looks like there is a race between non aligned read and recovery
> process.

But did you get similar report from customer from the past years? I am not
sure it is reasonable to expect the md5sum should be match under such
conditions (multiple processes do write/read with recovery in progress).

Maybe the test launched 32 processes in parallel is another factor, not sure
it still happens with only 1 process which means only do read after write.

Anyway, I think io accounting is irrelevant.

Thanks,
Guoqing
