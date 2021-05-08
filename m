Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1090DC433B4
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 07:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9317611CC
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 07:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhEHHmu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 8 May 2021 03:42:50 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:33933 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhEHHmt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 8 May 2021 03:42:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620459707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+0p9Bujh2H5/iPjdhNynVP8mfALYpaOUiiI0QT7ZTaQ=;
        b=Jh+aetpV2Tp87hSyPssRWGJtTM6/LO6bjeeMbu3CyqsMY3wP++yd+TZazMW39lCskFeP59
        vCCVEbYVqFmZhA0I3SD0lbJlvPArPZsLh+S9dgU2dgKy+YV3d/VGB9wjx2usjMDDcSRx8H
        YQGb19WIzsPwlpwaZ6gf3pyJCBvn3L0=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2050.outbound.protection.outlook.com [104.47.4.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-dTIcTHZ_OQe_D8aT-DL_2Q-1; Sat, 08 May 2021 09:41:46 +0200
X-MC-Unique: dTIcTHZ_OQe_D8aT-DL_2Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYRPYWk5BiBec9zRQzsh+uAiBWfj1GcD4SEHVIBOSA2EaXugqa3lxZwEJ28dFf8SanoOWL/dDh9qfBc+XRnWVeoZSU0d4j+M+zG4LoprUFbXdg5+kQESEf1rE8f08siBcXcV6KYeUG9iFiipJhmpB4tvdSeVB2maH65R7JULloRw2CCzlAytfi2bEK3Wee7TM4CVo/3bMYDoK7fZSDFo1zEZr3C/pNN6qXc0IK9k2KPJRdwp5k7llFjgxp6GSttk9ZOIGTp+6dzGOwU5c2XrBSEckWr7Ha27rGZSPSRy68fp2aWMpxBwMAW4cVAbBkzXHXUA/lIP7S+gsxwZd/PnQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0p9Bujh2H5/iPjdhNynVP8mfALYpaOUiiI0QT7ZTaQ=;
 b=A1nvVb9ITZAOcvfp8XC+hRftBZGmDQTDPKe19alG7kTYybfYEfXuVmK3FZ0zWTUtrZMBv8QZl5u+/9cRi0Kic8DGaxPJprsT16TMn6ck1rDXkTZoqExmnxo8NrjSd8WGc1pW05aMjS/c+AfY0ByQFM0m6uOk9CO/05YGNHrlNide0HCjmgVD+YBbrQuTn/Axx3Qh/wvD1IqdQUaaeg/li8lqN0ed3mUQZV+zy5ne19kQQJHyvgyUsxZ5G0OWAdA9zTlcnzkgFO9uCEAg6W1pm6B25b/scmLeP6p4pRal3iSCcqKzMJEdDKoqomqeff0LjrbJr3SX1/R4or+fITDXeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR0402MB3651.eurprd04.prod.outlook.com (2603:10a6:208:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Sat, 8 May
 2021 07:41:44 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::99c0:486c:b9d7:5740]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::99c0:486c:b9d7:5740%5]) with mapi id 15.20.4108.029; Sat, 8 May 2021
 07:41:44 +0000
