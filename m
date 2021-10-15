Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BC2C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 08:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9632061053
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 08:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhJOJBb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Oct 2021 05:01:31 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:50336 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235992AbhJOJBa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Oct 2021 05:01:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634288363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kPxLG7cNlYv5xB6SUDoygGZzA/mpMJCyeJYNItBRkHI=;
        b=A4jwUPli1SXas4TfHj2okF5kpxnl6rPk3P7kqwLWMF8CDToKo2WEfqGYC9Bz4Zk3ofAEdv
        nyW9Ud4v5K2vrkXZunLqHGqjRk8wunx2Ad/FbJaQdrB50m4RLw0pS8dHZHKHGtPo2jK/Xw
        D0++byhCjH6XjYI51LO2L9o7JQOqBHA=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2112.outbound.protection.outlook.com [104.47.18.112])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-10-d1hDZSe6P7aUeavbzDhlIQ-1; Fri, 15 Oct 2021 10:59:22 +0200
X-MC-Unique: d1hDZSe6P7aUeavbzDhlIQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fg/97wej986ywLxkWbXXrkxb4qBYkqVda33sNlCtRhn1v/cB376F1I5jGS76SOEasT0sN9PP5tirwB9NHponpchLTIZKXLqgv3CmpEVcJYCcmL0F9PoF13Mh2Hzj+dKRz1MjxwB1rtBM5GvD/sLO6MWBD5NguCJazZfBohf1a0uecDAFV8VMYo6C75j91Z2I1TqzpfuJy14V/2DhjRRwbuBL4UgehwX5POQ3Xwr2xEGc0cMkx3O6fTCzahAgA4+lVVDOk64tLdvqw2254s1V0Za+CKGDBF4uawXv2n7n2E1X9sLPLOeipEUEcgaansRmL3TnUmr9I8mO66Gb1pCVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKXCEj6LB1CnpKc3O9GeuXQQ6Ih5mYrTVQ4KdMzlvdI=;
 b=I4ZipRndxS1VXetLuMRot2vb4uUDN2r08Ky064gRHsSE8poVxCPeSh1AYGNS4DaVrtoyI9DQRdWHMbuQaCDFLKu7G7EtYjJ5hLJVHZA+l/DtsKbOVIgSGIEGOxb6bFlVrKCaxTKodm00zwT7zjF3AUf51Vn39WFzbv5uyCLizZ50dXqQAZijFB5dum8BaRQqu2Q4r6hlZBr9pgLA1T4CFm3DyC7FWvXHxd+SDeHGK3PFao/QTWvWaFaudDS6t4Sh07nicY/ln2JelKD1b/5lnLL31Sbt7QSFgS4MscVzNEG1AO8X4hPGCBXGZhDwyOBvkwCKmsVgoKLi5eDPMVvz6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.dev; dkim=none (message not signed)
 header.d=none;linux.dev; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB3PR0402MB3834.eurprd04.prod.outlook.com (2603:10a6:8:e::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.26; Fri, 15 Oct 2021 08:59:20 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::483f:e29e:cef3:fc5d]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::483f:e29e:cef3:fc5d%7]) with mapi id 15.20.4587.029; Fri, 15 Oct 2021
 08:59:20 +0000
