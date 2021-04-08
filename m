Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4064C433B4
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 05:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AEC56115B
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 05:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhDHFxU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 01:53:20 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:37568 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229752AbhDHFxT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Apr 2021 01:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617861188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=us6tRDGm+wpZWkLpivSp2JmFM5nUf9nWXn3Q4VgWQLw=;
        b=Tuu+PCnHwEL+Gn+9LYwLxolJjyKNCPr8wWhLX+hFqqReOO0IbFzU7J7AufOuIj4PocRJsZ
        4zLCh3QTUPuEMq/rI2h5nLWpbnjEGxN+vh+VE9++D9t2amqrxQ0Et7U5md8Eltvj4l0oHp
        b7gH4URdg0vDbddHrkl0DlsS3xDSBKU=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2059.outbound.protection.outlook.com [104.47.5.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-20-7ql7Bad0Ny6eTWY4CzA2yg-1; Thu, 08 Apr 2021 07:52:47 +0200
X-MC-Unique: 7ql7Bad0Ny6eTWY4CzA2yg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kauFo0vj6uS+q8za4xmNtLj60UxZ1Xy9W4o3eOc9OuiCo9tZYiPkje3xaobl6/d0k8dsowvi5J0/eggctGNOjrjs20cUpMmBQ8GQQ4T4BZ6Z1cpZfOzRQtQviYxwvdFJQCenHeaAUYZ6AfOvYAc/AadQfOcX6t6y5Gh9xLxpNz6B6ovLP6SOHWZoceuxFHczhG8RD4r4Pbt71N5nDbQ2ckstLzqVfTflgkqDHUhaC8nKGCY8opJ98xuWofrBx6wl/hCd1jsfteM6wwQCHJIsOwjJlXapl+pJ0zK6Hz4ScwCpo9Qa4zEMA6lHGD1XjPFIsjFIGbxMF56BhtV7qlLYtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S74a8PGskhBhipci4wAzyH2yXfW4/+Q4pb2F+fIlpK8=;
 b=CeqGJguQnBRuQ6m9zzaiQiw37V8mN01cRmw5xVvUIN4XK7bpd1qbGc2ds/dKB54pMGj2ZhHtEouIDiOu4Y52DgObaev83DkDZf0jjjQ3laRCPgobnJOdIVoBWauv3JPBIP6C0IVdUzneVts18tCVW9ZonbejUa5JF5lEjLfn76oTIuu8AbCNuFZK5N6keNMuWlZFrpI12SYMcEW8cGA0hlTOAT79sL/CMtsdGByVZMAvLXuQCx1pU7P3iBbIABqZKY9QQKaDRl6C/GOjft5T3xvGXT+mByLOafmPZx7spG5NONoQr6tXCWjH16IUF/LrTOahq55bYXyDxr9tmwoLtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6908.eurprd04.prod.outlook.com (2603:10a6:10:116::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Thu, 8 Apr 2021 05:52:44 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 05:52:43 +0000
Subject: Re: [PATCH] md-cluster: fix use-after-free issue when removing rdev
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com,
        ghe@suse.com, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
References: <1617850862-26627-1-git-send-email-heming.zhao@suse.com>
 <00bcd9d8-4199-7d4d-32b0-ece055f2186d@molgen.mpg.de>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <3744902a-2e35-ffc8-7de0-f0ad7dac0cbd@suse.com>
Date:   Thu, 8 Apr 2021 13:52:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <00bcd9d8-4199-7d4d-32b0-ece055f2186d@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.133.231]
X-ClientProxiedBy: HK2PR04CA0046.apcprd04.prod.outlook.com
 (2603:1096:202:14::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.231) by HK2PR04CA0046.apcprd04.prod.outlook.com (2603:1096:202:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 05:52:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db7a2b47-934d-4ab9-7ba3-08d8fa528750
X-MS-TrafficTypeDiagnostic: DB8PR04MB6908:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB69083128F75844EA3B3AD33097749@DB8PR04MB6908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPo8zC26jKvmpt9Smd08RpySy4H9CwOJKJEwkh4eJougt3pGV134n39wP4TD+/xPzFwIPUL40q72XgzlH/KIuPByqLmQrlkp8mQQ+twsYruBX4tRgmkBysg25XOjCA2YMvSF6qq14CoCiG+33hDj9D6N0BJhFRUIdz8OGbmGy7Gv3CS9SH2PLVtFT0Nk5HYe5ujxEgIxohVfXx8M3EYbKJvbNjqMUhl5nAUpRRLogVV3EzLPDwWZMX/wC+WvJvw85ma5OWxM11NJpg59LsqfmClns9gu5mILhDG9ULgI2zXYfWRWkrcdtgiPJFC/BtusMBSwhsORkM339B6VfK9x3mLRARvtqZmRKkAcyeQM8qZdP+3ndWeTEjsCWFbz5SGeKSXJKq4b+UUyeR8vRuzGdOyRax2zNTivOU4chgRRBUxFSixx6iw7caBz0DqrqQrd85t7TmUwYXLGCUhuBaTgHgwM5xw+rWNzaDUSaBrtjGb4Jj5v+G5PiAkNB2rTbYvxN3ThNNkc+sQwCzK+kgOt7NuXalcCMi4n1p7JaG3VJbEv5QnbCjGGCG6/lUsi2cp0t+IDEx4AlgUX96e/NKR+xelwv+PI40NNxe62oVRMRAb/KDFR/aDswQGXLoy1wJtxb7gL70BX5e8GFyMAquA+AR639qXcaK64Vk/wvpcGcict/57FMJSvT7pDYSjhLT2m3dUzPn4Qpj4wzdUWWPZqXCN4mMCDk+B10kYrGi+GN+oqzZHZl+BmYtD6BzL/VB4jRSVIHijB6YL11qCn0sMl6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(186003)(52116002)(6916009)(36756003)(16526019)(316002)(31696002)(86362001)(6512007)(38100700001)(26005)(53546011)(2906002)(8676002)(66946007)(6506007)(66556008)(478600001)(8936002)(38350700001)(66476007)(956004)(6486002)(2616005)(31686004)(4326008)(8886007)(5660300002)(83380400001)(6666004)(9126006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l5VeZDDkQT1hs+DViEtuYgjU+dV4daDZ+dmxaIdrGfzOS4eCNlxkQqzpBJXb?=
 =?us-ascii?Q?3GSxz/OvWzzUtWWTHTzQhZjt0GzOQS+lmzDPU1zPqWQhTZTJxSQFGKo+ALlU?=
 =?us-ascii?Q?/Y5Zi0zSMClzGPhbJE9QDZyb/ohQZqEiyXV3hx2SgaIaSXj+MyAOc6bOvSwr?=
 =?us-ascii?Q?4AGxHYlk8PaBW6FNwJ2BimK8aHAAx3a3JTMyn44EnUb7ROLsWdS9Jdjn5Of8?=
 =?us-ascii?Q?pfjI1lXeNK6zIkEIm88Xy2prKdPIvOMaK5ezbnZhpLlRkr/mKg0VQndEgtdb?=
 =?us-ascii?Q?2Wm2dLxGROjvsne/XC1VzkTrPFB4LimX/qlWvrIThcq+uHXVT567u747OGzl?=
 =?us-ascii?Q?rnupCatncnJ8zZMVk/T1gpMvlNVhP377MIyql5tU2fLvsVKSJg5Q+gnyIV2h?=
 =?us-ascii?Q?SSPEIPrQYSDntr4ErAMojs0j3Qkxew4GmfIoAjz80a+7QfLz6rixgzhc0Ze7?=
 =?us-ascii?Q?3p25Vl8JYKfJFlD4iAF3qf8l7+cyE7TvNkdejfUH0cc2OIRb8lTK9bnrYpcp?=
 =?us-ascii?Q?S8SS8tjlzlFczZ8n12VIuWy05mJhwPy9+w5RtmoDwoctkf7Ni/I8PXZJtbv2?=
 =?us-ascii?Q?QEn9Y7l4n0vBdh4DiMD/HGhhhFLr3WjUrxZm3dPv8dbLHhor8qzpz++pdRmW?=
 =?us-ascii?Q?UzPjCisIqau8ALY/SuAST+WL6hiyt1cnEYQRKTXTwnt9LY+Xr6vGHWUOj6zm?=
 =?us-ascii?Q?cmd54un6VSncj3iC7xAAc8xVZkx7pDc7m0cyDt0EbzUSAmSWeiudPn/sgqiq?=
 =?us-ascii?Q?zVHbjGHPK+wds7zojLWG/sB9mcC64cWlNXn6Hj91C6T1qAc3AMX4gZ5hUGmW?=
 =?us-ascii?Q?j8tCZ+IYwSHixX0kl0yIRRNsJr+3wjTGumPDnpMJ0CoO4ocnvKk8GXk1+2S2?=
 =?us-ascii?Q?lvLzY3EY/V1U3zSrJr0Yk/3ToErngvnFuxsdnEqCqz6JlEYXNorNP5an9jCU?=
 =?us-ascii?Q?zH4X0RjMmhW8nXZeNQdYWvh2jwixtmqSQEys/Kx7ekhtdTbpZeB8pY3iZY+e?=
 =?us-ascii?Q?5DDen38wYHXjeYcHESt30zhuvRcuf5ugNkfg08UMQJJbpe/tgXCwj7nhO+eE?=
 =?us-ascii?Q?z79Ljbo59a7pEnjvhzJHnoSceqTY4B9V6SeTUAJ8WEMuLl2c9lCpi06gh3XD?=
 =?us-ascii?Q?/THLsbNw5XHMrMK2rJvvkXOkuXh47c3L6KMHhotj2PF5GUVRSUQ+Ctm+AiSt?=
 =?us-ascii?Q?ZqDTU8z4/OUW4c3N4CaRRjzXLRUAYn6XS6FYTU/J4HDqtihknB7LxXsEoEPS?=
 =?us-ascii?Q?+VpsioGJh1wtoPsaGdnFDBwW5F/FVEMldbMMyCzKbH6nFACzd/EYgsEah2EE?=
 =?us-ascii?Q?S5TUCS1u+UVeSip7ZYIm2RV3?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db7a2b47-934d-4ab9-7ba3-08d8fa528750
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 05:52:43.8785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1NSoBoB+8OS/rD9dlkIy3ZBJ6MSw6Wv+uXWr3PVss0Q73tc0quHXum8PjW7ZQC27FL4/zRxLl59AlTxiEkLTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6908
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/8/21 1:09 PM, Paul Menzel wrote:
> Dear Heming,
>=20
>=20
> Thank you for the patch.
>=20
> Am 08.04.21 um 05:01 schrieb Heming Zhao:
>> md_kick_rdev_from_array will remove rdev, so we should
>> use rdev_for_each_safe to search list.
>>
>> How to trigger:
>>
>> ```
>> for i in {1..20}; do
>> =C2=A0=C2=A0=C2=A0=C2=A0 echo =3D=3D=3D=3D $i `date` =3D=3D=3D=3D;
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm -Ss && ssh ${node2} "mdadm -Ss"
>> =C2=A0=C2=A0=C2=A0=C2=A0 wipefs -a /dev/sda /dev/sdb
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l =
1 /dev/sda \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /dev/sdb --assume-clean
>> =C2=A0=C2=A0=C2=A0=C2=A0 ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/s=
db"
>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm --wait /dev/md0
>> =C2=A0=C2=A0=C2=A0=C2=A0 ssh ${node2} "mdadm --wait /dev/md0"
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm --manage /dev/md0 --fail /dev/sda --remov=
e /dev/sda
>> =C2=A0=C2=A0=C2=A0=C2=A0 sleep 1
>> done
>> ```
>=20
> In the test script, I do not understand, what node2 is used for, where yo=
u log in over SSH.
>=20

The bug can only be triggered in cluster env. There are two nodes (in clust=
er),
To run this script on node1, and need ssh to node2 to execute some cmds.
${node2} stands for node2 ip address. e.g.: ssh 192.168.0.3 "mdadm --wait .=
.."

>> ... ...
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> Reviewed-by: Gang He <ghe@suse.com>
>=20
> If there is a commit, your patch is fixing, please add a Fixes: tag.
>=20

OK, I forgot it, will send v2 patch later.

Thanks,
Heming

