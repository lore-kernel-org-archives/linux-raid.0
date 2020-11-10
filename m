Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B4FC388F7
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 06:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DDDD20829
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 06:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="PgHNKpfi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgKJGgi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 Nov 2020 01:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgKJGgi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 Nov 2020 01:36:38 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BA5C0613CF
        for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2020 22:36:38 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x13so10474531pfa.9
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2020 22:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hrqG/vW5zVZR2thr/1Bq9B1rYNsSFM2r2IaP0oqIbEk=;
        b=PgHNKpfiiqpGy54kyD4m2naCiklgpST9AHsma1LsWZd9fiETl5Lq7hPbXsmnueFBLS
         GkiqCWd95hSA0ndOKMKoN9zoYUkkmT0pwZsVbLwOLudoh/+8E37AyHd3vxbM3LtjAkXo
         9PlBHIo7FI6IfZWxJ3LNyV39E6o921g3O7essk2jAsq7c3usADnsPev0Fc+XStF1k7nh
         3NKcKexBtSBwDMFdhiLmrLLkE6ugzIVgENOxqatl86xfa3Nz0XXY2VzOYM/gRLEOvzez
         yhZBJa+qdshxOvV+9VbszisXmM97nzpmZ4/8ARQFVHKRHWAqADJAO1Jqh8svjny02OMV
         Cbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hrqG/vW5zVZR2thr/1Bq9B1rYNsSFM2r2IaP0oqIbEk=;
        b=YDcQiRmMl/RO/0Qt7acPp85XtkamjEn0U/2TC+KDlgPb9iL/gYYGj0oAOPFJtGdpMD
         ZsaW6P+z2g0pGQTMV2JrVmuB+FlrXJV+JLEtvo1RAzPWxazb75Pd/9Mbr2ykq3n3h7h8
         KiV16Q8BO91ECVZnhrPlRT8/qbtZJUdOe5X9PTiUNMwpWhT3KgXsvHDdwShdxi/Uhh3J
         fVvfcMpcSnTI3YkFlyX4admVdNDphDYbT4iJd7bbwi8oaHWL9AxKkuc3VgRQVgzpgM4g
         1wBEL39nqFM7NHbAvsZX7TZZj1ksfVjaA+uBDw8BnDYLP0MrDuuyBLMGN6ZNsr4cmPVu
         +WtA==
X-Gm-Message-State: AOAM532mKE/SoFHOrUxtWLuchHLZJqHrGEORwFNWLdxgMk9w7lLHup1v
        WicG8RnVor5sJWIiOeRW/wpceA==
X-Google-Smtp-Source: ABdhPJzQBEZnF6WGxSQAxHtD1KKJmIdQJgFZ16WoySEUUnEPYZcHhxrgVYQ/y/Lat+Y2uZTORt8XVg==
X-Received: by 2002:a63:1845:: with SMTP id 5mr486976pgy.393.1604990196350;
        Mon, 09 Nov 2020 22:36:36 -0800 (PST)
Received: from ?IPv6:240e:82:3:dd3e:4104:46a1:91e1:ec2f? ([240e:82:3:dd3e:4104:46a1:91e1:ec2f])
        by smtp.gmail.com with ESMTPSA id p19sm1745437pjv.32.2020.11.09.22.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 22:36:35 -0800 (PST)
Subject: Re: [PATCH 2/2] md/cluster: fix deadlock when doing reshape job
To:     Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        song@kernel.org
Cc:     lidong.zhong@suse.com, xni@redhat.com, neilb@suse.de,
        colyli@suse.de
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
 <1604847181-22086-3-git-send-email-heming.zhao@suse.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <b6ef581d-2eaf-37d3-7a21-a91630b0836c@cloud.ionos.com>
