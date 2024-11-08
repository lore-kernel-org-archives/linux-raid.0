Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6555D1922FA
	for <linux-raid@vger.kernel.org>; Fri,  8 Nov 2024 06:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731045695; cv=fail; b=SuUfC2IM4vWrgHO8qtgt77LzkLDg8Y8szm8IIui1MqSTr2KHuGBXtHWYU5H3C8LBYqmEknvgP+zTU8/K3o6G5/Huvz2AQDlB0s1GFEOXSyLwMfgbs8Bz9U9K0n7ooMDXfEBBBhFC9VY0Et/HYhH4BK0W18Ve4h7PWCWoQEsqfvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731045695; c=relaxed/simple;
	bh=9bPxAbdgyhTVLsbfWMaGMYM2MhjvuCe4Tgayc6Ct7uI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=askW4dghF2fIFYTXOCmGvWoAOPCFxWPxdRWq07OKoIlxAotuuyilYg3hTpHNikFwKlWcuoK0zY7YGxDTpf1UjCPYRLMp9/Lbblq0ZPLOzWrhKEY7MvyATbjAJtbF2bXWBjkkSJo+IyNb88pKsGmIwToiVYNCJlrRabCTnOhwh4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=b1YsG6Rc; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="b1YsG6Rc"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 4A83YCF0016442
	for <linux-raid@vger.kernel.org>; Thu, 7 Nov 2024 22:01:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-type:date:from:message-id:mime-version
	:subject:to; s=s2048-2021-q4; bh=9EJevz3AK2YkOSET1Rig9DiUJJLmuD8
	8ga844yRd63E=; b=b1YsG6RcE0hqt2rdp/+Sh/dpfbN19hkiTHZvZJnzhEoPrKj
	b4L4fRlb/R3Kw5ZP8aKdQSW1o7j6EApmKodr25svYtrPtGYEamiWBLij9Nc6ZPRU
	2M65uI+lZZcTduGaiymGhxmSsZuaDyo9ns5Mcy9+2w8UG2T4GtACAdH6/x3MSje8
	PfIwve6b1VzjdCDpb6WTLFEnxZBEh1yxTqOu8XS+G77bcm+RVAi+MsTgQVadl/X1
	hN8MH6z2cWT7zreTtAQ4msfN1iI96QUtBUligXa2Zv6IONJ4qT/KxEzcOQ1us9sv
	JTXqqJuX8Rf61BpeEw7hrysOcSufzrDTJ7cq1fQ==
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by m0089730.ppops.net (PPS) with ESMTPS id 42saup8g31-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 07 Nov 2024 22:01:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IJl53sUTRh1FPFM4yYTbtBtCVGLJuKP/GfaXqz5DC6YCX3L5siL7OKjTGjrYmcdjeX5eaI1ZS+m3o6IHaVWpDS0/KCuHTVSU0tr/CGbzmZqTLDUAeFiJIoghFnIPr9MQcbD1KfPogmoOQ/DLjWfKfXsCvFgWwkRR9apgXcx4Us0uGKKYPNpUUWStESfZb1j+J4oLxHi8M5RP6/gxSHiPMW1erPguFLqbA/PmFfPK6LuV3NkoQdqIpTIJEMibMJgBw+7SV6NAX17XG5qAKCWfjzMpNJ81si9VVjbW2vcpYPo691twpW+6K5TJFCyVFaYtmICtmaI9iUHeLEKD6Uk++w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9EJevz3AK2YkOSET1Rig9DiUJJLmuD88ga844yRd63E=;
 b=BixknIPpYVy1SnUeF8ytlhFSafKo168HFsm/bhwcVj2/1Wd95ZwcDX4eei3urWzi2NLEkelEQ+y9U2gMtEOecKZb9o5F0V7rTSdlNomxV+dqhRHVv0DVKNC8NJiAAdbZV+MfP/JSHvaEns0Jih7Vb5Ii41WDm1EEODyE7Cgfy4eRfAIh8LJz2zKwsCdLFK5HF1ANCAs3T7AYnMSSr6cAZJ4b6Bt2yg9vknNYBVEJ7h2DBXNnze+DOmW8kXWBfd6SM2pjXvmzzGlDBc9MbNpNIdGA0RcsjQogDoOIGYFElWGdcO6DZaXIWIRXDtF4sHPunoWTkGPEj2LCZlBazWpNnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by SA1PR15MB4642.namprd15.prod.outlook.com (2603:10b6:806:19d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Fri, 8 Nov
 2024 06:01:29 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::90bf:29eb:b07e:94d9]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::90bf:29eb:b07e:94d9%6]) with mapi id 15.20.8137.018; Fri, 8 Nov 2024
 06:01:29 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Song Liu <song@kernel.org>, Xiao Ni <xni@redhat.com>,
        Yu Kuai
	<yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-6.13 20241107
