Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B795CC77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 02:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjE3CXM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 22:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjE3CXK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 22:23:10 -0400
Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBF9E3
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 19:23:09 -0700 (PDT)
Message-ID: <d3e3ccdf-3384-b302-7266-8996edee4ca8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685413387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FcfQ7O0vVZU4C3cAN0uB0j1XNzDGnKcpnz/KUWzKhK0=;
        b=P8u9wsfMMiQy3CopR9p1ix3kVdzRPU1e9EYPcCKfVU7FC0KY+qdTyyc6r+Zr8la20lJ6Ut
        KG+tpSxcem0ark/0YJH9Acm0Or+GRntde+49+EKkIUvpAB+Tuc03j7UCqltwJozIFw20BR
        mlg6oooYvKyxiFoSQX5xaFhISEEV/8w=
Date:   Tue, 30 May 2023 10:23:03 +0800
MIME-Version: 1.0
Subject: Re: The read data is wrong from raid5 when recovery happens
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
 <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
 <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
 <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
 <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev>
 <CALTww2_vmryrM1V+Cr8FKj3TRv0qEGjYNzv6nStj=LnM8QKSuw@mail.gmail.com>
 <73b79a2d-95fe-dac0-9afc-8937d723ffdf@linux.dev>
 <495541d3-3165-6d4b-f662-3690139229e9@huaweicloud.com>
 <CALTww2_wphLSHV6RAOO05gs0QO8H9di-s_yJRm0b=D7JmjjbUg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CALTww2_wphLSHV6RAOO05gs0QO8H9di-s_yJRm0b=D7JmjjbUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/30/23 10:11, Xiao Ni wrote:
>> May I ask if these processes write the same file with same offset? It's
>> insane if they do... If not, this cound be a problem.
> They write to different files. One process writes to its own file.

How big is the capacity of your array? I see the script write 100G file 
first, then create
different files with 3GB size. So you probably need a array with 200G array.

./01-test.sh:dd if=/dev/zero of=/tmp/pythontest/file1bs=1M count=100000 
status=progress

Thanks,
Guoqing


