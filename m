Return-Path: <SRS0=Dxgx=ED=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B2AC4363A
	for <linux-raid@archiver.kernel.org>; Wed, 28 Oct 2020 21:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5637224680
	for <linux-raid@archiver.kernel.org>; Wed, 28 Oct 2020 21:42:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g+LBRZA2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgJ1VmM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:42:12 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:24989 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726031AbgJ1VmK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 28 Oct 2020 17:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603921326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YO0wadNxWucZyCf7uMFYdvjeev7m5Nu7E014WfX5Ipw=;
        b=g+LBRZA2Yq7P6Jsxw5GEiQ5kJ4atpIMLdABtmfaXKoblJBABvGpN5WoK9UM74bXheznj8/
        b86fxlVPzmu0OMISliaF8fdhQn/6rNqUC1YFEqb9t9CRTXYucah+U3i2FPYE77UdOb7z7P
        he9IUwtJbWPJFlTnupoAWEJPgo9jQ+I=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-4_fcgpaHMGKPf0tVtwoD7g-1; Wed, 28 Oct 2020 13:38:00 +0100
X-MC-Unique: 4_fcgpaHMGKPf0tVtwoD7g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQ478L6m5XtQ42CQf0V9s0kBoNRdkIHefIkJlcyc92oj24y6cK7ft/7zGFaMAjXnrqgvviD87/l7Sy8A+iX5v9nkMrbqTloSnEAuLTckPbA3zIawoD7+77G5fWeyeEkeNdnGi/MDKt03gzY5nXZoHSDVqcMcODuWqssM74IrqPk7dU1soavXCWiYI7ReSnSUTnbfSngn3kkUlC2QZHVjqrimYGenuQEXNYvlkz3jfebyffTcYByt2aWvAV2X3auB3aY6novKiUpp49JjbHNKoI2BzdK1Ov5FgCZyVGbXne3lA66hgKylwZTJDgCKMYZQZpojrawYkiJGCYVWBJQW6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5fsZOTwOTIHz3g85N23cDMzcnYwYojKmCXsRkvBTIk=;
 b=f7T4eyGEouv8z8HDsYAnOtFsasoABnXOjcSYTo1F8NfrEjkGxfgGHZ74muEYmb7rShxaaxFkMgmRsIev8yy/xFLilBLIGOePIhoFx78OcD6wT4KExzdFxKL2tOulY7kMZdyGqrgW5E0q1xsDE4CXc/fj46roMsyvXi8EwisAZO/p6tvB6wVUhN/QQBDwLq3zY6WF1IPQiupgW4b5QbECXSRjWbW+2UZld/7Cceg/mIF5IMuRjqulIKXiKjX/qlCX9Uv1SCm9rDeXs5BWgcD/XHf38SC2srIzwtPjdXDUB+L/pT1kiw9d1Q1dP5lvo2QKKRrZTeSKa/YKnYHJiwdJeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: cloud.ionos.com; dkim=none (message not signed)
 header.d=none;cloud.ionos.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB4671.eurprd04.prod.outlook.com (20.177.56.75) by
 VI1PR0402MB3360.eurprd04.prod.outlook.com (52.134.1.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Wed, 28 Oct 2020 12:37:58 +0000
Received: from VI1PR04MB4671.eurprd04.prod.outlook.com
 ([fe80::9d47:ec0a:56e1:f3e9]) by VI1PR04MB4671.eurprd04.prod.outlook.com
 ([fe80::9d47:ec0a:56e1:f3e9%6]) with mapi id 15.20.3499.018; Wed, 28 Oct 2020
 12:37:58 +0000
Subject: Re: [PATCH] mdadm/bitmap: fix wrong bitmap nodes num when adding new
 disk
To:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        jes@trained-monkey.org, guoqing.jiang@cloud.ionos.com
References: <1603552027-10655-1-git-send-email-heming.zhao@suse.com>
 <75940d7d-3933-a026-d878-d75aa0050905@redhat.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <8f39db60-635e-f187-f134-da6fdf3b83a5@suse.com>
Date:   Wed, 28 Oct 2020 20:37:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <75940d7d-3933-a026-d878-d75aa0050905@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.132.188]
X-ClientProxiedBy: HK2PR04CA0080.apcprd04.prod.outlook.com
 (2603:1096:202:15::24) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.188) by HK2PR04CA0080.apcprd04.prod.outlook.com (2603:1096:202:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 12:37:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67897de9-2715-4f27-897c-08d87b3e4d40
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3360:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB336080DCD9ACC5F9449ABE9F97170@VI1PR0402MB3360.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QrzIjvT95l/MrQZj0QFOip1AKrk8NhokUYOcteZBdxyIoNYvYkFspG1tWHHNCqa6/4EB0I2cPfPeny9n+PDLWPXKqpzLTVyxvebDjonz+l9Z9K8jSt/80bQgG2XoWD31+PLgBzA1YrvLpLFeNca1OzbRSxitFjSTUeWFipDFkogjHlUNiv5kCc5FiOJ/NEBl5Z+UDiwnWBsDFm7FEcZLEnolzZ1//EU0UzyZIr2kRayc8m6lHWwc3hMXa5b1XPBDdj8DpMf2mmyWaVcTWxC0MjpXbVpzK1zHYnfao+CQptxL4SDAfL5FB8l17oQVA/ESPOd7l4FFeMSUoEVGB0cnKSEyXqhmbcMYjQV/KlutEWQJ7G5aUvAgZUhyh1LbXgzlPyvajQ7v5e07ZcYGuP68IA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(136003)(39860400002)(2616005)(53546011)(956004)(36756003)(6512007)(6506007)(8676002)(5660300002)(31696002)(8886007)(31686004)(478600001)(26005)(66946007)(66476007)(66556008)(86362001)(8936002)(316002)(16526019)(52116002)(2906002)(6486002)(83380400001)(186003)(6666004)(9126004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N7CWJkHaglFFRvoqE//q1NQMLRCzDtaCn2iJcUpW9g0jPgdk4XHyLJThJ10Y8Sf39WIuFDCzpTh8V/fhxwayznJw4olHUhHsD7VjYNk5HoJ1kGYK7w+EkadB+aYrbbbe9kLnTYjBKQTOd5xHZQx0YokUrmGzDAxmhinXt20ZVnEN/bRMuHg/3gARgoouQn2GPpb+sIs4v0G0uXrFsJ5rCpOGqO8lJCPBzSWnQkOWgVuTCvYYQeMhhp9F++r88rza25hZ0e1zZtzVa99JQeMP97DnEKHXt1RAqNRzSlGzQKmeDz0PyBwQMM3P67N0DPphUxqeKm7ddXLdvVIP4Hb5yCKgWlj/bqlV/0rCDygYM+wR5YuflzJc1isKqJzOwj4RGl0hTFDM9vlPCj7Upn8BZ2bAkjqjyr1V5gwSEOMrVwQiH4hEJ3katU6NWzV77AYDj8+HxDEmqVzT8W00+/TI6+4mVy4t+boE8dx0QxJRCcm+IR8ghGvaSFrj3lbOBMxJkJUU6MiCGLirNuhYguVtHUDL6epHpHaSjgWzoKeMZ4F5/YJQ1NHYZY5H/OF1Ph4xn6owrsuU4iZWDLxyto+GUI9q+BbTwAzYJWVLBhalwYJ6WkeCFmlj5tPjHNEx4/MqUbuNiM3nobWECrAl4PXWog==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67897de9-2715-4f27-897c-08d87b3e4d40
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 12:37:58.8608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: khlr9lxbCyLCR9MK7MUv5yHvoSahRoTxaXu7xHvncsyH0Tjkv/nYNFsTbpqCl1Mhdx685YD2R5a7fYMOM8isTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3360
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Xiao,

Thank you for your comment.=20
The patch code is right, but the patch subject need modification.

The bug only generate one bitmap area in clustered env.
So the more suitable subject: fixing wrong bitmap area number when adding n=
ew disk in clustered env

Do you feel better for it?

On 10/28/20 1:51 PM, Xiao Ni wrote:
> Hi Heming
>=20
> In fact it's not a wrong cluster nodes. This patch only avoids to do the =
job that doesn't
> need to do, right? The cluster nodes don't change when adding a new disk.=
 Even NodeNumUpdate
> is specified, it'll not change the cluster nodes. If so, the subject is a=
 little confusing.
>=20
> Regards
> Xiao
>=20
> On 10/24/2020 11:07 PM, Zhao Heming wrote:
>> The bug introduced from commit 81306e021ebdcc4baef866da82d25c3f0a415d2d
>> In this patch, it modified two place to support NodeNumUpdate:
>> =C2=A0 Grow_addbitmap, write_init_super1
>>
>> The path write_init_super1 is wrong.
>>
>> reproducible steps:
>> ```
>> node1 # mdadm -S --scan
>> node1 # for i in {a,b,c};do dd if=3D/dev/zero of=3D/dev/sd$i bs=3D1M cou=
nt=3D10;
>> done
>> ... ...
>> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
>> /dev/sdb
>> mdadm: array /dev/md0 started.
>> node1 # mdadm --manage --add /dev/md0 /dev/sdc
>> mdadm: added /dev/sdc
>> node1 # mdadm --grow --raid-devices=3D3 /dev/md0
>> raid_disks for /dev/md0 set to 3
>> node1 # mdadm -X /dev/sdc
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Filename : /dev/sdc
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic=
 : 6d746962
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 5
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 UUID : 9b0ff8c8:2a274a64:088ade6e:a88286a3
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Chunksize : 64 MB
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Daemon : 5s=
 flush period
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Write Mode : Normal
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sync Size : 306176 (299.00 Mi=
B 313.52 MB)
>> =C2=A0=C2=A0=C2=A0 Cluster nodes : 4
>> =C2=A0=C2=A0=C2=A0=C2=A0 Cluster name : tb-ha-tst
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Node Slot : 0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 44
>> =C2=A0=C2=A0 Events Cleared : 0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State=
 : OK
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bitmap : 5 =
bits (chunks), 0 dirty (0.0%)
>> mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Node Slot : 1
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 0
>> =C2=A0=C2=A0 Events Cleared : 0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State=
 : OK
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bitmap : 0 =
bits (chunks), 0 dirty (0.0%)
>> ```
>>
>> There are three paths to call write_bitmap:
>> =C2=A0 Assemble, Grow, write_init_super.
>>
>> 1. Assemble & Grow should concern NodeNumUpdate
>>
>> Grow: Grow_addbitmap =3D> write_bitmap
>> trigger steps:
>> ```
>> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
>> /dev/sdb
>> node1 # mdadm -G /dev/md0 -b none
>> node1 # mdadm -G /dev/md0 -b clustered
>> ```
>>
>> Assemble: Assemble =3D> load_devices =3D> write_bitmap1
>> trigger steps:
>> ```
>> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
>> /dev/sdb
>> node2 # mdadm -A /dev/md0 /dev/sda /dev/sdb --update=3Dnodes --nodes=3D5
>> ```
>>
>> 2. write_init_super should use NoUpdate.
>>
>> write_init_super is called by Create & Manage path.
>>
>> Create: Create =3D> write_init_super =3D> write_bitmap
>> This is initialization, it doesn't need to care node changing.
>> trigger step:
>> ```
>> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
>> /dev/sdb
>> ```
>>
>> Manage: Manage_subdevs =3D> Manage_add =3D> write_init_super =3D> write_=
bitmap
>> This is disk add, not node add. So it doesn't need to care node
>> changing.
>> trigger steps:
>> ```
>> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
>> mdadm --manage --add /dev/md0 /dev/sdc
>> ```
>>
>> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
>> ---
>> =C2=A0 super1.c | 2 +-
>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/super1.c b/super1.c
>> index 8b0d6ff..06fa3ad 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -2093,7 +2093,7 @@ static int write_init_super1(struct supertype *st)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rv =3D=3D 0 &=
&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 (__le32_to_cpu(sb->feature_map) &
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 MD_FEATURE_BITMAP_OFFSET)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rv =
=3D st->ss->write_bitmap(st, di->fd, NodeNumUpdate);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rv =
=3D st->ss->write_bitmap(st, di->fd, NoUpdate);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (rv =3D=
=3D 0 &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 md_feature_any_ppl_on(sb->feature_map)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 struct mdinfo info;
>=20