Thread-Topic: [GIT PULL] md-6.13 20241107
Thread-Index: AQHbMaOnUq/SxWBSGE64OSpRbnaNmQ==
Date: Fri, 8 Nov 2024 06:01:28 +0000
Message-ID: <276F740C-6626-4DB7-8612-2DA8415EA6F0@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR15MB5117:EE_|SA1PR15MB4642:EE_
x-ms-office365-filtering-correlation-id: 5a989d88-a24a-4d1c-8cbf-08dcffbac98e
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?9Sltcod9T/VcNwHYFQVK22pPXl/3wgv1eISRTqU4HlFz/0iNPd0zS/eQGWn+?=
 =?us-ascii?Q?8ylBAYGrAqxcR9GZu0RGTWNRJ8yjxKyVMuQOsvO5aSXUtzc1ynaAUEM75ptX?=
 =?us-ascii?Q?fN32uPsYFvpX2h5t/K4TAC5jLvpDWQai80Xnrl+4AG/WLOE0Rh/NZ4V3M364?=
 =?us-ascii?Q?1bW5yWbCUiZnzsg12ySE072xipUYvvFXwOvSidPVmW9UwMQ2DwTSt3G1CEPr?=
 =?us-ascii?Q?av2ENLkM3Frb0QwEJqT9m1vvrgK7rzpd7In/QFDw6AzT4o6uxFHORRNCZ9tT?=
 =?us-ascii?Q?Xb3aLmqKNrUESm0crweCW4oCzv2vXSKWr3lP4XupuDkG8JdpbagWaACj/RWc?=
 =?us-ascii?Q?12BML1EHeitYMm4pS7zCTm/yE2orJyMV1a5kvamRVe5IPEXJY1di7cQbBPcx?=
 =?us-ascii?Q?pISnPkpuzN/opnihvuZhWlG4qNToDJbsLOUGY+11+rneMfe4usJaFehJITtK?=
 =?us-ascii?Q?JqHKdDjN5naZwRGrVobA+IXPBg+N9FSR4oiFgMABiwM17ewlmQYyPe3otXDI?=
 =?us-ascii?Q?heowAxMIj8K8MqRvyB+CzKpjtuZiDLcluUrtagahWm/Wc4Yg3ezoceaXWm5P?=
 =?us-ascii?Q?owT8yR6GvLRpBpKa6pmvFK7U/eaOPoHkE9ioTXnDIQX+ja8pxIaH/DTMf4el?=
 =?us-ascii?Q?uwbDPVh2wWW04WSXPcFKqFGLNKGCGEOYBKbLfSPFgoWRF9ZShHeNBiczKpdc?=
 =?us-ascii?Q?RfaEgTiT7BjGdHFoeor2f0v4xiDeLYZQcN5up7Cxxj2030oUq3aXOSX+RY00?=
 =?us-ascii?Q?HxcspOO6EyC5xW4oNl8UBR5UF5OBp5gQ2Ed0Pk4jiLKF+bgVLxmfFNT/4plH?=
 =?us-ascii?Q?/YdsJUyW+aJTemZRoPvrQfO5tZSW+0PcP/5m0SyKnwgSQBuxc7tYlHX3ptY8?=
 =?us-ascii?Q?Yz4kD4SJ1MFlWLD5kfm9SSgV0WtdliKgSz7Ar2oUyWj6umjlAKQgRw0XRDBL?=
 =?us-ascii?Q?534MMF5Fad6SaCKQtXgdE35Bsph8Pr8gVnmkeBNSfPX6T3xsyHr3H/4WQJdd?=
 =?us-ascii?Q?PirgwTihJNcTthpVnO7jW4w+xdKwJD6ZKS55QchlNZjuCN0ACNZIFSCkQtIC?=
 =?us-ascii?Q?8dsxUCkqGj14GYUarycCz2Dd0XaRGTfSHaWgP/bvIqybLeHAluWwinn5Mni3?=
 =?us-ascii?Q?OrOnQ1wlUuMTyI1wiPWZ1eb23yfm9W7bh6ph1w0aNw4VvgPwa85l3hGS16zi?=
 =?us-ascii?Q?6XJCwGJtAcJ++xaJfj68RzuSY8YpEpOXNI74gJvwBi4hHSbSPLZK0qBjboXB?=
 =?us-ascii?Q?XbUj+Y8sMyxwAb7M4xtOH+8ZMwa1mEdUYEJRZ0t2MXDUIvSFM2N508/6H9/O?=
 =?us-ascii?Q?rRYXZtunAo/LZB1mjw419v+dbcMNWIxTLTN8svKQgOASDuvOeli7tFEPn5iP?=
 =?us-ascii?Q?GO3/CLIJQSKpVPbU8KQgW9RQCq9u?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?6EDSbKhZhISmye1EioqZiRIof+HwIuAHmIlcRgF26YWY31wCFdotlftPVv6u?=
 =?us-ascii?Q?bmkafdsj7xDN50Pp1GGKN1FXnzoM2Nb+B/fxEBcPhIpRSwDAshIGSOPF3kYN?=
 =?us-ascii?Q?Wl4AtklPjwWf+jzeJaoslyL7KWlk1Oz033TTM/F9dAWbqJe0JiftlnIJByO7?=
 =?us-ascii?Q?V0nSw6gg1s61AT0AmrhcMMnc1nUFYKv+AXDBN1iFkSyddM7PkXCr8G7Ixroh?=
 =?us-ascii?Q?m7dfyFaJmaDJ9xoQx7LVCLMprrVQTW7hB/omkFJqtXFeft2YpeMDRe3jQ3r1?=
 =?us-ascii?Q?WilBbN3/gPXLfF54FUmNIlgeySdpiE9OOivflgK/eLkBaJvhWQzIv39Xz0dM?=
 =?us-ascii?Q?vFoES1tMjiUcGrdf9yYBvUCMSkGLcpm6xQrD+xGUU1ejW7kRPN9hGMN+Hk5p?=
 =?us-ascii?Q?DkkYbyX2sYhbMVy6bmOpSH7L9LJE5HUuPaYQHqbVUxYHzTdrlGeDeZVGyACm?=
 =?us-ascii?Q?u7Y6MmqNHGGnqUYBHHAM6rA7Dtv7fhxf+J6rfBnzJqJEMaPcha6rg9Bq+TdK?=
 =?us-ascii?Q?3h+s7BbiOGqyABhe2AfIusX9INlfZq2VtfwDY5jhgVzCQaxaqf2MBfblJmJL?=
 =?us-ascii?Q?D89hAICJKlGb5YWV6gm5cQ9EzSZa6vTTPvArnTEgSX6qH5bv1qLmJyubVP5K?=
 =?us-ascii?Q?PSLbXYeFcBmEapyrQmV17mbNOtnxxP2DOeJyYnemFekWy+dGvw/7XJ2XlqSn?=
 =?us-ascii?Q?YhIl3/tEAHs6dni4kqgl/2DDI3+DkASNmk9L/1TZxfw7ievPoWUEDsIIaxES?=
 =?us-ascii?Q?EievjB1FIVOsG5xImGQFJkhgSRD0rCLphPhGca+TaGxUybxmjaWrcwhw5I83?=
 =?us-ascii?Q?QDJsEvQZLXHnPgmOtnoWzLhAmzM0IWCGWUdTCnh1YaDOwyrm5b9DovBQEE5v?=
 =?us-ascii?Q?VZxC7pgnH1LaMI0KKgLTYGRQw6ZT7oZ4PSnlQRhqIXkeh2HmSV8B5aGWk4Qb?=
 =?us-ascii?Q?LuDhoWRiJLfEC7m38ipUg8vDugJRZnzuxpqJfqcONZ2Ntq0t3SYIN1CHigB+?=
 =?us-ascii?Q?iTEERMfeZtQcLVbtTmyJP3r2j8BDZfaCpXQMLg1t9x6FRZjZw220CN08jIwX?=
 =?us-ascii?Q?O5Mt8FGew/gQuKGZVLwZF/7UCguaRqLVCH1dhsXLkGeSivgq2CTGAifPEVkj?=
 =?us-ascii?Q?JrzYLqCgNlriiUIFZRngrQviQprq6WFfYh7Us7xwuUFX9Y4q06fVMfvaBtSU?=
 =?us-ascii?Q?YNCxcL3PApDZeKj+EnLacQSdDAnh4EVcN8kjxUDU2AmYPpOf83IhA8lBpwFt?=
 =?us-ascii?Q?ekqu3JC45FTsFhRHDo2qW0igTo/7EDh2NPv8rVi6bWw4/c8ZL9TMwckAnHTA?=
 =?us-ascii?Q?1qb2lB27lkYozp5RymiXA46pdNzdZfXJFIi0qelASMfkA8h6JjB3QwrLrYNC?=
 =?us-ascii?Q?5eRic/H1mX2ddpLpP6+1ohtEvF7qc+WIeU61Dv1V+UWo7gbt+bouvm4Vnkgo?=
 =?us-ascii?Q?cNM4RNMLtWV2HejDFhJwV16huwtHZU80HSCkHV6h7KkAaONG3ezvfzaQiCp3?=
 =?us-ascii?Q?vhuBJwxd98cRU2YVpzy1Tf5AkBCAGSikYYT+UOr+k10lYN6GTLJEBwNzVDzu?=
 =?us-ascii?Q?wabI/yxa3PIZr5JaYDrf7cX/GzA31jpACB9a+PXEdcQj92qqoSCDmpJj8dIM?=
 =?us-ascii?Q?rQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A37230BCA1A2E043A202888B97B7EE39@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a989d88-a24a-4d1c-8cbf-08dcffbac98e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2024 06:01:28.9981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zXFSFxIIhyP2N3BfGBk4WJ+xafNY0ceP4nx0aBQfT1ABTO9vFvJNX1WqqzmUHvC4lrG5oZyZuSdz9r+MyZhzDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4642
X-Proofpoint-GUID: UL3ljfrlqKT4noHoyi0RdIvWj_As_dFq
X-Proofpoint-ORIG-GUID: UL3ljfrlqKT4noHoyi0RdIvWj_As_dFq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Hi Jens, 

Please consider pulling the following changes for md-6.13 on top of your
for-6.13/block branch. 

This set contains a raid5 fix by Xiao Ni and an update to MAINTAINERS. 

Thanks,
Song



The following changes since commit 4122fef16b172f7c1838fcf74340268c86ed96db:

  block: Switch to using refcount_t for zone write plugs (2024-11-07 11:21:52 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.13-20241107

for you to fetch changes up to c13c2d2a4b52eacab1c093e5b993c0a6f82c438e:

  MAINTAINERS: Make Yu Kuai co-maintainer of md/raid subsystem (2024-11-07 17:45:02 -0800)

----------------------------------------------------------------
Song Liu (1):
      MAINTAINERS: Make Yu Kuai co-maintainer of md/raid subsystem

Xiao Ni (1):
      md/raid5: Wait sync io to finish before changing group cnt

 MAINTAINERS        | 2 +-
 drivers/md/raid5.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)
