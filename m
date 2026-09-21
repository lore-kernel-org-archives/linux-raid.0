Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010045.outbound.protection.outlook.com [52.101.69.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4464B44E66C;
	Mon, 21 Sep 2026 08:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978368; cv=fail; b=Cp4Yg02Y7MBWBPTeDpYg/2+Q7pGjb+VimEwda5hFC0mrsmUOJvYf7byf3SsyHUCVdlPS6BOVaIwiE+Ya/yDNuv73fZu7jFpGXv44A1Uf+FeSdCrGb1kxuBoZZj9+2zQ6ntJIdXrnWY1ucAFEfh/1LWn0jqlI2UKD0IIVloyHJZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978368; c=relaxed/simple;
	bh=9PgWpFz1y3ZJbZDRAs6VtBIVSnd4by//lGzQPXM978g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YfVG+FznAVWMSqLBX8aw3jM7xDTc5uRq39F5IUvU7xBo0cPDbyyL1SP+/9RwGbExCGTQ5iqIhPa4Hee9Dr2T/2vD3lYEizbgapeea/xGbwm6oWSEnOdSTNZ9MLb5i5cH0FMP0sZkEW5+6r0jvjErfTr4jeG1KoBiqLXmUcm+j7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=DM9cIo77; arc=fail smtp.client-ip=52.101.69.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="DM9cIo77"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nEil6JiazleuPeScjkIRFfEMipT+jdq2/y0VBaAZArivu9i+Gon7U9B2WNMWk32W09bdTL9c7XmyTkyWR9xurR00SGpQBvx2R2uCH2cTY2zH2ueBaLe2dQj5ohsQuRwrUl2h/SyJZMUn7d1ELacw4kt0g0CBi4XpqcNqYmy9z8Us0kLhCxXjYzLPddd/mM/FChuE9saJVJ/t/swFe2rXDuSz72daKzy6Zbp9uTxruwS5li56ndzPmhvCeBGg984PNMXr4j2W9bTi1+1nODPRRaiEG/NcdQOIQLEIARTa83awP2v6aw8ZFU2UKp/Y3Qdoouiv9vR1zo7gCKqrQ9MxYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FgzfcMFxnksj0acISF7QDut1TJQ2ouU1SMp7wigpAk=;
 b=Q1RX9ohlZDPD3dcwCbLp3Jw/h8gjlrOQCDfz96jA5k6hLNTU+81hezLIuAKcEJzgmTy6W3x0xSqIUafiwYzUmIuPTTZotRnMoAqmBdZcywD56I4qTgf56tKg1bdxs/5FnnhsmQnYuOrSagzOcYfIpJyE4zWyPfrNNaom+W+hiKKTnsWb00ViJXdiBfe4z8m0+YIXlEBu2OzD1GwUP3y7zVt+ZDmnFeq7c1CjLs4bnAuF9delhXkEhaYxs9ZFBSRxNlXcx+VC4nAH8oZ42cfk09dQQDzoYr365CFd5lbyoPf3hDFt73Y09Fbf9XdVAGAXpNA3lBB+pJDMY0iouqungQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FgzfcMFxnksj0acISF7QDut1TJQ2ouU1SMp7wigpAk=;
 b=DM9cIo77Sgfdux+/8DBJwsGoCp2EJHZDNIKFKqSwAB2LbeHBu28kWQwlvpWSbi6oWogJQGDXUHaim/dmksJmn8cswqOer0SVWhCUVFA7hCad7P4kZU6r7+fu0hhE0S2jTH2jQNpl4x4IxR5AxY4T/6iYmDnwFd/wroDgj6xVWRSBpIFCN1eyJy6n0JHR/ELo/X8Ved93EcHwnrkTH6v/gXtD94EoGskvhfZwq5gM+0L0IsBP8tdAaRY0GJHFlzNXIdFyHNRf77XOrU+6/NU1Z86Ux4yVPdk7vPjkaEPlkQ/kKvtmh2m9OWuPl2P7FdeNjpDXeSlL5od+dJn3alFdoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by PA1PR04MB10366.eurprd04.prod.outlook.com (2603:10a6:102:444::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 08:12:42 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 08:12:42 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	linux-raid@vger.kernel.org
Subject: [Patch V2] md/raid: use assign_bit() where applicable
Date: Mon, 21 Sep 2026 16:10:08 +0800
Message-ID: <20260921081009.278532-2-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260921081009.278532-1-peng.fan@oss.nxp.com>
References: <20260921081009.278532-1-peng.fan@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0002.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::8) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|PA1PR04MB10366:EE_
X-MS-Office365-Filtering-Correlation-Id: b33bfbcf-251c-455d-01b7-08df17b81be8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|19092799006|366016|1800799024|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZP8lPrfz0aqx7QIEPZaTsCzkr6D+3cBoe9HuUd6jPALjQnEALWmtTu3RyuMkdcSgEQvAhR02dLOffgc/+izITSDnLCRFeBv4+lTaUFcubsB79F6/ZM7nh+sG1f1De3U1e3QT9aT7PD/mtiI4U+3ZcmZY3cqNBVHQ4A56GbjXxp4Ky0hUikMWqhEoDN+lKPvNF0YDq4+9lFX0MfIr/epzDmjsCdaIijyBvp52hN1UZsqwrQuUqwHBjipnbZRBRK46EUs/h6q/wcnSNwdkvnB34UvzE1jNqoQFL0pZAm05QgaPjcgMXJ2JcpHS10fcy1fnC9DnPz0ASWUQeEvjjJD2aE5K7OPZAK+VCzM9Z0oaj1ZCrWyGt159BXTteVuBk07ixxVHZ+/8tJCKTWDfyII6aaM7iEY5Xx94nEMdUVvzsGaw4QQyDrYtUlMs65ZDbmB0NgQsqw6GV4GVDoRCzlPTHwDwdP6tEFN/Bewu1sDa/G/r3/zJ93C7/cT95XFiynK42/lwzbUIs3lp3OjBnmfnjy83N0Xp/INq0xcioEHELmCmGUHK7lXwdBcRQaYTXKRlLbWqbxF8LNPcBC3IAGbB8a/VMhivQDM/NzkU1IC1mlTXqt55ENFH1vEjMARG5+BC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(19092799006)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O9mUUlLzDEEpxcci2p/O4CDOTsD1nJvcTDiuOs66SZINwVCLQamfnS4BbhVH?=
 =?us-ascii?Q?Brk8A7GEOpVL0KP75fbQCpy+uYSr49xu7xgVbPWbggOj1nghDJF2QjTywIy8?=
 =?us-ascii?Q?9VxLl+tORsMQf2k7RQ5P6YgtW9FKxfKGbyJaY/eCARo24k7HDMoqQcfi6sjn?=
 =?us-ascii?Q?W/9aI5qZNTaQNwJe6r/yVmMXOXtGinkGNDtk/P46CiKCMnd64quoZmhUk/X7?=
 =?us-ascii?Q?vmo85vGhMVoQ7pdcWRk1qWGZQdupVDueOs8VlEzNjt5/MnV0jCFnJZKB5LU+?=
 =?us-ascii?Q?gGZdRJMpjwIf1u7+rdUz6XPXQV4Y4RztRuL6no6zLtZfjVxxDPOjRJdPmXbN?=
 =?us-ascii?Q?nQbFIrTfMcCWztwf5XaNIoLcOjHWLhJK1GvH9EwcpWocz6auSVTqe/sH1xU2?=
 =?us-ascii?Q?hGeT3KiY77h+gm8Pg7ykPe9kWPU/qiYojgA34ovBAXExj+TADXOOwjf9jdzz?=
 =?us-ascii?Q?J6wlvPvwiZaXSUjnJy1DhDNE0dJHTVpCkWXFV6PELKe2Sy55+NkFomr+TyMJ?=
 =?us-ascii?Q?11O5CskZxLgzAF7oNDgLdiorE6oVH5+FSDg9C4aVSwmOlY60gZ1VLCxkXrUl?=
 =?us-ascii?Q?TT9nCKMAmzNfKjNJ8QF1t95xxCragB4bzOTlwXP3TQ44OMGINUlxHF5vd/UE?=
 =?us-ascii?Q?kT7TfZOmOAWbqFEqKDNU+FWf8l6CzByibA4g1L5bYbXHUKl9XsMhGrZBnGYT?=
 =?us-ascii?Q?o0r+rMpi0E4kp2uR07Ifvp9M18qI9i8jqSOGfLmSMlmwXbXcBqFDagr7xizt?=
 =?us-ascii?Q?x4ckGalS9dBqD8ZeUUZk6aVbGT4PcajH5E5Fl/kc3yLwPvDijtz8iI+rS6WY?=
 =?us-ascii?Q?17lRq/cIf1bpEEtgbvl22mN6uy69eA7LaEXTleKcc8DCklyhrBtWJ4D1+eNm?=
 =?us-ascii?Q?GO/DrgWTjj/jT3Orj5VSkLLwxQuB27bxRekv4UDOg6JU9r977EVMEQhv+Roj?=
 =?us-ascii?Q?4nv7yk5jNFmydhGqaPLupEYkpZUjfW1zMxiN6dxrgmbTpk8CUhjSIkDwFp7o?=
 =?us-ascii?Q?DZpDuwNgdMgTmssoNa6nhOqAnEUq9kpvlKIFwHIjVtPlmDGb44l3Qx01Zjv0?=
 =?us-ascii?Q?Laisy+ptuyeEVC8UTlIgM7F0cA9+r3TOciUNEUT+etHqrhfT55nat34g8Bz6?=
 =?us-ascii?Q?0yV+MPIjqVjFvZYrrNor6rS4ZEKLm0LNcMQoP9X3JqCzoNV0T1TuyvxtbZcX?=
 =?us-ascii?Q?5NrbBtgP1G7MK0tXtcZWszzKcmN0fKGVa2OrpgOxO8RJS1GCNpGiy7uxCEST?=
 =?us-ascii?Q?LdR26hTLbc38iK7PDct01BIPW8JrML9U6jlt5ao4GA2F4x8Rw3mruO0yZl45?=
 =?us-ascii?Q?xBjnGUhQeEbAr3TdkBZgwynRS5w+nvqOjT28zkl9SUjUmNv66BdO7V52h+KV?=
 =?us-ascii?Q?z82qDrIpZLtONdRmYIcPdJMSPotYZb8QAq4jrMZ3Oofj5n9Fd7kG8wp11ssG?=
 =?us-ascii?Q?MY8vHVZ/q2Zxov8oeGES4SdF8pxCICSDnNaDtbpVYP0kLbbWSg3g7dgXYkZn?=
 =?us-ascii?Q?tRJCA6WukTKPG2R0HLHDrYlrn7G0fz+mmBxYULSzJhzFqfQ2oUyRahcfrn9Y?=
 =?us-ascii?Q?6eoTAwkyAWN4mGrbam/9XTkYZR81+rdhThY+Sps4RpGXIfNxwAtahS+0tylF?=
 =?us-ascii?Q?yWzQNDwv5cYxCkAGN4c6+uF/6TZRuqqyAuG66wrLWWqZhHwmND0ECxceSwXB?=
 =?us-ascii?Q?40Fgi5YmvHg/3j5b1dsGr57poUSNFrKpeLkGxfvkR/0Rnao4EO4txelHr7KC?=
 =?us-ascii?Q?Z8yKhCmo02WcDHAkOxeXDZr2dJEPBj1TfWkJ/yF2Q3qRHXek7MxJ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33bfbcf-251c-455d-01b7-08df17b81be8
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:12:42.1941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWOSewQmR01i09RdcyrE/L4V3JLIsMN61QrPaZBInp1vapcLyns63dncxcJ+R7xS4RLyPM4iq2kNWLYPsfadQ2UZlD62hHDQzvtyiamEMgq8oUgjf45snLT/2JxXt/Rr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR04MB10366

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.

Done with Coccinelle semantic patch:
    // set_bit -> clear_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        set_bit(bit, addr);
    -else
    -        clear_bit(bit, addr);
    +assign_bit(bit, addr, cond);

    // clear_bit -> set_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        clear_bit(bit, addr);
    -else
    -        set_bit(bit, addr);
    +assign_bit(bit, addr, !cond);

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---

V2:
 Separate device-mapper and mraid
 https://lore.kernel.org/all/20260918141737.3023011-1-peng.fan@oss.nxp.com/

 drivers/md/md.c          | 22 ++++++----------------
 drivers/md/raid5-cache.c |  6 ++----
 drivers/md/raid5.c       |  6 ++----
 3 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..6b2a397f8a9c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3586,10 +3586,7 @@ static ssize_t recovery_start_store(struct md_rdev *rdev, const char *buf, size_
 		return -EBUSY;
 
 	rdev->recovery_offset = recovery_start;
-	if (recovery_start == MaxSector)
-		set_bit(In_sync, &rdev->flags);
-	else
-		clear_bit(In_sync, &rdev->flags);
+	assign_bit(In_sync, &rdev->flags, recovery_start == MaxSector);
 	return len;
 }
 
@@ -5915,10 +5912,7 @@ fail_last_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	if (ret)
 		return ret;
 
-	if (value)
-		set_bit(MD_FAILLAST_DEV, &mddev->flags);
-	else
-		clear_bit(MD_FAILLAST_DEV, &mddev->flags);
+	assign_bit(MD_FAILLAST_DEV, &mddev->flags, value);
 
 	return len;
 }
