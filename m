Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011056.outbound.protection.outlook.com [52.101.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA6D2153D8;
	Wed, 27 May 2026 04:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779854602; cv=fail; b=po5Z/ne5gCQIKl0NGc6Y/BsrJq3GDKYw7aAS9u3KB6gJEVMReQhR5KZ2AU36omI++gc3Gs6G1VUOZGtMkAxSqd8nShXTNLXUK37U80qc8arT2QrBw1xFFqgs+pUCWbE2E7w/Jt5lv6RQl0S/ntsOomIoGjlze631jrEyPsCuHnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779854602; c=relaxed/simple;
	bh=5qIfBDR79j9IqyIN6ONG1Lzp12mhSDReKSvMWIZ7HDs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WCKsqeA8oH6KCSlEgkzC77d+ShhXVPvPZ9Woq55hDXrcuRpUu7tCBNvRKqfEp9xhLj+PvZMrNQ0MDjf5wvc4gQzBpaR1AdufpKRRw70YuqGpWACkHYpmmNOv3i+Qrz/ZXEyBMFGucW9PieVAlkxXTS1rp5alcnuuuARQanRt9AY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WRnZ1lzz; arc=fail smtp.client-ip=52.101.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WRnZ1lzz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YJAz3296qsznGvLNnNV+fJoCuP1i+hLMm9dkbbo3TAuJtOIH55naHt4TwENxO7ecU89LSBG/vUR6JcEn4+s8vGdz1vdw1DJOqqSNU4ok/sqCFpSFJN7T3iIu4BiCJZ3VlviKBNu9E9nJH1bJgc5fhbQKpUHJuSzRzk47jshhnMVTnz5DVXTLdk0RkE+xgwzIo6hKfDH0w0nCld7wsZiuTaVaL3RvNGV3lie74vFOwAn1iKz/3e6dPHy30pKXkyLrxNQAP96xxV+CESkto8gBjczCveqGWCQyfEqDY7KFVVN/vl/7QW8cRpVVdeZmZPuy86x/OX3V4W5tcFmOUh83OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qIfBDR79j9IqyIN6ONG1Lzp12mhSDReKSvMWIZ7HDs=;
 b=K/UHbzn6l+jRDfDOSXUmP5NRXzbeRsrc5DZA+I7XfkDC9AwrxVS8P84k3Aexy7ALBRbrn0rpjjVzuAWkrffJJ/ugSo0x1DzgnW5SFfrIBD2bJyKeY5dySersrGE/AwpRFjUTjmkcwUMJVDSN0YhKurBp0o8puhP6jqQf1hwuumsnfugi5To6LNLh7T9OKKP+wvGcgP++tMqFMRheDG3XuuNwwJFcYPbBhqIZJP54li7CNB2QRDbXoIXMQqiYDfz4/C1P856IA9QhNzNnZ0cQqn1zqQGq1dig1iMMpUY9wT5UzIER1UAUjXz1W1KyjLxe5LTuD6DyDMw3LDU0EYt25A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qIfBDR79j9IqyIN6ONG1Lzp12mhSDReKSvMWIZ7HDs=;
 b=WRnZ1lzzjKvNPPSqzGocGyuLPdsxb9WWHAbWS2cgxuDwRIXc5TgHSetO06z++aMW1/wivKQYEpJye6OQtnYDH9rBs/ZexLq1dohIc0Z2ULnAWpotVgBg2Mouhku1VhHmBcUPVM0AbXpJD2wp+iI+gMrWnK9x9M2oWgY2aua6/GMD4abyPH5wFPk2ZZwmYWVonO082Z4IlYQLFaq5jn/rKzT6RALb4IqRgdgfAfgRGWU315uO6FFDFr2udEZX8scxSm6lsaao8c1HACedSyAAXj8Ud0OPFk3Pb6jG+DT9b2GPdamdVyy0/Wxge4KcJdwAHbSAE/lLjy3b/OZ+Gy1/Fw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MN0PR12MB5788.namprd12.prod.outlook.com (2603:10b6:208:377::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Wed, 27 May
 2026 04:03:17 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 04:03:17 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>
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
Thread-Index: AQHc4wmyko8dzHWtKkiOtDLGosU2ILYOgneAgAeR0oCACopXgIAATvWAgABn1oA=
Date: Wed, 27 May 2026 04:03:17 +0000
Message-ID: <feed7ba2-3512-47b7-896c-cd08c0609639@nvidia.com>
References: <20260513185153.95552-1-kch@nvidia.com>
 <20260515043535.GB3756@lst.de>
 <4ed83782-04cf-45b5-93a0-05a08e61b82e@nvidia.com>
 <053b99b2-c994-42ff-af63-6e63ab468557@nvidia.com>
 <b89e372e-3068-4c26-9552-13e6853ba000@kernel.dk>
In-Reply-To: <b89e372e-3068-4c26-9552-13e6853ba000@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MN0PR12MB5788:EE_
x-ms-office365-filtering-correlation-id: e87907bd-90b8-471c-41fd-08debba4e218
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003|18002099003|22082099003|11063799006|4143699003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 BKXs6K0zyAQ8c3LGiC2uqw88K7e882KV5WsEIdItMYXJVL/oymS5bXIU1oxOG+wM7TBk4U98bKw+kAVfK0F223M9gMKMTIcDRvo7OFxS2c9yhcxMSM/tnioNACHf4zDUZVuHDjQuzTC6BKlxiB8sn6YdPGRx/C7YkM93rdYW9ecYwihnUx7tGvgQp1VQ0O9A/F1jy6TfcnpjFMUSXTLdRpmlmSL+Q0X7FxQeOUHXupjdrDs0XAhViHWwheArYWtAMNc2zu6AcaWvY+Ui+korS65uS8Y3STXjljgxLbZRAxy7zW0OTx8XDT5VRT7t6N+wSvdIg8CrT/Lvwte5YoM9MxqysLJkyvuAhClSZEjeAGv/QUsyerxs/MJntHRoohjU6DcGqtDfNMpnINh0uNdByua7NGhziWu98Ma/B42u6L56MGNo2YDqJIEyYLuc0dBBAKCt46SBALSu7jDJ5b1fDIcxctD30CCyPBIRKb94FjkRmOkaSQ6lLkLQbeOZu5iggSLBBbRLGQJDolOVsJA1oXqYBR+BQs93QSEI7gmO0IFOkv8y5Y7ZBlcHr1bYP4pTwa92ZEVx5ARSn6nh+5mR1G+3PMl3TZkqVSTcjinG7IQuqMK2y6LkaAHV4UgKCk2/ZFfBQUkBk87VR77XAcItPGBqQN5AlGO0o0fw8He0DAnLPRn9cLmu96OAlLKmH/4+80d3YtlFdlaY7O1ADk/Drb5zfLsRGNHBh43X3xBSc81OQVJ6YoKtKiEvPOlkYY1b
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R3pFeGpNTEJqZCtkWGc1WFlFZk51aHhwOWovSTIvTWs1Vmw1M2lzM1J5R3hR?=
 =?utf-8?B?OFdwenplelBhMXRlNHhMVE11TkFueE55bDNCZ3NCZy9rUng4V3lpRkRsdEpO?=
 =?utf-8?B?Z25lQlBpbWpRdGFFYnBKZGR6ZEdKbTY1K0dkZ28vZGFSVGN6dWxJVE9HM0Z1?=
 =?utf-8?B?K3FNZEV1blk5UGRqQ3ZuTmh0bllJSTVVOFg3cjRFczVVNUpCbFp2T2ZZczBW?=
 =?utf-8?B?UEExS3l6ME04VXhuTFdkSWVPSW5HbmFNck45Rk1leGwwdkFpdGd4dTNQcFpv?=
 =?utf-8?B?eVVtU3IwLzFRNXI2ZEhxcFQxSDBVSy83bEpsdkQzRTNtdEsyMFNmY2hhSXhL?=
 =?utf-8?B?K05tQTBKWlA0alNOL05lRE5XamcvTE8yVU1zSUdud21OVEhSRW5sa0srdDln?=
 =?utf-8?B?QXhxZHFKNXozL3o1a1duem1LN3lGWTN4S05wMlNpck5pOW1MUjFQVE1SUHph?=
 =?utf-8?B?NTQ0MkcrMHdSay9wMG40R2YxM3FPR2dCUm5HYjdRL0RJaWxDU0M1S1d5clp5?=
 =?utf-8?B?TndCL2lLTStWUVRMNkp6TUtWQ05FK2xoa0Y4VlRhYi9JZUZOaXVJa3JLTVlH?=
 =?utf-8?B?WDljbFlqK2RrTHVRb2Nnc3luZUhvOGlRZit6TjJ2VHdmL1F6RlgzWkhydmJh?=
 =?utf-8?B?bEJ3K3N2YVhPU2hSbm1xNGR3K3g4ZENYL1hUZEJKelpOcEZLSVBqZG4yWERq?=
 =?utf-8?B?bGtiazVaVUt0VG1kbFBYb0lTZ2RaOEF3L2tpVkNpdi9mMVdDY0w5a2t6T0I3?=
 =?utf-8?B?cXZXYStKUlNYOWdvV0p4b3FrSmRmejlTR2RvM0gxK2ZOUVoyUjNXcTJLWDEv?=
 =?utf-8?B?Umk2N2Zvc0N0SGxuTUJIUnpQeFB3MHExZm55OGx6Q3dWdDZZdXB3N3I3OHRN?=
 =?utf-8?B?SVc3VllPVlB0Mk9kbVozak4rR1F1YTN6Q1JaYXFYd1RYUGpsYzZ1eDZzSkgw?=
 =?utf-8?B?T2IxNDNtRE1JMDVlUTJKS1ZtVUExVnVMbHU5SSt1V2N5WXpGZ3FpSjlnOFZB?=
 =?utf-8?B?M0IvcnN2Y3hnMXFBdThwU2FaUGpUQ1RHdUkvMlVNYTU3aUdvb3EyVDlxM3Vt?=
 =?utf-8?B?bm12Rk5ucTZtUVJUK2dmd2llNlZQbVR4aFNsUGVEMnhMNjBDQjZWY2xxeGFz?=
 =?utf-8?B?SUl5bFRqOTdZMXZZSkhHQnVaMS8xSGVBdGZCV29PZGxESDRmS25UUU1kVHEw?=
 =?utf-8?B?RjdwMlJ0S3BXdEM1T3NWUHF4a0M3S2ZaN2Z4dW91WDRBRGF0c2docmtPcjI2?=
 =?utf-8?B?eUVXOWdwUUVKb2t1R21TVXd2V1R3NXM1Ni8vdmhKaGNVb08xcDJoL1hUN21y?=
 =?utf-8?B?anpRcGt6eE92M3hnL0tyaktrYlZGTjZBcWYwcXlwanBQVkQrRlFheVJ6MVNi?=
 =?utf-8?B?cVZZOFJUd1pDRFJTMkUzOE5LV3ptdVlReVBUdW5DTVpXblZRZjBITk5DQ2RY?=
 =?utf-8?B?NlQ3VVU5RFBsUHBlVWMrbC90WGc0TGN3N2Q2TWdKa2lNa2p4bGw0Mk1Id0hU?=
 =?utf-8?B?UzQzdWdtT0xuQnp5TjVyWUJoaXgvNUVTbW1SZXhpNVlaNEtzeUVpdlVOWk1P?=
 =?utf-8?B?WXowbFVpa2VTSTRxMktqdDF3NWQvYzJCdHZhaEUweEYrdEtZTkZOZzhORmtN?=
 =?utf-8?B?YWFsM1BMbG9LSk5EWVhoR1h1WklOK1ZzS3p6S00rK1RQSzhDOXFENDNkSVdU?=
 =?utf-8?B?ZFhFZ3JrcFg5TjBwV1F2ZWl6Zmp2U0UyQlhEVDVoUFo1WVRFbjY3d2pNNmZh?=
 =?utf-8?B?Yml0NG9qNGpPUDBPOVdaVUp0ZGdVSVdZQ0F5Y1dDanFKMjdZWlNPbmJLNEQ4?=
 =?utf-8?B?NnRwdFU5c2piZGNqcUVRWDFxb1lJNzd2THBZNnJJOGhJbldlSUFaK0FvZitw?=
 =?utf-8?B?NndlSnN6TnFEZHNWTk5uQW9GL3l3aXlWQjFGbm93M1pVUWwyUnJuazFsZTZR?=
 =?utf-8?B?bVhZVDBJLzhFaHNDVk1wNHppZEU3YzFVQ0U4YU9iNjBMWi9vQnpidHAxRDJm?=
 =?utf-8?B?SnpWTlN6VXNnNEdocmdBM25ZQnV5clYzSmR4azlVdlJLWWg0MWlaWS82TFZj?=
 =?utf-8?B?TmM2bGQvMW9qd1RQeG0vK2ZOaENySUphVTdnZkVnMDlRYjhhN25RUEt4YTgv?=
 =?utf-8?B?N3hrMDRycjg1VVNBdzZaUkxqUWZ0NFByblJ2Qml6Z3M1UFpWUFRCQ2FJd0xo?=
 =?utf-8?B?eVJtUEU2OWRCWlBtOFBZYStVbTdmeXVFaVJqbml6RXBhMTd5aTZWT0lvdkdj?=
 =?utf-8?B?TTg4ZW5uYzBYeHp0MmcvM0NvUVU2UUpIQnMxeGtRMnF5UnpGaFZybDNVVTJM?=
 =?utf-8?B?UWg1ZUFlc01JdUVZTkI3UnZZSUZ4dzB4bzMxVzNaNnhkWmZMcms2b0p0WUlh?=
 =?utf-8?Q?9eqgPX8OAm5f4IOP8jzsc36GjxysyLmQdvbms60NWZfb1?=
x-ms-exchange-antispam-messagedata-1: r6G6kCgiyvcEYw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <22F82D498F47314E8AF954FB3C94CA43@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e87907bd-90b8-471c-41fd-08debba4e218
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 04:03:17.5284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: APoBDXJ4rY0Ba4m71i4wUcvj7f2qOitjGwaeKrI7rwM4qK5eHryPluhkrLSP94FkT7URnksfkuVft4A/xrYhkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5788

T24gNS8yNi8yNiAxNDo1MSwgSmVucyBBeGJvZSB3cm90ZToNCj4+IFRoZXJlIGlzIG91dHN0YW5k
aW5nIHdvcmsgSSB3YW50IHRvIHNlbmQgb3V0IGJhc2VkIG9uIHRoaXMgb25lLg0KPiBPdXQgc3Rh
bmRpbmcsIG91dHN0YW5kaW5nLCBvciBib3RoPyDwn5mCDQoNCmp1c3QgZmV3IGZpeGVzIDopDQoN
Cj4+IE1heSBJIHBsZWFzZSByZXF1ZXN0IHlvdSB0byBtZXJnZSB0aGlzIHBhdGNoIHNlcmllcyA/
DQo+IFdhcyB3YWl0aW5nIG9uIHRoZSBtZCBwYXJ0cyB0byBnZXQgcmV2aWV3ZWQsIGJ5IEkgbWlz
c2VkIHRoYXQgWGlhbyBOaQ0KPiBhbHJlYWR5IGRpZC4gSSdsbCBxdWV1ZSBpdCB1cC4NCj4NCj4g
LS0gSmVucyBBeGJvZQ0KDQpUaGFua3MgYSBsb3QuDQoNCi1jaw0KDQoNCg==
