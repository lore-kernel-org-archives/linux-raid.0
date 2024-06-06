Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2094.outbound.protection.outlook.com [40.107.20.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE5E13D28C
	for <linux-raid@vger.kernel.org>; Thu,  6 Jun 2024 15:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717687962; cv=fail; b=lGBMK411Oku9usJ+3sr5M7VdZiPlJK8zfmMA1iC/8HGE5owg/lnGDwgIQxQkfIx7XUJvc5dP6EWkz2ceDqDpUHYTpshmByPiIuYNTNVUNyjmXYNNoQRPlKJQSX7SdJciQ9W57xd+KJF69YiLsMpzluYnl85y6FwuxPCdiaXGMiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717687962; c=relaxed/simple;
	bh=XzKhEhXn2MHduKcfdVX7BjbhCofyoTuB/c+6TuKxfmg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=L0x/LErZGD2wzq4XW1BJzU2kmxNi5qUJCtgbxNGy+4Zw6ay0+tjsjTawq7ONOK3lK6iovfHo5uPAah4aLFOh8NCkYLO2iin5vEFVgbx7gCe37W387OBX5cya4EQsPk7iOs1892D+aiuxo7mV8C5drQAwS19k0hp+5TZ5Uk06UEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=DRJlztu6; arc=fail smtp.client-ip=40.107.20.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="DRJlztu6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJPX10dcOnCifINcZkdBtZyy6MyjXAIfPsI/mnW3+wWKbiGqwm90vKIHUvFNokioL8/tnyv5PAc8+PoQKIPeib5kKEY6FOdCBfgEZtwUHpdiYBEDuXqD99MEZzKLWBP9wD4WfRloB0PKeZhjo4W89weMrpv3+pJKCuDo1Mjgd3sEEEoxb9/4A5llx+mC5Gu3ExWVf+OWf1s7eY7OLi1UL4O+B7bUq7E5YVgcWk2IwfMDY3CkqWLiZGb+p+I/tcNxcHl5kcHS3uHjZN8MpBIy+JGrMRm8oyJWvdT0UrJ7dd5dnHHXWZ6miSS323lHLeqdRCkXQZRm7XmfDN3UPXmDow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JJLcQNS9zm87qYt8ibjavI3Xs0pDIPjwrfFVEdkGHM=;
 b=QCOjRZaxbuDM6jF6/a14lOcQsu6Al1M/TZho9MRnk+gopgLs4xMpJSKpG2NKmSsFdpH/SAcyoKruf/1tEVKcaTpuWCgHUo+WzTHxNM2KOHuhuy+R8xErSfBPktvdK+LNG2rGP1lJj4tzk5pWrp436yHJA3E/42RTnEHOxHmufmKlxYiEnSfJTruGi11UElDaP7RVbNhGHSLp09P8Z1JXoqckhQFJE7YARG6i7D5iY9UQMttZ7di/VZxYznxQZgI+yairxWshecdtTZc8IF96dwX8kjDHCHNU6VxkYYVlqP7E/z/h2aiAW8aMq/RE9Ds21PVxkw1joo3Q2bw2AODcog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JJLcQNS9zm87qYt8ibjavI3Xs0pDIPjwrfFVEdkGHM=;
 b=DRJlztu6oN96vNwf885lC2RLcBMaHkcP/Zjq7qkKaNxADdpuPsFIhW9gH1r/BCh5FX8rRkZidYBCaz4Qgd+L/mKkhEaiF1t5HW/C1tLYuIri6w8aXA12sTpyRom12S6KYeDabnWO65Inho4Fj575EXETq27JC7YlvFPE0RFQhuucGDhNERfYpuuT8tmrRhoLzgTpEsvnDIQKrww6eWfS73Ju5Vi0k66yvvR+rsmI4Mha+6XF6bl3iq2O7iaF7qV4tfzLQ3MR7cI31Lua1V5vLvCfDidw8BFHuyUwO2UZNeThxwPEByz1eBdUHsF7bkU4X+NgYW1m+jI5muYZfSDIPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AM9PR04MB8523.eurprd04.prod.outlook.com (2603:10a6:20b:432::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Thu, 6 Jun
 2024 15:32:35 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 15:32:35 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: hch@lst.de,
	linux-raid@vger.kernel.org
Subject: [PATCH] md/md-bitmap: fix writing non bitmap pages
Date: Thu,  6 Jun 2024 18:32:20 +0300
Message-ID: <20240606153223.2460253-1-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TLZP290CA0012.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::10) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|AM9PR04MB8523:EE_
X-MS-Office365-Filtering-Correlation-Id: 36afaa37-201f-4c8b-1a95-08dc863de39e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|366007|376005|52116005|1800799015|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?btxNnzGpAwARb+KVF1iUEFaqcsPTTtA7XC2vm/Wcr50Linmy75WPfMzaFzyR?=
 =?us-ascii?Q?Rd1ET6G+JmgCmhRkABqj6pddMZFSRQONxS5Lr5zAbKZAiJI/TFZa2x1MoDoh?=
 =?us-ascii?Q?OQ8ErNbwl3eYOVF5qotsx2nUQzf1wG3IyQOwrYMsrOlOf9ePJg/cQFik++2S?=
 =?us-ascii?Q?CVdiv801kOw4/c9Frq8gPyrcNN9MYoOeFbywXXkzTSj5g4RSktZkFh98QBOg?=
 =?us-ascii?Q?D0uAZgM9OaSki1pHQdSEH60MnJFNh3ym00fYBpVaWIVky8sbcHr3eJw2D7Fx?=
 =?us-ascii?Q?ft6xlQJ6RsAqxCkDVcUYSgs2SjSe7xa+giLO9xU3uI4bjEJ1Q1rX9N/ptNyQ?=
 =?us-ascii?Q?BMsnyCdQg+YKD39mVNp6sQI9MvVyinVKblNreOIcjICJydADsKmbcqYhK8VE?=
 =?us-ascii?Q?pZn2sXDHyYu5nzoVxZYHoERuU/cGdTFESyuFUZSq47EswqucA+gmtcl+hfX1?=
 =?us-ascii?Q?BTNwYHEIO8PESJAwTTrHQwffu62LJHVWeP1InrrIplbZMIhuOxP3Ovy2vaBx?=
 =?us-ascii?Q?b1DCLp8//5co85q6/97XqgNbFApDp18erjzBtXBPzgppRiEt5pk1hug48cL2?=
 =?us-ascii?Q?m8bnKxjFA0MORugfIXt+vILzRTYbInlJTnt+f1U8w66C35KtTuq9O4RBKC3d?=
 =?us-ascii?Q?cpIAQdvm4dqL21mJVNXIcv9drNrwsK6l0B8yypTllSW9tegFJuv8oylusmF5?=
 =?us-ascii?Q?1c6eDtmWiDq6mACXzyOVaKUAVrqu/PUCbVBvDm5f8I7qeXzGas02xfYO6DQT?=
 =?us-ascii?Q?U0OmlasihvNiDysOraz5paXN8I7OY8UMjXUrNT324QRUeYatExQByzcMGZ+6?=
 =?us-ascii?Q?UT1G7DPkD7o7+SEYjBx+gDVNlcvv2y7kS1Rh2N2eI0K/OuwFuUKbJjagBDQR?=
 =?us-ascii?Q?ZZ7x7WgnzJ4vYz4wyz2kgztkXWo+Xg/hfXbKW9N21jJb951Hz55CzB92572k?=
 =?us-ascii?Q?Jz/eFCqO/2VzM6rvwvkB/ZYqObIVvnwnl5qr3fod/sGJUz1j4r5MtQi+CuVX?=
 =?us-ascii?Q?wcf0wrma4Ck0aNlFO5PS+iij4/3VWuZa8UqyP5Gz6r9PFWfV9IAkjacTP8PQ?=
 =?us-ascii?Q?Wkha6ICYUTFwVDy5oTsdNrapoyLFDaqy7ZjCo9lW9ykTWT+JBMIcjeycZGhU?=
 =?us-ascii?Q?Vwf2hZkd7AXR1XV+0FPako9MrcIMj+x95rGlXxcqXQNkYJ96rck2vhd3xerx?=
 =?us-ascii?Q?GRU0CqMZhA4EJTIkKuAP4DHaB+ezHXsQoBSZOjiZKE5fE0tLkIrcYMJ5jJMr?=
 =?us-ascii?Q?lYOD3DGw1RvbUne8m5vieYAF6wzOEgVlzllMosTKYeefvYBZMkQDPCJnfBoz?=
 =?us-ascii?Q?aHg9qCYEnU9bReCtRH54FP8T0MZNLK0AOQ+EXjJnUP+L4DKkzeZ52H0Xbw01?=
 =?us-ascii?Q?ZwftfEY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(52116005)(1800799015)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qWDXoC4Q7SDX98SQcwQsy+YycFmMW4Q6tXnGUNZzDVBpL54/2WFzMyJbMh4W?=
 =?us-ascii?Q?cqVSmC6czHbsGx8+QBRNXNH2dtwmJF3c4dfW4EZBZ4hvrHjeUoBSQo5QTT5f?=
 =?us-ascii?Q?V2NgariSbAdObU3IpZNAeabsjy5+3xsC5OEkZ2naGW1j2aVbvyVztpER24P5?=
 =?us-ascii?Q?aZEayc6pooq9MXnDLKK1XkMyG36Lh1ABcomBUKkxTYf+WZkzeyNjuqx16hXE?=
 =?us-ascii?Q?lQo/9FGowJ+NY80rW0LWcOUFZ14cEUA4MD298zI2Pu9XxNsRec1hBbERBG4l?=
 =?us-ascii?Q?1VVingdykTBtlCk8Nu/w0SxylwatYKqmiac7IDhAWiFbsuPYfNX/XwmnMuGc?=
 =?us-ascii?Q?7HxoAyot5vkdHDm0Soe23MvSewrif4IhIaLprtLStt1MGQ4DVNtTpTNe9Un3?=
 =?us-ascii?Q?kdTW0AMVbavCEdFJ8n4wDfLjuzeNIiHat26d12i4Jsq8mkw9g9IUxEdfcirk?=
 =?us-ascii?Q?Wzt+i4dgFLcYGQoVgK3i+H+KiNw7KrSGORqowE8pp9v4ODMZ1f4X19CrgKlg?=
 =?us-ascii?Q?g9E7eJCv7/z2NIvNSImK5cpbIkNYNRjA7iqqgQjJBqXk2TAkFdflmoR+883Z?=
 =?us-ascii?Q?2RCfFNislKTdB/6aLHpw/fizVFpCky3CETrNEpG+E9VCWrPOyWCVkhSNj9po?=
 =?us-ascii?Q?GZFmEJX09ZiOCY936ZGAz6xYOZw4PIaMGXGoRhQzgtb0oEYSIvmYMWwe/cXA?=
 =?us-ascii?Q?R0TqSt37nV/KpHWV4gGc4yC4feWfvBU58MUV6Q7Sy5aG23MJIAYAaJqF9cHv?=
 =?us-ascii?Q?ZtaBa1YKr13FFV2gXVLdusVmjF7nWIw1W3npzOHFJv2cDSCR1bjbYXR8Q8RU?=
 =?us-ascii?Q?U6HTZ1SaS63P+ve78jfpXQsnGgWFIzio4SZVi4uqMBWTmz9G2TqA60t8I/4t?=
 =?us-ascii?Q?n92il2v1XS+KctCR2Yew+BBTPfYSmC7MFBSqZa+WC2qqOxhaM9Wb5uafqAPF?=
 =?us-ascii?Q?4FCFnB7mdTe4T9d5e6PxU9ZaUVX9+GnGRb0WigJ8nSCu19zsyOOympzDn8hg?=
 =?us-ascii?Q?5JE8+5U8IaFDqFGO9Vs8Ie/YlK8ex+xWwXZbceKAoJ6mz2EE/N7PGEC0QQEw?=
 =?us-ascii?Q?sIzQruT0Oi17yTZrTUTm0qT7WXo67nRWn1A/G9v9ZlyBVs6eYb7ZxFBIE6CU?=
 =?us-ascii?Q?ytNuNPjuubbnVXME3qKxPJ3SFecQXxzfJMUq09AhXWkCYk93t9qiorABUnEp?=
 =?us-ascii?Q?XWN1a8YnV6DyXU2Fq+gU6ZAdpS+Yh0CY/+DKfYpk3oa6g03C0Q538dzTWJ82?=
 =?us-ascii?Q?3XiFdFGjB0ew6chCba6vbfpQ/RSulltFldHfk3YB1FiG1Guu3Zrgg9+KV4Mc?=
 =?us-ascii?Q?U+bt/SF8WlceIdh0sYJplL9eLVwzyvy+x4IGe+41u9PVK4S7RX8SXt/uTz+7?=
 =?us-ascii?Q?iSj+u7poKyleos+9OmvFjpV0f5/WN2DyBzC5s1Buo9lYg/4Da+tz1UZPt0z6?=
 =?us-ascii?Q?ENrtAjb5gfljxbNO88K3wY2tx2fG39qibkYlWQ1P5tdMGIti2wl7IItsNNvZ?=
 =?us-ascii?Q?SpkNunDp25VN6/6K8mqRWk97S+MW0a01Ehm4Xt5z0F0dofz0hG3mnuroe6sk?=
 =?us-ascii?Q?ypIvg91hSYcEcokrOu8NIZnVVkaKcxKoySgb3C4X?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36afaa37-201f-4c8b-1a95-08dc863de39e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 15:32:35.1229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KM/ReD5KRylYmJEBzzr7CFodRUDJQ5zEfSVX7RGLuBbiS9xPlui7i1K9AmxN4mvqJ/9+OQ49e2bv32RWzD7SnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8523

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

Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 drivers/md/md-bitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0a2d37eb38ef..3cc2d0ad6f00 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -227,6 +227,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
+	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) << PAGE_SHIFT;
 	loff_t sboff, offset = mddev->bitmap_info.offset;
 	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
 	unsigned int size = PAGE_SIZE;
