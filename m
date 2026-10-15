Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020107.outbound.protection.outlook.com [52.101.201.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E856A59C974;
	Thu, 15 Oct 2026 20:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097301; cv=fail; b=aLd+rLUSKOffNMhI3Q6/1pRtIezRPuXjWA7GwJ+eiTbZHCsyLkHXElIwhnhkHOQjemrWCI2xWN90R+khyoQ/W8XAXh3TIgdxcdHkr3D+ID+vY85cknjqQe3wjMIzUAmg8fkePeeKJ+VYPwfBWeeh6Ls2zEjmBF8wZ1OxfYzDXAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097301; c=relaxed/simple;
	bh=YOH2T3Uln+5qnKETblMy6PA1m2KaP4iXwZlUXJm8zZo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d1vOZ70hhnY+McSCOZjSsJcSVccbmK7NSy7oAjSlfj5JJRA9utqy/2ATQUPj15ONw3ooQplRQBL3INCIhQhOCX/oRmURBLwbsC/2Lg3R6KLyFuNvnXNf6p5OcThgU//h2SwcVGdcbLuwS5CHZofI+T85zizYLbFDHZPyn/mGB2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=cjE4nmSd; arc=fail smtp.client-ip=52.101.201.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="cjE4nmSd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kgvjn22em8F1KsD3e1038B5fMVz2+df24f2uWTRgBBYChJbq9pdChtEzIkklrEiwPPYY4i2CeNyfXwSvr/JOnOyivjTiLgQyQm04N2flTQLUE+53we6g/Ps9fCcFTDPez14ghTyfk38yFyh+YGloxnYfEItc8TJjeQIbndOXEQOk6Od7Ui8/5E+NBacpUjqOYH96ceR1CdU2N5yAWVXW8NMhwQcX8pIDs4uvFhIX1vnap3VX8t6Q1ZreVj0xFFHQf1N+jqc+gov3mgimDfP0a9Rjx85H59wprifiJEkMyo7YsIEcxFtMLXQi8+ukEhhP6KQmO6VQqMLZqYcTw4V2ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRNRISpb6Jwvo02vqmLlmuEb5dndfnx3c8Bfz5YKS/k=;
 b=WqkKMUz3uJmSPbvs44kJ8NfiNIuzc1lr9KChxsYYj/OVTypxRCqFaxaNbiMiJRjmd0utsp2gxViMj0QEzLfr5QEHvv03KFzsuGIxb+AY6q0zH+dxy6q5+v39LiyNNlfH2UMTAEFEmiUMmPFJ1csh1zYeEMv91mxdbWxpOcFmrLYhYJA1GCaVCsjoIbziuP3jdJPwc0TVesm2L7PqXtCn/52ZLV39/xBpnBlq5cf8OAP1L4SZAG4uXjq36IM2sOKfIslgjiiFAbEj3hMM7cWdPS9GJgLbizk32gQiJhdCOrMz5lt1+XKQoRnW+eGdtcBpM524QPX2XaVTALZ2qJydkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRNRISpb6Jwvo02vqmLlmuEb5dndfnx3c8Bfz5YKS/k=;
 b=cjE4nmSdudje/UeYtj2ctoTmwZTlOuLJspalFh7zkmAtbkmfmPxb2Flor5HXXQO7QkNm1zIcGzxWCis/aYlvZo1RvZ24UHn4PM9j85W2/q4LNi/oVESHkieXmdQO1VmipH8v7l1rCJacDXHQ63CHcXtgm1KZmG/DLs2/PLLoB9ne2UEOYE2br2PxPK5ZUQMyVppa0ejUshT5C00gmbK/UdsOwhzTVfc1dlI6R9+eJjkjVsTeKNIHZIH+V6MQidKGyifzDqhjAsTCmU/+ScA7WSNRmgjMHg1d+nm1cO2qpcQrwyUQU7iiN1ubjPWxgitMzOcx7+V3d+PkwImBBTBsNg==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by DM6PR07MB7226.namprd07.prod.outlook.com (2603:10b6:5:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 20:48:10 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 20:48:10 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	"magiclinan@didiglobal.com" <magiclinan@didiglobal.com>, "xiao@kernel.org"
	<xiao@kernel.org>, "abd.masalkhi@gmail.com" <abd.masalkhi@gmail.com>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Masalkhi, Abd
 Alrhman" <abd.masalkhi@gatech.edu>
Subject: [RFC PATCH v4 3/4] md: use struct mdu_array_info64 for SET_ARRAY_INFO
Thread-Topic: [RFC PATCH v4 3/4] md: use struct mdu_array_info64 for
 SET_ARRAY_INFO
Thread-Index: AQHdXOZ9VtgADAqrZ02g/v7Q4AbBgw==
Date: Thu, 15 Oct 2026 20:48:10 +0000
Message-ID: <20261015204640.1184848-4-abd.masalkhi@gatech.edu>
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
x-ms-office365-filtering-correlation-id: 8c1eb0e9-4b08-472e-ea9b-08df2afd9fde
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|786006|38070700021|56012099006|11063799006|261009221227099003|261009221727099003|261009223327099003|261009223027099003|261009220027099003|10067099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 easBiMecqv9+8xfxxa3ErJHoyjBqW3KHbjCs5FbmeMZxDYb0ed3D5aAXY1s+oJ1i8NU+w0o269nUdw9K7zRsi5maq46skoaZSj94noe3kZEx0yGzuVEPHrSzdMCnn2ga9XrXjMMHhS0/9eBUNZ7vZxuhEL7pWXp/1nsKXJhCjHXxE76PR+kbsR4Cydt6VOduvAQA9nu9hm7mnelgQ0dW7q43jXQ39LgwNIMHs4MYxcvLsRj4wp6FDSJU3M+JH5cK5JUY1GaW/sVRipd4kOJG/56ZmIle5gB5PDz05usEHnOMFdcLZkSzSHWf3RO9h7vIcA4+49rAaJZu6ZicXxbda/zBTOm1hjic2XL6yY+2Vv5HIj+XrReuNAgE4lUZjAong/i+C8VTiKnYoPhyacNKq7L+Dduy+5zEP2an3GrWRWwQ6KUXF9UDhMEIXTuC81Y334FV6iTG7rNjHMPukBsL5u5aOP+Ia/ArOfV7Y/EWAaeCj9toGOCFevJKNMUlqHBxU6FOp1eIJtdDbbbGOhpByJkFw8RehlRo374VpIS6eMJx8TbT0HDHIlMcC0rwaGAPjvf9peFVLBQAeNaj4MfbyTcmcEwn+4/NizW7Mqwihr9K7+vVgpRrAV1TZfaU8iga75WtBYA2j9nPdroeneNOk0EKQ5w6MQz/pRU2yoftP294TwVhzaRv/wOS60mvBVLbHORPzeJol1V4S6Gg1ZBodQlAz+rYQh5KhidZZRCrAMU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(786006)(38070700021)(56012099006)(11063799006)(261009221227099003)(261009221727099003)(261009223327099003)(261009223027099003)(261009220027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?3pLCOr7R9/dACR9it1oGWXAh76bepB5skkaQD2zedpK2JvvSBb31NEvzfS?=
 =?iso-8859-1?Q?YQ6PuyqJvnyvVj61aacqrFGq0w8TDwltfrGboCvgl3S40m3KaQwMHoabKi?=
 =?iso-8859-1?Q?KMmUfnYjgveiaiM6xJ3aAytVCcOtGR5vNLSW39UP61XRpfEK1RPsoMyluH?=
 =?iso-8859-1?Q?urg4WhvsrvWjvbc5j88BLRDPwvIn0Bl/nG1ksfUoSexS0PV/3oB3zu1W0c?=
 =?iso-8859-1?Q?vDqMegqKF8t6UxLFkclND08BYzHhUTYEtqJvcodg0B5nLr0S4YT/oaj38e?=
 =?iso-8859-1?Q?y7fGL3VA6nLJgZD5svS0CSJNA3TGIbNPFYeM3a4jStVCvQUKioAIgf0BhM?=
 =?iso-8859-1?Q?hYVRaPcjntagsmFC4jf7NUwD00ptD3AMOQ/ZDTgBmanP9lDAYhIEoEf9c1?=
 =?iso-8859-1?Q?w7gugyL+LtNw7qKRNo9kyxw0GMC5qpCypA8JcBCCD9lfky3gb2BX3p5u6/?=
 =?iso-8859-1?Q?MIRKcFJPuCJsvrFWBO8UiuRuJDJISmP28NM+gathHsDmVicjkmH7jrHtHJ?=
 =?iso-8859-1?Q?iTA23r0ofhsmBWpUBQoQtnYXXIm4bxI/o0dCl/VZTqR3xHo98D8YRk7FQE?=
 =?iso-8859-1?Q?/1eBUU7B1qGj/wJExiNF/NznU9pxs3mlabHD6kU6OOGj5oPiVDXGjTfv9h?=
 =?iso-8859-1?Q?JosEQNsdgHAelsSDCKSH6WFSH7gihNwMufpJQz7npCqD7wSli96J23SPxS?=
 =?iso-8859-1?Q?16K7o6L2F9qUvWHIYmz38iMGXMnxvKMP7C7YfWjVYyf1UsJyiKwtSM9MiV?=
 =?iso-8859-1?Q?6+Kn4l0AUc8RJPbrf1j6K5eHsazkOMkJM+hKf2d7uKXfJHz3Hhbl3xfLx6?=
 =?iso-8859-1?Q?F/F2g33qQ9iWulGWAcqa5wlvcQIFUxCuKC/6bAvMSZvhntatFxg9UsZXCn?=
 =?iso-8859-1?Q?NYFiwW4X2Rm3rxrGH73OTRAWUdWfY9Z3tomlZMCnkFWGEXX6OMuv708Q61?=
 =?iso-8859-1?Q?UvCdVrqAzMB0tFWuBmzxtxZ+KSDIcaeMXLu4Am71F553yMZklpadwagmcG?=
 =?iso-8859-1?Q?A3FZOVjTNuHoNcP59ojXMgYbaOmM99Ls5CQOuiptlAlAot+TGLzDY7ArJw?=
 =?iso-8859-1?Q?ueyrVh7G/WIDq3fMywSW8pc5TOwi13/wjSGpibpBe3E6o8Q1UXLnL5Aods?=
 =?iso-8859-1?Q?1TbAmx0HevKfKKWBuI/IEhyqSO8uvyuHu9SdjJQIJg2gCdzwlGFRFx6BCM?=
 =?iso-8859-1?Q?M8Z/76duy7m2vGFq5sQZ1zLT6zwTQfw5ftRdKh+YnBCgTr/4RvKe6va1oT?=
 =?iso-8859-1?Q?GdR8Zrh0vZB02kgTvxBV0BBKk7SkYUaLH9ytXGoXqkIchVb3SlyNHJUiY9?=
 =?iso-8859-1?Q?0YPeVZHHNeXRDC3nA4PjFi/3PfjbftykCCBxnLxDf2IGt5bjrn1zegeJA4?=
 =?iso-8859-1?Q?ONDjyPPRHM/2JDatYcQFYPv75U+ZOrHYPDmVCxD9WJHwo/oLR/TmvQToQ9?=
 =?iso-8859-1?Q?kBzBs4zIRNwtcln1Ai/CXkDqIsxEnjf+PLSmdNMZu2JOMtcr7apVdkklKj?=
 =?iso-8859-1?Q?2gHfl13hoIrDrpGI4a6BfSQOkGEwCupOZKtvnEvqrdjgF9HE9YeqR8teXE?=
 =?iso-8859-1?Q?rDIHD1ngacPBq3LMJSZGk4C+DSLZsaYsiSynbbIP/oqMZeumwBaPScYJKF?=
 =?iso-8859-1?Q?ENMDC83CvznbRaoN/+V4LvQMxdKIJtQjNaoQw316uXRpPZAKLv1q6kJ3yl?=
 =?iso-8859-1?Q?eHK/4DhawSYbRg/InNHPJKh5hLdN2EihNI6jAhYaCgMgZsAHkM0RsV7l2D?=
 =?iso-8859-1?Q?usof9qnX8PVvwgMdjVK1ipNAErRUT9PrVXCEW3d+ouIO0OlSaU35mkuFKe?=
 =?iso-8859-1?Q?/i25SwKgsQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1eb0e9-4b08-472e-ea9b-08df2afd9fde
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 20:48:10.6722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6JrtLCWIegs7wM0mDu2b2QV9bowdaG4sW0jnJHUod8wMDnsQ3n7Oe+ysteF74UWJWlUDi52fxX9C2ibKDaZ78A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB7226

From: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
=0A=
The md control device passes array information as struct=0A=
mdu_array_info64. Make md_set_array_info() and update_array_info()=0A=
take the new struct mdu_array_info64, so that the md control device=0A=
and the old SET_ARRAY_INFO ioctl can share them.=0A=
=0A=
md_set_array_info() no longer checks for a negative major_version:=0A=
the field is unsigned now, and the existing check against the size=0A=
of super_types still rejects such values.=0A=
=0A=
md_setup_drive() uses a struct mdu_array_info64 directly.=0A=
=0A=
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
---=0A=
 drivers/md/md-autodetect.c |  2 +-=0A=
 drivers/md/md.c            | 37 +++++++++++++++++++++++++++++++------=0A=
 drivers/md/md.h            |  4 ++--=0A=
 3 files changed, 34 insertions(+), 9 deletions(-)=0A=
=0A=
diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c=0A=
index 9ba061f1a628..227cd4a688a5 100644=0A=
--- a/drivers/md/md-autodetect.c=0A=
+++ b/drivers/md/md-autodetect.c=0A=
@@ -124,7 +124,7 @@ static void __init md_setup_drive(struct md_setup_args =
*args)=0A=
 {=0A=
 	char *devname =3D args->device_names;=0A=
 	dev_t devices[MD_SB_DISKS + 1], mdev;=0A=
-	struct mdu_array_info_s ainfo =3D { };=0A=
+	struct mdu_array_info64 ainfo =3D { };=0A=
 	struct mddev *mddev;=0A=
 	int err =3D 0, i;=0A=
 	char name[16];=0A=
diff --git a/drivers/md/md.c b/drivers/md/md.c=0A=
index be1634ae1d09..63b9468285b0 100644=0A=
--- a/drivers/md/md.c=0A=
+++ b/drivers/md/md.c=0A=
@@ -7904,12 +7904,11 @@ static int set_bitmap_file(struct mddev *mddev, int=
 fd)=0A=
  *  The minor and patch _version numbers are also kept incase the=0A=
  *  super_block handler wishes to interpret them.=0A=
  */=0A=
-int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)=
=0A=
+int md_set_array_info(struct mddev *mddev, struct mdu_array_info64 *info)=
=0A=
 {=0A=
 	if (info->raid_disks =3D=3D 0) {=0A=
 		/* just setting version number for superblock loading */=0A=
-		if (info->major_version < 0 ||=0A=
-		    info->major_version >=3D ARRAY_SIZE(super_types) ||=0A=
+		if (info->major_version >=3D ARRAY_SIZE(super_types) ||=0A=
 		    super_types[info->major_version].name =3D=3D NULL) {=0A=
 			/* maybe try to auto-load a module? */=0A=
 			pr_warn("md: superblock version %d not known\n",=0A=
@@ -8101,7 +8100,7 @@ static void put_cluster_ops(struct mddev *mddev)=0A=
  * Any differences that cannot be handled will cause an error.=0A=
  * Normally, only one change can be managed at a time.=0A=
  */=0A=
-static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)=
=0A=
+static int update_array_info(struct mddev *mddev, struct mdu_array_info64 =
*info)=0A=
 {=0A=
 	int rv =3D 0;=0A=
 	int cnt =3D 0;=0A=
@@ -8315,9 +8314,33 @@ static void convert_to_disk_info64(struct mdu_disk_i=
nfo64 *info64,=0A=
 	info64->state =3D info->state;=0A=
 }=0A=
 =0A=
+static void convert_to_array_info64(struct mdu_array_info64 *info64,=0A=
+				    mdu_array_info_t *info)=0A=
+{=0A=
+	info64->major_version =3D info->major_version;=0A=
+	info64->minor_version =3D info->minor_version;=0A=
+	info64->patch_version =3D info->patch_version;=0A=
+	info64->level =3D info->level;=0A=
+	info64->ctime =3D info->ctime;=0A=
+	info64->size =3D info->size;=0A=
+	info64->nr_disks =3D info->nr_disks;=0A=
+	info64->raid_disks =3D info->raid_disks;=0A=
+	info64->md_minor =3D info->md_minor;=0A=
+	info64->not_persistent =3D info->not_persistent;=0A=
+	info64->utime =3D info->utime;=0A=
+	info64->state =3D info->state;=0A=
+	info64->active_disks =3D info->active_disks;=0A=
+	info64->working_disks =3D info->working_disks;=0A=
+	info64->failed_disks =3D info->failed_disks;=0A=
+	info64->spare_disks =3D info->spare_disks;=0A=
+	info64->layout =3D info->layout;=0A=
+	info64->chunk_size =3D info->chunk_size;=0A=
+}=0A=
+=0A=
 static int __md_set_array_info(struct mddev *mddev, void __user *argp)=0A=
 {=0A=
 	mdu_array_info_t info;=0A=
+	struct mdu_array_info64 info64 =3D {0};=0A=
 	int err;=0A=
 =0A=
 	if (!argp)=0A=
@@ -8325,8 +8348,10 @@ static int __md_set_array_info(struct mddev *mddev, =
void __user *argp)=0A=
 	else if (copy_from_user(&info, argp, sizeof(info)))=0A=
 		return -EFAULT;=0A=
 =0A=
+	convert_to_array_info64(&info64, &info);=0A=
+=0A=
 	if (mddev->pers) {=0A=
-		err =3D update_array_info(mddev, &info);=0A=
+		err =3D update_array_info(mddev, &info64);=0A=
 		if (err)=0A=
 			pr_warn("md: couldn't update array info. %d\n", err);=0A=
 		return err;=0A=
@@ -8342,7 +8367,7 @@ static int __md_set_array_info(struct mddev *mddev, v=
oid __user *argp)=0A=
 		return -EBUSY;=0A=
 	}=0A=
 =0A=
-	err =3D md_set_array_info(mddev, &info);=0A=
+	err =3D md_set_array_info(mddev, &info64);=0A=
 	if (err)=0A=
 		pr_warn("md: couldn't set array info. %d\n", err);=0A=
 =0A=
diff --git a/drivers/md/md.h b/drivers/md/md.h=0A=
index a84c8b97fa2c..27de34a8bdf9 100644=0A=
--- a/drivers/md/md.h=0A=
+++ b/drivers/md/md.h=0A=
@@ -1042,12 +1042,12 @@ static inline void mddev_unlock_and_resume(struct m=
ddev *mddev)=0A=
 	mddev_resume(mddev);=0A=
 }=0A=
 =0A=
-struct mdu_array_info_s;=0A=
+struct mdu_array_info64;=0A=
 struct mdu_disk_info64;=0A=
 =0A=
 extern int mdp_major;=0A=
 void md_autostart_arrays(int part);=0A=
-int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);=
=0A=
+int md_set_array_info(struct mddev *mddev, struct mdu_array_info64 *info);=
=0A=
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info64 *info);=0A=
 int do_md_run(struct mddev *mddev);=0A=
 #define MDDEV_STACK_INTEGRITY	(1u << 0)=0A=
-- =0A=
2.43.0=0A=
=0A=
