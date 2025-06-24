Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC8A2512C8
	for <linux-raid@vger.kernel.org>; Tue, 24 Jun 2025 07:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750751736; cv=fail; b=bUX/5eiDfPqgBYiY6O227TE9mu8Rlh0peup23SXWeQL9En3XfgNwlSOZrgIgFIoyhENtxlsrS2tjluE8shd/0hUqLRvq44iaGZC6NeTHxQpROPROUSFeb8lsUFGP9DtPOlZMm5FC1rvB3ArPRMLRw1SUWFBp1aZOF5CO0njpkQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750751736; c=relaxed/simple;
	bh=SDwgSTYZ77DzOEN6ShzJTOeBV09BmO37ZpF2ybwXC48=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=A3ae+09Ezc0WskjolC6yieta7H4ybm+JasX0TRlubeGe5lyH0A2TUhmHBeF7SCzuSRyPkqXh8fvdp38J5ELxrecCndrC+T7StbnTSOw+GS47t0VL2/+MN9f82q5XrPC0pzWsrnX1UeJ78TbjwmKh2PnDxm+eVDWg4DXbqXF18ak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UrMuY5MQ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UrMuY5MQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750751733; x=1782287733;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=SDwgSTYZ77DzOEN6ShzJTOeBV09BmO37ZpF2ybwXC48=;
  b=UrMuY5MQ+ysCItsqwhMOBM3AxqIn4YdY+1o0mJw58X3SY1DhlrKk7hnz
   4dOsbPdM6g8e+9+ipb67FvMKQogE2tBKThwbWPtAkSJspPv3oXQuOk0rI
   Ub1Lex5xsrXtbGTWtCPl5DPJNEAr8JJc7jclgP7KaKE8GepbTzQRFv2+6
   kF0EFVd2z+p1v7VCqGe4X8DxCH8oI4X3FzZ/uv94p2bK9lUi74HuxZACE
   yw57thdQBB1WzbGIl1g4aUYzbtRe8F/oR8M9kLtrPZPaj2lePkvOLUMEv
   ryypxaQNFs0rm6Y9DG3HK2an+T3tZ7mUSFr3DscbcRrbWZrbZt3UY+Pun
   g==;
