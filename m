Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E981338D6A4;
	Tue, 26 May 2026 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815352; cv=fail; b=ZPgEPs0FE1JEpyi/JoE/ED9MIvrbGSgfMAhglAgc29/sH9Q92Od0bWXzNu+B+AJOjRuyxdvDvtHstvmKqDedoz8DU0254rd8f7z/gfW+xNhydolixOPB2KIHp9RpFpA43PCMKTcHtz9+kHzsuc8S3PJLHYyj8cx99ctqK79/Nd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815352; c=relaxed/simple;
	bh=ChYdUL6mASZR1Yx+Ja3DZHHG4sP7yFwmrmGQFMb/SDM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AoekMTYnOGRNudUrv7DugS8m7vpRQG9uhjlPtlHA9XIvwuDRRHwzIz15vO0dR0G+08UtEpk+1jY3rLs0WSqHTA2NSQNAGuvTJViN5YacULM+AGnXgqCTliYOGQWqA1Z2M2AG7B8E8CWCot9VaO/R9ktDxk0p6kN0v6qBfDC5OmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c3qfmA/C; arc=fail smtp.client-ip=40.93.196.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c3qfmA/C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HmjFp2RpTt/5/jO4Vmat3P0VGGOkcHdKxCtqdCvz7HC8K4lOD9oD0/fp67WnoofK+7xRG0vLHUasKBdZieCVhgQ1pSOK+vt6BB8pApDAVQbHWWRYVHcDU4XAIjk7VaR4hcSW4dsZndyQpsdE+LmV+polHWQV36laxm8+NGldo/28rECS7aFwru5x5YMWOnqqFSmtDr3LVVLVebsFNjJCVu9u5zAryTtLPItK2nTFmJUHNmeBNCbY5SSXPSZoixVQ4s0V89XmU6hzh2BaSUbhp5N3SdjKWUF37PgBz1t6TTyBGICZ2G3RdLzmMUc/CGjK4lYeUMEamktz1+LJ4oIfiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ChYdUL6mASZR1Yx+Ja3DZHHG4sP7yFwmrmGQFMb/SDM=;
 b=YMtzDLeKpSGoVM44byNkDvq7XOJ4/2zU/5QYdY+H1fwhvmc0/aeenw5fOyjLHFglvylszN54Zl0/7UaeAt7mHlm0Rj835zIKExsivN7jfH8f3pmt2GcggvKr/2148oemYJcZPU5uyEUvz8YytHqJeUZGVw7Ih4RPDD4hGyRZlVtv0I/+aYYIUq9tzqonEfSjVmW5z0L7owFDnPJLSQTNAZrAk61CJoUFB7re8VReGf6wWZuRTpxlkje5p7/c9QSO4TZJLpUcYLyAjPX3S+iiDqzq0d97AcAZEe36FXa3fkzdFZ0pUaME/ekM29MLTrWglCHD5eB2MV9hBxG8mPADqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChYdUL6mASZR1Yx+Ja3DZHHG4sP7yFwmrmGQFMb/SDM=;
 b=c3qfmA/CiWHT6BQOVMy90e8mMSHuyzZTelcpObEMBktB1usi8Grnp+h1V6eoXrEwj38mD4PMsmzzSP0VVU70q9RmspraHSwPC2rXRpZMnhk4KVsSvCCNfIjA+2iud5sbGDq1usqWoeBsnL5+eHUDO0I6DGLPHBuGtGqNGpvyhJDdXfufa3EjPGAR/ZH8lB+mxUbqwHib4S1O2g3CbBeJ1sVfhN7xsrcGRJglQLZpJF7QHAjaeaaGXV9afYcDqQvXNtmvSIrcM7JlBkK7gN1fugeuYTa4yxEpWuSyWDQZ6QWr7rw99eTuZLMvFjF2jlmaCkwcGhuoRWC8WJ0Ow0eQiw==
