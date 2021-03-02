Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83BCC28D13
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A64DE64FA6
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241911AbhCCBOj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:14:39 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:31995 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377900AbhCBIpK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Mar 2021 03:45:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1614674592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pmEBMccL2exWkOOYMjYPB6XSeg7EGj8v85KnyBYPt2o=;
        b=kBEOF7iozSswVJtPuPU9VR38AJdBm4CVHS+QrRJ8YXXA8A0PBxp34lYKXtyvtJPJVvJIou
        rzqpoldP8ebZ1b2fVrO1i41V3EYorGsus/ogmY3OP2Ar0y7QHIffbBNoffJqILCvKkSdGa
        iGiovwFAxhgxWu1vo7tryQJpmGHpB7A=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-5UjAO_BLPJu4HrMbhUPHzA-1; Tue, 02 Mar 2021 09:39:32 +0100
X-MC-Unique: 5UjAO_BLPJu4HrMbhUPHzA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOq+lXjQ11dmu7BTCV1stJyzwYtTc5tgCORaBs5tFpLM4WU1Zz1S9JWBIJG8l0LvldB2Zt75au4ySBj4BeyBhrunVGXZkiGw0lQJCilbrqqWS1C53ysBhqZiZz1vVaaQqeMinAgspn5Fh2Fq+RzxzQz82EdeQ/lChY4qvSJt/an+/5Mjx1RzQNMxgGea0ArmkMew8BDi2ISu8hHA5qXL8XQ40WgE9kIHerKuhfKKQUVzUaUdshO8AmiSjxhmsdYekL+u/NhAnj8E6mZDQ/SObzzzQS8JFRRLCNyGDd8NWY+wqdSCZ2A5451wqcVSQM/4KEkZN0nNGzTRcT1j6NJAfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQQVqRWjdxOXeeVANzmfu0O5QvmwQrApyVd6OYBtW+A=;
 b=P+Tv/RwsosxsNt0tsdglwHqMJFq7MQqS1BzXXX3rHjEGYmfSjDLvwW9FhqC04XOxhWVOIJXDdD0JaKNLkdeBAv7saovr9zvO4/7g2CBz79lGLFjCgih3M7GEvQPMA52Lp4hXwG3NfxelSrqtaJ1ebVWmmANZuuVp7YAyCX0ZY2/JuUseQjGiGLgaQDgulWeK0b0asfjMrQM6FxyxABjtyIlpyR3tfC7fzfAbYebcyuHGaWw55p9LXPXJ6OEGAqUlnfSTZtN4Qpjx+IryrQa/pgvZHTAsHnYya1yGuIV+TuxD+dyDcuybslytw8CqGLCdpoHs6h8xT+r8dlutbUlnDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4665.eurprd04.prod.outlook.com (2603:10a6:5:38::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.19; Tue, 2 Mar 2021 08:39:31 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3890.029; Tue, 2 Mar 2021
 08:39:31 +0000
Subject: Re: resend: [PATCH v2 mdadm] super1.c: avoid useless sync when bitmap
 switches from clustered to none
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
CC:     xni@redhat.com, lidong.zhong@suse.com
References: <1612311771-17411-1-git-send-email-heming.zhao@suse.com>
 <1304a391-532e-0c93-b3c1-58441e3c8200@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <ba1f98c0-e332-173b-1aab-afdbbea1e604@suse.com>
Date:   Tue, 2 Mar 2021 16:39:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <1304a391-532e-0c93-b3c1-58441e3c8200@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.132.117]
X-ClientProxiedBy: HK2PR02CA0215.apcprd02.prod.outlook.com
 (2603:1096:201:20::27) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.117) by HK2PR02CA0215.apcprd02.prod.outlook.com (2603:1096:201:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 08:39:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5bbc6b5-6bc9-4c85-c070-08d8dd56b2e3
X-MS-TrafficTypeDiagnostic: DB7PR04MB4665:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4665E7745DB5773B4142796D97999@DB7PR04MB4665.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:324;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0b2G++yPOqePdccQJopqI4+j8gB8I69ye7JmnCe+dTCCyAGtHx0kJpPoTvrkDrAxPviblgsOHe/KvcAVk82PLHA9ie24YKXiXApk6ATOj/UwmtiKwAmhbFeRcYges5RiKnQtOJC4FXxAPu3ZMIUcKfKvYB8isaU9Uu8gK5G2QQuDLC+JfTeWtlnobVlvJgzDd4yDMoprox6fWPh2qm8gepYVtxAWcJmnUNzMA1ijVXz3D+3/A61Kh/HmxQ/OQ5nU+WyLV7u2t5Rh4QGgIXw8zJmdII1cjmK313nQjlEGFLoA2ChhafE/9I7sfcFgtxAsh/wgMpgN/pAZouoS+uZCeRMQRHbiFi2QvjV09FPc7zZscEP4jjHdtSlD3Q/LuqaBKc0/Zuu1ikNBv/ZEYFq7wYtJx0DWj62GOA5kOrXc53IYp2wRweJ8kT2vl4ol5493fJ2W/xQvoHwCiHR74wLqKLDda5uyZu4+MBahDYeN0CY8Ow9BYSqRlqg33/G+jyQ3HnR5XrHp8Puz5C68zCOCsY8CTa7yr95DXIFOa6hKABiZnJVeHRrWTsUcOs8JY7ffq4DBAqG8Vx71L+LksCiW8HekdQWrqQfgqrzDOTPHQhh9HD7Zez31G2mKqx0xu08k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(136003)(376002)(39850400004)(8676002)(31696002)(2906002)(86362001)(53546011)(8936002)(6512007)(52116002)(6506007)(26005)(6666004)(36756003)(6486002)(316002)(478600001)(31686004)(4326008)(66476007)(66556008)(66946007)(4744005)(83380400001)(8886007)(956004)(2616005)(107886003)(16526019)(186003)(5660300002)(9126006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p3GrYETzuE1Vlfsu+ua3n6bK9kD4i58sGyEwHoqd1GjoiZ6S8g5WO/I8By01?=
 =?us-ascii?Q?rchPzw+j7zuICFhLO0hS0O5yF56R4vmFTv6h29ANnIwQrjOG2dQyCCdPJt+u?=
 =?us-ascii?Q?feMwTsoccuQb5FjN1XKpW7+fmbLX009IMb7o7brDyniulpnLD//j5i61PpTE?=
 =?us-ascii?Q?uErFqTm0aPJHaFgdFqP+CUb6f2E6lsp2OyrxC/jk5UwTBejZzYECIOHBtaZL?=
 =?us-ascii?Q?U50moc4l9wqsXxJuo6EUfqQU67dAVJqIDjW7m9hdeEhQ03mJ0gFXRbkkbclu?=
 =?us-ascii?Q?Iw1i72yfXZCs63uyGAxerBwFvL7qclPBn0GlzKsqYWoQVAghJsUqdnr0h+b9?=
 =?us-ascii?Q?L8f9anisN7d6K2bzCfV2kFX0gsieMkdb1swDnHJKi8aHnAd3am0YtvUQ8/6R?=
 =?us-ascii?Q?NvDrvR7EqxhqqvtBeE/qFB7wZslX7P+bocl9kuoDfMHxyW90F5TBVG8VRmap?=
 =?us-ascii?Q?4ABlZlaGsFzNz/GJg3V6s/1+bYfDUMo8NoxahKUJvs4FdVK4zmP/Aeif17KL?=
 =?us-ascii?Q?4DBaiX00TfzF68YWPRwAI4rZ1kha+eMMNo7qVi1ybDC0UTATC8aBpGhGyvJ4?=
 =?us-ascii?Q?ntq4YcI25U2wxOc8qOAsGqI5H1CQCq0ksSFa5m4fPCLfUu1zJ7+AAzuvrNj1?=
 =?us-ascii?Q?fJItkCLg9W4+5MyERgIuX8ETYYZ8xw/1vFbfBWkqzdXGa/jFe2kL85HgdhIf?=
 =?us-ascii?Q?HHUPacSoXPILWsaklrgAedEx8NsY+eIDZThhxp8TuDaqYveNK1v8VT2MI3ez?=
 =?us-ascii?Q?IKW3OKCErY0qLu0EstYZQaBOmZ/abVU6CFWmaWoVPhSmaUn1gFHfLaLP/AMg?=
 =?us-ascii?Q?tk8d/Hby4/WQbbTv3vMQD9/pPQDFYZ3F7G2BRwz9eSQ1A8uX+54P5Jyd2xML?=
 =?us-ascii?Q?V9m5y5daz9QFLsAoIWBUpQK1ZVi7T+Qe9YI5GD60BuihIiso4R4iL7xUK+GG?=
 =?us-ascii?Q?EZ7jZjSg1FElr4xp+E3CDPLz1swnhldgfCFRIfydxFaltFzPFd4qh+t4m/zF?=
 =?us-ascii?Q?5owp4YkyYJWfm8bhRiSKS/geY41+zxYcbezCZmenkUZUwoBfsjQrdm7CGTL4?=
 =?us-ascii?Q?anxBUUy3s5RhNQT5N7IthYm3Cr5Ha6+EL5t3eXDaUnspR8CLBGyISRGPGuI6?=
 =?us-ascii?Q?b9/W9IEQ7+I+R0A1blSNscPL3Z9evxqBr5aD71DZc86N4HxLCSePjfIaPiZv?=
 =?us-ascii?Q?jm/rdZ/yMSPRD7LCMZfiF9ZbPYlgGpzCJ7dCGQatYIOuur6mZK6jyXdUBmNv?=
 =?us-ascii?Q?CwWcmsiOUmqFqB8X/r57DlABSijmujAkaWXRzXv48dsMLSr8w3O3tz8QkEA4?=
 =?us-ascii?Q?Y2EA/0b/1HjgjKdz3J6mvR0c?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bbc6b5-6bc9-4c85-c070-08d8dd56b2e3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 08:39:31.2270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ATX9+D7yKKj3Ou8g4GGSf0Y104+Ngd0eJEuE1QjDkjDXbkCBPQF3Pe7rnoyclH1Ic+KY9qPbbLP9A8cVd8DrQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4665
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/2/21 4:35 PM, heming.zhao@suse.com wrote:
> With kernel commit 480523feae58 ("md: only call set_in_sync() when it
> is expected to succeed."), mddev->in_sync in clustered array is always
> zero. It makes metadata resync_offset to always zero.
> When assembling a clusterd array with "-U no-bitmap" option, kernel
> md layer "mddev->resync_offset =3D=3D 0" and "mddev->bitmap =3D=3D NULL" =
will
> trigger raid1 do sync on every bitmap chunk. the sync action is useless,
> ... ...
> ---
> v2: only set MaxSector on bitmap clean device
>=20
> ---
>  =A0super1.c | 2 ++
>  =A01 file changed, 2 insertions(+)
>=20
> diff --git a/super1.c b/super1.c


Hello all,

more info:
This patch had been verified & run in SUSE customer env for some time.

Thanks,
Heming

