Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12olkn2109.outbound.protection.outlook.com [40.92.23.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538A1159906;
	Tue,  2 Apr 2024 17:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.23.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712077584; cv=fail; b=WR//oYMVKPbXk183/oEOSnCVR+aRqfvRpzwk4hZ8MOlPI+JoQKYUoz3AmfLXtMpQ0APuZM13XtQa+PISdl51W5NE/dvSp66PpSKitKwc1eJBgNU14W/pjUJNeaVKefRO6O8pI2+cTBO992JXiXeHhJ6wS59ytagMHqLFECcYrjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712077584; c=relaxed/simple;
	bh=iLL4S4Aw6u2iP30Ybyyae8/pSy+bvD+gh4jAt7a+nxg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YjTPMsF/raJbn7Op1vDw/OrwbuI1Z5OXsaZjw8YLCU8z8hZWzQdXVh8+VSHuY0EotT2s2KGOwnpIe3o2qPnEWoWsvf3JGFYfGD7jJA7UR9O7wIS2Lu3q4wxtC0xpg7KEcgCZb832piulQxmCc2C3D3XEf47bLHCwpA35/dFFJhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=FZOmkQ9x; arc=fail smtp.client-ip=40.92.23.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="FZOmkQ9x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7GfQcIRIWwAA1rjHkX0enKrAUgeS0be2y7EmClthi+LZIM6S/2ip4ycfn1xVOKcmd8X0otBOBna+7kNF9XSafmbZ7oV65WfdlZRUoTefZONKBbzNMXpmOYbfzlWhaalxMp49VXZVoIKxJyf6HVguZtSePlOZt8syNt5WSrJWJ2fB0uquvEwjN6Ro+5DOU0AZ+iG0/+ugOc6LEucSQk9+PAmSMpZMkI9wRtVKTLkJsE0SlCcP5oMP+kCGzrZ9H7LRCM6wdv0uUxXuV+4sPDEJCGT87K0rZhXF2YdSiaFmbwKhDDDpdQJHGmXxowpEuqfD0cKTpXLxHdP9C6FaBxsmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O61oSXxGtirU0GxkLCtOxwb8UD95u3Oi4c0o+k+PGVo=;
 b=l4amnLD05041PO+iGsyynoa3k2Qc37qHShGWRpYy9xq2YVxXJNv9FfGIoUzLqDGGdIoimwEl9t72JoAnWT7zO7I3LJExU3psfSywCS1ZnqPTFD6n/iXqEKhTq6KxRkpOEl0nAKFLjX5s/J7w1Y/yKqrpTcBDfIfTfjT1yhx9uw7RaQk84AHcc5QQLqqQRwBHOu4BMXR3+IxZUtnCHygwdBgkb6eR5ohQhkygYA1vuzhQHGMOdo1jHfMZNl8OXH427W+bUIasPz1fqPFDan6Fg4Hi+7VWb2kfkYIC0bIp7FNA7CVr1XnE32Np9/5B0db/BU0SipuWFNSU5CauXeScZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O61oSXxGtirU0GxkLCtOxwb8UD95u3Oi4c0o+k+PGVo=;
 b=FZOmkQ9xC68SMKX8UBNj75mZTPqa6GwszT7DEE6TXccMMsgh6LIIGZPzrt90JF8SescYL4yykJe72sifT+OdWMjiBNOQckYwTglmiK9hIZfeMfZ3GJLBNx4aChBWsc1NbpPWk9G8q1OWPPH/hDVDnmIimJIWKC7nQBWqOxnq+92CRySIab2Qru9nPLh+6QIBZ9NhJXdro0yR/B3DZ3nO8nkK/f3mXlbvXUV92TVLRx4Y7COo8ed2ERkxdo6CuhkwFAWgTo30z4uT6+okR+l1f7GdQhb4BOMihIl2FL4IpyxmTT/Yn41yJ9nfsqCDjAGKMC1lkuELZ2BPfOP9slMgWA==
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com (2603:10b6:a03:3ec::20)
 by CH2PR10MB4149.namprd10.prod.outlook.com (2603:10b6:610:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.42; Tue, 2 Apr
 2024 17:06:20 +0000
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::7ed7:f9b8:da04:31e8]) by SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::7ed7:f9b8:da04:31e8%4]) with mapi id 15.20.7409.042; Tue, 2 Apr 2024
 17:06:20 +0000
From: Yiming Xu <teddyxym@outlook.com>
To: majordomo@vger.kernel.org
Cc: linux-raid@vger.kernel.org,
	paul.e.luse@intel.com,
	firnyee@gmail.com,
	song@kernel.org,
	hch@infradead.org,
	Yiming Xu <teddyxym@outlook.com>
