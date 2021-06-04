Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A40C47083
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 04:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 529CE6140C
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 04:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhFDE5W (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Jun 2021 00:57:22 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:42138 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229452AbhFDE5V (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Jun 2021 00:57:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622782535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ScwGN2EWFkHhu58hS0DBLMj+Zxj8RFghGtaIkvgIjH4=;
        b=juvYl0ngp8GtUR/TgGdntwfncJbT0VJfg+UbrQRH8AtYKTqVx8yig+kbGj0roqvcVLt89W
        Xo/lc8ncSRQWj5hKTb1L00Cw7esmvANvGP09kmrq7eKpVXKYm7Wk1bDJd7xXxROupbXHbw
        Wv+SSz8/PflGKk5KdgCF49kH2iODfhw=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2050.outbound.protection.outlook.com [104.47.5.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-4-QjgdGnj7Oo6Dq35i68nFUA-1;
 Fri, 04 Jun 2021 06:55:34 +0200
X-MC-Unique: QjgdGnj7Oo6Dq35i68nFUA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfyQ93nTOOz9Xa+hZB6QrEOQWNrSEWlaE0z8bCKz40ewxonquWNPHWaB+dduuNLl63KtU06O6qXqzEme9nh4sMuCv3QOFWtwaGE0YK0nAj0EF6mHC9Ve+CfkOeNDc6xYrAi9pisFWl1UVxRjP8qHQeizebmIpcjcOEc0PA/nbNQ6ISiAZlLSd8hbcAnASRJkPOEyjyjM6NjRiPBvJEefZv1Ljus6KIzEPq8eu+1cSa2H9ItAHRmwIasoDCflq8VhgIqMFzXFuRw1O6E9FYL17V8GWWjPyawMVKn0XbLXg+1dI0mKAnnoYwBxTDfFJMDE2/8jb6k1d2fphVPph8Tqqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScwGN2EWFkHhu58hS0DBLMj+Zxj8RFghGtaIkvgIjH4=;
 b=kGnXCuJB4+oDvJ4m9X/70NnodRWCmsTRdk8pY/cZY3CRWdTxO4dHyNA89tQKf2EnOhO+wPN9e5rrQpgNgkCj1jRXlFruJphDC07EOHVU29aXWgD2+rHNzjkmSBNtfp836L7qrkCVfK/GhV3+QOeVz8yfpRcK8Mb/sV+moLxZE2HKJ8/8QuX5+gN9vn/dJIxjdQDSs/0A31UZ4KoorICowOTaHXq3aTPrZeb6LYxmxlBxR08Jy8rG5XtYG9yItwlyyBxAWhaDS4WRj6BEr10A9fyrvF+KfylNq6a9zEI0539InGwUvzN171xn3Y0L0yQjO5pQnCTRc0EzWMHQzVAWNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 04:55:32 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::99c0:486c:b9d7:5740]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::99c0:486c:b9d7:5740%5]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 04:55:32 +0000
Subject: Re: [PATCH] md: adding a new flag MD_DELETING
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20210428082903.14783-1-lidong.zhong@suse.com>
 <CAPhsuW7uWNg05ps1b2qmD5P5=0x=_0ChV0e=hGZ7Occxeh2t-g@mail.gmail.com>
From:   Zhong Lidong <lidong.zhong@suse.com>
Message-ID: <e858add0-84bb-eda7-8e7e-886504577883@suse.com>
Date:   Fri, 4 Jun 2021 12:55:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <CAPhsuW7uWNg05ps1b2qmD5P5=0x=_0ChV0e=hGZ7Occxeh2t-g@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [112.232.225.71]
X-ClientProxiedBy: HK2PR02CA0201.apcprd02.prod.outlook.com
 (2603:1096:201:20::13) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from l3-laptop.suse (112.232.225.71) by HK2PR02CA0201.apcprd02.prod.outlook.com (2603:1096:201:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Fri, 4 Jun 2021 04:55:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6466adf-37ba-4c74-dc34-08d92714fb82
X-MS-TrafficTypeDiagnostic: AM0PR04MB6529:
X-Microsoft-Antispam-PRVS: <AM0PR04MB65299375AD493636093BD09DF83B9@AM0PR04MB6529.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8R9Qu9DL4zpOdW85pIEQMGvuMHfZL37VIyaBKDpKD/MJjGRR/G97oAdybfy2/V148tGUi5DQA0LdLkIzHXSTcn6UYKW6eBC7Gm7AVU7cnU5yc6ToUnBpr4HxTjST+E/ACPMEDZY5Ke/pwCNjdSQKSW59y9gtEijRdeWy6dC19Q2L7cDmF2nfPX/ekfhqpUmt9TcLrUPs2E71t2MXU3JeGMkmBNVMfWGyvGcpeX834b+ulPI8FuVGYX44LUZuCcgd1niVi80UBnW0Ri7oc55gvaYsLRH8h66c1r1l5smv4n9T3llXxYOKnDYjs8XWHHg0peq5Cv1jLwyoW6I9CIehiO2Zz4cTXtqMV6LdX0/b32/Bkiqj5uKNOsH2Uhm/IyTKiQRD5Aepuc2ZKaoBE3Uu/DvliCdPmFb8d0gj9+sXyKoQM59f0y+MOtV+VUGc79zofCDPen8Sok8BkCYI9gE8pA2kR2UYDuwjd2pFUbW+RdXFrLA82YaztT/rLSVw78ut62MFdL8dW6QU9QsheWw4c8W6UNcUNhx8MbO5rPwvsnrITR1hrtBwhd+nfJ1p4VMIfhFP7hmT7eY4z+t8oD4vgFYMzdF/o0NpcDg78AU22NUxL2cc6wEjxVw+uiwkPgbhwn4pMRj9Ki7O6y7EP26HD2LkKQAPwuB12UD/ShTXkbC/3PLM+OxS0MX/gHkH/gz/2rbQ6EoEr/reuKLg7zOTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(39860400002)(396003)(6916009)(36756003)(2906002)(2616005)(956004)(6486002)(6512007)(5660300002)(86362001)(38100700002)(8886007)(6506007)(53546011)(16526019)(31696002)(186003)(26005)(31686004)(316002)(66556008)(66476007)(66946007)(4326008)(478600001)(8936002)(8676002)(83380400001)(6666004)(45980500001)(43740500002)(299355004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?2B9e7Us+o+Mrvw32RsjscHFPy+Jcq7KkMpSmi4Du2CP/yTeT4nUo42Nn?=
 =?Windows-1252?Q?R1YWO5fTb9Ii2vAaQIivRy7hPHK0z76CHWdXCnKhP9vawI8KnKx1LE8N?=
 =?Windows-1252?Q?i2rvCNnoW/kp5nT1th/ksW06+CjR/a7IPw08yqkm6yImtcOqjRIGxgs9?=
 =?Windows-1252?Q?HEJZKv1BnfPVRJ9er6lRa8nPdYZdgOTjuo+9zbtHOaj4C2wy5eDwyDOn?=
 =?Windows-1252?Q?nThxc8XQdTHQ9iUy8Kp4BYlqr2ISsJHZGobiL/vKTbUxSqjx7zWmdwxT?=
 =?Windows-1252?Q?bRkYwWuLNvgrOhcPSmVEV/wlfOk6IN9ELLW6bLGwW35hQqpUlIRJM/ip?=
 =?Windows-1252?Q?zpcPCEqDdSO6QkAVF7J5xGZlnh0WjRGOuN5I3vnAOPuBk3rfys+yBXc5?=
 =?Windows-1252?Q?W4SxIB1O1EglVZhP/bmzL+dHS7gwpx7uRgTAGFcB0WZ20Np96Mv7SD2H?=
 =?Windows-1252?Q?9e07nBRHPPZxQ3YLpsLyiZh3TggITUtQyu5jl0FszlEgaBrgespLsF7+?=
 =?Windows-1252?Q?K1WfgRi5s9oQJGOIPoLqBA3lamPYDj0B9Q6kWwaizEqegL6cfUJod4Qg?=
 =?Windows-1252?Q?L6eIjm9FsNQ0qUYc2X7ZpnPlWTgVE2r0EU/eqaJpZ3n+ND7tUG0xjDTX?=
 =?Windows-1252?Q?uws3exNWTr+QTH5OdBFX1Ibwjq8njc/SQ+uThLp6IWsR7OXpESbzRmP9?=
 =?Windows-1252?Q?a5D1AoG4BGd5uxhONHKaV6qpz/i+Juy0eSajPhKxZgHGOxtKhtgKvmI0?=
 =?Windows-1252?Q?fxSXm/ilVUBqrAnSfs0zp/dtYPLPjKiGkAOrgxuhHoHQHDyRw1caOy/+?=
 =?Windows-1252?Q?0gTkHYVfO2jwzTGIAhLSVNkUPkqltOGlSuNpoXJVAOmc4tf/s9yZ/+4Q?=
 =?Windows-1252?Q?OMSnbFhOpglN3ej5zqQ2u1ePiCeGcPV5X+fkzhG3K1b7YwPNtE4ULWlL?=
 =?Windows-1252?Q?ycPoXsPYng36wp2lnuRqi470lD1IJjItdrF4fgo4/Qrnova9D3NxEsDL?=
 =?Windows-1252?Q?3Z6rcIM289rnlCJj+R46feDc1J5JuXVtw00NVDHrLQEnqDNnJCfr/P9u?=
 =?Windows-1252?Q?NrSlDZbyq48UaKmc2VJXjIuyBAGkBZhYynXKtz6QUEJPsjZC+3Lj6UMb?=
 =?Windows-1252?Q?rTpuGgbPp+Ejzs9H4kHIESVwmiUaIqaDns41C/c8ni6HVh+q7vHsxBGQ?=
 =?Windows-1252?Q?/0qV4Y9uTvNS3OjOV7mwvVA/L/l2LTHQsK9GY2QlhGzHG5FYAVYFYxd/?=
 =?Windows-1252?Q?HAThCtKbtazVZ19L9Vnug+NdknhcNn5cWKgh7vR75pLFx42HDkL21h5/?=
 =?Windows-1252?Q?9ZozLSmwZ97L6vK7X+gbVXCiid1psxqfSc1b5KUtIvoGWNWYaC3swnDe?=
 =?Windows-1252?Q?HFhEw5WFDH1n43ElK4/gu9r5OhuviiFAawNHtRX76I/4aT03fS7QfgLi?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6466adf-37ba-4c74-dc34-08d92714fb82
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 04:55:32.6149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zg67AVDZiAjWwvWPn12qCEAyaCwE5BUXcmHbzbZkQHkvT7mJ7T9yfKp03z0fEbM4FEuE7Bs2S748T0yD7ATZOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6529
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 6/4/21 9:23 AM, Song Liu wrote:
> On Wed, Apr 28, 2021 at 1:31 AM Lidong Zhong <lidong.zhong@suse.com> wrote:
>>
>> The mddev data structure is freed in mddev_delayed_delete(), which is
>> schedualed after the array is deconfigured completely when stopping. So
>> there is a race window between md_open() and do_md_stop(), which leads
>> to /dev/mdX can still be opened by userspace even it's not accessible
>> any more. As a result, a DeviceDisappeared event will not be able to be
>> monitored by mdadm in monitor mode. This patch tries to fix it by adding
>> this new flag MD_DELETING.
>>
>> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
> 
> Sorry for the delay. I missed this one.
> 
> As I try to apply the patch, I found the patch is somehow corrupted. It contains
> special patterns like:
> 
>  =09if ((err =3D mutex_lock_interruptible(&mddev->open_mutex)))
>  =09=09goto out;
> =20
> -=09if (test_bit(MD_CLOSING, &mddev->flags)) {
> +=09if (test_bit(MD_CLOSING, &mddev->flags) ||
> +            (test_bit(MD_DELETING, &mddev->flags) && mddev->pers =3D=3D NU=
> LL)) {
> 
> Could you please try resend it?
> 
Hi Song,

I'll resend the patch once my email client gets back to work.

Thanks,
Lidong

