Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902AF20403E;
	Tue, 29 Oct 2024 09:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730193159; cv=fail; b=EorVtkl8iIP1sKyYKiojWJQgWVjUCS1NyjHATvEqgKg+ddnTSGVep8okPtDAXQI7CftOmFydn0QX+tKbcg0gOmgECkQQYujVV/x3TplucJmGa/0t7uA9kfoCscFqTxQU46ZhX0aKP2Dzp7GKdn7x1Jp6ozv3Jry7drhFGCvmSSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730193159; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lYyc09/Td4Tlk2nl7cPDDCZfFOIVMeqy/TJdmv2EgrUW5y8rCVKtsjuXiIADNAZ7Sf0SdJZxr2XhsxiyRFdvdWJ1P/K8lWxHsmAQYAdbD1/1LJTNGkAvTwiyt+eJcmHYUnHFl1MVTOCwL1cRC1BraItg/KlS1SkLOCpMTBvV1yA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VQQptjFu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=AkH+mLb5; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VQQptjFu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AkH+mLb5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730193157; x=1761729157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=VQQptjFusrfJVN5A2Ks+ezy/KkpxMMrmuDzI32AsvSVhKhgYMu+/oUBC
   3QuhNDPTcGdyDW9xwKkx5xVfkjdXMtCTNqG3MiRFDfyI7aifbFh8PdmAQ
   TFIASg4/vjM0RBFLu+2ybu/Y2i11egsz3OQtfBIUhJlOkvoGpKelyWpOk
   /frCA2AJ1W2Dms1j9gtBnA/FplDqyAmpvlsg1Z3AZs+2ev5hOVrf6rzbk
   JUEEuXzOFf1wP2r7xOGEUcXlsBds/iQfnhtAlViQrxKkUeccV9SLhusgy
   YD3tbMNmFwhJf3NZThIj8/6vQNCAtChAWvhGH4vNUcU6QdywdIdsCuGSp
   Q==;
