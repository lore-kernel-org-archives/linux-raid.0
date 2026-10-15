Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021091.outbound.protection.outlook.com [40.93.194.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5503B3F9F5B;
	Thu, 15 Oct 2026 20:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097278; cv=fail; b=kyym6WTE//WMv2PjSuigNhGYUpt761sr/WCYX2cOcJSvXz8v81Bm/SwtN17D24JVrDgnkA6tNaNX8yOGWa1h+o3iagfUfNb5QwWlbyM8QFIj+A+1Fq2RfaFWokTn+S7QAdpOKevuCzapXZ3kvKO5qMkS78DYoP+RxbFZ1aPriPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097278; c=relaxed/simple;
	bh=PRN7l4yfkJzOll1GSJCr3LYRi5mym2aF64X8VeuR7gE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ur8oOmnpTedmEwD73cW2I+CCdjEDwrmdNvtSUGoI0NGP/Yay8IQNnt5Hn3xViIfLfCwJHWGv0juckfY9/2mopYqd3DsYQmGGfT6FBRcnkviIEY5el30beI/opQKkvX4BvO2UK5CCbaIrlr1RgVZIpqopMVIqzEAZAHo2BwbgQJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=CAKmq0hY; arc=fail smtp.client-ip=40.93.194.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="CAKmq0hY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=okSPZaTJpYt1fQpl/rI4inwdcTF9yR7qulU30egRcNjgWfqic79ga8T1S+qhkjAzaWhEhSIWAH/WqVtM641iKRZ04p30fu/XczdazG6PtDCzI2sUWsfbK39ErCqnaOSS/WPz6VqqNDr1xPEXANy6DZT+cF/Pa63J8Fj2SHJ86/V4pD1odfZ0z015mWqhkfFl3oaPzRf6ffo96NKOTAi2VwO7wMN6GPpjGMXUkIZM8Ph4JCq7E7WqDhlB6hP4aSj6mgc1h6B+2nQAa2M+AagEnUE8IDzPMpPO8nI1ybhTBGjmUqzfKS/78vEgHEGFFtt+LjjQa46iYInMapgJW6IEIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8kiPtIBEv9EyD8ypcn/bSD4vvgLPn/P0fNiq0wb9Nc=;
 b=RwQRBnc6MJ2jn+GSZk9ht9X7hOltKU37AYaicWrnYDQEo2eUy+guRmgI3FVotZ7SjiHjiWaiJdlTbC1XuLXIgxssEItoEN+3kNElj64CSuyTBzEJS0C9GyOXJkASpRaYr5WCZcYIguekIu986DsyVWbiLimCAH80CBHHons5Ex9Yi971dP3YScPcMc/rcW5tWcKrUvAkM61z1fUMESaOvbSp2CPtdSIO9IT6QuBbM8xubPc6hBEQ+bLXOW8+gtgU1NYDwTluFn2yn8EnWriIghhCY8uNRe9Yn7PRVE5SOkPwCJAJs9dPIlDWpSVxceokMSxiR6IjmtiGQL4CB3hdAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8kiPtIBEv9EyD8ypcn/bSD4vvgLPn/P0fNiq0wb9Nc=;
 b=CAKmq0hYtW9j+PdAiLuxc+JuMGJRodaMKQwnfHABI54r1nJ8TUC2H39ABNBhZYpHl8eFbuDTi+e/ka7EcGECIs3mwZgMJhr66nfw4Z7mF36Bfloih8sYfVNYVq454FXW4GSA7wf/H3uAPYpLiC4ZmOZTLunE5oiazjGdP/Ea6CDWGyNnG+BSk9CmVyapmX5x/pMBzR/Exd0+eZb9bfo7hvsNQZzdyNl5Y/aSKyj9oPS/F4l7Zs5gy6uE0Asi6wVk7TXZ6NyKCS/YcE14h4uLAsGwK1tNg2++hP71y10NEWERJSUM9pr40XKuvApelwuOrJXbWGLS6jFdqggazB+9xA==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by DM6PR07MB7226.namprd07.prod.outlook.com (2603:10b6:5:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 20:47:52 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 20:47:52 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	"magiclinan@didiglobal.com" <magiclinan@didiglobal.com>, "xiao@kernel.org"
	<xiao@kernel.org>, "abd.masalkhi@gmail.com" <abd.masalkhi@gmail.com>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Masalkhi, Abd
 Alrhman" <abd.masalkhi@gatech.edu>
Subject: [RFC PATCH v4 0/4] md: add a control device for array management
Thread-Topic: [RFC PATCH v4 0/4] md: add a control device for array management
Thread-Index: AQHdXOZyexdWiYnXCUOsbLEcfqNrAw==
Date: Thu, 15 Oct 2026 20:47:51 +0000
Message-ID: <20261015204640.1184848-1-abd.masalkhi@gatech.edu>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|DM6PR07MB7226:EE_
x-ms-office365-filtering-correlation-id: 71b2954a-8480-4e91-44a8-08df2afd94b0
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|786006|38070700021|56012099006|11063799006|261009221227099003|261009221727099003|261009223327099003|261009223027099003|261009220027099003|10067099003|18002099003|6133799003|3023799007;
x-microsoft-antispam-message-info:
 LNERhSZWi5EVV3gpai+jCBu8N8+OAZDFomgnGby6sxjsIVfnVd3R51FCrgojBnQWqax2tiSfBkKj0bQWJzC6lrkYgQnQYGrrZhuVsPOzA/glMohBh/t5NQ0jGqHKm0kLMotpG4T+NXPpT9oWWZVzUGtY2sHCyZochotCqGYpVyHuc/Ef4rm8K2JnPWNjzsJB40ZAKhf9g2w+0daMBo+M0T7lp5Jcm+fs+/WdVDAEdaZS3goERNJ80VWwfpGr41BJJIeEkIRs5+7n6HKmG4c/OIc1s0pQUhxFu0G6xpKP7I7qHzJpWEDfdKCRayY+9SkggdFI4q7s3I8WTQAkbKKo0Feo4z3U0mIxCC1fLxK/xolfFMwhPL4hPIgEAZospmsIIgZ9CDH0Du6nC6USHaI6BfQQzaejtlS5WJbvaROh7YXJVX9ppTAB6ihBKe+jNH73JLI+Kw/r4weeIBC2A8SCQSLh1KEWruF5Qm2GnPRCOSbaFbhSKs35yt4/u79Weud0mJ39QmeiABxTHnRnOEd/GfOvlBCFFxM/ZhywtTHNQhnj5TWyuwlBmI65wuvBYyULHPCPDhTR/OJEUMZZCVcwHQu3QNgw22AhsW8MUVJJFwxwYaAym01OevlbAVZWcIBSgL7xQjAOZcjRMmJW470DBKvMPYpSbxKzH5G+3/FpyoM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(786006)(38070700021)(56012099006)(11063799006)(261009221227099003)(261009221727099003)(261009223327099003)(261009223027099003)(261009220027099003)(10067099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?NY8Uh89+2wYkEY5NzYOUBVSdWTjSLKfS7AIN1V2L5uYWDXaolZOZ2Mytwl?=
 =?iso-8859-1?Q?JHnxtFnVAQikiSf0/FlKQ8x2rfmcyoOlKfkG8iVGxX+6BUxJacOyfbea9D?=
 =?iso-8859-1?Q?AXYF5auK2w5V3LG6uI+Nq/KKApsGC9Fr0HjLwIqg+/ftncYZWh204m8mdG?=
 =?iso-8859-1?Q?wuaFzscnkPBYHX2KIRISNirY28+FXDLLyW8ZAfT79h65r1tNvpQF8yCRI/?=
 =?iso-8859-1?Q?TDn2BvrvZLura/Mvhh1RIc8xQYbG4qg/G5RlYm3/rpNh+RPJs8SU8ML7UK?=
 =?iso-8859-1?Q?Ae8CVZw1gQ5GOCAyGePsxr+XMBmLglhlzk7gzhJSQjVjUrz369Wmzr+cjO?=
 =?iso-8859-1?Q?cTzdwFKHi3yfzUHiFC+yk/fhSNtRilN/Ox2wQRls5aAD/T+D11uJP5GBid?=
 =?iso-8859-1?Q?fZLZa7s7zYXJV3I2czZsM1ENe5itrbCkwZSag2yur+0emE2iHj+HP81fp/?=
 =?iso-8859-1?Q?1wgvfDM8oInwupShb6v0LlTrST8nrTa9G0KMnWaa9fFxos2wdvZqg2Jnw7?=
 =?iso-8859-1?Q?TCas/IA+EybQwOcc5W4iAa8xDDa38pOmeZx7KTlS8Qwo5tdL0OI7LidPTT?=
 =?iso-8859-1?Q?+zesAZ2PNoIOZLBDMA8b6DhbBrWKiBdx9J1QYJfjHeKfjZdlznNKGAI50M?=
 =?iso-8859-1?Q?HAbmulPh5Rg1/LlcaBVDCi7E0MYGSjpNiCeQgeiI71/T3leW6PyawwGDY6?=
 =?iso-8859-1?Q?YbrzMDbvX15zsHZEfnbjDPq2geaCD1qqQMDhi1zB3lFeawroH2Q4Gzz3M+?=
 =?iso-8859-1?Q?c1tLz3lMH0E4Ft3J6LQ3YcnrYfo6lUbgfWyW7T7EpRn1UAVN6I3+d7jiRk?=
 =?iso-8859-1?Q?otMiBTyUuqkSksfo0nPLOlyUVHDzCieP5EfZIbmmBdAheegYUBN/uL134R?=
 =?iso-8859-1?Q?Cs3pkJErCsoPzYBjHFGtDR7OkML36B40cNPklgm1V+XDufsIQztV7a+q/2?=
 =?iso-8859-1?Q?okQSbFasbS/tuflsNDA4afdtbm3mbFwZoEfFQfcupP3MNQhOiLi+6kdPKA?=
 =?iso-8859-1?Q?zdoAS3yYhGZcCH9W6C0KrhQwxQBB3NgEbsVaGW6YjxKuw81f3984iwOLLT?=
 =?iso-8859-1?Q?7tAhG5bQnS/BXJ0TM4XcGglEyaxndaDpGJh8f3GHxSsaKug4cdNfdrhKiD?=
 =?iso-8859-1?Q?jPr13HMrsC9esDifrpolO6273bMXNvTbbL1UCmr3jzi5CEaCSiI33OVBVo?=
 =?iso-8859-1?Q?Gpbd8l3UW7sufXjPXA03eYMMkyqzCXm63mSauxWWUyIIgguoaLIqwysYIt?=
 =?iso-8859-1?Q?fr/NhDPlB3Z0FaQruyIpy6KUQbaamSGA/Q7xgqxV5BeO2lnHhmqXk5JA9Y?=
 =?iso-8859-1?Q?OnKFYmNWZF9QPE28ga/lXOXXf0GG22/qF3pgU+htqYcDSmamODZDWpqDiv?=
 =?iso-8859-1?Q?49n0W2EAh2i655lFXGsAmnQxrhdBgdQcDlU+uejDj80BjRck0ZrFpmtUZS?=
 =?iso-8859-1?Q?y2k+pkK3hJL9sycm6NBULermvzcMX3niSUld3oXnpa/6weKYQ4iPmKW5/s?=
 =?iso-8859-1?Q?z9qI1hYarxoyGOQN/tnW7GuGxG8cOojYwTlLGxrrNJeRZ1V1KjbriwgPBu?=
 =?iso-8859-1?Q?z4B3TdPj90wcoGl7GGbyYRBdykp877XK+PMmvitnGo0GitvcqTljyN2V5f?=
 =?iso-8859-1?Q?gyzTuOj3NANuiM1V71IMZ1gJ5Syb7SZ7j+FiuWXZcP7/WYSg+/BWIA/1pV?=
 =?iso-8859-1?Q?xnV4pHQ7dguWsuukfpa5zIzJ5hndoo41sEfXPUYkQWdj6bOHDeyA011Sb4?=
 =?iso-8859-1?Q?BScwYSaR19ObZsATbeLyZ0ok8h0vSDYVU9DC0+We65cY6R?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: gatech.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR07MB9958.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b2954a-8480-4e91-44a8-08df2afd94b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 20:47:51.9513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fq/dO5pYRCRNzwuZyN2nCFRs4UG+M9nEBkuT1qt4C6lHUksVG0Z7K98hC6C2w0rD7iXfzDwMubLBeC3t7P1x/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB7226

From: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
=0A=
Hi,=0A=
=0A=
This series adds a new /dev/md-control misc character device for=0A=
managing md arrays without opening the corresponding md block device.=0A=
=0A=
Currently, md management ioctls are issued on the md block device=0A=
itself, which requires the caller to hold the array open while=0A=
configuring or stopping it.=0A=
=0A=
This is a problem for STOP_ARRAY and STOP_ARRAY_RO. Before the array is=0A=
stopped, the page cache must be flushed, and no other task may have the=0A=
device open or be writing to it. The issue arises when several tasks=0A=
share the same file descriptor table, as they count as a single opener.=0A=
Consequently, one task may still be writing while another task flushes=0A=
the page cache and stops the array. A write within this window can race=0A=
with the stop operation.=0A=
=0A=
The solution was suggested by Yu Kuai and Zhihao Cheng. See the=0A=
following discussions:=0A=
=0A=
https://lore.kernel.org/linux-raid/856a065c-38ef-08cd-7701-8f579212a1a3@hua=
wei.com/=0A=
https://lore.kernel.org/linux-raid/12b0bc4c-5dfb-4936-8ecd-849137b597d8@fyg=
o.io/=0A=
=0A=
The new control device is not tied to any md array. Each request=0A=
identifies the target array by name, UUID, or device number, and=0A=
carries a flags field. Unknown flags are rejected with -ENOTTY. The new=0A=
commands mirror the existing md block-device ioctls, with STOP_ARRAY_RO=0A=
represented by MD_STOP_ARRAY with MD_RO_FLAG set.=0A=
=0A=
New 64-bit structures, including mdu_ioctl, are introduced=0A=
(mdu_array_info64, mdu_disk_info64, mdu_param64, mdu_bitmap_file64,=0A=
and mdu_version64) to resolve padding and overflow issues in fields=0A=
such as size, ctime, and utime.=0A=
=0A=
The existing md block-device ioctl interface remains unchanged.=0A=
A warning is emitted when it is used to recommend upgrading mdadm to=0A=
use the new control interface.=0A=
=0A=
The corresponding mdadm changes were posted as v1 (a v2 will follow=0A=
in the next few days):=0A=
Link: https://lore.kernel.org/linux-raid/20260928211849.3602414-1-abd.masal=
khi@gmail.com=0A=
=0A=
This is an RFC because the new UAPI (struct mdu_ioctl, mdu_array_info64,=0A=
mdu_disk_info64, mdu_param64, and mdu_version64 and the new command set).=
=0A=
=0A=
Suggested-by: Yu Kuai <yukuai@fygo.io>=0A=
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>=0A=
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
=0A=
Changes in v4:=0A=
 - Drop struct mdu_bitmap_file64 and keep using mdu_bitmap_file_t.=0A=
 - Remove MD_RAID_AUTORUN, since the kernel has not supported=0A=
   the corresponding RAID_AUTORUN since v5.9=0A=
 - Rename the ioctl commands from MD_* to MD_CTL_*=0A=
 - Fix MD_CTL_CLOSING mutual exclusion in mdctl_ioctl, reported by=0A=
   Sashiko AI: https://sashiko.dev/#/patchset/20261007115104.13884-1-abd.ma=
salkhi@gatech.edu?part=3D4=0A=
 - Link-v3: https://lore.kernel.org/linux-raid/20261007115104.13884-1-abd.m=
asalkhi@gatech.edu=0A=
=0A=
Changes in v3:=0A=
 - Fix the issues reported by sashiko-bot, Link: https://sashiko.dev/#/patc=
hset/20261001125611.943731-1-abd.masalkhi@gmail.com?part=3D4=0A=
 - Link-v2: https://lore.kernel.org/linux-raid/20261001125611.943731-1-abd.=
masalkhi@gmail.com/=0A=
=0A=
Changes in v2:=0A=
 - Move the code from md-ctl.c into md.c and remove md-ctl.c.=0A=
 - Handle the new commands directly in mdctl_ioctl() instead of=0A=
   converting them to the old ioctls.=0A=
 - Use a dynamic misc minor number for /dev/md-control.=0A=
 - Drop the devname module alias, which only works with a fixed minor.=0A=
 - Fix the issues reported by sashiko-bot.=0A=
 - Take disks_mutex around the lookups, so that they never see an=0A=
   mddev that md_alloc() has not finished.=0A=
 - Clear hold_active only when a command succeeds.=0A=
 - Link-v1: https://lore.kernel.org/linux-raid/20260928201224.3602262-1-abd=
.masalkhi@gmail.com=0A=
=0A=
Abd-Alrhman Masalkhi (4):=0A=
  md: add uapi definitions for the md control device=0A=
  md: pass struct mdu_disk_info64 to md_add_new_disk()=0A=
  md: use struct mdu_array_info64 for SET_ARRAY_INFO=0A=
  md: add a control device for array management=0A=
=0A=
 drivers/md/md-autodetect.c     |   4 +-=0A=
 drivers/md/md.c                | 671 ++++++++++++++++++++++++++++++++-=0A=
 drivers/md/md.h                |  17 +-=0A=
 include/uapi/linux/raid/md_u.h | 114 ++++++=0A=
 4 files changed, 786 insertions(+), 20 deletions(-)=0A=
=0A=
=0A=
base-commit: 5c2f4115051d064ad79b0b4edac70a2b62528d9d=0A=
-- =0A=
2.43.0=0A=
=0A=
