Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021099.outbound.protection.outlook.com [52.101.70.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE368F40;
	Sun, 21 Jul 2024 07:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721545894; cv=fail; b=XzvrYfNqaZF6amGb804L7MI5px+Nteaviu67WGyC5HbEwPbvoTJIJcKnNiE2TG9m/A+Q0qeTUga8hoMROnrVywjUhqgIWVtPhr9KWVVb9vjp3ibEZk7eLkR0EHLRXKNwrtf2Ss64Q+cRpGgZTj3qGHcdJcVNC+OyNym8RJqWxMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721545894; c=relaxed/simple;
	bh=Y9AKiNrwG0a54HqbIHXPXENVxkj0mFEiHr4pVuJ9y7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=EiUI1QZWSOe/jZiJGXQVP9YZ7RZ084MKwkzN6A7Unyb3j0sQor/P45Vt23mmIy+5whK3/Ump4KRtzcKz1mHN+XnluKJ5FsNEbkot9bT6fBZp3/nyNUi/p4K3kcvdWzb9JJH/iHBxL0yEbXFdc08N+5CV+aCltFhprncZ6L+hSfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=GSiYVuIl; arc=fail smtp.client-ip=52.101.70.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="GSiYVuIl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJPBfbLRk25iCWz0BUZgiGSNDqwDRMkzwpErwMQ0lNbi7pbaypDb++jPBMNJbGD+iTLwVYXwynSG4l+MbeUtNDQqhWt/0f/K3YXMepqtYzEGFpWNeL94RYy6FeBVSRgoBRmycBEI69VSGcMFB8xNcyzmBhNSGZN1u7q8xoX02vL15XP7cLeaUHjv38rovO0sGmX9HdfbneVcW9vsYUYDFbusXo5YWMoeqOXULbBuFJVL+m/kCB7a9gMdeGizZ6UYFNKHzhPOVdypR79GM2fLYDziybwTi8T1LRwqVAmNnZz32Tt3oGP5gx7nquAOWeUCexJI8++Wzu4+klygDo6Vog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWkUin3MBo05zB/7BGFBkJsB5mS/XHmIt1+8ibWfoQE=;
 b=tUD5XPe7clFWrPs21TD/GrJVl51tOeri6B45JAdcG/2EfjaWMThcjiMyQIug8HCIeIW8/lGXrhWauZuv7dHWX+J+/92oH8M1vi9fjpo9nvnswdK/tMzEWwYuONnyLyJPDP8oP91buN49fMKzQPwBZmN0zOdMORWXgrtg50GYU3Oy3/INwEkkZ4AJS2z3lmbuVM5tS6204ICo1Jhbaa75Rvs8uq52itJU2BhTa2xnFBQ/MN5cE7jJVHlq2ri+Yqx3WvTh6yLbhP+r+VQBDtcPg2Rl+5JRqv26IPeQsze6yRZcDozt7BfK1NUBavB9n4ZjOBvykIqjd8lHJW/BbPKU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWkUin3MBo05zB/7BGFBkJsB5mS/XHmIt1+8ibWfoQE=;
 b=GSiYVuIlY27kqTcj/kKBOc7s517NDt3PWhOv/KSppzwLGOwZnjNi7L5ItFgPlWfTCJhWr+97h/LFcwuVfp1oWAHa3ZjteC+4buPiF/bw7iEFNm1P1HwlSPnNFi8JIulhf+2B72kUSUtBGgv/SXcMItQWhWx+Uhzqk7c6CKpISixk6ZzFoMwS8vur4n6P5IErZ6kTK2DXE/5/7BmboxrZePiOfg8Zjrv57JGeVTzF1QL4bDxvB6949txY1q6Ho7vc/UZwuZKNN+qAA590bIMefJos6pfevJeQUGgYfUsYnkoOe55j9n+CQpTu6zMF2pxxn3C0pchpt8TqH7DQQO4/6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by GV1PR04MB10396.eurprd04.prod.outlook.com (2603:10a6:150:1c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Sun, 21 Jul
 2024 07:11:30 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7784.016; Sun, 21 Jul 2024
 07:11:30 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	dwagner@suse.de,
	chaitanyak@nvidia.com,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org
Subject: [PATCH blktests v4 0/2]md: add regression test for "md/md-bitmap: fix writing non bitmap pages"
Date: Sun, 21 Jul 2024 10:11:17 +0300
Message-ID: <20240721071121.1929422-1-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
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
X-MS-Office365-Filtering-Correlation-Id: 19c9cbda-61ad-43d7-6d78-08dca9545853
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LhSljcUhSzsD4XHvwW7lbfpHv3SOomHdXE+7R57ZA04fCqOXaq9VW1vl/BC2?=
 =?us-ascii?Q?K9mzSo2lf6gQjvzMeomCjD/Vge3aCpQwPxXpdw7NHJ0DS64bSTQLcGmU4MSh?=
 =?us-ascii?Q?Ucis1WjWoqAAWRZ+mfOm7cH1ACVwrIprsaHbeGzr5c1QvP+F+vC9mfHDzlEt?=
 =?us-ascii?Q?T1EiSnfmLP3TgbVU1cIgxfHYUs/HjSvV3d72vyAbtJbSQRcn1/Bv31hyE1ig?=
 =?us-ascii?Q?8V2pFM1Ekl9j2hGGXOOyslngx9FhKSQOPFCCdzqggqJQ5eeABQ8nLVD8ddPp?=
 =?us-ascii?Q?JGW9e63PhQIzxfr6m+JHJn68pyY+tP84HAHzKF83K6GNKmKyFYzPf6xb7Xno?=
 =?us-ascii?Q?qjUdxKGBsD1CvWyDvDLFBewj67OZW8Y+StkKtUf3nJcIx2tnRqqVQtibI0X6?=
 =?us-ascii?Q?OW34ykMgzFveGRTtA+5bYcYVaJnKIu4LM08xq93MIVJeUWJ2C+3NUJ044VQw?=
 =?us-ascii?Q?zWnv/yfC9Nr6WRjWx1crjiE5EnUi27V5UaqdPckRGktbNzuGg76zn8GsImKW?=
 =?us-ascii?Q?uocS1hQ7JZZDymgsAEMpQVetqkVPPDLYx4QGsUsVthW9Qt3qWDwGV0whAJew?=
 =?us-ascii?Q?OUtd0nIDpWaFxEUqA2Lg5zVU6mS1UABlzhDggoXndiIWbDA/ZsCq251gE9b2?=
 =?us-ascii?Q?Cc2XZD2jCPdKzfSuVQL0Y8XF1jSiriuWbeBIcZzPzbb5sfVUHPysJBf7R39H?=
 =?us-ascii?Q?BfyX5nWtlFnNGhvjg0Z1l3+zc9cIrnCOV9U2wntwybXgKNNM558OvxEMv63l?=
 =?us-ascii?Q?vFnL/TufRWpG++/o7Nrq+PbencZprO3EunjavpseMT02IjK6W/tDN7YsMXvR?=
 =?us-ascii?Q?MLri0nXrQpFwSW7hmFHYMqG8TWZZjm9s73wDq6pper6ZwaqK6GL54aiVFS7R?=
 =?us-ascii?Q?nIQJoQZz7bQnwzHcb9lSJgRgQbcEUrDXec09ZF82kbHZOWT1S3DqbcF7acid?=
 =?us-ascii?Q?Nj1o4dxmjLeNu834GYfZj0YHS74LQkefjlus67S+B3XdtV2H2nGoYB0cJTKA?=
 =?us-ascii?Q?mbZSjlUnt8HvSUa8LIlIoyiP24DQuiAupvq5G603QvSYQJ0Uoc6u8DriAZdE?=
 =?us-ascii?Q?QDU1SduMFFJTWV5QpVR1D3W09Z8SxWkGZxw7GkoawBgNdXUEb3BcxF4HlaCO?=
 =?us-ascii?Q?KmDGkGIVY6KqSIYfidE1HfTSIACeiV6zRRT1lxE/zMBLA87rt7O4NjtKJI7k?=
 =?us-ascii?Q?PoB/L6aXBpMBZMSJTF6gV/n0RYjmJ+PMicDOSIPwHXG7ruB9mQDRp2GSELoI?=
 =?us-ascii?Q?DmINRqVaefELMJnAfDI+A2kh0p3FKdHHVjLhQDetrJ4g1ydyV7LG6rQN339d?=
 =?us-ascii?Q?W4D+YbYA9CBv2Y3FDwsaMyeG8AXnrNhZWdXkrSzEel1LDdTGh6XX3f/TggVU?=
 =?us-ascii?Q?Gz1BpdS3UnEd8l7vtzYxz8EFXeUv1Q7On4nUw+JYQfDOHsV3Ug=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/m2Ia7MbMr10ttBR7ZuYsIanZulrVTCibX8bxZBe/TF1BD3gGYZ4HlmmCXb7?=
 =?us-ascii?Q?cKiTOf4MBttF7ipA/bKnEDdtgb2CElKv4RO83gsdafXiy5DR0Hr5SysbZfJe?=
 =?us-ascii?Q?1EqYYeNAm6k96L0EduX+182ZTzIdtKARWNtarjuuZ/eLv5vC/1JlwXmOAzEO?=
 =?us-ascii?Q?NZwD3QqGCQVw/TljKLYxOOCOa4KuKdC+vkLa0J9jfaR7lEbv9ox6L1VMP85p?=
 =?us-ascii?Q?4UNX2ikpM6Na+zK1F32cMDqgs8Ajq36XAlqQ9zI+kDlpIo5VYBq1rJkdgmyq?=
 =?us-ascii?Q?dIp75OGoiXjl4uAdya4ZpyOSKyzOUkEwYYLISRgR9zAJA4jjE11eXTuARTRg?=
 =?us-ascii?Q?jdaaaidIpI3qndNs/2/VyhD1KzJNb6H7z3hHL2tUDCeu7DRS2iriFcvmedsJ?=
 =?us-ascii?Q?8r/MHsrZWRng8EvRs2Zi3K3Na7NXf8lLLBMk/g5+/RZ47vdUUx8L4JFjvKKb?=
 =?us-ascii?Q?RRMPrTxIIo4jdyPQbch/h/2MgIv67g+xWdvx2p28GQNk5l4KmpLZhGYS89CD?=
 =?us-ascii?Q?UV8GjynDF0Q9VgDccrUnMZ5Dv5mP7br+m4m3qjpsCB3StJxmvqlcaU0kOChu?=
 =?us-ascii?Q?u8WmiF4YJCC2z9OCPeKiB9P1OHGDOw3qxbHvPDZaWr4oA3GQDHDkGSFgYEyf?=
 =?us-ascii?Q?m8ziwmK8qJjd1eSx05yJUCUwmgV0Y40yrfboYsIcJ1UnYR4UAVgRxBLWtt2q?=
 =?us-ascii?Q?2AWC7+qIbPxlyiBm8XweTLkzYG/Aav2/oGQAbTP/UQYRCFDpEVNFH2U6O42z?=
 =?us-ascii?Q?IM6vRuM9mDkDQt8/Wk709WaaIzXvtRJMxdm1T+lCQ50CGvW+IL9wL7V29oxj?=
 =?us-ascii?Q?hZX1Cd46hi+cm4HN2lJqhrHZtTOtAUC9a20FOsxpuPYj6R4wTzgmSHnSoNM8?=
 =?us-ascii?Q?b05ClT2+42SkB543aCcPYURwr3LvEtZx09k/aGbhwDnOzLzUbPoTZB8z44Y6?=
 =?us-ascii?Q?G0KZcCuda7iHkHTx5RUN1T7GY6GInFaZb6jY/SMHn9SrqyjQ8ucRaQwyhOmx?=
 =?us-ascii?Q?7k7TrLHp2Dl8zkrdeqrv6ujwGopYrz/Yzi0hZuPVIZ4ZNoV+izZzHWa3X8qd?=
 =?us-ascii?Q?ESvRgcCUdNnRohxuddiMDpQ85dUQBt8+qIMtwTePVOCj2CzGNk97n6WUBCmW?=
 =?us-ascii?Q?owTQ/ygDuqybGMND0un7Frfy0bbtc5/uLgsSQKutY4780lBlXsCCGuYTe0MJ?=
 =?us-ascii?Q?l7xVJqxf+uaZHFJQSJ5O8CTgU7HcAJb6gQAqo1rWZh1pumLcecfCWsz7K96Z?=
 =?us-ascii?Q?2wg9dYsKPxFZogSK9eDfLGcRCF+qqDg2x/5Q7ErgSG5SfzxpAc0f90Lpitc0?=
 =?us-ascii?Q?0NYqeYHqmUtcft1h3ybCv9sZXlHKT02kFbEsy1IgkDjdlM3QLJBPlFQrhMV0?=
 =?us-ascii?Q?jAIvRdIcuKf3589GUQALjZm6UvXZc89lYVNAOt6ZgfXx0nc92jg/G9/edrjP?=
 =?us-ascii?Q?4jdH7JvJWhmX5pSrHdJxErmirO8XcniggEhyscdeg/jOZMWbNue1RCzTixXv?=
 =?us-ascii?Q?99TNhldRixBkTVM9IPP9D310jjHNEJ8WwbWqOLoznNDR9IAp5jqK5We79MGl?=
 =?us-ascii?Q?psK9iUxHZl+dFGRkJL7Ebc0FVwU0XE0mmX7NDMzu?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c9cbda-61ad-43d7-6d78-08dca9545853
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2024 07:11:30.5788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /znXectfaGWAQ+PgO/1XtoTRt6HQMUEuHxxaksxuRfTeoCAoKZ4CstfETc4hejYffS1R4YOiDEZPC4FxcYTQMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB10396

This patchset adds a regression test for "md/md-bitmap: fix writing non
bitmap pages".

The regression test requires a network layer as the underlying layer of
md, it use nvme-tcp as the network layer.

Changelog:
v2 - applied Shinichiro's comments, use common/nvme instead of
   tests/nvme/rc, disconnecting nvme controller on cleanup_nvme_over_tcp

v3 - applied Shinichiro's comments, fixed shellcheck, moved
   _nvme_disconnect_ctrl() to common/nvme. applied Daniel's comments,
   using ${def_subsysnqn}, moved _find_nvme_ns() to common/nvme.

v4 - applied Yu's comments, add requires() for md-mod and raid1

Ofir Gal (2):
  nvme: move helper functions to common/nvme
  md: add regression test for "md/md-bitmap: fix writing non bitmap
    pages"

 common/brd       |  28 +++
 common/nvme      | 636 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/md/001     |  86 +++++++
 tests/md/001.out |   3 +
 tests/md/rc      |  13 +
 tests/nvme/rc    | 629 +---------------------------------------------
 6 files changed, 767 insertions(+), 628 deletions(-)
 create mode 100644 common/brd
 create mode 100644 common/nvme
 create mode 100755 tests/md/001
 create mode 100644 tests/md/001.out
 create mode 100644 tests/md/rc

-- 
2.45.1

