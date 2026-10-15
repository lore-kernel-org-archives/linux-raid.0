Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020107.outbound.protection.outlook.com [52.101.201.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516303D9DC3;
	Thu, 15 Oct 2026 20:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097292; cv=fail; b=ZyBSy/717jePJbRh1tJsmlSl519O3+GrZcgUwjaM/iwtGGsiDiuVKIJIAjgToxrj9+eMH5ZTKAfXxjhmlNb5+WErkjRUe3VnqsaMx5giyzDP6yuUl4YCbTRAFCfcbhYq5zGAS5h3ocTyupB3TIfsZzu+mchfDMA52jpo7xaBFSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097292; c=relaxed/simple;
	bh=NJrCJhDCLXvPoPjztj156voMm/3tBlYsrlmGpiIpS7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MWF96istFSabkEcfZnrDtioAC0BMUIlAyHm6Ch/kha7eG82XxIpo1s35Ew9oOMRP/BhY+DwmKl5LpnA/FfL4PiDoR9+TYxSJVzgusjDGtqTOks7qsJyCziEK4eAlmfigf/i2T5R8TvsLaLVlAhCv8ydfQ+gmPpYzE0oBp4zg640=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=190NdtA6; arc=fail smtp.client-ip=52.101.201.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="190NdtA6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HoI//lw3O26zsp7lWCTxcDktU0UVaWNX07cjZxnXvKvYuUqjn33/TpfaNnOYrtemPfkupxUkZV6tUsKRVt5/jJGAuAVV3z3tIKvHIlhBtcK2ChnQhUgBO2QVwf3haGW9JJj/XxeQ9LyD+RtBh+ddkl2xmuR44ORNOkl/qCLVSDHR8L8YfXdH2h98qWB3L2H53+iwSJ/iQVr39ksu0AXZ2dvAddWgruPoO9XHi9tcKow8j0sJsuQ3yTIOzwr6krwV5CS02j6QzuB5DryUKGOd6XTPY4XcUtXNGe2d2nmZ173GSM4v1cjSUDEQs1koiXOgdPsXJ7TrK0bOWbR/XD/Kzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpZo6ZJ/tko8DSQkzR3itj6IN/opb7ffVvq3qCA513Y=;
 b=jRp56WDQYUN89J0YcGuhozgRgtQLI9HLPi+1AV+lWlJl9wypypzMHHn6DEoBQO/qCQ3KVCClcx0Ug8p99/JP36BaO9lvEI1Fyiuc/s/4eAOkhPI0kF84QT0taQZVq6KTeRYSZH6OqrS5Wv7yKvvRc2gd9L9TtKiztr6zpGPKTTeMMQ1ShlXkwLDq2XoP25IZU3HbEJYkf6YYW0IWJuCuLdOPLMX4LG0Sfoa5nP11FbiZhq8yw2qJIUTAWqOQYIGZGkt/J3TvIJxoviWNOStlX/LlX0Yxh/HQR6CVN+WyTKXNwdA1px6y4kbDtIiv3WCl3e+QbuNlDnLFaooPVZv6kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpZo6ZJ/tko8DSQkzR3itj6IN/opb7ffVvq3qCA513Y=;
 b=190NdtA63RsqoIDB5qXMN51sasovtFGf5FvPbXdfZE88zFoZHJYBEZ7j/bvXXkJCkPlZUZz8rKPxIENcd3485yXNJDrLL7ejwHqvR8tWRJvJ0xCe5VJrzF6EUnsL5ILbc8KovWR93y7Sk4Wm2c+XgzX42Zn/eMYruRWRzzYBzlqmn1kHX642HX7H1ypkD/3uBJCTBISHVYsgGcl68G+DNlxEA7nPyjU8EYN+BndV2fz6dWA+RK7QOI/C4Pxz79N4vAhlMXVNOtEhCTDX4roIQB5Nyc6q/w7tzKpioB7RKATOLSnfsSzTQoFIiBTAwdOp8+n4yWfIu5BmQGvUZAoQKw==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by DM6PR07MB7226.namprd07.prod.outlook.com (2603:10b6:5:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 20:48:06 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 20:48:06 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	"magiclinan@didiglobal.com" <magiclinan@didiglobal.com>, "xiao@kernel.org"
	<xiao@kernel.org>, "abd.masalkhi@gmail.com" <abd.masalkhi@gmail.com>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Masalkhi, Abd
 Alrhman" <abd.masalkhi@gatech.edu>
Subject: [RFC PATCH v4 2/4] md: pass struct mdu_disk_info64 to
 md_add_new_disk()
Thread-Topic: [RFC PATCH v4 2/4] md: pass struct mdu_disk_info64 to
 md_add_new_disk()
Thread-Index: AQHdXOZ6XlR75W8O3UeaZa6ZYPCfNw==
Date: Thu, 15 Oct 2026 20:48:06 +0000
Message-ID: <20261015204640.1184848-3-abd.masalkhi@gatech.edu>
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
x-ms-office365-filtering-correlation-id: a95400b2-a7f9-4056-4700-08df2afd9d27
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|786006|38070700021|56012099006|11063799006|261009221227099003|261009221727099003|261009223327099003|261009223027099003|261009220027099003|10067099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 QGAMD8FqC+9/wJYmwh/OaM1QTmayZUOjbEKxmSYT6mJ1Qnug4ufzdtEv9RnE5KMGx0AhEm9Zy40XkIy2gm50lGvWJAKb/5vYslqo2jpUdggv+obcFiu1ztdpxQNNasLL4yUl3dkww+5UF7zCoPNamKuVkmDva6VPrppk/UbJpFKaTmBjeZYVIWN4+x07BcoHaKkqJ9rGHBjrbPhn4hQiXzditwzBXKpwcEd7OGCysa/Oe9GUsRVNVVHl8WXDxnv/afmhfpj1X+Ajbtm5y/S5jhuWgcKTx52LgWCOcgXZMqz1aAwN6Gv20TWi6w8T/SHeH0xHT7ivLvKoEm3QZ2upkD4xlCAxtCDkEwLgU2C9ohPZO2bYKqjkv2tKMXPAbFhPy108cBejfDysVW87D82VqOiZ2vnO4GG6rAJs2FQUFtZNqWd7OqDA0Jg7fY4mQWmj+eUeVn7hdhML5n0M3EaqcP/49aZDneyGoqOCASzefgMaTKNmLeoVhgqqeAaD5pVt2UKOMvA6VYVqpyvoIPJcztOJSkO52ilVuAslXuZlDD4RTwVgBgXy0y7Rs0RsYgNTv99Vdowu/+zLSIdOvD/hZzSdXR/uiKof/NXoKE3ihhEneAnQTcbJcXqOlJSqpq7ZtCnPh2syIMI2lYzssghwpw1S6F5D9Dye6H7YKgc9sd/zx1JzU+A9Y58KKajcCUHWaPRLm0yeC/MTxDtZ/E+/cc3uTzmxorUPW5thIOaacD8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(786006)(38070700021)(56012099006)(11063799006)(261009221227099003)(261009221727099003)(261009223327099003)(261009223027099003)(261009220027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?pmgytPxUlenyHdPASaCuM4yljGoWnQkd93SVn6TvYy8kVrsJ7m9WaaigFP?=
 =?iso-8859-1?Q?Xk6PMHmYJKrGBIkVvr3/OcELv+/jXXtuy+Yw9ITJQ7lEPYP7xWFtls0pGU?=
 =?iso-8859-1?Q?8wn84CCfB6PzmJxoICJmiReMlm8FZ1BSa6TrMHxGQE5m4/WjcXY2NzT5Cf?=
 =?iso-8859-1?Q?nzuOvoyW+6Si03v+KysqcyNN8KTuGI8A6t9/ALppocMSRvQW6gflCnnsVC?=
 =?iso-8859-1?Q?l43RlBCINRHEfLFUjG0crltFgKYcpLnI5aZ1Tr2oC4SkwIasKUa4EsNKmE?=
 =?iso-8859-1?Q?1+siHEpbURe4v7G799AbkvK9HnXhl02yliJnOCOaE+U1AKPecYcq/6Scr9?=
 =?iso-8859-1?Q?4DMigCeSrzQMqmFLjx+oDBxf0LdPhpldfg7/N35+TMwx9ehmSlKEeTxYnA?=
 =?iso-8859-1?Q?mdYZe+pi534rc6RTnSMjcdTNARo5llZDfel1A/st9tH6HLqkyMVYn395Ot?=
 =?iso-8859-1?Q?w9FpuI2jZHBZKx+OE1oW7Aw+ENtx2Q+dcmYo0BDhzzTOUtLOcRlGnnprpp?=
 =?iso-8859-1?Q?6lxVd3xoHvJp5IG9su6ypD9XQwUJsCICLHHSpUq8Ci6mHIT1TK0MJU63xY?=
 =?iso-8859-1?Q?myD8T6fKmphWsbvl4IBD+iGjMJJXFzun8YuoZZL7/TJNWlm5nahvVxhXs9?=
 =?iso-8859-1?Q?IvePQhHaiUqGO8jNH4w8oxmkZswnOrIoD6XJdc63+CGiEdzqlUqRL5JM83?=
 =?iso-8859-1?Q?tuASO8xEYRU8oL7AX/coDuLwDWoGdsD9k61rfzzd1OqU08Voy6YPHNNT45?=
 =?iso-8859-1?Q?IkNpkyKbNy0ND7g3OJ8vuqdqViDnhD0SIsjclGpMQ7CT+eMHAR7I57PAXX?=
 =?iso-8859-1?Q?XiLST9IMCpOVpYfmxidECihXFxUnksGZqWv0kkB3ept//iCl8lO0ELu90f?=
 =?iso-8859-1?Q?F2+Kmsu4rPDAWmtoCyq9m08OpsOcZs1wVjbJ/1za4M8tXVjgOYFNN8PYC6?=
 =?iso-8859-1?Q?GIo2B2GD61S/O8d7Uo2TL5QNurv3Hnlq6xiKYn1A02uhVwOp3unMiPb2Vy?=
 =?iso-8859-1?Q?zzeYGnFQhNX0KnQifGi4jdkBkbgipwZHFKOMYaw7RT/PFqoyHF/irk6z4B?=
 =?iso-8859-1?Q?7kajdCFES6MNS5LqPAKJZL6W4UGfGnSvlBnIf0uCo+zBHhPAsI3PBDH9pF?=
 =?iso-8859-1?Q?dqXuejsSl0yWqd1zNpi9Wuu5adArv1XT7A3ffceDyE6Y25M8wdk4PBBdeW?=
 =?iso-8859-1?Q?Lex1CmsWVv5eciPXv8904hLUaK0XtJgzh5DsGrb/q1NQpVtN+w6qOLTG4a?=
 =?iso-8859-1?Q?/YDm8x6JU2ouCB6V8P6/xNlpbxq7Ini+ExwtWq+8ZhKwVt+jSSNBMb41qk?=
 =?iso-8859-1?Q?wUeUIU/bPqkekcavEqh3E+hPWbal8DthRu1qeVeN17nzwTY76jvtNZq5rT?=
 =?iso-8859-1?Q?W2/UmOlCRhrt0aFrasyYDpL2/p+G7unzcRexMWAgsCvLPf1l/roTpK8P61?=
 =?iso-8859-1?Q?gnB2YYcVOATy8uga7gZYomhqh/2j8A2mpMhAl8oppgfLbeVa3zTRILjN7K?=
 =?iso-8859-1?Q?JPla3jWJGRLtjaTbJNMVGMEBQjHU8tN2u/jCc40wI/ki74qjQQdGIvOZWa?=
 =?iso-8859-1?Q?LBiR3e9FNP0Hv54yfcnEKCGurjgYlTDqpg2OlI6zVwUOz+jOokuyTY9fnu?=
 =?iso-8859-1?Q?bluJTlRFEyIzXr1setKKl6csnoLqiEcZWlFE+vO1yOSxUfr7BQ+sJEUBMi?=
 =?iso-8859-1?Q?sM53RoBUGIK5p7Mav7vevIuC+wUpePrO2BY2iPsJNcaSmn6yqqAzs0J8aB?=
 =?iso-8859-1?Q?pFnUUKm0kjGRD0vHU3zO9hAbDpcof2BF0ST0m38+5VCP85wz/W/I5cHyb5?=
 =?iso-8859-1?Q?0P4fVIZIDA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a95400b2-a7f9-4056-4700-08df2afd9d27
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 20:48:06.1396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A7HRnoc7PP99RfSxFfKur4Htm2Yn/dTQPF3qyUFb11/a9NTTmXXuLsDKTchJ+eN10Qdr41pGvrC5wY+6mznkMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB7226

From: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
=0A=
The md control device passes disk information as struct mdu_disk_info64.=0A=
Make md_add_new_disk() take this structure, so that the control device=0A=
and the old ADD_NEW_DISK ioctl can share it.=0A=
=0A=
The ADD_NEW_DISK ioctl converts its mdu_disk_info_t with the new helper=0A=
convert_to_disk_info64(), and md_setup_drive() uses a struct=0A=
mdu_disk_info64 directly.=0A=
=0A=
No functional change.=0A=
=0A=
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
---=0A=
 drivers/md/md-autodetect.c |  2 +-=0A=
 drivers/md/md.c            | 26 +++++++++++++++++++++-----=0A=
 drivers/md/md.h            |  4 ++--=0A=
 3 files changed, 24 insertions(+), 8 deletions(-)=0A=
=0A=
diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c=0A=
index 4b80165afd23..9ba061f1a628 100644=0A=
--- a/drivers/md/md-autodetect.c=0A=
+++ b/drivers/md/md-autodetect.c=0A=
@@ -201,7 +201,7 @@ static void __init md_setup_drive(struct md_setup_args =
*args)=0A=
 	err =3D md_set_array_info(mddev, &ainfo);=0A=
 =0A=
 	for (i =3D 0; i <=3D MD_SB_DISKS && devices[i]; i++) {=0A=
-		struct mdu_disk_info_s dinfo =3D {=0A=
+		struct mdu_disk_info64 dinfo =3D {=0A=
 			.major	=3D MAJOR(devices[i]),=0A=
 			.minor	=3D MINOR(devices[i]),=0A=
 		};=0A=
diff --git a/drivers/md/md.c b/drivers/md/md.c=0A=
index 154ee5a65cb7..be1634ae1d09 100644=0A=
--- a/drivers/md/md.c=0A=
+++ b/drivers/md/md.c=0A=
@@ -7486,7 +7486,7 @@ static int get_disk_info(struct mddev *mddev, void __=
user * arg)=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)=0A=
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info64 *info)=0A=
 {=0A=
 	struct md_rdev *rdev;=0A=
 	dev_t dev =3D MKDEV(info->major,info->minor);=0A=
@@ -8305,6 +8305,16 @@ static bool md_ioctl_need_suspend(unsigned int cmd)=
=0A=
 	}=0A=
 }=0A=
 =0A=
+static void convert_to_disk_info64(struct mdu_disk_info64 *info64,=0A=
+				   mdu_disk_info_t *info)=0A=
+{=0A=
+	info64->number =3D info->number;=0A=
+	info64->major =3D info->major;=0A=
+	info64->minor =3D info->minor;=0A=
+	info64->raid_disk =3D info->raid_disk;=0A=
+	info64->state =3D info->state;=0A=
+}=0A=
+=0A=
 static int __md_set_array_info(struct mddev *mddev, void __user *argp)=0A=
 {=0A=
 	mdu_array_info_t info;=0A=
@@ -8452,13 +8462,16 @@ static int md_ioctl(struct block_device *bdev, blk_=
mode_t mode,=0A=
 		 */=0A=
 		if (mddev->pers) {=0A=
 			mdu_disk_info_t info;=0A=
+			struct mdu_disk_info64 info64 =3D {0};=0A=
 			if (copy_from_user(&info, argp, sizeof(info)))=0A=
 				err =3D -EFAULT;=0A=
 			else if (!(info.state & (1<<MD_DISK_SYNC)))=0A=
 				/* Need to clear read-only for this */=0A=
 				break;=0A=
-			else=0A=
-				err =3D md_add_new_disk(mddev, &info);=0A=
+			else {=0A=
+				convert_to_disk_info64(&info64, &info);=0A=
+				err =3D md_add_new_disk(mddev, &info64);=0A=
+			}=0A=
 			goto unlock;=0A=
 		}=0A=
 		break;=0A=
@@ -8493,10 +8506,13 @@ static int md_ioctl(struct block_device *bdev, blk_=
mode_t mode,=0A=
 	case ADD_NEW_DISK:=0A=
 	{=0A=
 		mdu_disk_info_t info;=0A=
+		struct mdu_disk_info64 info64 =3D {0};=0A=
 		if (copy_from_user(&info, argp, sizeof(info)))=0A=
 			err =3D -EFAULT;=0A=
-		else=0A=
-			err =3D md_add_new_disk(mddev, &info);=0A=
+		else {=0A=
+			convert_to_disk_info64(&info64, &info);=0A=
+			err =3D md_add_new_disk(mddev, &info64);=0A=
+		}=0A=
 		goto unlock;=0A=
 	}=0A=
 =0A=
diff --git a/drivers/md/md.h b/drivers/md/md.h=0A=
index 6440da292105..a84c8b97fa2c 100644=0A=
--- a/drivers/md/md.h=0A=
+++ b/drivers/md/md.h=0A=
@@ -1043,12 +1043,12 @@ static inline void mddev_unlock_and_resume(struct m=
ddev *mddev)=0A=
 }=0A=
 =0A=
 struct mdu_array_info_s;=0A=
-struct mdu_disk_info_s;=0A=
+struct mdu_disk_info64;=0A=
 =0A=
 extern int mdp_major;=0A=
 void md_autostart_arrays(int part);=0A=
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);=
=0A=
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);=0A=
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info64 *info);=0A=
 int do_md_run(struct mddev *mddev);=0A=
 #define MDDEV_STACK_INTEGRITY	(1u << 0)=0A=
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,=
=0A=
-- =0A=
2.43.0=0A=
=0A=
