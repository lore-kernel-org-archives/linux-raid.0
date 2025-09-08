Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021110.outbound.protection.outlook.com [52.101.65.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099A51F9F70
	for <linux-raid@vger.kernel.org>; Mon,  8 Sep 2025 14:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757340505; cv=fail; b=GGA3qhhOSZO0qs125VSHhFekT++HYSw5XVtMH6bssERVXIDRkgov1LiwURNNCFEy3qBmVjH2zHgaEybmumojiz5TgUslrylV+JRefwSGUlmuDgyD2iZNoHRDuMVqK+pq3hYsAQMrJdQmzi/LYVB0e4F7QoXePrUJXvXfLdUAHuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757340505; c=relaxed/simple;
	bh=HuAV5VMTudX9le7iaUbZAK8Sv1hKAekF33RcgILtpP4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=csmmzpufqyobF7QI5FqjBMCLbgx41VtzkSw2L0z2rPEulaOG6Ldb8wo+BHi4p0SOREfJK2XJiLlQX3dmSEBUZKPn3lszlG8iZEkQwMLsoNtT9bdLZ4F0XQdUsP/YsicsZySAL78uP6DZ4d81iExKx0kXL0M0j4D4yvbXI8SAR3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=NPh60C4Q; arc=fail smtp.client-ip=52.101.65.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="NPh60C4Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BdEN7jdgTdDfGX7q7XnJ2WA7EsbcJMrIZCynxW7oMFGuJAjSYRbamrKyWDqLGhaIk2UJeGY7IUXnJ2CIzgDWXXMgP8ENfVelZonxr6PEe7Oh5DcU5+FLpxfh3Lgj74/fq5rn4Ip6OSDfYQqbU6CdWuzZyLFxlTNwHtYLnGbYiYz5cp6hIOw+2Bc/2/fHwlSItJzbQ/5XFh2wnt84rX3dgsm/2E3PthmLaO29TskYu4Iiy3MX9fM/ydf+1lr8PPlHD2ZK18kgacH/XNhNoYP5IfWvHWnrt2aXMp4iylrMTSceUWflS5UtsMcgkjxrxUq8I+QbfXEcqm1tOI34NEbOBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+TNWputmfdLaqYBKPfm5VTaCQF7GN2rqNsA/spDCcw=;
 b=DOzKP+hh9dv4/RoPt4k72FzyhzFnOwt2e4J6Zi7wFgA7HNqSIla3jlVH6eVW95iytb3WqyA8qH+74QUrry58K/Q5WD68BGWwMZGRuyrt8HpLEmZBj9EWqu9yNfuLwOPULwlxZcrzbH7kNc9UTAA8KFr/rv7V1s69LGQI/xqMB2NZZ3FANr7c+hSU5iJjyD/cKsA+2PfwswljCOzrx4zhwUUa/6ckkdISZfpAaFvulA3ntzyW6QbG9gf4FVKyGsWsAqEl/o1298VfdUpVBppID8tkXaTkQ/X84lwfGDngc2wE6ABIPjMqQYc/T03b93RQ8jeujXlM9PMjXAzyDCaPqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+TNWputmfdLaqYBKPfm5VTaCQF7GN2rqNsA/spDCcw=;
 b=NPh60C4QztAutWVAliByAKOjRIt28YEpIZLX4SqYWaLH6U4W8A0uWxXwkW4S1LDXrV3y7oJwFfFFzkwqIB8FX3WqhAk1HtgTvl5IiThzdd2sxa+loLJj2GciBc846cH8nU40K4mfrN914HglDnnKJoBBkwke38YhPEu+phBlAxgeoVFYuZlyWxIrH7keiUIET6u2hr0v9eOIPe3AB3fid5FJrACfaZ1rsAKHFwYhn2cK55pg6p2fcYkZjD4k61gDOmQisUuYacs4ECn7lIaCI41eQpPRzycHDRaa10ZRNEqdLhePlwttUnwqfScuS+tBKRh/kbMWiUS0q21FnONR0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
 by GV1PR04MB10704.eurprd04.prod.outlook.com (2603:10a6:150:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.14; Mon, 8 Sep
 2025 14:08:17 +0000
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8]) by GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8%6]) with mapi id 15.20.9115.010; Mon, 8 Sep 2025
 14:08:16 +0000
