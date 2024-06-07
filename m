Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2104.outbound.protection.outlook.com [40.107.7.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694721C2BE
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 07:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717745284; cv=fail; b=ZdSUItd4YI2wCo/yIYog1sTKycoOmv8u4GFlkRHc0r8GwhnaomsyoP7IJczs9uAqdStKPyNrqP0XcvQmbEDn0zD/1EptikHdhWGSccZTo48uLIiHX4TvmRwJBFSsWTuECxUTJ/OH9QsQym0yZNd0H5rY6QmgfQrjtt3lxUjpODk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717745284; c=relaxed/simple;
	bh=SfSArvFe1uSn2ZjFLBEUMuvxitdRIMmzwqd+ZiJjMOY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=beFZWQbIdblEUZeVCJCpA1a3+JgqYyqVNGUZsQcphkdj5h2uLnTl9n6+t+iTHA8snzenSZ/UOIMc0Q6R3uopM7N+m4QnFsQfU7qw5+q5oEsAm/4YXOHZSQH0gQYMFWVApxHbyV17Gpwe08HWD0ar+8avosVUbvsCUJooyGdH6TA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=UjWj5y7B; arc=fail smtp.client-ip=40.107.7.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="UjWj5y7B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoKON6um7k2dE3r9UJwZf+AsYjH1ZbgIJE8+KmmFWpfgBTbcbxVVTbQ1hqxqaK9a0vvHy+mnjO2kYO0+reZwANVvvJKehPV6NDF7B40k9CsZ7cPvDiDwnH9zNWutDluGS2d5srSQbZEDkgJgPbnueUoxwbhTeTf5tC9QeCwRLfoiheRrXCjeZn9DaV3dHrThj06/29mGlBOdlftOvXdWNDzS3r9Famjx0GaVcRVSzWeAwvauFJPdrWCxSBv5JxgpFowYPLevgUGuoZ6RZACiASFYy8zTHl6485FTpMW8u3bO9lM0ICpqBUx7aKqqTUC+BwO3wP08bBD57hWh5SfnDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ewf5J2n8toMkMhABVr2q+AexH2n7Yc2jXQxd5pvfNU=;
 b=LghTdTJLV/t57AX6usv13dq4rv/Z7mYC1r7BU1YDPmSAzoCNv1b2j9EmjaW0ClDnj7AIPW4XZACXGaZcQkDnvhez/51itY5zspq7GfybUoQUdeXJE0rGVqBvSxTGSNAux3Y/WI3EA5Cql9/r2ol3l698K3N87xNasgjlp5Emxm4IIrkq2x9LMDBAZPpgaGqb8NjutIONMvXBHhe08besqY2BL3JOOt+HE1L1PbCQ2AidAroVzlgweKvPuDcvD1W4bnSOg2/ea08Ar8q6Q8JN5bPUQgp/dmtVEmyDqPr2roY3Rq+ryR7OjFuDW/vgLqTCgNwspNgPq8ePenHcnwqfcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ewf5J2n8toMkMhABVr2q+AexH2n7Yc2jXQxd5pvfNU=;
 b=UjWj5y7B5zLpjrNV5IzupkPZUAVib3TvIQkGzJ6oNDJS1NELZ157ZjNQEvEZ6Dni3B4X+uS1VYM+FIweWtmnvf2ce3w60gWSrEfU4dT3Wrc62+1muIu4bxUJxJEF70l92nHwmVNsjTjo4zE16BWxwC6fRux/v4+0vAgXY63w8u6b9A+0yWWMQD/t2Lidvc+0SKuUGvrXiilXXJz6zx5mwc49XaRQMhGJoA/go9R5nZmlLe7oAuHxnMQkCxoiLLUPp3Jjww2weevvc/6SVvBILf3Fud1JsSTZyHSi9mUJysC774AgGIUAIWo/FD2URdBbpKikKsObCb0iuUpVdEJqHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AM9PR04MB8273.eurprd04.prod.outlook.com (2603:10a6:20b:3e5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Fri, 7 Jun
 2024 07:27:58 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.033; Fri, 7 Jun 2024
 07:27:58 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: hch@lst.de,
	linux-raid@vger.kernel.org
Subject: [PATCH v2] md/md-bitmap: fix writing non bitmap pages
Date: Fri,  7 Jun 2024 10:27:44 +0300
Message-ID: <20240607072748.3182199-1-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0012.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::16) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|AM9PR04MB8273:EE_
X-MS-Office365-Filtering-Correlation-Id: adc847e6-77b0-4911-89c0-08dc86c35ae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|366007|376005|52116005|1800799015|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SNtCLUIqvLCxI55bLGoRXOwM554oFqYNUaIFerWo0U1AG2TFejns1OyHnGTV?=
 =?us-ascii?Q?4Vo/m5IohQ2lmB3X/+N2ZMgbe5nUcUkLOuJOLGp8/ROsMyIeFInnFU0Sv7EI?=
 =?us-ascii?Q?IlxT3jMfrcihtIhJl0dcSAbQguoYM2x1yJHHgPtXHtu0T690CKE5l/bQP18b?=
 =?us-ascii?Q?6k4yyUdbjdJUF8GBxPPz2aTwk7aQKKA7rHTrbWkqeCOqh+Uok71a0sbJMbGg?=
 =?us-ascii?Q?XPUB/wJv6NMQyJTJ9d14ma6dslDrYR3r1Sx3zW8/4v7thuW1NsKCtWYnGEJp?=
 =?us-ascii?Q?K2sllsmL/2kCSSOhDG/3NoYqTC08gslbpRr8PO5lp4ehETZfscpKXUaVvlKy?=
 =?us-ascii?Q?6Ykb0zAKdM9+5KnJAmp9TN6wOUDzx/VtEkn4gKKFekYh2o6Xn2qPiCtMJ3lL?=
 =?us-ascii?Q?AZO9/wd7kKAOTmn167o2RoaYNBXLd7VZKmZCYtiQlt/c9BVqFukYxtovjTtA?=
 =?us-ascii?Q?1Q00u8YL8M/Z3wtv3qeSAULXycyQEAHB5/RYklAQX5QMNwuAk7IfQZ2wHnpH?=
 =?us-ascii?Q?JmK9MxuIrW/lK7ln+9M/AZAc0uRhwtrnFdWBivIX4glM/Nmvvzyddmmly0hM?=
 =?us-ascii?Q?fOuwAs1RpcJ6Yus9JmHX++BaZc0PwMYr7zsL9kLifqMBEZZuzJeDsTcbn6GK?=
 =?us-ascii?Q?SeMzttJLo5TImGJUkd9YN4zECsmxpjw3zyx6KJh+g6jPT/h5LTwYnS74QYDT?=
 =?us-ascii?Q?gxLbuhkuqeLxLcyjPc0dlhRe7mTpCryE3o9kxufsyaTjYOLU2W1ulzQGRg3V?=
 =?us-ascii?Q?IRTQFtJWg9DSCMu3L6+FwPj1oP2MzF/leQeqB/JoJMLlhjKyiNn0MiUOj3ak?=
 =?us-ascii?Q?6jfrricAxT0YozHZ1i0GmsKS1X+49fz9A7D1sSwWcVA0PxTbgB72gIqBX1F2?=
 =?us-ascii?Q?stt+1rMFGUkvyFg/S3W6gFkxCynxDiSoeCWxdnoOauJXmcFFrkZMu3RbUnf/?=
 =?us-ascii?Q?Rw2H9AsZii/lFBlXRg2SocTSdeFg+yRkcsn2OMtZIVe8tpOy9neLPP1xl7P0?=
 =?us-ascii?Q?Ajxq+vLkRbTUB4Igt7IlfEUzSzE4f1bMHFv7GA4NhJNUuIgZMiSLCHlbmWAQ?=
 =?us-ascii?Q?dYfRBgAYHaVbzbCUfDjlJG7ZXTn2JHCQUAYGrv7t0WmISVzF/1SpJRk0YthJ?=
 =?us-ascii?Q?eV49myEUplepnyrQZu2nJXVnRpDVW2hqHFSpZQm7TwbBTYSbrZy6LoR3dcX7?=
 =?us-ascii?Q?PnydtAeyOkj3OTNUdDG+JcBn9g//0L2mbNL4p3I4ENwKUBEBIp/fGHy3lyxJ?=
 =?us-ascii?Q?oMlC7upHwi++J73zw4pmEJj2FzvTiUTvQLZl4bKavm3VBT2qhYiLpv9j0F9d?=
 =?us-ascii?Q?L7iJL8OjBXX3slwAMsfi10fr4+7KZKtpGBcD++ufudc1LJ43K7PxFEzyOsvp?=
 =?us-ascii?Q?cFHid8I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(52116005)(1800799015)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xsnwgL4FmXIiwgNDwePo+g18xaoaruJDZUxNp4t+pw7YFJMvAF2GTjSScnGd?=
 =?us-ascii?Q?9binRKAvWdurkm1o5cqeopMkloOPDoJWHTnSaKHP+JUdZqA2FTa5SglhJ3W+?=
 =?us-ascii?Q?oyxPlCOQ/ZKaZcGBY8zqJYi8gsD3zD7kngQzVGPBTlFqVJmBJfyvexrLOUgn?=
 =?us-ascii?Q?F6C7H/NVC0s406DhpnwBIP2msvEQ6wxiph/TXb+aS01PV3a1k/pYejdPwWhV?=
 =?us-ascii?Q?svIJt2YoCljZW80xA66LZAiaFc/dc/GUUnO6xBhRveRPKUog+eVYQ+mNdlDn?=
 =?us-ascii?Q?ZFKmWCVu6MQyLTUnj4fcpCSmMbJjDdvud/6q9KFMAMUhCnzfJgk3aLSofqZs?=
 =?us-ascii?Q?0MNI25IeSIsvzASlIZPPfEd/U2wh2mVMbhcf2+lx8JMMPxtC47+hxp1OUdst?=
 =?us-ascii?Q?t00vzDnhiHiz5xrNo09ZKiG1pFRy3PNAzlukeAwydQ6yV3Bzlt/lWIqkh8YJ?=
 =?us-ascii?Q?XBXO+BjhhdnQepiar8m1i16dfSuzu2Z5jBrcOCd0xTVzV8msIAzifo1uZA+q?=
 =?us-ascii?Q?F9V2x+qDMdQBGxwli2g46GgyxQHlR3F/nDungyOdT69VpbDSGNjB03i4ky56?=
 =?us-ascii?Q?LA0BemUIP48abFUir5zZwIwVzNmywT02u2SSusH7LkAAal22No8iCb5IMZVV?=
 =?us-ascii?Q?+adLLbPQEifd4hUapZvYjD87qqFN++xmeYDSyjbnXZXGmZq33/8MD3CppLTg?=
 =?us-ascii?Q?Qs37FNyPbwfqmm4mKbGoxMsIXlPW+qucTF/0L+qVqJOqIgc9yo/Y25WzkF75?=
 =?us-ascii?Q?YPhLEymUUQON9+3Ytjpta0qe4KgzGLuOkTJzHiV3qWLxU0v572WJV64Y99Qg?=
 =?us-ascii?Q?Uc8lQHfLgyEhS63Ljvc1CkovrjlH8/LFyZNebOTZtD4g13rMVqcRCX17KJwV?=
 =?us-ascii?Q?5wIZIEzg5c/CxbH+kh8CHxqITZ8841th/i7k+tk8ForCI+OzhqjS/2WHNzUv?=
 =?us-ascii?Q?cTw4KprY/14OjxflC9TwKtXU1IkZEetBJo5K4uu2O4W4bxW38TlR/KPa5Fnc?=
 =?us-ascii?Q?EwWVlgNsQ5i+QaBHAtAcZXlOWTtc/ulAta7fBAV2c9bSTwQ1zxDCVHkWhIRv?=
 =?us-ascii?Q?Eo98PoWsIoTeq130Fw6n4EZKQUowngVeuF6r0vkGaiA5Hj0vryNsrZ+pB8rT?=
 =?us-ascii?Q?TVjimI73wwYOKRjRo0XDUtL167wOFCKPzcWQ3VbuLvfx9zu4GR7bUxO0+W8K?=
 =?us-ascii?Q?0PbBCGTHva3cI2aI7U/zx2GMjBo5WCNFJNfvsH0gA8KgCMrLu5VpskZfpKt8?=
 =?us-ascii?Q?1OHYqKUaYBBDM6Yk3UgcW7jDhoepblOtvcGyc5Ag2dwwiyVNRwuPaok3FHOG?=
 =?us-ascii?Q?AN768/rhKGieOUEvBc6QQRn0kCwVv3TByq9jwePufobS5y8ph+fJQXpS72Ie?=
 =?us-ascii?Q?ZRd8AYg0H7hnxOrC0TS8z7+p5Sn2u47JYqtacS3lOAew+MvKGP2Md0nu/iEW?=
 =?us-ascii?Q?dOVY9kpK8Cmv5vIpq9i0tJi+8t4fcyFoFkFSeXfEhyHpssVsDiIm/6kILesS?=
 =?us-ascii?Q?jf6Q6ohOnxsRoN6wIWCOaEsnW3RtGFvphJQ8/a5Ywcfdw6h1Gv5s6o2kRZ6p?=
 =?us-ascii?Q?4qIVhF0SwPj51LR+Brh0s51rVgPT6fQY7cTEFIs3?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc847e6-77b0-4911-89c0-08dc86c35ae3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 07:27:58.5186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DoTBkYiKzEXgfraJsPdGxAX/opY+n0wpuENs5NeooMrS67npFGbyTqsLd4KmM9OEF4lDNTybqbh+8Y+ZrZLXaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8273

__write_sb_page() rounds up the io size to the optimal io size if it
doesn't exceed the data offset, but it doesn't check the final size
exceeds the bitmap length.

For example:
page count      - 1
page size       - 4K
data offset     - 1M
optimal io size - 256K

The final io size would be 256K (64 pages) but md_bitmap_storage_alloc()
allocated 1 page, the IO would write 1 valid page and 63 pages that
happens to be allocated afterwards. This leaks memory to the raid device
superblock.

This issue caused a data transfer failure in nvme-tcp. The network
drivers checks the first page of an IO with sendpage_ok(), it returns
true if the page isn't a slabpage and refcount >= 1. If the page
!sendpage_ok() the network driver disables MSG_SPLICE_PAGES.

As of now the network layer assumes all the pages of the IO are
sendpage_ok() when MSG_SPLICE_PAGES is on.

The bitmap pages aren't slab pages, the first page of the IO is
sendpage_ok(), but the additional pages that happens to be allocated
after the bitmap pages might be !sendpage_ok(). That cause
skb_splice_from_iter() to stop the data transfer, in the case below it
hangs 'mdadm --create'.

The bug is reproducible, in order to reproduce we need nvme-over-tcp
controllers with optimal IO size bigger than PAGE_SIZE. Creating a raid
with bitmap over those devices reproduces the bug.

In order to simulate large optimal IO size you can use dm-stripe with a
single device.
Script to reproduce the issue on top of brd devices using dm-stripe is
attached below (will be added to blktest).

I have added some logs to test the theory:
...
md: created bitmap (1 pages) for device md127
__write_sb_page before md_super_write offset: 16, size: 262144. pfn: 0x53ee
=== __write_sb_page before md_super_write. logging pages ===
pfn: 0x53ee, slab: 0 <-- the only page that allocated for the bitmap
pfn: 0x53ef, slab: 1
pfn: 0x53f0, slab: 0
pfn: 0x53f1, slab: 0
pfn: 0x53f2, slab: 0
pfn: 0x53f3, slab: 1
...
nvme_tcp: sendpage_ok - pfn: 0x53ee, len: 262144, offset: 0
skbuff: before sendpage_ok() - pfn: 0x53ee
skbuff: before sendpage_ok() - pfn: 0x53ef
WARNING at net/core/skbuff.c:6848 skb_splice_from_iter+0x142/0x450
skbuff: !sendpage_ok - pfn: 0x53ef. is_slab: 1, page_count: 1
...

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
Changelog:
v2, split bitmap_limit line after "<<", removed pointless case, add
    Christoph Hellwig review tag.

 drivers/md/md-bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0a2d37eb38ef..08232d8dc815 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -227,6 +227,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
+	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) <<
+		PAGE_SHIFT;
 	loff_t sboff, offset = mddev->bitmap_info.offset;
 	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
 	unsigned int size = PAGE_SIZE;
@@ -269,11 +271,9 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 		if (size == 0)
 			/* bitmap runs in to data */
 			return -EINVAL;
-	} else {
-		/* DATA METADATA BITMAP - no problems */
 	}
 
-	md_super_write(mddev, rdev, sboff + ps, (int) size, page);
+	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit), page);
 	return 0;
 }
 
-- 
2.45.1