Received: from CYXPR12MB9386.namprd12.prod.outlook.com (2603:10b6:930:de::20)
 by SJ2PR12MB7848.namprd12.prod.outlook.com (2603:10b6:a03:4ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Tue, 26 May
 2026 17:09:04 +0000
Received: from CYXPR12MB9386.namprd12.prod.outlook.com
 ([fe80::edab:eb80:ee7e:e9b7]) by CYXPR12MB9386.namprd12.prod.outlook.com
 ([fe80::edab:eb80:ee7e:e9b7%3]) with mapi id 15.21.0071.011; Tue, 26 May 2026
 17:09:04 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>
CC: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com"
	<yukuai@fnnas.com>, Christoph Hellwig <hch@lst.de>, "linan122@huawei.com"
	<linan122@huawei.com>, "kbusch@kernel.org" <kbusch@kernel.org>,
	"sagi@grimberg.me" <sagi@grimberg.me>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Kiran Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH V4 0/3] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
Thread-Topic: [PATCH V4 0/3] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
Thread-Index: AQHc4wmyko8dzHWtKkiOtDLGosU2ILYOgneAgAeR0oCACopXgA==
Date: Tue, 26 May 2026 17:09:04 +0000
Message-ID: <053b99b2-c994-42ff-af63-6e63ab468557@nvidia.com>
References: <20260513185153.95552-1-kch@nvidia.com>
 <20260515043535.GB3756@lst.de>
 <4ed83782-04cf-45b5-93a0-05a08e61b82e@nvidia.com>
