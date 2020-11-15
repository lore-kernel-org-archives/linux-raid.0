Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD7DC2D0E4
	for <linux-raid@archiver.kernel.org>; Sun, 15 Nov 2020 04:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C3D222D5
	for <linux-raid@archiver.kernel.org>; Sun, 15 Nov 2020 04:39:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rp6d1Ejr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgKOEjf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Nov 2020 23:39:35 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:44951 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbgKOEje (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 14 Nov 2020 23:39:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605415170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBP5+ZChuu82fPlrI8m9q8VFCLNFz5BtKzAgMA+puPo=;
        b=Rp6d1EjrwcO22PRAznmDRd6q7wL/qOvfgc2o+WqnRQXYuGR+BfMf26peuj7g8PDPRZxLgm
        5cb13vc6tGb9B2vSFZYamp5TTX+An5GNq7/joWRofaFUvHNfFbngblvmYYwBOyoHo+eD73
        4gUymKJ+GHlahTEM5KIoK8nocwL1cRw=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2056.outbound.protection.outlook.com [104.47.9.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-HGX-17IzMROInf16QxPKWQ-1;
 Sun, 15 Nov 2020 05:39:28 +0100
X-MC-Unique: HGX-17IzMROInf16QxPKWQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5fzx4JgiJRee0QAeW7BXJ+r29u03eWDuntinJOUhKINCP28Fd4VT6oRhW5z1i362mVL6QWCaX+BBoynLZ5hP0IyZ70AvLYDXgjIZXbZkD8WXMc8dp6g+HWYiwhVfyht3lUJi9i9InXQzFNrKQHfnaA+ab8DRpeU+uvXTXwGcDNkx8p97yMWp7qTOzx66M9mF3nsnl0NAIS4GV0UHSXTAnydeFP5pIk4PPgy6ukJuyKek0FxenWG6Js32BYrTe7Bz+nb1SxBwsuPH2oB7gQ2pm4JlHa7M0rZWkalmLaarFc8iYDq3PV5dH4U2wtyE4k6XJHyCs0ws+JvSuQz9xSQpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBP5+ZChuu82fPlrI8m9q8VFCLNFz5BtKzAgMA+puPo=;
 b=OuRAHXT4wSCJtCDrFp9BILNcN7aIi7y+4CmDEFS3dNw5rwuc9IoT0pfK83OnpfgxqjKpT25KFm8jDak9eNlLxqRv1dhhkBxLuW1xmB1BznTtM1/eMVEWQ4JnbR3R83mUg4wyKzvkRtpfzQB77tgu4wHJoKVi8dXyyiQu3wAA7QNljC7W/v5a1xe/Hh93rlKHo4fzAVc+KXSdudO2k9w/y/v17j6Clo2n1J1iQ2C6h76t/3Oo6lxlpy2bATtJnaTXDl5FkLCFPsaWVm+W5zqSZfIKtJ7CIF8bcCYby3syINjG8dBeqlG6KDpc24oDUhJlqw8wpWWEYScpu2UtqUmXDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB3PR0402MB3948.eurprd04.prod.outlook.com (2603:10a6:8:d::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Sun, 15 Nov 2020 04:39:26 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.025; Sun, 15 Nov 2020
 04:39:26 +0000
Subject: Re: [PATCH v3 2/2] md/cluster: fix deadlock when doing reshape job
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de
References: <1605414622-26025-1-git-send-email-heming.zhao@suse.com>
 <1605414622-26025-3-git-send-email-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <864282f2-4924-2cc3-9c9f-4e0ac1888bf5@suse.com>
Date:   Sun, 15 Nov 2020 12:39:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <1605414622-26025-3-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.135.93]
X-ClientProxiedBy: HK2PR02CA0135.apcprd02.prod.outlook.com
 (2603:1096:202:16::19) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.135.93) by HK2PR02CA0135.apcprd02.prod.outlook.com (2603:1096:202:16::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Sun, 15 Nov 2020 04:39:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52d2627f-4f21-494c-b1e8-08d889206e94
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3948:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB394862432EAFEBA3B29AF59497E40@DB3PR0402MB3948.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yBNzQ33561PLvm/bS5cB7B6+9NVlDE7p0892li6+e626i0X6eykCY/S3HBJ8yaH9N8jF9/rPN2AhZqeE3QKeVTtFE9z4IhD5Xl5i43q763apS+uDJYS3Qhr6uI0bi6dn6xquObMwONGrRA+kUMlkMyegonh8qepZenOiYmZA8HrQ6xXMKFRwVtyDdpk024BSHL27NHxhzEojpQSKf2QK5KIXpnRqGq4MzZruqqkJRLieN/s/WSj3Xd8Lyfpo86u+YFn7HklMVoy779a2tTdOOSr3cMFTnW4wEgBCq7YnwG8S5Tj5dXhau9ijxp35ccgxcnU7pko+IM/0y8wVeEJKx75NCIkDaz7c26e50TcKf58woejkSFvFv4awrd+ERCsYgR0k85bXMFKQ0ZhJe6WNm5VnVUJdGbKG6iiUqJDnNPpIZliRe+p9HJXEHKDnbuHR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(346002)(376002)(39860400002)(31686004)(6666004)(6512007)(478600001)(6486002)(316002)(5660300002)(8886007)(86362001)(36756003)(53546011)(66556008)(31696002)(26005)(4326008)(956004)(2616005)(8936002)(2906002)(16526019)(186003)(83380400001)(8676002)(52116002)(66946007)(6506007)(66476007)(9126006)(43740500002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: U7YiyuMFwxl9/YFB36zf8O0J3y9SsHAQ0vdT7vuJ5aG1lrPSU8akD0Vt/irUb0PwFWGj3R4WPkK5ESHFerWBQZ/qxpsuOh8cDV42G4VPRQU+1d56dvpCcaYglAUEAeKuTA5zSk/pfxnm88xs3e4cMHyTrOkcZveJdKiMa7cAX8Kw6xy0KkoM8aRhvkowT5IeydT2c2ZirhuueQGhc1ZSPGknAOrnppVEZJcHt5odX2Qp+w1g1IsrcgoDl83zog6Cz1ZZHzoSRPdB9RtpCHx02MVN1VFpdSqwmYyQoSusMnakXYe7EMQbMEGf8xLj8GaUASfEwm3pAN/slTL6krCQ5m89ZB+ieg+orsT1jlhOYixkidIMUejvO/WHaQXviqCHY2JxPmQzJLq+h+RIJO1JoqxZmahrTPyp4NdPnK1ZN2vHb3nhklaU36ASgzjolCMlVD4SbEEEzUSGlVvJI5ORxVdKVsXVK+52dk2UfHh05MWREJ4wxDVqwugYK6DMJDlosCyX7V3Lh3n2OfV9en+XuhGJVaAVVqYTt7Kbb4SymwvZNekWpgJSNYAuKC9tQLDnc/3Yr7X6VA2M317VaFR7lIEHE86FwMmX52n9zTMbayOJaWa0khBDN8TP5Hdva2SRY/z/1fQFBxF975M3jCv4RA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d2627f-4f21-494c-b1e8-08d889206e94
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2020 04:39:26.2980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmxkAwv80SoOhTCfTv+u7l+DNNZvwZUl2g5+MpEJQYXckKz159kx8schd5gxb43UZr4CH8Ir02yCeQw6RdRTVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3948
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/15/20 12:30 PM, Zhao Heming wrote:
> ... ...
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
> 

for easy review, I paste key fix code from v3 patch.

legacy code (original upstream code):

```
static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
{
    int error, set_bit = 0;
    struct mddev *mddev = cinfo->mddev;

    /*
     * If resync thread run after raid1d thread, then process_metadata_update
     * could not continue if raid1d held reconfig_mutex (and raid1d is blocked
     * since another node already got EX on Token and waitting the EX of Ack),
     * so let resync wake up thread in case flag is set.
     */
    if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
                      &cinfo->state)) {
        error = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
                          &cinfo->state);
        WARN_ON_ONCE(error);
        md_wakeup_thread(mddev->thread);
        set_bit = 1;
    }
    error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
    if (set_bit)
        clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);

    if (error)
        pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
                __func__, __LINE__, error);

    /* Lock the receive sequence */
    mutex_lock(&cinfo->recv_mutex);
    return error;
}

/* lock_comm()
 * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
 */
static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
{
    wait_event(cinfo->wait,
           !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));

    return lock_token(cinfo, mddev_locked);
}
```

v3 patch:
```
static int lock_token(struct md_cluster_info *cinfo)
{
    int error;

    error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
    if (error) {
        pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
                __func__, __LINE__, error);
    } else {
        /* Lock the receive sequence */
        mutex_lock(&cinfo->recv_mutex);
    }
    return error;
}

/* lock_comm()
 * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
 */
static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
{
    int rv, set_bit = 0;
    struct mddev *mddev = cinfo->mddev;

    /*
     * If resync thread run after raid1d thread, then process_metadata_update
     * could not continue if raid1d held reconfig_mutex (and raid1d is blocked
     * since another node already got EX on Token and waitting the EX of Ack),
     * so let resync wake up thread in case flag is set.
     */
    if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
                      &cinfo->state)) {
        rv = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
                          &cinfo->state);
        WARN_ON_ONCE(rv);
        md_wakeup_thread(mddev->thread);
        set_bit = 1;
    }

    wait_event(cinfo->wait,
               !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
    rv = lock_token(cinfo);
    if (set_bit)
        clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
    return rv;
}
```