@@ -273,7 +274,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 		/* DATA METADATA BITMAP - no problems */
 	}
 
-	md_super_write(mddev, rdev, sboff + ps, (int) size, page);
+	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit), page);
 	return 0;
 }
 
-- 
2.45.1


Reproduce script:
 reproduce.sh | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100755 reproduce.sh

diff --git a/reproduce.sh b/reproduce.sh
new file mode 100755
index 000000000..8ae226b18
--- /dev/null
+++ b/reproduce.sh
@@ -0,0 +1,114 @@
+#!/usr/bin/env sh
+# SPDX-License-Identifier: MIT
+
+set -e
+
+load_modules() {
+    modprobe nvme
+    modprobe nvme-tcp
+    modprobe nvmet
+    modprobe nvmet-tcp
+}
+
+setup_ns() {
+    local dev=$1
+    local num=$2
+    local port=$3
+    ls $dev > /dev/null
+
+    mkdir -p /sys/kernel/config/nvmet/subsystems/$num
+    cd /sys/kernel/config/nvmet/subsystems/$num
+    echo 1 > attr_allow_any_host
+
+    mkdir -p namespaces/$num
+    cd namespaces/$num/
+    echo $dev > device_path
+    echo 1 > enable
+
+    ln -s /sys/kernel/config/nvmet/subsystems/$num \
+        /sys/kernel/config/nvmet/ports/$port/subsystems/
+}
+
+setup_port() {
+    local num=$1
+
+    mkdir -p /sys/kernel/config/nvmet/ports/$num
+    cd /sys/kernel/config/nvmet/ports/$num
+    echo "127.0.0.1" > addr_traddr
+    echo tcp > addr_trtype
+    echo 8009 > addr_trsvcid
+    echo ipv4 > addr_adrfam
+}
+
+setup_big_opt_io() {
+    local dev=$1
+    local name=$2
+
+    # Change optimal IO size by creating dm stripe
+    dmsetup create $name --table \
+        "0 `blockdev --getsz $dev` striped 1 512 $dev 0"
+}
+
+setup_targets() {
+    # Setup ram devices instead of using real nvme devices
+    modprobe brd rd_size=1048576 rd_nr=2 # 1GiB
+
+    setup_big_opt_io /dev/ram0 ram0_big_opt_io
+    setup_big_opt_io /dev/ram1 ram1_big_opt_io
+
+    setup_port 1
+    setup_ns /dev/mapper/ram0_big_opt_io 1 1
+    setup_ns /dev/mapper/ram1_big_opt_io 2 1
+}
+
+setup_initiators() {
+    nvme connect -t tcp -n 1 -a 127.0.0.1 -s 8009
+    nvme connect -t tcp -n 2 -a 127.0.0.1 -s 8009
+}
+
+reproduce_warn() {
+    local devs=$@
+
+    # Hangs here
+    mdadm --create /dev/md/test_md --level=1 --bitmap=internal \
+        --bitmap-chunk=1024K --assume-clean --run --raid-devices=2 $devs
+}
+
+echo "###################################
+
+The script creates 2 nvme initiators in order to reproduce the bug.
+The script doesn't know which controllers it created, choose the new nvme
+controllers when asked.
+
+###################################
+
+Press enter to continue.
+"
+
+read tmp
+
+echo "# Creating 2 nvme controllers for the reproduction. current nvme devices:"
+lsblk -s | grep nvme || true
+echo "---------------------------------
+"
+
+load_modules
+setup_targets
+setup_initiators
+
+sleep 0.1 # Wait for the new nvme ctrls to show up
+
+echo "# Created 2 nvme devices. nvme devices list:"
+
+lsblk -s | grep nvme
+echo "---------------------------------
+"
+
+echo "# Insert the new nvme devices as separated lines. both should be with size of 1G"
+read dev1
+read dev2
+
+ls /dev/$dev1 > /dev/null
+ls /dev/$dev2 > /dev/null
+
+reproduce_warn /dev/$dev1 /dev/$dev2
-- 
2.45.1