X-CSE-ConnectionGUID: SZPczTb9Sj220afCjV1v+A==
X-CSE-MsgGUID: rS+huxE/QgKlcM4u6DipDw==
X-IronPort-AV: E=Sophos;i="6.11,241,1725292800"; 
   d="scan'208";a="30111047"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2024 17:12:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2AoNfU0GKivABzupUvn3JvuL5F9u/6Uj4uQ8+8xK4xcKUVBJiohtEQotbkBiSBGifeWCGTbJCtFiToMDXO1TFmVa8w11bhRGJYQ5VJWW8S5ygZeQSnhLke2hKivcIIVxnTTLWevxoL8EYyfpf8tbGkSBP9PuoYWD+MSe7nnaffWaHH+mKTgKQh9esY2dq/3kllCbJisglXNnW76nrWZvucmt2SCsOWQSdqtSuKHcXjIIoscg9xMGY4n2ctTShgW0B+7jaFRq3CMCGheg3GlNpPtbUYGKxkAazcb4PyspSkzlqUd6yVHlWHe+iFbpuC9zIOKqtm88pY7QxZEBO68Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=QJYdSwj25FOMELHxUFeU2Yb7zqPkzPtPLVwbqljWjCW+sL3nvxP10On+yMfinN2QlrGmxo4E6hnOrZN18hXkjQClhuR5xBsly3NxAKNEyRl096RPuPOsfVt4RFjyXFnDYQxnC1I7wgyIN49UzS9e0e4XS1Jo/rznlL/Yu/IAMll3UXG9eA8jYZCjHrV16l49CQuWEkKUMyydkFadpeMPYUeCOss+p35upLulsjmYZ8xOtOV53pnhA/MQcGxX5MuHwAenxzryKQaLYES+J14jfnWK4eWJeUmqv3iTDEKD7ESro1yn6hsHAP2abGv3QqSqAA4aOyvB5WqldRnP95FxyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=AkH+mLb5sp5ZLbm+DwB9x7eiD/1RRzx6ER5l3qIkfMWMaF6iYAadT8dtupD090Bmu3M7VZzreH05YdD4kb0jVOkKC0P31QlJfjrwnTJKbR2wlah6RV11RFLpfNQd8/8HovuZCPW4FGLoEkLPuwcSHrcrJ1BJ2b0hDGlVosfjxBs=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM8PR04MB7846.namprd04.prod.outlook.com (2603:10b6:8:39::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 09:12:27 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 09:12:27 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: John Garry <john.g.garry@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"song@kernel.org" <song@kernel.org>, "yukuai3@huawei.com"
	<yukuai3@huawei.com>, hch <hch@lst.de>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hare@suse.de"
	<hare@suse.de>
Subject: Re: [PATCH v2 2/7] block: Rework bio_split() return value
Thread-Topic: [PATCH v2 2/7] block: Rework bio_split() return value
Thread-Index: AQHbKU4Au9hHz18sSkmNjskI2WxgnbKdcryA
Date: Tue, 29 Oct 2024 09:12:27 +0000
Message-ID: <49773f7e-9177-43c8-a8d1-74da17300c30@wdc.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-3-john.g.garry@oracle.com>
In-Reply-To: <20241028152730.3377030-3-john.g.garry@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM8PR04MB7846:EE_
x-ms-office365-filtering-correlation-id: 491f7d6e-7450-43e9-5087-08dcf7f9cf52
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?K1cwNGJZVW9BQzZuUVVLS2tiRSs3RU96eVlzdUhLaXduTFMzRVRkOVlIQTdj?=
 =?utf-8?B?VVFLanhoZXBaRDlOVGpNV0MrVjdDR0VmR0JxR1Z2NUhacTU2cE15MUNZNDVj?=
 =?utf-8?B?YkR5OEZnRDFjUlUyZHQ1L1BOZmJ2RUNIWlBZdWpMODJSYm1hSWNnUkxMZ09p?=
 =?utf-8?B?a1lBRWN3cGoySDlGM3NPOEJNejBEcEswaGtweVg4T0Y1VDlFS0JkMTNNcXVR?=
 =?utf-8?B?a2tTUk5sZUN6bFc2L0NXWGxLKzN3dmxNVVlFWXlKOWtxaGszc3JpaUlYVkdK?=
 =?utf-8?B?Mll4bnpRZ05nNGtxZkdZcWROeVQ2YVNZU21EYnA0ditOajBJUGN1TUZiYXBV?=
 =?utf-8?B?Z0IwVHdESzlVYmhSczJyODhObVlMeFBRNTY2RHhqTWZlVlo2S0N2Um9ibEE1?=
 =?utf-8?B?RVMzbW8rTVdtTlFxSjhuV3hBTlZ5a0VINjluYTVwMEVZbWxoeW5RZ21JY2tt?=
 =?utf-8?B?N3N0b0FJeXRoRUovTm13MlM2Y0xrM05rMmhtSXA0OHJHandVbmJaamdCaGtN?=
 =?utf-8?B?ZkZUOUZIS0w2QitDclVTQXg2UWZDYnp4NkVCYUxiK21TL1FsQVZPeitFd0Vq?=
 =?utf-8?B?SFlnamVGMVRjVHkzMVhBK3ExTTQzcnRMRElydWllN2lYSldJZncvVHU2djZs?=
 =?utf-8?B?MktneXNlUXZTQTVEdkwyeUxwVkUzZXM1THdLa09UVmRjRnBobTRXWlhHaGRu?=
 =?utf-8?B?UWVGcHN1ajU2K0RWdzhvTE94ZXZBN0tja2N5SnFQNU1CZnZzTkgwaDZ2YjQ5?=
 =?utf-8?B?aXVydldlMnpCR2M0Zmk0MW1WK0NLYWlEbmVZNUxaR2hTd1FhWHQwdlp3bjZK?=
 =?utf-8?B?ZG9xS3BRdE5lQVQzc3FQTTlwc0NEb1hzTjhBWGtjL05iSTl1UUNEOVZzWENS?=
 =?utf-8?B?c3l2RGN4WmV3VkdKdWR2dG9KbXNaN2FpekFzTERVM2ZhZHV2cG1BU0RGSVVQ?=
 =?utf-8?B?c0d3R2dRVG9wek9KaVVpZ1hscHhMUzJOL1hrYWFSZmd4YW4wZjhEYk80aEIx?=
 =?utf-8?B?dlI1UWx0MFVxVER0UnNza21Iek5BbHlsRVd0QUNYRXFuRWZxREhjY21vOTNn?=
 =?utf-8?B?TUdvbEpmWTZ1K3djWUQrNkozekRsb0xuSFpZaVY4QkNTOGxDT0c5M3Q1dHU1?=
 =?utf-8?B?Zjk2SmFkWFlIR1dRN0grdjN6Q2hWMGp3MVJ0c1lBbjM3OGhJaWQrSGdpQXdj?=
 =?utf-8?B?V2h5OE1NNU1sZlJQcGRiWWwwRDhZdTIyaUpOT1JzUzJLYzErN3NLdWZ0SnpB?=
 =?utf-8?B?U2R3TzNzSkQ3SG1qNmpWT1J4VmpFc3VwM0YxZGptMjFRZXU4amdKK0hLTWtI?=
 =?utf-8?B?dU5hRmRqd0R3TldlYWFscmY0OStlMEpPaTlCNmRzRHBJTXNyWVU4Q25DSkJ3?=
 =?utf-8?B?S001RmtjUDNJQkpEdHE4aVpYcEszQnF5RWtpUFFkTDlTMGsxeGZ5bEszQ2JV?=
 =?utf-8?B?cXhUTFJyMFVMNkZzeThMVDNqVmNHUDNHMlZleUdtbUxCVjdJcmZQazRkU1Jt?=
 =?utf-8?B?Z1FWSEtjNmp3S20zM3lKUnFFRkU5OUw4NXhNNDhwWjdtdTkzQThGdHErY04x?=
 =?utf-8?B?RFBDVm0rUko5a2s1UG9melU1ci96Y2c4Z0dBcEZwUk1ibVg5STc0V3Vibzdi?=
 =?utf-8?B?RGhPRytrTWJ6QzB0N1R4UmpKSU9ycjlpNncvOEdLUGJkL3lZbVR6WXVLVTNq?=
 =?utf-8?B?Mzg1VHRSWW96UGRRNXJiV2JHSEwrM2F5ZytHVXg3ZGxGdFArVUJIWm8yTFJU?=
 =?utf-8?B?VW95TERyTHhRY1dJQmxqTDlEYVlzcFVqdGd3b2lQNkQ1NUpsWnVLazh1aGZG?=
 =?utf-8?Q?qPIaARnkyMJSgTsHgob5J0BkBKr60uILDzxN4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VDZsY3Q2OEFiVHI5Y1QzUnorcFZwZWViNUR5OXJ2U0RtY2huN281R2VWZmh6?=
 =?utf-8?B?VXFnQ2hHZjRjd3dvTm9QQnBablVKT1FKT01XbGV2dTl5WmI0bzgzM0tnQmFG?=
 =?utf-8?B?U2RvejVPZy9HTHlCR3Bqc25MUUhkdmZmUWE0TTU5OTZUVmtMYzZXYnhydUl0?=
 =?utf-8?B?YkVOUXprbVRmaTZ2SGI4c3oyUThIWU9SMjNXRGt0czdYdnpWcm0zaWFBaW9N?=
 =?utf-8?B?NFNFZzQ4K2tUcFlyQTNMcGJnb2xUeU1sT0hKWmNyeUFlbHZ4Z2xEbVo0NlZZ?=
 =?utf-8?B?YnM0dlJrVVF3OGdISHhGYjliOWtzSWt4am9XUmdrYlI0YVhudzM1WkJhWTNq?=
 =?utf-8?B?QUN1dGY0anJRLzJkREtNR1hVYm9PZlo2TEFMNVF6SDlObjAwaStVNkVpYTNm?=
 =?utf-8?B?N3JSbGxCSVM3VXR3NExWcXNFc203QTRjTFhLcXArWXZTS2FKcEpWczZ1RUYz?=
 =?utf-8?B?dzdKT3FSVE5NNjJnTDdEOHBrV2NQaDFoRlJtdVdRbkFIZlpWMXV6OUgyS3ZY?=
 =?utf-8?B?M09nQ2J5OFZHczVZelVkWm1mTXgrdlFUYWFEeWZ2TnlRQ2l1RjlGRkFxQ0Jj?=
 =?utf-8?B?OFpJVFZ1MEJUSFJ1LzZkVTlLUFZMZEtMNmVkTUt5Q0Q1eXFwZ0NnTmV3N1Nl?=
 =?utf-8?B?SWVWUjhhV3VQcm42U1E0RklPQlZjbDVoNTlDVE9RYXFRZ2NRQStmNitnd2o3?=
 =?utf-8?B?eWUwbFhMdUhwVERoV0d5L2IzdGRMdFdNQTFJNCs4c2puNDY4ckN4L2huckho?=
 =?utf-8?B?dnBDYjZFS25iSHJHRzEvUS8zY2Y3RFEweVp3a1FDR05wbFQyeDBDMUx5cGdI?=
 =?utf-8?B?Tll5dzFpWjZrZnBhNXc0d1M3MlB6V05aOGtkRm5EcDh3SzVtVGVvb2t3cVBo?=
 =?utf-8?B?YjI0bFYxSXp1M09oejQ3NEt3Tjc3SGpoeitaVTNxclZPVy9aRFh0emFONTBv?=
 =?utf-8?B?NnptUDc2c2x1bzZJdzRjeGlDaDRCa1BmK2ExWmI4VXBQZDlycW05ZXd2Yjhr?=
 =?utf-8?B?ZUhNc0ViWXRQVHVZQXhtOTQvbXV3bFd4U3N4N1NjY29semQ5MG0rUGhoTTVu?=
 =?utf-8?B?NGRQbDhEcUJ5azVwL0tCdlFmRWhQNDVoWEhNSEcwS0J3blFNcEZyRm9pL2RB?=
 =?utf-8?B?akttRkFFT3RxNWVPY2VUU2srVTJVbWlWNjhiS01Tcy84dmxFdjhrSllTU0Vq?=
 =?utf-8?B?UEV5SWd1MG45MG9pTmJobnYzRWtwZnVsMi9melFMa0JhSTNRa2N1UE4xYVFz?=
 =?utf-8?B?ek5idENTRWhsNlJYbXpHVEY1dDV1L1BBUkN6YTRzOHNvVkpsNVFPeEVBb2NC?=
 =?utf-8?B?eXpISUtMNUFGaW8xbzg2WXM5ZDI0b2QxSDJzaks2WUt6cDNEeC9zUVljbTBP?=
 =?utf-8?B?MzlvbExuMFZBWGh4eUF6SHVpQnVzcko5SDYwZWgzaGhsM1RkV3FadXNubC9L?=
 =?utf-8?B?dU5nUHlWM3VuSW9iMTdNK2FReEd6cDRxOEpucU9TazhkeHZMeFZPL2pFNlBa?=
 =?utf-8?B?VGhmcGZuY0gydTFoL2JEK3RTcXZhS0k0U2k0L0xDNSs2alpEaFpzSjYxczl3?=
 =?utf-8?B?VFlaZmpJV3FIK0pxd0VmZGVnd2NtdnM1NzVxejRjeFhJamRFVzRzc3pqdjlu?=
 =?utf-8?B?bVhFcUQyeEFueml0SkhIMDhRU2xmS012dUxnZWZaZDlZYUpOV2dsbTZROGM3?=
 =?utf-8?B?MS9KQ0hrL2JYOTJwclkxRVdqaURzOHJKL1Y2ZmhUME0yUEx2QTJkc1dOWGhz?=
 =?utf-8?B?c0Q5R3B1OXo2aTF3WXVRNnBzMnBIbm5uZ0ZwUGdnMm1qcmcwVEJFVHBDWVFU?=
 =?utf-8?B?WE9FVWtNaXo3RVplNUI4NGt3d2pOUHI4cmx0ZzlWdlh0VUpDbElIaHIyd1J0?=
 =?utf-8?B?QWJ0S0lTQ2F2U1g5WHVNUTF1UlNzLzVvTExXZ1NBS2JqTzdlYitQeGNoQytz?=
 =?utf-8?B?Q3RuT3llb0N5V2l4ZnlKSk5RWENrMXFRM005Smt5eFNVcTNqSGxQL3RSZXg2?=
 =?utf-8?B?dEp3YTdXK011MjRCV1A3TitWNWxxRHhLRktqZXRGZml6azUxWFBRSzlzRXRl?=
 =?utf-8?B?a2J2N2JEL1hkZ2ZORlVZeHg5bFdHS3JjbXRhTlRCdE5hbDZyM0hJdzhTNVM5?=
 =?utf-8?B?TDRkVDRFOW0zRTBaRUpya1FQNHMyVTVQRm1WMHR6K0Vjd2RpSGNGUVMrOTlN?=
 =?utf-8?B?Nmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A8708E7402BF44AB7E6F0C0F41762D3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A6xwoR7BeZG/AogvByV77MjezT+iy9yYA3FwWG4ixMfdg6OweCHNFxLO2f+DL9rsu4FY7gI+3X5m2GxYKOHV87vn6SbKeeHRCL5sn5m6/isP9SpQEnZwNSOE0FHNvNqvXPZ+Hhj3dvmFB6s2qF6UTZIlQw+RTXSLuqgZZ6mXmI3iVAKBpz73s6Iw4sPlibEyEbY+l4w4L7Ic0aJJ0XMPp1SUR/IHS+5tbGs+6eoNPuwRA/kNzzfE0Mb+lAbhEtuDIqJb+Z8+3MPhHtqA9XpV+hxv2y6CTsirE0b90ZtD0CcfA5xe+EGJQTN3lOWAkSzAvRJ5K4UybHiH92wuTeVYcOvJhJMvXZ2Ed1kHfv4iK3C48oAkGWlyuiIHSA9RE/rdoCzzLO3uyN+5LEYL6cum/sO6zbEabhFpev5lWSG37cxDrLxJc06dRCMDe3W29FS/JgGEQYCTCcVCogndt1xuieLtt0P1xVNSRZ1fJVYhrfXDr/fZ1Z5P+ACODfSUjbx4WrcdMWOqxn5uqqFvcA4Y3Y8InleIuv8OAOUWuZGlW+aK18rj1AGXN7LnYWrNGA+C2rsDGEHBNHSZmS6FTuAkHUROcg9myUrzlw4TOKMbQsAKa9EF+TF1DVKsjQsycgZ8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491f7d6e-7450-43e9-5087-08dcf7f9cf52
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2024 09:12:27.6588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g1CgllU2+O7eYibA2CqwOgIHJIzRTHz9R5XPX89LJQotAvphILOcz7Dl3kWdlvS6FKrMgeDnqcvXq2GA6zF6cezTVX53Af8R3MjKj0hcwsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7846

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