X-CSE-ConnectionGUID: 2RD54FmVRlG9ULfqEOXIjg==
X-CSE-MsgGUID: x7yw/oXKShaB5bzXh3vUBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="53051578"
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="53051578"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 00:55:32 -0700
X-CSE-ConnectionGUID: CYL1P66ySBOIUHO3pz3FRg==
X-CSE-MsgGUID: XuvSgm+mRT2/LNc8hmLeCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="156418808"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 00:55:33 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 00:55:31 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 00:55:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.76) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 00:55:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2p+B5uyqUm28OrHvy8P4EeTNy3TAqO4knb4n3q7oldTDAOunoYm79OYHeS/hVvPFYaDGPEPPrwubfjwFYYxpyNlT5MPjF4pNMUxek5RYGdGexKqz78n7ufYmOB0x43ofQ8NUGijYIIu1NuyUVS0OkjV96lgIXBp1uPfd6d4mSFvrlOpds7/Q2Y00QEYP4UVITJldJ0S8wuOQCPqTIxvXjjKUtwuLmTwZ20neEgtl9aPBs85nQ15eTkL+1NvkSLgpl4w7jXU0WPGNN58RlCsRdvKKbiwuHqON43kn7oP+EvKxl8LaF3dXL9NyQ7b1Jv0FaINoR/T78bBqkjMMUbxHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJPT0BG6ZyN64Jr59crvjmiIBJzQwsFEdLVYtOpUu50=;
 b=Br+f8/QWO+GhAgNTtCOI1Y9m3lx5tNVVvtOHfT+GNf4qhVNOhVtsjbMcuU/j4R2QwaYCt9BISewzOlbMSwTXo7WCs1WNfKaUubY3Af/Hdnb83/7Xs1XvNR00NYzV7QuoHDZmsvAH/TFH4whPDlXcTx68vXgcm0RBXD/1GOUbBsBwGsp0oN9Pu7Y2YMN6ZDauDChYMmPGqELfJZ4Hq2q9/sZScsEyg/1WdVN748PzmjdByBFsCT9fWXesBly5z2ClF5vY3Cr5SzgKp30YQv4+1Mlc5QaFLITbN0VUjxEkfURqXpIUhK/Dufl42kOP4k4ZCZoQfBVS5RzBLwzhOPmSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ0PR11MB6814.namprd11.prod.outlook.com (2603:10b6:a03:483::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Tue, 24 Jun
 2025 07:55:29 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8857.025; Tue, 24 Jun 2025
 07:55:29 +0000
Date: Tue, 24 Jun 2025 15:55:20 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Xiao Ni <xni@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Yu Kuai <yukuai3@huawei.com>,
	<linux-raid@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [mdraid:md-6.16] [md]  bc8ce8eaa2: mdadm-selftests.05r1-failfast.fail
Message-ID: <202506201427.baf6fdc2-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SG2PR03CA0114.apcprd03.prod.outlook.com
 (2603:1096:4:91::18) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ0PR11MB6814:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c44a602-6cd2-46d8-a76f-08ddb2f47c89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?olLNcqTFs00cUU/R7Hu7Kc9V0UJfT5VXpB8TmiyFPJxkfVvS3F5GUQwYqY6n?=
 =?us-ascii?Q?SHSBooaGCV4i5+tbrThmMPvhWfIkfS/434neZ6A8JcBdbRwaYvm+HsC7ZNnM?=
 =?us-ascii?Q?QbIxwGfepGgz0Q9jjGWh7fGGE4CxZqWiE2mD73MBo+zZQhdXgC3gK8XHEIxe?=
 =?us-ascii?Q?h9d/MlLb+L2e5TB/SCjzWO77ZHmaJ94DFz18yA9lo8DLtVa54E1v1CV/i2K5?=
 =?us-ascii?Q?WyXDF99Jh9TM7euM5NSp6X4eaVh3S1ygZpnx9jBYM5APHp11mjRuAjfoBQHz?=
 =?us-ascii?Q?/M1pUEw346IXxIpydVTcaKcJF3UT4SN5HvoRQFRA+HHCNoYUiGEicREMzrM/?=
 =?us-ascii?Q?UKarRvVtvB1XTEY9+77ZCJWgw+a+dU/vhlHPx01QCwTWg6NlOtBCslLmY/vz?=
 =?us-ascii?Q?SfDvjSITUb3PECrU3mxJenLLrDZ8JYOS158QXwd1wH0QaNJXKrVgJYsLIudy?=
 =?us-ascii?Q?qDmh59olo0HT59WsvgXoM+xmgIxnFj2imbcqesrbglFtEFrckQutaE8By150?=
 =?us-ascii?Q?M8keHlWhnpjnbByfQVccR8Mw88I1aZSfc2jUM14d3uVQCf0b8v6kW93avKvp?=
 =?us-ascii?Q?/v30Qi8DkmRZm2fworZ1IaDb4PPEM+VEWsPCrKWZQhmzuoCLJIl+/vzGN9JQ?=
 =?us-ascii?Q?i8I8uzNyPmC05ARQ0vSrydJ6fJG9VzphjjnuwZXqMkJaNMWsScSpZOEgxBK3?=
 =?us-ascii?Q?f8YtOl5L/TrwbwUeb+GGECtyIIJXPlvPG/LH/0mgijSX63X7QzTIHjjEiSsD?=
 =?us-ascii?Q?n87BmT8jwvIprqBrzLrB1oryI7I2Ro8cMwRMq6vZCRUeUYyHuvLqcOBeuGhz?=
 =?us-ascii?Q?f32RasexIMKlBGseZUb0a9GR27F2LwRbriv0ci5VLSYlpyhplhNh406WryFy?=
 =?us-ascii?Q?Iw90UMaw/N8CRN9tyVa84KU4W9Rd7+dittr313aVW/tmWDsU9m0fWtQHi+oE?=
 =?us-ascii?Q?e/csNiXYeUDiovcZxDXrOwnncvfBzG1m7AmmjLXPTDjj2fCapk8pv5UBivcq?=
 =?us-ascii?Q?OyOC0R6iad1bcPZynXCBD/Xpq2OFQkTQBum34uqGYNsX9n66Zk1a6B/8YOEV?=
 =?us-ascii?Q?51W91je9M5Gy88wWn0hJs2cij8psOVWvhECe1NEdVw7EGUofZNoxIB6ICuKV?=
 =?us-ascii?Q?8QHz1ggLe+Hmtc/35NsCW+qXLCgkzD80r+eHManhl/68/eBWLxTiOPu9ibRj?=
 =?us-ascii?Q?neC7Vy2UaOlfwOGqHu68s/ty3gwPcupvlvp9cog336Op9CQONuW3cK6N4IKc?=
 =?us-ascii?Q?g49C3+9BUKzoQbTxOmN2tHL9m6b09FmQvZsoeTKXwkijtEfFovUzBrw5u+ln?=
 =?us-ascii?Q?xQycRgYjL7foucil07oNy7aHPZAPlyo0LAf7lcdAluur60lSl55242Z0wcNJ?=
 =?us-ascii?Q?TGgarjobriLDwDzThU9uU/hQYObH?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hg9k0X5dCGbB/PcPkDqQFZKmHQXTweVB0DaTm7j609rTW2nODuFginQn1ejM?=
 =?us-ascii?Q?cELJMYdpdDBpL9tQ2APCmif1JBsa0lBS9zm+x0bCvhGS0bbrqYINiAdYVjvb?=
 =?us-ascii?Q?Ik95ity+xsiEA/1xwdsjNBWc6lVgKhgTcIwgg6/ZWAAmlV/1E8DAeNotrhoH?=
 =?us-ascii?Q?DknJmw/8Sxj0LDWP9WZbtqEl6piQLkPjm3sBOZJ/QuuVm/5S35s10xhorx5a?=
 =?us-ascii?Q?cTE1kmcej2TbGXcGkw+5OFPsQlqtlqqXdoQahM/p6j6YhvAGs3n/jMM31Lxc?=
 =?us-ascii?Q?8Xbw2bI6vj5T0Yyf7oNgHXuG2j2ytMCfnkPhbZNkzP19Nzv1Jo7g1V3jKmpN?=
 =?us-ascii?Q?eyWhzUbiXfTG7f3XNpUeq3tts3gGAGaenEb9AQeFplNitl14OG5CgcpIZltW?=
 =?us-ascii?Q?w9Qp8+Q7sgy4tJCKpy+80W+JaQTESXz7xXVruEg2yn2redNWWi4+1EUySfkH?=
 =?us-ascii?Q?677h6T2AgNpNqKQHXYNXgaUcApXIVmFKeQx4vdu70x+FzaefmRVa4MuyDCH5?=
 =?us-ascii?Q?noOofTtttsVdVNiDtMHH2KXhrliZMmAmkbSUVBBXLiaBiDEzQXqNMZw+rPUb?=
 =?us-ascii?Q?KMF9c9JjONf+URoLolIey9pwZEJMjebHfym1ao/4t8i2NmJPZM0mZXyhiV7d?=
 =?us-ascii?Q?0esvveLwJtiV2PT28oCKmgeBtpNo9ZTISYrQeBIXItty4bSmld8yzzkCHo/Y?=
 =?us-ascii?Q?G+KbFIxpOS/4PCEOBiGv7bWFmie/v7S+Xq0W1DMzcFvvg+SMqBQslzG3eUG1?=
 =?us-ascii?Q?WzUGmz9AOeckhlWC5fJEjxzagssEq7+9FMNoO0LvLjrREsZIQ5UEbexI8WST?=
 =?us-ascii?Q?znIBFJmG8EvL4KfKumTpwZclQFyGV6EWLP1vS3sTM1Ofu1k7DHTKV612xXJ0?=
 =?us-ascii?Q?cV0y1ruJAKRE1Lujk/ZOTF3IxykrhH5VC7IhfaI08R/dbMnYa2v8YT6jJ2u8?=
 =?us-ascii?Q?7yTJbAyzY5gpUyDUTlEQQIVu8SnwMaOs052rqihF6rvvvrpOiqmlrosPDytT?=
 =?us-ascii?Q?ibHJtnygwvOIFa1NeSaj8Nj9h7CRqc5mfVo1gowSjqMwAsHJ1d+ZKGGz7PR4?=
 =?us-ascii?Q?vt1wSZ/plOltOYX/JxccraZu/Fh4JaO3dBuJIbb4LgNu9A3hxTrktcq8ca/G?=
 =?us-ascii?Q?xdRC6BrTmop3fjHG/2i8dkyB+TJCXui3xAustWWaTIvNTDo0JGNm3akwmQN5?=
 =?us-ascii?Q?l/Xf5iLmV8BwPgVQmALpf0Y80kFzKTnoikBnluWXTX3/uDc7ETLT4fOG+LhE?=
 =?us-ascii?Q?eAqCxbMeja0kuKv1QVUrW2tOHd3khmzRalq9HWpPRN6G+WgZBgYXditQr9YU?=
 =?us-ascii?Q?lEzohlDGzmyGvfJY4lKtdSIkt0g428uTWf/K4n50grL0mGkZNMfrH6E0oCq/?=
 =?us-ascii?Q?0sAH8Fd+8Aa2tbSbf9vBhi0JyG+CGLoJ+KiHfKIxwwpmJfVqNaIu0LhI+5H9?=
 =?us-ascii?Q?DOn975JrdcBVnevCGmsDIiJpX31ItKbwgtFl6HFHrI3hba44Gk+BO22HICTK?=
 =?us-ascii?Q?wF9Up1gsQ4vdjhnxKWzHnaiRDjtAw6lD1902n+Dml0ZBNEuvqWhVzMHXeo0l?=
 =?us-ascii?Q?J5qOjsXVUZykfGLkPvh7zP1cB8IBa2Lfvd9jMQCU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c44a602-6cd2-46d8-a76f-08ddb2f47c89
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 07:55:28.9529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4WpiVpylQ1CfQdIAMFkVRLa0I3NqNhnMJXPBC16j0W62yu69Yu/Kvgtrl6ssdKJtdXYKyQ/Db9Gb+C5qSat4SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6814
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "mdadm-selftests.05r1-failfast.fail" on:

commit: bc8ce8eaa290a198cb5303181041aad037299b7f ("md: call del_gendisk in =
control path")
https://git.kernel.org/cgit/linux/kernel/git/mdraid/linux md-6.16

in testcase: mdadm-selftests
version: mdadm-selftests-x86_64-0550fb37-1_20250518
with following parameters:

	disk: 1HDD
	test_prefix: 05r1-failfast



config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GHz =
(Haswell) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202506201427.baf6fdc2-lkp@intel.co=
m

2025-06-19 10:07:43 mkdir -p /var/tmp
2025-06-19 10:07:43 mke2fs -t ext3 -b 4096 -J size=3D4 -q /dev/sda1
2025-06-19 10:08:14 mount -t ext3 /dev/sda1 /var/tmp
/usr/bin/install -D  -m 755 mdadm /sbin/mdadm
/usr/bin/install -D  -m 755 mdmon /sbin/mdmon
sed -e 's/{DEFAULT_METADATA}/1.2/g' \
-e 's,{MAP_PATH},/run/mdadm/map,g' -e 's,{CONFFILE},/etc/mdadm.conf,g' \
-e 's,{CONFFILE2},/etc/mdadm/mdadm.conf,g'  mdadm.8.in > mdadm.8
sed -e 's,{CONFFILE},/etc/mdadm.conf,g' \
-e 's,{CONFFILE2},/etc/mdadm/mdadm.conf,g'  mdadm.conf.5.in > mdadm.conf.5
/usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
/usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
/usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
/usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.5
/usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rules.d/01=
-md-raid-creating.rules
/usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.d/63-m=
d-raid-arrays.rules
/usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rules.d/64=
-md-raid-assembly.rules
/usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /lib/udev=
/rules.d/69-md-clustered-confirm-device.rules
=1B[1;33mWarning! Tests are performed on system level mdadm!
=1B[0mIf you want to test local build, you need to install it first!
test: skipping tests for multipath, which is removed in upstream 6.8+ kerne=
ls
=1B[1;33mWarning! Test suite will set up systemd environment!
=1B[0mUse "systemctl show-environment" to show systemd environment variable=
s
Added IMSM_DEVNAME_AS_SERIAL=3D1 to systemd environment, use "systemctl uns=
et-environment IMSM_DEVNAME_AS_SERIAL=3D1" to remove it.
Added IMSM_NO_PLATFORM=3D1 to systemd environment, use "systemctl unset-env=
ironment IMSM_NO_PLATFORM=3D1" to remove it.
Testing on linux-6.15.0-02014-gbc8ce8eaa290 kernel
/lkp/benchmarks/mdadm-selftests/tests/05r1-failfast... Execution time (seco=
nds): 8 =1B[0;31mFAILED=1B[0m - see /var/tmp/05r1-failfast.log and /var/tmp=
/fail05r1-failfast.log for details
Removed IMSM_DEVNAME_AS_SERIAL=3D1 from systemd environment.
Removed IMSM_NO_PLATFORM=3D1 from systemd environment.



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250620/202506201427.baf6fdc2-lkp@=
intel.com



--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

