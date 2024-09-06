Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC48E1B85C1
	for <linux-raid@vger.kernel.org>; Fri,  6 Sep 2024 19:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725651834; cv=fail; b=a9J/TD78YnzckEhov8dhi56vyyluoKuFarH7jSMSxnxT7HV+tZYeFHjwcFQ4+JQhqMP0mLYeI3SyW9QPPbbK6sD8cL3Z7G54gPNXc47GXw9Zh2kzsh+jObd5+l6w/qD12mgkymK7dMTyTWnIZuUtvRlLBINv9AKcYtYyqQKPuEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725651834; c=relaxed/simple;
	bh=BipE2x/pb/1bLtfSbPSsr3RoLhcJc4egWq5uIGr/bwM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qdiKUd5++M7QSUQ+VSz/h2yx1QrjAReTKIzq+erVHh6EkS2Q+T4d9F7+ENVML6GxYwpjX66DFXhe0ONb66HljRhVEQIdRztRQA3p9wvaAcIY3mi64071kEXBXVsNqHo/mwSWr0sSs2gScKjX2DHX4+Ai2UUYqdi9lfWYxPe9zmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=R52PnkoP; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="R52PnkoP"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486HRGYK008536
	for <linux-raid@vger.kernel.org>; Fri, 6 Sep 2024 12:43:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:content-type:content-id
	:mime-version; s=s2048-2021-q4; bh=nW+WZk/Y9ZXPo2JrRyVCm22XMkhF1
	lQ7yL0FlYgkaCg=; b=R52PnkoPLML4cVnptiq8C7URtiakgT39+iRjpPvgP/9TF
	m+9QfVEF7hJ5mH0P6QgZKZMqGrASD2lzKA1RIzxRB3n7IzB2AZmUSMczqeu866eh
	qv+Z842Em/RKIP8uXYg3kNqgBm3hK4DIH39Ftfu59pHsfCreJURzbfD43pejLjlb
	ZrS2JiqGmOb+S+h2lD9cz26iL/Be5M/NhPmkB1XDzTX5eepOwmA2avr03/pz1wpB
	ge46oE9HAsBBjTVmNExAIp1cKdcn8uFGND3oLSM5SehGc2DDuR8m4l5Jz8VgHQPx
	8p5Z52V5GYtghDlURfunLLBC0jBUW/J9Zc/63uhqw==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41fu3d4q0g-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 06 Sep 2024 12:43:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQYlv/Io+6zRIi+m8RLKwWCPgTfLH4hXojgul3ZUtCJ5fi+eM8cSqPNkDHJpC8EmLd6X6mCY4Yj3/VQQi3FUimvvJfmrSuPokwenGz/EbgTzAA45+OMp5d/1RWBdwouAyCZNmELOxUIk/KG+SAzGa2iyILk9unbdYJvJ/WD2wtYUQ+ACqp+HI3RmZ2EACdOmibpyg+Dno9imHVpCYENyevGRph56VHBEINHRBXJmXv8ayrlhegb7KcBYnsLlkU4ox2FrQpNh7Sp7tqmiz5NW6fK8kZxyEn73apbLRyXw2HxYxofbbRsXznFN6rkMuqi0n9SZT6zZTph/Ryq6L7VOIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nW+WZk/Y9ZXPo2JrRyVCm22XMkhF1lQ7yL0FlYgkaCg=;
 b=WpSR+kVVTfcB2siTnZcHyYKUHS5K9ZxfHH4hRj9/cnlNjPEg7892maY3VMH71yb+ySzxUZOvXEOLxJtY00VNnIb9RioLejjbZ0krX+jjI+/MxeY11M4xj6a3UiM0nfg0D+1fCIjq0XA6qh+XD3lp3gpCXRDAoF8d8wJjL49gWhyAHFfiGifdYacLnfqm30CFrqwZaf3cC5tx3vZpY43lBIm0YFsRSvtaxYcdGWAbE5ucIxoyoIedz5VobWwL2rlmesDJ1a1ZviK2n3wYl/+2ob7nP6gVN4mq4och8EtLBmYq/ZvGSacCRBLmvBzPyknd2dpa7wqFOAD8Iw4Dzg5xMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by IA0PR15MB5524.namprd15.prod.outlook.com (2603:10b6:208:440::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Fri, 6 Sep
 2024 19:43:48 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7939.017; Fri, 6 Sep 2024
 19:43:48 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Yu Kuai
	<yukuai3@huawei.com>, Song Liu <song@kernel.org>
Subject: [GIT PULL] md-6.12 20240906
Thread-Topic: [GIT PULL] md-6.12 20240906
Thread-Index: AQHbAJUXFdJb20agO0+NlsB+X1MCxw==
Date: Fri, 6 Sep 2024 19:43:48 +0000
Message-ID: <7EA0AC98-64A3-4DC9-B204-8533DA2DDE5F@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|IA0PR15MB5524:EE_
x-ms-office365-filtering-correlation-id: f823ba71-137d-4733-ccf9-08dcceac3a50
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?sv50xeyZ++phE7CN/uRP05bOiiBKzlQAnHVoTgfter8TnBENK9ZJ3jfVbYjM?=
 =?us-ascii?Q?pXKM2HBqojxkYCrl0rvM4S1o4iadQfr5r5r30nbOl3ZVXCrIpXVdcXMzbYqC?=
 =?us-ascii?Q?wKzNimrqOk59miAtDwIeZsS9yH2vkY3+R8r/xDPyJgI1rLHd1Mw+BqXN4njL?=
 =?us-ascii?Q?4IJOX/0nZEC4Z/5THXnnS4RzT4HhKyO9RqbXdPBGhNOVTezLfpM2QNBpDKdx?=
 =?us-ascii?Q?PL3/u2gYmP8FzcLYO2ivn6T2ARs2/9Gfq8apWpU/ehz16pMlvZwGN9urcH5L?=
 =?us-ascii?Q?QZs+BTGNG7mLv6SqFHGt1knv2vheMrHLrXe3lck1etC2qLzgZ2WslLbERBu3?=
 =?us-ascii?Q?QhNrlw6tl1+a0zpYFnTe6v294NOcG4UjveG+ya82R/+QX9YneR+l6wJZRImF?=
 =?us-ascii?Q?8tW0LzodO7XBBbWUoqDPKSd2eTsr3lt9hacpFP7OnZ0Fwwsq48k+UdXeqfYs?=
 =?us-ascii?Q?aY+WLFU2jxvEIQ3pTiaPMApAjQZ73CLYVi33r9Pp16bRq6h4u88ATUJqQQcH?=
 =?us-ascii?Q?kWYhM30tP1jgrzEyfrFwgPPU0ChD15x4E4+K/l4RRjRpBPlYY7CcQn1E8fWu?=
 =?us-ascii?Q?O4KnIbJJ+QHmvQS93/iIJ++Efox9CY8XKTmaY1gyiAZwYKxrCMQxqJIBOJ0A?=
 =?us-ascii?Q?sbENpVm3dCPRA95+iX5H9wW91atkq2ljA6xtnbVt6BuccLjbCbUQVwBtRGSl?=
 =?us-ascii?Q?bYNFhHin2gdkVYtU/tcs2B/I5hdp77ztPFz3cLfY3+DelI1gTZ/QxRXHg6EH?=
 =?us-ascii?Q?+NAFGM44EEPkIXbFm4IwUeJq8Cd01yoQzmzibz+JrIggPozq3aiDUqZuKZzj?=
 =?us-ascii?Q?vsnwOuDl7eknczNKzKpXMiUuMkVMMzfILb3YAIXG8/z6xpJXh02xC50aMvAy?=
 =?us-ascii?Q?DLji41QcRbAU427B0cgOcx0CWvhfChJYYxZrZDxPZMBM/rI8QTmo+pzPiiAK?=
 =?us-ascii?Q?oeaWlLTWW7odhZa61U6FH46riNc6yYnuLDbCwZRQSXfcxHO7CwEAJ+kItiN9?=
 =?us-ascii?Q?mplbatcX1uqjS2uSgSHidMxQ4dRPPCcOvncamtZgoA4OyOAHBnXgCmzT+wUI?=
 =?us-ascii?Q?ZaNt4eblwLUDmx3ZOtVAOM9E+Zm/D45BQpKhTwravJODH3qU5kMIXNQicP+W?=
 =?us-ascii?Q?2FKB9SkqMFoZ+BTxmZvxvun+tmx5NNBr1X/B0xpa4fxvJewPeJ275b7ZRG0g?=
 =?us-ascii?Q?r2XARVs9VLUkxKjU3eTMEMBnk8zrEQVSbDD//tBUbyw18mrl00rtkQPtpVpv?=
 =?us-ascii?Q?/frYuXyI5lZG0W3aQrs7g899Ls+5gxs6XmbNspPVM3Gh/y5twlE0cLTaz6da?=
 =?us-ascii?Q?w/H+oOnB2htK6HikD15zCRUERN8cZXq8rM1AVqq9mFHoILErC+U0x2uIFGm0?=
 =?us-ascii?Q?ptmKd8EltlHbNrOWtM+IMYfKCs2zy1hZqhz0tsUb/Gi9SBtE+g=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ij0iZQadnf7bwJvRARGfxvYptgcU9m9loEi2F6to4KBpAZYxwbBev71DBWwh?=
 =?us-ascii?Q?NquqndLMXz6/ba9O7gwQMA5sj1jMb/qxXTjmaN67OFA22wJiyejeBAvweX1v?=
 =?us-ascii?Q?uOxPgSHK838JgpHKJmYNO0OQKD8OX8jeicGYVJINhq0jq28AyBkPQGxvWjJY?=
 =?us-ascii?Q?DIkfNuW3/E4ps9JD9XLTvQ3o+EV3LQ0urEqyNwygpJ8N2dcYWC5/gxoWEPYn?=
 =?us-ascii?Q?XYhteAMzUxnbst37qDyaeZo+RmbFPcRRTkL/aXI0OVTrmWLf7XRDe5VZdXZe?=
 =?us-ascii?Q?YlJmiIWeKv2a2QIeiZHcoY+RdIpABkr4wuae3Wa+xXtYpjv42PIsIYGU3W/b?=
 =?us-ascii?Q?gs96yxe19gqSTVEcacNRgTzmaqXZPRZ6kdXXAoY+TdDRHLXot96qPUXXE+GR?=
 =?us-ascii?Q?n0ymUXqH0uTvAXJs4fnbIle5ZMb4jqbJ87CV1GfgXkrhm27TdNg9q3xiLI9q?=
 =?us-ascii?Q?xPxy80vUykL0kDXSusg7O/C+Mi+rnJq2Ycs1bgJlPAZ4ZaZuFoQMdut828Sy?=
 =?us-ascii?Q?wsSkoNvyWDRe85NwPVVaIJlTkmNkWgp+2Xf8Zk6csrRdUhcknT3jqC2ZoT5d?=
 =?us-ascii?Q?U4rRZiekfRAg3yu32vv2tBogw+CNo6SB/y7kiarfJ6Ym4UEab/RanU63ePvI?=
 =?us-ascii?Q?OR/S/7hgmMIDzS7j/IvQiTDnpz05oP5derZ+H/wnCOePlEJs8sdzXUAZKM75?=
 =?us-ascii?Q?pHf7V2Cb8KBl7mdntRusyazxd1CW4X7qiTIb+mo0ZXXT40AtXkq/0kIcYk1s?=
 =?us-ascii?Q?L3UFeLZYrnhGjRLZjvEIjKSBWLTodr7RdnE1ie5ORFRDYy/MMxrZ8fdnxu4F?=
 =?us-ascii?Q?TBvaxYHB2eBFAVt/2WfBhw30HC8XUkkk8p4BAkpsSKoPO5vZTI1MmRBF+QKQ?=
 =?us-ascii?Q?NlViEtnKbgPcPrAKi2YkP2EcO0gjqoy9cl/iIPhtgPrede5KLSfpSgDjcbXn?=
 =?us-ascii?Q?kQkkrplgxZrclOAzAHJKOMa8xZoM1EYPjZLvBbf2mQVtDzDPhypP3hxZstEW?=
 =?us-ascii?Q?tHy1zXZ6qzO1xgIGyrbT5Ecs3dOqUdrBJjVwzRPpX2ewLGujxon0PVGvKbV9?=
 =?us-ascii?Q?6cUN66G4OANXOSnKDsxqGhiRHuhlx0W/EXkUYARAUqq8gRxl3pVC3ytBA3+g?=
 =?us-ascii?Q?/+aVC1Wg9ij0JStIxu/mzQJ4em2NTxNN5BLwbLO8FYQGHmmvSADhKBlo2KvU?=
 =?us-ascii?Q?KbE8edgSN2Q4+ReC083z2kAqLQehoTPumQClJDhQliZ1bQgvCfU5ksO/KPcY?=
 =?us-ascii?Q?lezPpCWr9+RqEBeEep2jIRM2YKiXs0Vx3wU1CoozPMsljBwCb9anWs8Q+/NW?=
 =?us-ascii?Q?m8aTIfTWKR6sAKHE/fxcy6X/rmUDumJC1bd/qfYoGSpFhPi3FnTPjk/xNc+M?=
 =?us-ascii?Q?LlJohud7OZbdMk2q01AMB4jIcDJu4WN9V70ulh2fc6SNneegvkXPIaFjMbui?=
 =?us-ascii?Q?RgjE/J62JbyYWXLGILnJdmH2VvtB3JlV6K7BJj9poChdK4NcUQNAE26hTt/4?=
 =?us-ascii?Q?feIsnbM5u1hXAatOQ8UH2xrqZbj8v4Qdl3FnnePOm/M53zTN+N8ZB2uxWHmx?=
 =?us-ascii?Q?A9cs+JS+CTviOFDXmk47UXFumb3VnRz5DiPIKUM4AyJLiNUvONDpm9LyHZET?=
 =?us-ascii?Q?zprOO2z51wCcZAdlcSWIyQY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C16423EFBD970844AC0623B5584C6CEE@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f823ba71-137d-4733-ccf9-08dcceac3a50
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 19:43:48.7499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fFw0tDY6DBL7CYFXb8sYfsQJF9JxFjzanXuz9IaA4Gg7kvoQ5cBskVtPYvX/bKMU8AoP3XEBexnxOzGeo2aVrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR15MB5524
X-Proofpoint-ORIG-GUID: GeZobqBQZwAAnHASRJMYUlEI99pZcE5u
X-Proofpoint-GUID: GeZobqBQZwAAnHASRJMYUlEI99pZcE5u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_05,2024-09-06_01,2024-09-02_01

Hi Jens, 

Please consider pulling the following change for md-6.12 on top of your 
for-6.12/block branch. This patch, by Xiao Ni, adds a sysfs  entry 
"new_level". 


Thanks,
Song



The following changes since commit 2d2b3bc145b9d5b5c6f07d22291723ddb024ca76:

  md: Report failed arrays as broken in mdstat (2024-09-04 14:52:45 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.12-20240906

for you to fetch changes up to d981ed8419303ed12351eea8541ad6cb76455fe3:

  md: Add new_level sysfs interface (2024-09-06 10:31:12 -0700)

----------------------------------------------------------------
Xiao Ni (1):
      md: Add new_level sysfs interface

 drivers/md/md.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