Subject: [RFC V2 1/2] md/raid5: optimize RAID5 performance.
Date: Wed,  3 Apr 2024 01:05:46 +0800
Message-ID:
 <SJ0PR10MB574146BF65CC516F253B2DADD83E2@SJ0PR10MB5741.namprd10.prod.outlook.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [rvSWTiXD10l0TVannC/7vnhutn4yJmDw]
X-ClientProxiedBy: KL1PR01CA0069.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::33) To SJ0PR10MB5741.namprd10.prod.outlook.com
 (2603:10b6:a03:3ec::20)
X-Microsoft-Original-Message-ID: <20240402170547.19353-1-teddyxym@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5741:EE_|CH2PR10MB4149:EE_
X-MS-Office365-Filtering-Correlation-Id: f1633a8f-5298-4b3a-167b-08dc53373784
X-MS-Exchange-SLBlob-MailProps:
	YfhX3sd/0TW9EKWS3Xv9+1S4G32O+CBYR53LL9klDVXzDLGmnRiri49gyxo1+BY+hAshEOkdqlRdFlMi7jy7655L9UPz87WpcKhOyzbQZ3y9BQpu5raglQT0rFDznkTjMjvRUqTi7Vmtu73YaYz7C7BHkRvLVCOk7BXSphn/cOE0XTLbaOP8FKdUuuYY/fd6x4pxs8hzcBsWPGV1C8dTkYClRQNAfzsukjCKPR8bVJkFRZzchPaloJPbzj/pnNy9gU6R6SmbYFfgP+vM1eJQimiOnvW9PSOvffCGzBpyVtkHsWwg8CPUjquvw8rV6KEdxX8D4eIzAteJeP7EmhsD7WvM8IEIVBYFQ7z1if382kCtsbwtEevsp64GXmyGGjui9XLR0kBwmNZ/ih5n6ElTEQB8nYGYn+QRSWcZXRxfVw5k6/uWLbzcKLuO6PQ1W73vWlbPa40HzwzSpqFq2GKUqO3+1ck136lgOjP3bwi359YO2YIjFbs2jt3r63DHs+xH9bVZYOj1d8p0xNTpQxVzbTOoCuK62MV8JV0TA8EXb+FCLWkyZE5UxPdgft1ThoS54j3eVVNP8MjW1jsClJVmSj4RK3ZfwTZ0mTqz7aP9TyTFnAib8Uc0agwPs53GAB6DM8G55USdUJYbr3Aa1bhOpxsq3Uwqz3qq4v5IsxROjSDXKPe9qFFDIVajVN5Uv6mZ5CLzDByWDFNaP2RY+4NRhkTUMXV0PDBwo1forifCkLPXtecW+QCGa12ay3Brb5M+WKvfNj72uHxrW6WD+KG6WWAAVhQtN764/LLDV4FRaMw=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3BddAyD6JZ0dxOH4l9om90CaBs8IpSX/1oD8Eq0L8xM6SEVMvzc1Vn+sjoIgcinHpCYSi/xyOvt5JF1Qi+Gu+C5bsBMSASBsosUZSoZ4eQU0sxTbiUuYZ4AN79+SH/lrr9TsP4bxBeReVgyu/nwluuyW1F+05DtSdlYIcQcFlfeTrlNym4T3V9ZF+hUxQp5KoHC1jNg4BsLbXJtkPqlPaoPAeVwQIisFCOx/XrUxSiLBEc4lw8ktI+4wllWHvPRRkFeOry8vVthiGoYPrIR1BKlr5QsKu5Jv0EvLZPb15XWw+6PCKuoj3HpT9kclEngPpak2zsy9gnm+vYO84De7MDzEKFiRh4QtSFE+ocD4SjVqUcFJL3Nue3KTQJ6W9MTeK3jaDhNlayH90jwel3TP8e1VcX6j3txJ2UmFuUwORHW4mA1qSUCmefJmBqB31y1UezussccPNCWVzIjXYMQIr8AGTCg7/FP3pgJ5arTnFe1uxHpcOUePJxS8wA46n0hpnRhoXXpUmk8R+5oHNOvk2drb+QRZsbTdFCSH49b/7EGCRjdzczeuHdZ+QxL5JOnrcGEbtEyyBU+dnHzARypWmgYiXbjmuPAygNLpt76yqqxoh3IhEANQTA1mjgtLj2jreC4I3jkAoNalyBQmjCc1cValPdN9v1G1Y2IeHB+QP1c=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rZ3bPiJ4oCYVW7WR8Fao5QPZUp08SKeMK6TjEPT2bAt86ZyQdZn/uB79v2i1?=
 =?us-ascii?Q?a+R5619g7FYkXONn9WRt45rQuUnhRlNgCAYjx1JeIzJmnu102/KrvG4Mt6Bz?=
 =?us-ascii?Q?fE7kOCw5XOYolYhkRR3+5fyRGGfK/gU8nBq9HW5JFpMvw70nDFaWs0WPYSR2?=
 =?us-ascii?Q?mDQLHa6ltB8uroVadRaLDF39t2AUueLHNeMhsrYyMrrt7u5VCPA13VjZEaBk?=
 =?us-ascii?Q?rkMAggT7Ywf3xD0FJdkea0im9RFOPSu5FWpFk95M+uXuAjyOZ5boOYvFeSab?=
 =?us-ascii?Q?1ibRvQGiDscAWaVSQ98lgsRY/8x2+M+a8Qb7if7GKVgSg09YygQyx1z/TECh?=
 =?us-ascii?Q?SFXhdAt51q61KmjKDJ4VVg0E1TQsMqMJQn0hyYD949bd1xJKGqsrQ6KVeOVE?=
 =?us-ascii?Q?eRV7G7OlLV1Tm+Sw9m67y28FpfJY9S+OGCswSMzifTDIdoMLuAFq1r5CLQOi?=
 =?us-ascii?Q?eIjzbsRElW+zLyPMtVCv2JhRfoxfq/XUVwCK+F/6e5DsrW/v2DGqAyQ3TRuA?=
 =?us-ascii?Q?xp5/ZkVhZ9n+JhibnYnhcq4NySZqIVeg0Lon+WNWD8HO5DaobMBc7+NP5i9X?=
 =?us-ascii?Q?X+hc0y86qvG1ntAX7ejw70ufk4OFnKKbNR1YpO2l+/4fPJJvtWCTVF+yTGKZ?=
 =?us-ascii?Q?Yey8aGgoZNRdKDegnuYFuoa9JPKHHE0Fj73EytP5J99unsDmPV0P5FjF/4/K?=
 =?us-ascii?Q?Qdi4fj+JOOBez+zCPwooi7jvkxH/Je1zcLs+5M4taAtwdpsICR36cCIm8aOF?=
 =?us-ascii?Q?74VS5giRTVU8TyMkNFnVThW1fhH4MmG4Q7L2bXiZL99nFuJClx5plUKLKn6B?=
 =?us-ascii?Q?Eblh5P8TCKmu5ak5DFH3s/2tmqRAqMK+c4LZhQluax/5i/bTmYaYuvu1y000?=
 =?us-ascii?Q?+1BhgUz9YHi4YG1K3jy1pDe/8XnOvRzBORX6yVXcqD5SzkG9s0y4x1XKIHWw?=
 =?us-ascii?Q?AqX93XaErd5JsklCxC8A+a+TahGazaeDPo3hamx6QuRt56oc5sWN5RdC6qVO?=
 =?us-ascii?Q?fndhgdQq5d8ZcwlXZYyFVsd+/I/YCSvn9DgH7YJ+DmFaJgmHbZGi6XbpaTb5?=
 =?us-ascii?Q?6B/PGNbN66wg/qldySWK1x8j28sbo1KT0ZBQANYDMVv7NcGHVOHLXBXV5/nE?=
 =?us-ascii?Q?wSy5J/9FxnRajTndGB8A5rkswKo4TH+e2vCfRs+uTbuSTjY2Fhz2XxZRK8fm?=
 =?us-ascii?Q?Y4BUBmxabtHCtBE2bfxr4hioSKJClDnIjgOyxJmv1D1/ndWkx/oGzxVBNkA?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1633a8f-5298-4b3a-167b-08dc53373784
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5741.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 17:06:20.3486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4149

