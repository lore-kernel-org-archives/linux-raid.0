Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012003.outbound.protection.outlook.com [40.107.209.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163E91799F;
	Wed, 20 May 2026 00:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779235885; cv=fail; b=b99NSbjcjVOIO4BmKCEj8A+sNVgrRT2JoGRqIrlXyPS4T3s8jWSUYo8EmUUHRPnFo/G1YPFxfcMomNNNkRD5Rm4j/wWkyWbWtHdaojV4Ntu6a9C7VkySvhEjY5tzUu7tEJ04bP9zH9tawhcXeQgASkruF/ER+v56d74wtHaaDZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779235885; c=relaxed/simple;
	bh=YDB7d2Wyu6HXiE/03iFJRjZhEvxwn+egKrsqEpd803c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Lgziua2olaqqUW+jAP0A96fzJT8lEz4NCrJateE7f2lfvmsqwTXKB6dPhRJqF8prSl91XuDUAZAtfnijcgpk0lx7C3pid8yOjUjge9me8YWXzneKq9XkbfHRCvpEhMniQS3EijJP+ixHBj4zuiMIrfZ5ToxZliSs+J7+Tc8Fsmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I9brglsl; arc=fail smtp.client-ip=40.107.209.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I9brglsl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gW8EkjJsGdGzMprwA3yEEpzvCc3LdYkM08KQrH27iv//75b7tR/pJvhl32ZiIuMDwl3cmKS0LsALls+PS3wTCaQCE++ahNlfLZS8mXKUkVDfaobOaa5Pu17njRLJBHkZTyJxkxgI/7JWvEiXe+JHfm159JS4nVPU0n61KmNdCmXS2apjTiwgkO7Kcpxv9rH29u3xNGCIAu8bzeEIQ505EJgZP19HNrGoOMGVDmn8skrqK2fwPhZCyZcGxSCweBUpXz4G49PjAJHBImwTb9hdn1eTRIb6IAnfPz6gWxxrAsbzAv4jIHywI5Qy6nE5BAF7ilA+vSLFsJ8PfnW/VUjXkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDB7d2Wyu6HXiE/03iFJRjZhEvxwn+egKrsqEpd803c=;
 b=n+OMXiiU5xkHTr+XUf9+7bqxhC76g9o+JqFoblouSdCYrQdWS8/Vklf8JNLqvTDGTNcIeowcszodP3kOGVWpQKhPDic1l6O9YYhw1hsWOCDFTEoKbD7Hy/N7DO/4Jjo/yev79C6fS+TzCeDxLBz6VjtZIFCzDUIVazbDOYtDp7rfHItVpm6GoRWPD4mJMmM9qf8HCqcy4W3pkKxgG0qXQrBOGKQpDxaDA2fRwqUKReZiSrsTxx7Y5NK1K02wWWpmt36Yq4vo6ZiUbjJ5sFqZXCsVU3Qh2WKGeJRqi8dAMZb0i8unc7A6QrUircrohIvOOlnaPCwfdXwGhJtAVyZzdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDB7d2Wyu6HXiE/03iFJRjZhEvxwn+egKrsqEpd803c=;
 b=I9brglslbLwuQTVdDPQb8X5zoUIes/33QmLhiSSQeAjx4emiJxGsVWpzcM/3YDWRBMMccHu56Fw6uYacwKvluFJU39Qj1Bgm6lhnjlsaNPB/GQNytjB3oKl90OEGeUudM5/ujd2UwOY0jizosDL1K0vDgc7ZFKFewC2eEUYm81c5k2pbjPUBLFGldoxjSZaWCn680zQsVrb2+pVUX2Bh1fPZCkvhzNuEIqharhRgDXuP3GMZO6FomHfSYGm4RoZmdBshMaMHyC4ECPtpMEHSd5Hcc1l8m9KdLtQWB0m3Vz67iBXJx12/CvJdtm0PlTvDMzGuriu7z8CCPIqprEjUGQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CY5PR12MB6646.namprd12.prod.outlook.com (2603:10b6:930:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Wed, 20 May
 2026 00:11:20 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008%6]) with mapi id 15.21.0048.013; Wed, 20 May 2026
 00:11:20 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>
CC: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com"
	<yukuai@fnnas.com>, Chaitanya Kulkarni <chaitanyak@nvidia.com>, Christoph
 Hellwig <hch@lst.de>, "linan122@huawei.com" <linan122@huawei.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "sagi@grimberg.me"
	<sagi@grimberg.me>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Kiran Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH V4 0/3] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
Thread-Topic: [PATCH V4 0/3] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
Thread-Index: AQHc4wmyko8dzHWtKkiOtDLGosU2ILYOgneAgAeR0oA=
Date: Wed, 20 May 2026 00:11:19 +0000
Message-ID: <4ed83782-04cf-45b5-93a0-05a08e61b82e@nvidia.com>
References: <20260513185153.95552-1-kch@nvidia.com>
 <20260515043535.GB3756@lst.de>
