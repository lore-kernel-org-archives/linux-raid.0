Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012070.outbound.protection.outlook.com [40.107.209.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAB723EAAA
	for <linux-raid@vger.kernel.org>; Mon,  1 Dec 2025 06:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570150; cv=fail; b=QouQ/jXxObfTXeyOmgSvWyd01HA20/fgiQhSkd8MFpYC6GSuQ7KQvxL6BQ0CNHhyR1Tn/6WncfdZBfU7kPcFswIoZPTRyUcnZhRDpfCbKr6PuCwJgM4EEqTGbHuLyeFPfm8cwzbVszAc4Q/Wk6z7ric2QSamG32HXVq0OIBNyBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570150; c=relaxed/simple;
	bh=14gHLv7A1PtKf26cxTEdh4BFVOBzghJWTWAnNLOhsLU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZlJTcPxwuO8DWD5Ie6k58c3oSMCAfgj/OAwdXD5Evp4LgFbCdKPQzyXTkF8hZaJwCi5QXsZuFFhzZaUUfXd9Otz8fhnPBwvprWrVcz4cjWIoCZLFflpOVG6GYNjwVoWM2Jb4zuYRmn7u9bVivMdVqw1ms2dRmoSN4bOIInI6xrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VEn8QPaf; arc=fail smtp.client-ip=40.107.209.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VEn8QPaf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wmAQXsJsfq3QnEjAgYf9VNE9D6owYFgP2Pbm0CJg8Z40o4793ghR5XWSFsRlMrG/QD8v+JBQXBwdFfBIGkyJrAc/jhjyLSwtXbyeGJNItX0wAF66LxAB4DJCacHLcXKSzzCc8v4T1nhpp2wOrHiUGaAthHXsNS1sf5X4zPnXQW4p5N9PQ1BQMB9ofsczWX7qOiFfnvwHkl3c+bgtF5FqLyNc6iFm+qTMToU9nv34bb5krLH0FpuHDkFPH6K2gm1fqFjafqvaRTZSO1oI/eS4Rtare6Ne8z+mFW+lBzkRZZRGB73bXStRFO+EUQ4FcRHR+djxZnU8VpcFkhjp9mSGPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14gHLv7A1PtKf26cxTEdh4BFVOBzghJWTWAnNLOhsLU=;
 b=pmQcsB8jYEudHzMFwd4crkWprWnUg484caj3F2UO4arf9ZcpqhZOnGdflhWxDy456biv2PyNZItCzgfQbXLIq7iVgkqWXYvya083f9zM1cAHvYLpLh4OFEp0wIROX3UBkYJhWG+0Yz4O4vY2YkmuCWZinFlcOy81CTsmvUnTTSm6x6wDTljtZ9fNvPcAVwQvIWPTK1/4/HQrU/L4SB5rtEI7yMw55/kZhppMEdhOoEkxN3O/SM+E47vsoTHa+rMkeDBvxhHUzGqaBw2DzXp7Wjvn1BIzuscZHM7R9NbtN3MdGlM78vY+IDuUXLiBMP6GPxM6zD4v1c+XHd3VKD0pdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14gHLv7A1PtKf26cxTEdh4BFVOBzghJWTWAnNLOhsLU=;
 b=VEn8QPafzzr1ZvFkT+HTt4bOjFH+RLFTCS0pr09PLPOPp9Uu8hNRTvtEDxvYuHQ+/idNwjx2BCGGGmZlq6umbiN+G6ZhKaLzYWChFStPAwEHRQFBGpcwA/x/mhIamDKVnQSI3ZkRBjZxDEi5SrGkAxIjGSIsdysAwSMf9pLVmRkiJpooZiDPNzlFKzGEaDrC9L9AdgyWxMACXiyzDrMNUHMcKR/IEc4k6tvjWFIkvrhUNzekEeqtFREcX3NKC6ao+TZoMpEHaa+cIhu1QMOs9ezu9ewQslnviQP1mzt7Rop0bVQto/9dBAeBIqUmvRMXU4VIjLKdn1Qtpjgr8MoyqA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CY5PR12MB6132.namprd12.prod.outlook.com (2603:10b6:930:24::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 06:22:26 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 06:22:26 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com" <yukuai@fnnas.com>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de"
	<hch@lst.de>, Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, Chaitanya
 Kulkarni <chaitanyak@nvidia.com>, Johannes Thumshirn
	<Johannes.Thumshirn@wdc.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH V3 2/6] md: ignore discard return value
Thread-Topic: [PATCH V3 2/6] md: ignore discard return value
Thread-Index: AQHcXZzV8+Wgjk0PP0mjg0Cn+Vcw1bUMWn8A
Date: Mon, 1 Dec 2025 06:22:26 +0000
Message-ID: <938be45c-dcd9-45ba-b6ba-0fd29b0815db@nvidia.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-3-ckulkarnilinux@gmail.com>
In-Reply-To: <20251124234806.75216-3-ckulkarnilinux@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CY5PR12MB6132:EE_
x-ms-office365-filtering-correlation-id: 9376201d-f1c2-4ce7-9e88-08de30a1ff63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cE05eU1XZ3A0SGVPc1BpUzd5ZzIwSzJSMHlpUi9IbTFhZ2FXZ05OMmZhMVVr?=
 =?utf-8?B?Q2RDbWZnTStFVFo0eXNHT3phMmhTZW9yZERiVHFIeU1UL2lXaUFUWCtMRi9Q?=
 =?utf-8?B?M1JCejVpTnpkUjIwTjcxUnRZc2RXbmNpcmtQNTMxKzgyZjI4VEQrcmRFM1FO?=
 =?utf-8?B?Rm9hWjkvZm5TSzR4eEJiRGJIazJXUERoWUF0aWYxdzZGdGlrZ1c5QTBaUlRp?=
 =?utf-8?B?MmcwS1ZRK1J1Zk9TRWV6LzJ6QkFHeEZDSjNuMUVDMTZ5NzExL1hQTGhacUQ1?=
 =?utf-8?B?MWphSHVxZm9QcXlkVHVsMjlNTzhLaTFvaFpjajNaLzFQMCtrNjBCRmltY1lE?=
 =?utf-8?B?eDlhbURKVmE3RFBrS3dNd0tqUzkwcnpVYTRqdzFpN0FqU3VUbEhIMWRIOFcv?=
 =?utf-8?B?WmNvRXpKYVhBWVVDOHF3a1VvRi9IS0dMOEtNQkNQb1lBcVVhTXVWeW1lS21M?=
 =?utf-8?B?NFRDd1psM3ZVTXdnRmNrbmxwRTdDeDZqWUFZbG94eC9SdWt5NndmbU03bzRz?=
 =?utf-8?B?Z05pQ3pQa09BMkJHR1lIZDBVTDVRMVJyY3BRSXRreFhoQUtnUnBiUG04b1V5?=
 =?utf-8?B?R1R2ekVzUHZ0OFh5WXFCTlF6bXJ3SEVMMzRaam1adG42enVVV3BkMmhiU0Nv?=
 =?utf-8?B?cHhDRTJtNzJNdlJFcU1tTUd0ZmVudHh3L3dkWFZnb0k1R08rczR1ckIvY0FD?=
 =?utf-8?B?RERWWkRsd3Rsbk9tRDEwRjVLeFFITVRaNHVoMEl4Ym5tY3Z5ZUJtUW5ieEc2?=
 =?utf-8?B?RmlueDFoeDZiRDdKR1FxYTNmWHV1c3F2amdrVVZES1JndlVUSUc5RS9BbTdU?=
 =?utf-8?B?TmxjTFM4WDJia2JZa0M3dmI5N05wcGRYNjJmeTBtNGZNYXJSOFY0d213MUwz?=
 =?utf-8?B?dmRQRXoxZWhrN3dPZlZrN2RGdTJGQURNT1JrbFZCZTkxNW5RSVBEc3U2SmlU?=
 =?utf-8?B?Zjd3ZVhuUnZGM0RYQ2RHeTNZVlQwOFRiSWdPdlJVSjNmRGY4ZHo0WHdDOVBW?=
 =?utf-8?B?VmhzNENDcnlQRmt2cXJXZlQwS2lPWGowR09TVnhYdTZaakJKL09QZHpSZWY1?=
 =?utf-8?B?eUN2cDI2bkFFTGFVWStZeXBYL0U1cG1BRUlRWWNTdjhxSUR2SUVTZkUrWEgr?=
 =?utf-8?B?d2ZINWtFN1l0YXRlSU5YdTNNS0ExZXN3eTRpTkpCT2pkTWc3eXNQTDBIM3NV?=
 =?utf-8?B?Yk44TjFBazNkVWs3d2xaN2lzdnpvZDMxMFZTZUE2MFNtRjJISEFCR1VSNkdQ?=
 =?utf-8?B?cjA1ZzhzWXp3eXRJbm5ZZnU2Wjk0YnIwVmp4QjNQTkNrU1lXYnh6OXZseUxa?=
 =?utf-8?B?endlaEt3RmdTRFlZN2FhSi9OMzNwK0lpL2lsWU9mbEpTRkFkcVE0L1o2L1Q3?=
 =?utf-8?B?N1NFNHY1QTFucU1wS0RaR0JjQkFURncrSGJPaC9hcTEvcDJCdUs3TXJkekli?=
 =?utf-8?B?YU1PcGJ4RVB3QkVTZnBHdm5yMXRYTkdvMzFyUVMxbWNGdnVNOTcrSUNGdklQ?=
 =?utf-8?B?NTZucEtsRnpRRklyWjZuUTQ1OTNRUFlmSFJ0eUxNUFRWQTlRTVFydGxuWXlV?=
 =?utf-8?B?WU92WStSVUFJQngwV01vK00rUWtaWjg1ckh6N2puN0J2S1Z3YVFNRFhzWCtx?=
 =?utf-8?B?SFlXVWVkQzZpT2lpK1R1bE5WZ2VZaUpvQlhFYmsvRk9BRkRnS3RjelBKZ3pB?=
 =?utf-8?B?Rmh2S1JBaEsxaHNveUJlc0UwMmJFRkJXOXphQW9PbTBGUXpKcVhPckF4a3RD?=
 =?utf-8?B?ZzdHbkUwT3MvUklOV0ZLSmlNSHl2dk5EUTFEc0p0TVRhSU1wRXNyOEVERjhP?=
 =?utf-8?B?MXIzRUJYazFlYzhzZDByTU1OelZkenFuNkNzbnRyZ1NxK2gydThUM3NpeFJk?=
 =?utf-8?B?S2MvTEEvdkNsR3h1NEw0VFBmdlpsd0VidERVM05qTWw5dHhoUFBta0d3UDVq?=
 =?utf-8?B?RTJsQWx3aXBPdXZTR2tWMjh6MHFKQmExa0lrVzBMSndzUDgrUHRuWlZ4UWFv?=
 =?utf-8?B?K1VUL0FtcXJ2WTkwVitMWnduUHk2Z2VkRHdKSXowZ2dSZE5mNlhNS3cyOTcr?=
 =?utf-8?Q?WUecND?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YUliRHY3dkg1ZXVrOWxqZUhTZ2xvU0VUVG5FeHBuY3AveXR1eEFwNFlKMmlO?=
 =?utf-8?B?SGtkSDBSa1o4d05Hck5FMlVmYk1hVjkwYi8vME5YaDZEMGQvVTJQRDlBZXJN?=
 =?utf-8?B?d2RLSlNwMjFmeDJsZFYwVGNvdGNEV3k4WTEvZ2NiaTdBS20yRXBtQUw3ZHNY?=
 =?utf-8?B?bS9YaHhQNGZPOFdNQmdUYU9pcmhzc2FUZTJLdFRNbXZ1eHFBUm02QllYdnBN?=
 =?utf-8?B?NlN1YjhRMisxSkZtTm1YY2FSRmlRQitjbktYd09FaGFkQmJncXNCSVRjSGQr?=
 =?utf-8?B?M3NnZUVEUGkvd0dUSUFTeDFCSjlheU9mTnh2OGZXZmp1WktJOVVTbXV5N1lu?=
 =?utf-8?B?QXorSzBIYWxoS0RPa3BjNnF1aTYrVEhjVzQyNEFleEg3TjFaZHkxQVdleTVr?=
 =?utf-8?B?L2RLTklQVDc5YmprQlc1SEZhNWdUZWNLRXNxRGxPZ0tvNG1lY3FKeitXMW91?=
 =?utf-8?B?azFGVFRpeXRBK2E5TWg0SkdGTUZBSWx2TkMzQlBST3RHOVlhdHR4bkY0Wm0y?=
 =?utf-8?B?c2tVSFB5NXNibGFYV3NvYklrdy9aTEU1OWQvQmQwRDRWYWhxSkVobUNuWC9h?=
 =?utf-8?B?cTBZSTJTdGpVYkJNMlRNSG9WZzl6Q25MRlNCd2xWMHd3Mko5ZFh0K3ZlSFhV?=
 =?utf-8?B?MVVkbG10KzNGRGNUK2pTWEZUNlFsZlltN293di9RZEZHUklTM0tiQ3dCVTNM?=
 =?utf-8?B?QzhYcXE5Q2FHMzlGbGJmMWY1aSt2Z1M4L2ZOc3h3QjlBcnhlZGo5TzRueGMr?=
 =?utf-8?B?dFNaRG1ZYXl3ejIrM1pCdkhWc0orK0l3SkVRMUlyd0xPaHFDSlROeFUzMGt3?=
 =?utf-8?B?TXlKM0sxdEhrZlphTnFmN3hMS05aeXlnL3BFWTZaV2ljdmo5d1ZtMXp3aHVx?=
 =?utf-8?B?ZlNEb1Jjc1NxdDVEZTdUei92VFNFeitqVVJ6bENSK3BUbWwvY0VtaWdaVDRl?=
 =?utf-8?B?STFwSnVhay9oaWNIeGNSU3l6VERaS0o3KzNOL1BaZGNpRUROM09yaktWYVlC?=
 =?utf-8?B?THdIUytqSy85bXJTYnhHN01EK3ZHdUZ0QnRkbFEvZXRPaWlrWkdvbVp6b1lz?=
 =?utf-8?B?dzBCWElvSWlpYmNFRXdUUmUvVnQ3VDNuVzNIMklER1hWT0RuaSs0VWFEVFY4?=
 =?utf-8?B?ai9kaXFDT0lLMVdueVJ6UG5lUFdObnJXS0lUajVUZC9RbmxqSTJMbVVaeHd0?=
 =?utf-8?B?bzBRZkpUMGhaNkJnMjlOemJQY1UyV3Erci9tZzZTOCtpV0JLakd1QWFVWk9i?=
 =?utf-8?B?Sy83K3FlOWkzeG1IcnJkQ1E0RUh2dkw3Uy9sLzYrSTVxaEVHOFcxZzVaUVFR?=
 =?utf-8?B?d0hHTTN2Q3ptVWhXVDhldDNVUzB3UkVmNVdjaGhXMlBucnYvK2tlMUhYbE5Q?=
 =?utf-8?B?T3RRd3p6ZG9heEpUVGY5c25rd3R2RTY4WWtsZlpCQ0Z3Y1VsbU9pbm9pNXBW?=
 =?utf-8?B?ZlI0cHliK1RVbHZxam5ES1VoTm5NR1JRd082QjNYR1RPV3YyK3FmRFdVUU52?=
 =?utf-8?B?bS82RVRpNm5xV21MSVNaS0RQZUo2Tnk3L0cwZFpEaWpnYTQ4bSt6VkV3aVpy?=
 =?utf-8?B?S0hDZk51dHZrT1FlWkcwMjIwdGJIV0dya3NLWlMvUnlBemRmMVV4b2krSSt3?=
 =?utf-8?B?cUM4bWJrMGVwSUdBN0dacFBvQ2ptUHFkZFJnMGNqVzBhNkY5KzdmN1pCQUll?=
 =?utf-8?B?d255c1dpcytqaVkrdGh0WjdtN0tyVUNnSXVOOHkyMVUycHJwUXNFdWI0M1p1?=
 =?utf-8?B?MXpGeUI1bkNVZVp1NUFNUndMRkgzQnIyUE9uWDJyK3VXR3ZJNGJ3UmxCbU9W?=
 =?utf-8?B?MFZuc0l3bXBoRi9KNHRvbTdJTVJjS2dBTHdCYzNZYlg2Ri9sdklMaVFwTktM?=
 =?utf-8?B?bUhaQ3ZKTkxsblVWTFpzZGNqUUhDV0pXZlB1SVRwY0ZDcTgyM1FxVm1za1o5?=
 =?utf-8?B?azhqSGZ6dWlCcU43clpkdVIyMWxYWnhJWjlHaHFMZ00zbENvUXkxVDFsOFJJ?=
 =?utf-8?B?ZGJMYkhhcDN3bjdmUzJ1RTRGNTVrYXJIUEdEQ0gzK3FhTXg2YzJQSkU4dnp4?=
 =?utf-8?B?N2xyYjFlajEyRnNoZWhFZkNScU9SMkozSWZGMmw2ekhjUFlFQ25SMjlVN1pB?=
 =?utf-8?B?TmgvQjFVb28xNy8xSWcrSVVUemlDcUE0ZEhKOXhUNExLRGFTdFRmQ0pPazJS?=
 =?utf-8?Q?hQvt6l4Oa6ASomGUMN3d8mRGUvZhv3SWypUg2oug82uz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81C4754895BA464091B3F8DDA4D3CC3E@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9376201d-f1c2-4ce7-9e88-08de30a1ff63
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 06:22:26.5552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nLBMZTlg0x94O6aZ2+0bCKUL1ktPOafgkBY3cGabvJJ0bjRcdABcomXQMfzhgjcqMXi4xMopApAs9TZgH47ukA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6132

SGkgU29uZyBMaXUgYW5kIFl1IEt1YWksDQoNCk9uIDExLzI0LzI1IDE1OjQ4LCBDaGFpdGFueWEg
S3Vsa2Fybmkgd3JvdGU6DQo+IF9fYmxrZGV2X2lzc3VlX2Rpc2NhcmQoKSBhbHdheXMgcmV0dXJu
cyAwLCBtYWtpbmcgYWxsIGVycm9yIGNoZWNraW5nIGF0DQo+IGNhbGwgc2l0ZXMgZGVhZCBjb2Rl
Lg0KPg0KPiBTaW1wbGlmeSBtZCB0byBvbmx5IGNoZWNrICFkaXNjYXJkX2JpbyBieSBpZ25vcmlu
ZyB0aGUNCj4gX19ibGtkZXZfaXNzdWVfZGlzY2FyZCgpIHZhbHVlLg0KPg0KPiBSZXZpZXdlZC1i
eTogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gUmV2
aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+
DQo+IFJldmlld2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gU2lnbmVk
LW9mZi1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxja3Vsa2FybmlsaW51eEBnbWFpbC5jb20+DQo+
IC0tLQ0KPiAgIGRyaXZlcnMvbWQvbWQuYyB8IDQgKystLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMNCj4gaW5kZXggN2I1YzU5Njc1NjhmLi5hZWI2MmRm
Mzk4MjggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbWQvbWQuYw0KPiArKysgYi9kcml2ZXJzL21k
L21kLmMNCj4gQEAgLTkxMzIsOCArOTEzMiw4IEBAIHZvaWQgbWRfc3VibWl0X2Rpc2NhcmRfYmlv
KHN0cnVjdCBtZGRldiAqbWRkZXYsIHN0cnVjdCBtZF9yZGV2ICpyZGV2LA0KPiAgIHsNCj4gICAJ
c3RydWN0IGJpbyAqZGlzY2FyZF9iaW8gPSBOVUxMOw0KPiAgIA0KPiAtCWlmIChfX2Jsa2Rldl9p
c3N1ZV9kaXNjYXJkKHJkZXYtPmJkZXYsIHN0YXJ0LCBzaXplLCBHRlBfTk9JTywNCj4gLQkJCSZk
aXNjYXJkX2JpbykgfHwgIWRpc2NhcmRfYmlvKQ0KPiArCV9fYmxrZGV2X2lzc3VlX2Rpc2NhcmQo
cmRldi0+YmRldiwgc3RhcnQsIHNpemUsIEdGUF9OT0lPLCAmZGlzY2FyZF9iaW8pOw0KPiArCWlm
ICghZGlzY2FyZF9iaW8pDQo+ICAgCQlyZXR1cm47DQo+ICAgDQo+ICAgCWJpb19jaGFpbihkaXNj
YXJkX2JpbywgYmlvKTsNCg0KDQpHZW50bGUgcGluZyBvbiB0aGlzLg0KDQotY2sNCg0KDQo=
