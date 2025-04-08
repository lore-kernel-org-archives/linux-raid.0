Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023142.outbound.protection.outlook.com [52.101.72.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E7C1E3DDB
	for <linux-raid@vger.kernel.org>; Tue,  8 Apr 2025 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.142
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744123104; cv=fail; b=ZTA9aVXpu1pFnWVzTfYtoldj2JqipcrUK5swhmVocX5EbhYJ5GjRoHTymz8vp45t6mGYGuqaeNJYBFKw69Chz6gmvulDb1m6gx1escVOUQ11ND1sX+U/Qe1rBv+hnXQXauB3Fxi0apBD7/p0e4sAAJtjy1Lm6xNzG/tmjDivDiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744123104; c=relaxed/simple;
	bh=P3OnTAyvsWSWNGvaBVoYL/Iw2Wo++c5eUAmTZO/L9Ac=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=eUaWUYHinCSvhdx2wNGWn+ZfC/Z1aKdvzUCZvytVOCkxpPYtFwukc7lQOu8VPkfcvXKsTUisOdBOOaKUE6BrW9DM2h/uQIS+IvQTCOdmnDe7KQrs49tchmcuZjURwZx5C0FQV+Cb9uPu7wrbkOmjck4aQ8Kd98a3cvd/zbPepmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=hbCCoRZK; arc=fail smtp.client-ip=52.101.72.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="hbCCoRZK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xA8/y+g2CdTgMKUKRTtOODLVJseFu5stst/HE9H2npLRFRr0xaROIvteVW6HsGR9+qWZM++ZcWf9fk6nkujdNYr2IAe7NwY1i7vD48wdOxdElOzIWty8D9UfFP/YkXtjIJVl8bMohslz2oyfOFmgr4VGC38bf8z6hf9wPm3bO9tg1jc6CIbRJSjrJFK4H0CiiwnpxuwgaXK0ReBAtrtsKKfyAwr7JCZ/JT3fmr5r5orUwNLpQMvrPnpMe3bLOGoDCgooIUXTdtPSl8MsgWxVzm4n+W+Zj8bm5I+mT3p7oS/KcJv56WqRH+rCb0nutgnm1gXsy1M0gjzIhicVbhBdFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PI6ngqbQ3OARGKdRjkDnV+K3ZM1Q2qAdSI/l68GWl4=;
 b=ImWpmP+lVA7Ay/t6gvgebfbPrPeTvQUIbvf4p18EiRVEkU6QZ5Pem/2m8RbuF4gBke8FKk9G63qwW4ePJlbrRRzUu1ng+17B5icP2cndKnutGun9z02Z+szptwZzq3GRoFZseD7ibWk6vw/P9Wj+ENldzhdO819YTOFavvcDEYa6JDsLmCjNyBd1YJ+gtXp1bOPoSnjGIPnt6PNKDwbVRcQO33uqgzQ0J7gumynVjCZ7SYisCLcmGzTXL1vic5o5Jx2P3LMO7j6djrThw5lTpiFImLpdG5JhS9Z4bndKS5SkKX2t1qoYmveKNRLv12O+x893oDFEKz8WQtH3p+IZOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PI6ngqbQ3OARGKdRjkDnV+K3ZM1Q2qAdSI/l68GWl4=;
 b=hbCCoRZKur460hMJ/RLSe5gNotUGHMdZpvluomoAsRaw48qvtexEtmhdtig6bVeCyivFVz8KzOeN76wKASpBgy819MMs+EglmEtoyIB//qaobDcntoeBWjLSBHOZKT//Kliz1SZmZO/SkDMalShUwd8XDMuPWHc00Yvqc9VcCx/n1zIj4YyXriYVtVJzCNi5kJxS9vSQIGWGecIfNKus3NVra53bSHi2vmNBCPoenuGCxM36b338e/NxClPZwLkxcDutjraUxZWRHzuFJBV6+k0yKq8Fetcjk3NQqRiZ9QwNy+1qfymRQvPx6+hi0NXad9QhXVT53383fIYujeFNOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
 by DBBPR04MB7691.eurprd04.prod.outlook.com (2603:10a6:10:201::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Tue, 8 Apr
 2025 14:38:17 +0000
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8]) by GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8%5]) with mapi id 15.20.8606.029; Tue, 8 Apr 2025
 14:38:17 +0000
