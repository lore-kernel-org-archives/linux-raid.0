Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021099.outbound.protection.outlook.com [52.101.70.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2155579CF;
	Sun, 21 Jul 2024 07:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721545897; cv=fail; b=hByuFbg0HGbLaXGlKoc00x+CwFNwq0E2bo2uUPdl9R6xo4sxNVa7zHOG32RU2k/zXHCBAfZ5BxNbo64k/3yVGmM+xtzCKu7m3mePJUT7pC9qpfJULy4+28x89TUQgBOKiio3JueD+U5foRTANoKI0q4imz+Jn4EAd2ykiV/wYMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721545897; c=relaxed/simple;
	bh=xHn5joR3v1zWr/E3bLCor0xNVLAbnth1ftqWsKd2D1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=deozpmDXps1P5pdlTfg1/4sv2N82kkbO0ysg/9tlfK1UpuqJEMJthj+8lD+zdh7uLzpRNCcM7VVTU6KnAU1n1/UF4TDZ2pwLF2xa4S96murgfdCuO0cu5GyLkzf6O0vlAZL8PGyaNmJ7dbRTOhUhvZvA086iiLUOCoE4E76Qxsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=QCUdxMgX; arc=fail smtp.client-ip=52.101.70.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="QCUdxMgX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DmGW012ozZXAKTPWnCGrCcDD0REUIx2sv+eWlz5XqaAvv38AvBCGfs7dn2f7p7R7ZggWgzR34BuGCPQfuuWRafOa9w7zevnjhRcxpmut7qs3wT5kk9Xzf1q3jZVKUloWdGkdhlURWXAJq3qK6KNRLgw7uGoLh39sjlaMJFY62sGf/yg275NGNqD2dAWg28JKXeFjemC8RLUakG70IJPt8Iytqvk1tbZafEO2kfAW/O6XEhTS/Z0b3bl97SiD4npdq/iAYO4OGTQ6c9CvmDpodj8kHtJmYTXFpswuSgDvf3tYFM0HnpnUISdL4zshuw/hg/UPjKTenGlkrtHgWCT8xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKBll5VEHTMdbiUvyUCQK6g57PpwjYFR90NOi60tyNo=;
 b=N3Yeyo8M4dzFV323tCb3xibTtnsXbAIqHXJfOivghDpWPTgBj3lzaZvCUvLM4ICXYZUBl34jOhBxjGbk9WenH96Zr0VJTQts93nLgkHXcvwm51aKkyv4XXkOMKDAoH8XOx7WRGKiE4pP/ZJnlrqCC16ebeoUUoolclEbpjqyj5hpOKLT4R8PfVOCwXEkRgXYtv8KpDgNJWzRAlboeGuHLqjkZrz81NOLUwLYAJBoLeCgJU2Rt2NVSjBJcx6gkPUT88yPUl1gD3SIGy6LYhNFLct1WlXOQzXDLZaaMQk43SRCN+IXrpW8OcjOi+EYycNSK49ryxHpsF46DRdCWIxTcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKBll5VEHTMdbiUvyUCQK6g57PpwjYFR90NOi60tyNo=;
 b=QCUdxMgXPqublMWG+NqggBpqXqATsh42na+50gsFXW5485IFPTqILKWScyIRNrYtpRIImBLVNvDTKZiwZlye+TV7MInAaMKY3Z7RyLos96Rt+cEXSABgw/YXxqFGhSK6uNWDQpKevAxH32rwUMFvI+8BldfQgSOZXm4jznwcCH9mZi2y9Ia3nyGmn3IXG6nwo+A5H7AKusLDce8hl8HRrGYXP21uVDgj91HKfwY9B//Vmx5OrcqrOZ+yWifz9zPSDVd7l7eQHKj0W6eq8vw5M+dUWImXu83uyjr9Jt0m2MAsN3U5qtlckbeFMNi9XWBYz9etaacKVn1PsKqgePDCmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by GV1PR04MB10396.eurprd04.prod.outlook.com (2603:10a6:150:1c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Sun, 21 Jul
 2024 07:11:31 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7784.016; Sun, 21 Jul 2024
 07:11:31 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	dwagner@suse.de,
	chaitanyak@nvidia.com,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org
Subject: [PATCH blktests v4 1/2] nvme: move helper functions to common/nvme
Date: Sun, 21 Jul 2024 10:11:18 +0300
Message-ID: <20240721071121.1929422-2-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240721071121.1929422-1-ofir.gal@volumez.com>
References: <20240721071121.1929422-1-ofir.gal@volumez.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TLZP290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::17) To AS8PR04MB8344.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b3::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8344:EE_|GV1PR04MB10396:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cb33c6d-3cf6-4e86-2456-08dca95458e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iHPY2V57tIuJvzRRzUxcKBKsR6PD9Y6awC0CX6D8up5CrkHCpoBi19b9JwDD?=
 =?us-ascii?Q?WdRjBMcInkLIn6WL6zmW9lSWIvPiXu0jml1NpLW5oxcsz8OzFOWpWEqE6DY9?=
 =?us-ascii?Q?xMtxukdqa1fpvDjFcNb0ap1JjFCh7EXoo1ams3vG77tp3cP8ZJFAb2l9mlJD?=
 =?us-ascii?Q?snmlw/waV5j/mGnZF5F8Ru+2J26PBkUWiK9obiG5FDhw5dDJDWo4i4BfRdUF?=
 =?us-ascii?Q?RvOlQqvGQuBIgeL6uz3O1NYXgDjkD/KiU6u/JBgcYmHkvueiKzY3VxrvtG1Y?=
 =?us-ascii?Q?y+fFQEsTAMD0mOr6WAlHrFYybWmTbnl6WIjb+v6mlLIztS3rEUReTaowhYJS?=
 =?us-ascii?Q?GCdgiT0/mL6w9Hx5GhS6bGk+ReoVAeAbRJ7hlOtDyHlF0UaMgqgV8Y4WIvgU?=
 =?us-ascii?Q?Ef7f+qFmG5E7Hg/wyzdHCFb5igSyawSUUDVTBMtiwb8RnCRovoEd36CCRQLr?=
 =?us-ascii?Q?3EeO8vRfeDM1kyRhPDKfqeAVjBNz38pj3hx2edkmylrjWZAg1WFzpjSLkzkG?=
 =?us-ascii?Q?yO02bIIyVX+pT211G9DWHsxvzBBKUjxV9NiMJQWYbyS6fN3B/p8RzQiY55pG?=
 =?us-ascii?Q?O13XF4pyy4NlYg49w8zv0huewHrNkfueEnlkmNWhIv3HfdmV4y1Hzu738OYF?=
 =?us-ascii?Q?XXpJWQXiBpgBrNeZyn5FuPp24J+alcY2oSF3/WKm6LDz2yZ3b/V01EBqcBu+?=
 =?us-ascii?Q?2C5P9s6sEKx24+QICbiV7f882RQMJsevrByKLM+6ulJZVmWtrxDL1sN4F+yY?=
 =?us-ascii?Q?rVIoP+HoeEosGc4Mb5HjsP+vYTMBAiMrl6ULM8y3KXALwz6/jBKlP9LXE63r?=
 =?us-ascii?Q?2bEz5SZimC5b1tRYRnr2xoGtiEOvp/5Q1f5XLB3ux4xYxnMIH9TRdxdsbdhV?=
 =?us-ascii?Q?VYQ4HbHQE2aPiw96JGz1/69XwTGEQL0WpUj1NiIhAC9O8YkLAXzchUkCHial?=
 =?us-ascii?Q?BFdo9PGkRsT9K5q2NIpv14ouQw74AaOvcrfz6KAhEyZiK8Gq/aG6DW12lAN/?=
 =?us-ascii?Q?EYzASH7qcoIm6NceQcZA/iyDXtLclEV37QzPG3K7GM9aCV8+XQ8za4BXPrYU?=
 =?us-ascii?Q?AGru9GAH2Bxi4KWWCCmeo2ysLfEv3e010Tm/Zo/0q0aTTOGuXumszamEHzBm?=
 =?us-ascii?Q?c9b7gegw7zrR12zGLcs/T6flNbER84J09beyiVoyPGnsgIaiYXVzOmeVwpzN?=
 =?us-ascii?Q?da82UgmscUnPPiOotU61kM2hWxH9TTnpa2XjOw6CkA/menNr640YxTGBhhj/?=
 =?us-ascii?Q?bFeL6cgN9BakQfQyN5w7heQ5bqx4lQ7kh9uoaRyzYm34pU0xg1kd9gESb9wF?=
 =?us-ascii?Q?oIeKPxLfNeDOlV0HktllP9hTYACIQrVWEvFh8LzrbWxy3jfTco4ilY02t2Kz?=
 =?us-ascii?Q?ginCKe7mswmtFStQPDxm4fP81ib9UxFRx3GnewXiXmKu7e8Hrg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ykZHAlWPmocfHF9G8N+GhA62+34LPRH5X0TRA5JbDhOMTkmaEuzdfY8skNlE?=
 =?us-ascii?Q?q5q2RzNhW/yce+k7aoJNiGFYGyR9jbHKpnOa+F8OMbmdk5rwmHbnN5AGfbwR?=
 =?us-ascii?Q?++3jrYIFtyBi22DRhhQMtd+Z9sfeZegL5qAnoax1D32sNtZEfAyaUcTjWsc/?=
 =?us-ascii?Q?/pDz6IAduJbLcX0qgLzkE3tjBFM+caX4b6WKCd/FE+Pa2bMI5V/31UiHIji1?=
 =?us-ascii?Q?n5sS4LblMiOby/XzpmpT6YJ2d2u5B9YOxJ7ib3NaKGgJmBMBa298s1ceHSGw?=
 =?us-ascii?Q?6IOOldV3dpYvsC6/sCeGH9Wt2LVNMXJa3PpSTDRCercGXkXd5TjniQlYJ1s8?=
 =?us-ascii?Q?7VbOAQKqXWubWve+EBYw71PqoxYIwHs4v8wV72druGhfRs7q8ovrB3FyCWhE?=
 =?us-ascii?Q?bsEnkyfnrpk1E2MtxUFzbspRFFI1HETLiee/c8CTd2bysfmTEIsragk58D4F?=
 =?us-ascii?Q?PtmMXrG/tjLzbgalVN5bNDneqNisTjvgT86H3LvkM+Glqdd9LoTGFXIx4BuT?=
 =?us-ascii?Q?XOkTfWMyy7UsgCy/QSTUKPYxHUJCp6VLXgSSya6pDH2g6Yjes7JAnhQ3+Xja?=
 =?us-ascii?Q?Zv6DIUMY03U1IaCtdxpDPvkUsGEVhJS8nNvmmj6a93+4e90T9zEwtSNrZm8p?=
 =?us-ascii?Q?M+lDWcKrlXIe1orQ1zTVFdbCn5ioAosD05z8wDrEYABXl20WIaVmlNT0Z9s3?=
 =?us-ascii?Q?CrVif91Ed7tXoFXJPinbdDW4QMKiMDBt5qiz+5j7zTxzUSVEW1gETFAyuP6p?=
 =?us-ascii?Q?LvJdG+2um4tQCUN+NVsb70AY+D++PXYYML6B02EvGewUpmT2oSt+BsaSCs09?=
 =?us-ascii?Q?3qpDqYvR+211mKJZLplaQW8kwUjUMrDIJj98uk6TZf454CbNnrRLe/tVOQuw?=
 =?us-ascii?Q?wAoxp0b8huGOc3A5fjdiI4RLoUEJxyNy7ZzuZxjxweM/vGy+x11IiCdsjGGs?=
 =?us-ascii?Q?noR/lpNhkkmxaxmVhTjGxc/s2kZxkZxwJVHwst8NaGR9UX/WzFGQtUhSp9MI?=
 =?us-ascii?Q?fTc8LrAbiy9i/3lORwEPw243Ym76tHU5N1wtAHaZQzyL4YYfGq70/wriROuA?=
 =?us-ascii?Q?XnFDCHVfydUvzCdRd3HrZlwl/rT93Yhpj1U2P5c+/D0uwBVXYxyNTeowCEdq?=
 =?us-ascii?Q?KjDggmPpZY+wJJUE/GlOZ2SoVYG9SrlSftuleqain6C/PySr1Bspwwyw2+Uq?=
 =?us-ascii?Q?Hp9iOyWj2PyjHRTbs8mLMA4k5hadDBwMU5EVIr3yQx+8Gm90RVBRcl2RL5Jx?=
 =?us-ascii?Q?iaxHF0HaxDSjBEpU+K1SvPagInaLfERZyhx5PQz3kuzfSTVdA5hhGfC/lvfc?=
 =?us-ascii?Q?Wr4okCN3X2yDgj2XdSXjQs+KiDrlkEAycBplJUmlOdZW/PmQEXgQexkTaz//?=
 =?us-ascii?Q?A3hN1+JuwIvgxrGs2NiiIZ7hB0wnL9UyFnwnzZpECwm09uiUHeK1Y1LCJsls?=
 =?us-ascii?Q?hBx/c9lv4BodEP1OuKwIIw5Z6ms0vpS2ho1mqBbYzcghABnDB1qvNmJZLfQI?=
 =?us-ascii?Q?7JWiL9CzIbybM8fJ1EU/CuQ9zSHu2sCnVarD70kb5rGYMyGTcqCm3SrATfxI?=
 =?us-ascii?Q?J+DDv6yGc5LhAJTcM+7WEuKKUWx2Yxp+jTQDk1WJ?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb33c6d-3cf6-4e86-2456-08dca95458e0
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2024 07:11:31.5089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AL9RgOIj3eGXC8cRkanavHaG8nmkhGX2ZwomX64jVhtsi3eD3OexNSFgZ1r91C65dHECfUMunJ8dZCfZb6aQ8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB10396

