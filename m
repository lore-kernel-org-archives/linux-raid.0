Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021134.outbound.protection.outlook.com [40.107.130.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D456218587
	for <linux-raid@vger.kernel.org>; Tue,  8 Apr 2025 07:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.134
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744098564; cv=fail; b=LT9+4wlAt6zLzPxD5/OoR3E8RlL/OLv5C0JVrpxamfjnSQW/Z2ZiM0ZU+TxG+SLOw8CPUcYmoREpwxdSFx491FUan9DDBkyjMg1QLdM2Tl6wtwnltXEhtXdOcxVz2kMw2UjuDyWV6bFrURr77Ko+Z2jqswkkIk66oFelkMLHVJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744098564; c=relaxed/simple;
	bh=FgeVyQfNFqe1sFM1wfRM8pg09VxE8xSzBL20bv7awpI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=apQyVFlhjV7beNqs05kFfUoNtScASGg2SWhbo1ge/ACuvZp/dVi1ehzU/HNhWooJthcDeRwj9JzsF96TPAlIlfZG2DF4OnVYva4FJZTq2p0CHMTvmTL/LKbFHoko7J60ubSCxUkcv06QEc+1bxXLQt05tOt2iSxZ4EGwAHiegC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=EV3nDTvp; arc=fail smtp.client-ip=40.107.130.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="EV3nDTvp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aybSsK1d7nlMK39b8vR+XpoOQpV98dEwiJtbh7HvHR0OaU5uYRWpocmG9FkZHnoxjCwhqZbnO320IuwULjX3jpKE0c4NIBHPHHpVP+cZ/BQ1afsF9wvPYgHdrLu34lsSwiB0hEmDjiVyQH3wxQExeApevSc/P8+mYwm+oV26YaSqpIO1Fxx7/4t5cDlywzbBFvPuBiDQztXvOxNfLl46MpqiDY0LMOdAi4CBOhIVQ2Mn/eyUUzIm0PicfTYUKNTCAT3ljZCgEtKwqFHb1TM+XhEbhyjay2MDfxknj86pTITu96mrnThLCjYpXVchZyXO4OrKiSK4l6fvGyMH6ySJEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9owV2AWx7pAwBo6pzo5cDS8TwNV3FWuPboYDcTN2a4=;
 b=q1vistUZRhiiJigOVbx0/B2oHHiY16i6wp/A3AJqBPJXAeQ0rAGm9PaZTkubryg3xdMjtLdGeKpS1nIZp+HqzrGO8mb6pvvQl8RHo2RDFhc31mXS7SiL46/4ADb3a0n3T7hPczrcuJznUH8hbfrnbXrR8U0psJqkKJLubOJX+q9iOQooukBkNGvdHFZSWSsOyPX4wBUeTFIjkBXRtNhdgPjzA04EWjVS7jDECi/Cv3fmcvxrnyrUXlXoJEtATjFyv2+hf9k6b+LYTZ8Y8uwDDyoySXFblNh4d1uPAPv1x69SqDqf1xPJrzOQw8d4oqoYpYy30vss4VV3oiFojBPgxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9owV2AWx7pAwBo6pzo5cDS8TwNV3FWuPboYDcTN2a4=;
 b=EV3nDTvpRdTT3pHlJsSoD6F/HuhCcSM+WCxw/Oh+p6wGzDpWMhqD17VC5+fY3ba7xS5PA4XY4BrEDcEe4JrtwGl8ntPoSPyvFiCJ9/PMeP3LmeCcu6Ry+65NVyGbZS3fan/9lzPupLN23a02lEbgFa2GjMnIUQ8S+8YAlIkoCmBd0sBsR6+U46pvwLNMyJUs4dTvKgqUP5UwtNJ3A7N4n5guDQus3pG1ixZ0OZnikMZc2aSvqJacil94AvCd9XekBtxvxMbRIcyTfrcOCM3mqDCDmS0CZI2wLwkwAAt5ptsSsUSsz7vv24ifaZmGjAl28AAO3SJVl1yISk4HGlQFgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
 by DBAPR04MB7464.eurprd04.prod.outlook.com (2603:10a6:10:1a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 07:49:18 +0000
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8]) by GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8%5]) with mapi id 15.20.8606.029; Tue, 8 Apr 2025
 07:49:18 +0000
From: Meir Elisha <meir.elisha@volumez.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	Meir Elisha <meir.elisha@volumez.com>
Subject: [PATCH] md/raid1: Add check for missing source disk in process_checks()
Date: Tue,  8 Apr 2025 10:49:09 +0300
Message-Id: <20250408074909.729471-1-meir.elisha@volumez.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0007.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::9)
 To GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR04MB9927:EE_|DBAPR04MB7464:EE_
