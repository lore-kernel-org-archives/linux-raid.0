Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020107.outbound.protection.outlook.com [52.101.201.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C4E56E07A;
	Thu, 15 Oct 2026 20:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097309; cv=fail; b=sWekUmmuCrPmNCc8EEwL2QThHsMKR2gQTK5G3YTpb7DoLC+GL4+A1hT55WoEUilhbkSFXoULyav4AYafTM3cgJc4seXQK71M8JNKHZ8PJXXDqJLg2YSuDiZZFbRaJqjV7+Z704IntP3CBuwuY9zYVBy/2tlH03ZfrouPBjI67gI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097309; c=relaxed/simple;
	bh=yasG8GVmMJGIA5EVaX11NNet1V0DG+5qxIrBScXI0P4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=stsKRcoCXGRnJVyY+N2SANTvX2HzWaIEHm+iTntFwC0UNZtzgIBZTzqQ13eyDoBlbcvtg4B0B7gghpu+gw3qi+S0F2IT9hQgZmHhTiejAEn5cepx1DCPI7UAoMJo0V4/P7ZNuIjY1LPEef7g11uPt1hGqIrSriCezL3IpbysQfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=YC0qp+SK; arc=fail smtp.client-ip=52.101.201.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="YC0qp+SK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hq2uap8nEwT0GmL5MyQIfBWsK3HyYj+dMaN6gTdbjFSPqFaQauTpdRl/0xrggHfrtwi+n8EV4guwYmVNtDC3JpNlkCfS3NsWF9Q5K15tEzzgvjkZN1amNkLr0wvxPCWtwKQcSFkhQ0XUGvgUMCWGTeXBZuiq1BDD/rX0juNTcMCkYDTEgYm+6lM0adkE9S7VBM6pK6Mox5fAdFm4mI0H8O89N31OfKR3X5AZHJmeTIOZCv2gzK+TJwww6z7OApfDlwdBX2QasIlwyw+bpFp1Cj+dab+2pkCKhNMzGndQ9WQSuZlbXd1kTaOfPiZLf6ZiwmMIap01k4sZEmnuVtSYcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8u2G710l7pJwrq0QMHoDBIjiYPl1v9koGjjnNumqhF4=;
 b=EazelAq72p6foum7mdrFkrZS1DitQWExm3Mn+U+GB3DJ+47zKWwPYpgtBRqqyCAIaUxmElEs3DwDeDDP8KdmYVchu0xXLWv29b6iI+C1ONq3x5/4Pd9YcAReqoMNb40dmUGoyFVVrwQ4Tue4+w5CJ5JPvSZZsOHFouZG1uzvPZRnNuUU9/Yq9g34BZEmjKW4glrHfpIyWCR6oPIN/pgSd/w/BoyGx4DeLuoOHNnS6HXCGPbvqOD3Z1SYDMIDhbbuWCK2E+jkFPHFoI0w6bmFx5RFnyoHarB8QTWtc+q32+Ogv+gVDkqj0cM2kATlMHh+l/zOm7oJwGonnuuZoa9SBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8u2G710l7pJwrq0QMHoDBIjiYPl1v9koGjjnNumqhF4=;
 b=YC0qp+SK1nWFkWveJba7LeIpTt/95OvLyQ4bSI6i9fCuXGgk0CYBrukeDC4cvfxtMGCzvLowEngzmG2oRGw9tVxWH/T/2z4+KOW308F9F81aadWzXQXfebls/9i/Heo0itdsq1dJ/JTQa5CdF+0QPsR7KlFpu/sH67BvDhIlRy99/W5mFRZVqeUhZ/6FtTnBnRNoKUBsbmLtMga1x6YAifpWSU3u3gBS1Fc1ZJFQd4lNb/iEaNQx+NLTB4VJS6Es3csu25RKbGX2Ln5zM79rAJf/1nUJKKAx6tK9PO9QrWDnOJUXVur63MWTBOb9uMl6ZHmfBIeX+5ZW8JBVkwRV9g==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by DM6PR07MB7226.namprd07.prod.outlook.com (2603:10b6:5:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 20:48:15 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 20:48:15 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	"magiclinan@didiglobal.com" <magiclinan@didiglobal.com>, "xiao@kernel.org"
	<xiao@kernel.org>, "abd.masalkhi@gmail.com" <abd.masalkhi@gmail.com>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Masalkhi, Abd
 Alrhman" <abd.masalkhi@gatech.edu>
Subject: [RFC PATCH v4 4/4] md: add a control device for array management
Thread-Topic: [RFC PATCH v4 4/4] md: add a control device for array management
Thread-Index: AQHdXOaAoL4Ml8hbY0OjPoY/NP8ERQ==
Date: Thu, 15 Oct 2026 20:48:15 +0000
Message-ID: <20261015204640.1184848-5-abd.masalkhi@gatech.edu>
References: <20261015204640.1184848-1-abd.masalkhi@gatech.edu>
In-Reply-To: <20261015204640.1184848-1-abd.masalkhi@gatech.edu>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|DM6PR07MB7226:EE_
x-ms-office365-filtering-correlation-id: 6f747269-7262-405a-dd32-08df2afda2ca
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|786006|38070700021|56012099006|5023799004|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003|3023799007;
x-microsoft-antispam-message-info:
 MYgCNr4Zyr4f2/iU9Nh+Me4FTpmvQTlgiMQkSfY0UTlva1kLraKlfWv5DcI0MnPHUDKUUwwWD6HhNvYv3oRpvpIkBbMIBFSSYKw0TxotfhOkKtTvnHCFjNpiAXlFUef0DrqOp+m8UPILhvJivMtWi+CgEBMY8ELG9ceaScW422bkSIjQEbdvvhwfoeGyNKzI3hYSRxiTJIgUgYoMeIV29KaluIYFFEYb65aOgzli2gkyDNwnHZG9bAxLsfb2DQtnzwzhEgdTVhr7rU/Tlsr/0r51fgGbMFYuSSdaUg2Yd90OT69cEd35+XiiayDLWm5Ncng7pgZR0gBdunA8oNSam131PFii7NkcorH6IbZVH5LaWEobG8et0esQbh8TdUeBwzmUASwBvJNqNTwpyDFclulukIhbcHvkN/xHHc9a85JD1MFuE+ZtilvAlnK/OLhtLdrNUsqaZs0DvrqjOLh6LLcFzEcfM4/EGShC6q2iJ2nun2Kz0rrB40PQrYF9hkGr8ET/+KZLzG6zj/L4EffqH0g/y6O6nKezuU+73v31g58hvz3KHLT1QhPkk0BqhKDXYCwComT05rz/hjEoldOgngu2X9fwKOmsdBQgyQ921MqeRqMLKHen/zdYEG0QO6jgcKUpu86nOgIOOs4kRGQ70AiofEY71rNaEpd2HMR9uMnZa9Vq/hmiaX/rlPV9bzgWffvDbGPhNkZ3/r3MuSRiWYCUWS6LlWu7NpDhv9S9CzE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(786006)(38070700021)(56012099006)(5023799004)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Wg/6CG5gUU6fX5jo7bBI3AswNqmEe0zcRYSji/n+pJmfXra4Qy9fwIFnj5?=
 =?iso-8859-1?Q?9Ro2uiSrNZJMXvyo4zcBoAkyDVlRkgwifHyd/nGziJZgiZNWc4fIJwKYw8?=
 =?iso-8859-1?Q?ogNWJ4qnIZwHSVLq+pl08espIo55VvhJivufwizhq2hDh913YMi6RMeYkN?=
 =?iso-8859-1?Q?ZsSwEXnT4uPrOUGmaEKEoWc7gfLtORTwezBQsGrBhfIRKev+iR3hqYAFpw?=
 =?iso-8859-1?Q?EjKtVZV4JzxLuzbFt3HstX31ayIdQnPPLF2sj6IxDr1Tm4Qke+bbNBywcB?=
 =?iso-8859-1?Q?cRd0UsS8HEjSdF1eH0EN1/IG7my0Uw10TY3TujKyMT9iFRSHL4pGoKDz69?=
 =?iso-8859-1?Q?uZIr5pQxfl6uSnTRV9QXqioXOTaD0UYaUKos7wlyIDGcdH0gdicGjwLBc1?=
 =?iso-8859-1?Q?xkh4AgFqr8Mv6t1cMBdkN3pQf3naK4Er24etTHkDZAqzt9hH7zgUddmEbb?=
 =?iso-8859-1?Q?vpunCEJeP0uiCoTzroJU69Z8/bjebL9/78zAFVFOIubgrGF8/8bHL6AHKQ?=
 =?iso-8859-1?Q?9rYNS4QVdnp+I6TY/VBiZTKSxGw75vojr6rXX3onyJeRmCkBM6r4H6W7r8?=
 =?iso-8859-1?Q?WYa0Y7TYhyGvO8E+sAxYOy+9mNuMiyCsTUELfHuUTNVnK/ejEWoGSwCsLX?=
 =?iso-8859-1?Q?Rm9DpGyD3yLty3g1Tu8Z7/7yxuDepd1t4+xBDCy/p/aNPVssMPHOFU60Fd?=
 =?iso-8859-1?Q?uqMC743qsvcyzHEU7f0ixW19FquUSakbq+uVS+s1N6V6EJ4L0kkhqksOdN?=
 =?iso-8859-1?Q?kbfPqqrwV6ivXjTqqknaLMc2VhwaTNm2RFFKgmge6PQDNVNe0c4+n7oube?=
 =?iso-8859-1?Q?/0MZRNvkj83P6qYWZCLdBt2zkhjQFl261EDd8IspOMoCqE64wCCJVtO+yJ?=
 =?iso-8859-1?Q?UkrGF12n7wCR3hAXgf082molsqbVFYooWfKluAuqNq3qlm+Zr8zCZdcwv5?=
 =?iso-8859-1?Q?puvUQGSOe5xN0YIYWTvrLhcjVgtUJT+ey+rWI7JrW4tQ70GJWh/qC8FMXR?=
 =?iso-8859-1?Q?gyj6x0u9X+hw0lt1euIzwL4PVIyI0JsjH2HuPPAGUcbfUQ2SJLATWbQghL?=
 =?iso-8859-1?Q?M+riPCVkfPL3sVS9v9ooh9qE1nKGmqNVSo0KvYRyU+ga6wLbKOZktrtcP5?=
 =?iso-8859-1?Q?AG0jhiIL4mfwZECImi0QqBeZznL7z6UsPBDOSfv+57h7piMdxwJrQBXWjP?=
 =?iso-8859-1?Q?Gvyz/amJSBoClc7NQ1U9TPY7aoZDE0BzRPHPT4lwsQlur6HBcTVskqu96g?=
 =?iso-8859-1?Q?L8aTWUimGQyE/HGs6NkIgKpJ/S0ikQJabsZvCNtiOr+o+BScbBEA+NkJSP?=
 =?iso-8859-1?Q?b3PQy8CRGNrtD4u0hS7YzlUCA/cIZgliiL/Ldfsz4l7L6Ig0GxdB1Gf/7v?=
 =?iso-8859-1?Q?s1BqjRuGuLSIHbKkfAPSowX9PKEvWQjunBT39KwgXrTsC7GLCfz+HxzQHz?=
 =?iso-8859-1?Q?teTb0bQkEFh8paLupCNdGPFF+W5As7TF76GCudhZLbm0VKxo2S9nVYuN/o?=
 =?iso-8859-1?Q?wSnMnoTv7WgqSCsTuXoR4i4AXKrjFHDMgJo/D//xhYHLE0bngP8j0TrimE?=
 =?iso-8859-1?Q?0tAU1b2MCe7p9D8QDyA46iWMHta6ES367I/oHntzhExKVfYMuhfsLFcMGz?=
 =?iso-8859-1?Q?BHOpXpbb+ddUhWPrtjma2eZKxSEXcmevtX2GX0PFr13drgWh6T1kKijVtG?=
 =?iso-8859-1?Q?xQY5518CPlJYckLbBuz7IGBLIyzdVAQmt2eZte5y/Dj/279NftifzUcmXg?=
 =?iso-8859-1?Q?MR97QyVClvyLgRxV4jQ1p3UQFly6DSgpwkCNEV2eVtR747bIb9Rc11vuBy?=
 =?iso-8859-1?Q?j1OvoXx6MQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f747269-7262-405a-dd32-08df2afda2ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 20:48:15.5959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r44TSkCoNKONquEPe2W/tc6B3bhb4jNsVwDPOeTyir1Y4UAcIniNnhDD+aSNsSMX0pkGK39pbJOxcbkZmW3FZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB7226

From: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
=0A=
All md management ioctls (SET_ARRAY_INFO, ADD_NEW_DISK, RUN_ARRAY,=0A=
STOP_ARRAY, ...) are issued on the md block device itself, so the=0A=
caller must hold the array open while it configures or stops it.=0A=
=0A=
This is a problem for STOP_ARRAY and STOP_ARRAY_RO. Before the array is=0A=
stopped, the page cache must be flushed, and no other task may have the=0A=
device open or be writing to it. The issue arises when several tasks=0A=
share the same file descriptor table, as they count as a single opener.=0A=
Consequently, one task may still be writing while another task flushes=0A=
the page cache and stops the array. A write within this window can race=0A=
with the stop operation.=0A=
=0A=
Add a misc character device, /dev/md-control. The control device is=0A=
not tied to any md device, each request specifies the array in the=0A=
payload, either by name, by UUID or by device number, without the need=0A=
to open the md block device. Every request structure has a flags field.=0A=
Unknown flags are rejected with -ENOTTY.=0A=
=0A=
Each new command matches an existing block device ioctl with only one=0A=
exception. The STOP_ARRAY_RO has no separate command, it is handled=0A=
via MD_CTL_STOP_ARRAY with the MD_CTL_RO_FLAG set.=0A=
=0A=
md_alloc() adds a new mddev to all_mddevs before its gendisk exists,=0A=
and frees the mddev directly if creation fails. Move disks_mutex out=0A=
of md_alloc() and take it around the control device lookups, so that=0A=
they never take a reference to an mddev that md_alloc() has not=0A=
finished.=0A=
=0A=
The existing ioctl on the md block device is unchanged, but a warning=0A=
message will be printed to recommend upgrading mdadm.=0A=
=0A=
Suggested-by: Yu Kuai <yukuai@fygo.io>=0A=
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>=0A=
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
---=0A=
 drivers/md/md.c | 608 +++++++++++++++++++++++++++++++++++++++++++++++-=0A=
 drivers/md/md.h |   9 +=0A=
 2 files changed, 614 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/drivers/md/md.c b/drivers/md/md.c=0A=
index 63b9468285b0..2d135698e0f0 100644=0A=
--- a/drivers/md/md.c=0A=
+++ b/drivers/md/md.c=0A=
@@ -64,6 +64,7 @@=0A=
 #include <linux/slab.h>=0A=
 #include <linux/percpu-refcount.h>=0A=
 #include <linux/part_stat.h>=0A=
+#include <linux/miscdevice.h>=0A=
 =0A=
 #include "md.h"=0A=
 #include "md-bitmap.h"=0A=
@@ -367,6 +368,8 @@ EXPORT_SYMBOL_GPL(md_new_event);=0A=
 static LIST_HEAD(all_mddevs);=0A=
 static DEFINE_SPINLOCK(all_mddevs_lock);=0A=
 =0A=
+static DEFINE_MUTEX(disks_mutex);=0A=
+=0A=
 static bool is_md_suspended(struct mddev *mddev)=0A=
 {=0A=
 	return percpu_ref_is_dying(&mddev->active_io);=0A=
@@ -6319,7 +6322,6 @@ struct mddev *md_alloc(dev_t dev, char *name)=0A=
 	 * If "name" is not NULL, the device is being created by=0A=
 	 * writing to /sys/module/md_mod/parameters/new_array.=0A=
 	 */=0A=
-	static DEFINE_MUTEX(disks_mutex);=0A=
 	struct mddev *mddev;=0A=
 	struct gendisk *disk;=0A=
 	int partitioned;=0A=
@@ -6386,8 +6388,10 @@ struct mddev *md_alloc(dev_t dev, char *name)=0A=
 	disk->events |=3D DISK_EVENT_MEDIA_CHANGE;=0A=
 	mddev->gendisk =3D disk;=0A=
 	error =3D add_disk(disk);=0A=
-	if (error)=0A=
+	if (error) {=0A=
+		mddev->gendisk =3D NULL;=0A=
 		goto out_put_disk;=0A=
+	}=0A=
 =0A=
 	kobject_init(&mddev->kobj, &md_ktype);=0A=
 	error =3D kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md")=
;=0A=
@@ -8375,7 +8379,7 @@ static int __md_set_array_info(struct mddev *mddev, v=
oid __user *argp)=0A=
 }=0A=
 =0A=
 static int md_ioctl(struct block_device *bdev, blk_mode_t mode,=0A=
-			unsigned int cmd, unsigned long arg)=0A=
+		    unsigned int cmd, unsigned long arg)=0A=
 {=0A=
 	int err =3D 0;=0A=
 	unsigned int noio_flags =3D 0;=0A=
@@ -8387,6 +8391,8 @@ static int md_ioctl(struct block_device *bdev, blk_mo=
de_t mode,=0A=
 	if (err)=0A=
 		return err;=0A=
 =0A=
+	pr_warn_once("md: ioctl is deprecated and will be removed in future, plea=
se upgrade to mdadm-4.6+\n");=0A=
+=0A=
 	/*=0A=
 	 * Commands dealing with the RAID driver but not any=0A=
 	 * particular array:=0A=
@@ -8602,6 +8608,594 @@ static int md_compat_ioctl(struct block_device *bde=
v, blk_mode_t mode,=0A=
 }=0A=
 #endif /* CONFIG_COMPAT */=0A=
 =0A=
+static struct mddev *mdctl_get_mddev_dev(dev_t dev)=0A=
+{=0A=
+	struct mddev *mddev, *ret =3D ERR_PTR(-EINVAL);=0A=
+=0A=
+	if (MINOR(dev) >=3D (1 << MINORBITS))=0A=
+		return ret;=0A=
+=0A=
+	if (MAJOR(dev) !=3D MD_MAJOR)=0A=
+		dev &=3D ~((1 << MdpMinorShift) - 1);=0A=
+=0A=
+	ret =3D ERR_PTR(-ENODEV);=0A=
+	spin_lock(&all_mddevs_lock);=0A=
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {=0A=
+		if (mddev->unit =3D=3D dev) {=0A=
+			ret =3D mddev_get(mddev);=0A=
+			if (!ret)=0A=
+				ret =3D ERR_PTR(-ENODEV);=0A=
+			break;=0A=
+		}=0A=
+	}=0A=
+	spin_unlock(&all_mddevs_lock);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static struct mddev *mdctl_get_mddev_name(const char *name)=0A=
+{=0A=
+	unsigned long minor;=0A=
+	struct mddev *mddev, *ret =3D ERR_PTR(-EINVAL);=0A=
+=0A=
+	if (strnlen(name, MD_NAME_LEN) =3D=3D MD_NAME_LEN || strncmp(name, "md", =
2))=0A=
+		return ret;=0A=
+=0A=
+	if (name[2] !=3D '_' && (!isdigit(name[2]) ||=0A=
+			       kstrtoul(&name[2], 10, &minor) ||=0A=
+			       minor > MINORMASK))=0A=
+		return ret;=0A=
+=0A=
+	ret =3D ERR_PTR(-ENODEV);=0A=
+	spin_lock(&all_mddevs_lock);=0A=
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {=0A=
+		if (mddev->gendisk &&=0A=
+		    strcmp(mddev->gendisk->disk_name, name) =3D=3D 0) {=0A=
+			ret =3D mddev_get(mddev);=0A=
+			if (!ret)=0A=
+				ret =3D ERR_PTR(-ENODEV);=0A=
+			break;=0A=
+		}=0A=
+	}=0A=
+	spin_unlock(&all_mddevs_lock);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static struct mddev *mdctl_get_mddev_uuid(const char *uuid)=0A=
+{=0A=
+	struct mddev *mddev, *ret =3D ERR_PTR(-ENODEV);=0A=
+=0A=
+	spin_lock(&all_mddevs_lock);=0A=
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {=0A=
+		if (memcmp(mddev->uuid, uuid, sizeof(mddev->uuid)) =3D=3D 0) {=0A=
+			ret =3D mddev_get(mddev);=0A=
+			if (!ret)=0A=
+				ret =3D ERR_PTR(-ENODEV);=0A=
+			break;=0A=
+		}=0A=
+	}=0A=
+	spin_unlock(&all_mddevs_lock);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static struct mddev *mdctl_find_mddev(struct mdu_ioctl *md_ctl)=0A=
+{=0A=
+	struct mddev *ret =3D ERR_PTR(-EINVAL);=0A=
+=0A=
+	/*=0A=
+	 * md_alloc() adds a new mddev to all_mddevs before it creates the=0A=
+	 * gendisk. If creation fails. it frees the mddev directly, without=0A=
+	 * looking at ->active. All of this happens under disks_mutex.=0A=
+	 * Holding disks_mutex for the lookup means we only see mddevs that=0A=
+	 * md_alloc() has finished, so taking a reference is safe and every=0A=
+	 * mddev we find has a gendisk.=0A=
+	 */=0A=
+	mutex_lock(&disks_mutex);=0A=
+=0A=
+	if (memchr_inv(md_ctl->uuid, 0, MD_UUID_LEN)) {=0A=
+		if (*md_ctl->name || md_ctl->dev) {=0A=
+			pr_err_ratelimited("md: only supply one of name, uuid or dev number\n")=
;=0A=
+			goto out;=0A=
+		}=0A=
+		ret =3D mdctl_get_mddev_uuid(md_ctl->uuid);=0A=
+	} else if (*md_ctl->name) {=0A=
+		if (md_ctl->dev) {=0A=
+			pr_err_ratelimited("md: only supply one of name, uuid or dev number\n")=
;=0A=
+			goto out;=0A=
+		}=0A=
+		ret =3D mdctl_get_mddev_name(md_ctl->name);=0A=
+	} else if (md_ctl->dev) {=0A=
+		ret =3D mdctl_get_mddev_dev(new_decode_dev(md_ctl->dev));=0A=
+	}=0A=
+=0A=
+out:=0A=
+	mutex_unlock(&disks_mutex);=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static int mdctl_get_raid_version(struct mdu_version64 __user *user)=0A=
+{=0A=
+	struct mdu_version64 v =3D {0};=0A=
+=0A=
+	v.major =3D MD_MAJOR_VERSION;=0A=
+	v.minor =3D MD_MINOR_VERSION;=0A=
+	v.patchlevel =3D MD_PATCHLEVEL_VERSION;=0A=
+=0A=
+	if (copy_to_user(user, &v, sizeof(v)))=0A=
+		return -EFAULT;=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int mdctl_get_array_info(struct mddev *mddev, void __user *arg)=0A=
+{=0A=
+	struct mdu_array_info64 info =3D {0};=0A=
+	int nr, working, insync, failed, spare, journal;=0A=
+	struct md_rdev *rdev;=0A=
+=0A=
+	nr =3D working =3D insync =3D failed =3D spare =3D journal =3D 0;=0A=
+	rcu_read_lock();=0A=
+	rdev_for_each_rcu(rdev, mddev) {=0A=
+		nr++;=0A=
+		if (test_bit(Faulty, &rdev->flags)) {=0A=
+			failed++;=0A=
+		} else {=0A=
+			working++;=0A=
+			if (test_bit(In_sync, &rdev->flags))=0A=
+				insync++;=0A=
+			else if (test_bit(Journal, &rdev->flags))=0A=
+				journal++;=0A=
+			else=0A=
+				spare++;=0A=
+		}=0A=
+	}=0A=
+	rcu_read_unlock();=0A=
+=0A=
+	info.major_version =3D mddev->major_version;=0A=
+	info.minor_version =3D mddev->minor_version;=0A=
+	info.patch_version =3D MD_PATCHLEVEL_VERSION;=0A=
+	info.ctime         =3D mddev->ctime;=0A=
+	info.level         =3D mddev->level;=0A=
+	info.size          =3D mddev->dev_sectors / 2;=0A=
+	info.nr_disks      =3D nr;=0A=
+	info.raid_disks    =3D mddev->raid_disks;=0A=
+	info.md_minor      =3D mddev->md_minor;=0A=
+	info.not_persistent =3D !mddev->persistent;=0A=
+=0A=
+	info.utime         =3D mddev->utime;=0A=
+	info.state         =3D 0;=0A=
+	if (mddev->in_sync)=0A=
+		info.state =3D (1 << MD_SB_CLEAN);=0A=
+	if (mddev->bitmap && mddev->bitmap_info.offset)=0A=
+		info.state |=3D (1 << MD_SB_BITMAP_PRESENT);=0A=
+	if (mddev_is_clustered(mddev))=0A=
+		info.state |=3D (1 << MD_SB_CLUSTERED);=0A=
+	info.active_disks  =3D insync;=0A=
+	info.working_disks =3D working;=0A=
+	info.failed_disks  =3D failed;=0A=
+	info.spare_disks   =3D spare;=0A=
+	info.journal_disks =3D journal;=0A=
+=0A=
+	info.layout        =3D mddev->layout;=0A=
+	info.chunk_size    =3D mddev->chunk_sectors << 9;=0A=
+=0A=
+	if (copy_to_user(arg, &info, sizeof(info)))=0A=
+		return -EFAULT;=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int mdctl_get_disk_info(struct mddev *mddev, void __user *arg)=0A=
+{=0A=
+	struct mdu_disk_info64 info =3D {0};=0A=
+	struct md_rdev *rdev;=0A=
+=0A=
+	if (copy_from_user(&info, arg, sizeof(info)))=0A=
+		return -EFAULT;=0A=
+=0A=
+	rcu_read_lock();=0A=
+	rdev =3D md_find_rdev_nr_rcu(mddev, info.number);=0A=
+	if (rdev) {=0A=
+		info.major =3D MAJOR(rdev->bdev->bd_dev);=0A=
+		info.minor =3D MINOR(rdev->bdev->bd_dev);=0A=
+		info.raid_disk =3D rdev->raid_disk;=0A=
+		info.state =3D 0;=0A=
+		if (test_bit(Faulty, &rdev->flags))=0A=
+			info.state |=3D (1 << MD_DISK_FAULTY);=0A=
+		else if (test_bit(In_sync, &rdev->flags)) {=0A=
+			info.state |=3D (1 << MD_DISK_ACTIVE);=0A=
+			info.state |=3D (1 << MD_DISK_SYNC);=0A=
+		}=0A=
+		if (test_bit(Journal, &rdev->flags))=0A=
+			info.state |=3D (1 << MD_DISK_JOURNAL);=0A=
+		if (test_bit(WriteMostly, &rdev->flags))=0A=
+			info.state |=3D (1 << MD_DISK_WRITEMOSTLY);=0A=
+		if (test_bit(FailFast, &rdev->flags))=0A=
+			info.state |=3D (1 << MD_DISK_FAILFAST);=0A=
+	} else {=0A=
+		info.major =3D info.minor =3D 0;=0A=
+		info.raid_disk =3D -1;=0A=
+		info.state =3D (1 << MD_DISK_REMOVED);=0A=
+	}=0A=
+	rcu_read_unlock();=0A=
+=0A=
+	if (copy_to_user(arg, &info, sizeof(info)))=0A=
+		return -EFAULT;=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int mdctl_set_array_info(struct mddev *mddev,=0A=
+				struct mdu_array_info64 __user *user)=0A=
+{=0A=
+	struct mdu_array_info64 info;=0A=
+	int err;=0A=
+=0A=
+	if (!user)=0A=
+		memset(&info, 0, sizeof(info));=0A=
+	else if (copy_from_user(&info, user, sizeof(info)))=0A=
+		return -EFAULT;=0A=
+=0A=
+	if (mddev->pers) {=0A=
+		err =3D update_array_info(mddev, &info);=0A=
+		if (err)=0A=
+			pr_warn("md: couldn't update array info. %d\n", err);=0A=
+		return err;=0A=
+	}=0A=
+=0A=
+	if (!list_empty(&mddev->disks)) {=0A=
+		pr_warn("md: array %s already has disks!\n", mdname(mddev));=0A=
+		return -EBUSY;=0A=
+	}=0A=
+=0A=
+	if (mddev->raid_disks) {=0A=
+		pr_warn("md: array %s already initialised!\n", mdname(mddev));=0A=
+		return -EBUSY;=0A=
+	}=0A=
+=0A=
+	err =3D md_set_array_info(mddev, &info);=0A=
+	if (err)=0A=
+		pr_warn("md: couldn't set array info. %d\n", err);=0A=
+=0A=
+	return err;=0A=
+}=0A=
+=0A=
+/*=0A=
+ * Return true if @cmd needs a configured array, false otherwise.=0A=
+ */=0A=
+static bool mdctl_ioctl_need_config(unsigned int cmd, u32 flags)=0A=
+{=0A=
+	switch (cmd) {=0A=
+	case MD_CTL_HOT_ADD_DISK:=0A=
+	case MD_CTL_HOT_REMOVE_DISK:=0A=
+	case MD_CTL_RESTART_ARRAY_RW:=0A=
+	case MD_CTL_CLUSTERED_DISK_NACK:=0A=
+		return true;=0A=
+=0A=
+	case MD_CTL_STOP_ARRAY:=0A=
+		/* switching to read-only needs an array, a full stop does not */=0A=
+		return !!(flags & MD_CTL_RO_FLAG);=0A=
+=0A=
+	default:=0A=
+		return false;=0A=
+	}=0A=
+}=0A=
+=0A=
+static bool mdctl_ioctl_need_suspend(unsigned int cmd)=0A=
+{=0A=
+	switch (cmd) {=0A=
+	case MD_CTL_ADD_NEW_DISK:=0A=
+	case MD_CTL_HOT_ADD_DISK:=0A=
+	case MD_CTL_HOT_REMOVE_DISK:=0A=
+	case MD_CTL_SET_BITMAP_FILE:=0A=
+	case MD_CTL_SET_ARRAY_INFO:=0A=
+		return true;=0A=
+	default:=0A=
+		return false;=0A=
+	}=0A=
+}=0A=
+=0A=
+static int mdctl_ioctl_valid(unsigned int cmd)=0A=
+{=0A=
+	switch (cmd) {=0A=
+	case MD_CTL_RAID_VERSION:=0A=
+	case MD_CTL_GET_ARRAY_INFO:=0A=
+	case MD_CTL_GET_DISK_INFO:=0A=
+		return 0;=0A=
+=0A=
+	case MD_CTL_SET_DISK_FAULTY:=0A=
+	case MD_CTL_GET_BITMAP_FILE:=0A=
+	case MD_CTL_ADD_NEW_DISK:=0A=
+	case MD_CTL_HOT_ADD_DISK:=0A=
+	case MD_CTL_HOT_REMOVE_DISK:=0A=
+	case MD_CTL_RESTART_ARRAY_RW:=0A=
+	case MD_CTL_RUN_ARRAY:=0A=
+	case MD_CTL_SET_ARRAY_INFO:=0A=
+	case MD_CTL_SET_BITMAP_FILE:=0A=
+	case MD_CTL_STOP_ARRAY:=0A=
+	case MD_CTL_CLUSTERED_DISK_NACK:=0A=
+		if (!capable(CAP_SYS_ADMIN))=0A=
+			return -EACCES;=0A=
+		return 0;=0A=
+	default:=0A=
+		return -ENOTTY;=0A=
+	}=0A=
+}=0A=
+=0A=
+static int mdctl_flags_valid(unsigned int cmd, u32 flags)=0A=
+{=0A=
+	switch (cmd) {=0A=
+	case MD_CTL_RAID_VERSION:=0A=
+	case MD_CTL_GET_ARRAY_INFO:=0A=
+	case MD_CTL_GET_DISK_INFO:=0A=
+	case MD_CTL_GET_BITMAP_FILE:=0A=
+	case MD_CTL_ADD_NEW_DISK:=0A=
+	case MD_CTL_HOT_ADD_DISK:=0A=
+	case MD_CTL_HOT_REMOVE_DISK:=0A=
+	case MD_CTL_RESTART_ARRAY_RW:=0A=
+	case MD_CTL_RUN_ARRAY:=0A=
+	case MD_CTL_SET_ARRAY_INFO:=0A=
+	case MD_CTL_SET_BITMAP_FILE:=0A=
+	case MD_CTL_SET_DISK_FAULTY:=0A=
+	case MD_CTL_CLUSTERED_DISK_NACK:=0A=
+		if (flags)=0A=
+			return -ENOTTY;=0A=
+		return 0;=0A=
+	case MD_CTL_STOP_ARRAY:=0A=
+		if (flags && flags !=3D MD_CTL_RO_FLAG)=0A=
+			return -ENOTTY;=0A=
+		return 0;=0A=
+	default:=0A=
+		return -ENOTTY;=0A=
+	}=0A=
+}=0A=
+=0A=
+static long mdctl_ioctl(struct file *filp, uint cmd, ulong u)=0A=
+{=0A=
+	int err;=0A=
+	unsigned int noio_flags =3D 0;=0A=
+	struct mddev *mddev;=0A=
+	void __user *arg;=0A=
+	struct mdu_ioctl md_ctl;=0A=
+	bool closing =3D false;=0A=
+	bool suspend;=0A=
+	u32 flags;=0A=
+=0A=
+	err =3D mdctl_ioctl_valid(cmd);=0A=
+	if (err)=0A=
+		return err;=0A=
+=0A=
+	/*=0A=
+	 * Commands dealing with the RAID driver but not any=0A=
+	 * particular array:=0A=
+	 */=0A=
+	if (cmd =3D=3D MD_CTL_RAID_VERSION)=0A=
+		return mdctl_get_raid_version((struct mdu_version64 __user *)u);=0A=
+=0A=
+	if (copy_from_user(&md_ctl, (void __user *)u, sizeof(md_ctl)))=0A=
+		return -EFAULT;=0A=
+=0A=
+	flags =3D md_ctl.flags;=0A=
+=0A=
+	/*=0A=
+	 * for now, Only MD_CTL_STOP_ARRAY takes flags; other commands need=0A=
+	 * flags =3D=3D 0.=0A=
+	 */=0A=
+	err =3D mdctl_flags_valid(cmd, flags);=0A=
+	if (err)=0A=
+		return err;=0A=
+=0A=
+	mddev =3D mdctl_find_mddev(&md_ctl);=0A=
+	if (IS_ERR(mddev))=0A=
+		return PTR_ERR(mddev);=0A=
+=0A=
+	arg =3D u64_to_user_ptr(md_ctl.arg);=0A=
+=0A=
+	/* These commands do not need reconfig_mutex. */=0A=
+	err =3D -ENODEV;=0A=
+	switch (cmd) {=0A=
+	case MD_CTL_GET_ARRAY_INFO:=0A=
+		if (mddev_configured(mddev))=0A=
+			err =3D mdctl_get_array_info(mddev, arg);=0A=
+		goto out;=0A=
+=0A=
+	case MD_CTL_GET_DISK_INFO:=0A=
+		if (mddev_configured(mddev))=0A=
+			err =3D mdctl_get_disk_info(mddev, arg);=0A=
+		goto out;=0A=
+=0A=
+	case MD_CTL_GET_BITMAP_FILE:=0A=
+		err =3D get_bitmap_file(mddev, arg);=0A=
+		goto out;=0A=
+=0A=
+	case MD_CTL_SET_DISK_FAULTY:=0A=
+		err =3D set_disk_faulty(mddev, new_decode_dev(md_ctl.arg));=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	if (cmd =3D=3D MD_CTL_STOP_ARRAY) {=0A=
+		/* Need to flush page cache, and ensure no openers */=0A=
+		err =3D mddev_set_closing_and_sync_blockdev(mddev, 0);=0A=
+		if (err)=0A=
+			goto out;=0A=
+=0A=
+		closing =3D true;=0A=
+	}=0A=
+=0A=
+	if (!md_is_rdwr(mddev))=0A=
+		flush_work(&mddev->sync_work);=0A=
+=0A=
+	suspend =3D mdctl_ioctl_need_suspend(cmd);=0A=
+	err =3D suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);=0A=
+	if (err) {=0A=
+		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",=0A=
+			 err, cmd);=0A=
+		goto out;=0A=
+	}=0A=
+	if (suspend)=0A=
+		noio_flags =3D memalloc_noio_save();=0A=
+=0A=
+	/*=0A=
+	 * Commands querying/configuring an existing array.=0A=
+	 *=0A=
+	 * If the array is not initialised yet, check of the command requires=0A=
+	 * the array to be initialised.=0A=
+	 */=0A=
+	if (!mddev_configured(mddev) && mdctl_ioctl_need_config(cmd, flags)) {=0A=
+		err =3D -ENODEV;=0A=
+		goto unlock;=0A=
+	}=0A=
+=0A=
+	/*=0A=
+	 * Commands even a read-only array can execute:=0A=
+	 */=0A=
+	switch (cmd) {=0A=
+	case MD_CTL_SET_ARRAY_INFO:=0A=
+		err =3D mdctl_set_array_info(mddev, arg);=0A=
+		goto unlock;=0A=
+=0A=
+	case MD_CTL_RESTART_ARRAY_RW:=0A=
+		err =3D restart_array(mddev);=0A=
+		goto unlock;=0A=
+=0A=
+	case MD_CTL_STOP_ARRAY:=0A=
+		err =3D -EINVAL;=0A=
+		if (!flags)=0A=
+			err =3D do_md_stop(mddev, 0);=0A=
+		else if (flags =3D=3D MD_CTL_RO_FLAG && mddev->pers)=0A=
+			err =3D md_set_readonly(mddev);=0A=
+		goto unlock;=0A=
+=0A=
+	case MD_CTL_HOT_REMOVE_DISK:=0A=
+		err =3D hot_remove_disk(mddev, new_decode_dev(md_ctl.arg));=0A=
+		goto unlock;=0A=
+=0A=
+	case MD_CTL_ADD_NEW_DISK:=0A=
+		/* We can support ADD_NEW_DISK on read-only arrays=0A=
+		 * only if we are re-adding a preexisting device.=0A=
+		 * So require mddev->pers and MD_DISK_SYNC.=0A=
+		 */=0A=
+		if (mddev->pers) {=0A=
+			struct mdu_disk_info64 info;=0A=
+=0A=
+			if (copy_from_user(&info, arg, sizeof(info)))=0A=
+				err =3D -EFAULT;=0A=
+			else if (!(info.state & (1 << MD_DISK_SYNC)))=0A=
+				/* Need to clear read-only for this */=0A=
+				break;=0A=
+			else=0A=
+				err =3D md_add_new_disk(mddev, &info);=0A=
+			goto unlock;=0A=
+		}=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	/*=0A=
+	 * The remaining ioctls are changing the state of the=0A=
+	 * superblock, so we do not allow them on read-only arrays.=0A=
+	 */=0A=
+	if (!md_is_rdwr(mddev) && mddev->pers) {=0A=
+		if (mddev->ro !=3D MD_AUTO_READ) {=0A=
+			err =3D -EROFS;=0A=
+			goto unlock;=0A=
+		}=0A=
+		mddev->ro =3D MD_RDWR;=0A=
+		sysfs_notify_dirent_safe(mddev->sysfs_state);=0A=
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);=0A=
+		/* mddev_unlock will wake thread */=0A=
+		/* If a device failed while we were read-only, we=0A=
+		 * need to make sure the metadata is updated now.=0A=
+		 */=0A=
+		if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {=0A=
+			mddev_unlock(mddev);=0A=
+			wait_event(mddev->sb_wait,=0A=
+				   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&=0A=
+				   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));=0A=
+			mddev_lock_nointr(mddev);=0A=
+		}=0A=
+	}=0A=
+=0A=
+	switch (cmd) {=0A=
+	case MD_CTL_ADD_NEW_DISK:=0A=
+	{=0A=
+		struct mdu_disk_info64 info;=0A=
+=0A=
+		if (copy_from_user(&info, arg, sizeof(info)))=0A=
+			err =3D -EFAULT;=0A=
+		else=0A=
+			err =3D md_add_new_disk(mddev, &info);=0A=
+=0A=
+		goto unlock;=0A=
+	}=0A=
+=0A=
+	case MD_CTL_CLUSTERED_DISK_NACK:=0A=
+		if (mddev_is_clustered(mddev))=0A=
+			mddev->cluster_ops->new_disk_ack(mddev, false);=0A=
+		else=0A=
+			err =3D -EINVAL;=0A=
+		goto unlock;=0A=
+=0A=
+	case MD_CTL_HOT_ADD_DISK:=0A=
+		err =3D hot_add_disk(mddev, new_decode_dev(md_ctl.arg));=0A=
+		goto unlock;=0A=
+=0A=
+	case MD_CTL_RUN_ARRAY:=0A=
+		err =3D do_md_run(mddev);=0A=
+		goto unlock;=0A=
+=0A=
+	case MD_CTL_SET_BITMAP_FILE:=0A=
+		err =3D set_bitmap_file(mddev, md_ctl.arg);=0A=
+		goto unlock;=0A=
+=0A=
+	default:=0A=
+		err =3D -EINVAL;=0A=
+		goto unlock;=0A=
+	}=0A=
+=0A=
+unlock:=0A=
+	if (!err && mddev->hold_active =3D=3D UNTIL_IOCTL)=0A=
+		mddev->hold_active =3D 0;=0A=
+=0A=
+	if (suspend) {=0A=
+		memalloc_noio_restore(noio_flags);=0A=
+		mddev_unlock_and_resume(mddev);=0A=
+	} else {=0A=
+		mddev_unlock(mddev);=0A=
+	}=0A=
+out:=0A=
+	if (closing && (err || flags =3D=3D MD_CTL_RO_FLAG))=0A=
+		clear_bit(MD_CLOSING, &mddev->flags);=0A=
+=0A=
+	mddev_put(mddev);=0A=
+	return err;=0A=
+}=0A=
+=0A=
+static const struct file_operations mdctl_file_ops =3D {=0A=
+	.open =3D nonseekable_open,=0A=
+	.unlocked_ioctl =3D mdctl_ioctl,=0A=
+	.compat_ioctl =3D compat_ptr_ioctl,=0A=
+	.owner =3D THIS_MODULE,=0A=
+	.llseek  =3D noop_llseek,=0A=
+};=0A=
+=0A=
+static struct miscdevice mdctl_misc =3D {=0A=
+	.name =3D MD_CTL_NODE,=0A=
+	.minor =3D MISC_DYNAMIC_MINOR,=0A=
+	.fops =3D &mdctl_file_ops,=0A=
+};=0A=
+=0A=
+static int __init mdctl_init(void)=0A=
+{=0A=
+	return misc_register(&mdctl_misc);=0A=
+}=0A=
+=0A=
+static void __exit mdctl_exit(void)=0A=
+{=0A=
+	misc_deregister(&mdctl_misc);=0A=
+}=0A=
+=0A=
 static int md_set_read_only(struct block_device *bdev, bool ro)=0A=
 {=0A=
 	struct mddev *mddev =3D bdev->bd_disk->private_data;=0A=
@@ -10815,12 +11409,19 @@ static int __init md_init(void)=0A=
 		goto err_mdp;=0A=
 	mdp_major =3D ret;=0A=
 =0A=
+	ret =3D mdctl_init();=0A=
+	if (ret < 0)=0A=
+		goto err_ctl;=0A=
+=0A=
 	register_reboot_notifier(&md_notifier);=0A=
 	raid_table_header =3D register_sysctl("dev/raid", raid_table);=0A=
 =0A=
 	md_geninit();=0A=
 	return 0;=0A=
 =0A=
+err_ctl:=0A=
+	unregister_blkdev(mdp_major, "mdp");=0A=
+	mdp_major =3D 0;=0A=
 err_mdp:=0A=
 	unregister_blkdev(MD_MAJOR, "md");=0A=
 err_md:=0A=
@@ -11098,6 +11699,7 @@ static __exit void md_exit(void)=0A=
 	struct mddev *mddev;=0A=
 	int delay =3D 1;=0A=
 =0A=
+	mdctl_exit();=0A=
 	unregister_blkdev(MD_MAJOR,"md");=0A=
 	unregister_blkdev(mdp_major, "mdp");=0A=
 	unregister_reboot_notifier(&md_notifier);=0A=
diff --git a/drivers/md/md.h b/drivers/md/md.h=0A=
index 27de34a8bdf9..0dfae7b86830 100644=0A=
--- a/drivers/md/md.h=0A=
+++ b/drivers/md/md.h=0A=
@@ -996,6 +996,15 @@ static inline void rdev_record_write_error(struct md_r=
dev *rdev)=0A=
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);=0A=
 }=0A=
 =0A=
+/*=0A=
+ * Return true if array is configured or its metadata is managed by user s=
pace,=0A=
+ * false otherwise.=0A=
+ */=0A=
+static inline bool mddev_configured(struct mddev *mddev)=0A=
+{=0A=
+	return mddev->raid_disks || mddev->external;=0A=
+}=0A=
+=0A=
 static inline int mddev_is_clustered(struct mddev *mddev)=0A=
 {=0A=
 	return mddev->cluster_info && mddev->bitmap_info.nodes > 1;=0A=
-- =0A=
2.43.0=0A=
=0A=
