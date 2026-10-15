Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020081.outbound.protection.outlook.com [52.101.85.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A903F54A7;
	Thu, 15 Oct 2026 20:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097287; cv=fail; b=Gq3QKTDUOBGa6knRHlM/pcjH7d950SffJv0CY6Wigm6AP6oxRgkWpy33B3ulRcJPbFVSo646+N1KQwwIhiwoDrwk/yjD5H4ggYigobqS5eAvUy74h97pIWT+uPy/tN4XNWC6DcFUxhPDPs0yrM9w2VkiSnUPq9lEAKaBzXYk1Gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097287; c=relaxed/simple;
	bh=5GnCg8Yintsq+bPc0hwRGXvgVCzhfVYe7mI8RfzvQcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ba2+DQaASZy32yxkaEYNDzRUfAustk27R8GLPSa4Q3LHzxYVGTIubfzt/T7Y1gl+VvVGC27uk6GMSlJXg8cRzPLLvZ3MsQo8UzLCyE1QOQuxuj8eCoVzyeSslhVAc6MtxC/+1TQ/PugiHfmcc1Jk7KyfwlvIrRdj0lA8YyQ4GDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=bMTq8XNf; arc=fail smtp.client-ip=52.101.85.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="bMTq8XNf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gjuf4epHuZ48eF0Yv9zvBHDG7gZCvN1Yluz7hZV9+qzPSueen/bxmD67xc2K8QzkeWHSjqOnwfRwR12s6fxCuwbusWMVY7jMmOTa9kjgi0tcKG+q05CfHyOCuIPBTdrCpLRj+c3e1pp/omALirXNCE44/PzDddjoXDDQ4k1fjqxwZ1oZ53uFYJYxbsFMc7WkNzE1qH2hgjxLKO8I8oEku/M+PXcRlPX40aokQYeGZ6B0JPX71HP6nxPPu4AIqiQV+Jq8ZLweuo4VTw0ge0KREtO/rdJgZdkBihkzueSxSmgzLJnTdnxBuduiQVo40ba2g23HtfYkeSLOW7KxMm5zsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLVYox+PivaFergq8UiLegMnxSeKdgAYvKvO0rBFzSc=;
 b=TJZIBbdFrk1JJk5pw5jAuL4UoJnD8/DJroHd85lc1Y51Nc4jZH+R6IZIdsE4r2scaQvBSp9OBUfG9SKNEBWqc59U9n5SLKNzT6rizTbkibrqunajAnuZuHp+0KxAiVDSNd9vqcCx/wUw/JUtfmZWdjNnyBtU1Flkzg/WT5AXZOEopf9f0bhHIGOEfEUooAU6WOC8NkAxNniCXMO8pCQXNwYoD5KgK1IRpOcv0fmexGYEYKymdfaaIqTHSNRdyKYhX4n45RZtJLaylLT+gPfSrxoUFBzgf8FH7Xo7IMBQdpj5zO8hsz3nfbH2AWL22DUgxXUuvQs2QxIR6R+KOz9ODw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLVYox+PivaFergq8UiLegMnxSeKdgAYvKvO0rBFzSc=;
 b=bMTq8XNfHgO8ZwScNcPla/NTdk4VM4ArAKpYrzL82iLajkYzz4Hc14736Op1tuQKryEZUzmFvrrkq4c7OGz6HhxSxySuaOMoVr5gJU+dyC5t7oXfb57P/ChBPAxt2yxDV1RHS8EO5m/vhyFHNhYQO1dTuAVhcAzgi2O9vpFmsM77s6y11jQx2uJ+bXZcKLvCmPQBIbg52eerUmL8EdTgnQEzpFwLW/ou99uyIx2YktNBh36YMYaLJvpOjbySrbSzJjgeXJ3aQeOuMtVG9dxSX0rgn09z5CW2hOQSppLeFzfZkHeIE52ZPZwYBLyZT4Hs1JxL82ewMIpa7OKCcBaZ6A==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by DM6PR07MB7226.namprd07.prod.outlook.com (2603:10b6:5:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 20:48:01 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 20:48:00 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	"magiclinan@didiglobal.com" <magiclinan@didiglobal.com>, "xiao@kernel.org"
	<xiao@kernel.org>, "abd.masalkhi@gmail.com" <abd.masalkhi@gmail.com>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Masalkhi, Abd
 Alrhman" <abd.masalkhi@gatech.edu>
Subject: [RFC PATCH v4 1/4] md: add uapi definitions for the md control device
Thread-Topic: [RFC PATCH v4 1/4] md: add uapi definitions for the md control
 device
Thread-Index: AQHdXOZ34eMoUnosXEyOBRuypH8AnA==
Date: Thu, 15 Oct 2026 20:48:00 +0000
Message-ID: <20261015204640.1184848-2-abd.masalkhi@gatech.edu>
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
x-ms-office365-filtering-correlation-id: 229a2942-7743-4919-50de-08df2afd99ba
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|786006|38070700021|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003|3023799007;
x-microsoft-antispam-message-info:
 MuxRGxJssAA5z02G2wmmVQtgfgLH3YUkW7RSoy7ztQ/PfEf07oqF7hANki3qPYxf+6B7EUPXFT91nYp1AsEictEKIGvn6RWWxay8FBh8thXHdEbQc6i6mZQz7zO2Manb2N4jbmtyIam3FMN2MHhLNGt+GbI9PyX/z+G27qliXWnV4ZuTIFbX5M16jJJhQM8XsOAft/vQLR/N4rm1pSCH2eAaKXf1jziAj1gGw+xa7e7IFt7k0jjiYc9GogdxzG/xa66KCH6iC2GvrZ1TyxVBYciGX5BtBcB3AEOJLHphS+WJ9JMG91XzPbIIYSEe0CdxBG8+Nofcx+bw7wlv/Ea6KW/XB3fCmZbHYm6c1IW29m93S1aiZKnBy2LOgMU8AxfWj9aX56onJaOVjZ2mnOtsxMHSsZ52N3zh49fRjwMxL6SQ4U1tsXPQTv+hiy83M/U77hW2eEnX8+juZcdHJOg46YijuQ/0f7oViFQJuKxZTa7SNwWf8fcrIjWtjznftz86+5bLtgrLepx4/e+9qFaXUVA93fCoLxWyU0GqF8Ul36z0GE1ciRGV1ZKDNLtkSliII1+0XqvNWyfaNndybhwKEF24gEaHNf3aKksx6JuxSsTqlpZArMqmpCY6jk0wJpHY2A4xmf2eNKKO4Jld5iWyuYgr7ym6IWgGmwLZ5qt90GXeFckJK8E8GQrViET3Yp125LfzUadwv06d4XvdEoBoPS5HDU7gJffIoM62FnSY6oQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(786006)(38070700021)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?O9WRdnXzB6qvXlOE9zsMWzXtq4DEZBsN4v/HkNDoAt0z4yhwh2K41FPo66?=
 =?iso-8859-1?Q?00OCYHYuen574CnR/PIlw9I8h6QcvQkcij+vNV6MSxcyCgngCQp+2xfEut?=
 =?iso-8859-1?Q?mG2a1gIWx3dlJff1JQqgQdq7+5Prgkb0knXbWMFCYBtfbxVuFvnR9zzKZa?=
 =?iso-8859-1?Q?qfePWwT1u4tB0Rr0UjtjsgJrXj3YFSiG09AkRNq3z+iyPExWoypbpi2LJ8?=
 =?iso-8859-1?Q?U9FsdkEOLcOUV5XSykP+vb2oLABrzYGZJdsDxQjBZf/rCh04Z2sTh2OM17?=
 =?iso-8859-1?Q?E7Lti38T19LrAmF8+Qpjrshx+3SukeupSF4ke7Oe1Ftt8GvMivv7RdGRZk?=
 =?iso-8859-1?Q?abV/bdORClqlbIRZ+baW7f744hK9LUMzlVFrEDHSvAXa8DOihaDE3jy4m1?=
 =?iso-8859-1?Q?n5ec7TzS/7NTZhQd95+Dw8V5NF9aWOpWdtRlejlq885cB179/9OfUdBoLZ?=
 =?iso-8859-1?Q?4oJCum1AyRUFujHh150dOOc9kEPyaWYyH8efzWjBU762BgVLhKSBaXdgeX?=
 =?iso-8859-1?Q?oU3EpmFEysJK9Z5iQTOzYIB5iLx8Xotwg+ZcS3VERNeBcwrRlvzgfCot0n?=
 =?iso-8859-1?Q?4z7tD53mNfn7PD/wW3z6O5H0pSSskjL4Sin+JrTJ2+DFnZXzicfxsoSz22?=
 =?iso-8859-1?Q?8LJRUBN4K08qp5w11wUIQZEJeD2u7i3lsdzgNDjlzjd8IUGnYlriJbrGH4?=
 =?iso-8859-1?Q?GMej8ho/LJlI3hS10SG6eUi7Z5aZZCQsFDaCxH9dlV8ZS6ToXObvrclTKH?=
 =?iso-8859-1?Q?RXOrSpi1A0Nuzll16eUT22vRqr9vpUeQnGbeKCtQHU8q8NUnwq2MSkqoCJ?=
 =?iso-8859-1?Q?voPG9fktnhsj3eA5ccWSo61u5o0Ie44jLn4liZfP2IF3UDiaxxMLueG5C2?=
 =?iso-8859-1?Q?PHfDgI80VvfBFK7cuWja09IYL6TGJzveKJJ4uMq6pgGCLq5ruBv2MUPSPz?=
 =?iso-8859-1?Q?mJ0ifudAdny4RhrUImFWh6JcLWnqwYQaQLKcZ2vohcdtkAFe2Nr6q6SZvr?=
 =?iso-8859-1?Q?cDhItzEpJocu4dG/cISw04uPHITkUn5W9HCAzdYi6gQRvRJ+/5DeO5L0o3?=
 =?iso-8859-1?Q?ibUZrHKxeQYMWZRTuaT+10Zw8z1+bnCn6pER1O0RjORuaqLVzhDZQhts6/?=
 =?iso-8859-1?Q?Vt4rcVBncomd4p/A8nxV8r4BdzKvMJ/xeWNkhl80lOn+zdX6ANPJxShnfP?=
 =?iso-8859-1?Q?HIwBkpLcvRmC9KOr2t21EfbQM1Z/HX6P1jKzX4tQy8LzXoMBcSx00fP7Ve?=
 =?iso-8859-1?Q?beb9q4yqfVp/qjg4LrV86CDkeBM5De8s/hYF5PdzGZTMs18czcI71M6Mn2?=
 =?iso-8859-1?Q?wfOi4AcsS4hHWgEVLY8Z0cjYd0GdvIlsPjDtUfUJAhiF6oSMC5XAT0z9R9?=
 =?iso-8859-1?Q?lsEkNS6o66fYHEdAN6j4PWs3p7bANCFDk2oc51end5ajQI+VLUw8Orj2IV?=
 =?iso-8859-1?Q?ak+C+3CDe9mluNw2oMTdYEY8qk4V35m1S5IF+lW0Rynwfthk78pnsCBZsv?=
 =?iso-8859-1?Q?YZ0WLIQCfkQR661XonnvVSMCnzch4lMgZyjSdeThPnumpIjJs8gMU0sxI2?=
 =?iso-8859-1?Q?dFpsAoFycwRNcRQGstJy3sWQgS8EkXzGSACR6/DMOvqU8SUvgS7cb0V1i5?=
 =?iso-8859-1?Q?frG9X2wIyNYXih+yRHsMXCU0Y8VpSSYce+YlMcwimtDoBfSL0babw0kZe/?=
 =?iso-8859-1?Q?wZ5bWhX+GjkWEhj5RwHBAIAD5VinF2kDXljkBTKE31eBkrt+LS9sB2jU1i?=
 =?iso-8859-1?Q?PmnoB/P1oqX+HE/AtqRukryFUdqNkgUeku8+BiWs2aLiO+?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 229a2942-7743-4919-50de-08df2afd99ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 20:48:00.3471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BFDVgC9hf11a7BLD70HupAIbj9fCNSsJhTObOJt9hOoxTuhm2+NYJJvLsGFyFvuUNIvwmDb3l3OUS79z6NOLiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB7226

From: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
=0A=
Add the ioctl commands and structures for /dev/md-control, a misc device=0A=
that manages md arrays without opening the md block device. The device=0A=
itself is added in the next patch.=0A=
=0A=
Every command except MD_CTL_RAID_VERSION takes a struct mdu_ioctl, which=0A=
names the array by name, UUID or device number, carries a flags field,=0A=
and points to the command's payload. The commands mirror the existing=0A=
block device ioctls and use the MD_MAJOR ioctl type, with numbers=0A=
starting at 0x40, grouped like the old ones: status at 0x40,=0A=
configuration at 0x50 and usage at 0x60.=0A=
=0A=
The payload structures are new versions of the old ones with fixed-size=0A=
types and explicit padding, so they have the same layout on 32-bit and=0A=
64-bit systems. Fields that overflow in the old structures are 64-bit=0A=
now: size, ctime and utime in struct mdu_array_info64.=0A=
struct mdu_array_info64 also reports the number of journal disks.=0A=
=0A=
STOP_ARRAY_RO has no separate command: MD_CTL_STOP_ARRAY with=0A=
MD_CTL_RO_FLAG set switches the array to read-only mode instead of=0A=
stopping it.=0A=
=0A=
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
---=0A=
 include/uapi/linux/raid/md_u.h | 114 +++++++++++++++++++++++++++++++++=0A=
 1 file changed, 114 insertions(+)=0A=
=0A=
diff --git a/include/uapi/linux/raid/md_u.h b/include/uapi/linux/raid/md_u.=
h=0A=
index a893010735fb..f5a84605b677 100644=0A=
--- a/include/uapi/linux/raid/md_u.h=0A=
+++ b/include/uapi/linux/raid/md_u.h=0A=
@@ -12,6 +12,8 @@=0A=
 #ifndef _UAPI_MD_U_H=0A=
 #define _UAPI_MD_U_H=0A=
 =0A=
+#include <linux/types.h>=0A=
+=0A=
 /*=0A=
  * Different major versions are not compatible.=0A=
  * Different minor versions are only downward compatible.=0A=
@@ -30,6 +32,10 @@=0A=
  */=0A=
 #define MD_PATCHLEVEL_VERSION           3=0A=
 =0A=
+#define MD_NAME_LEN                     32=0A=
+#define MD_UUID_LEN                     16=0A=
+#define MD_CTL_NODE                     "md-control"=0A=
+=0A=
 /* ioctls */=0A=
 =0A=
 /* status */=0A=
@@ -61,6 +67,28 @@=0A=
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)=0A=
 #define CLUSTERED_DISK_NACK	_IO (MD_MAJOR, 0x35)=0A=
 =0A=
+/* ioctl commands for the MD misc control driver */=0A=
+/* status */=0A=
+#define MD_CTL_RAID_VERSION          _IOR(MD_MAJOR, 0x40, struct mdu_versi=
on64)=0A=
+#define MD_CTL_GET_ARRAY_INFO	     _IOWR(MD_MAJOR, 0x41, struct mdu_ioctl)=
=0A=
+#define MD_CTL_GET_DISK_INFO	     _IOWR(MD_MAJOR, 0x42, struct mdu_ioctl)=
=0A=
+#define MD_CTL_GET_BITMAP_FILE	     _IOWR(MD_MAJOR, 0x43, struct mdu_ioctl=
)=0A=
+=0A=
+/* configuration */=0A=
+#define MD_CTL_ADD_NEW_DISK	     _IOWR(MD_MAJOR, 0x50, struct mdu_ioctl)=
=0A=
+#define MD_CTL_HOT_ADD_DISK	     _IOWR(MD_MAJOR, 0x51, struct mdu_ioctl)=
=0A=
+#define MD_CTL_HOT_REMOVE_DISK	     _IOWR(MD_MAJOR, 0x52, struct mdu_ioctl=
)=0A=
+#define MD_CTL_SET_ARRAY_INFO        _IOWR(MD_MAJOR, 0x53, struct mdu_ioct=
l)=0A=
+#define MD_CTL_SET_DISK_INFO	     _IOWR(MD_MAJOR, 0x54, struct mdu_ioctl)=
=0A=
+#define MD_CTL_SET_DISK_FAULTY	     _IOWR(MD_MAJOR, 0x55, struct mdu_ioctl=
)=0A=
+#define MD_CTL_SET_BITMAP_FILE	     _IOWR(MD_MAJOR, 0x56, struct mdu_ioctl=
)=0A=
+=0A=
+/* usage */=0A=
+#define MD_CTL_RUN_ARRAY	     _IOWR(MD_MAJOR, 0x60, struct mdu_ioctl)=0A=
+#define MD_CTL_STOP_ARRAY	     _IOWR(MD_MAJOR, 0x61, struct mdu_ioctl)=0A=
+#define MD_CTL_RESTART_ARRAY_RW	     _IOWR(MD_MAJOR, 0x62, struct mdu_ioct=
l)=0A=
+#define MD_CTL_CLUSTERED_DISK_NACK   _IOWR(MD_MAJOR, 0x63, struct mdu_ioct=
l)=0A=
+=0A=
 /* 63 partitions with the alternate major number (mdp) */=0A=
 #define MdpMinorShift 6=0A=
 =0A=