In-Reply-To: <20260515043535.GB3756@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CY5PR12MB6646:EE_
x-ms-office365-filtering-correlation-id: 4d50b80a-d1f4-43e5-131a-08deb60451b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021|4143699003|22082099003|56012099003|18002099003|11063799006;
x-microsoft-antispam-message-info:
 kJihw6fUx7GWW4u5/wy8G1flQJKCZ9d8bRdm6JGs95M3g7ZUTNQIKKIlpncIe4NHKXdy3P+1PLLubrjtCsYIPEAW42iAcpmHZYUD0m/L8/mhHYvCCDqYIiYr/SNBTQwZWqao5VZfs98NYqKEnokTWlzzLPPsbWLOApnQAHt/TLIj4/IDUdqWkhkrJHYQ6qDsqPrApr130m9+9FXnz8wk8mqC7VxAh31eucMv04G5hVU4wKx/MIqRnu6yHPKHDQrjojVKiH3nR1Gv728+gE0AJK6OXSDVTjjZN48Hdjd8mXpqu5thrUKC5W98+kQgLE5U+ZsiAsK2VRZNZFHqGsUiWOPsTETdWF5J5f95wqruejDHQs4Ut/iqM775+y0UTXeBr2K6S7iJ+PD1pj7Ky2b439XKe1+sL7hBndJyeC9AID92iAiB4LQ/+lLq4HEvJ1OwO3lqnETzBTaMxBTKMCqpnH8cTi4lf7721B9UNMV8gIDnCQypJ7OAfEvd1JzoP5mxKp6KLoQhqUfjVqXniv+nWI1hPGc/FyqgH1E4TfOWlU4aZaYEp2DgfKTQ/6tMv+9kGdfD477QjJPbSrbdtgQKrDKWnJvQwtDD2dOVTFpD6ABvG3IZut0AvGSO5OCGgwYhxN92Uwd5GXq2if3dS8pB8J6GZgi/gsHeklg/qTzCoR8xVjCEITW7V3y4CUyJFE1/EKQbIt/OEv+dFFJIAwOQ1UBU/yEnv034AzIfQb9uvvSfS5U+2+K1OIE7gVhbZYHr
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021)(4143699003)(22082099003)(56012099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TFg4UXdNblpXcys4L1FwWUJaWU9zN3Jqdk9KRWZmTUdTaG9PcUFBMTFZQXZi?=
 =?utf-8?B?OFgvZSt1enRHdFFndU9uTnYva1pXdFd0VmNKNWZnZXRnK1RLWm5iM2s1Yis1?=
 =?utf-8?B?NnhXdUFTZ2dJOW5wZWpxU2VjamZMNEdGdERoNUdLeE5jbEpFUmMwcGNwb0wy?=
 =?utf-8?B?NUVrMnpNbkJQSjJTMkMzbFdLYUdhSWZ6bldRV3BPRkt5MWRuV05PRm5kVldn?=
 =?utf-8?B?NmZHU0VxNzNUNTB3bGlUMzZQVjFNTC8rUnYzaEdhSE9hQnNGV2NDd3FVMWND?=
 =?utf-8?B?di90VDgvWEJXT2Rmb2NibzhjOHdMQUlHNy9ma202MFNmZW1sYWdPMmFEVUdK?=
 =?utf-8?B?akdJVk8wK0FXWHNLeStZNXFUZUpSZFJBVHA0Q0pmMG1YMm5sNEs3MGhwQ3gw?=
 =?utf-8?B?MlZnRDU0Vk96VGtqV1pBS08vQWdMQTdYRS8vQTV0bXVLZmJ3MDlwQUdFNzVj?=
 =?utf-8?B?emhMbjBUOWIvMDVrTmlNTEJEaUVhOXBORkozalRQeldQZFIvYkpUREhPMTBo?=
 =?utf-8?B?dXRPQUxBK0NwdHQwZGRrZUI3eDhiQ3JhRGpLdG1kc2VBRFlJTXZ2OGF5S0o0?=
 =?utf-8?B?VVY5cDNOejZlblkwZzBMWWJGNy9VZ3AzWGF1OURUdTF6cWV1cEVPdUZhVEpE?=
 =?utf-8?B?VUI4OUgyVHVwR1k3amxxNnRNWG1WUVNDL1FSN05vZHR4N3NWZTdDQ25SV1dl?=
 =?utf-8?B?WE9yMWxJaE5GR0J2STZWamVQekV3L3Q0WitSWHVtSUdhWkR6OERON2RpNnp2?=
 =?utf-8?B?TWowUDhhSGlaWlNqMmhhcnZnU3ZxcmNXRkEyQWk4R3ZpVDl0MlZ6QzlHa0po?=
 =?utf-8?B?Y3dUWDFnaTk4K1Evc2czWG9TbGJNSkNpSFdGcFNTYnhoc1BrSUxXR3NKRGNz?=
 =?utf-8?B?Y3ExMENoYlhleDlPaVczMUtqZ2l5MXR6NjRkajZVc2tpWVRZMk8zNUZ6WGJ3?=
 =?utf-8?B?ZHNnUXVINklOWFJXZ2c1OGNKVHc3QnhHRjVMOUhaRkh1dnV3dlljL3g5S3Z0?=
 =?utf-8?B?OWxWR3NkZWt4bit1Qlg4eXBCZ2FIYmVBam5JSUcwc1UwUFB4b3dSZ3BsNUh3?=
 =?utf-8?B?dlBlc202bmdLTGdLVmJObzIzejdvV0YzRldIZ1ExcndqS1RwaWpOVFIwSmln?=
 =?utf-8?B?Zy8xcTJzRzZtaGY0ajdqekJ0NW5VTzhKdGpHOTBvczdhMmhUTXI0QjJGbFpU?=
 =?utf-8?B?SG1JQjR1Z0pKcGhrSHhLanAySGxOWEFqbFBtREF3eUNRUHk4TWQxU1lXYmNj?=
 =?utf-8?B?eUhhcHZqcHJtWXRDNUdnUUk4SW52Q3VtUnZHdmFWaHErV1h5QUlRYnVRdXd0?=
 =?utf-8?B?OEhQb3JEVDlTcm5QVjlMMGNNQmx6UFhpSkZTSitOakhmNGhHYzBpeE9xSzhP?=
 =?utf-8?B?WnF3cVRVRDBmb2JxTFMyYkxiVUIyM253OUk0TEFBc01rUXpBM3JYbDk2TmZZ?=
 =?utf-8?B?bVVBRWwxMzhudkpRdmZVSkl4YjhDUzJOUC9KMDZIM3BXRlFCQXpyb3JZZDVP?=
 =?utf-8?B?Zk1Xd1dwUDk3SDArUUhrVUlTc1VFdGRVN2pVNEt4c3BUSE15SGxoancvbTc3?=
 =?utf-8?B?a0s0WnBQTnA1RkhzV2NyZmg3eXhpVUxhbU1pZUdVL2hvKzQySHFEVDJTK2pu?=
 =?utf-8?B?aDV5ODM1dXloclEvaGhMNm1YRHpNVmVoRlRsNWZLVWtHU01lTGc5ZEE0T01V?=
 =?utf-8?B?eDZuejJhUlJGM3ZMY0lSN3FFSFZYWFYvSHNqSU5VdkpnRmJ4bC8zN216ZFM0?=
 =?utf-8?B?WkZaM1pCQm0rcWcwWTlVa3lNN2U2N3JFeVQzNDhKVUJ1TG5Mb2dPQVNwWW5U?=
 =?utf-8?B?T3dvOWpGY2RvVFE2N2hEYjQvT3pvNUZsSWp3S3N5WnJmK1lsZExoMUxGRkow?=
 =?utf-8?B?djlLckM5RlpCd1BSc210NEYxZVA2NzFRQWpHckhyYnhWR2cvMUQyOHlXSnA2?=
 =?utf-8?B?dEYwWG5OK0F0c0drNTd6Z0JFeGNOVU1mQm4xQ0VEN2dxUDk5K3h1VE5mWHls?=
 =?utf-8?B?K0ttQ3diMHpUK2ZvSlYzWTdNaktMeHdFTkNITU1lZ0luQVo4MFFCZ0tyTUVB?=
 =?utf-8?B?ZVV4blp3dWQwdGJXcE90M0tUMzZwdlBpa3pDQ3phaktvWnFkdGZ2MjF3cmlD?=
 =?utf-8?B?OUVldVFXOVVXZnFUbUlET0JVbXJ6aVhoZEtlZ3RIYThTMzE1TnpXVW00Qy9X?=
 =?utf-8?B?dUVjYlNERnloRUVWM1hYKzNMNDFaSGJRSitZZncvMWFQWWFwYUlqNzRBY083?=
 =?utf-8?B?bHovRXYxNGFWdUhqSk1PTVRwZ1FDNm95TEx3WXZjQ3gvSFY2TDRWRDBEaUtR?=
 =?utf-8?Q?xCRpNNylx8hNrDq5G+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E71575CBEE7DFA418B940BF96BCFF5D0@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d50b80a-d1f4-43e5-131a-08deb60451b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2026 00:11:20.0026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YcTjPxxhrS2w82ShyiRWO4F0zrODgKLgpnr+O57arNtBPvx9l+trLm5W2yEWwUgjo82vn/ubNDclJO0cb+Ovfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6646

SmVucywNCg0KDQpPbiA1LzE0LzI2IDk6MzUgUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0K
PiBTdGlsbCBsb29rcyBnb29kIHRvIG1lIGFzIHBlciB0aGUgcmV2aWV3cy4NCj4NCg0KSWYgdGhl
cmUgbm8gb2JqZWN0aW9uLCBjYW4gd2UgbWVyZ2UgdGhpcyA/DQoNCi1DaGFpdGFueWENCg0KDQo=
