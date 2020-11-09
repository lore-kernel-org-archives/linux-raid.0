Return-Path: <SRS0=Hvl7=EP=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B433C388F9
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 02:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B067206C1
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 02:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="caEwTtTA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgKICCm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 Nov 2020 21:02:42 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:56106 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728006AbgKICCm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 Nov 2020 21:02:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604887358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfC8HzCnHPNdu+s+tcesVDLe4PWn9I4+rlIkrrJ8Gk8=;
        b=caEwTtTA2n7h8FZYkxf+NZovnN2XQADCWxFHU1qdHOMG1apae/Af4O3QfL5beweQtsYAqC
        54uahkwCVZAWn56fdh7dzEqPidt51x/pViOta9/XqNqZpLMpELSHqtvanXcvU6E4JdGcJW
        uQ8Ycd9Mbkr80d0tuKeTC56JeaQCLA8=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-_KjPs2c_Pe2r4csLwEYCng-1; Mon, 09 Nov 2020 03:02:36 +0100
X-MC-Unique: _KjPs2c_Pe2r4csLwEYCng-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbQF3gD0etQx9xz6DtZbtEafjfs9NH1HiGaRAKVhzITTaoHb3wjtuNh0m2meSAEhMyoJt/OJmokYTnTUDk5kvq85hRJjYKmycB60Kd40pRt2tpeQ503Y/+tzU4gjQt3lXsKM0VMBGJEqxSK+tYbc8PeKNMPxywFR1JlqDTdtgTDoUl4W4IXMzYmM817FEb0fTP68Wc1aKT1EhSXPXwLd6L+1hndzqOofwWEOwVyZYm7Oblk5/03RHjPWtU5L9nJI5A98mCvbszrxo+unC/hq7w2NWlgfg/scwCDJ6Y6priigfA53+0M8Xt4/o1CQbFqycxaGmMZcwCyLI1/SMSHfbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfC8HzCnHPNdu+s+tcesVDLe4PWn9I4+rlIkrrJ8Gk8=;
 b=lSnhM7pPZbaeb4mrAyiLyjU2tGoJmSlc27BEYWmEdOKnXNitXn7EG2U4yfHnqSxgfo8YQE8JH+cuGTMW/wl9itgMQ70Q+IIN2/YwE+Br9nlDXmu/Pdqi61q6yFkxEM0hOyGiWdZG07Ovik6RLs5cynkNuw+xP69hJI3P4hTJ4ScVaFJTLDd3Vg44nItqK2iNM+XAkaItydVYQXxyka6DEB/4sUomVpcBcmChdQj5gQ/Gl6BRQaAOhXKAtFD06TheERFgP7VIPSc63ymtYMCGY5TWlkt8z22iBwGEVWjVGe2CcDWEfva43LbsPdoQWpEhYHkxfUo5g5eeQxjrTKp32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBAPR04MB7415.eurprd04.prod.outlook.com (2603:10a6:10:1aa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 02:02:34 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.021; Mon, 9 Nov 2020
 02:02:34 +0000
Subject: Re: [PATCH 2/2] md/cluster: fix deadlock when doing reshape job
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com
Cc:     lidong.zhong@suse.com, xni@redhat.com, neilb@suse.de,
        colyli@suse.de
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
 <1604847181-22086-3-git-send-email-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <6dee90a2-4074-c3fd-a4ec-5e006a236b7a@suse.com>
Date:   Mon, 9 Nov 2020 10:02:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <1604847181-22086-3-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.132.155]
X-ClientProxiedBy: HK2PR02CA0139.apcprd02.prod.outlook.com
 (2603:1096:202:16::23) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.155) by HK2PR02CA0139.apcprd02.prod.outlook.com (2603:1096:202:16::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 02:02:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6910135-9b31-4e53-e95a-08d884538613
X-MS-TrafficTypeDiagnostic: DBAPR04MB7415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7415403924798D59A9263EF197EA0@DBAPR04MB7415.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ipt909IWp4FMBUJ4KlK8FsKRAYPd2EZQ6/Ro7XPsOGwMGOlx5Hn3aA3RvAcdcdfA0iUUlHVGt/xc3OVifBsai2wmvj9H+ygtdzM63NZLJRR79MqzEk+iw7+AwxX+FjaZ+bTafLIUiHZH80hlWW5nDAH2XBVnrEFkHDCjaN7anpVcBA454ivBVUwuDJaOmxmpkEa+Tc36nndqLXOxUGsuwv5UIW/6cVtGbSYlA3/jSXVtQyZMnX8RkAhONEs9+kdLV+kWhjMLaJdS7Hs0xtM/BYT3YipPaWr7gHGWDNjfNUclgAVgAM9afYkUf7pj7B4HQ4T66QZc2levEX8/gNk/GL7F7US1XN1vO7txhqjTJ5/UomJLzuVRZwXkGPQ2CpT2A1gKTyTZLbiHxXy9dnH5rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(376002)(136003)(83380400001)(8936002)(31686004)(6486002)(8886007)(478600001)(186003)(26005)(16526019)(4326008)(6506007)(53546011)(52116002)(6512007)(8676002)(956004)(2616005)(66556008)(66476007)(66946007)(316002)(36756003)(2906002)(86362001)(31696002)(6666004)(5660300002)(9126005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: q9J8wYDT/lsySa6kG0wmhZ+HKpULruNzuegGnrEnxGg8UrUUvcni7q4NPYiTYSrozLOYq4E2/gx7djFoBYypjSWxzwX1GWoNrim300tGnTLZIQGH86SHek8romyhZL6qOdRlNHHaUIDRbguZ0bctQlJNWfKjs7sDrC+0X4QBBFnEJtDSw70pw5fhV3gGVed33zJuGMRMxy2WG1zoUYtRjxvRbPhw4Vpvh3nhiec95ANdPN8IJalRe2qrnxnwesfLqn+MjQQN9BXl9Ek4qiGk56u19jQMUXoJNmwmdPOneyOm1IY9dLrhqawDxoKBVZRN8cSnXtqglt4bHedEc85R3E6Npr2cdCKnE3henwb7798dfmSe8BDmKIvBdTSeip0RnB9+iC1RB6MUgA/+OrJcnOkd5raf3cYCB5vlpuFciTUU78fr2e0qBvJmQR5RpmNBzjmJ/hWs4znYAhwjrMOsSiKu8eWwvrsm5GvgHb6xkE0XzLV6sgD7QR1nBCW1d9Ywh9p4jxY0049inzYTXiYnnrJA9wkyv1fmiosq8EQ/TUDntcYWLsJpH9bXlG/diadgHQ8D27EObVIxpneHF99wlEDfJJmd2D+mZ7SKtKojyGEK7zMN/p/IUNHAt7L3+h27yO5T2Lcdrjg9ZaykCtdmWQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6910135-9b31-4e53-e95a-08d884538613
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 02:02:34.1867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyffX03Zr0vxXWMbaeiOExxmNyReEiUjlrxL4nSappMzu32l8FqX/MT+3IGChBn/pHTEJshdFoeMlBfEjBYyqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7415
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Please note, I gave two solutions for this bug in cover-letter.
This patch uses solution 2. For detail, please check cover-letter.

Thank you.

On 11/8/20 10:53 PM, Zhao Heming wrote:
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
> 

