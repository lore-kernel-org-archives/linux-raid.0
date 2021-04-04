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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55157C433B4
	for <linux-raid@archiver.kernel.org>; Sun,  4 Apr 2021 02:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BCB660200
	for <linux-raid@archiver.kernel.org>; Sun,  4 Apr 2021 02:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbhDDCYx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Apr 2021 22:24:53 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20070 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236618AbhDDCYw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Apr 2021 22:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617503088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s4Cj7p8738v9Oqp5KKH9UGrwJ6O8+jnIDdA4zfY/YwU=;
        b=LOSMTxjroxXSLJSCsLdb9KJHyZdB18j1IZo7H7CAcg4oQzEP5BPA9CU2xx1EBxIUz3Sry+
        cqhen5JFrTPmWYmy3+VzghNCnGYPa+dwcqo1lbEWu1hyZaH6qcuu7+cTj0aziXrRlIE5zq
        MyMIR1Ea2bW09g39HAz6sr+GPk9iCf4=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2057.outbound.protection.outlook.com [104.47.4.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-mGk5eBPnOT6H40Dj4_C1lw-1; Sun, 04 Apr 2021 04:24:46 +0200
X-MC-Unique: mGk5eBPnOT6H40Dj4_C1lw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9sW4J6KguQDYq0IE7US6gh66GPcov/xsjXV2Q8Kd6XNl0NAyFP3/tTcfJ5GJpFuZijTBy7kXqRwoy4ICKtIH7nZ41+JtGrriXMLuVfpOILhohy8R1IX7rUHZ2qYalAbpzG5/TEjuvIFYs0633kVrvLHCXTfGQTuq9fMp+zk7qiRRoNsETLVZAiwC/XbR2cit3Xl0asSxTExciFaQXw2A5wfetqyd9mhqOHAXFPai2bxub/9WEefN4gwDlgG72pMGsYhM1GVJ7XjdELglL37AshyyatnbLUu9b5mUbbNFkxU0INUonstczwxK58LekwS/Ahl6tWfajeKkS+ujVfPIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4Cj7p8738v9Oqp5KKH9UGrwJ6O8+jnIDdA4zfY/YwU=;
 b=dTLVl1YNA9YuihpnfW5ioqsQzQjUshFtGM/QK2MzHqIQ5KYViZ4HFCeXCjl+NvWlk4aHwWKjYy5Mwhcq+oFcWlAbLjG2BkT1cwmBJNCXXGjKSP/1OgRaWdqmb5QjNg1uUoo6lKfs4TeRfZuUTBoF98w+gORBaSYQSGmItIb/klgkTAruT3pEPxV13mS8vZbN1Ys/A6QZiMUFHaAi2aIhf7pRZF3zMmHpi+1t9/pNe5qC0zCeO3SmNmRTg0FXO3hdeREFikeisXCUqwE1PYv5lfGkLbLuZWb4h0YdrY5LVngIEcHi5QZj3FJuLl3ZVUUN/o/UE1ijawieOxAubEaklA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB3PR0402MB3834.eurprd04.prod.outlook.com (2603:10a6:8:e::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Sun, 4 Apr 2021 02:24:45 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.029; Sun, 4 Apr 2021
 02:24:45 +0000
Subject: Re: [PATCH 1/2] md: factor out a mddev_find_locked helper from
 mddev_find
To:     Christoph Hellwig <hch@lst.de>, song@kernel.org
Cc:     lidong.zhong@suse.com, linux-raid@vger.kernel.org
References: <20210403161529.659555-1-hch@lst.de>
 <20210403161529.659555-2-hch@lst.de>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <b46903ee-c64d-85ba-5a89-7acdf29dc10b@suse.com>
Date:   Sun, 4 Apr 2021 10:24:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210403161529.659555-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.134.184]
X-ClientProxiedBy: HK0PR03CA0111.apcprd03.prod.outlook.com
 (2603:1096:203:b0::27) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.184) by HK0PR03CA0111.apcprd03.prod.outlook.com (2603:1096:203:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Sun, 4 Apr 2021 02:24:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23ebdc66-e81d-4b2d-1dbc-08d8f710cfb4
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3834C447257C627F7905CE7797789@DB3PR0402MB3834.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KnZszUrtJwFhapRau3LNPUIqE90APB14i6ab1OAz1PB/JX3qE3Xx//ImegXGxLgHhraZW08cgp1DUF7sinWb0mlfr3VqTlWRCaUUZ9lAS/7nfZt4k3QlwapnbHJg2VKZ7/BpIJUEALFVGD4doyzsyoXGZJ7GsGhPF2dBfu2ec9fSWi85FLvz934qbIiI6A6fhoHPA8b9a/ZKyDss9b2QkCzfDXd9SHpDXOPEXLHc9KDifGeHGg4ykhaOQIHintQP3P0g4PtVSrlkEAKWfHaJHuo+uAcMuzQ68Miy9AxjP6GOYrK4z28DFh5aJqFIgJM+Gnvauw5pa2grXgmiYBKCUXd57pCf4cYJ5QqHv0W+eARAMxRrR0wVkkOx7F3Zmf3wwKPKkDu2TcvWcqJ35SZ9nlEPlJ5mOkAiMfOy2bWiCGpBxho7Ipxs4Oh79p+JQDuxx+YB3ZWs1uxG4WJXFMbWYir8W8LPY+HxoIsEGYcWjiKMJS/dobNHM+AzUdiXUPzhd0A746f/KxhVdvtig1oXDQFRG49FcM5VZ18AoS/qkH90cEhtVri2CJCP9T1W3utdNEzL3Fx2z3e8KlY9J002MNn7XndqZTkFCuUTU7uQ+UotALCkdP5ZRqKwdVJAqwynTSF5pHj9Ojb79SCQ/GhEYxzmMhg7c/L65DPcyEZicszSikq3H7imQiU4MjQiaKj9VU2f7TG2ZlcCdWju8n9KZsfgrDNx5iA0/iFsHAecJqNQVYd8cNZ1ReFKbsJ1x8+c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39850400004)(136003)(376002)(366004)(38100700001)(31686004)(36756003)(52116002)(316002)(2616005)(956004)(8676002)(6506007)(31696002)(8936002)(6666004)(53546011)(4326008)(2906002)(66946007)(66556008)(66476007)(26005)(478600001)(6512007)(83380400001)(8886007)(186003)(16526019)(4744005)(5660300002)(6486002)(86362001)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b1lUOFhQaEZ0RndhSm50MWYxZU1FTTNzR0NhL1NyUThqNC9aRW9zc0JUYzND?=
 =?utf-8?B?TUZ6YVhkbXJPcFphcC80bjRzWXVrWU5Kd2V5YUZnWlhNRXBQMmJIRW9YYXFx?=
 =?utf-8?B?a1ovZzhvT21Kajlzb0hJZjd2SDlUMktndEJ1WHhZanduWmlkMmpXS0czM0Yx?=
 =?utf-8?B?Smk1VjNrWndhZ1VYVmtEK3c4d3FiZ3l6MmRYTVpWUHB4NjE5aitFK0EwRGF5?=
 =?utf-8?B?d0VsaFpRNzl4anV5OHY2REhIamU4Tm1pcE14NWRzZTRlMUpsZTdIenVEMmhM?=
 =?utf-8?B?TVlrVW53MnJGWVFpSzZsRjYxT2JWVEh1SFl4YlJ4SzV1eDBMVDRvemNaNkFs?=
 =?utf-8?B?YmVjRjZqcGNPdlZ1Nmo3QUZNMk9YcEhUcWpsZ3dNMXJzOXRNeVpKMTk5ajRn?=
 =?utf-8?B?dEtHSnZ5SnkyZ1lTY1Y1ejlSaXRZUWlZZHp6d2duTFBPM1FxNnVmaHo3VllE?=
 =?utf-8?B?TXFvRnF4ZDhLcS9PVlVUQnNDTnNPRnJQSHJkeThWd3BHdmNlY2FsTTRjVG80?=
 =?utf-8?B?c29pdFhPWWdlU3ova3BRYVVMbzM5TnQwVzdTSVgwMmxwWUR4dXRuWFozbnV3?=
 =?utf-8?B?WFJ1OEJCY09SZXpJamFsb0NjSk03WFZ1d3doTjlSZXl6QTM3TjdzTEtlWnds?=
 =?utf-8?B?Y0M3MmpZeHpRU09nZ2FPeTFORW9aMXY0OUZld1F1QnhLYjNSbFk5N1FMZ0w5?=
 =?utf-8?B?WVdjeWhrek9kcFVwMTlacHN4TU5MaW4vNG93bytsckIxZzJ4anlpTTVsY0J2?=
 =?utf-8?B?WVAwb01xR0V0bWdOODVEVndrODV5VGpteFNMejJSU05kck92ak90SWdKaUl1?=
 =?utf-8?B?WTNjZkZ1YVA3d3RLMm91ZTBhcm8rQVVxSHdhdzJBcGNhei95SjRDQm5vTTB4?=
 =?utf-8?B?MjVnZCtFR214VTU1ZU9WK1ZxK21sc1QraVc0ZklBOGIxYUd5dzZiK1hFcDl0?=
 =?utf-8?B?eUVlRVVUVnd3ZVpTOW1hZkRTb0UzYzB4ZTNpNlp3K1ZEcHV2VWdnNFZPV051?=
 =?utf-8?B?MGE2U2phZE5vaW43NWZ1azF2aEQ0VUplUHZUVzFIR1M2Z1gwZUtqL2hsQ3Jq?=
 =?utf-8?B?TDQ3WG1nekZzQUVHUkJQZTNNeEx0d2dJcCs5VDFhcVNyM2x1UXAxSUVXQm5S?=
 =?utf-8?B?UWUxVi9kUXdlM1lOZVRhSWw2c1dZWkM3THlnSG92N2gyejBjTmw1Y2ZDYjRo?=
 =?utf-8?B?T3ZidjNiSnlpZ1crRmpMZlFSSHVJNGJLY0pQd2szNFdoZnl3OFNJT3N0Nllt?=
 =?utf-8?B?eUYyL3pWN2lvb1F3aUpnZHQ0TGNwdVhubHQwNnJWOTZWTmZWaGsrMFlJd3Ex?=
 =?utf-8?B?TW9JZTVteWJCR2F4eHU1VXlTSHBCSlRxWUozTkVwSlc4eE5iWHRrNEdBUnZJ?=
 =?utf-8?B?eUxud0lBVW9MbldEaTY0TE4xMGllbHpjdlM3RVdVZjBRSHY5eTJIb0N4akph?=
 =?utf-8?B?YTBhcGJBd09GNDlRM3h6SlY3VEtYNDQ5UjdVd2hRUksvbkRSc2dUZjdCOXFS?=
 =?utf-8?B?WTdDZzJMWjRBbXNLTWNnM1h0UDZncXhSVDJUdFlteU01V0hGbmlxRnFMQkw0?=
 =?utf-8?B?RjBocFRhZU96b2g4ekMrb082OXNhZlNoNitzeGIxb0c1SnZocC9IdE1LdUtW?=
 =?utf-8?B?UXNMZHZTcEhydHAzbG1XVU0wQnpYZ2oyazh4TkVpcnNTSmZMY3BYK2IzNHRH?=
 =?utf-8?B?cy9GT3VsQ3VsUXZNWmJpWGxFM3Z5c2JBeFZpVW9mbWhKS2c3eW5NbmhhMFhz?=
 =?utf-8?Q?39FH2dSDeYOg/144VhLDg7w1jQ+n5P8zeCYQQXb?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ebdc66-e81d-4b2d-1dbc-08d8f710cfb4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2021 02:24:45.2738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UIM0LUGli3O6AxuzopkILq9k2w1AhXG9ds92KHGHmimIDvfhL2AYzlZqa24CPzIeOMKk/3rDS/g4tayVxA741g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3834
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/4/21 12:15 AM, Christoph Hellwig wrote:
> Factor out a self-contained helper to just lookup a mddev by the dev_t
> "unit".
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 32 +++++++++++++++++++-------------
>   1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 368cad6cd53a6e..5692427e78ba37 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -734,6 +734,17 @@ void mddev_init(struct mddev *mddev)
>   }
>   EXPORT_SYMBOL_GPL(mddev_init);
>   

I didn't know if I have right to give this patch "Reviewed-by: Heming Zhao <heming.zhao@suse.com>"
But, this patch looks good to me.

Thanks,
Heming

