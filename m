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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56DDC63777
	for <linux-raid@archiver.kernel.org>; Thu, 12 Nov 2020 05:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41DF220825
	for <linux-raid@archiver.kernel.org>; Thu, 12 Nov 2020 05:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9sw7lGM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgKLFj1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Nov 2020 00:39:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729221AbgKLFI4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 12 Nov 2020 00:08:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605157733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9AAFh3DR5nR6Lq+NZoziKf6IWM76CqhJxrD0I8GBMM=;
        b=J9sw7lGMi8+vL/R8djp+6ToWQ1y1F/k6gQiNdfJ4L+Iv4LBgdoP5FKvGiUT1bS9e3xS4N4
        LKdSIpozHkaum9LSMvMD4UF9r+R0fACdP1W88xisvFEtbeSiaSOTpScz65pPy9758nDXGY
        qmrnpb1PyB1EqfKAM5WVRh2GxF2QYh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-ODBGAFy1NRaJbRNQgPyq6Q-1; Thu, 12 Nov 2020 00:08:48 -0500
X-MC-Unique: ODBGAFy1NRaJbRNQgPyq6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 084C81074647;
        Thu, 12 Nov 2020 05:08:47 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32E4755766;
        Thu, 12 Nov 2020 05:08:42 +0000 (UTC)
Subject: Re: [PATCH v2] md/cluster: fix deadlock when doing reshape job
To:     Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        song@kernel.org, guoqing.jiang@cloud.ionos.com
Cc:     lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de
References: <1605109898-14258-1-git-send-email-heming.zhao@suse.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <a5b45adc-2db2-3429-49f9-ac3fa82f4c87@redhat.com>
Date:   Thu, 12 Nov 2020 13:08:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1605109898-14258-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/11/2020 11:51 PM, Zhao Heming wrote:
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
> node A & B share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB. The disk
> size is more large the issues are more likely to trigger.
> (more resync time, more easily trigger issues)
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
> Break sending side bock by wait_event_timeout:5s.
>
> Why only break send side, why not break on receive side or both side?
>
> *** send side***
>
> Currently code, sendmsg only fail when __sendmsg return error. (it's
> caused by dlm layer fails.)
>
> After applying patch, there will have new fail cases:
>   5s timeout & return -1.
>
> All related functions:
> resync_bitmap, update_bitmap_size, resync_info_update, remove_disk,
> gather_bitmaps
>
> There is only one function which doesn't care return value: resync_bitmap
> This function is used in leave path. If the msg doesn't send out (5s
> timeout), the result is other nodes won't know the failure event by
> BITMAP_NEEDS_SYNC. But even if missing BITMAP_NEEDS_SYNC, there is another
> api recover_slot(), which is triggered by dlm and do the same job.
>
> So all the sending side related functions are safe to break deadloop.
>
> *** receive side ***
>
> Related function: process_metadata_update
>
> Receive side should do as more as possible to handle incoming msg.
> If there is a 5s timeout code in process_metadata_update, there will
> tigger inconsistent issue.
> e.g.
> A does --faulty, send METADATA_UPDATE to B,
> B receives the msg, but meets 5s timeout. It won't trigger to update
> kernel md info, and will have a gap between kernel memory and disk
> metadata.
>
> So receive side should keep current code.
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
> v2:
> - for clearly, split patch-v1 into two single patch to review.
> - add error handling of remove_disk in hot_remove_disk
> - add error handling of lock_comm in all caller
> - drop 5s timeout patch code in process_metadata_update
> - revise commit log
>
> v1:
> - add cover-letter
> - add more descriptions in commit log
>
> v0:
> - create 2 patches, patch 2/2 is this patch.
>
> ---
>   drivers/md/md-cluster.c | 27 +++++++++++++++++++--------
>   drivers/md/md.c         |  6 ++++--
>   2 files changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 4aaf4820b6f6..06b4c787dd1f 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -701,10 +701,15 @@ static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
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
Hi Heming

Can we handle this problem like metadata_update_start? lock_comm and 
metadata_update_start are two users that
want to get token lock. lock_comm can do the same thing as 
metadata_update_start does. If so, process_recvd_msg
can call md_reload_sb without waiting. All threads can work well when 
the initiated node release token lock. Resync
can send message and clear MD_CLUSTER_SEND_LOCK, then lock_comm can go 
on working. In this way, all threads
work successfully without failure.

>   
>   static void unlock_comm(struct md_cluster_info *cinfo)
> @@ -784,9 +789,11 @@ static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
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
> @@ -1255,7 +1262,10 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
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
> @@ -1407,7 +1417,8 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
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
These codes are not related with this deadlock problem. It's better to 
file a new patch
to fix checking the return value problem.

Best Regards
Xiao

