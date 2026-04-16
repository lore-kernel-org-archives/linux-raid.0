Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazolkn19012011.outbound.protection.outlook.com [52.103.72.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CACC2D5923;
	Thu, 16 Apr 2026 03:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776310851; cv=fail; b=RXplGWXWYYzCBLO0Hv1WEXTLIp/mvry6at+EO5RZ9tUhBrKyTvHmf2qMFjGvyt3MNxSRdnG4ztAhU6N8NeAcU0BPRsN6+s9dy0OZnkvn3JdhG0dSuVrSFytoj06WmwIGLTRW6rUvNjrdZ+utOroGHgjG9+wKepoOTvVUS6bowlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776310851; c=relaxed/simple;
	bh=ZDmBpHFupOh8KP26eP4pun6aSOFIL4jaaz8ZXswAtR8=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=c/C7wfDpM8L//xNQxp8WR2jV83v/nqkk7qkTkY3ZmL21pv7N7qX4LslV4GjR8uowoUHvlKI8/QA/KrQe5aO2UgQsylg2nzdCy9avSjitWEdNFhUZosHrejGPT1L6B4KRznJ2jr789v2aCwFFypxzNoyWCcGqhmG7LJFUTdGT0+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=f6gkiWSd; arc=fail smtp.client-ip=52.103.72.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="f6gkiWSd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P/x6r3lmqwcBO0mzhxTzkxwknPOtr/d1a3GbZIEykoetNflY2YLDnSItUeiaF3AXAJfpVO7TQpv8tcy/zreTlrYCiuZWR3Lb+io7EJpbhyvtVxUDbA2A+xLwwFdspC/hSPEFLW0s5uWtk98pJKI2XwK+ODgPW8wEIL+nqjoqlEgy51Y7bvHWLVUTE+zFZMHCJJjRbnLbhwIp75NgNQR+RHoe4bCN2tQU+smcM72OK8L0hKm4Jy4qQeOG8/rJs2gpsmQHj0fPVtL2/ugB3nB3d2XXooXPc4iScSWoCn/td4k4gPDucAJEqkGeRaf06z3CSP3to5uDxhiHH63cvPQARQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIdomZWxCa2uhgG0LHPAZwZJt+f202uZbQqmT9tyaZU=;
 b=mqkxYFkharjW06lg1QKUCFWI5SOg8jQFnDPWfU14qSaN/tae101DjSA49nuHS2HD7E6QYpVRp3ZY3pK02/55Z6j2Qjpn4cijtZM6wrPltRRtFzGi+iDF4VmR4bMesI/S+TLMZgxlgwPuoLs9J1Se0NMMRnMRYOVQ708rDQnxwirq9kmtruFWnsEFJzTCvwLQjc9ROSea8nIEQdqggJg0E3SWudDPsBOmD7rBrKY+gvheaFWNQpBLoXd4GlGDRk18/OcvJfKtRM3VMDcH88fGlSz7GvRnshkoPXtiXz/M+Bk6kGWexZCmp3cKfxVffFbjFlV5keIFR1e40p+kH0gbCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIdomZWxCa2uhgG0LHPAZwZJt+f202uZbQqmT9tyaZU=;
 b=f6gkiWSd+nBXQn8oKD0IUmj8YCTdzzqeyjJ1EesWHVwptJ0TSujzgTIflB0e3JV08E3hh9fGBHfHroXOclLWyCIs833MPcFX4mVgYFAh3JrD5cyN02MzT03ewvu1/DCH7IvQqdaAJP2ZChJlQLyLccqIzH7oz6jrTY7S4ZiRUfTzFOm/kAMARhRO8RrtgItPae9O2jn/y4kHQH7XxjvcbCqHJN2X/cf6fMMd72O0rkms1D2OsbfUEXxOZ0zj0unfIIsnaUz4diZNSdgPcdP6wPjib1hgzXdmByeNRBpZP5+75OnsEMwaiUtHw4mmGhSJaPUXIt4RUl51gs98DFZ3aQ==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SY4PR01MB5866.ausprd01.prod.outlook.com (2603:10c6:10:f9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Thu, 16 Apr
 2026 03:40:46 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 03:40:46 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Thu, 16 Apr 2026 11:39:56 +0800
Subject: [PATCH] md/raid10: fix divide-by-zero in setup_geo() with zero
 far_copies
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAAta4GkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDE0Mz3bTMitRiXbOkREtzC3ND48QkYyWg2oKiVLAEUGl0bG0tAA9043Z
 XAAAA
X-Change-ID: 20260416-fixes-6ba978713ab3
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 Li Nan <linan122@huawei.com>, NeilBrown <neil@brown.name>, 
 Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yuhao Jiang <danisjiang@gmail.com>, stable@vger.kernel.org, 
 Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1238;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=ZDmBpHFupOh8KP26eP4pun6aSOFIL4jaaz8ZXswAtR8=;
 b=owJ4nJvAy8zAJVb4wiKgu++DA+NptSSGzAdR3KeYGQ4F7mn9Usn2Y/H2W3kJ82+f/RKT2vLH6
 MLfMBbJTyc7SlkYxLgYZMUUWY4XXPpm4btFd4vPlmSYOaxMIEMYuDgFYCKr7Bj+KbSuzN0z581L
 ySeKe6WYztdwazzeFPxoAdeKUydWWU076czwV/ZOS3zRonnvK4T2lRX1h0TfvxO1uFyoZ3GTjNL
 UTamrmQAqyE8t
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TYCP286CA0279.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c9::6) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260416-fixes-v1-1-e6a854a5c048@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|SY4PR01MB5866:EE_
X-MS-Office365-Filtering-Correlation-Id: 550fab81-8842-409f-183a-08de9b69f13f
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24121999003|22091999003|23021999003|15080799012|51005399006|19110799012|41001999006|8060799015|6090799003|5062599005|5072599009|461199028|440099028|3412199025|40105399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eElhYUFrcEhkSmtPSGMrREVRd1JSS2VQZ2tQNUdWQ2IrcGczaWlZUkJsbU9j?=
 =?utf-8?B?V2ZNK05BL1N2dlgzME5xYmc1L1M3aVJUZ2gwZm9HZHFucWM2ckEwdlRXdmEy?=
 =?utf-8?B?SXVJVFU5TGdKL3FRMFlqZ3NnYzkzMXgwMWFvVGdPa25QNDNVa254aDJhdEFr?=
 =?utf-8?B?c3dIY3B4NTJoVXQzdHd2ZXZaaFdTd0hSMDlyS0o4VmRFajlYTDVMbDlJR3Bh?=
 =?utf-8?B?TXZncWo3a2o5YjNxNTFDcnYwemlWTklpM3d5bWFDS0xNV0QrdEJGc25HVUxi?=
 =?utf-8?B?UEhYUFU4WG01SFVSSTBOTjN2QVF3enNheWE5Vkp3QmFJL1NvRnZmSDZRTTE0?=
 =?utf-8?B?UWxNRERTZXVIKzhqbEF1SWkvQVI4bzdzSnA5OHFTdVNWaGZPNHFMZVFNdndt?=
 =?utf-8?B?QzZwc2d5dkYxeTZ5WjRtNVVYTW4zai9DdU5LRFFHSHgyVW5JQ2tFMnlhYnBF?=
 =?utf-8?B?b2luaTBUVzhCSjVLQlo1VFdGdmo1d2tWYWJRS2lhNjJIMVRTbTg3NzdzQW5o?=
 =?utf-8?B?TjRySlVVNWFCSmwwT0VyOGpTSFVSaUhOQ3dWeExMT2pZQTlXTllFMkxIQ0U4?=
 =?utf-8?B?OTI3YW1QRlRXU2d4Y3A5cHRURDc0UFVEdnVLQVFaRnZCOHVBNTNwbEJkbHZi?=
 =?utf-8?B?am1kNU1xZ1ZST2Q3QTh2cm1pMWFrR21TYUpNVjJhTG1pOERyVGpDZ1Y2ZU9B?=
 =?utf-8?B?YzhpYkh0R1VqRXFpcDRwTElWR0VSOTBjR3BSTHcrYmllMTN1ZkNTdGt6Ukda?=
 =?utf-8?B?VWljSnVoYkhCd0pIcFRqbENuL2dOckpJWTU1K2MwNG1IOVlZdUx2bzNZM3JF?=
 =?utf-8?B?MHFPNTZ6ODJZYVIramljamduWG80NXVrREVXd3AyYkN0WTVKZEhOM0RNdzE5?=
 =?utf-8?B?TGd2MnB4UHNncXJTN0lwZzVlS0YxT01wY2RPY21NVERBOFh6WXdiMWRQMnp5?=
 =?utf-8?B?Y2t6NU9zZk9mSHY3M2RHbmt1emRuQm1ITENhdUhZSEYxSCtEZ09lem9DWHF4?=
 =?utf-8?B?Tzk0MFJleUxockJmSHN0WFBqcW9HWHdvN2JPckNOS2l6KzR2R2wyMGhpMUNB?=
 =?utf-8?B?cEZENE5HVzNjNkhpbG4vTnRtYXJRbmhnVmxQQkhPVnRtUHV5K3BobTZYaDZ5?=
 =?utf-8?B?Ymwyakc4RnlMUEdyZ2pRWVc0K3hQaDZ3VXErQ09hdkRTb29qL241MlQzTEEx?=
 =?utf-8?B?V1pVZUdsL1V1bjQzNmRkWmtxZndDWkFzcDE1bzZsUzFrZ2hlTFFlVnJ1RENI?=
 =?utf-8?B?TklZRUJ2VmNrZk5vVEFjZFZHOU1YQmd0QnpkeFF4K0M1NEo3SmIvWjJCRmU0?=
 =?utf-8?B?Y2pFZUF2RFNXVkhDdXNoZDZEMW4rN3JGbGRTMStxSkg5TkRxTXpRODRJNDRx?=
 =?utf-8?B?ck5qMllzSnhVSVhnMEZqRFdocUNkTDV0bG42dkFsZlo0TVNXNWRTWGFiczBQ?=
 =?utf-8?B?L2FJcUFUbEtzbk02elBBQ25OOVFsMCtaZjdiK1JRPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0VIb2haS0RFbEZsV2toZEQwVS9Lci84d1pDOEpiUU9RNlU1d2w1SXJudzFx?=
 =?utf-8?B?MW4xRHZHemxlSU5KZ0FRbTJDSU1nTkxWZUhEcmE1Sjl4ZHZWMEpPVDFJQ0NO?=
 =?utf-8?B?OFQ1SGVPYjdsdFNoaXlTMkFpblBMWmxxbWhXdTdYNit6K1RJK2lTVzVWaHAx?=
 =?utf-8?B?YzVvaEVWQXJlSTJQMXhxUWw2TG9PV3pqMGNpT3JvYlJyK1FxeHY2RUl5dG93?=
 =?utf-8?B?eUFna3lqNkt0M0tYRTc1ZWtmNVBjSCtTOTQ0K1RWWUZpWnAwWDdqc3BJb2RU?=
 =?utf-8?B?SGpBRnRUR3RLRUw0MGEzYmhVdzBkbEZUL3YxV3lyYzltNG5KMFdjV3hSL0N6?=
 =?utf-8?B?UUVma1IyendLQ1lhbUJudDhqNTV5c3BkZU5yMWZMbXgzd2JkdGlPc3JicTdC?=
 =?utf-8?B?STVNK0pqNkpuQ2drVXZ5cVREcFd6V3VKSzdFeHV6bHhxSm9NNDk0cnhGR3JE?=
 =?utf-8?B?eDJScUJJVjlYaVZGV1REaFg2dWMwekRLbkpab3dMTXZHaFArRityc3l2QmNj?=
 =?utf-8?B?OS8rdU44RTkxVlkxV1JheXd1bXFQdUNrcWtRbDh5ZlYyR09vUGkxK3NZMmQ2?=
 =?utf-8?B?SzduaEtCS0szYTBta0lPMFpmODNFdDJjQTU4eG84Z09NMzllYVZ2Z29GZUpi?=
 =?utf-8?B?K050Wm5paXZPZjVzcDl3eDQ4SWJ1Y2VEM0RhQnd2VVVrUGtjTXB3MkFNVytH?=
 =?utf-8?B?S0daUi9zZ1B3T1dpeEQ5cFNSWE5RaVZDN2pKM2Q1M3VGS1dQaHFWMHZqalVE?=
 =?utf-8?B?SlpFMjdQMzJidWZNa3JDbHFZZDNJMjA0aWRETk1JWmE2b0huMEJTZ2F6WE5l?=
 =?utf-8?B?WXdXamdYemM3WEErUG1HUUJQRkFDakdlWlRBMG9ldmdneTl4TjVSK3I1b3ZK?=
 =?utf-8?B?ZmZQcm5qc2JSZFpFMzJqRi8zV0xoUUg3UnhEY3NSOGI3dW1oZjBDd3BaMWp4?=
 =?utf-8?B?SFVzeVlhNEN0amQvU3dOTmlQTjZQWWt6VzFYc1VhWGdObytjM1BnQXp4UkVu?=
 =?utf-8?B?UUJQL2FTb3ZYRis0ckdaSWM4WG9GbXZ6MTR0bVhYTFg0dzE3K3VBRVRkZzhw?=
 =?utf-8?B?NE5tRU85ZzN2OTNDaFAzWmhDWXorb3pEc3FiaUNwbUlsMHNia0U4NHFyQ2R2?=
 =?utf-8?B?eUo1VVhxWnA3TmlpTURCRXoyb2Jxc2lyQ2VrSlRISG5lNjFQQm5aZzFvUEw3?=
 =?utf-8?B?cnNQcm5ENWRqQThyeHV2Uys4ZjZxWDJWUzBMa2YwRldQZDFsaFU1M293Zjl1?=
 =?utf-8?B?bHVaWUR1Y28vYndlczRncXQyejc0L205MnZlVHBVVjd4MWhiczBVb00rYmJX?=
 =?utf-8?B?cFJRZlRteUkyVld6Mm5mRFlJczdyRDhHOXRSeHlYNkpySEk2TWR3OVNNY25D?=
 =?utf-8?B?KzF3djRxN1IwcExyckdFcE1lVzl4WnFMdW1pb2ZXZ2lBSVgyS0xNUCtIcWUv?=
 =?utf-8?B?Ty9JenA4UTNmaVJodEdzb05uZXp1NXdPR2Fxa0FhQWpiSGtDWDdJbHBuSTBB?=
 =?utf-8?B?cEFQcStxRVU1VFZpK3ZrQjM2SzAyaTc1ekF1T0RCTUQwQXRwbkFiaWJ4QlFY?=
 =?utf-8?B?Z2tzK0I5L2RXaHlvZi8vWTF1OG1ydktOQng4QmYvdDFzTnMrc0ZObENGQnBj?=
 =?utf-8?B?K3MxV2ZhZW9YRjIzQkZWMFRxaURIY05mMFNXL0NobzBpUXMzZ0ZYSWl6bW5j?=
 =?utf-8?B?OGUxSFppcDN5N3pMM1IwclRNODNVQW0vSlpjcDJMbTFhSVhTa2ZEWXdRcGNh?=
 =?utf-8?B?SnFVbi8xTDQyM0dGWWdlelVXcS8yODQvZ1lyMEN6TmZ5cUowb0h6Q0o0b0E3?=
 =?utf-8?B?WFl4V05LLytrRTdLL2huWHZwOFdhaTRJdEdhRzFmdithWHZEQnNWd21xaTBy?=
 =?utf-8?B?c2JoQy9GalVEbTdFZUswK3pWbDdpa3hybTBNNjZ2b1BQeHc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550fab81-8842-409f-183a-08de9b69f13f
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 03:40:45.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4PR01MB5866

setup_geo() extracts near_copies (nc) and far_copies (fc) from the
user-provided layout parameter without checking for zero. When fc=0
with the "improved" far set layout selected, 'geo->far_set_size =
disks / fc' triggers a divide-by-zero.

Validate nc and fc immediately after extraction, returning -1 if
either is zero.

Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far' and 'offset' algorithms (part 1)")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0653b5d8545a..811ea3d23b80 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3791,6 +3791,8 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
 	nc = layout & 255;
 	fc = (layout >> 8) & 255;
 	fo = layout & (1<<16);
+	if (!nc || !fc)
+		return -1;
 	geo->raid_disks = disks;
 	geo->near_copies = nc;
 	geo->far_copies = fc;

---
base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
change-id: 20260416-fixes-6ba978713ab3

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