From: Meir Elisha <meir.elisha@volumez.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	Meir Elisha <meir.elisha@volumez.com>
Subject: [PATCH] md: Fix recovery hang when sync_action is set to frozen
Date: Mon,  8 Sep 2025 17:08:06 +0300
Message-Id: <20250908140806.153159-1-meir.elisha@volumez.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0024.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:3::8)
 To GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR04MB9927:EE_|GV1PR04MB10704:EE_
X-MS-Office365-Filtering-Correlation-Id: ddc20f75-cdb5-4a03-6bd5-08ddeee12811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PiAJjrApTMlOSD1QJkuzRYWLv0pw0IMLy/C+Zq02KptlD0eE1FPgbtKNTdQg?=
 =?us-ascii?Q?33oSrSQCjzWafU7U76KME0Oh6TOMdHDU5m4kYVx6dZ/k6/A5l6HDYG4/L9zF?=
 =?us-ascii?Q?ejK4WLSl/bgWgns+tFE3jQRcSTDMu+ru73rnKXygrrIAttcbMjI01UYjLatR?=
 =?us-ascii?Q?33i85KsMXXEhi8kBjmVrSYXehZSK0DMnpnyRIYW8ZCRJ3I6hSt8+pelvYtYk?=
 =?us-ascii?Q?SnrNGXd/xgo0Y3JznntLjLvS3BeU+s3Ag+lZZ6bUVb7pBUYhF8Lm/K2TCCgd?=
 =?us-ascii?Q?5mgATrfWjB3XIYM9c4wrClqKPdWjfQ70+gEHHZ6vj5V7y6d+/iUEwtnwtBE3?=
 =?us-ascii?Q?l7Vgk0wDIUwJObCrwU+qFcZGmbxVV1IsjZ4E7Ysv4RERQeSyUnIZ4uPQ16PO?=
 =?us-ascii?Q?kP3I2AAgBtL2QCG3yDqQQF4/9k3Ze9gafsSxNKuD4pLl7+Qq6o4sZwou45IK?=
 =?us-ascii?Q?rf+tPu8s4Nu3Y4QUvFMCDE601ISVAZl/iy8RcOAP0ZYTUA1opttGpQhA5hzV?=
 =?us-ascii?Q?y3eFnrBR0KwlG5joiaTrcIl9TqtcepgUOPXstuHxVWDOwsKmzT6QeSDXj3sa?=
 =?us-ascii?Q?LKQstX3ksXhslhQ6gffvTCn2XpWn+Sn65NL/uYwEZGMcvoemfVRhtGji3BaW?=
 =?us-ascii?Q?6DXqT/lJqRBpUULx2sVTzUSrPiXRU4SBE8paI6Xn/mf9HaCBLdeL5zpoEFkt?=
 =?us-ascii?Q?qxFg3JZpLeIHUhZbqi1zbTTgVZbyM/ohV539JxXC3xVKQvungrTHA2kg3dTj?=
 =?us-ascii?Q?hXmJmk5GQ1+GHzxaZ1vf7elx0waZmn7e8NecOrsALlzVmS2LRABAQlCA1aTm?=
 =?us-ascii?Q?qJuCLny+Cg1I1ZVFXU4Yle5eVws7l60kwwt3n5RCVnnYDqcbY//h0Mb1CwJl?=
 =?us-ascii?Q?vNBLqifbkXIoplPbn3J0rAhoclJmFo4tj0+XQLCAuWMPOqcqgw22+G8SIeED?=
 =?us-ascii?Q?KHRKbG+3Z5yg60//e+MYcbvfSss60nwn6yFUI6Uf43FIJGi0VVVExWqssQz3?=
 =?us-ascii?Q?2c+hKQSrUBpObEdfh7rRvWAYQiRpSx89kxkDFvdS25gRGA3YF3eD1Blp3e54?=
 =?us-ascii?Q?j9rzegDwyVLxxbLuPNqq99L8MsfRh+f3CAX04Ve4jbBbN0Yxfx/ei5xuIStB?=
 =?us-ascii?Q?EXmkTXXnuKkyCkpJB6m7jUcWdCYMPzV8xB+HrXaNB9benRJo3oU3JtfoqEpj?=
 =?us-ascii?Q?5UFESbGY+SclXI/9AEWNbVQq/Cp3vZeYrzuTsjJBBIArIoRtmZKdtmZ3rsEm?=
 =?us-ascii?Q?0e4X3+Uvb0MDOOAVTlAKCa9K+iQw2Wp2XQtNO7N2TLuIz5iYzrhMJX4DSXbR?=
 =?us-ascii?Q?eEP6HPWJw7DiYhjtAe4+9VVxudm6b6GKpQosFS0ma+ZiejBuogdxB5l2hDQR?=
 =?us-ascii?Q?zi5ULFg+GjKw7XZEDSlVRht1zc3obXUv0SZVZqgbMHlrn1xYWJX8JD+GQrkY?=
 =?us-ascii?Q?XNKuFdsv8SdUDkWlU2IgHWbn/XNY9JzzTOnkxQ2TblppvysBhtfhBw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB9927.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T3J8ouiSJvXXYAp2QAIZ5jhCfpxtCozWcYtLaFgsRj2CUL9fef2ybQW7qDIb?=
 =?us-ascii?Q?qWiluHaNp4Aj9pV6q8oZ5b4p1f5MEWQnbXbRkf0kaq3aRPcgrTLArDx6iw20?=
 =?us-ascii?Q?ffkhlM7JHuq3zYknwRFglzh6u4ed/c/un3RUPFAlcq75tg4nRB4obHQsWj3y?=
 =?us-ascii?Q?t+H728tSIYnKDyGIZcijgz9lf9lPgEl1BuoqnReExaHiVlyGSn0JUvLjXt8L?=
 =?us-ascii?Q?DorPD6WKUJmNEd8rU7wf/ikwi7DYDDYYWsJ95oSxZBUZR8GXsrxWjsuNoJLC?=
 =?us-ascii?Q?jOzo26wgkiWixu0FBL29ruYzKm4Pmesn4xvtxeQ2MPLKNGaGOmhWB/h7PaBE?=
 =?us-ascii?Q?ZhS86OzOKa7gu2aEX3AKKD4VfW/ZFtOFLxC106Ph8nP/1RV/TObtNwOW7Ow+?=
 =?us-ascii?Q?UsgbV5GJga/+mMVT3tzNfpCMR7Qi4I6m9WusRztWuNCspJCKO1WlXDm8hCRb?=
 =?us-ascii?Q?3Qq/7Hxv0Hw8ztT2c3sEMQRYFgtLYotiqqBMnxXB+5NFR4Fz77N1YqfXr/I2?=
 =?us-ascii?Q?Dg6z6cc3pxXrouG23ctln1JqIuPBKUd/ylezXd6/FnsELUc7mYGkoyWgo1Ci?=
 =?us-ascii?Q?Ew+LAx9uUeO83jBuImh+GcfRwYMXHt8I+ZyeWmGxNWOBEkFHqA2/4gSqjrhL?=
 =?us-ascii?Q?d9nKlffLClPq8yosBb3BUo/rGfBUwuHgknvq2XIv3Iv8yGN6qzZv3Hmf2EFs?=
 =?us-ascii?Q?htZogQA4B6bC8+vzeNuPbvUgl+emOictLgSwV6JAECSw+9HClxaQLpOxLgWp?=
 =?us-ascii?Q?8ptpFH/eQ7yvXClC5/AlJ6FFcccPNfAePkFVzUvq85+R26iyHogqqNZsY5E/?=
 =?us-ascii?Q?AjSIT+RDrsE0s/398QKpTCjUfawfosYftWfGruG4yR6NqFtD/umIBz+VGU3R?=
 =?us-ascii?Q?EsVbKRIWVY6urXcE3bKckAC2hHJNjqWPEcSvL6NmEtrusOC65INRGdDeKSuf?=
 =?us-ascii?Q?8dZ0SnREryWfnfNC0CmZ1q5U5swfu892KEy2g9J8tzOqwWEBzrhkjafooL2h?=
 =?us-ascii?Q?zpSeN0eBPcTP5oQZ3GlDr+Wn30EYgRwJ/UvhxsK+GajuS5LXL/Q4rmISrjo5?=
 =?us-ascii?Q?aKkYu+PgQnFnJ7vd2UnaVW/J6yO6q+gjrAlLCD8sO0HtMt43LMlQhw99smsz?=
 =?us-ascii?Q?Ah11KjyfJc4RT5mcFeOkT2NN0blFwSleeAXnlTAqfJoffwE+qNds/R4lIsYF?=
 =?us-ascii?Q?emiBS+IqCvvE+qssrv3tfUEtGGdIfXLNrp4Pq4C0oAc52AeB8OoxxUC+8d+d?=
 =?us-ascii?Q?TiZ2egspcthD5g+FZSeQ5CwJqqF9yDhZTdCrXayil+NBgJio0KjoLHwF8jyh?=
 =?us-ascii?Q?ih7n2budFMc9bJaBc4OoTUATMCb3PqIvk3x/JlFMT/nMzbXlQZQ3DYW10rBn?=
 =?us-ascii?Q?u/s11F8CGme1FGjD/DPy4GJdH3b3ibLRKDEDZO2sbr6rrVIDsNV+i0HoU30v?=
 =?us-ascii?Q?147vuY5lE7L3+qqmrqCV1NP1QGNbpia5sEmpzQ3XssIsWxxl+bJBTULRhVRD?=
 =?us-ascii?Q?0zF+vVBsHkFgzPSY3esU8DcMYfpk4aXWqWZ8uxvK34YtLTR4JqI1oiBbF4/y?=
 =?us-ascii?Q?2e/xJ1bllZp/an6XbzOb6LFDDSpAxUlsWzfRIgRDTXVZibntkNJPrpb5fmg4?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddc20f75-cdb5-4a03-6bd5-08ddeee12811