Subject: Re: [PATCH] md: adding a new flag MD_DELETING
From:   Zhong Lidong <lidong.zhong@suse.com>
To:     song@kernel.org
References: <20210428082903.14783-1-lidong.zhong@suse.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <8c7a3fc1-eaf8-b67c-d981-29932168295f@suse.com>
Date:   Sat, 8 May 2021 15:41:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210428082903.14783-1-lidong.zhong@suse.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [39.78.183.25]
X-ClientProxiedBy: FR3P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::17) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from l3-laptop.suse (39.78.183.25) by FR3P281CA0011.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Sat, 8 May 2021 07:41:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a80af4cf-09a6-4521-253d-08d911f4ba56
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3651:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3651C528A8A88B282E7C137FF8569@AM0PR0402MB3651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccsSRcCbcUgNWLl8kMOtlui3WhlGxfzfBGWR81GY53HEUHKUP7xd2e96Qx/wh29J5BPwVY8wo5do5CtWImIXdQ4xA3jUvlVfRkHMmIkltl8y0AekVH3mUaO9zS5fc4vXKZ17wUT6tBYttWUAnxIktz0ZR32NyifnwZ68acOyw0v5HbKO07DGRUEuADW/3C4O3LPyaJJmYJgxO2xPCAzLyO+4MryVmgqxdPuFVW4LlGOiiLxXd/2Z0ajqQD9C1vFvrG0x1W43PeQ5TjgMMhSIIMFHrgDJ3sSXrz5IeWAVSSgQuRcyQkNaTZ+hWHUO/Z7DP7SF/o5iGEhNU2WZVUxKfisLnhhnyKgiLB1v3UVpzWFYHnn5RI4nAF7gHX55HbGFxhwOfnaKnMHWDMDEJtuJo74jvTvT2CsWxbyfnKXF2eoFqB31sCKAjQ4w97acRAjpkv/+CZtVvyQKEuR81UheZiDZlRoYoDM7DGYkLsY3YGUKe1zouEzHo2wwS21vWzKNwEuwllQW+r2OXVWKAtPvBHZCTxpaAMxLktvntbvAnoJL5CW3wUTa2IPKuBUnH+ZjYsW4W76ohOIF1zLj51S/vq+CjrWObLbpTEH6vTj0rYHtGjCJesRhBq4BxvASycNe08ApUyD9nNwXp/I8gYGkF2lL/ra+e6z6g4qQFsZAjuIItiFiXbbXun7lPAgCvsNbSJnOERETY9LsA/wI7LqN4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(366004)(39860400002)(38350700002)(16526019)(66476007)(2616005)(5660300002)(86362001)(26005)(31696002)(6512007)(8886007)(8936002)(2906002)(956004)(36756003)(66556008)(6666004)(38100700002)(66946007)(316002)(478600001)(8676002)(52116002)(6506007)(186003)(53546011)(31686004)(6916009)(6486002)(4326008)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?fTykprQo64aW2IbBfnPKXUVjIKQklwhrT3yQjWxiMkkH/c+VX9oUSCK2?=
 =?Windows-1252?Q?Lq09VgjsknpFGg74RgUdgnXe/nu4O8gCYPuzNC1QOQFs7oLRScChbYMe?=
 =?Windows-1252?Q?58qicI86nRdfeX8oTqjLpOSDF/5kmls7Bcj6EnJCPFshKVrq3MO2Zc73?=
 =?Windows-1252?Q?lC5/9HRO6hWjYZrucDCfTxbMqNcIFy5+CBNiZvpKXygCfLy8WLkE9swE?=
 =?Windows-1252?Q?epQcwP4nH1SgSBuA+eNQHlxMeQ2VqdXfS6OxTckO1RCQ4rSMplsyv1vA?=
 =?Windows-1252?Q?6EnGGlDQ07n7LhOSLPHFhdcUpkKz8SfdKIDHVLmmMTzPmJeKLN1Q3mei?=
 =?Windows-1252?Q?22fkD8ACQpwORm+NU6GnJ/EpnMG8UNyo3m2dQjOIsXXcxUelvQ1LoDXQ?=
 =?Windows-1252?Q?/+s0hMJZrNiEGT7A7V0kKLeZ4bXir9ySP8odZY8Y7D2JVL3WYyKe3A/A?=
 =?Windows-1252?Q?kBhmKcajW95cu+Tds9hbAYCTyuGCJYEOioFMZTmhuG1NMGhbzN4eCSPM?=
 =?Windows-1252?Q?0CLqBjKh3pZeZi/crK/YaTQlYHLtsXZS3y1cmczRJmuGUWOTVucDA/d4?=
 =?Windows-1252?Q?Cw825UY1PPaExFy4J2xGmBnh+hnvpn/PCYPwL2c7QJ5SwKnQA0HNI6e7?=
 =?Windows-1252?Q?9wt8NPrSifyui//S4DII0OA8ldsyVTyCBITlfsLwkviM/JcTvwh6n/4R?=
 =?Windows-1252?Q?tYcQLgYk23vqAyaas3RX1xpNg/8k25dktAiRIFOODenTwCcksd4Yg7sh?=
 =?Windows-1252?Q?cLSz0P2wk7BhfFeSc6lMgw2nqGtDZT/qBNCnFApoMc6nRGi+cy84so5f?=
 =?Windows-1252?Q?521AxYnmqHM995l1FIbnpIdBd0yL1STFrIpJi62YcUdBGf5pu/pmWBiE?=
 =?Windows-1252?Q?/o7TVXbrd7nHgc9HqE0lpaqPXNNhCC/UIf5PGnmb27PvBwz/LTAYx5dK?=
 =?Windows-1252?Q?xYijjPagwKXy1aRsQZuU6AUhWX0Ps1iM2H3iZaLO3do+CxHULS1+Q8OT?=
 =?Windows-1252?Q?0C+Az6Jlke6rBPdJo2YTm6QPjr9HSfhveq4Q5i5B66BhXTZQupYBQFQ/?=
 =?Windows-1252?Q?4lxMRiGjI42QmN/N9/seQMalR6GWkMaitimwROTIHE4IqzWeF5xjzF7a?=
 =?Windows-1252?Q?tS6Dm/P1AoyhfB5P78AX9aIdeHc2+2GIBOz9svTpNO1pLqlAZZ9A3050?=
 =?Windows-1252?Q?LKUzj+QadoHb4VAJUcG+LefCF2sEjDnQmRzHGvrV0Dm0iIJnsscHHh+x?=
 =?Windows-1252?Q?lqqAj6H4CMjxBQ5nQeFJBimLpBnOsGoOLVODanLRsqvjXpFjgPsKR5ln?=
 =?Windows-1252?Q?vEJlcMCpNEQTjS9CRpHacw51H0nwo32UsJunGlTCdEUdxvphdOvKk4Is?=
 =?Windows-1252?Q?dXh5xV55cKP7xrZ9Y+ptxEBTgUX/CpHDEUrve6XzU6uHzAP6BwxuiNjh?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80af4cf-09a6-4521-253d-08d911f4ba56
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2021 07:41:44.6845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsJZQKUCF4kw9mKAevx6vJMPcHTVGe3MdJ7r9WkYtw7cazK4EBmUbu4wGndkLBTf9BupbQWtAY3wIOkoZJ6Vxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3651
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