From: Meir Elisha <meir.elisha@volumez.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	Meir Elisha <meir.elisha@volumez.com>
Subject: [PATCH v2] md/raid1: Add check for missing source disk in process_checks()
Date: Tue,  8 Apr 2025 17:38:08 +0300
Message-Id: <20250408143808.1026534-1-meir.elisha@volumez.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0017.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:3::7)
 To GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR04MB9927:EE_|DBBPR04MB7691:EE_
X-MS-Office365-Filtering-Correlation-Id: 895b4ab7-6ef8-4f14-01b5-08dd76ab0072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?prf2NAp9VOdqrSE91cKCx16W2qGCnY3BsE9LACNosjCeJdBKYFCAkM//kwfa?=
 =?us-ascii?Q?AWWYKt09OVjLRd8wCImOv90JLXVPedVNtd0bGsGrjwKwUC/7oR6Maov+SKGe?=
 =?us-ascii?Q?H6SLgOgem6N1kLmsswdHqNQm7NdCfRF0tviJJbQsgS/U+dVmIbQAmdJJJY6r?=
 =?us-ascii?Q?GJsxcGo+yqmyKmCduLFUIJASs9+0gR+jg78xTzrzCC/L5QZb6hJCPZCi7p1j?=
 =?us-ascii?Q?Obr8AJ4CQqr//X9OitdTHma2WTUhZhHd6z9SjrjpabYRUYQPzB3GNXRrRgpU?=
 =?us-ascii?Q?Owf6+2RgcRBX1vslmk83Kk5jcykyPAuVsKagQjieOp7mCxu/B+C1sQBuxbl4?=
 =?us-ascii?Q?u97pqAKfUyviRskeEEiH2UQAofCmARKKOZhskfIoRKp11zWgaB8jeIA+Di0e?=
 =?us-ascii?Q?ht93tj9b+DUMlE19/UcW4EnqjSpGQFEfMe9IPgGI8YeVXTU2YqHsnpXGMB8b?=
 =?us-ascii?Q?Z5h1+3KWFSYhk1FeZ0u7gEo/cRWLnLbDXbixuxVnHxAL/OzHl8QF/hJO7we9?=
 =?us-ascii?Q?GP4obcEbhSxUJwr8DpCu2sAupLYOJWOKlRGYCJUQT4EfL2eYE1ADCr1T+gXw?=
 =?us-ascii?Q?3LGanTOzHZQtduRgIcAus5k4HqgcovsA9IXxyRqmAKdBRaYK7o4s2VvW5U6w?=
 =?us-ascii?Q?T3aeBXTZk6A0Ns6QIK6jKBwbFYVaRQtgW4sUEfKj7/QTWR6OeLVcTqagifdE?=
 =?us-ascii?Q?G7TQLRhAUqHAyrmLIl/xKbwLekjZmFSehqLinkPeUUAag70R+hyp6Ti4Iw73?=
 =?us-ascii?Q?COW0ki/7azBDqMkNZMVD3dbjh3JJAgECVo96l0e/Pm4++lqy2X7XTevw4vKN?=
 =?us-ascii?Q?txZX5oanBQt7MbdcWOOIYj+lo/cZcGhSIPfVGqvFd8evKy09LRYV8s+iOm1e?=
 =?us-ascii?Q?hJoCv4/kGU1XH4yl4OCtxcdfgMZo37dOQbjcbpYyxB+mh4CPa4NtMvX9s+A1?=
 =?us-ascii?Q?c+I0FUvThqfJ8140S6RlAAWdCVcR3TH2N0Zi++vYfND8SAk1cs11VbVWF62n?=
 =?us-ascii?Q?3GXDrIhUGPZKZTF2qYQ98g/WHbFFQRcopdEYXJ1IHLyVcDjHkfMDEKiq89n9?=
 =?us-ascii?Q?5T5DUUkgVbG7VmYEqKQBEk/JzNNjeqYH3h55AbdsS9BTWVzv54OMsq53gTLc?=
 =?us-ascii?Q?hl1m+uquJY4mKctchcxzKHl5auWLcQCKDx98w2MULz5u/CRCP9q0Jhet88J2?=
 =?us-ascii?Q?BAWi6MNsIpr5NTaEtLPcgyZ0g7Ex6fU6Rflbhwn1lnOP+8Hik31JjNtPzUnQ?=
 =?us-ascii?Q?jhchAQp2nPyFva/K/YdJSe0YRbLs3FxatNftg234KcSAI0nt92a/ZpQrPRkf?=
 =?us-ascii?Q?LisRJsbDtFIbhjwFbWF0k87zZbpNbwr/2vs3m7fLIJL3zzPQLFScQkBK0ijY?=
 =?us-ascii?Q?6OQRPAirJyxb7jniLwi9mQH65D43eMF+SCVGq+URdOOSWxIwx3e69vpXqMMT?=
 =?us-ascii?Q?YV+b4tb6lnfgPJ45ymAYLeIuFggcF5u+kqjqOUpnhJiHfK841J9jug=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB9927.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nYWv1JgfBsoTpVvkNTpksX5IV9ftZ0AFJm4UdessixaFmvvQaw4G7YCM8wbM?=
 =?us-ascii?Q?/RHRLcLFC7fVhyFCYwALgmazrrGpgvGK5qc1i87nNEmGM2QvW6DXxSWDmyBy?=
 =?us-ascii?Q?EkcsC+Pkj+RLTasL9eYczVN2ppblIbho0bbnHelkAaY3nqqyvqGzRdz2+h8K?=
 =?us-ascii?Q?ZV9GD/ZiEZDgw6aOjYtSQU1pSkxE+P5tfARHD3jD1I0EYpmlkNy059RtKpje?=
 =?us-ascii?Q?TIjsBCtp4rCPAFlb2uOgUCVwJNR5Nlyo8bij6BqWSpGoQDW07eoPUOvMMp99?=
 =?us-ascii?Q?eQ0ZK05b3yJBl++3cA2ZT9h8flsmNRrrJWVCm6w1fQMbHSqctkupy17qSBqf?=
 =?us-ascii?Q?RgxAnzvqmUgvZ4eR2g/O3rJ1Phy9rF2r+Rt5c+9JY4ONeUN8eon3HYWy6Rt8?=
 =?us-ascii?Q?uifEYbAFM2jr3QrAzfDzmeHweNQRtyv6tfee5BTnEIBHPAtXe1JrgzS8aCxr?=
 =?us-ascii?Q?iDNYEGJO4o3EDyS7wnPhAnBqybmOZT1ALfCQ60+dMWp0YMuJMot2ybl4VXgj?=
 =?us-ascii?Q?B0qJkpWK8f21EyZAP7qx0/egw/37rE8A76ZKxa7o8KHSQFRPQCrd1GogsPfs?=
 =?us-ascii?Q?fWE9bbOy3PlYYIy/QDQbK3aNkm5fmh0niRtvl4H1ySyqkcBetLJ7WqrB0mUe?=
 =?us-ascii?Q?sojRiRxd9Of4iMwHflAXUyFjy8Z19D/uazSMqZysObxysPGKLRPmqgHRkIdK?=
 =?us-ascii?Q?e6kBMVnwynPjE/vrR1Zw5mWEqVXg+qZlZh95Z90GJOodFRNWv3ceaJppyyWi?=
 =?us-ascii?Q?QnR0pdQt7qEUkXAFNGZgCpm6cOZ1AvvkoChF+A5g7hEgoq1a985po5VsS4ch?=
 =?us-ascii?Q?jDkIuviDfAhRGiPeLtYxLlWEzqM9wN0VgeWrovTrlwnVhYHuHGYk3kw7kWQR?=
 =?us-ascii?Q?EEVhUX3Z8TPIpEn4osbBYqBDpfTfLZwWpugbh9zU7i23WmMjPGQUcBJN9Onf?=
 =?us-ascii?Q?KDRpuo5rpX3pzPcGYmA8sz+Xzq1f+6dqPoWTEOW6Z+fz2Iv1HSmoIPUmYLv9?=
 =?us-ascii?Q?ZlESSe570dx/Bh/zn9dT/RDYC3NbbhNKggYyLvQw4oKotGzb7CKFGU1p+52T?=
 =?us-ascii?Q?8W49ZLvSghnCW69ooeS7IvawngzunFVseXOHR423rS0n9JglK/T+NY1ozGxH?=
 =?us-ascii?Q?GC9CSpjskm1GpWNEzIzsdkf8ON0YnE5DO/r378llcglVZaTq6p8RNwe9YXR1?=
 =?us-ascii?Q?wBZ9EVO2lLI6JdHl1DfedvCxaA+KwoSbpXXtKxOxwO0bnOxD54p6h0Cd6niZ?=
 =?us-ascii?Q?XseEbG3QTWWwPDxd0BOIRBfwfg6n1BW+dh/EazCZ3JhyXHtCAb1hmzW8H2uf?=
 =?us-ascii?Q?SChUQQhERv4zTkmbb8CUwRtMeXSuAagUAp7YnXN1/T7otEett5QmRSyF6afv?=
 =?us-ascii?Q?kpcaXGD2/WRAtWJ1TlzeiKESIpiId6H6l9Dol+kDAkmKgaZxqpGwhzjr6Dzn?=
 =?us-ascii?Q?d4csHusDBATQDRntFlPjRwOPPan+svQtj3CdjU+BFm2oTDQC424V6q+FbZPO?=
 =?us-ascii?Q?puRM5Fz0pqXNqLzhTXv2LM8OrFHekQAeoSCpB+fFRmRUMgBajp2PNwCSlRWo?=
 =?us-ascii?Q?SWsc3dILXb//X5V1INjbp6fGDdNtzF9i8Dcm9sLu8sW5Ggy6PC0C+0dl6h4y?=
 =?us-ascii?Q?DA=3D=3D?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895b4ab7-6ef8-4f14-01b5-08dd76ab0072
