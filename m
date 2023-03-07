Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0E2C678D5
	for <linux-raid@archiver.kernel.org>; Tue,  7 Mar 2023 09:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjCGJpZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Mar 2023 04:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjCGJpO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Mar 2023 04:45:14 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098FB5BC82
        for <linux-raid@vger.kernel.org>; Tue,  7 Mar 2023 01:45:11 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9FF696002768E;
        Tue,  7 Mar 2023 10:45:09 +0100 (CET)
Message-ID: <9f3c9892-e621-6913-6cd5-eb5d0033bb58@molgen.mpg.de>
Date:   Tue, 7 Mar 2023 10:45:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 09/34] md: else should follow close curly brace [ERROR]
Content-Language: en-US
To:     Heinz Mauelshagen <heinzm@redhat.com>
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com, xni@redhat.com,
        dkeefe@redhat.com
References: <cover.1678136717.git.heinzm@redhat.com>
 <79fbe388f2044498cc63bfdf3138318a6ceb5f5a.1678136717.git.heinzm@redhat.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <79fbe388f2044498cc63bfdf3138318a6ceb5f5a.1678136717.git.heinzm@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Heinz,


Thank you for your patch.

Am 06.03.23 um 22:27 schrieb heinzm@redhat.com:
> From: Heinz Mauelshagen <heinzm@redhat.com>

I’d prefer statements as commit message summary, that means adding a 
verb (in imperative mood):

md: Let else follow close curly brace [ERROR]

> Signed-off-by: heinzm <heinzm@redhat.com>
> ---
>   drivers/md/md-cluster.c | 3 +--
>   drivers/md/md.c         | 3 +--
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 9bcf816b80a1..760b3ba37854 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -548,8 +548,7 @@ static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
>   		set_bit(ClusterRemove, &rdev->flags);
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   		md_wakeup_thread(mddev->thread);
> -	}
> -	else
> +	} else
>   		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n",
>   			__func__, __LINE__, le32_to_cpu(msg->raid_slot));
>   	rcu_read_unlock();
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9dc1df40c52d..ff4699babdd6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9694,8 +9694,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>   					rdev2->bdev);
>   				md_kick_rdev_from_array(rdev2);
>   				continue;
> -			}
> -			else
> +			} else
>   				clear_bit(Candidate, &rdev2->flags);
>   		}

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
