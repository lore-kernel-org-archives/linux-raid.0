Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5EBC388F9
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 03:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41AAB24694
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 03:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dzGVwEIq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgKQDVS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Nov 2020 22:21:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726146AbgKQDVS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 16 Nov 2020 22:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605583275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TNye6fsY0uuXQnRJgTRdrWPmdJdug9HlEr+buYyVIGo=;
        b=dzGVwEIqQEeWal9ihZyeeKBf2dFG1n9lGhlINN69dk2btZ50txJ6DhF9qwQ5atMhSO12qP
        FoT69OI4cfBiFFzaAp9xC7l8vqIvyPuk/4e56ras7mu+Kjo4EHI2MLDn+LHiBV4v6d2D62
        UVX16ngMAIctrjEJhNFVwJ/UIY/CFVM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-iFkMsf8mOqCbp23jzx2lsA-1; Mon, 16 Nov 2020 22:21:13 -0500
X-MC-Unique: iFkMsf8mOqCbp23jzx2lsA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3553A10074B1;
        Tue, 17 Nov 2020 03:21:12 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 338F06B8E1;
        Tue, 17 Nov 2020 03:21:07 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] md/cluster: fix deadlock when doing reshape job
To:     Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        song@kernel.org, guoqing.jiang@cloud.ionos.com
Cc:     lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de
References: <1605414622-26025-1-git-send-email-heming.zhao@suse.com>
 <1605414622-26025-3-git-send-email-heming.zhao@suse.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <a0127cda-fdaa-1f85-7f68-6e51670dd6bc@redhat.com>
Date:   Tue, 17 Nov 2020 11:21:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1605414622-26025-3-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Heming

For the code part, it's good for me. For the comments part, please modify
as Song's requested.

Reviewed-by: Xiao Ni <xni@redhat.com>