X-MS-Exchange-CrossTenant-AuthSource: GVXPR04MB9927.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 14:38:17.6763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFRv2wYhFuV6k25K2K1zCpjty9h1vCpYu24KuFwAtsGQDfQKyadCROnqS4PTlAPBOJbS9LxybzVS+CTS++amIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7691

During recovery/check operations, the process_checks function loops
through available disks to find a 'primary' source with successfully
read data.

If no suitable source disk is found after checking all possibilities,
the 'primary' index will reach conf->raid_disks * 2. Add an explicit
check for this condition after the loop. If no source disk was found,
print an error message and return early to prevent further processing
without a valid primary source.

Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
---
Changes from v1:
	- Don't fix read errors on recovery/check

This was observed when forcefully disconnecting all iSCSI devices backing
a RAID1 array(using --failfast flag) during a check operation, causing
all reads within process_checks to fail. The resulting kernel oops shows:

  BUG: kernel NULL pointer dereference, address: 0000000000000040
  RIP: 0010:process_checks+0x25e/0x5e0 [raid1]
  Code: ... <4c> 8b 53 40 ... // mov r10,[rbx+0x40]
  Call Trace:
   process_checks
   sync_request_write
   raid1d
   md_thread
   kthread
   ret_from_fork

 drivers/md/raid1.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0efc03cea24e..de9bccbe7337 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2200,14 +2200,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				if (!rdev_set_badblocks(rdev, sect, s, 0))
 					abort = 1;
 			}
-			if (abort) {
-				conf->recovery_disabled =
-					mddev->recovery_disabled;
-				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_done_sync(mddev, r1_bio->sectors, 0);
-				put_buf(r1_bio);
+			if (abort)
 				return 0;
-			}
+
 			/* Try next page */
 			sectors -= s;
 			sect += s;
@@ -2346,10 +2341,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 	int disks = conf->raid_disks * 2;
 	struct bio *wbio;
 
-	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
-		/* ouch - failed to read all of that. */
-		if (!fix_sync_read_error(r1_bio))
+	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+		/*
+		 * ouch - failed to read all of that.
+		 * No need to fix read error for check/repair
+		 * because all member disks are read.
+		 */
+		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
+		    !fix_sync_read_error(r1_bio)) {
+			conf->recovery_disabled = mddev->recovery_disabled;
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			md_done_sync(mddev, r1_bio->sectors, 0);
+			put_buf(r1_bio);
 			return;
+		}
+	}
 
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 		process_checks(r1_bio);
-- 
2.34.1

