Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012006.outbound.protection.outlook.com [52.101.48.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AB822D7B9
	for <linux-raid@vger.kernel.org>; Sat, 24 Jan 2026 21:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769290186; cv=fail; b=ijoWXI5tj7/OfgfwRFQOLqjGrDEmSw/e7NqbQO3Ro4a34a41YIh6bRTmwapK5Jm/LXVRGV4GeBNg97PRR/0qCjGE5LGfeo7i+V77s1adUERLfcvzMMCd5RpM5B4T8XID7vLHNboCl03aNvlZNUCpxBz5rRWHJcA/oi3dSGWPbiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769290186; c=relaxed/simple;
	bh=di6VtV2j4bqIyUfvsHyG5GNK4y9tbK6DOQEtWUAkRQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N55YwtA2+NglUfcAHCTrBLvJXAvcArbmgiLrWY0sWl9CyMHLHs/TQr18Da85fk3A68qJ9l460QVQ+rE2LnZrcAlYPOkjXyzctzTZT29xSufmaRkSHP0kiermYbyAVNxyIJm4Vnp3rTjFIF3oshG0Ayj9RGgqFe2v8pm0Hub03AM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IzRdEQtp; arc=fail smtp.client-ip=52.101.48.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IzRdEQtp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X/ahkabsMu/Wu9VdTw+OUA868Ufo7DL7jLcTLDHlQ7FcRtHiNuYdp9OOF3Jb3zDC7MStOxPR3YMdac54BQ1afjV5XzOALF6rHzu6sRKe+mMWXgp3m5gxkbAzz8siMSsFkFzIWvPxGjX6Lr7FuBDRE8puANwGVDwonjC5+A3L7PA/wMLUoJyTmr5viMUEpXDn4JJIW1X1TarF9T2fpgWCrB41H1dTDnFDoIM4ov5iYaPaiWwXpceLrzVOwOHYgFRgyv68k/5WTgbrwQopwud/KYyYVrcWpTr7znAaZfrm0vhe0gA+DnwS7+a5tbsSpdyFqU4Ca3XxK6+zdrCKXOaMhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=di6VtV2j4bqIyUfvsHyG5GNK4y9tbK6DOQEtWUAkRQE=;
 b=AH9lfQGWzfZjJV2r/C7wMSjiMeRKua18QL1pDXHXClE+YHLx4BKV6tRJQE+hyfHPSmkAZNeZRcomWew5bSe7rZ2bmcWrWcbi+A8a1PoohmsQbUO7hxHaX9nFuwOzbiyjqMVK0Z6eJvn08Z8tIWksi/k++7TJSvf++3DAn2+kmbXgl2tvaI356K0CzmZS+/QKlPt97urSdDJMnHajjP9oCkbX3ZzvUxwWfgbLU7HrGcRDiaLJSSL5uDNxPUlJbCI1OiicxBHGtW/cPZZhA4Bu4qdFXwMUGcVS/hVnUnQkDyyqVUMKsXtCi1c2Gx5AdmERt4F865yHp+uoZMJ/mT1Hjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di6VtV2j4bqIyUfvsHyG5GNK4y9tbK6DOQEtWUAkRQE=;
 b=IzRdEQtpFgjQVIOriemTHf+7v0was010/VsxrKG6MMnwTou+lxgItZVz/t81+cGsWKdNPcGkkLXR8cux3Q3uGxgMPB5BT1x7/EhYkzcvR/TLwJqP616ETM0Hodn50o1FGX5dodOOCZmGgDAIm6DK480kTedODu/LjfCRlV6aUhPGBQBjgZApCbHbQBBAKuwST7+zIQuRpQxmiyMhwuwqSVjE/rFkU+emHkG8tudtUt3v7tptF/+eOGM+j8uMC3PJ6VaXUiR+HtID1UCPIyM83Y5QEZHT9tX8dI1ghA1yFqLfA6b6Z9Juwi+00j5hDnAWdkghT+YBSoq+f5NSWFIRYA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SN7PR12MB7788.namprd12.prod.outlook.com (2603:10b6:806:345::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Sat, 24 Jan
 2026 21:29:40 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 21:29:40 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com" <yukuai@fnnas.com>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de"
	<hch@lst.de>, Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, Chaitanya
 Kulkarni <chaitanyak@nvidia.com>, Johannes Thumshirn
	<Johannes.Thumshirn@wdc.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH V3 2/6] md: ignore discard return value
Thread-Topic: [PATCH V3 2/6] md: ignore discard return value
Thread-Index: AQHcXZzV8+Wgjk0PP0mjg0Cn+Vcw1bUMWn8AgFXbXwA=
Date: Sat, 24 Jan 2026 21:29:40 +0000
Message-ID: <b89bfaa5-a7fc-434f-8cc1-afb4dc317f6d@nvidia.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-3-ckulkarnilinux@gmail.com>
 <938be45c-dcd9-45ba-b6ba-0fd29b0815db@nvidia.com>
In-Reply-To: <938be45c-dcd9-45ba-b6ba-0fd29b0815db@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SN7PR12MB7788:EE_
x-ms-office365-filtering-correlation-id: 8cac00cd-82dd-4ddd-ca5e-08de5b8faef3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SWdOR2JaSzhSeFhpeFVKRThoMHljVEFPM0dPQzBDcGlZOVpVaDhPTEhLdlhu?=
 =?utf-8?B?NXZUSWQ2dG9mNTB1WFZ3UWdZTnppaEVueThtYWR5QUgyakRNWm5nQnNuclI5?=
 =?utf-8?B?ZXhERmIrL1Zac2JLVTUvNHJtbmhRNW5JVkJmQXE1SG5LYU5yeFVySGZxNUxI?=
 =?utf-8?B?OWU5amlidGxXTW1nZnNVa1lKbk9RS0pPMWNpZFVPQlZKODl6KzEyMGw0T3d1?=
 =?utf-8?B?V3o1eU5RdjAvTVJSWDVWaWV0U0Q5aVNIQlk5VGxlS1RFSDRqNzJkUVE5UjVK?=
 =?utf-8?B?d0VkS0RWR0JTU2ZINjNpY1NySU5NMUdxVkZUWVBPTDZVV0RxdkZGbHNPMzZG?=
 =?utf-8?B?dGpjQ1FMTU5waWNRNS82THJVNzhmeW41SXlYSk1VNzNaUENkQXpzZ2FNeXRQ?=
 =?utf-8?B?QVJkTmtBVzhBbnlFTGlhWG1VV2NiZndXRTArZGRBbEMySzM1dkZVQXJXWWUv?=
 =?utf-8?B?Q01KK0ZybFVtVTRFc253Vm91VDZ0Nmh4THg0QVFycSs5bmM2RlNRQUxKK0Yz?=
 =?utf-8?B?dUhEY3JkQVZEL0txVHp5ZytCOHRnRWFWZS90WktIeG5OekI2Qlpjdi8zbWky?=
 =?utf-8?B?YWNjd1pZcFJrc3ArcDZrcmgvOWNVV0dzSjJQUEh1emwvY0RzeGJGd0VCcDcr?=
 =?utf-8?B?WU9ZQ0c1Q2ErTkhqMUtwM0p5WWlEUHBXT0hubGpEdVp6ZnlBV1ZFbnVEaThC?=
 =?utf-8?B?cjB4SURoNTI3elZDUVRmd0wxOG1CQ0hrb3NpYml4TGE5MUhucmVRblI2MmZt?=
 =?utf-8?B?eEgvTzI4TVUyd1puSEFlVE9sUVlxcUFPYmxhc2xFZEZKMjJVb3FzVjd3VFJ6?=
 =?utf-8?B?WFdWT0NpNDYrY2FEQ01QejJubUQ5ZDcwcDhOa3FVSnRuODlGU3F1Q0VxVFdj?=
 =?utf-8?B?VnFvMnpVaWY3dFZQOEd2ai9oM0pDejNCZkhmSHhISFpCZWk2ZklNM0VJRzdt?=
 =?utf-8?B?RDFNNmhRMjJBQ0tYQTYyZzV0ZTBKNE5uYlN6clVXaDJHK1NLQXNSM1BpMlZn?=
 =?utf-8?B?cXdoQVN3WDlHd05QSndPS21wWGtVM3ZUT01IdDhoUmhtQVlod0NodkFreFMz?=
 =?utf-8?B?RWNsdkRXSWRVQ3FCelVzaHZjYnBhQ0FHdE9kUWpJNCt0RGh6cjFGTUp5RkMz?=
 =?utf-8?B?Mzd6UGhJRHlLRDhPYXlCSDlrT1MxQWJwMGN2UExZbjJuNkNBODBTNVZBQXFP?=
 =?utf-8?B?WmllQktvTG1KbE4vZzAwbUFCcytNcFE2QmFNdDQ2bUFCdU0zbHJVOUN1ajly?=
 =?utf-8?B?YkJCVkp6REl4aERzTy85NEFkZ2dwVjZpZVJWcDE0UEEwZGprQ1hNS293ME11?=
 =?utf-8?B?ZTNpUkJnbjhWU2o4RStrKzJmSURzU2ZSKzU0SzhJZXVqNDQwOW1NS2J4LzBP?=
 =?utf-8?B?VTNXSG1wV1NuUTlUendETG01Yk10ekNKR3ZTTldTenpXcHB4L3ZZS0N1ejJE?=
 =?utf-8?B?YkFOeDJ6MWRFNlRTL3Y2Qm1ibDJ2TjJ0UTJuR0xBREpRUHFaSXVVRzRFNndn?=
 =?utf-8?B?OStrN2x4VVRJNWorY0VrMnpscjVEQnFxTThqaUNaTWFRZWwvVTZGSkc2L25G?=
 =?utf-8?B?TjZBbTFxSENEcWQybEhVempXR0o0TlIzNHFZYzdlclphOWNSZGhRaVMyaVpu?=
 =?utf-8?B?eDBrNDFHRWl0NUVGcG1sRVREMzFlUzlEL21kd2prZDdlYm5oTy90RCtGZlVP?=
 =?utf-8?B?cjZVdjJtNU9ydmNRbUowc1NLOEFIZ1ZzejZlNDhKZ00zU0hqU1BGbHQ2T1VL?=
 =?utf-8?B?WnRlZ282UUJzU1NVOFZYaFFGK0x5Ni80L2RaSHJGR2xlTnlEYnBSVGx1eU5w?=
 =?utf-8?B?TEpKdkc5T1JyMkRJMk9MTDA4d09wVUJ0b1dtb1lub1VmNXJOVkhoSjdMejZC?=
 =?utf-8?B?QjFvaElBYnVBRVRYaUJvZmx4QlFud0lPOUdmUWZnQmdpbUNUenZ6eEUzenVQ?=
 =?utf-8?B?SzdUTTNrdS9wT09nT3ZhclVqK1dlQjFORTRjNUwwQUJBZW1PZTNSNnppaTJO?=
 =?utf-8?B?bTN1bUptcm53aGxVM1kzYWZBSTN6V3lyQS91RzVHU0JFQ2hibVBTQzI3SVFu?=
 =?utf-8?B?OTNjU2trQVFIay9sQzhoWWxIUUlmVWxCZjlJN2cwZ0tacDJ2ZkdBaDhuVHI4?=
 =?utf-8?B?Z0hxRFB0M3FsallpNWdQVVZ0d0loRlFPQjFJMWlLcjE3aVV1N3crSFlScExR?=
 =?utf-8?Q?rpAGeJ2tN/tMY28958Zw4Kc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZGtvLzU3MHRET3N6MXhnZ1lzK0FJZzN4TitYZmREazREVW0yZ3lHOGRYZW9W?=
 =?utf-8?B?cWZLUG5RSG94MjFaZGVTL0ZlTlIrclJ0dUlITkRhcEJQNGRxelZsNlpjOVRm?=
 =?utf-8?B?dFBIZWo5M3QrbjdVY29NSmxPU2NXYlJqb1RlUHJPM2t0K2lieUJUeUkzaTlQ?=
 =?utf-8?B?dmxYR1ZzYlJMYkFzZ3ZZc3hhVXYrNlhKWUxKa3gxT2ZET0NlZCtqMkZaelRT?=
 =?utf-8?B?aEw2VkFETUJvVEtrcE5yVG5sdmV1UWR3eWh5ZVRZa2JzLzZzVWVWSDhQb1I1?=
 =?utf-8?B?SFNxeVk0R3RzdS9Ka0tWOEJSeWJVUFBPMk1qNFQwcCtocWRSNmtWK3JBMllC?=
 =?utf-8?B?cTJ0ckYzUXVodDEwbzZXZndTUEZjMHM0aHN5L0lFWXhLSE50MTMzUGdLZ214?=
 =?utf-8?B?YitCS1NzY1Q2d3VxRGtFZE11MlY5SXUrenh5T1VuRlFBZG0zS1k3TGRObXl3?=
 =?utf-8?B?V1BRM2JvOVdXMVlsTlhBM1dSSlBiUHN4VW05NmdFYkpoY0dNSVVLSHoxQXhm?=
 =?utf-8?B?Nzc4QVl5Q0lmNGQ3ZUppQ2Z3Q1l0NzJua3JDT2NQeGpURzVpd1lWMTJaY1FC?=
 =?utf-8?B?Z1ZwWVFEQmUyTSs3SXg0cmZWbExaRHRoRzFFL2tuK0grTEJrMHdSYmV6WmI4?=
 =?utf-8?B?cHQ1K3NHa0w4ZklLYzkwUEczM1lRZzdrd1NReWV1NHhWYUxXK1lPajcrcjIw?=
 =?utf-8?B?djJyUXhTWHBpTEQ0YndBNmpEblVDa3NHanVvYkpxY2dlNEpLamRPKzc3L2lR?=
 =?utf-8?B?U2hQbEJYellxQTV3VHRXOFRYT3VSRTZtRzJmSmxnUTdQOEd5eElnVTBiSUhB?=
 =?utf-8?B?L0hZdjV2OW8zdWtUaXpqcHdEczBzRmw4SUhUcHlFLzg3L2tMaTBGOGVLVDJZ?=
 =?utf-8?B?K25YbFFLYnBlT0dLYVFYa1AzcVEvVVNTb1JUTDliZEFYVVV5MDY0WUM1ZHZH?=
 =?utf-8?B?aTlHYzNVNmdITGRDMUxYYXRTMU51dEFuNWRNdmFBT1BkNEhtazJPV0MwWkNO?=
 =?utf-8?B?cGgzN0NZSTY1aE9wR1l1NHRtQnBXK2ZIRmY2ckNncUZZNUdHQzFaOG5qdndZ?=
 =?utf-8?B?UjJQeEVTYzNLZlNKTm4wUDQ0MEZLOStPVzdqYXZNTEIvSVpEc2J1alZYUlNV?=
 =?utf-8?B?eDNjSCtZeEFUdmZyS1Q5WDdYbXhLNDRlbmZvMWVJNm9wRnBmOE9POXg3c3NO?=
 =?utf-8?B?djFoUFNPSnlPM2FydHJBMDZDa2RLbldMNVBSWUtOQTh0SkVnWllheUp5R21k?=
 =?utf-8?B?aFY4Y3N4UHVUVkdpZWRpQzR0a1hSeUhCUzZuWm54VW5rQklHdG4xY00xalVy?=
 =?utf-8?B?TlE1dkdQUGJTc25vaHFlVVQ2ZWlRM1RrR1U0a2RoZkU5WUxVcjRCT1g0cUNY?=
 =?utf-8?B?T0lya1paYjI4YXYzczdxV3IxZ2JzbzlMbHNOWG9BS3AyZTZxbE5oWWU3OXdJ?=
 =?utf-8?B?K1lseTVVY3dhQTJBMkxML2Z5MG5CTEhTY3JYdHN4VlJEVnArSWY3dWJTa3hT?=
 =?utf-8?B?cGlNWTR5RmhpVDNQS0c0WVVIMHY3SWZrYVlzRTFNRTNhSllZaUtxRVc0and4?=
 =?utf-8?B?cG9teDFxS2plalp4RmZpeGtSelFZS0RnTW9FVTc4TURGOEFPWm0xcHgyVXhK?=
 =?utf-8?B?VFpYQXIzWlFKZjZ4Ym52czBPSENmUTlpbnBUYzVid252aTIwUnVxQ2E5ai9S?=
 =?utf-8?B?cXBlU00yVU1rRXY2SXRBRFpBK1NFYmtvdGxzb0tNeDIrVk1vczl4R3BXeWVu?=
 =?utf-8?B?OE5HL3dSbWY1Uk52RGIwaHcxc25vMG5aUmNQaVBXTnlpQm9TL1ZzVXFNaitZ?=
 =?utf-8?B?Z3d5MFhHUllWNUxGL0pBUER2WmJHTHlWcmNTOWo1SnduVlA3Zm5tRXFEQlFD?=
 =?utf-8?B?UUdBVCtpZGthZUNuaEtBci9POE9qQlNibnpaY1hsQUtSdTlsNEFnN0VhTHZ1?=
 =?utf-8?B?Z2xVSkc2UFlCMGxhb2hyRndEVjh1YUY2NDZLR0hTbjkvZXdLQUJ6TmRTbkEr?=
 =?utf-8?B?UUgrc29ZbmhXV0FmMzdDbklxaFlScm9jRTR0Z1djSi9EaGhPMHJjcjNCanVC?=
 =?utf-8?B?NHg1NmdVREpFdGE0aHRIVENaVEx0eTVqR0dzcVQwL1U1RCs1QUg5dUtCNCts?=
 =?utf-8?B?QnovcUg4TUI0Rk8wNks3VDRkM25YWEtYMFdZN3FBQU5ZMFdibThIcVJKcDVN?=
 =?utf-8?B?SVlCNndORTRrekhIWVVIWE5TeU9vZGhnRmN5OWNQTGhXNldXblBzU3hiTGJr?=
 =?utf-8?B?RUxYUExXQ09TcThxREZjdkpxK3hHMm1zTk5QYUxGN3BESEJGd0Z4RitEL1cy?=
 =?utf-8?B?SDkwRWhsb2lJNnpRNlNqMWFrdWtWZS8vbjZUYjFvWnd0aDlERGo0bTUzZ3B5?=
 =?utf-8?Q?xo1r6NXyHSkGwsuOe6yI9hz9g92BJuTSLc16i?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E20C5EFDCD0BE4B973676C728218DE9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cac00cd-82dd-4ddd-ca5e-08de5b8faef3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2026 21:29:40.6505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3PyrP1dDggmYdomCdF/rkKAUQ/uwS8cmAx5D2L5uWCX7hlIs2vcCcEceG8h6CNgVtv46VYRVJGgCuMkDbyhNOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7788

T24gMTEvMzAvMjUgMjI6MjIsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToNCj4gSGkgU29uZyBM
aXUgYW5kIFl1IEt1YWksDQo+DQo+IE9uIDExLzI0LzI1IDE1OjQ4LCBDaGFpdGFueWEgS3Vsa2Fy
bmkgd3JvdGU6DQo+PiBfX2Jsa2Rldl9pc3N1ZV9kaXNjYXJkKCkgYWx3YXlzIHJldHVybnMgMCwg
bWFraW5nIGFsbCBlcnJvciBjaGVja2luZyBhdA0KPj4gY2FsbCBzaXRlcyBkZWFkIGNvZGUuDQo+
Pg0KPj4gU2ltcGxpZnkgbWQgdG8gb25seSBjaGVjayAhZGlzY2FyZF9iaW8gYnkgaWdub3Jpbmcg
dGhlDQo+PiBfX2Jsa2Rldl9pc3N1ZV9kaXNjYXJkKCkgdmFsdWUuDQo+Pg0KPj4gUmV2aWV3ZWQt
Ynk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+DQo+PiBS
ZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNv
bT4NCj4+IFJldmlld2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4+IFNp
Z25lZC1vZmYtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8Y2t1bGthcm5pbGludXhAZ21haWwuY29t
Pg0KPj4gLS0tDQo+PiDCoCBkcml2ZXJzL21kL21kLmMgfCA0ICsrLS0NCj4+IMKgIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWQvbWQuYyBiL2RyaXZlcnMvbWQvbWQuYw0KPj4gaW5kZXggN2I1YzU5Njc1
NjhmLi5hZWI2MmRmMzk4MjggMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL21kL21kLmMNCj4+ICsr
KyBiL2RyaXZlcnMvbWQvbWQuYw0KPj4gQEAgLTkxMzIsOCArOTEzMiw4IEBAIHZvaWQgbWRfc3Vi
bWl0X2Rpc2NhcmRfYmlvKHN0cnVjdCBtZGRldiAqbWRkZXYsIA0KPj4gc3RydWN0IG1kX3JkZXYg
KnJkZXYsDQo+PiDCoCB7DQo+PiDCoMKgwqDCoMKgIHN0cnVjdCBiaW8gKmRpc2NhcmRfYmlvID0g
TlVMTDsNCj4+IMKgIC3CoMKgwqAgaWYgKF9fYmxrZGV2X2lzc3VlX2Rpc2NhcmQocmRldi0+YmRl
diwgc3RhcnQsIHNpemUsIEdGUF9OT0lPLA0KPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJmRp
c2NhcmRfYmlvKSB8fCAhZGlzY2FyZF9iaW8pDQo+PiArwqDCoMKgIF9fYmxrZGV2X2lzc3VlX2Rp
c2NhcmQocmRldi0+YmRldiwgc3RhcnQsIHNpemUsIEdGUF9OT0lPLCANCj4+ICZkaXNjYXJkX2Jp
byk7DQo+PiArwqDCoMKgIGlmICghZGlzY2FyZF9iaW8pDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuOw0KPj4gwqAgwqDCoMKgwqDCoCBiaW9fY2hhaW4oZGlzY2FyZF9iaW8sIGJpbyk7DQo+
DQo+DQo+IEdlbnRsZSBwaW5nIG9uIHRoaXMuDQo+DQo+IC1jaw0KPg0KPg0KSGkgU29uZyBMaXUg
YW5kIFl1IEt1YWksDQoNCkp1c3QgcHVsbGVkIGxhdGVzdCBjaGFuZ2VzIEkgZG9uJ3Qgc2VlIHRo
aXMgcGF0Y2ggYmVlbiBhcHBsaWVkIFsxXS4NClVubGVzcyBteSBnaXQgcmVwbyBpcyBtZXNzZWQg
dXAuDQoNCkNhbiB5b3UgcGxlYXNlIHByb3ZpZGUgcmV2aWV3IGNvbW1lbnRzIGFuZCBsZXQgbWUg
a25vdyB0aGUgYmxvY2tlciA/DQoNCi1jaw0KDQogIDkxNjkgLyogVGhpcyBpcyB1c2VkIGJ5IHJh
aWQwIGFuZCByYWlkMTAgKi8NCiAgOTE3MCB2b2lkIG1kX3N1Ym1pdF9kaXNjYXJkX2JpbyhzdHJ1
Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1Y3QgbWRfcmRldiAqcmRldiwNCiAgOTE3MSAgICAgICAgICAg
ICAgICAgICAgICAgICBzdHJ1Y3QgYmlvICpiaW8sIHNlY3Rvcl90IHN0YXJ0LCBzZWN0b3JfdCBz
aXplKQ0KICA5MTcyIHsNCiAgOTE3MyAgICAgICAgIHN0cnVjdCBiaW8gKmRpc2NhcmRfYmlvID0g
TlVMTDsNCiAgOTE3NA0KICA5MTc1ICAgICAgICAgaWYgKF9fYmxrZGV2X2lzc3VlX2Rpc2NhcmQo
cmRldi0+YmRldiwgc3RhcnQsIHNpemUsIEdGUF9OT0lPLA0KICA5MTc2ICAgICAgICAgICAgICAg
ICAgICAgICAgICZkaXNjYXJkX2JpbykgfHwgIWRpc2NhcmRfYmlvKQ0KICA5MTc3ICAgICAgICAg
ICAgICAgICByZXR1cm47DQogIDkxNzgNCiAgOTE3OSAgICAgICAgIGJpb19jaGFpbihkaXNjYXJk
X2JpbywgYmlvKTsNCiAgOTE4MCAgICAgICAgIGJpb19jbG9uZV9ibGtnX2Fzc29jaWF0aW9uKGRp
c2NhcmRfYmlvLCBiaW8pOw0KICA5MTgxICAgICAgICAgbWRkZXZfdHJhY2VfcmVtYXAobWRkZXYs
IGRpc2NhcmRfYmlvLCBiaW8tPmJpX2l0ZXIuYmlfc2VjdG9yKTsNCiAgOTE4MiAgICAgICAgIHN1
Ym1pdF9iaW9fbm9hY2N0KGRpc2NhcmRfYmlvKTsNCiAgOTE4MyB9DQogIDkxODQgRVhQT1JUX1NZ
TUJPTF9HUEwobWRfc3VibWl0X2Rpc2NhcmRfYmlvKTsNCg0KDQo=