@@ -7574,14 +7568,10 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 		}
 
 		clear_bit(In_sync, &rdev->flags); /* just to be sure */
-		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
-			set_bit(WriteMostly, &rdev->flags);
-		else
-			clear_bit(WriteMostly, &rdev->flags);
-		if (info->state & (1<<MD_DISK_FAILFAST))
-			set_bit(FailFast, &rdev->flags);
-		else
-			clear_bit(FailFast, &rdev->flags);
+		assign_bit(WriteMostly, &rdev->flags,
+			   info->state & (1 << MD_DISK_WRITEMOSTLY));
+		assign_bit(FailFast, &rdev->flags,
+			   info->state & (1 << MD_DISK_FAILFAST));
 
 		if (info->state & (1<<MD_DISK_JOURNAL)) {
 			struct md_rdev *rdev2;
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7b7546bfa21f..b442a4de61fb 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -432,10 +432,8 @@ static inline void r5c_update_log_state(struct r5l_log *log)
 			wake_reclaim = true;
 		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
 	}
-	if (free_space < 3 * reclaim_space)
-		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
-	else
-		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
+	assign_bit(R5C_LOG_TIGHT, &conf->cache_state,
+		   free_space < 3 * reclaim_space);
 
 	if (wake_reclaim)
 		r5l_wake_reclaim(log, 0);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..713596ee933c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4748,10 +4748,8 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 				       RAID5_STRIPE_SECTORS(conf)))
 			set_bit(R5_ReadRepl, &dev->flags);
 		else {
-			if (rdev && !test_bit(Faulty, &rdev->flags))
-				set_bit(R5_NeedReplace, &dev->flags);
-			else
-				clear_bit(R5_NeedReplace, &dev->flags);
+			assign_bit(R5_NeedReplace, &dev->flags,
+				   rdev && !test_bit(Faulty, &rdev->flags));
 			rdev = conf->disks[i].rdev;
 			clear_bit(R5_ReadRepl, &dev->flags);
 		}
-- 
2.51.0

