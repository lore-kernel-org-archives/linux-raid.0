Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAC2C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 08:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14D99610EA
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 08:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhJNJBP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 05:01:15 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:39355 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230221AbhJNJBF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 14 Oct 2021 05:01:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634201937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pt8sr3JUpf2lJxbtrs11Tn27HY4ywekGVNHnWwfmPTE=;
        b=jMW22ggnxzaN7AWgdy3rZI2Um/BOAqvg5UE74JGl2Xyr382YKeGC0cwD4mTF6g1wTTCPX1
        2zUcqH971Rpj/inNaUnBptlJI5T7I7eTNDJIuXx6bHitdVwm9OuaII2yVAquWW90nWyDDo
        J4t0dfvwHm4fkubU2HbtyjPJlD+iEIk=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-7-km3pfEdpMCGIIqFAc-MvNQ-1; Thu, 14 Oct 2021 10:58:56 +0200
X-MC-Unique: km3pfEdpMCGIIqFAc-MvNQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLKdg0HgTu1clVMM/D6LnHc+/yyzznHzdqaxfkZvBf7VPK3XA2aZ+4nCJlf7gAu8Vryg9BJxLJV/gAsDdAzogEHB1lIH8U+1hd0hq3hK8b0BofltrCLFnOaXSR2VVSsfXt9AXH21c+Nenmf8YdilXS+4WiI+YnNG/BWUpdQNEJv2dgliu7R999fQdN64MBD+L6gYRXynUeiYySLdWYKD94S6fskIANzc4aHIuRbZfrnlOv6L01dWyGFBR+twJh6fNGAgWF/4VIi9zmnKIHqtcW4ItF0M3QKxD0I64UI2RFHqd1qjlfuTdumAhtToXTxs24fCZx4Od7fmu/h34XZhdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lz+HyaufnwzdIoHri3BBshXMFxv8owLG8bLOUlYlwYo=;
 b=UeO9cYC+ySpJIZNqAAlJGfoQ1zUi3l8loZVM4uPD7g+o/khZ4N7dfnV0x3kAr/okRgkE0GT7bnqZ0iqGo1fqLgPNc8JhQO1ATGL6k7ybAlkmHLyTGG2jtkz5djwurnPV4SDoubwPLP3ywCkDc+G+KTZXsNYchHJo8Sb/ptHj70TQuSYbRNfkcWRXr9GtzW6zccJnddW/uZB3ykvXGGJ0TjL+8yk0eIDA0zrIHzpbd4cD/xwZHeJFQhKhgFoUzn2hql6Fj7uvf7gFOJtBpImJLpFrCVKYBUAsOfD8sgrU812NQGb/Wa6ZScHThaVPw+qf0dcYgUGLBW+Ch2B06nKr7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.dev; dkim=none (message not signed)
 header.d=none;linux.dev; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB5643.eurprd04.prod.outlook.com (2603:10a6:10:aa::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.16; Thu, 14 Oct 2021 08:58:55 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::483f:e29e:cef3:fc5d]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::483f:e29e:cef3:fc5d%7]) with mapi id 15.20.4587.029; Thu, 14 Oct 2021
 08:58:55 +0000
Message-ID: <04714b0e-297b-7383-ed4f-e39ae5e56433@suse.com>
Date:   Thu, 14 Oct 2021 16:58:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 4/5] md: Kill usage of page->index
Content-Language: en-US
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
CC:     alexander.h.duyck@linux.intel.com
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-5-kent.overstreet@gmail.com>
 <bcdd4b56-9b6b-c5cb-2eb7-540fa003d692@linux.dev>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <bcdd4b56-9b6b-c5cb-2eb7-540fa003d692@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: HK0PR01CA0064.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