X-MS-Exchange-CrossTenant-AuthSource: GVXPR04MB9927.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 14:08:16.4758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1AYPzY41hjdndqDbyTOwOdtUukcQxlLBIp/55oblxys5Y7S71WSmJbb6hcjYsBhofEs6cFAYDDCGZuJHz9JbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB10704

When a RAID array is recovering and sync_action is set to "frozen",
the recovery process hangs indefinitely. This occurs because
wait_event() calls in md_do_sync() were missing the MD_RECOVERY_INTR
check.

Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
---
 drivers/md/md.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1de550108756..1b14beef87fc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9475,7 +9475,8 @@ void md_do_sync(struct md_thread *thread)
 			    )) {
 			/* time to update curr_resync_completed */
 			wait_event(mddev->recovery_wait,
-				   atomic_read(&mddev->recovery_active) == 0);
+				   atomic_read(&mddev->recovery_active) == 0 ||
+				   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 			mddev->curr_resync_completed = j;
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
 			    j > mddev->resync_offset)
@@ -9581,7 +9582,8 @@ void md_do_sync(struct md_thread *thread)
 				 * The faster the devices, the less we wait.
 				 */
 				wait_event(mddev->recovery_wait,
-					   !atomic_read(&mddev->recovery_active));
+					   !atomic_read(&mddev->recovery_active) ||
+					   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 			}
 		}
 	}
@@ -9592,7 +9594,8 @@ void md_do_sync(struct md_thread *thread)
 	 * this also signals 'finished resyncing' to md_stop
 	 */
 	blk_finish_plug(&plug);
-	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
+	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active) ||
+		   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 
 	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
-- 
2.34.1