X-MS-Office365-Filtering-Correlation-Id: 900e6675-cdda-4720-f2a2-08dd7671ddaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8REgFtAKIOHFlap8/vm+Dcx5W+KZM/rzXErx/qR9kfe5flyLQEJpH2My33lN?=
 =?us-ascii?Q?DbxgNy5EqDt7V0U8F+o8dJrytGUH0cSVXEGZ/xT9KNvUYE22gnJyqWCjzaDA?=
 =?us-ascii?Q?a45aDbS34rnoyLr3FlGcnpqoxTOwMH6hfGnmGrUek8v0FM8Vh7hLu5so96BQ?=
 =?us-ascii?Q?XDekErXSRypCq6kt9tXlzVk7sNv6IY12JJKEgXue71U3n34G1QjQbLGpWzIi?=
 =?us-ascii?Q?7wU+hjR0dXQ7RPFcDGJVhUcvECcTyQqSuPIDRuEHODqjMvxfTJXow9Kxociw?=
 =?us-ascii?Q?si8t9fCEHkFnzDa/z5SUigrnpbdwceM/kF8rlpHxoXZMvtk+NeGguU3oFd2S?=
 =?us-ascii?Q?tKArUnkSo8WOQOorVk1eRHXUtRGS3ulDT+uH3P5kiipJZj0iHH71Fb6NaIgR?=
 =?us-ascii?Q?dHtpJZWe2lsQp6ag28nAdccnmcfFhLH0SsHEkM7k7BALtnbnmQCPJi10tzcj?=
 =?us-ascii?Q?/wBnI3hCbJsuv49ZDD7R9u38kQbZ7sYGElbsc9QGi1ofMJVdeanWMd/EFatm?=
 =?us-ascii?Q?hhZ9f7Y9JkplxTO7drWZ8Lhqq7ro5uqbqktzIXjA7WZGajSjPV86oHUhs7Oe?=
 =?us-ascii?Q?f+UVta93UfCodQ1uAjoOMUqmEGY7965SmCbNgPX+C0GEzxGlrHbi7rIpvQS9?=
 =?us-ascii?Q?Kl4eIecnhKeDZCd1UUaa3KqQBdF2WDCeNQkBKvZ5dWv4TpbDcsElQu5USMFf?=
 =?us-ascii?Q?h7RQ8HqHdhUnCaOh7CG73hCyMyXj6WQpYpqnJF+zHRyG/1+IIbB6ESeR/JQN?=
 =?us-ascii?Q?WovDTqwHvbKnoW0iFH/O/PWACl6Br6ntoTehGLpCpVmEZjwFdV6cwBO3kARY?=
 =?us-ascii?Q?2bjTMaPPvetxmx1ll2uID2S8npdkPmivGDI+7nqtt8Nr+4zoLSTC+R5NsmVA?=
 =?us-ascii?Q?dTH4qCTpAC59363UAQvLAdFfr17k3ukfyYqs+/6XYxh8hhW0iZ8SscZG3njg?=
 =?us-ascii?Q?i5ii+7uwd6K2/D7qMzjgdiMzBGemKlD/G6uNVf8qzZ/wF99Eja/MmHzRC7gJ?=
 =?us-ascii?Q?dzuuGtjxwMXXhfSfpuosqktnayq9zq1hsjgjUX7a5XSCEXQXGhIMCGhC0gIf?=
 =?us-ascii?Q?gCixHheJd06bwlZGtIQWMqpJBBi0OPhwkqVxmSNje8I8b7/St6/ZqUnQeQUd?=
 =?us-ascii?Q?rXlW/WRuPzfHkm7IITGgA+2QaiLqqTf9us/6y3fbc2Cd4FsHE09aCRI6DrFp?=
 =?us-ascii?Q?8PFZNy0/bogC1Wi551KOcFiXegPZXdmIj7qaFv6sryjfLimmm4TCH+P8fMZC?=
 =?us-ascii?Q?gIih6iUyEFzYrPQvIVxMGc5JVoi+C7SSMbHJC5Gz60nVkhWS0JAOTsz8t6LA?=
 =?us-ascii?Q?jdHPMywR55Ilw6T1q3m81BEo0Qtb5TqUWYnz/lPPjgM47Z50c25RRicsa8cC?=
 =?us-ascii?Q?4UGQAd7DeW6c7sAxmpyN01yDW5EAAw+0cxaew1esQZaQevFDlRvvFdjCmkdm?=
 =?us-ascii?Q?jVmvOQu2GvIEWKK8U7/Y6XKLdf1AsiDo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB9927.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0WzS1IlV3uLAsC1x4z0GAmp+vgBis2+9eQKP4QK0SBGNwVnh+Ez7Hxt5W0qW?=
 =?us-ascii?Q?P5y3ca4AEarObfLrsSkO7f7TMbNRrPPcHjmjToKHogSiUQy5gbJRm+ghr4gU?=
 =?us-ascii?Q?MDk3OMzzqNR49LjqORmob18xe5cou/rN9Lg3w5z6WEtAzh6+WvCH321bZ494?=
 =?us-ascii?Q?YHpwTjIvOh7zSg6oazzJsd51q5HIbMHl3Z6WYnIHs0uXAmqofQa5ey53tsWB?=
 =?us-ascii?Q?x4CAHX8pN7DKW8rUqfJK585QpfZ5deQjh5JIBEeSeIJjSKbKRhthJrS+9ghG?=
 =?us-ascii?Q?OXF6+ATmywwY2vp6Mg2vqh7syEaWBn+IfM3DJkLAzj5OfAj8IANa1r/eEx7b?=
 =?us-ascii?Q?fEOri2W3dmLQsTu7o1JjO0fDUhKCz9LFhHR0tifGBo4yCc9Bj+TGpJdKctln?=
 =?us-ascii?Q?To5C4VeczRgUailRDC+jYEIwOQ1byK9iCWqaaiF/KfdQ15esdmacA6T06TcX?=
 =?us-ascii?Q?3abjCeVAhucvqxg8GjDUC86pzwtiFijES20UBeuf7qK6ZzwH+cEQvV12Oyo4?=
 =?us-ascii?Q?lAkeYlfERkWt77U554QqDHk1G6DrwAz5Qy3VmG/9P2+AShpMn6zeqh4SG5yt?=
 =?us-ascii?Q?RAGJ/yMKPuoWP/FEGTqO09O4mW+aP4OvcPPLnwpOaEyxjSkWkeHsfsZO7FvN?=
 =?us-ascii?Q?C/YW6NdBeJQjYPtlkztgZ1T2NSoIuZaYiu/PwlDGdvctyei6vwxwU6hwhLXD?=
 =?us-ascii?Q?WnmEnv8GAlzuooq7pTE1vkTgSG3E2I92Awt1DrDz2ethYOOIOpvjGbw1BJ/P?=
 =?us-ascii?Q?y66VOmLTMygeOn9v4rCNs9iQtj0Iu0AB5GrbXPDxEj9gGJdfZ7FXr28eCJdw?=
 =?us-ascii?Q?v5FLXJEfhedFciv3aCBxywojHPVEjJeDAtiFyC6S22dEOSGa0mXBiN962bUd?=
 =?us-ascii?Q?mpow9J67qId1xLX9hEp2ShCTeEq5NSthHvC5yaAY+KlWQHEjVYbM01qV3nXF?=
 =?us-ascii?Q?pcwtBSV1texqLtWL0lKecykhtWujcVmkR4Lx3BsXlSmuSKN76YwHgflEc9Lw?=
 =?us-ascii?Q?TO9rdADZSTywJ6xtxE/Mne+6JzjsmKRqWxKU9yxtpqzU1Yeg2W2jK8HdH6Om?=
 =?us-ascii?Q?FQdf0mRN/yYPqYY4B7HCe0MysEJzRi11yumPtsEWZTHLSP9j2GN8AUn96m/D?=
 =?us-ascii?Q?Z6kAFJnRnjJS2TbkszQm6tYpf/i3s+DJq/yZYdkRtS7wfMDbR+TJ5VWgx+id?=
 =?us-ascii?Q?Pnc2oZnT6l16tQ4uoWG7BwOqLpg/DjHGyoD6OHerZkwK7NFzkfvwhXx9fMSw?=
 =?us-ascii?Q?r+GSAiYzjuq8S9OhrchoYJteS340ycq6wUe5SNSJYsYCQBtEVel+BGf2kBT6?=
 =?us-ascii?Q?7ONt13VcEd67f8RdiaroSzMfxeVt684WYymsu+RLRoP+GxxSXcAJqA9oeO9R?=
 =?us-ascii?Q?QjJPnBhqwiymm7sc3IiTt8I10pwfMVTxrueNITUq/gUktcRtzOdHpu32lQE8?=
 =?us-ascii?Q?xvLew1xm27XC94DS3Tc3Fw3gs70XPvclQZ7TUKI4nr7y81+1szAQkWvL9x1Z?=
 =?us-ascii?Q?dHfzfX9rQFgfPwBLddFO2BsV9bIAgTgewDHm5vONTwA9IyKMM+0OoqmF5dhd?=
 =?us-ascii?Q?8d1LFkEVuLN8r4VPf7j4K7VLnlpllb//zdYBUqtCMJfVOJb4x95RwrX4gnff?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 900e6675-cdda-4720-f2a2-08dd7671ddaa
X-MS-Exchange-CrossTenant-AuthSource: GVXPR04MB9927.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 07:49:18.0355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HP7GyZPMg0gTHtFuINB3lRftNYam5vAuFLvWzXZx0+r1aWeSnGU0mSc85M2zfu3SYOJtBC3n630bhbBt1TQuhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7464

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

 drivers/md/raid1.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0efc03cea24e..b6a52c137f53 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2296,6 +2296,12 @@ static void process_checks(struct r1bio *r1_bio)
 			rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
 			break;
 		}
+
+	if (primary >= conf->raid_disks * 2) {
+		pr_err_ratelimited("md/raid1:%s: unable to find source disk\n", mdname(mddev));
+		return;
+	}
+
 	r1_bio->read_disk = primary;
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		int j = 0;
-- 
2.34.1

