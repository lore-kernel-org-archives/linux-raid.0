Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE47194A67
	for <linux-raid@vger.kernel.org>; Fri,  7 Feb 2025 04:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902364; cv=fail; b=XWY7Mx5wgHHYrIkDFD7+Yiao7FBHj21abOSvSf5kOu+MEwCB0UxTtfg88RUJqCJZAwofusw3GfyzPAMe+j+NETjVqaSi0cBKLIfda6ENIAn3LoVjzeQ0cJVpBEl7FgHBhoMkqKnWPDuqNAdsP/ddCLGkb95Uatph8LChKiVIj2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902364; c=relaxed/simple;
	bh=1NtaHUP/uJhoVASuDUBnn/QTo11fqpjJO1cz7CXu4Zk=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gBUUIvVCaaeup+GuFNmtUFq/5EC3DhFaOZW0xtcCzVzZsvx2BUmIV3y8Bne2BYw+r/2OT8cOvnFnaOmnWiXU7fk0v4H6T0ufquONH2yjF/+sUDwhL6KBKKI+GaHkeT5ZAbuUGfrJnlHEAuRChpxP+Oh2kA96SJNLsUZadrgrgwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=iaNK81dY; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="iaNK81dY"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 5174Q0Wv016924
	for <linux-raid@vger.kernel.org>; Thu, 6 Feb 2025 20:26:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-type:date:from:message-id:mime-version
	:subject:to; s=s2048-2021-q4; bh=iMxMAkcSk0o22AzQ14U4+EPtkjcAMxP
	YVey53k/uG1c=; b=iaNK81dYOZJxS7tPKGLsO6r5KoW40acrHZ48kb1pcZmvIYP
	x3LM6gqech6QwjQyKz+jdjrDWhaylcBcCFyM/Tfdd7Qwt4tZBIVunS52DEZJRCFE
	4bg44doDIv163y7XpqRs3aHTaU6vIwFi/xNMmHX4id6V/osjAzeP4cFQwz3fRp1y
	MpqYl0g7x7kcCURqsSRqOOXB6eVDyaGiaJGZcIL7jYPYL3RQrHtzD+Sp/0oq+pqi
	25QVjYKJFkAbcGfbSzjZMV2CNslo/1Et0yG7dNurEh88GTR7vI0Ml2jCSr2N7I5W
	AS7FspYLnurgB1Uc263D7aq8lc0Xquy22SiHmWg==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by m0001303.ppops.net (PPS) with ESMTPS id 44n9gv0ga5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 06 Feb 2025 20:26:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TN+QX87nkMawwtX9UgTDxLYeQLZI55r2qh1yN4Z1ia+gbAIzj2Y2Z7YKcFUdK+5/gSjCUMZ4/cLN4Sd6589uhR3btgILbD2k7pyoR7kEbc3MuIAZIDg7QFVnE+WXKctnTml1XnQOEJemSnnuUB4lujq2xr+h/8joYDmDwX8CpDRsisSCKT3hf44Y0J1g9JeUzSIh7JUut0HJE4vP6WilNU6iNCd+xlU98bsAPfdLOAt+jn4Ggx9HdWMGAj+qT5Aoe58AzyBg5u1ieocKy3Rvj8qdI+0UIih3f205r33VIEGNwRNOstDdH2ZYq1itGRxFs/EE7Dn/K4dzKQtG304d9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMxMAkcSk0o22AzQ14U4+EPtkjcAMxPYVey53k/uG1c=;
 b=eEaP79g8CBUFdzasBfzGzE7+8C9Lt6MaYuW9eNLdLwv6bIzV79SuNz3ljvts1mT7kh3aTPLwQdbf3stDlc9U5u9gonAE27BJYuXtt9fE5wWAh1Y7ejh3OsS/wfQ956fl/Frneky3XNGJAOlyVcDdpGrpXUl9wiXgMCwCgi+a6iNNPHaFxhNE5MdKrljTgX5T6A/9pnuyINjAAPD8hcwxk23QbgSooQg2YdAHU1uh8NZ4uqRHpTEYowYA+JxQgmggib+Kw+jVa8Ae4Qxn/Ter02QNki0AtcWmFAlwe4EPD+g9UJbDnyVLfNdsDbTzA4ABBBdnffmngbAUMlaUO9MpaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB3880.namprd15.prod.outlook.com (2603:10b6:5:2bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 04:25:32 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.8398.020; Fri, 7 Feb 2025
 04:25:31 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Bart Van Assche <bvanassche@acm.org>, Song Liu <song@kernel.org>,
        Yu Kuai
	<yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-6.14 20250206
Thread-Topic: [GIT PULL] md-6.14 20250206
Thread-Index: AQHbeRhTe03ZRp8y+kyL+Dprlef2Ng==
Date: Fri, 7 Feb 2025 04:25:31 +0000
Message-ID: <E81687C5-CD10-4726-9BBB-378CFAC323D8@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DM6PR15MB3880:EE_
x-ms-office365-filtering-correlation-id: 67a5399a-87e6-4169-e08a-08dd472f75a9
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?lLM4QYRVdv5TijwR/FLPPG8phaGqYh/5FLiENN/7ETY3+H02DOFqq0t3Nfby?=
 =?us-ascii?Q?dCi1VkhercBi7K4tmc33JwY08U5Xh1DxUrdtlqJJKt/Z1Raf+Lf6b1E6vmrg?=
 =?us-ascii?Q?bIIxzFcZ1yMHeNjWv7l3l8kodIeyAHPviLRRj2sw727FhNbfq4Hyi+VdT+0J?=
 =?us-ascii?Q?1Iq6VX0hLo6MCY2j5vxs9lOsZ60kzhDTsobeWu9Yl3tQ1v6amrk1TtAxI9N4?=
 =?us-ascii?Q?WbVSaBhszj9sk8787ZiCla3E4eDzgZA9o988vN4fYKFrKrFelHAxoA2I9ZwE?=
 =?us-ascii?Q?80kKrCkBddjTCCCo9bI9EVM/2BOBsr3dkHWew4l0RscO4P75bx9Ecxo7wJ9s?=
 =?us-ascii?Q?qeZnIDmNUubILJjwhP9Is+FA9oM71mZZI8Rs4GYDc+kyVOLY+gq9dQFkas+9?=
 =?us-ascii?Q?mHKi0uRV4W3+DKaztOFxDPUXNaIn4GzHdnxibRgzJY2psxnHnETYGdNtbu+m?=
 =?us-ascii?Q?va9RJSJAwmkRZF9KeKCUL5LKzHvFfuCjhAnXCXF5qmcyhd6JkJX1zLIpx48Z?=
 =?us-ascii?Q?9ecZVj6uHaKBAdypJwok4ILdmSFVMKRF5RqG97bxRsgY3t1Awtka0r/ptl6W?=
 =?us-ascii?Q?ZMj27PAW9sjUKaHDg3I2N0uuK9Lrgoh2K/WzN6gQpbf6l3YwdgfAEHaLtEsn?=
 =?us-ascii?Q?EVICksituqa0HZ0cMHtgQiGrJUN92ApPzCk/dRCA8levnHeaothR2Jv5esMq?=
 =?us-ascii?Q?jYecIQon96vripY7Ytm+HzNJrjinDTLYE3W8qG4hFld0Vw9hRmOFAj8U+y0p?=
 =?us-ascii?Q?3S28Nc/uyOTDOL2Q4Ekr3wO6cpACzRtndxyl3P0lKuZzav5XvEC2jTDdgnMB?=
 =?us-ascii?Q?wOuCmvujVQc9aLF+w3g2ubZuyWArsdVFgdeN2W0lK3JPXelT6yihgaki/Ku3?=
 =?us-ascii?Q?pAjj9vB1ZlOlzrbbs1v69h3u4bjcD9wLAerwbKjGf+2DT1YkYvYGGudx+h1U?=
 =?us-ascii?Q?j8LCJJHvAFSmAiNDnXR/4lbiDOXTksu5hJLm6AD5ggun9dR/OmI9UebkIKi2?=
 =?us-ascii?Q?xjDjfLWA/WyILy6E2xH547qC6H4nOzuhT3lJGaNhpADRyrJ+rB3r+aE0nfK5?=
 =?us-ascii?Q?hXMAT3kghdwgR+sFOow4Ip/wxfdDdwSf2ZP+b12iFYMXn3blw0+V6+sLrN5c?=
 =?us-ascii?Q?1d66UNBYSwGn2S0nUw45dcvL5gIRIiFNG8pnyLpJwJpmI+KqALuP5lcefw8m?=
 =?us-ascii?Q?DgPwLQdT0ZToZMw50Gr+VzZHCC59j6PhZZm2lbkug6VcoV6s5LHvDcwG2vFV?=
 =?us-ascii?Q?zMt9wF3YnddWKZ+Td9/8Bo6L2MZpqvyGuzunwmX3E/Nvf6ig/D6AKLbH0dDz?=
 =?us-ascii?Q?ed3RHFBwrB/JNU9LsfjRpFToaBqerm6uzArs1EVDZ71y1PvRvQqXDL4dffZb?=
 =?us-ascii?Q?hfsVtunzhBXZbP5Suzus4+5BPdtYWLRyr+zeHEchigHHWw+J+ClbCRWXviQg?=
 =?us-ascii?Q?iQpX21jCX1cBb2Jd87MJKKVlYtfe1KA5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?+s+XBlvk4mQZfrqGpJvnWeJjYTviWbx36FgC7uClvHLGZFta0QMo7M/kwerF?=
 =?us-ascii?Q?wN939wOXvh5WihYDXbwsNR/MwyNx/a4j7SiP9Cs2scfH5YztS/R+B5hiQLCt?=
 =?us-ascii?Q?IVIZ84yxwkNymP1NC9Xsm7ceRrJsNZ6FbEbJjqrQj+NV2wVb4/HmQiBfVNSw?=
 =?us-ascii?Q?wldpM+wLJpzlx9SZWz8eSgXKhDtpIMc8HYkCF6OlAdsmJ4lVMaJFn9tld5BT?=
 =?us-ascii?Q?w3qBLK+muWssFMVAsPdUZeMrDtHImzL/ucAOqiSoGmpSt9QPf1qiKqC250ic?=
 =?us-ascii?Q?gE4HjP+kvcGkypuCRDct9u5QASYmpcxHxAK0u71w0TUD7FhuRE0PidR5CIm1?=
 =?us-ascii?Q?hnv2M6nGnM8Ei7BFBMQ920w+b+2krY16XI8GUjE+jR2PSO16m/cTgVg7RX7q?=
 =?us-ascii?Q?SputXshg1FGx2Jhi7yQbhMAUqtUZQXmBoSUj5fTvLMR4hcyHXIbn/iE5LcPx?=
 =?us-ascii?Q?2nbdA4j+buR2K51+uZtwvg1jKD9hCbMT1wt3t8njcKYVrOM0Hvai9TzBClQm?=
 =?us-ascii?Q?1N9BWWYlSbk/yqNvatxVsLXEIk4ZDz0hfvu2O523iCRcfeKzznchtbbuUaQr?=
 =?us-ascii?Q?PPE5AlrRXnTB0lTp3LarygT12jJG9ypfxQCq/T3XKaVMJrB2yjq+uWXSYS3V?=
 =?us-ascii?Q?siftHnyPMWF5MQuwEuC8d80b6bAUNmxfqeuFcb3Dk0vFNBpg3S1J4bjSEBTt?=
 =?us-ascii?Q?1c80A/krRlVWqdx20uIH4TBKlzwCITvkUmCt77cZbqp2U1DSSoXwdiJDmsDj?=
 =?us-ascii?Q?vitEIbjtViv5f3mHXOdwzt7PlkIacody1Jer7tBjp0iEFEPBXMNR4+IVgqHz?=
 =?us-ascii?Q?6WC6RrmgST35E/Krd+6eogPH5GgcEFiuNZ2ylrWNU/nV9ikgyCBK1nB/OmkG?=
 =?us-ascii?Q?bek8eUQColBCkqjgtfPKJRe+0OR73po8MNAJMv6JNlx+rwAZnenhv5LOHeF1?=
 =?us-ascii?Q?DmWk9vbRmst2sduDuLslf6W1TSCd5oJKJbDUxg7dDx5T1IONGdhoXUqwPIhJ?=
 =?us-ascii?Q?q2t6xwEf8hLvXHlozBJbLXgeWLzjn6BtoqARcHZHOfFEmqWK7AABg0bAQMFU?=
 =?us-ascii?Q?67fCGnvdEBJ7Q9PaYVx4EVkts9YJjszRbkIUNO5YqNP40b8LJoxAjEOBwgmv?=
 =?us-ascii?Q?NMun18Dc55Mao2s7ObHQRhlkQFxuBhUM2h4MXd5wubJCTb95G2Rq+Ygb3TPQ?=
 =?us-ascii?Q?cjLUvpxDgtlFzaj6dWubRuI+TKESZ8+Qa+0fTxojILms3FL0lehBUUciU1Fw?=
 =?us-ascii?Q?ApeOgh5vAchVg+U0Upe0zsjxYDmlol7mPWTaghITDdCUldsDUQSKvnOGgZr6?=
 =?us-ascii?Q?8SRqolFdcFdoIrE7rm6w/E371FPix9UbvxceuZHCeB9rEHbYBAkXGCn4Ol05?=
 =?us-ascii?Q?XCgBPEtwyIpu3U/klF0mjpeUAczg2jhVa/4nG7kKkWyopA0UVWkk5S8kLKGP?=
 =?us-ascii?Q?HiUM2hxgvcUDTYtpUD50y55+tYhDt0wEKnFkMrA6LHk7sXm2hgkkVVDg5tfp?=
 =?us-ascii?Q?a9EFQN9ZObiD6TKCc4u1ER4PbhMYEViKjjarOnIn8LjCn8CVrHFI12TuITrz?=
 =?us-ascii?Q?R0z1yp2p7zuOsSNXwzJ1Ep3M7V8u8p8hoWoWK75KDJmO5NcFH/s8zHIMcJ8S?=
 =?us-ascii?Q?kw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0E8706D9A09857448C3766D5EE6DF2A0@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a5399a-87e6-4169-e08a-08dd472f75a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2025 04:25:31.9402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M9NeBFZSk9RatuqoQaeRJe9XLgyPNPRMak6FQB3VNZyuq+Zx55YmmStsnpkx/MjFubGWYOxpXtr2ee62Kh49gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3880
X-Proofpoint-ORIG-GUID: mDVZ827R8VrijPfyoMetByyFaNLpmjQL
X-Proofpoint-GUID: mDVZ827R8VrijPfyoMetByyFaNLpmjQL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-07_02,2025-02-07_01,2024-11-22_01

Hi Jens, 

Please consider pulling the following fix on top of your block-6.14
branch. This patch, by Bart Van Assche, fixes an error handling path
for md-linear. 

Thanks,
Song



The following changes since commit 1e1a9cecfab3f22ebef0a976f849c87be8d03c1c:

  block: force noio scope in blk_mq_freeze_queue (2025-01-31 07:20:08 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.14-20250206

for you to fetch changes up to a572593ac80e51eb69ecede7e614289fcccdbf8d:

  md: Fix linear_set_limits() (2025-01-31 10:18:50 -0800)

----------------------------------------------------------------
Bart Van Assche (1):
      md: Fix linear_set_limits()

 drivers/md/md-linear.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)