Move functions from tests/nvme/rc to common/nvme to be able to reuse
them in other tests groups.

Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 common/nvme   | 636 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/nvme/rc | 629 +------------------------------------------------
 2 files changed, 637 insertions(+), 628 deletions(-)
 create mode 100644 common/nvme

diff --git a/common/nvme b/common/nvme
new file mode 100644
index 0000000..9e78f3e
--- /dev/null
+++ b/common/nvme
@@ -0,0 +1,636 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+#
+# nvme helper functions.
+
+. common/shellcheck
+
+def_traddr="127.0.0.1"
+def_adrfam="ipv4"
+def_trsvcid="4420"
+def_remote_wwnn="0x10001100aa000001"
+def_remote_wwpn="0x20001100aa000001"
+def_local_wwnn="0x10001100aa000002"
+def_local_wwpn="0x20001100aa000002"
+def_hostid="0f01fb42-9f7f-4856-b0b3-51e60b8de349"
+def_hostnqn="nqn.2014-08.org.nvmexpress:uuid:${def_hostid}"
+export def_subsysnqn="blktests-subsystem-1"
+export def_subsys_uuid="91fdba0d-f87b-4c25-b80f-db7be1418b9e"
+_check_conflict_and_set_default NVMET_TRTYPES nvme_trtype "loop"
+_check_conflict_and_set_default NVME_IMG_SIZE nvme_img_size 1G
+_check_conflict_and_set_default NVME_NUM_ITER nvme_num_iter 1000
+nvmet_blkdev_type=${nvmet_blkdev_type:-"device"}
+NVMET_BLKDEV_TYPES=${NVMET_BLKDEV_TYPES:-"device file"}
+NVMET_CFS="/sys/kernel/config/nvmet/"
+nvme_trtype=${nvme_trtype:-}
+nvme_adrfam=${nvme_adrfam:-}
+
+# TMPDIR can not be referred out of test() or test_device() context. Instead of
+# global variable def_flie_path, use this getter function.
+_nvme_def_file_path() {
+	echo "${TMPDIR}/img"
+}
+
+_require_nvme_trtype() {
+	local trtype
+	for trtype in "$@"; do
+		if [[ "${nvme_trtype}" == "$trtype" ]]; then
+			return 0
+		fi
+	done
+	SKIP_REASONS+=("nvme_trtype=${nvme_trtype} is not supported in this test")
+	return 1
+}
+
+_require_nvme_trtype_is_loop() {
+	if ! _require_nvme_trtype loop; then
+		return 1
+	fi
+	return 0
+}
+
+_require_nvme_trtype_is_fabrics() {
+	if ! _require_nvme_trtype loop fc rdma tcp; then
+		return 1
+	fi
+	return 0
+}
+
+_nvme_fcloop_add_rport() {
+	local local_wwnn="$1"
+	local local_wwpn="$2"
+	local remote_wwnn="$3"
+	local remote_wwpn="$4"
+	local loopctl=/sys/class/fcloop/ctl
+
+	echo "wwnn=${remote_wwnn},wwpn=${remote_wwpn},lpwwnn=${local_wwnn},lpwwpn=${local_wwpn},roles=0x60" > ${loopctl}/add_remote_port
+}
+
+_nvme_fcloop_add_lport() {
+	local wwnn="$1"
+	local wwpn="$2"
+	local loopctl=/sys/class/fcloop/ctl
+
+	echo "wwnn=${wwnn},wwpn=${wwpn}" > ${loopctl}/add_local_port
+}
+
+_nvme_fcloop_add_tport() {
+	local wwnn="$1"
+	local wwpn="$2"
+	local loopctl=/sys/class/fcloop/ctl
+
+	echo "wwnn=${wwnn},wwpn=${wwpn}" > ${loopctl}/add_target_port
+}
+
+_setup_fcloop() {
+	local local_wwnn="${1:-$def_local_wwnn}"
+	local local_wwpn="${2:-$def_local_wwpn}"
+	local remote_wwnn="${3:-$def_remote_wwnn}"
+	local remote_wwpn="${4:-$def_remote_wwpn}"
+
+	_nvme_fcloop_add_tport "${remote_wwnn}" "${remote_wwpn}"
+	_nvme_fcloop_add_lport "${local_wwnn}" "${local_wwpn}"
+	_nvme_fcloop_add_rport "${local_wwnn}" "${local_wwpn}" \
+		               "${remote_wwnn}" "${remote_wwpn}"
+}
+
+_nvme_fcloop_del_rport() {
+	local local_wwnn="$1"
+	local local_wwpn="$2"
+	local remote_wwnn="$3"
+	local remote_wwpn="$4"
+	local loopctl=/sys/class/fcloop/ctl
+
+	if [[ ! -f "${loopctl}/del_remote_port" ]]; then
+		return
+	fi
+	echo "wwnn=${remote_wwnn},wwpn=${remote_wwpn}" > "${loopctl}/del_remote_port"
+}
+
+_nvme_fcloop_del_lport() {
+	local wwnn="$1"
+	local wwpn="$2"
+	local loopctl=/sys/class/fcloop/ctl
+
+	if [[ ! -f "${loopctl}/del_local_port" ]]; then
+		return
+	fi
+	echo "wwnn=${wwnn},wwpn=${wwpn}" > "${loopctl}/del_local_port"
+}
+
+_nvme_fcloop_del_tport() {
+	local wwnn="$1"
+	local wwpn="$2"
+	local loopctl=/sys/class/fcloop/ctl
+
+	if [[ ! -f "${loopctl}/del_target_port" ]]; then
+		return
+	fi
+	echo "wwnn=${wwnn},wwpn=${wwpn}" > "${loopctl}/del_target_port"
+}
+
+_cleanup_fcloop() {
+	local local_wwnn="${1:-$def_local_wwnn}"
+	local local_wwpn="${2:-$def_local_wwpn}"
+	local remote_wwnn="${3:-$def_remote_wwnn}"
+	local remote_wwpn="${4:-$def_remote_wwpn}"
+
+	_nvme_fcloop_del_tport "${remote_wwnn}" "${remote_wwpn}"
+	_nvme_fcloop_del_lport "${local_wwnn}" "${local_wwpn}"
+	_nvme_fcloop_del_rport "${local_wwnn}" "${local_wwpn}" \
+			       "${remote_wwnn}" "${remote_wwpn}"
+}
+
+_cleanup_blkdev() {
+	local blkdev
+	local dev
+
+	blkdev="$(losetup -l | awk '$6 == "'"$(_nvme_def_file_path)"'" { print $1 }')"
+	for dev in ${blkdev}; do
+		losetup -d "${dev}"
+	done
+	rm -f "$(_nvme_def_file_path)"
+}
+
+_cleanup_nvmet() {
+	local dev
+	local port
+	local subsys
+	local transport
+	local name
+
+	if [[ ! -d "${NVMET_CFS}" ]]; then
+		return 0
+	fi
+
+	# Don't let successive Ctrl-Cs interrupt the cleanup processes
+	trap '' SIGINT
+
+	shopt -s nullglob
+
+	for dev in /sys/class/nvme/nvme*; do
+		dev="$(basename "$dev")"
+		transport="$(cat "/sys/class/nvme/${dev}/transport" 2>/dev/null)"
+		if [[ "$transport" == "${nvme_trtype}" ]]; then
+			# if udev auto connect is enabled for FC we get false positives
+			if [[ "$transport" != "fc" ]]; then
+				echo "WARNING: Test did not clean up ${nvme_trtype} device: ${dev}"
+			fi
+			_nvme_disconnect_ctrl "${dev}" 2>/dev/null
+		fi
+	done
+
+	for port in "${NVMET_CFS}"/ports/*; do
+		name=$(basename "${port}")
+		echo "WARNING: Test did not clean up port: ${name}"
+		rm -f "${port}"/subsystems/*
+		rmdir "${port}"
+	done
+
+	for subsys in "${NVMET_CFS}"/subsystems/*; do
+		name=$(basename "${subsys}")
+		echo "WARNING: Test did not clean up subsystem: ${name}"
+		for ns in "${subsys}"/namespaces/*; do
+			rmdir "${ns}"
+		done
+		rmdir "${subsys}"
+	done
+
+	for host in "${NVMET_CFS}"/hosts/*; do
+		name=$(basename "${host}")
+		echo "WARNING: Test did not clean up host: ${name}"
+		rmdir "${host}"
+	done
+
+	shopt -u nullglob
+	trap SIGINT
+
+	if [[ "${nvme_trtype}" == "fc" ]]; then
+		_cleanup_fcloop "${def_local_wwnn}" "${def_local_wwpn}" \
+				"${def_remote_wwnn}" "${def_remote_wwpn}"
+		modprobe -rq nvme-fcloop 2>/dev/null
+	fi
+	modprobe -rq nvme-"${nvme_trtype}" 2>/dev/null
+	if [[ "${nvme_trtype}" != "loop" ]]; then
+		modprobe -rq nvmet-"${nvme_trtype}" 2>/dev/null
+	fi
+	modprobe -rq nvmet 2>/dev/null
+	if [[ "${nvme_trtype}" == "rdma" ]]; then
+		stop_soft_rdma
+	fi
+
+	_cleanup_blkdev
+}
+
+_setup_nvmet() {
+	_register_test_cleanup _cleanup_nvmet
+	modprobe -q nvmet
+	if [[ "${nvme_trtype}" != "loop" ]]; then
+		modprobe -q nvmet-"${nvme_trtype}"
+	fi
+	modprobe -q nvme-"${nvme_trtype}"
+	if [[ "${nvme_trtype}" == "rdma" ]]; then
+		start_soft_rdma
+		for i in $(rdma_network_interfaces)
+		do
+			if [[ "${nvme_adrfam}" == "ipv6" ]]; then
+				ipv6_addr=$(get_ipv6_ll_addr "$i")
+				if [[ -n "${ipv6_addr}" ]]; then
+					def_traddr=${ipv6_addr}
+				fi
+			else
+				ipv4_addr=$(get_ipv4_addr "$i")
+				if [[ -n "${ipv4_addr}" ]]; then
+					def_traddr=${ipv4_addr}
+				fi
+			fi
+		done
+	fi
+	if [[ "${nvme_trtype}" = "fc" ]]; then
+		modprobe -q nvme-fcloop
+		_setup_fcloop "${def_local_wwnn}" "${def_local_wwpn}" \
+			      "${def_remote_wwnn}" "${def_remote_wwpn}"
+
+		def_traddr=$(printf "nn-%s:pn-%s" \
+				    "${def_remote_wwnn}" \
+				    "${def_remote_wwpn}")
+		def_host_traddr=$(printf "nn-%s:pn-%s" \
+					 "${def_local_wwnn}" \
+					 "${def_local_wwpn}")
+	fi
+}
+
+_nvme_disconnect_ctrl() {
+	local ctrl="$1"
+
+	nvme disconnect --device "${ctrl}"
+}
+
+_nvme_connect_subsys() {
+	local subsysnqn="$def_subsysnqn"
+	local hostnqn="$def_hostnqn"
+	local hostid="$def_hostid"
+	local hostkey=""
+	local ctrlkey=""
+	local nr_io_queues=""
+	local nr_write_queues=""
+	local nr_poll_queues=""
+	local keep_alive_tmo=""
+	local reconnect_delay=""
+	local ctrl_loss_tmo=""
+	local no_wait=false
+	local i
+
+	while [[ $# -gt 0 ]]; do
+		case $1 in
+			--subsysnqn)
+				subsysnqn="$2"
+				shift 2
+				;;
+			--hostnqn)
+				hostnqn="$2"
+				shift 2
+				;;
+			--hostid)
+				hostid="$2"
+				shift 2
+				;;
+			--dhchap-secret)
+				hostkey="$2"
+				shift 2
+				;;
+			--dhchap-ctrl-secret)
+				ctrlkey="$2"
+				shift 2
+				;;
+			--nr-io-queues)
+				nr_io_queues="$2"
+				shift 2
+				;;
+			--nr-write-queues)
+				nr_write_queues="$2"
+				shift 2
+				;;
+			--nr-poll-queues)
+				nr_poll_queues="$2"
+				shift 2
+				;;
+			--keep-alive-tmo)
+				keep_alive_tmo="$2"
+				shift 2
+				;;
+			--reconnect-delay)
+				reconnect_delay="$2"
+				shift 2
+				;;
+			--ctrl-loss-tmo)
+				ctrl_loss_tmo="$2"
+				shift 2
+				;;
+			--no-wait)
+				no_wait=true
+				shift 1
+				;;
+			*)
+				echo "WARNING: unknown argument: $1"
+				shift
+				;;
+		esac
+	done
+
+	ARGS=(--transport "${nvme_trtype}" --nqn "${subsysnqn}")
+	if [[ "${nvme_trtype}" == "fc" ]] ; then
+		ARGS+=(--traddr "${def_traddr}" --host-traddr "${def_host_traddr}")
+	elif [[ "${nvme_trtype}" != "loop" ]]; then
+		ARGS+=(--traddr "${def_traddr}" --trsvcid "${def_trsvcid}")
+	fi
+	ARGS+=(--hostnqn="${hostnqn}")
+	ARGS+=(--hostid="${hostid}")
+	if [[ -n "${hostkey}" ]]; then
+		ARGS+=(--dhchap-secret="${hostkey}")
+	fi
+	if [[ -n "${ctrlkey}" ]]; then
+		ARGS+=(--dhchap-ctrl-secret="${ctrlkey}")
+	fi
+	if [[ -n "${nr_io_queues}" ]]; then
+		ARGS+=(--nr-io-queues="${nr_io_queues}")
+	fi
+	if [[ -n "${nr_write_queues}" ]]; then
+		ARGS+=(--nr-write-queues="${nr_write_queues}")
+	fi
+	if [[ -n "${nr_poll_queues}" ]]; then
+		ARGS+=(--nr-poll-queues="${nr_poll_queues}")
+	fi
+	if [[ -n "${keep_alive_tmo}" ]]; then
+		ARGS+=(--keep-alive-tmo="${keep_alive_tmo}")
+	fi
+	if [[ -n "${reconnect_delay}" ]]; then
+		ARGS+=(--reconnect-delay="${reconnect_delay}")
+	fi
+	if [[ -n "${ctrl_loss_tmo}" ]]; then
+		ARGS+=(--ctrl-loss-tmo="${ctrl_loss_tmo}")
+	fi
+
+	nvme connect "${ARGS[@]}" 2> /dev/null | grep -v "connecting to device:"
+
+	# Wait until device file and uuid/wwid sysfs attributes get ready for
+	# all namespaces.
+	if [[ ${no_wait} = false ]]; then
+		udevadm settle
+		for ((i = 0; i < 10; i++)); do
+			_nvme_ns_ready "${subsysnqn}" && return
+			sleep .1
+		done
+	fi
+}
+
+_nvme_disconnect_subsys() {
+	local subsysnqn="$def_subsysnqn"
+
+	while [[ $# -gt 0 ]]; do
+		case $1 in
+			--subsysnqn)
+				subsysnqn="$2"
+				shift 2
+				;;
+			*)
+				echo "WARNING: unknown argument: $1"
+				shift
+				;;
+		esac
+	done
+
+	nvme disconnect --nqn "${subsysnqn}" |& tee -a "$FULL" |
+		grep -o "disconnected.*"
+}
+
+
+_nvme_ns_ready() {
+	local subsysnqn="${1}"
+	local ns_path ns_id dev
+	local cfs_path="${NVMET_CFS}/subsystems/$subsysnqn"
+
+	dev=$(_find_nvme_dev "$subsysnqn")
+	for ns_path in "${cfs_path}/namespaces/"*; do
+		ns_id=${ns_path##*/}
+		if [[ ! -b /dev/${dev}n${ns_id} ||
+			   ! -e /sys/block/${dev}n${ns_id}/uuid ||
+			   ! -e /sys/block/${dev}n${ns_id}/wwid ]]; then
+			return 1
+		fi
+	done
+	return 0
+}
+
+_create_nvmet_port() {
+	local trtype="$1"
+	local traddr="${2:-$def_traddr}"
+	local adrfam="${3:-$def_adrfam}"
+	local trsvcid="${4:-$def_trsvcid}"
+
+	local port
+	for ((port = 0; ; port++)); do
+		if [[ ! -e "${NVMET_CFS}/ports/${port}" ]]; then
+			break
+		fi
+	done
+
+	mkdir "${NVMET_CFS}/ports/${port}"
+	echo "${trtype}" > "${NVMET_CFS}/ports/${port}/addr_trtype"
+	echo "${traddr}" > "${NVMET_CFS}/ports/${port}/addr_traddr"
+	echo "${adrfam}" > "${NVMET_CFS}/ports/${port}/addr_adrfam"
+	if [[ "${adrfam}" != "fc" ]]; then
+		echo "${trsvcid}" > "${NVMET_CFS}/ports/${port}/addr_trsvcid"
+	fi
+
+	echo "${port}"
+}
+
+_remove_nvmet_port() {
+	local port="$1"
+	rmdir "${NVMET_CFS}/ports/${port}"
+}
+
+_create_nvmet_ns() {
+	local nvmet_subsystem="$1"
+	local nsid="$2"
+	local blkdev="$3"
+	local uuid="00000000-0000-0000-0000-000000000000"
+	local subsys_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
+	local ns_path="${subsys_path}/namespaces/${nsid}"
+
+	if [[ $# -eq 4 ]]; then
+		uuid="$4"
+	fi
+
+	mkdir "${ns_path}"
+	printf "%s" "${blkdev}" > "${ns_path}/device_path"
+	printf "%s" "${uuid}" > "${ns_path}/device_uuid"
+	printf 1 > "${ns_path}/enable"
+}
+
+_create_nvmet_subsystem() {
+	local nvmet_subsystem="$1"
+	local blkdev="$2"
+	local uuid=$3
+	local cfs_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
+
+	mkdir -p "${cfs_path}"
+	echo 0 > "${cfs_path}/attr_allow_any_host"
+	_create_nvmet_ns "${nvmet_subsystem}" "1" "${blkdev}" "${uuid}"
+}
+
+_add_nvmet_allow_hosts() {
+	local nvmet_subsystem="$1"
+	local nvmet_hostnqn="$2"
+	local cfs_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
+	local host_path="${NVMET_CFS}/hosts/${nvmet_hostnqn}"
+
+	ln -s "${host_path}" "${cfs_path}/allowed_hosts/${nvmet_hostnqn}"
+}
+
+_create_nvmet_host() {
+	local nvmet_subsystem="$1"
+	local nvmet_hostnqn="$2"
+	local nvmet_hostkey="$3"
+	local nvmet_ctrlkey="$4"
+	local host_path="${NVMET_CFS}/hosts/${nvmet_hostnqn}"
+
+	if [[ -d "${host_path}" ]]; then
+		echo "FAIL target setup failed. stale host configuration found"
+		return 1;
+	fi
+
+	mkdir "${host_path}"
+	_add_nvmet_allow_hosts "${nvmet_subsystem}" "${nvmet_hostnqn}"
+	if [[ "${nvmet_hostkey}" ]] ; then
+		echo "${nvmet_hostkey}" > "${host_path}/dhchap_key"
+	fi
+	if [[ "${nvmet_ctrlkey}" ]] ; then
+		echo "${nvmet_ctrlkey}" > "${host_path}/dhchap_ctrl_key"
+	fi
+}
+
+_remove_nvmet_ns() {
+	local nvmet_subsystem="$1"
+	local nsid=$2
+	local subsys_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
+	local nvmet_ns_path="${subsys_path}/namespaces/${nsid}"
+
+	echo 0 > "${nvmet_ns_path}/enable"
+	rmdir "${nvmet_ns_path}"
+}
+
+_remove_nvmet_subsystem() {
+	local nvmet_subsystem="$1"
+	local subsys_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
+
+	_remove_nvmet_ns "${nvmet_subsystem}" "1"
+	rm -f "${subsys_path}"/allowed_hosts/*
+	rmdir "${subsys_path}"
+}
+
+_remove_nvmet_host() {
+	local nvmet_host="$1"
+	local host_path="${NVMET_CFS}/hosts/${nvmet_host}"
+
+	rmdir "${host_path}"
+}
+
+_add_nvmet_subsys_to_port() {
+	local port="$1"
+	local nvmet_subsystem="$2"
+
+	ln -s "${NVMET_CFS}/subsystems/${nvmet_subsystem}" \
+		"${NVMET_CFS}/ports/${port}/subsystems/${nvmet_subsystem}"
+}
+
+_remove_nvmet_subsystem_from_port() {
+	local port="$1"
+	local nvmet_subsystem="$2"
+
+	rm "${NVMET_CFS}/ports/${port}/subsystems/${nvmet_subsystem}"
+}
+
+_get_nvmet_ports() {
+	local nvmet_subsystem="$1"
+	local -n nvmet_ports="$2"
+	local cfs_path="${NVMET_CFS}/ports"
+	local sarg
+
+	sarg="s;^${cfs_path}/\([0-9]\+\)/subsystems/${nvmet_subsystem}$;\1;p"
+
+	for path in "${cfs_path}/"*"/subsystems/${nvmet_subsystem}"; do
+		nvmet_ports+=("$(echo "${path}" | sed -n -s "${sarg}")")
+	done
+}
+
+_find_nvme_dev() {
+	local subsys=$1
+	local subsysnqn
+	local dev
+	for dev in /sys/class/nvme/nvme*; do
+		[ -e "$dev" ] || continue
+		dev="$(basename "$dev")"
+		subsysnqn="$(cat "/sys/class/nvme/${dev}/subsysnqn" 2>/dev/null)"
+		if [[ "$subsysnqn" == "$subsys" ]]; then
+			echo "$dev"
+		fi
+	done
+}
+
+_find_nvme_ns() {
+	local subsys_uuid=$1
+	local uuid
+	local ns
+
+	for ns in "/sys/block/nvme"* ; do
+		# ignore nvme channel block devices
+		if ! [[ "${ns}" =~ nvme[0-9]+n[0-9]+ ]]; then
+			continue
+		fi
+		[ -e "${ns}/uuid" ] || continue
+		uuid=$(cat "${ns}/uuid")
+		if [[ "${subsys_uuid}" == "${uuid}" ]]; then
+			basename "${ns}"
+		fi
+	done
+}
+
+_nvmet_target_cleanup() {
+	local ports
+	local port
+	local blkdev
+	local subsysnqn="${def_subsysnqn}"
+	local blkdev_type=""
+
+	while [[ $# -gt 0 ]]; do
+		case $1 in
+			--blkdev)
+				blkdev_type="$2"
+				shift 2
+				;;
+			--subsysnqn)
+				subsysnqn="$2"
+				shift 2
+				;;
+			*)
+				echo "WARNING: unknown argument: $1"
+				shift
+				;;
+		esac
+	done
+
+	_get_nvmet_ports "${subsysnqn}" ports
+
+	for port in "${ports[@]}"; do
+		_remove_nvmet_subsystem_from_port "${port}" "${subsysnqn}"
+		_remove_nvmet_port "${port}"
+	done
+	_remove_nvmet_subsystem "${subsysnqn}"
+	_remove_nvmet_host "${def_hostnqn}"
+
+	if [[ "${blkdev_type}" == "device" ]]; then
+		_cleanup_blkdev
+	fi
+}
diff --git a/tests/nvme/rc b/tests/nvme/rc
index c1ddf41..dedc412 100644
--- a/tests/nvme/rc
+++ b/tests/nvme/rc
@@ -5,25 +5,9 @@
 # Test specific to NVMe devices
 
 . common/rc
+. common/nvme
 . common/multipath-over-rdma
 
-def_traddr="127.0.0.1"
-def_adrfam="ipv4"
-def_trsvcid="4420"
-def_remote_wwnn="0x10001100aa000001"
-def_remote_wwpn="0x20001100aa000001"
-def_local_wwnn="0x10001100aa000002"
-def_local_wwpn="0x20001100aa000002"
-def_hostid="0f01fb42-9f7f-4856-b0b3-51e60b8de349"
-def_hostnqn="nqn.2014-08.org.nvmexpress:uuid:${def_hostid}"
-export def_subsysnqn="blktests-subsystem-1"
-export def_subsys_uuid="91fdba0d-f87b-4c25-b80f-db7be1418b9e"
-_check_conflict_and_set_default NVMET_TRTYPES nvme_trtype "loop"
-_check_conflict_and_set_default NVME_IMG_SIZE nvme_img_size 1G
-_check_conflict_and_set_default NVME_NUM_ITER nvme_num_iter 1000
-nvmet_blkdev_type=${nvmet_blkdev_type:-"device"}
-NVMET_BLKDEV_TYPES=${NVMET_BLKDEV_TYPES:-"device file"}
-
 _NVMET_TRTYPES_is_valid() {
 	local type
 
@@ -70,12 +54,6 @@ _set_nvmet_blkdev_type() {
 	COND_DESC="bd=${nvmet_blkdev_type}"
 }
 
-# TMPDIR can not be referred out of test() or test_device() context. Instead of
-# global variable def_flie_path, use this getter function.
-_nvme_def_file_path() {
-	echo "${TMPDIR}/img"
-}
-
 _nvme_requires() {
 	_have_program nvme
 	_require_nvme_test_img_size 4m
@@ -144,8 +122,6 @@ group_device_requires() {
 	_require_test_dev_is_nvme
 }
 
-NVMET_CFS="/sys/kernel/config/nvmet/"
-
 _require_test_dev_is_nvme() {
 	if ! readlink -f "$TEST_DEV_SYSFS/device" | grep -q nvme; then
 		SKIP_REASONS+=("$TEST_DEV is not a NVMe device")
@@ -168,31 +144,6 @@ _require_nvme_test_img_size() {
 	return 0
 }
 
-_require_nvme_trtype() {
-	local trtype
-	for trtype in "$@"; do
-		if [[ "${nvme_trtype}" == "$trtype" ]]; then
-			return 0
-		fi
-	done
-	SKIP_REASONS+=("nvme_trtype=${nvme_trtype} is not supported in this test")
-	return 1
-}
-
-_require_nvme_trtype_is_loop() {
-	if ! _require_nvme_trtype loop; then
-		return 1
-	fi
-	return 0
-}
-
-_require_nvme_trtype_is_fabrics() {
-	if ! _require_nvme_trtype loop fc rdma tcp; then
-		return 1
-	fi
-	return 0
-}
-
 _require_nvme_cli_auth() {
 	if ! nvme gen-dhchap-key --nqn nvmf-test-subsys > /dev/null 2>&1 ; then
 		SKIP_REASONS+=("nvme gen-dhchap-key command missing")
@@ -235,371 +186,6 @@ _nvme_calc_rand_io_size() {
 	echo "${io_size_kb}k"
 }
 
-_nvme_fcloop_add_rport() {
-	local local_wwnn="$1"
-	local local_wwpn="$2"
-	local remote_wwnn="$3"
-	local remote_wwpn="$4"
-	local loopctl=/sys/class/fcloop/ctl
-
-	echo "wwnn=${remote_wwnn},wwpn=${remote_wwpn},lpwwnn=${local_wwnn},lpwwpn=${local_wwpn},roles=0x60" > ${loopctl}/add_remote_port
-}
-
-_nvme_fcloop_add_lport() {
-	local wwnn="$1"
-	local wwpn="$2"
-	local loopctl=/sys/class/fcloop/ctl
-
-	echo "wwnn=${wwnn},wwpn=${wwpn}" > ${loopctl}/add_local_port
-}
-
-_nvme_fcloop_add_tport() {
-	local wwnn="$1"
-	local wwpn="$2"
-	local loopctl=/sys/class/fcloop/ctl
-
-	echo "wwnn=${wwnn},wwpn=${wwpn}" > ${loopctl}/add_target_port
-}
-
-_setup_fcloop() {
-	local local_wwnn="${1:-$def_local_wwnn}"
-	local local_wwpn="${2:-$def_local_wwpn}"
-	local remote_wwnn="${3:-$def_remote_wwnn}"
-	local remote_wwpn="${4:-$def_remote_wwpn}"
-
-	_nvme_fcloop_add_tport "${remote_wwnn}" "${remote_wwpn}"
-	_nvme_fcloop_add_lport "${local_wwnn}" "${local_wwpn}"
-	_nvme_fcloop_add_rport "${local_wwnn}" "${local_wwpn}" \
-		               "${remote_wwnn}" "${remote_wwpn}"
-}
-
-_nvme_fcloop_del_rport() {
-	local local_wwnn="$1"
-	local local_wwpn="$2"
-	local remote_wwnn="$3"
-	local remote_wwpn="$4"
-	local loopctl=/sys/class/fcloop/ctl
-
-	if [[ ! -f "${loopctl}/del_remote_port" ]]; then
-		return
-	fi
-	echo "wwnn=${remote_wwnn},wwpn=${remote_wwpn}" > "${loopctl}/del_remote_port"
-}
-
-_nvme_fcloop_del_lport() {
-	local wwnn="$1"
-	local wwpn="$2"
-	local loopctl=/sys/class/fcloop/ctl
-
-	if [[ ! -f "${loopctl}/del_local_port" ]]; then
-		return
-	fi
-	echo "wwnn=${wwnn},wwpn=${wwpn}" > "${loopctl}/del_local_port"
-}
-
-_nvme_fcloop_del_tport() {
-	local wwnn="$1"
-	local wwpn="$2"
-	local loopctl=/sys/class/fcloop/ctl
-
-	if [[ ! -f "${loopctl}/del_target_port" ]]; then
-		return
-	fi
-	echo "wwnn=${wwnn},wwpn=${wwpn}" > "${loopctl}/del_target_port"
-}
-
-_cleanup_fcloop() {
-	local local_wwnn="${1:-$def_local_wwnn}"
-	local local_wwpn="${2:-$def_local_wwpn}"
-	local remote_wwnn="${3:-$def_remote_wwnn}"
-	local remote_wwpn="${4:-$def_remote_wwpn}"
-
-	_nvme_fcloop_del_tport "${remote_wwnn}" "${remote_wwpn}"
-	_nvme_fcloop_del_lport "${local_wwnn}" "${local_wwpn}"
-	_nvme_fcloop_del_rport "${local_wwnn}" "${local_wwpn}" \
-			       "${remote_wwnn}" "${remote_wwpn}"
-}
-
-_cleanup_blkdev() {
-	local blkdev
-	local dev
-
-	blkdev="$(losetup -l | awk '$6 == "'"$(_nvme_def_file_path)"'" { print $1 }')"
-	for dev in ${blkdev}; do
-		losetup -d "${dev}"
-	done
-	rm -f "$(_nvme_def_file_path)"
-}
-
-_cleanup_nvmet() {
-	local dev
-	local port
-	local subsys
-	local transport
-	local name
-
-	if [[ ! -d "${NVMET_CFS}" ]]; then
-		return 0
-	fi
-
-	# Don't let successive Ctrl-Cs interrupt the cleanup processes
-	trap '' SIGINT
-
-	shopt -s nullglob
-
-	for dev in /sys/class/nvme/nvme*; do
-		dev="$(basename "$dev")"
-		transport="$(cat "/sys/class/nvme/${dev}/transport" 2>/dev/null)"
-		if [[ "$transport" == "${nvme_trtype}" ]]; then
-			# if udev auto connect is enabled for FC we get false positives
-			if [[ "$transport" != "fc" ]]; then
-				echo "WARNING: Test did not clean up ${nvme_trtype} device: ${dev}"
-			fi
-			_nvme_disconnect_ctrl "${dev}" 2>/dev/null
-		fi
-	done
-
-	for port in "${NVMET_CFS}"/ports/*; do
-		name=$(basename "${port}")
-		echo "WARNING: Test did not clean up port: ${name}"
-		rm -f "${port}"/subsystems/*
-		rmdir "${port}"
-	done
-
-	for subsys in "${NVMET_CFS}"/subsystems/*; do
-		name=$(basename "${subsys}")
-		echo "WARNING: Test did not clean up subsystem: ${name}"
-		for ns in "${subsys}"/namespaces/*; do
-			rmdir "${ns}"
-		done
-		rmdir "${subsys}"
-	done
-
-	for host in "${NVMET_CFS}"/hosts/*; do
-		name=$(basename "${host}")
-		echo "WARNING: Test did not clean up host: ${name}"
-		rmdir "${host}"
-	done
-
-	shopt -u nullglob
-	trap SIGINT
-
-	if [[ "${nvme_trtype}" == "fc" ]]; then
-		_cleanup_fcloop "${def_local_wwnn}" "${def_local_wwpn}" \
-				"${def_remote_wwnn}" "${def_remote_wwpn}"
-		modprobe -rq nvme-fcloop 2>/dev/null
-	fi
-	modprobe -rq nvme-"${nvme_trtype}" 2>/dev/null
-	if [[ "${nvme_trtype}" != "loop" ]]; then
-		modprobe -rq nvmet-"${nvme_trtype}" 2>/dev/null
-	fi
-	modprobe -rq nvmet 2>/dev/null
-	if [[ "${nvme_trtype}" == "rdma" ]]; then
-		stop_soft_rdma
-	fi
-
-	_cleanup_blkdev
-}
-
-_setup_nvmet() {
-	_register_test_cleanup _cleanup_nvmet
-	modprobe -q nvmet
-	if [[ "${nvme_trtype}" != "loop" ]]; then
-		modprobe -q nvmet-"${nvme_trtype}"
-	fi
-	modprobe -q nvme-"${nvme_trtype}"
-	if [[ "${nvme_trtype}" == "rdma" ]]; then
-		start_soft_rdma
-		for i in $(rdma_network_interfaces)
-		do
-			if [[ "${nvme_adrfam}" == "ipv6" ]]; then
-				ipv6_addr=$(get_ipv6_ll_addr "$i")
-				if [[ -n "${ipv6_addr}" ]]; then
-					def_traddr=${ipv6_addr}
-				fi
-			else
-				ipv4_addr=$(get_ipv4_addr "$i")
-				if [[ -n "${ipv4_addr}" ]]; then
-					def_traddr=${ipv4_addr}
-				fi
-			fi
-		done
-	fi
-	if [[ "${nvme_trtype}" = "fc" ]]; then
-		modprobe -q nvme-fcloop
-		_setup_fcloop "${def_local_wwnn}" "${def_local_wwpn}" \
-			      "${def_remote_wwnn}" "${def_remote_wwpn}"
-
-		def_traddr=$(printf "nn-%s:pn-%s" \
-				    "${def_remote_wwnn}" \
-				    "${def_remote_wwpn}")
-		def_host_traddr=$(printf "nn-%s:pn-%s" \
-					 "${def_local_wwnn}" \
-					 "${def_local_wwpn}")
-	fi
-}
-
-_nvme_disconnect_ctrl() {
-	local ctrl="$1"
-
-	nvme disconnect --device "${ctrl}"
-}
-
-_nvme_disconnect_subsys() {
-	local subsysnqn="$def_subsysnqn"
-
-	while [[ $# -gt 0 ]]; do
-		case $1 in
-			--subsysnqn)
-				subsysnqn="$2"
-				shift 2
-				;;
-			*)
-				echo "WARNING: unknown argument: $1"
-				shift
-				;;
-		esac
-	done
-
-	nvme disconnect --nqn "${subsysnqn}" |& tee -a "$FULL" |
-		grep -o "disconnected.*"
-}
-
-_nvme_connect_subsys() {
-	local subsysnqn="$def_subsysnqn"
-	local hostnqn="$def_hostnqn"
-	local hostid="$def_hostid"
-	local hostkey=""
-	local ctrlkey=""
-	local nr_io_queues=""
-	local nr_write_queues=""
-	local nr_poll_queues=""
-	local keep_alive_tmo=""
-	local reconnect_delay=""
-	local ctrl_loss_tmo=""
-	local no_wait=false
-	local i
-
-	while [[ $# -gt 0 ]]; do
-		case $1 in
-			--subsysnqn)
-				subsysnqn="$2"
-				shift 2
-				;;
-			--hostnqn)
-				hostnqn="$2"
-				shift 2
-				;;
-			--hostid)
-				hostid="$2"
-				shift 2
-				;;
-			--dhchap-secret)
-				hostkey="$2"
-				shift 2
-				;;
-			--dhchap-ctrl-secret)
-				ctrlkey="$2"
-				shift 2
-				;;
-			--nr-io-queues)
-				nr_io_queues="$2"
-				shift 2
-				;;
-			--nr-write-queues)
-				nr_write_queues="$2"
-				shift 2
-				;;
-			--nr-poll-queues)
-				nr_poll_queues="$2"
-				shift 2
-				;;
-			--keep-alive-tmo)
-				keep_alive_tmo="$2"
-				shift 2
-				;;
-			--reconnect-delay)
-				reconnect_delay="$2"
-				shift 2
-				;;
-			--ctrl-loss-tmo)
-				ctrl_loss_tmo="$2"
-				shift 2
-				;;
-			--no-wait)
-				no_wait=true
-				shift 1
-				;;
-			*)
-				echo "WARNING: unknown argument: $1"
-				shift
-				;;
-		esac
-	done
-
-	ARGS=(--transport "${nvme_trtype}" --nqn "${subsysnqn}")
-	if [[ "${nvme_trtype}" == "fc" ]] ; then
-		ARGS+=(--traddr "${def_traddr}" --host-traddr "${def_host_traddr}")
-	elif [[ "${nvme_trtype}" != "loop" ]]; then
-		ARGS+=(--traddr "${def_traddr}" --trsvcid "${def_trsvcid}")
-	fi
-	ARGS+=(--hostnqn="${hostnqn}")
-	ARGS+=(--hostid="${hostid}")
-	if [[ -n "${hostkey}" ]]; then
-		ARGS+=(--dhchap-secret="${hostkey}")
-	fi
-	if [[ -n "${ctrlkey}" ]]; then
-		ARGS+=(--dhchap-ctrl-secret="${ctrlkey}")
-	fi
-	if [[ -n "${nr_io_queues}" ]]; then
-		ARGS+=(--nr-io-queues="${nr_io_queues}")
-	fi
-	if [[ -n "${nr_write_queues}" ]]; then
-		ARGS+=(--nr-write-queues="${nr_write_queues}")
-	fi
-	if [[ -n "${nr_poll_queues}" ]]; then
-		ARGS+=(--nr-poll-queues="${nr_poll_queues}")
-	fi
-	if [[ -n "${keep_alive_tmo}" ]]; then
-		ARGS+=(--keep-alive-tmo="${keep_alive_tmo}")
-	fi
-	if [[ -n "${reconnect_delay}" ]]; then
-		ARGS+=(--reconnect-delay="${reconnect_delay}")
-	fi
-	if [[ -n "${ctrl_loss_tmo}" ]]; then
-		ARGS+=(--ctrl-loss-tmo="${ctrl_loss_tmo}")
-	fi
-
-	nvme connect "${ARGS[@]}" 2> /dev/null | grep -v "connecting to device:"
-
-	# Wait until device file and uuid/wwid sysfs attributes get ready for
-	# all namespaces.
-	if [[ ${no_wait} = false ]]; then
-		udevadm settle
-		for ((i = 0; i < 10; i++)); do
-			_nvme_ns_ready "${subsysnqn}" && return
-			sleep .1
-		done
-	fi
-}
-
-_nvme_ns_ready() {
-	local subsysnqn="${1}"
-	local ns_path ns_id dev
-	local cfs_path="${NVMET_CFS}/subsystems/$subsysnqn"
-
-	dev=$(_find_nvme_dev "$subsysnqn")
-	for ns_path in "${cfs_path}/namespaces/"*; do
-		ns_id=${ns_path##*/}
-		if [[ ! -b /dev/${dev}n${ns_id} ||
-			   ! -e /sys/block/${dev}n${ns_id}/uuid ||
-			   ! -e /sys/block/${dev}n${ns_id}/wwid ]]; then
-			return 1
-		fi
-	done
-	return 0
-}
-
 _nvme_discover() {
 	local trtype="$1"
 	local traddr="${2:-$def_traddr}"
@@ -617,73 +203,6 @@ _nvme_discover() {
 	nvme discover "${ARGS[@]}"
 }
 
-_create_nvmet_port() {
-	local trtype="$1"
-	local traddr="${2:-$def_traddr}"
-	local adrfam="${3:-$def_adrfam}"
-	local trsvcid="${4:-$def_trsvcid}"
-
-	local port
-	for ((port = 0; ; port++)); do
-		if [[ ! -e "${NVMET_CFS}/ports/${port}" ]]; then
-			break
-		fi
-	done
-
-	mkdir "${NVMET_CFS}/ports/${port}"
-	echo "${trtype}" > "${NVMET_CFS}/ports/${port}/addr_trtype"
-	echo "${traddr}" > "${NVMET_CFS}/ports/${port}/addr_traddr"
-	echo "${adrfam}" > "${NVMET_CFS}/ports/${port}/addr_adrfam"
-	if [[ "${adrfam}" != "fc" ]]; then
-		echo "${trsvcid}" > "${NVMET_CFS}/ports/${port}/addr_trsvcid"
-	fi
-
-	echo "${port}"
-}
-
-_remove_nvmet_port() {
-	local port="$1"
-	rmdir "${NVMET_CFS}/ports/${port}"
-}
-
-_create_nvmet_ns() {
-	local nvmet_subsystem="$1"
-	local nsid="$2"
-	local blkdev="$3"
-	local uuid="00000000-0000-0000-0000-000000000000"
-	local subsys_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
-	local ns_path="${subsys_path}/namespaces/${nsid}"
-
-	if [[ $# -eq 4 ]]; then
-		uuid="$4"
-	fi
-
-	mkdir "${ns_path}"
-	printf "%s" "${blkdev}" > "${ns_path}/device_path"
-	printf "%s" "${uuid}" > "${ns_path}/device_uuid"
-	printf 1 > "${ns_path}/enable"
-}
-
-_create_nvmet_subsystem() {
-	local nvmet_subsystem="$1"
-	local blkdev="$2"
-	local uuid=$3
-	local cfs_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
-
-	mkdir -p "${cfs_path}"
-	echo 0 > "${cfs_path}/attr_allow_any_host"
-	_create_nvmet_ns "${nvmet_subsystem}" "1" "${blkdev}" "${uuid}"
-}
-
-_add_nvmet_allow_hosts() {
-	local nvmet_subsystem="$1"
-	local nvmet_hostnqn="$2"
-	local cfs_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
-	local host_path="${NVMET_CFS}/hosts/${nvmet_hostnqn}"
-
-	ln -s "${host_path}" "${cfs_path}/allowed_hosts/${nvmet_hostnqn}"
-}
-
 _remove_nvmet_allow_hosts() {
 	local nvmet_subsystem="$1"
 	local nvmet_hostnqn="$2"
@@ -692,54 +211,6 @@ _remove_nvmet_allow_hosts() {
 	rm "${cfs_path}/allowed_hosts/${nvmet_hostnqn}"
 }
 
-_create_nvmet_host() {
-	local nvmet_subsystem="$1"
-	local nvmet_hostnqn="$2"
-	local nvmet_hostkey="$3"
-	local nvmet_ctrlkey="$4"
-	local host_path="${NVMET_CFS}/hosts/${nvmet_hostnqn}"
-
-	if [[ -d "${host_path}" ]]; then
-		echo "FAIL target setup failed. stale host configuration found"
-		return 1;
-	fi
-
-	mkdir "${host_path}"
-	_add_nvmet_allow_hosts "${nvmet_subsystem}" "${nvmet_hostnqn}"
-	if [[ "${nvmet_hostkey}" ]] ; then
-		echo "${nvmet_hostkey}" > "${host_path}/dhchap_key"
-	fi
-	if [[ "${nvmet_ctrlkey}" ]] ; then
-		echo "${nvmet_ctrlkey}" > "${host_path}/dhchap_ctrl_key"
-	fi
-}
-
-_remove_nvmet_ns() {
-	local nvmet_subsystem="$1"
-	local nsid=$2
-	local subsys_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
-	local nvmet_ns_path="${subsys_path}/namespaces/${nsid}"
-
-	echo 0 > "${nvmet_ns_path}/enable"
-	rmdir "${nvmet_ns_path}"
-}
-
-_remove_nvmet_subsystem() {
-	local nvmet_subsystem="$1"
-	local subsys_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
-
-	_remove_nvmet_ns "${nvmet_subsystem}" "1"
-	rm -f "${subsys_path}"/allowed_hosts/*
-	rmdir "${subsys_path}"
-}
-
-_remove_nvmet_host() {
-	local nvmet_host="$1"
-	local host_path="${NVMET_CFS}/hosts/${nvmet_host}"
-
-	rmdir "${host_path}"
-}
-
 _create_nvmet_passthru() {
 	local nvmet_subsystem="$1"
 	local subsys_path="${NVMET_CFS}/subsystems/${nvmet_subsystem}"
@@ -765,34 +236,6 @@ _remove_nvmet_passhtru() {
 	rmdir "${subsys_path}"
 }
 
-_add_nvmet_subsys_to_port() {
-	local port="$1"
-	local nvmet_subsystem="$2"
-
-	ln -s "${NVMET_CFS}/subsystems/${nvmet_subsystem}" \
-		"${NVMET_CFS}/ports/${port}/subsystems/${nvmet_subsystem}"
-}
-
-_remove_nvmet_subsystem_from_port() {
-	local port="$1"
-	local nvmet_subsystem="$2"
-
-	rm "${NVMET_CFS}/ports/${port}/subsystems/${nvmet_subsystem}"
-}
-
-_get_nvmet_ports() {
-	local nvmet_subsystem="$1"
-	local -n nvmet_ports="$2"
-	local cfs_path="${NVMET_CFS}/ports"
-	local sarg
-
-	sarg="s;^${cfs_path}/\([0-9]\+\)/subsystems/${nvmet_subsystem}$;\1;p"
-
-	for path in "${cfs_path}/"*"/subsystems/${nvmet_subsystem}"; do
-		nvmet_ports+=("$(echo "${path}" | sed -n -s "${sarg}")")
-	done
-}
-
 _set_nvmet_hostkey() {
 	local nvmet_hostnqn="$1"
 	local nvmet_hostkey="$2"
@@ -829,38 +272,6 @@ _set_nvmet_dhgroup() {
 	     "${cfs_path}/dhchap_dhgroup"
 }
 
-_find_nvme_dev() {
-	local subsys=$1
-	local subsysnqn
-	local dev
-	for dev in /sys/class/nvme/nvme*; do
-		[ -e "$dev" ] || continue
-		dev="$(basename "$dev")"
-		subsysnqn="$(cat "/sys/class/nvme/${dev}/subsysnqn" 2>/dev/null)"
-		if [[ "$subsysnqn" == "$subsys" ]]; then
-			echo "$dev"
-		fi
-	done
-}
-
-_find_nvme_ns() {
-	local subsys_uuid=$1
-	local uuid
-	local ns
-
-	for ns in "/sys/block/nvme"* ; do
-		# ignore nvme channel block devices
-		if ! [[ "${ns}" =~ nvme[0-9]+n[0-9]+ ]]; then
-			continue
-		fi
-		[ -e "${ns}/uuid" ] || continue
-		uuid=$(cat "${ns}/uuid")
-		if [[ "${subsys_uuid}" == "${uuid}" ]]; then
-			basename "${ns}"
-		fi
-	done
-}
-
 _find_nvme_passthru_loop_dev() {
 	local subsys=$1
 	local nsid
@@ -924,44 +335,6 @@ _nvmet_target_setup() {
 			"${hostkey}" "${ctrlkey}"
 }
 
-_nvmet_target_cleanup() {
-	local ports
-	local port
-	local blkdev
-	local subsysnqn="${def_subsysnqn}"
-	local blkdev_type=""
-
-	while [[ $# -gt 0 ]]; do
-		case $1 in
-			--blkdev)
-				blkdev_type="$2"
-				shift 2
-				;;
-			--subsysnqn)
-				subsysnqn="$2"
-				shift 2
-				;;
-			*)
-				echo "WARNING: unknown argument: $1"
-				shift
-				;;
-		esac
-	done
-
-	_get_nvmet_ports "${subsysnqn}" ports
-
-	for port in "${ports[@]}"; do
-		_remove_nvmet_subsystem_from_port "${port}" "${subsysnqn}"
-		_remove_nvmet_port "${port}"
-	done
-	_remove_nvmet_subsystem "${subsysnqn}"
-	_remove_nvmet_host "${def_hostnqn}"
-
-	if [[ "${blkdev_type}" == "device" ]]; then
-		_cleanup_blkdev
-	fi
-}
-
 _nvmet_passthru_target_setup() {
 	local subsysnqn="$def_subsysnqn"
 	local port
-- 
2.45.1