Could you share your opinion about this patch please?

Thanks,
Lidong

On 4/28/21 4:29 PM, Lidong Zhong wrote:
> The mddev data structure is freed in mddev_delayed_delete(), which is
> schedualed after the array is deconfigured completely when stopping. So
> there is a race window between md_open() and do_md_stop(), which leads
> to /dev/mdX can still be opened by userspace even it's not accessible
> any more. As a result, a DeviceDisappeared event will not be able to be
> monitored by mdadm in monitor mode. This patch tries to fix it by adding
> this new flag MD_DELETING.
> 
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
> ---
>  drivers/md/md.c | 4 +++-
>  drivers/md/md.h | 2 ++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 21da0c48f6c2..566df2491318 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6439,6 +6439,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
>  		md_clean(mddev);
>  		if (mddev->hold_active == UNTIL_STOP)
>  			mddev->hold_active = 0;
> +		set_bit(MD_DELETING, &mddev->flags);
>  	}
>  	md_new_event(mddev);
>  	sysfs_notify_dirent_safe(mddev->sysfs_state);
> @@ -7829,7 +7830,8 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>  	if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
>  		goto out;
>  
> -	if (test_bit(MD_CLOSING, &mddev->flags)) {
> +	if (test_bit(MD_CLOSING, &mddev->flags) ||
> +            (test_bit(MD_DELETING, &mddev->flags) && mddev->pers == NULL)) {
>  		mutex_unlock(&mddev->open_mutex);
>  		err = -ENODEV;
>  		goto out;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index bcbba1b5ec4a..83c7aa61699f 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -262,6 +262,8 @@ enum mddev_flags {
>  	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
>  				 * I/O in case an array member is gone/failed.
>  				 */
> +	MD_DELETING,		/* If set, we are deleting the array, do not open
> +				 * it then */
>  };
>  
>  enum mddev_sb_flags {
> 