Date:   Tue, 10 Nov 2020 07:36:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1604847181-22086-3-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/8/20 15:53, Zhao Heming wrote:
> There is a similar deadlock in commit 0ba959774e93
> ("md-cluster: use sync way to handle METADATA_UPDATED msg")
> 
> This issue is very like 0ba959774e93, except <c>.
> 0ba959774e93 step c is "update sb", this issue is "mdadm --remove"
> 
> ```
> nodeA                       nodeB
> --------------------     --------------------
> a.
> send METADATA_UPDATED
> held token_lockres:EX
>                           b.
>                           md_do_sync
>                            resync_info_update
>                              send RESYNCING
>                               + set MD_CLUSTER_SEND_LOCK
>                               + wait for holding token_lockres:EX
> 
>                           c.
>                           mdadm /dev/md0 --remove /dev/sdg
>                            + held reconfig_mutex
>                            + send REMOVE
>                               + wait_event(MD_CLUSTER_SEND_LOCK)
> 
>                           d.
>                           recv_daemon //METADATA_UPDATED from A
>                            process_metadata_update
>                             + (mddev_trylock(mddev) ||
>                                MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD)
>                               //this time, both return false forever.
> ```
> 
> Explaination:
> 
> a>
> A send METADATA_UPDATED
> this will block all other nodes to send msg in cluster.
> 
> b>
> B does sync jobs, so it will send RESYNCING at intervals.
> this will be block for holding token_lockres:EX lock.
> ```
> md_do_sync
>   raid1_sync_request
>    resync_info_update
>     sendmsg //with mddev_locked: false
>      lock_comm
>       + wait_event(cinfo->wait,
>       |    !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
>       + lock_token //for step<a>, block holding EX lock
>          + dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX); // blocking
> ```
> c>
> B do "--remove" action and will send REMOVE.
> this will be blocked by step <b>: MD_CLUSTER_SEND_LOCK is 1.
> ```
> md_ioctl
> + mddev_lock(mddev) //holding reconfig_mutex, it influnces <d>
> + hot_remove_disk
>     remove_disk
>      sendmsg
>       lock_comm
>         wait_event(cinfo->wait,
>           !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));//blocking
> ```
> d>
> B recv METADATA_UPDATED msg which send from A in step <a>.
> this will be blocked by step <c>: holding mddev lock, it makes
> wait_event can't hold mddev lock. (btw,
> MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD keep ZERO in this scenario.)
> ```
> process_metadata_update
>    wait_event(mddev->thread->wqueue,
>          (got_lock = mddev_trylock(mddev)) ||
>          test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state));
> ```
> 
> How to fix:
> 
> There are two sides to fix (or break the dead loop):
> 1. on sending msg side, modify lock_comm, change it to return
>     success/failed.
>     This will make mdadm cmd return error when lock_comm is timeout.
> 2. on receiving msg side, process_metadata_update need to add error
>     handling.
>     currently, other msg types won't trigger error or error doesn't need
>     to return sender. So only process_metadata_update need to modify.
> 
> Ether of 1 & 2 can fix the hunging issue, but I prefer fix on both side.

It's better if you put the deadlock information (such as the 'D' task 
stack) to the header.

> 
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>   drivers/md/md-cluster.c | 42 ++++++++++++++++++++++++++---------------
>   1 file changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 4aaf4820b6f6..d59a033e7589 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -523,19 +523,24 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
>   }
>   
>   
> -static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
> +static int process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
>   {
> -	int got_lock = 0;
> +	int got_lock = 0, rv;
>   	struct md_cluster_info *cinfo = mddev->cluster_info;
>   	mddev->good_device_nr = le32_to_cpu(msg->raid_slot);
>   
>   	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
> -	wait_event(mddev->thread->wqueue,
> -		   (got_lock = mddev_trylock(mddev)) ||
> -		    test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state));
> -	md_reload_sb(mddev, mddev->good_device_nr);
> -	if (got_lock)
> -		mddev_unlock(mddev);
> +	rv = wait_event_timeout(mddev->thread->wqueue,
> +			   (got_lock = mddev_trylock(mddev)) ||
> +			   test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state),
> +			   msecs_to_jiffies(5000));
> +	if (rv) {
> +		md_reload_sb(mddev, mddev->good_device_nr);
> +		if (got_lock)
> +			mddev_unlock(mddev);
> +		return 0;
> +	}
> +	return -1;
>   }
>   
>   static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
> @@ -578,7 +583,7 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
>   		return -1;
>   	switch (le32_to_cpu(msg->type)) {
>   	case METADATA_UPDATED:
> -		process_metadata_update(mddev, msg);
> +		ret = process_metadata_update(mddev, msg);
>   		break;
>   	case CHANGE_CAPACITY:
>   		set_capacity(mddev->gendisk, mddev->array_sectors);
> @@ -701,10 +706,15 @@ static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
>    */
>   static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
>   {
> -	wait_event(cinfo->wait,
> -		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
> +	int rv;
>   
> -	return lock_token(cinfo, mddev_locked);
> +	rv = wait_event_timeout(cinfo->wait,
> +			   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state),
> +			   msecs_to_jiffies(5000));
> +	if (rv)
> +		return lock_token(cinfo, mddev_locked);
> +	else
> +		return -1;
>   }
>   
>   static void unlock_comm(struct md_cluster_info *cinfo)
> @@ -784,9 +794,11 @@ static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
>   {
>   	int ret;
>   
> -	lock_comm(cinfo, mddev_locked);
> -	ret = __sendmsg(cinfo, cmsg);
> -	unlock_comm(cinfo);
> +	ret = lock_comm(cinfo, mddev_locked);
> +	if (!ret) {
> +		ret = __sendmsg(cinfo, cmsg);
> +		unlock_comm(cinfo);
> +	}
>   	return ret;
>   }
>   

What happens if the cluster has latency issue? Let's say, node normally 
can't get lock during the 5s window. IOW, is the timeout value justified
well?

Thanks,
Guoqing
