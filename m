Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27029C433ED
	for <linux-raid@archiver.kernel.org>; Sun,  4 Apr 2021 02:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC6F36136A
	for <linux-raid@archiver.kernel.org>; Sun,  4 Apr 2021 02:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbhDDCcs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Apr 2021 22:32:48 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:23261 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236618AbhDDCcr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Apr 2021 22:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617503563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ntfCYgiPznOKbTllP55e0QVzAmBih1yYPppY7Y9Cyv4=;
        b=BxctdTK6MJcMBfHN4CuSHi0e2oT/5alRCwxja5H+FpEWWuRsJquxbKDQoxxc0iEgwi+Sml
        LepNCxsmVS7TX8b/jOcFd+xAO5NsEpPSttn1dup2slxZoc9rx3hIOwecD5pKC6DAZN+zl3
        6iRbwA3ewsoGG+JuOg0CrMOi7tqQDPg=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2052.outbound.protection.outlook.com [104.47.6.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-ZTIfJOMdM128B1vt-ljotg-1; Sun, 04 Apr 2021 04:32:42 +0200
X-MC-Unique: ZTIfJOMdM128B1vt-ljotg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIoaPf8Wk5SK1aagHYwBdVU04aiom+J3JIRzgKfZ8C5qco0TBVehEK5BMFVUT4yIVuCpGyzCEAyrGno5QJgNrMSMpd+q9/aCWUWLUq45H6T8ayRQPYkstkoaxec3eL0x1pyD2fplWzHRdPaGl+/UXTU6Uu6HfQZs9GQSfeW5TSCxM7AsYcwLqAogSAjCB4+Nkjpe+0Zr0Jtq2dPwX9XTVrTCBB1M/p0oG2upXvlsKWEpFXsAvR+fHQFVqv2kDBo+sxbtJA/6hXsBm3vwFG0CXwevTHAu3syIeeT8G7JAMkGEWfkLbSu0FCn0dzqcZLA8VmyZEGM8NF8O/7HG1r4PVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntfCYgiPznOKbTllP55e0QVzAmBih1yYPppY7Y9Cyv4=;
 b=Qy8QFgnOVtgOQ4fmsJuTIVgUrx/HImRRvdGoVtXHSIWlWdSeiZLlH4yMHBBwzAEWAHjHZsbmYOL/JV/P7deoGiG4O9F4jSfHhFFPzi0buR/XqYutyCfcqw9bnhwmtlRMdRbx2ysv1D0ftFXftOfyRsMAQ546qgMMkTCJnmoTKyyDhDCJK26KjuSFm1yoGL4s0GjF8UgdDWaFNyEUmYhE/6U/kZlhpT6jNGQamdrV02b1k297/J23gimfLJRedvYGL9Bh1Ue/hnGqLzdFrNZBqtQ3kKucHZD71eD0rmlsg/p1NDBD2HTbu8JC+wr/pkn2bv685WBx7XxUXLfRfaxtkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBBPR04MB6090.eurprd04.prod.outlook.com (2603:10a6:10:c4::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.26; Sun, 4 Apr 2021 02:32:39 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.029; Sun, 4 Apr 2021
 02:32:39 +0000
Subject: Re: [PATCH 2/2] md: split mddev_find
To:     Christoph Hellwig <hch@lst.de>, song@kernel.org
Cc:     lidong.zhong@suse.com, linux-raid@vger.kernel.org
References: <20210403161529.659555-1-hch@lst.de>
 <20210403161529.659555-3-hch@lst.de>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <ef2a6db9-ff1b-2dc0-a104-56bda46bc5ba@suse.com>
Date:   Sun, 4 Apr 2021 10:32:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210403161529.659555-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.134.184]
X-ClientProxiedBy: HK2P15301CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::25) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.184) by HK2P15301CA0015.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.1 via Frontend Transport; Sun, 4 Apr 2021 02:32:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20a81e31-36ac-4d12-2c22-08d8f711ea13
X-MS-TrafficTypeDiagnostic: DBBPR04MB6090:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB60907CF205E292211A2921D497789@DBBPR04MB6090.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBtnx8JR+cBKAN2gHaoxMcIfYT2jlMiQZUIkACkmvoiEadm8QMcO9p1yy0X2ob7Mrdzb45pu2adcK8mnNJt2lPcm0AjinRXI4PSH8zNe+4KMqXzjquBFfuFK6TTuhfBWGzwEmzqfExrP19263zdpyMNSpJAn4Ra2ZWOGonTtJ+f1RPd2QLmTHYtY5UpYg6XTq5TakSfhdB2tuefF0z+Y1uRnhJuCs5xPxEJiqsScxM4AyRifRRtyZG1Mr1MwVDietfRaZm9RxPR4SVv6boEAzF9AC8YjqnlNAu9LkxBYqUsDu9M0o1ULLHukP9OJwq7ROLX1EJb6p1zwDb0RpF5V436tEPsOcfm0jVG5SZhwEz7j9aiOSVxdHaeAq83ymcHz9PnVWmK3Zv/vam4LAnrWk0T1T6XzaUAvoks0zuMSdx2gqSRpS7Ls1VQpWLAaWowcM1NrawJ0r0uV05EvZd4RW4Vuv5mBppGCsm811Gn0phREuXEj5600TpEIOliK7cvbEAJHTdJzjLXQMYusTopqPbiick/Ozew9/M80k2XqVo+Am/1Aq6dkpK/UhJbasbrW4oZ7Q/v9GHkZ4h9+ZtKJg/cYTRHDRfHq59A+XGZ4GpxrWEJUS8bt+QXN/GsBPGRI8W44RvRLLDmUx6EUYPrSURD2bLz0EtewUSn2cN4uutHamVHx7et/O6I/8Yl+nbSlkFkpbbvRdTas4LWay+ypn8pJgEzYuNBkB0Fqy84guOhiHzWdm/NmLYMpVjYgIn6a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(346002)(376002)(366004)(396003)(6486002)(6512007)(2616005)(478600001)(956004)(6506007)(83380400001)(53546011)(31686004)(8936002)(4326008)(8676002)(316002)(31696002)(38100700001)(52116002)(86362001)(8886007)(5660300002)(16526019)(186003)(26005)(36756003)(6666004)(2906002)(66476007)(66556008)(66946007)(9126006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NDV2SFBORnlPMTV5aWtIbkdjRlF3bGZxUitVSVZNYjhhOTc4ZXNrdnlwNmFK?=
 =?utf-8?B?dGdMZ1d2dGZlNDBOZk9zUkNjMG9kbWR4eGI5L2Z5MmNldG1oUWFxVzJ0QnVw?=
 =?utf-8?B?K1p1dnNSZTkzSjhZb1lZZnN3Q0h5RkMzdDRXTVg5VmwrOEorbE1taUxoOEFL?=
 =?utf-8?B?a2pZa1p6UWg3S01mdG5QZFIyRFRGQXNBZEl5SDJBY0FRclhYVlBCRzZwNEI3?=
 =?utf-8?B?S2lxRUlGamtTVElTNGloWGh5cXlqT29ROW5hcTloR21EY05HdE4yUFE4enh0?=
 =?utf-8?B?WVgxa2ZtUkp2TDk0YlRIU0ZGYmhndG1wYWFOMjA4a243dGg5TFRDenJVdXZl?=
 =?utf-8?B?NDV6c2RCWGw5SldRZXppZDBIbzYyMVZTR1FmUU1PN2F1NnJGa1VoTkovV3R0?=
 =?utf-8?B?UytsYzBFakY3YmFxdjRKUnRlWkZHd0p4U28xU21pc0xueEtobmplOXhFWlhP?=
 =?utf-8?B?dFova2ZWR1I1ZUg1UzJEUi9xUE9xVURxbk12ZWlSK2RDY0VBYXl5S21YY0sz?=
 =?utf-8?B?and3SEFXWVlZYWhGMk96MmhmTkcrMGZEMnMvV2JsSVpXc1IxbjlKS3BDSDEx?=
 =?utf-8?B?d2hDZ3NoUkNBUGU5TUJuVTlwUzQzU2Vqa2hjNFVWVVB1ajJscE5EYnVBY1BM?=
 =?utf-8?B?MDBVWEFkdDFzOW8rclZKa1hRT2UzR0d3VHI1U05CTGV6aVpTZ0kyd2YwQWNh?=
 =?utf-8?B?RUFnTDk2SVlScnJQckhKemt6ai9hODc0S2RwT0JWVmtSbHJMQ3l3b3Q3eHFj?=
 =?utf-8?B?Wjd6RGZVM3JNN05CNWdmbWZsUnJKMWRRYkNkdDEvdFlJMGdURmhSTytSTVA4?=
 =?utf-8?B?ZVJnekdEQkhBYXRKUjJxbGl2bFhkWE1uNTJreFBId1h2VitlN3lqL3dBL25j?=
 =?utf-8?B?ZjdjcU9BMWplNUdpcFFZaEhPM1ZvL0JONUFGbkh1dW1wS1g3S2tnNmMwVGFY?=
 =?utf-8?B?VTcrTXNIbGVEOTBnekNCT1JITC9ld2lvYjVYOWhRWW9wZjRjbjVHYnord0Yx?=
 =?utf-8?B?N3Blekw2a3VaWUhTMjV1RUhvYnRWc2pVdERtWmlxSXRDcldxaDVSRW9zYU9I?=
 =?utf-8?B?dkVhbHUvZWw0NTZ5Nk80eHlmMXpQcm9GRUZTQ0ZGeWhXdlV2ditwOHpzY3FK?=
 =?utf-8?B?eFNhTTY4UXpKWnoyUThXa3d1Q1dMVDNPNlZKNGdhSFlpQ04wRTR3Q2VXQ3Qz?=
 =?utf-8?B?UFo3dnRqRTRoSjhuRGpTdUs5Q3F1dnp5UXlUaERoZ29qZnFrdE5JQ3ZDNHJO?=
 =?utf-8?B?TWZLd1hkY3RaTE9iUXZFbkYxUDhJTUVmQUl2WjRHNVFYVnY5ZFBJQ0xxZVlV?=
 =?utf-8?B?QVNUR1ZoYUZPcFVxM0Q1aDJlRHlmWWEwNy9HcWpDWXRSeDNiWEVCZ2lJWDR1?=
 =?utf-8?B?bFVGVEd4RnJIMnBrR1J0RkRMcnpUYm4yam1DVnBGbUpjQ2N0d0MvVCtPZkVO?=
 =?utf-8?B?OWw1cUdwblVJVTNmWVlDT1hvdXVWVjcrV1kyaWc1QTZpMmp2aXJKM08yZVlF?=
 =?utf-8?B?QkVab0ZOeVl6RnJUZE9BWnpkYWpWa2toS3o3WG1wMDdCQjRlb20yaVNjNHA2?=
 =?utf-8?B?ODB5ckNoRWtBNDF5djdTUC9BUkJ0RTE5VzBiVjZVa0xSZGx4c2IwNWFhSnUy?=
 =?utf-8?B?ZHF3QzMzOThjaHI2ZVFIVGtRakRFUUdkL1JPYXRrdG55WWxibitQakRqbXc5?=
 =?utf-8?B?RTJXRXNLTGk0Q2dxaUV3aHdSN05DeThxTnFFWUFCZWhkRmFIVHlVVVV2enNw?=
 =?utf-8?Q?1q+5PU+bVFr2cTpS8ZzONQ7IFiKsZi/B3Ug0cEU?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a81e31-36ac-4d12-2c22-08d8f711ea13
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2021 02:32:39.1741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9OutLp/qgG0DLrwO7TH2cBEpPRcoieNK241j/TxPqtBBti+4uIEvtjN/yX90H2Y+vUdxICygJPe5Njpo6ftrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6090
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/4/21 12:15 AM, Christoph Hellwig wrote:
> Split mddev_find into a simple mddev_find that just finds an existing
> mddev by the unit number, and a more complicated mddev_find that deals
> with find or allocating a mddev.
> 
> ... ...
> Fixes: d3374825ce57 ("md: make devices disappear when they are no longer needed.")
> Reported-by: Zhao Heming <heming.zhao@suse.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 24 +++++++++++++++++++-----
>   1 file changed, 19 insertions(+), 5 deletions(-)
> 
> ... ...
> @@ -6530,11 +6546,9 @@ static void autorun_devices(int part)
>   
>   		md_probe(dev);
>   		mddev = mddev_find(dev);
> -		if (!mddev || !mddev->gendisk) {
> -			if (mddev)
> -				mddev_put(mddev);
> +		if (!mddev)
>   			break;
> -		}
> +
>   		if (mddev_lock(mddev))
>   			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
>   		else if (mddev->raid_disks || mddev->major_version
> 

autorun_devices use md_probe (when create_on_open is ture) to create mddev & gendisk,
mddev_find is only need to do finding job there.

looks good to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Thanks,
Heming