In-Reply-To: <4ed83782-04cf-45b5-93a0-05a08e61b82e@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CYXPR12MB9386:EE_|SJ2PR12MB7848:EE_
x-ms-office365-filtering-correlation-id: 829db3bb-0538-41e4-ba1a-08debb497d53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|7416014|18002099003|22082099003|56012099006|38070700021|11063799006|4143699003;
x-microsoft-antispam-message-info:
 7LjL7NB5w7jt/b7r0kJaRTWMF/0WsZ2uGnKk85j/Na73y+dXSM7G1CLfMxGhyyItlAt957vLoRFWZ/A3lZJo+ytVWr1WIYfLNmY2l+KxVcZNFj30WNVRfTuuV1FdKPqCculDko2TCQxmEVDdU/NZOlmBUF2QPznALhcR0j2ELp98YNrNDTbjJiUGi2lzXyq94AdwDlMkDTCS+k00JzySHK+9YeHFzNTZtKcRlkyTm1iiBPEz8I8H8ncGfu1aHPC7v48KVge+9UPNkBXy9GMlsHWUGknft2UwLe0te7LZ29hIFcatCDuIVajMe9KZuZ/MAWzpgLKQg4uKxmVHehUlDfpN5TKiFc9Y02x6GYknDo7kxXDrjCCw/aFI6MQcbkB8yeCkLUl3Va95JzBIbVpGOIkwOufsC2N7juV7+12Iohb0z+DZp6BG/ao2yfUTJqnfkwNjWesxTkThwV4+J0l6bwmi3IqB0IVJ5xfm+1mPzhy0iQnPqJlIXTEnH78UMm8FTAQc34Wjwggh8e77dJbZ/TRrynA9rppmZt+Rb2cS8EtDHg6a6UzLaQW1tMwL8V2w0eu3Pp1/9zy3DZf8UZeQFISiuuRSszDfASpukMRly8dH/yiUJ0asVUZb6H0F0ProNbo5jtRyijh6h/E11sQpu3kU+S+/FXLXEXJq2cKPrRBXd7/M4CZNcjWo64ZsAthoztU0Fw1PuOsQoZo9xobVAjh4kuHl6SXM472Ru6+3tit7GXdYX/kibYvkf9WbAiaO
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR12MB9386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(7416014)(18002099003)(22082099003)(56012099006)(38070700021)(11063799006)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TmtpWC9TUCtIaHRubEpsemR3ZWVrdGcxTXZHU2lJekVxanZwbHU5MjBkWHRU?=
 =?utf-8?B?czhoUFhodStpK2RGVnUvMS9oOHVtTVR4cldMNkNRM2RzZlJmcnJLb0t4ZEhm?=
 =?utf-8?B?WnA3c1phOFYva0VpLzhlUVlwRW5nYjNEM2pVZUY4QmNYbkQvdFY2NUhjUUdp?=
 =?utf-8?B?WXZVMXpZa2QrU0RTYmt1dDNYNk9teU0wcys3YmRlYTQ4MVJxdU1xOFdpSHJD?=
 =?utf-8?B?T2hsaVdvendxb1duY3FMQmFiVXZzc0VlcWdmaUtyZWlYMVgybVMxSHl1dFNp?=
 =?utf-8?B?UWxQNGlLeHhrMVRFUjlPSEJ2MHd1TkUvNDVsczVXbmlQeGVycTdKSyt2Y0Q2?=
 =?utf-8?B?R05Ma04zNTduNTVWU3ptVlU2dDZwRVZKM0EyN2tPYTliZlh3U2hHU08rYVBa?=
 =?utf-8?B?c3V5UVRsSmRJMGdTVi9qVXUwOC9iR0JIZnVKbVQvblNzc2MzZXJOWFhtK05L?=
 =?utf-8?B?RURtdVJxYlhhUklaSTd0YXRVaFUrbWwxazAyQ0pjT2NyRkZPbEpTbjRaU20v?=
 =?utf-8?B?Z25xTFNuaWJiVWc0M1pndWlkbFFybGZBMUJvZlVtVm9vSUtzbWRhMXlBL2FU?=
 =?utf-8?B?YlM1YitFeFB4T3lkUVdPSTlLNUJJUXdrTFFrcjNOK005My9jMFRadzRHeHhq?=
 =?utf-8?B?TU02MHgwdjRORnN3VU5WeWpwb2dVLzFLTHlVNFRRRUJaQVJsVm1BSzJPZndy?=
 =?utf-8?B?NnJUNndTUDZqZmx2eCt0SW01U3dDcGFBR0xGbjhOUVA0QkFPNjVBSE1iSSth?=
 =?utf-8?B?M3JyY3Y4OXF6WnFLSDBIQmZjcFNnYjdOd2YwdUtBMXdIazcrcGRONDhLNWRT?=
 =?utf-8?B?MlJWRFBNaEozaFdhSzlmYlgrSW9Wd1JMcVNnWExTNndxd2tGM3VCcjhEUnlx?=
 =?utf-8?B?dHMwMTZXK094T2JrMHAvOUwrcFNsbHYzSHFuYzJqVENwRUk5NFN5MEVpdXo2?=
 =?utf-8?B?OVpsbXpIY2llREY5eXM0VGxQc1FPc3V3YzMwODJhN0hHVWZFZlJYaUpveXNW?=
 =?utf-8?B?eTBzZFozSSszeUFESlZvYnNaRGNYY3BnYjhINnczb2dtM1h5cktYcU1NV1ZF?=
 =?utf-8?B?YThPK2xCU0Vub2c2NXB0dTRiSllrR2VIQ21ES3VFblZJdzM5bnJHOVVBbDNv?=
 =?utf-8?B?S3FkV3Z3UytjTTk2Y2RYRWNuOWIzVDJLS0U0L3hqN3VYT2F2OFBNZDl4QXZT?=
 =?utf-8?B?VTkzSkpDRlc3WDhsVDlCcVU4SU1DODFVUUNVTm5KNG5lRTRnY1NCZXlXN3Fq?=
 =?utf-8?B?NWJvZW83ald1dk9TSFhxeDZuOVV2Q0NtOEE5TTRvc2dLTEFvc3YzU3hVRmNu?=
 =?utf-8?B?cTdyRG9pMEZlWUtYNzRGMU9GY1ZYUzZpM01nYnd0WW54eXZXS3ppbnB5bEIz?=
 =?utf-8?B?MVRUN2ltb3pHVU5SQzRmOE1hTUFPZ2xXWHJSRWMwbmZRa1ZBUndHMWdIaU5z?=
 =?utf-8?B?M2FFVTZPWVFrZ1dISlRWQmZxSmhvNUdCMGNmczY4V3JwME5yZDhRanZKNGtq?=
 =?utf-8?B?YnFpdlcrQ3FiWFZFNVAzM1B2YzhUcVIvVVdGOThrUHpBS0FjYjFES2YwZEFU?=
 =?utf-8?B?M2FiK1ZRR3B3eWpwS2FZT1JmYU9NekRVQkVoUTNzNWRBVmtaTnduRXNVYTlm?=
 =?utf-8?B?aHlHa1J4UEZkSnlSQWVYZWNoNVJsVFdCcjFwNk5BR053eUUyb2JSZll0M2Vx?=
 =?utf-8?B?eFdNZGh2ZWlVNTFacG0yUE5uQzB1RmtzNThuRVhob1J6S3lhT2xIZWFpY1hB?=
 =?utf-8?B?d2phUkdOTjZFR0J4dHRVV0tzeTlzNVZMcGwzU0t6SXJpQlFQbTlMNURvMFFm?=
 =?utf-8?B?SW9OaE5Oa3J6QmtBU2lyZmtoWHFhbGhJTEFYUnhxWmN2Mis3R25EbTRTT0R5?=
 =?utf-8?B?U2tMVU5Ed1cyMFNDcVE3b2FTalNNckVhUW5iTUttUlFZZXp4Tzk2RkVqT2pL?=
 =?utf-8?B?aEFJWlppODNjVUZBRXB2SGVkdkh1QklDSTVPaUN5M3VtNjB5WmtaRER4amJj?=
 =?utf-8?B?TjhYOGVTaUUxdncrdlV1cTE3RldjZU8zdjJMaTFWdnZRSW1NN25wTXR0S3Jq?=
 =?utf-8?B?a05lcWxBTGdScXFIUmN4a3QwSDhOTkwrelJyZG5LTWRheDBtWmhUbkV6ZXBz?=
 =?utf-8?B?VnJKVm9RbkVRenlRcXBqRERLakxIam1Ca1JIbk51NThFaFZvR1U2aDNnTGxJ?=
 =?utf-8?B?aXQ2QlUzWG5takkwMEFLTWpNWndHMEhzRGwxdmczc1RDWUM4UHMrVk5TaU9C?=
 =?utf-8?B?NzVtSFNNcHRIL2Z2eTN1bzZtdGpZQnE1eXhmWk1jb0MxZTZPamY4UUVHVk5B?=
 =?utf-8?B?a0FSWFYwbU14UFdWdXJ1N1NpeFdoWkxUamVRZ25OWmFmMjdadnpWcHRPcDEy?=
 =?utf-8?Q?88F3EB8hLxYFsO0J+vMvEMNnBwis+Se7fhahf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <885DF0F8739D6943960C9D31FEF0F3DA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CYXPR12MB9386.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 829db3bb-0538-41e4-ba1a-08debb497d53
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2026 17:09:04.2372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MNGKOeXgkb7rwaaVLF2zZkijy1Qro0DxPtEU8qwYQCQt3lZXQdO+5yjdHk9/XFMgJAvpD5J5Bum8JQPB06eAmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7848

SmVucywNCg0KT24gNS8xOS8yNiAxNzoxMSwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOg0KPiBK
ZW5zLA0KPg0KPg0KPiBPbiA1LzE0LzI2IDk6MzUgUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3Rl
Og0KPj4gU3RpbGwgbG9va3MgZ29vZCB0byBtZSBhcyBwZXIgdGhlIHJldmlld3MuDQo+Pg0KPiBJ
ZiB0aGVyZSBubyBvYmplY3Rpb24sIGNhbiB3ZSBtZXJnZSB0aGlzID8NCj4NCj4gLUNoYWl0YW55
YQ0KPg0KPg0KVGhlcmUgaXMgb3V0c3RhbmRpbmcgd29yayBJIHdhbnQgdG8gc2VuZCBvdXQgYmFz
ZWQgb24gdGhpcyBvbmUuDQoNCk1heSBJIHBsZWFzZSByZXF1ZXN0IHlvdSB0byBtZXJnZSB0aGlz
IHBhdGNoIHNlcmllcyA/DQoNCi1jaw0KDQoNCg==