@@ -146,4 +174,90 @@ typedef struct mdu_param_s=0A=
 	int			max_fault;	/* unused for now */=0A=
 } mdu_param_t;=0A=
 =0A=
+/* structures for the MD misc control driver */=0A=
+struct mdu_version64 {=0A=
+	__u32 major;=0A=
+	__u32 minor;=0A=
+	__u32 patchlevel;=0A=
+	__u32 padding;=0A=
+};=0A=
+=0A=
+struct mdu_array_info64 {=0A=
+	/*=0A=
+	 * Generic constant information=0A=
+	 */=0A=
+	__u32 major_version;=0A=
+	__u32 minor_version;=0A=
+	__u32 patch_version;=0A=
+	__s32 level;=0A=
+=0A=
+	__u64 ctime;=0A=
+	__s64 size;=0A=
+=0A=
+	__u32 nr_disks;=0A=
+	__u32 raid_disks;=0A=
+	__u32 md_minor;=0A=
+	__u32 not_persistent;=0A=
+=0A=
+	/*=0A=
+	 * Generic state information=0A=
+	 */=0A=
+	__u64 utime;		/*  0 Superblock update time		      */=0A=
+=0A=
+	__u32 state;		/*  1 State bits (clean, ...)		      */=0A=
+	__u32 active_disks;	/*  2 Number of currently active disks	      */=0A=
+	__u32 working_disks;	/*  3 Number of working disks		      */=0A=
+	__u32 failed_disks;	/*  4 Number of failed disks		      */=0A=
+	__u32 spare_disks;	/*  5 Number of spare disks		      */=0A=
+	__u32 journal_disks;    /*  6 Number of disks used for journaling     */=
=0A=
+=0A=
+	/*=0A=
+	 * Personality information=0A=
+	 */=0A=
+	__s32 layout;		/*  0 the array's physical layout	      */=0A=
+	__u32 chunk_size;	/*  1 chunk size in bytes		      */=0A=
+=0A=
+};=0A=
+=0A=
+struct mdu_disk_info64 {=0A=
+	/*=0A=
+	 * configuration/status of one particular disk=0A=
+	 */=0A=
+	__u32 state;=0A=
+	__u32 major;=0A=
+	__u32 minor;=0A=
+	__u32 padding;=0A=
+=0A=
+	__s32 number;=0A=
+	__s32 raid_disk;=0A=
+};=0A=
+=0A=
+struct mdu_param64 {=0A=
+	__s32 personality;	/* 1,2,3,4 */=0A=
+	__u32 max_fault;	/* unused for now */=0A=
+	__u32 chunk_size;	/* in bytes */=0A=
+	__u32 padding;=0A=
+};=0A=
+=0A=
+struct mdu_ioctl {=0A=
+	char name[MD_NAME_LEN];=0A=
+	char uuid[MD_UUID_LEN];=0A=
+	__u64 dev;=0A=
+	__u32 flags;=0A=
+	__u32 padding;=0A=
+	union {=0A=
+		__u64 array;=0A=
+		__u64 disk;=0A=
+		__u64 param;=0A=
+		__u64 bitmap_file;=0A=
+		__u64 arg;=0A=
+	};=0A=
+};=0A=
+=0A=
+/*=0A=
+ * If set, MD_STOP_ARRAY will switch the array to read-only mode instead=
=0A=
+ * of fully stopping it.=0A=
+ */=0A=
+#define MD_CTL_RO_FLAG              (1u << 0)=0A=
+=0A=
 #endif /* _UAPI_MD_U_H */=0A=
-- =0A=
2.43.0=0A=
=0A=