From: Shushu Yi <firnyee@gmail.com>

<changelog>

Optimized by using fine-grained locks, customized data structures, and
scattered address space. Achieves significant improvements in both
throughput and latency.

This patch attempts to maximize thread-level parallelism and reduce
CPU suspension time caused by lock contention. On a system with four
PCIe 4.0 SSDs, we achieved increased overall storage throughput by
89.4% and decreases the 99.99th percentile I/O latency by 85.4%.

Seeking feedback on the approach and any addition information regarding
Required performance testing before submitting a formal patch.

Note: this work has been published as a paper, and the URL is
(https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/
hotstorage22-5.pdf)

Co-developed-by: Yiming Xu <teddyxym@outlook.com>
Signed-off-by: Yiming Xu <teddyxym@outlook.com>
Signed-off-by: Shushu Yi <firnyee@gmail.com>
Tested-by: Paul Luse <paul.e.luse@intel.com>
---
V1 -> V2: Cleaned up coding style and divided into 2 patches (HemiRAID
and ScalaRAID corresponding to the paper mentioned above). This part is
HemiRAID, which increased the number of stripe locks to 128.

 drivers/md/raid5.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 9b5a7dc3f2a0..d26da031d203 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -501,7 +501,7 @@ struct disk_info {
  * and creating that much locking depth can cause
  * problems.
  */
-#define NR_STRIPE_HASH_LOCKS 8
+#define NR_STRIPE_HASH_LOCKS 128
 #define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
 
 struct r5worker {
-- 
2.34.1