Message-ID: <2c33ebaf-66d2-3138-9e75-ab366b395ad9@suse.com>
Date:   Fri, 15 Oct 2021 16:59:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v2] md: Kill usage of page->index
Content-Language: en-US
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Kent Overstreet <kent.overstreet@gmail.com>
CC:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        alexander.h.duyck@linux.intel.com
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-5-kent.overstreet@gmail.com>
 <bcdd4b56-9b6b-c5cb-2eb7-540fa003d692@linux.dev>
 <04714b0e-297b-7383-ed4f-e39ae5e56433@suse.com>
 <YWg/AGR50Vw7DDuU@moria.home.lan>
 <c2e2edd1-8f6f-1849-df0a-46916e311586@linux.dev>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <c2e2edd1-8f6f-1849-df0a-46916e311586@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: HK2PR06CA0002.apcprd06.prod.outlook.com
 (2603:1096:202:2e::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
Received: from [192.168.2.101] (123.123.128.230) by HK2PR06CA0002.apcprd06.prod.outlook.com (2603:1096:202:2e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend Transport; Fri, 15 Oct 2021 08:59:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52f00ae1-3eb0-485b-0037-08d98fba1390
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3834:
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3834A5A4856222A27C62722797B99@DB3PR0402MB3834.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m0A8pB7cXaMOtJP2txR2b3NnCytYrllaVKLe3OwqpriM2enQaPh0RWfwvBQKGGXuebxphYRYN+sk0SZXKqpv0rmdgRbS+m3YlNfKvv0VyIp4vySyw9DLLFdxuc2Q6+nB1IWKFJMLWDeJ6C1tuLCa2Nd2uqiOZq9CZO/dS0MCXi76mbxLNKLSnDWx2dNjr/6d54GjmasHBIUpCfd019gDq9HcAh5xQuyXwQUvtuaHY82om1+6Jqym7sfZc0/N6sQ2N0+c4Ot7ZY3zS2RQgK3mmAumgYxIq/r0Jgl7bBbTp6TeWxNIy72ul0O+NJvUHerWqo9XDvGGNF0OWlMUb7c7Zs8NyQQv9T0KxtSS+e3nmbISXCUTxqSEr3A/PVnmncbq269CblXf24HmN2B6zxsotzKby+IgQXvm3TmtORMIkCOxKPg8CX/WSP5a4yumSAxY4B8YNHcC7yvMbVrCwiZ9kOuZdrDOrejTvCW5Ywc5RI1ThBSKpXwb3SVFfqWw3+qD5ptgN5eL8T03h93Svq/e5MTVROwI+7QTvcOeripswiMgS7SgOLWb8PFIHI9JV9CAqQVUoJEl8JdM0mzRSGlAW7SMu03BsGlQHlUkaClq5OX6upNHVyO0WExbCNU1xRs6Aatl9+PvHOLhrCgUB8kb9tN3MpO3YcIdiqsozysEk1XO67/f2U0weOwkU/ue7k/4HPaPx5nWKuPbWmRhMu21eAhdm097R6aQEgFnUi7GpXAV5tjpSFIcctNXTN/jXi42
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(8676002)(6486002)(956004)(26005)(83380400001)(110136005)(316002)(36756003)(4326008)(508600001)(38100700002)(6666004)(53546011)(16576012)(66946007)(5660300002)(31686004)(86362001)(2906002)(31696002)(66476007)(186003)(66556008)(8936002)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1InWgnO+vnO/zrJJZQDxL09XBq2gXIJyr1a04DY4JmFk85yGm4aiuU7JCABw?=
 =?us-ascii?Q?aCkheO5saBzkCEqFxJTO3IzS0uos0/+K5KcN4vfTiT+Qn8936I1aZZ1q1H/A?=
 =?us-ascii?Q?C1ZLwtkRGu1n48z7piIHIsPEOVNS2+o4AVhHSRQsV9hpzFHw2nGPbVhsu70E?=
 =?us-ascii?Q?7NR0apikEHlnioz1Ru2Q4AUH/+dt2bs4iAV2g4fRjrdQqwU4Rry7CQz491wT?=
 =?us-ascii?Q?smMoSHC2TVnQpVJds9hlWiiIJX6KRfpb7pOHjcFEAtPJokQWyS+S7EEK8N+u?=
 =?us-ascii?Q?CJC3NRwUdZVd6eUURDd8YC5Ls1m/ybnrHjKtQ9nhUAH0mpPy1Z8WmWuK/8Ih?=
 =?us-ascii?Q?63C8NjVfu+PDzGwOZkcki1d5tgSfOvurHNrVPEIXAODcAQBNOmTDmFLYvVg0?=
 =?us-ascii?Q?7CKxvXZw8EyqEjGMnW80SumCMEAMwgvPrnejmFbN4STTYg5y+jPLIAKZTW83?=
 =?us-ascii?Q?+OGL15WBflouChgfQO5H40IdNjUJTxo+KLs4dxynJBeVMNawHXrDnqa+cDFP?=
 =?us-ascii?Q?0jH1lA8lz1L9usd3baKAJQdNRLxUHQGiEj1RhOcOvmlkprYlm1M91m2MHzKc?=
 =?us-ascii?Q?YTq7aroQN3DPeUyWc3AhdSRCWrWHdi1yCLZhuBLpo6Z/dDckPDAW1K+9jPlV?=
 =?us-ascii?Q?9HWbByC9ktLr7MQksiRGfvOD9tzcq070+YXm+MlONBYUlB+U2OvBkIG7avnI?=
 =?us-ascii?Q?xh3b83mncZ5WONxijYUU0MBkrbV8NcCz9z8DPR2wPxxmGujF2oFa1AGdL/dp?=
 =?us-ascii?Q?Pak2dSXteaGdLMzoiWsAhjO31oA0ByDP6a2GXjjl8wfmTgQuELQufZJmTmAK?=
 =?us-ascii?Q?WRKAc2W3ukH1ByJwG0Aj9BRE8DKz3tgEcUB11u1qY6x0SUSvYoMAySu2XWA9?=
 =?us-ascii?Q?Ne252W2T4u/XXCzlAq91DfxgifF1Fjiw1CKPQ0AFl9VjoONLKbXZsR8ktsiF?=
 =?us-ascii?Q?/yTdNBQ+0Qu7VO66ZjDmtoojj3O26bvPMG7aEAee/UDMwtM4fdbW9rNLn1dy?=
 =?us-ascii?Q?CDMq36UBjrSxgXPvHHqP0m148ICNNVAeRw7ESp98kZVD7KMsdVWQaGVBosOt?=
 =?us-ascii?Q?/m7ONwTd0YWGPkeOKaOJbS6hkrizcIqpxm/Mzesou9vbY4igUj/caQKGdU7M?=
 =?us-ascii?Q?heCLzu5pBD+zjCIcsiWk5uP2UVKtbsMbRx1yElkoafxfzxIkpmiesOzSE0QO?=
 =?us-ascii?Q?A3TQHTP+W3HGkhPZkqa2wroQNVSK7eTPEQAFGrjpK9mZpSYWQw3cF9qrxuQW?=
 =?us-ascii?Q?3oSQ4oBtSVdXwj10beIHxNW9wU5nyCUCFiWDybIdb7DUX5hJdJ9EYV1rO/lp?=
 =?us-ascii?Q?/z0AwpxzkLr3A2ma9jOzKJ1i?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f00ae1-3eb0-485b-0037-08d98fba1390
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 08:59:20.7607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MObkPFbqQ6Nbif/+ORGsghYA4b83+nXq0vYb3+J1FVM4KjMbVvRKT1zeRbR0A5RL5D7GGOI0Lr51k7Ty3hjzKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3834
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I agree Guoqing's comments.

In Documentation/driver-api/md/md-cluster.rst, there is a pic in "1. On-dis=
k format".
Which describes the layout of "sb+bitmap" area.

And even in non-cluster array, bitmap area more than 1 pages also needs ind=
ex/offset.
After the serial patches removing page->index, md layer should create a sim=
ilar
struct to manage it.

- Heming

On 10/15/21 11:01, Guoqing Jiang wrote:
>=20
>=20
> On 10/14/21 10:30 PM, Kent Overstreet wrote:
>> On Thu, Oct 14, 2021 at 04:58:46PM +0800,heming.zhao@suse.com=C2=A0 wrot=
e:
>>> Hello all,
>>>
>>> The page->index takes an important role for cluster-md module.
>>> i.e, a two-node HA env, node A bitmap may be managed in first 4K area, =
then
>>> node B bitmap is in 8K area (the second page). this patch removes the i=
ndex
>>> and fix/hardcode index with value 0, which will only operate first node=
 bitmap.
>>>
>>> If this serial patches are important and must be merged in mainline, we=
 should
>>> redesign code logic for the related code.
>>>
>>> Thanks,
>>> Heming
>> Can you look at and test the updated patch below? The more I look at the=
 md
>> bitmap code the more it scares me.
>>
>> -- >8 --
>> Subject: [PATCH] md: Kill usage of page->index
>>
>> As part of the struct page cleanups underway, we want to remove as much
>> usage of page->mapping and page->index as possible, as frequently they
>> are known from context - as they are here in the md bitmap code.
>>
>> Signed-off-by: Kent Overstreet<kent.overstreet@gmail.com>
>> ---
>> =C2=A0 drivers/md/md-bitmap.c | 49 ++++++++++++++++++++-----------------=
-----
>> =C2=A0 drivers/md/md-bitmap.h |=C2=A0 1 +
>> =C2=A0 2 files changed, 24 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index e29c6298ef..316e4cd5a7 100644
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
>> +=C2=A0=C2=A0=C2=A0 write_page(bitmap, bitmap->storage.sb_page, bitmap->=
storage.sb_index, 1);
>=20
> I guess it is fine for sb_page now.
>=20
> [...]
>=20
>> @@ -1027,7 +1024,7 @@ void md_bitmap_unplug(struct bitmap *bitmap)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "md bitmap_unplug");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writ=
e_page(bitmap, bitmap->storage.filemap[i], 0);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writ=
e_page(bitmap, bitmap->storage.filemap[i], i, 0);
>=20
> But for filemap page, I am not sure the above is correct.
>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 writing =3D 1;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> @@ -1137,7 +1134,7 @@ static int md_bitmap_init_from_disk(struct bitmap =
*bitmap, sector_t start)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memset(paddr + offset, 0xff,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 PA=
GE_SIZE - offset);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kunmap_atomic(paddr);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 write_page(bitmap, page, 1);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 write_page(bitmap, page, index, 1);
>=20
> Ditto.
>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EIO;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(BITMAP_WRITE_ERROR,
>> @@ -1336,7 +1333,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bitmap->stora=
ge.filemap &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 test_and_clear_page_attr(bitmap, j,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 BITMAP_PAGE_NEEDWRITE)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writ=
e_page(bitmap, bitmap->storage.filemap[j], 0);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writ=
e_page(bitmap, bitmap->storage.filemap[j], j, 0);
>=20
> Ditto.
>=20
>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index cfd7395de8..6e820eea32 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -207,6 +207,7 @@ struct bitmap {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 * w/ filemap pages */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long fil=
e_pages;=C2=A0=C2=A0=C2=A0 /* number of pages in the file*/
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long byt=
es;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* total bytes in the bitmap =
*/
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long sb_index;=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* sb page index */
>=20
> I guess it resolve the issue for sb_page, and we might need to do similar=
 things
> for filemap as well if I am not misunderstood.
>=20
> Thanks,
> Guoqing
>=20

