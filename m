Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021099.outbound.protection.outlook.com [52.101.70.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337C78F49;
	Sun, 21 Jul 2024 07:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721545900; cv=fail; b=AjK3sTXSSYP5FJG6iyTZkMkulMRXpIkGzEtJEh5lORpm7mQQk4q/vKj9q+6fuEwvEL5qy+omr++X0NjsPPYMoz+ZpdkEJ8QvgvOUsMAG/FHCqjWd7pVwLCkuyDIzT40+cIDgf9Puv+QcnsWKURL9o2bg4gTCPhnrpH6wQO+7gd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721545900; c=relaxed/simple;
	bh=R30uGWDbiN/6xdPDK4lH7RRivhN0t4RZfQ358R5HF5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E2cznj5oH7mRrZiknE5Trz3+FmUHEUiH8JhHjvpkqhiUS1wCgMPAMYaf08xle48pba36fDFCWvCFFSSYYSuYhcYw/dKLrB7vrOjEix68dZCKyd95cYd4jvJadbHLGOwK3WVjajiq86WTOzSCEWYVYh4+/3q21CMHmBe61WLTNVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=KY36qKpx; arc=fail smtp.client-ip=52.101.70.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="KY36qKpx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7eAlrgyGQx7lv2ByI+x4k+sMYM+ChtKVfci1RekOAgVh+xm//2Q/7G3g1+9eoEZ5bN9AF11GADuNJ4d5X79St1y3lXNHcI+0GORVR4FYOPBKJLE1ljXw2ywgc4ohMk4qW7ORZRzrLp8d5m4t+9L0SPVakwMdybFxm/p8uVu28VeLszbglFIXqHD9Cri5kdfJHxENnhFBtfuXVN4dGb375wq0Qf5FXijSsywe/eULUkdVTaViHHvT07ESu8skL73mxwRzhrn10WAJOmd+VMe8gi8a34eS1cWnLSfitKHZJyQtKojf8yLjkicMrCl82PJ0adcHlAzMZmrIVkKQgpPMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUgBbRGHAOSJIAqnSzg+pTbI1iBndbNDJuzMEZjuuUY=;
 b=Hi/k3nyF644Y8nQy+tuFlAH1rKsIoeFqLMjCL9uVnyxRlituFYYb+rqnCqeBkZQxTBUj6aVuTXw2Yl2T9gT5uG4Z1LRAvVOl2sE2wYCYDbw1BEzYBVhg/xL4+6ywBrMHPEPjZ1m3ZI4TOOGvwmvJNyq9GiRRT7jajMZNevpKaIqihQ08AWw2UZuuFQdrL+x082uSVQICj5CvgjGT0MqLraHGuv9+RSgeKYVw4f7w8O/QnE8TkIdWt4JSCwV34yLdNdWfaZtmufJ6EK5QS5LQgjYIMZ3Z878oC7CyLG3fb4NbW9dqJPTZi0N56NtEyXx9aymaYja4xpeSaCb+8LrCNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUgBbRGHAOSJIAqnSzg+pTbI1iBndbNDJuzMEZjuuUY=;
 b=KY36qKpxBgQiZ3k/H8kliZGKeKW8suJbRBKpuOs89CVNpq50ZRWJd5KyHj0o6StcAC2Iy0XEQDecJzg9BQGDS9H/ODSOTN5AFh76B9+w5b6bGyKoItnffIrgug6cxRlVs/+JJQaaW2HYL+jhwjE8Xo8cGv4MeqCn0N8B/aXeYsPKpR7vFSeuUq8hPmFZn4AYXQRoA6bYH+2+wgHHZYbIPbDYaSm/Ee/QeNCBaDfr/xjagEoSxmlnW0H9kQEeHLTZfAP4ExnOQJALAgk1z3poQXROfVNoSm3vpMuOvKTQRcU1crUEat6dkPiEIVbawUQc/XWdtZQOu/O0NP+MOKicOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by GV1PR04MB10396.eurprd04.prod.outlook.com (2603:10a6:150:1c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Sun, 21 Jul
 2024 07:11:32 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7784.016; Sun, 21 Jul 2024
 07:11:32 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	dwagner@suse.de,
	chaitanyak@nvidia.com,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org
Subject: [PATCH blktests v4 2/2] md: add regression test for "md/md-bitmap: fix writing non bitmap pages"
Date: Sun, 21 Jul 2024 10:11:19 +0300
Message-ID: <20240721071121.1929422-3-ofir.gal@volumez.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4095965e-74ae-4130-5541-08dca954596a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?slOjM+Nv/DK12+ld3Df4znDyMJ0276H1PUNNohj+BLrvHHn+ye22473aJ0Ie?=
 =?us-ascii?Q?mhHQ9eL4Ubx+VsJ82exHCSFLRlBCEsKDmo5aKcRvKIXqEG34OlyiOpmhbeag?=
 =?us-ascii?Q?kv5GviqlkGkAt8elTHgaIdnTdBK4R+CY69AqqQAztsNrgyoOd3TCZmC0IWOb?=
 =?us-ascii?Q?2+4oFwhqEQ8o9/Yc0Du8aqbpXY3n9z6o/Q4RC2xLfgziTf97+f+RdETBMry4?=
 =?us-ascii?Q?MBbZnD5ykk/5UiHD8eZlu7zv2FL2LrYorhBtaD8IZN873/VR9aXCa9Yky1FW?=
 =?us-ascii?Q?7UumQ4DjxSKYukHs4iOnRDCNKlPEO8djv5mTmc2rw+Z/puQ7ly8e6yQm2ct0?=
 =?us-ascii?Q?GU0wowKlTzYTwuMlhCGC+d82sYyA31VJiaW/lzmBIspqu7Sz/uS2yesUve0h?=
 =?us-ascii?Q?sltYnL8L2a3JIvbHRlxTDkdT8dxftYBMtA+XgB8mFGS1QcqhaYAAJ892V/ij?=
 =?us-ascii?Q?oBxIBItKBOmmpNHQRs9A4Zb1jpaynNr24TsoM+b6ZumuhjVMYBqx9agVFwh6?=
 =?us-ascii?Q?xFXCT9bKfZnPq8jeFtkFb6fkFgUK0537h4T+zThXDtAULzJwKFs+2AmNmBIS?=
 =?us-ascii?Q?wbzuK4/JrutbSEQyMmM97bXFgRwpiHEh7VK7Ay4BnwNoSpjrPqGach9DFyf2?=
 =?us-ascii?Q?zgbb5vac0mTxJ1gx9ZKlrkAeHNVcMVwv4pCPv/dzI0X0VBbXaeqRgUqrMiqW?=
 =?us-ascii?Q?OaVLn0RT1c4sbJFiM8vaTqAo50DLGNpnBtjdHHuDo2ap9wyGmqjDh8dOiq8s?=
 =?us-ascii?Q?+b2OVoIfr55kQUw+jASosGgGzOvLc5x5hq2P48fW3k3L1Gtjjrzm7QV4Wvtq?=
 =?us-ascii?Q?i3rmaGIby2zbzOty2VycXs06bmzgxU7YI7zCtPNBOZlAz1iPaLgmPIEwF7vs?=
 =?us-ascii?Q?+9gaEYYvOjTpu8WkepI4U8jbZgdhgcFWB+816vG/pLdGUkPgJHW4Ztmj7FZT?=
 =?us-ascii?Q?zi4L/aJPhNNUUqWtMJ1V/0y72IxkJkHwcADcy7sITGFp0g/0PcqrEBRT3XgX?=
 =?us-ascii?Q?dUh7fxiuSbQqfTdCVpfg1WoiRR8MTudrVfsvC9aiyz/NvuvrUjy8Y6GBvIsn?=
 =?us-ascii?Q?ZOLfxUxRzP+OWpX6S6MK8IygZUa/3CKcNQNqKNs71bE6mx78JKfC72sAn391?=
 =?us-ascii?Q?htBkpdgRSZLEMF/AvqX0hWMyAlRshkSJv/LSU2QU3NuJ28DCgs59aLGN9KXi?=
 =?us-ascii?Q?YFQKdJG4YOBjE8FCi9nA9Sdn7U6wdcBPR5a1SqI5O06ToeN7VELcDfmtIGpg?=
 =?us-ascii?Q?uFgArtiKg5iOzStLUZLc79W2Pt1Fzepa/mCZMeIWdtpoi708PEwpIy8BzRfi?=
 =?us-ascii?Q?e4YYleAp3In4dbqeiTIjMsOSIaiZjxhXPwHmFTeZwtbLE4RJBGYYgiNmK1Vz?=
 =?us-ascii?Q?mRV4yaFBxFBUyYoerKuCDMZhHvzF2Sm+WmcXWdTXn2HmVWAcTw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hQj1K5ZVqgKz2aeOLkzUO4SwRwK74SenJl2DJ34qvR7+qBypWQMNG2L821Ir?=
 =?us-ascii?Q?EtcrkWrxxprsVupJ3q83Mc3yTm+9Eu/5+OigJgdweP29qXBpYQyTpGYlG2MW?=
 =?us-ascii?Q?IREHxKTCOyvfIioo5toUMHe0BvS84jXNWiUCmFKp8KCkR6GJjdityg93/Wla?=
 =?us-ascii?Q?fEl68vWdnyuOpv314K+bybVWM3NyYG7vrm5OaIEVZuvMZrv2CGrURf3v1xzX?=
 =?us-ascii?Q?sniXcqU61Rez2BPeCrZiwEf6BXMZNvbLHvRjsbwKPAkEvu1oNHMgHDyiWa/K?=
 =?us-ascii?Q?MuNO9usO8okJPb4bPTCs32Qq0y/vAGAsM0z4vmWx7khfFUcpD2boG3pi4yQW?=
 =?us-ascii?Q?riIi6+UTCp4XUViikjf0uaSom6LXCAV0FFygaM5LhUyxrYlLQtJIWZ9/uGDg?=
 =?us-ascii?Q?fIsilH7S+6yiW1y01sv4kfOzfYyAL0pYmhmfB0gNb8lo/Q7pO4QM1o+AmcrF?=
 =?us-ascii?Q?f9oDLttLCuZb6rw7BRauhrCUK2MK6Lwa8L0b2R3UqOe0ktKl+e++7vYXYGgc?=
 =?us-ascii?Q?FiRroHTl2/3lprSOqhq1ZV0WFjI/Hg306op0fAckyDjWz8ogPKlArFChBR30?=
 =?us-ascii?Q?DyCSwnAWg4WQxUHV0FQ3lyqgBeP/paDQmQhg1p6p33MiBPQ6iXjV6y55ctVX?=
 =?us-ascii?Q?Xnm0yZJcCfSo8W77EGQoHxKWIivq7lLaY66UbozCYrABh/NH79/KnUgkRgWQ?=
 =?us-ascii?Q?3oBzQu7/67KUgZVyUwr6PwOsrgShA+EDYgD7aW1RKSwF4EZS+V4tvoy8u8eW?=
 =?us-ascii?Q?b4od3T7uy4cRyR1WRFbG0b8jlLq5zw3J9QpMZ3wGc0SsU0h9/LWjdFmyMvHL?=
 =?us-ascii?Q?7QXAaPEYdRarXW+aBaA2ZTsMaTFAfMqRU0m46MD3jTkUsASR8FYorhxvoyqg?=
 =?us-ascii?Q?7Hcf1sp4+LRtA3biU2FYBQibhTLFCc+qEMNlCuqvhGXCpMPdHqiLHijJkVsL?=
 =?us-ascii?Q?DGotFztZqBPvNOebzrz3A4pcRCgZLqTs/WTNPFucNCwKjqskO2tqMcYIf23f?=
 =?us-ascii?Q?+drE+fACNuO0EY27iH3CRt1Sdw6X/BXCVwWR5HMY5lNTL7av1yLQC8ADSg5v?=
 =?us-ascii?Q?7mKXUHH5NFAqwnhMuj/YBSZET8DrbrpoRAMKZaeJQziDA7D4wE5TWe8WRkrS?=
 =?us-ascii?Q?vphfnRRut4mphLxsuiqpXLWgBU3velY43fZqlKrQnOcWMfHoLMQjpHVY4r/R?=
 =?us-ascii?Q?g33eXBeKSmVh+PIwOKt40WzRQg7a0tsXaTZeqdV/FU66oMos0ZQY1jbNPX9V?=
 =?us-ascii?Q?Mr//CShQS8tXxoMTNJctGzr7j9M5AbSHzmyMJrf6+4A00FaxbzDPv30X0D0Q?=
 =?us-ascii?Q?NJc03fU6nNj61rolNqXd+h1UMqBV1ByxCGHAWfqjjhAsLL5yxIT7cpxiwpvB?=
 =?us-ascii?Q?sRDcaEHv3CO2RmisV8GncbCiuDo1vY9FIoJrIgQuREjhbjQgIHQKt0Ahs7Vm?=
 =?us-ascii?Q?CdHo1suPkQl2SOWwJsKsThc8Upebt76FYPSKVLvwgXUxDvfJtGB5n1J+ibbm?=
 =?us-ascii?Q?d+ZzMkoUwYPy3DeVu/CBU4H/6BjfqWqO4EPkKMlJuXpbfffghPcyGFqDyMK2?=
 =?us-ascii?Q?eyiiXcX6kRA58U1l50rzk4HQwGJTTG7KmwNSHDVd?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4095965e-74ae-4130-5541-08dca954596a
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2024 07:11:32.3466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26rvio7oJ3uM56JhQoD1CGstk4oR5F2CsdM+i99VShUhRS4wBOY1IyuaF+VMt/B6DIe0yb69UCv1vgqPUtw9eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB10396

A bug in md-bitmap has been discovered by setting up a md raid on top of
nvme-tcp devices that has optimal io size larger than the allocated
bitmap.

The following test reproduce the bug by setting up a md-raid on top of
nvme-tcp device over ram device that sets the optimal io size by using
dm-stripe.

Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 common/brd       | 28 ++++++++++++++++
 tests/md/001     | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/md/001.out |  3 ++
 tests/md/rc      | 13 ++++++++
 4 files changed, 130 insertions(+)
 create mode 100644 common/brd
 create mode 100755 tests/md/001
 create mode 100644 tests/md/001.out
 create mode 100644 tests/md/rc

diff --git a/common/brd b/common/brd
new file mode 100644
index 0000000..31e964f
--- /dev/null
+++ b/common/brd
@@ -0,0 +1,28 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2024 Ofir Gal
+#
+# brd helper functions
+
+. common/shellcheck
+
+_have_brd() {
+	_have_module brd
+}
+
+_init_brd() {
+	# _have_brd loads brd, we need to wait a bit for brd to be not in use in
+	# order to reload it
+	sleep 0.2
+
+	if ! modprobe -r brd || ! modprobe brd "$@" ; then
+		echo "failed to reload brd with args: $*"
+		return 1
+	fi
+
+	return 0
+}
+
+_cleanup_brd() {
+	modprobe -r brd
+}
diff --git a/tests/md/001 b/tests/md/001
new file mode 100755
index 0000000..5c8c59a
--- /dev/null
+++ b/tests/md/001
@@ -0,0 +1,86 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2024 Ofir Gal
+#
+# The bug is "visible" only when the underlying device of the raid is a network
+# block device that utilize MSG_SPLICE_PAGES. nvme-tcp is used as the network device.
+#
+# Regression test for patch "md/md-bitmap: fix writing non bitmap pages" and
+# for patch "nvme-tcp: use sendpages_ok() instead of sendpage_ok()"
+
+. tests/md/rc
+. common/brd
+. common/nvme
+
+DESCRIPTION="Raid with bitmap on tcp nvmet with opt-io-size over bitmap size"
+QUICK=1
+
+#restrict test to nvme-tcp only
+nvme_trtype=tcp
+nvmet_blkdev_type="device"
+
+requires() {
+	# Require dm-stripe
+	_have_program dmsetup
+	_have_driver dm-mod
+	_have_driver raid1
+
+	_require_nvme_trtype tcp
+	_have_brd
+}
+
+# Sets up a brd device of 1G with optimal-io-size of 256K
+setup_underlying_device() {
+	if ! _init_brd rd_size=1048576 rd_nr=1; then
+		return 1
+	fi
+
+	dmsetup create ram0_big_optio --table \
+		"0 $(blockdev --getsz /dev/ram0) striped 1 512 /dev/ram0 0"
+}
+
+cleanup_underlying_device() {
+	dmsetup remove ram0_big_optio
+	_cleanup_brd
+}
+
+# Sets up a local host nvme over tcp
+setup_nvme_over_tcp() {
+	_setup_nvmet
+
+	local port
+	port="$(_create_nvmet_port "${nvme_trtype}")"
+
+	_create_nvmet_subsystem "${def_subsysnqn}" "/dev/mapper/ram0_big_optio" "${def_subsys_uuid}"
+	_add_nvmet_subsys_to_port "${port}" "${def_subsysnqn}"
+
+	_create_nvmet_host "${def_subsysnqn}" "${def_hostnqn}"
+
+	_nvme_connect_subsys
+}
+
+cleanup_nvme_over_tcp() {
+	_nvme_disconnect_subsys
+	_nvmet_target_cleanup --subsysnqn "${def_subsysnqn}"
+}
+
+test() {
+	echo "Running ${TEST_NAME}"
+
+	setup_underlying_device
+	setup_nvme_over_tcp
+
+	local ns
+	ns=$(_find_nvme_ns "${def_subsys_uuid}")
+
+	# Hangs here without the fix
+	mdadm --quiet --create /dev/md/blktests_md --level=1 --bitmap=internal \
+		--bitmap-chunk=1024K --assume-clean --run --raid-devices=2 \
+		/dev/"${ns}" missing
+
+	mdadm --quiet --stop /dev/md/blktests_md
+	cleanup_nvme_over_tcp
+	cleanup_underlying_device
+
+	echo "Test complete"
+}
diff --git a/tests/md/001.out b/tests/md/001.out
new file mode 100644
index 0000000..23071ec
--- /dev/null
+++ b/tests/md/001.out
@@ -0,0 +1,3 @@
+Running md/001
+disconnected 1 controller(s)
+Test complete
diff --git a/tests/md/rc b/tests/md/rc
new file mode 100644
index 0000000..96bcd97
--- /dev/null
+++ b/tests/md/rc
@@ -0,0 +1,13 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2024 Ofir Gal
+#
+# Tests for md raid
+
+. common/rc
+
+group_requires() {
+	_have_root
+	_have_program mdadm
+	_have_driver md-mod
+}
-- 
2.45.1