Received: from [192.168.2.101] (123.123.129.70) by HK0PR01CA0064.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Thu, 14 Oct 2021 08:58:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd044e12-4ead-4a69-55bb-08d98ef0d9c8
X-MS-TrafficTypeDiagnostic: DB8PR04MB5643:
X-Microsoft-Antispam-PRVS: <DB8PR04MB56438FF0C0F209FA1368FA3497B89@DB8PR04MB5643.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZqW0dxOGP4EIv/v9n8a9SqK3TrohSXfXhKlLXxI/ahkpGz0IBrrmV1prJiUfWS5sHrpEpLNE/ieQGg50dnvl0C+alosZ3w1QNdYtroVV7WlIYsnqWrBSymSXMTyRARwnNReXBtdv1QFA4e9YoPg2PwC1QZqFmmnDzpAMU7corRQPcwnbvHQwYw7+eTmGlRPfjsr6+Se2J2RW4/i0j74rGwmOvfmZxA1tNICFG8gZ6P9ZfFk6aN+tRKo/qEByJTLgsj0QRq4vKbOXOoE4AHNhWMA+3VgLfGEaWCxNCCOQd+9TOBwbv0aaNnnTnY773Sgthgoniiq3Sq2rXVLBg0nRqf9a1Eo0s/tKUDLbBvAa6zcmE0ByYc5TSafyH/AqaZHxgNk9R46DH9Jjfd553YHl/s9KrLjPTbrqjlqXWmgR0t+zOVs2Os+MCQGRaMn/SZmRAt0xgCKvtnJC9luCfB9RO6OVxjsJ0rZ8ZucZPDbmJxk9NtwjveJBkEvgOnnUCmTrBto5jQ8MnKsQtRHlel7TyQzo2VGApzTbGDIaG/d0QO3IHrx0UpTjOek5DOKOwYtoXLD1OF6d9b1pn9l42M4UxrJG9iiwHfz90fJhkV5iERkWoLEO5++Pu8JWoiGCDIxGQpII5dhsAos8uT6sPWikhTkDhxxbHZow8QY6Jwwqvn0lsoh3f1AcTGM4hGZ1p92h2hNOlisIbL2+oJavOo5ocDS2NVQkb2f58pl30RRcJs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(508600001)(6666004)(31696002)(36756003)(8676002)(83380400001)(86362001)(2906002)(16576012)(4326008)(2616005)(956004)(6486002)(66946007)(31686004)(66476007)(66556008)(5660300002)(316002)(38100700002)(53546011)(26005)(186003)(8936002)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WeRlgwXcWA6OEHwNEMARIodB55rAyC1bQT0LJN7J6PHstf5LwzueWOG/bbmI?=
 =?us-ascii?Q?xdR1pIMzw2O9EzPk2XhOIYMra3cMgQjd7ViNnTI1rUYv8zYjSehte5beMFjX?=
 =?us-ascii?Q?FXrQS9o6uzdSnHsaYkSRXZhAnGBObMnbpGF6oayHlxzKpbCytITmOp5XVxLw?=
 =?us-ascii?Q?L7KINpYcEqvByzLRxlYN7WhX0xDmdj6jmcpNWu7ObXbsrt05Yh9uiNQFjhIZ?=
 =?us-ascii?Q?Bf/fOpqeVi9DT84tYsG9XvnFeq3oQiZWVhDwSGtrIdl2RvD82Lhqcl31o5Fx?=
 =?us-ascii?Q?Tx21DsSCsghrfIp21BiALdmydIy+X+JC1Vb9Z7ej3ediN3/uvwg6J9s6FRe0?=
 =?us-ascii?Q?qIWsLjr3hG2SH11BMvBYft/I0U6Kaq9zv8Li1anBzfIqJA7hM1hdNwSKzIIF?=
 =?us-ascii?Q?/ThrIjdkUIMamzz+vch6ywe42uxb9tD/KE1rWP0YIC19F3g20rkoB/PAxeC9?=
 =?us-ascii?Q?hnpJg+XmKbCzDNfpVBeoU0yqyboPjfohQINSdhoS5eixJ55MCxKbgAO63YXV?=
 =?us-ascii?Q?xg2RWxrlyY0iuCdBsLLoO/Kh4D6LmENOB+96Y4i95GQkSO+g5v7Zb1so2WbI?=
 =?us-ascii?Q?mqg27sunYLEUtwSljb+mi/W5FP8emt4vNsSs4wULvmTOJS3DOa0+NhDQKCBD?=
 =?us-ascii?Q?I83C/KvJ8et/VCD9bNnHYAsr0y+jjEUz/Bvy1Ef0ds9XotTgmqn3g1We97zI?=
 =?us-ascii?Q?8QLde/CgZSxvobhdBob7+2Arj+dteMd5tG1ueKrWKP2JquE3gCg9jVZTgw6o?=
 =?us-ascii?Q?gLZooSz5VbkcIiLT8/RvxjVja7bYTHJ/NUqWXKbKlXM8KNDd0hqkMtr7n7jr?=
 =?us-ascii?Q?TAciqhplp0D2ezV7Pp91ajRws7DVtq7+hlpM8iU051+qTX5T58BJR4DvfzKx?=
 =?us-ascii?Q?+xLIkAYFZ7v+/e9GtH0uMJIUhVMqIQmCFWxC6Spt0qxalSOEzVA1hn9nqQLm?=
 =?us-ascii?Q?dhZMZo07iEx8tJSd9tkmpkeVqzVJjeyteNv18apONSxLpvsDI072TJVO7fbG?=
 =?us-ascii?Q?ptk7IipRUFmTmGhGVD3VpHpYevoiF/INzOxOAXyE1urFIxqArgfpctgYX4vs?=
 =?us-ascii?Q?73OvC81SocSheHMH+te+hpCarb2z9Ran0zM5xC28fmRFTpLZvvf88wL+Hiqd?=
 =?us-ascii?Q?NMP6UyPfYHyCeVHouFXb9sNLv1Dvoj8cm/AC16qVGqMS3DBlToZ/gs8DqmIS?=
 =?us-ascii?Q?WwNkQfgCnAxLNBrmM6ZXmztgPyFMoca4BcqoM7qIQZMBLKzkyKyAN3NcSPnF?=
 =?us-ascii?Q?Tb/so7w5Cnwzx+YEKlZ6rENOsStQU8IknD4B3/agTmkhftmgdosSE6yNSEeX?=
 =?us-ascii?Q?4m+67dI3BPIu0E8xiONs3F3X?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd044e12-4ead-4a69-55bb-08d98ef0d9c8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 08:58:54.9554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: roatJZ6J+0KXMZvsgBJMUaYfDXIPjV4pyUuJurGn5TEtma/7xrVflCcQIoFfLxMMYSULHYfIoTbP5+tqJeKUaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5643
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello all,

