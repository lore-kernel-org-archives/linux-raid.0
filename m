Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2731DC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 12 Oct 2022 17:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJLRAT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Oct 2022 13:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiJLRAE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Oct 2022 13:00:04 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B50D9E
        for <linux-raid@vger.kernel.org>; Wed, 12 Oct 2022 09:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=5Dr2oEmE6UnZFK8La87ojFbkgXphKoO6+tb9L1ERD0A=; b=In8ebRrGUhArT9ZOouKg9cWKyP
        YMWGVr3BQOxQaik09nbOzFhnEKNaIofaI+4AJB/aASMeZwNQrFhLGqd10Tp1peTO9KaTwob3XPbkB
        yLf7lixn5zSDFY5YJk2umhU9WrG8oO2sE99Ki5Lmbzq/rj3qeuydQk5p44h4jK6/Gp0xyVjjYVG8u
        YfZp/ln8n5g+eKqEv5gXtFoZhi/rnhMJpS37YiJyNnlWkzuTd1y3z3E4sgZyhg93eucCWH2u5r71v
        juUnY5T482+n2fuZVYkAdbORfKmTD49RH9ieErebpsxxKmhE8kbmlMXhONEjV58rQwclMvWS71EgJ
        7ysy52hA==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oif5A-006czx-D2; Wed, 12 Oct 2022 10:59:50 -0600
Message-ID: <8ee5368c-1808-d2bc-9ad2-2f8332d2704e@deltatee.com>
Date:   Wed, 12 Oct 2022 10:59:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20221007201037.20263-1-logang@deltatee.com>
 <CALTww28HQUPbB647oP9WKvkLX=9PqZv+9am-884zZVM923H-KA@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CALTww28HQUPbB647oP9WKvkLX=9PqZv+9am-884zZVM923H-KA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: xni@redhat.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, martin.petersen@oracle.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v4 0/7] Write Zeroes option for Creating Arrays
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

@ccing Martin hoping he has an opinion on the write zeroes interface

On 2022-10-11 19:09, Xiao Ni wrote:
> Hi Logan
> 
> I did a test with the patchset. There is a problem like this:
> 
> mdadm -CR /dev/md0 -l5 -n3 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme0n1 --write-zero
> mdadm: zeroing data from 135266304 to 960061505536 on: /dev/nvme1n1
> mdadm: zeroing data from 135266304 to 960061505536 on: /dev/nvme2n1
> mdadm: zeroing data from 135266304 to 960061505536 on: /dev/nvme0n1
> 
> I ran ctrl+c when waiting, then the raid can't be created anymore. Because the
> processes that write zero to nvmes are stuck.
> 
> ps auxf | grep mdadm
> root       68764  0.0  0.0   9216  1104 pts/0    S+   21:09   0:00
>          \_ grep --color=auto mdadm
> root       68633  0.1  0.0  27808   336 pts/0    D    21:04   0:00
> mdadm -CR /dev/md0 -l5 -n3 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme0n1
> --write-zero
> root       68634  0.2  0.0  27808   336 pts/0    D    21:04   0:00
> mdadm -CR /dev/md0 -l5 -n3 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme0n1
> --write-zero
> root       68635  0.0  0.0  27808   336 pts/0    D    21:04   0:00
> mdadm -CR /dev/md0 -l5 -n3 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme0n1
> --write-zero

Yes, this is because the fallocate() call that the child processes use
to write_zeros will submit a large number of bios in the kernel and then
wait with submit_bio_wait() which is non-interruptible. So when the
child processes get the SIGINT, they will not stop until after the
fallocate() call completes which will pretty much be after the entire
disk is zeroed. So if you are zeroing a very large disk, those processes
will be stuck around for several minutes after the parent process
terminates; though they do go away eventually.

There aren't many great solutions for this:

1) We could install as signal handler in the parent so it sticks around
until the zeroing is complete. This would mean mdadm will not be able to
be terminated while the zeroing is occurring and the user has to wait.

2) We could split up the fallocate call into multiple calls to zero the
entire disk. This would allow a quicker ctrl-c to occur, however it's
not clear what the best size would be to split it into. Even zeroing 1GB
can take a few seconds, but the smaller we go, the less efficient it
will be if the block layer and devices ever get write-zeroes optimized
in the same way discard has been optimized (with NVMe, discard only
requires a single command to handle the entire disk where as
write-zeroes requires a minimum of one command per 2MB of data to zero).
I was hoping write-zeroes could be made faster in the future, at least
for NVMe.

Thoughts?

Logan