On 11/15/2020 12:30 PM, Zhao Heming wrote:
> There is a similar deadlock in commit 0ba959774e93
> ("md-cluster: use sync way to handle METADATA_UPDATED msg")
> My patch fixed issue is very like commit 0ba959774e93, except <c>.
> 0ba959774e93 step <c> is "update sb", my fix is "mdadm --remove"
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
>   + mddev_lock(mddev) //holding reconfig_mutex, it influnces <d>
>   + hot_remove_disk
>      remove_disk
>       sendmsg //with mddev_locked: true
>        lock_comm
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
> Repro steps:
>
> Test env
>
> node A & B share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB.
>
> Test script
>
> ```
> ssh root@node2 "mdadm -S --scan"
> mdadm -S --scan
> for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
> count=20; done
>
> echo "mdadm create array"
> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh \
>   --bitmap-chunk=1M
> echo "set up array on node2"
> ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"
>
> sleep 5
>
> mkfs.xfs /dev/md0
> mdadm --manage --add /dev/md0 /dev/sdi
> mdadm --wait /dev/md0
> mdadm --grow --raid-devices=3 /dev/md0
>
> mdadm /dev/md0 --fail /dev/sdg
> mdadm /dev/md0 --remove /dev/sdg
> mdadm --grow --raid-devices=2 /dev/md0
> ```
>
> Test result
>
> test script will hung when executing "mdadm --remove".
>
> ```
> node1 # ps axj | grep mdadm
> 1  5423  5227  2231 ?    -1 D   0   0:00 mdadm /dev/md0 --remove /dev/sdg
>
> node1 # cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdi[2] sdh[1] sdg[0](F)
>        1046528 blocks super 1.2 [2/1] [_U]
>        [>....................]  recovery =  0.0% (1/1046528)
> finish=354.0min speed=47K/sec
>        bitmap: 1/1 pages [4KB], 1024KB chunk
>
> unused devices: <none>
>
> node2 # cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdi[2] sdg[0](F) sdh[1]
>        1046528 blocks super 1.2 [2/1] [_U]
>        bitmap: 1/1 pages [4KB], 1024KB chunk
>
> unused devices: <none>
>
> node1 # echo t > /proc/sysrq-trigger
> md0_cluster_rec D    0  5329      2 0x80004000
> Call Trace:
>   __schedule+0x1f6/0x560
>   ? _cond_resched+0x2d/0x40
>   ? schedule+0x4a/0xb0
>   ? process_metadata_update.isra.0+0xdb/0x140 [md_cluster]
>   ? wait_woken+0x80/0x80
>   ? process_recvd_msg+0x113/0x1d0 [md_cluster]
>   ? recv_daemon+0x9e/0x120 [md_cluster]
>   ? md_thread+0x94/0x160 [md_mod]
>   ? wait_woken+0x80/0x80
>   ? md_congested+0x30/0x30 [md_mod]
>   ? kthread+0x115/0x140
>   ? __kthread_bind_mask+0x60/0x60
>   ? ret_from_fork+0x1f/0x40
>
> mdadm           D    0  5423      1 0x00004004
> Call Trace:
>   __schedule+0x1f6/0x560
>   ? __schedule+0x1fe/0x560
>   ? schedule+0x4a/0xb0
>   ? lock_comm.isra.0+0x7b/0xb0 [md_cluster]
>   ? wait_woken+0x80/0x80
>   ? remove_disk+0x4f/0x90 [md_cluster]
>   ? hot_remove_disk+0xb1/0x1b0 [md_mod]
>   ? md_ioctl+0x50c/0xba0 [md_mod]
>   ? wait_woken+0x80/0x80
>   ? blkdev_ioctl+0xa2/0x2a0
>   ? block_ioctl+0x39/0x40
>   ? ksys_ioctl+0x82/0xc0
>   ? __x64_sys_ioctl+0x16/0x20
>   ? do_syscall_64+0x5f/0x150
>   ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> md0_resync      D    0  5425      2 0x80004000
> Call Trace:
>   __schedule+0x1f6/0x560
>   ? schedule+0x4a/0xb0
>   ? dlm_lock_sync+0xa1/0xd0 [md_cluster]
>   ? wait_woken+0x80/0x80
>   ? lock_token+0x2d/0x90 [md_cluster]
>   ? resync_info_update+0x95/0x100 [md_cluster]
>   ? raid1_sync_request+0x7d3/0xa40 [raid1]
>   ? md_do_sync.cold+0x737/0xc8f [md_mod]
>   ? md_thread+0x94/0x160 [md_mod]
>   ? md_congested+0x30/0x30 [md_mod]
>   ? kthread+0x115/0x140
>   ? __kthread_bind_mask+0x60/0x60
>   ? ret_from_fork+0x1f/0x40
> ```
>
> How to fix:
>
> Use the same way of metadata_update_start. lock_comm &
> metadata_update_start are two equal users that want to get token lock.
> lock_comm could do the same steps like metadata_update_start.
> The patch moves setting MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD from
> lock_token to lock_comm. It enlarge a little bit window of
> MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, but it is safe & can break deadlock
> perfectly.
>
> At last, thanks for Xiao's solution.
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>   drivers/md/md-cluster.c | 69 +++++++++++++++++++++++------------------
>   drivers/md/md.c         |  6 ++--
>   2 files changed, 43 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 4aaf4820b6f6..405bcc5d513e 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -664,9 +664,27 @@ static void recv_daemon(struct md_thread *thread)
>    * Takes the lock on the TOKEN lock resource so no other
>    * node can communicate while the operation is underway.
>    */
> -static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
> +static int lock_token(struct md_cluster_info *cinfo)
>   {
> -	int error, set_bit = 0;
> +	int error;
> +
> +	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
> +	if (error) {
> +		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
> +				__func__, __LINE__, error);
> +	} else {
> +		/* Lock the receive sequence */
> +		mutex_lock(&cinfo->recv_mutex);
> +	}
> +	return error;
> +}
> +
> +/* lock_comm()
> + * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
> + */
> +static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
> +{
> +	int rv, set_bit = 0;
>   	struct mddev *mddev = cinfo->mddev;
>   
>   	/*
> @@ -677,34 +695,19 @@ static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
>   	 */
>   	if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
>   				      &cinfo->state)) {
> -		error = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
> +		rv = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
>   					      &cinfo->state);
> -		WARN_ON_ONCE(error);
> +		WARN_ON_ONCE(rv);
>   		md_wakeup_thread(mddev->thread);
>   		set_bit = 1;
>   	}
> -	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
> -	if (set_bit)
> -		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
>   
> -	if (error)
> -		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
> -				__func__, __LINE__, error);
> -
> -	/* Lock the receive sequence */
> -	mutex_lock(&cinfo->recv_mutex);
> -	return error;
> -}
> -
> -/* lock_comm()
> - * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
> - */
> -static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
> -{
>   	wait_event(cinfo->wait,
> -		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
> -
> -	return lock_token(cinfo, mddev_locked);
> +			   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
> +	rv = lock_token(cinfo);
> +	if (set_bit)
> +		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
> +	return rv;
>   }
>   
>   static void unlock_comm(struct md_cluster_info *cinfo)
> @@ -784,9 +787,11 @@ static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
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
> @@ -1061,7 +1066,7 @@ static int metadata_update_start(struct mddev *mddev)
>   		return 0;
>   	}
>   
> -	ret = lock_token(cinfo, 1);
> +	ret = lock_token(cinfo);
>   	clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
>   	return ret;
>   }
> @@ -1255,7 +1260,10 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
>   	int raid_slot = -1;
>   
>   	md_update_sb(mddev, 1);
> -	lock_comm(cinfo, 1);
> +	if (lock_comm(cinfo, 1)) {
> +		pr_err("%s: lock_comm failed\n", __func__);
> +		return;
> +	}
>   
>   	memset(&cmsg, 0, sizeof(cmsg));
>   	cmsg.type = cpu_to_le32(METADATA_UPDATED);
> @@ -1407,7 +1415,8 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
>   	cmsg.type = cpu_to_le32(NEWDISK);
>   	memcpy(cmsg.uuid, uuid, 16);
>   	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
> -	lock_comm(cinfo, 1);
> +	if (lock_comm(cinfo, 1))
> +		return -EAGAIN;
>   	ret = __sendmsg(cinfo, &cmsg);
>   	if (ret) {
>   		unlock_comm(cinfo);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 74280e353b8f..46da165afde2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6948,8 +6948,10 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
>   		goto busy;
>   
>   kick_rdev:
> -	if (mddev_is_clustered(mddev))
> -		md_cluster_ops->remove_disk(mddev, rdev);
> +	if (mddev_is_clustered(mddev)) {
> +		if (md_cluster_ops->remove_disk(mddev, rdev))
> +			goto busy;
> +	}
>   
>   	md_kick_rdev_from_array(rdev);
>   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);