The page->index takes an important role for cluster-md module.
i.e, a two-node HA env, node A bitmap may be managed in first 4K area, then
node B bitmap is in 8K area (the second page). this patch removes the index
and fix/hardcode index with value 0, which will only operate first node bit=
map.

If this serial patches are important and must be merged in mainline, we sho=
uld
redesign code logic for the related code.

Thanks,
Heming

On 10/14/21 16:02, Guoqing Jiang wrote:
>=20
>=20
> On 10/14/21 12:00 AM, Kent Overstreet wrote:
>> As part of the struct page cleanups underway, we want to remove as much
>> usage of page->mapping and page->index as possible, as frequently they
>> are known from context - as they are here in the md bitmap code.
>>
>> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>> ---
>> =C2=A0 drivers/md/md-bitmap.c | 44 ++++++++++++++++++++-----------------=
-----
>> =C2=A0 1 file changed, 21 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index e29c6298ef..dcdb4597c5 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -165,10 +165,8 @@ static int read_sb_page(struct mddev *mddev, loff_t=
 offset,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sync_page_io(=
rdev, target,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 roundup(size, bdev_logical_block_size(=
rdev->bdev)),
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 page, REQ_OP_READ, 0, true)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page=
->index =3D index;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 page, REQ_OP_READ, 0, true))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 return 0;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>> =C2=A0 }
>> @@ -209,7 +207,8 @@ static struct md_rdev *next_active_rdev(struct md_rd=
ev *rdev, struct mddev *mdde
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>> =C2=A0 }
>> -static int write_sb_page(struct bitmap *bitmap, struct page *page, int =
wait)
>> +static int write_sb_page(struct bitmap *bitmap, struct page *page,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 unsigned long index, int wait)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct md_rdev *rdev;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct block_device *bdev;
>> @@ -224,7 +223,7 @@ static int write_sb_page(struct bitmap *bitmap, stru=
ct page *page, int wait)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bdev =3D (rdev->m=
eta_bdev) ? rdev->meta_bdev : rdev->bdev;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (page->index =3D=3D store=
->file_pages-1) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (index =3D=3D store->file=
_pages-1) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 int last_page_size =3D store->bytes & (PAGE_SIZE-1);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (last_page_size =3D=3D 0)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_page_size =3D PAGE_SIZE;
>> @@ -236,8 +235,7 @@ static int write_sb_page(struct bitmap *bitmap, stru=
ct page *page, int wait)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mddev->extern=
al) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* Bitmap could be anywhere. */
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (=
rdev->sb_start + offset + (page->index
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * (PAGE_SIZE/512))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (=
rdev->sb_start + offset + index * PAGE_SECTORS
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 > rdev->data_offset
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev->sb_start + offset
>> @@ -247,7 +245,7 @@ static int write_sb_page(struct bitmap *bitmap, stru=
ct page *page, int wait)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (offset=
 < 0) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* DATA=C2=A0 BITMAP METADATA=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (offset
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 + (long)(page->index * (PAGE_SIZE/512))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 + (long)(index * PAGE_SECTORS)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 + size/512 > 0)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* bitmap runs in to metadata */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto bad_alignment;
>> @@ -259,7 +257,7 @@ static int write_sb_page(struct bitmap *bitmap, stru=
ct page *page, int wait)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* METADATA BITMAP DATA */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (rdev->sb_start
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 + offset
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 + page->index*(PAGE_SIZE/512) + size/512
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 + index * PAGE_SECTORS + size/512
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 > rdev->data_offset)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* bitmap runs in to data */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto bad_alignment;
>> @@ -268,7 +266,7 @@ static int write_sb_page(struct bitmap *bitmap, stru=
ct page *page, int wait)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_super_write(md=
dev, rdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev->sb_start + offset
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 + page->index * (PAGE_SIZE/512),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 + index * PAGE_SECTORS,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> @@ -285,12 +283,13 @@ static void md_bitmap_file_kick(struct bitmap *bit=
map);
>> =C2=A0 /*
>> =C2=A0=C2=A0 * write out a page to a file
>> =C2=A0=C2=A0 */
>> -static void write_page(struct bitmap *bitmap, struct page *page, int wa=
it)
>> +static void write_page(struct bitmap *bitmap, struct page *page,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 unsigned long index, int wait)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct buffer_head *bh;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bitmap->storage.file =3D=3D NULL) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (write_sb_page(bitmap=
, page, wait)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (write_sb_page(bitmap=
, page, index, wait)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case -EINVAL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> @@ -399,7 +398,6 @@ static int read_page(struct file *file, unsigned lon=
g index,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blk_cur++;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bh =3D bh->b_this=
_page;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 page->index =3D index;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait_event(bitmap->write_wait,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 atomic_read(&bitmap->pending_writes)=3D=3D0);
>> @@ -472,7 +470,7 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sb->sectors_reserved =3D cpu_to_le32(bitm=
ap->mddev->
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bi=
tmap_info.space);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kunmap_atomic(sb);
>> -=C2=A0=C2=A0=C2=A0 write_page(bitmap, bitmap->storage.sb_page, 1);
>> +=C2=A0=C2=A0=C2=A0 write_page(bitmap, bitmap->storage.sb_page, 0, 1);
>> =C2=A0 }
>> =C2=A0 EXPORT_SYMBOL(md_bitmap_update_sb);
>> @@ -524,7 +522,6 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitm=
ap)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->storage.sb_page =3D alloc_page(GF=
P_KERNEL | __GFP_ZERO);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bitmap->storage.sb_page =3D=3D NULL)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>> -=C2=A0=C2=A0=C2=A0 bitmap->storage.sb_page->index =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sb =3D kmap_atomic(bitmap->storage.sb_pag=
e);
>> @@ -802,7 +799,6 @@ static int md_bitmap_storage_alloc(struct bitmap_sto=
rage *store,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (store->sb_page) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 store->filemap[0]=
 =3D store->sb_page;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pnum =3D 1;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 store->sb_page->index =3D of=
fset;
>=20
> The offset is related with slot num, so it is better to verify the change=
 with clustered raid.
>=20
> @Heming
>=20
>=20
> Thanks,
> Guoqing
>=20

