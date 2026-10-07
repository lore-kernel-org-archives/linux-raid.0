Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021139.outbound.protection.outlook.com [40.107.208.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4121A9B46
	for <linux-raid@vger.kernel.org>; Wed,  7 Oct 2026 18:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791396567; cv=fail; b=kRQ+eIjBBZgQ3LYE95t7wg3Pxrd+6Gw9UMXb9rnE7OS9HAJnpqvhTfvey03x5hmbpYYdbkHhFrmI45j6Tapq4FIqTWJy9R2DJMQCrXsr6Td/RBKnJwMtcV7ti1cM7LPI2x7D5QToC1pz2x/e0gCZPUnoH9aOBHRzaOgxUPC5V2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791396567; c=relaxed/simple;
	bh=NrCYAwdj7SoA2J9plihDMXdxnYmqo3RvPopiMkLNDWg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kWv/wM+ChspAQoWOhllED9L1h4NSNLS1fReIa9MIfVgeW2CrUOyBbVCYg7Xgh7lX8d5Q/dLGssIFUgn+AAGxc1ZZD1XbJl+rXZzQtNuFFoNCBhdeQxbdKa1xmbANJ/awAxExcusW8Yri3vl5VeGMS9AWVb5+8G893YjQ7gjURq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=U3dUVwBL; arc=fail smtp.client-ip=40.107.208.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="U3dUVwBL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B28QZSwi8fNOjUw7nW7Te+qh5gFxjOcFNmRiob1bHlXp4oBIr3oXPwM91aCbaLwYhcr7hypjJnavFzKz9A42PCfW0MFjWiD4btalFLUKiogbTTGm0PDfFqbocy8Oy7wZweWYlgwnLKdLG4EMk37aZ3PZogjf0qWDhwZnrmTPBgnG7mq/pcVJZmkDuu7i57OYjCsWPG/RUps/ZnQ9iUXSSEy+wK6U+P0aYg5OQfU7+t0ebC5C5s0RYEwd1okluSaemsdYBko5eA2Yl3cLvqt1Bxt0Df4NzeTU83bCbmFkrJn2DZpWAlJsZGuIWU9x3kYfjSk0o3jQPf2avs5LqnrSDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrCYAwdj7SoA2J9plihDMXdxnYmqo3RvPopiMkLNDWg=;
 b=Y5jOPpNP8Skh33uF6SQW18JTY8HUkGORB4p5JM7JYGcPQMFpgGItDixHWfaScrwBYDoWl/VyBBD+UEpaRD6OjUXcQ4vthL8l5XS2GIeQo0k2vy/z4v5qoPLedTZB498eVVcQGixUGXWV74zIfIko4tQgselZ5JqPHp1XMwNP9LAb+ehJkqmCuxpzGJE65Wc1XIkgLxwz4mrZTWE6PuN35LFzVYCYnbHjwEPKZsDWaGNvYGu8tfOPFfr1RFMaxA2DMKa+EBNwogHZerQLu5ni/5jVji3O+Vl4EJOmZjRBpHGvNl6zz9ztDiRVvDx8EmgGkKLafecfogbABzMpLqMMRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrCYAwdj7SoA2J9plihDMXdxnYmqo3RvPopiMkLNDWg=;
 b=U3dUVwBLSZ5j06VYsI9qsPDgyhcx9eSXYWWVHOi22q77atfcXntEtexApEMFGzQw64+oAjEIGr+Up255qNbB1l1EkZgR/DkBgABUIynPWAywCM6uubr8nRN1qSIDvg2cO66tayjQBD2pFQ3oCYhiDV6iXmrv0FKS3x0L8zjsDSj1Mn0cCjnBktdj4RVlCFd48AeOIvZPx4sH6hPr2YrCsomKKpimedzsULXU3R8fiumXK/uWUALny8Oqq5ofcPWBgearSFtB1o4/xwXWHv1fXwYN9hry+MWRf+WlbihLWJeORJhTHjl2uMXPRB2WGRNlP+WBsD0TJPZnBAAqqcdBkw==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by MN7PR07MB629411.namprd07.prod.outlook.com (2603:10b6:208:632::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Wed, 7 Oct
 2026 18:09:23 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 18:09:22 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "yukuai@fygo.io" <yukuai@fygo.io>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>
Subject: Re: [RFC PATCH v3 4/4] md: add a control device for array management
Thread-Topic: [RFC PATCH v3 4/4] md: add a control device for array management
Thread-Index: AQHdVlJIcjwKT2hWx0a13yUeO9vukLbx/NGAgABkfoA=
Date: Wed, 7 Oct 2026 18:09:22 +0000
Message-ID: <m2h5ixbcxa.fsf@gmail.com>
References: <20261007115104.13884-1-abd.masalkhi@gatech.edu>
 <20261007115104.13884-5-abd.masalkhi@gatech.edu>
 <sashiko-outbox-162977@kernel.org>
In-Reply-To: <sashiko-outbox-162977@kernel.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|MN7PR07MB629411:EE_
x-ms-office365-filtering-correlation-id: f1aa77e1-613d-4b98-035d-08df249e1d86
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|786006|1800799024|23010399003|376014|366016|10067099003|56012099006|5023799004|11063799006|4143699003|3023799007|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 e0ebtobx0RQaRMr12IMT6vGLB/fX3Tvmf2vjYYt6kaFAPEK904YuJT0Dk1OQ1ya6X0pyltiGd2Z06x4iKG8DJy2ahAxSe6Ek7b32c7+BFdA1Hdz+2Oi5I+ApvgAmsSOVnyKiXvWapj+7hsYpj9ER9Xlo2umfv4UDDSH2DzN2ZzdCu1uglpaisrtOfUEHRFEAYZLUG9vvK1ImImBQQFYSEAVfKQ7IoVHieO2/sZYgnV9V19p2+bdTEI7LXoddYHqOl87FgE/FJNAybYIoK1Or6pexjDwt7u/9hHaLMQhOkMlVfl96QI0LpwgCFdogoN15bPj5/WwdHhGRgim09QJn165HKHITc7fdG0LWVTc7YNOfN5OmFlS17ymAshKOn8lUSUl/NPwbVx0kdHBqrwIwgkHMeTNwyYGyxdIBxB7SvGycAsxdBUULhNobMc5SZh8lKW6+32nGOAG7WuDJqnDEBBB6sqfia5Zuo83mVhDRH6VVEPP2k00aYgxhmPyK+8v4md3tCaMPurMzyYnul8IRhD34eGwp9HA2XG3JMpQeqeq4gfyfxEtRgpAIb1rguYq5Jamlu/5nGzOvAWwiE/7V/5TS/srjZZG3A0FgjEu3y5oagbJ9Ta2lVEwrYIth9SLTfyWr6VqVADfbpUwEamMstnOIvuy/R1fRIoXjrJpAdus=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(1800799024)(23010399003)(376014)(366016)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S1dQN3BLckVmR2QwaEVVY25VSXI4YmdQU2ZoUnpCWkx3RDJqd0h4V0xCWDFQ?=
 =?utf-8?B?eGhQVE0vemNTdVFYcWJ4R3QzRkZlL1RPbjJ0QmNOaVNYajdQMVN1U1kwT2hO?=
 =?utf-8?B?Ykl1TmdEcHV2NEFsb213NTJVOE8rVjhsZHcrNDB1UEFxTVJ4WVVDZzVlRWJn?=
 =?utf-8?B?YVFUbDJYbitFS1owZEtNTkd3YjdXVGp6bnVQMmxWUk1BTFN4QnRxbHo1QlZu?=
 =?utf-8?B?YUhvdldRMVdWZHE3WkxqRjVRS3M1anlnbUlNVGFOWGFNbCtqeHphYWJUUkJZ?=
 =?utf-8?B?S1BBVWxlWWp5SXdPQ0JHeGxWa0lWN2RlSE85UW9md0FkMlk1K3JGNFNwZnU5?=
 =?utf-8?B?Y2cydHFIQUhaWmlZRm9XVlJzT0tRV0lORGU2K2RZbWtGSWJQTFFSdWNvUkh2?=
 =?utf-8?B?dnhHbThaTlFPc1BtNnJwUlhxb2JrdWhGbjZIT3lDUW9Obmd3emtvUEtZeFRo?=
 =?utf-8?B?bEZvR09YUi8rK21KeCtnbHYycThuamVSWkV5R2pWVllHeDlFRkRDbjFFa1ZB?=
 =?utf-8?B?NVVJazJEN25vM2c0eHZHb2MvS1NHS3ZJTFMrL21TTmVKdHJ5Qi9KWThaVEZh?=
 =?utf-8?B?NXllREhmb0NrNGJEbjh4ZFBMT1loMGh0NEZzK3ZYWXlORmlsQ0Q2eGtnb0xQ?=
 =?utf-8?B?M3pRVHNUZlNYQXZHeVBNcHA1V25vbStlNXdlMllRSFVMaFZMYlhML3U4OFBw?=
 =?utf-8?B?eTdKd3VwWTJaUzVQeVhXbHNlMlc1WC93bnd3cHJIKy92ekVCV1JzL3NGMFFK?=
 =?utf-8?B?czAxc1cvRHdObmJPR1FTUkczRVZWSVVFQ2ZKdXcwVjBZL1RES3J1WjNVLzg3?=
 =?utf-8?B?K2NmaS9PWXlma3FQcWI2cElZZVpKcXdWb0xXNnN4N3pmeEVMdXpybkU0cXFy?=
 =?utf-8?B?Tjd5bCt5elVvSGtRNWFlUHI3bXNxL2hBdVAzeEFzZ08zMkZvaEFjR0Vya296?=
 =?utf-8?B?WGxQOVQ2M2YybUQ1L3dRKzc0cE9Mc2hOSVdNcDMxMXRCNFpKRHBpZHNpd3Jp?=
 =?utf-8?B?VGpSVTUwd0tDYk5lRm5Yb1VyR0JnWEVMZGRnNkswSnJTNWM3OERwdFk0T0M3?=
 =?utf-8?B?UEhxNUlkTloveG9YVkEwSnRyZXB0L0xuUzVHOUpEd3l1cDZKQlVHSnh6ZzFX?=
 =?utf-8?B?YVkzVndhQ3BpRVFZWTZKcENjbkpEeHhBcXFDa0hneTRqUG1GWHNrTnd3bHUv?=
 =?utf-8?B?a1Z1eWRoU2pqSnNiNHBDeG9VQVJyemM3Y3YreTdlVjlQS3Y4WjNPamhINTNz?=
 =?utf-8?B?aGIzOTJNNlNLN01pYm5zNThYdTFsaWxwVDdnTDVHQ2dKeks5T3hGZVM0Q3Vu?=
 =?utf-8?B?anloaGJkc3NEUGhUdGRrV1FuaG1VdWo3NkQvdVcrNWlhc0MxM0dqMlNCNEU5?=
 =?utf-8?B?cngvZHlCRkNpRUk5ZS9wTzE1VHQvQ3dBbmRmQTRiam8ySTVpRVRpWnFKNHhr?=
 =?utf-8?B?eWlzUm92VHpFblladmpPY1ZNNG4xMWI5V3JJMy9IUnl2NXFQOTJwOEZVd0dy?=
 =?utf-8?B?RGNaN1ExeEU4cXFnbU9JVDd1Y3ptM05EY3pKMUc4eXRCdXJFLzZSL083VnVh?=
 =?utf-8?B?TC85eVJiUmdkd0s3M2gyc0o1MU4xM3BkbHMvaU1OS09kM1E3a0JCN3pxM3ZT?=
 =?utf-8?B?ZlFDZHFVamQ3R3pVUTU2UUl3d3d3cEtpSTh3VnFYV0dRbnJ0M2FyVmZNWUpu?=
 =?utf-8?B?ZERlMWcvYUpvM3FweDNaL3h1OWltWDAvNVd1emNYK0dSOFF5MTE1bWVYdDhu?=
 =?utf-8?B?ZUdsOWN3MFpxSlcxNUUzRW11Z0NnWEkxNlNvT2JITjlHU3g2R210SjEvODdX?=
 =?utf-8?B?dENIalVSaVZaTVBTYmp2bnNGVEtid3lRSnovdlNrZFZQc25GNHFuaFo2NXBY?=
 =?utf-8?B?L2RUZU43azlmR3NiamZHZ2l5Q2Fiem40dTBRRGl6eGt2clpvYmxOWFhCd1N0?=
 =?utf-8?B?YkVPVTNneHhBV2dpMTFtU2puMVJ5Zk9ENGJKckFwRTcrUVZXeWdSblY5TERV?=
 =?utf-8?B?ZUNTQXh6YnNhSUYycTJkdy80dXRBNExGODB6WURIRnlsT0xGTnZ2ZnlKSVFa?=
 =?utf-8?B?K2UvcGhkL2pmVHp3a0xrU29iWE4wdktxSDEvL3VyOTByRW4vMWNGbm1rYzZh?=
 =?utf-8?B?Qnp1THZGb0czNmcxNStTNkRoZFJJRkJ0aDQ0K21tU2VUNzNDdUo3NjlVTzBZ?=
 =?utf-8?B?TGswS2hLKzJYZVh0Sk5ITW16TitUbzBWNDFMakN3eFJ6SDdqV0hpVy9hVjFi?=
 =?utf-8?B?N254NTI2VFdmWWNocURXbFlWVUtFSXlTdERHdEFLNjBKVnpRSVpyU0k4NUZ2?=
 =?utf-8?B?d1J1a1dqTm9DNU5Gc3h4aW0xZjkvVUY5YkNXT0gzb3c1NVdOZGZRUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F5B488BCB74A440A557E11D402F30DF@namprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: gatech.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR07MB9958.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1aa77e1-613d-4b98-035d-08df249e1d86
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2026 18:09:22.8036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RPG8g84hMn82bvd2bsSZx2NYk+UP8wON4dAyufmYDPJHTyJr0SrlRV+kgc2KZeTHbkR+51XDixCoCxEvqVhmAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR07MB629411

SGkgS3VhaSwKCk9uIFdlZCwgT2N0IDA3LCAyMDI2IGF0IDEyOjA5ICswMDAwLCBzYXNoaWtvLWJv
dEBrZXJuZWwub3JnIHdyb3RlOgo+IFRoYW5rIHlvdSBmb3IgeW91ciBjb250cmlidXRpb24hIFNh
c2hpa28gQUkgcmV2aWV3IGZvdW5kIDEgcG90ZW50aWFsIGlzc3U9KHMpIHRvIGNvbnNpZGVyOgo+
IC0gW0hpZ2hdIG1kOiBNRF9DTE9TSU5HIG11dHVhbCBleGNsdXNpb24gYnJva2VuIGluIG1kY3Rs
X2lvY3RsCj4gLS0KPgo+IGNvbW1pdCBmZTc1MDJlYjM4NjYyODcwZThlY2YyODg4MGYzMDU1YTMz
OTUxZDJhCj4gQXV0aG9yOiBBYmQtQWxyaG1hbiBNYXNhbGtoaSA8YWJkLm1hc2Fsa2hpQGdhdGVj
aC5lZHU+Cj4KPiBtZDogYWRkIGEgY29udHJvbCBkZXZpY2UgZm9yIGFycmF5IG1hbmFnZW1lbnQK
Pgo+IFRoaXMgY29tbWl0IGFkZHMgYSBtaXNjIGNoYXJhY3RlciBkZXZpY2UsIC9kZXYvbWQtY29u
dHJvbCwgdG8gaGFuZGxlIG1kCj4gbWFuYWdlbWVudCBpb2N0bHMgd2l0aG91dCBvcGVuaW5nIHRo
ZSBtZCBibG9jayBkZXZpY2UuIFRoaXMgYWltcyB0byByZXNvbD1lCj4gYW4gaXNzdWUgd2hlcmUg
U1RPUF9BUlJBWSByYWNlcyB3aXRoIGNvbmN1cnJlbnQgd3JpdGVzIGZyb20gdGFza3Mgc2hhcmlu
Zwo+IHRoZSBzYW1lIGZpbGUgZGVzY3JpcHRvciB0YWJsZS4KPgo+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZC9tZC5jIGIvZHJpdmVycy9tZC9tZC5jCj4+IC0tLSBhL2RyaXZlcnMvbWQvbWQuYwo+
PiArKysgYi9kcml2ZXJzL21kL21kLmMKPiBbIC4uLiBdCj4+ICtzdGF0aWMgbG9uZyBtZGN0bF9p
b2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwgdWludCBjbWQsIHVsb25nIHUpCj4+ICt7Cj4gWyAuLi4g
XQo+PiArCWlmIChjbWQgPT0gTURfU1RPUF9BUlJBWSkgewo+PiArCQkvKiBOZWVkIHRvIGZsdXNo
IHBhZ2UgY2FjaGUsIGFuZCBlbnN1cmUgbm8gb3BlbmVycyAqLwo+PiArCQllcnIgPSBtZGRldl9z
ZXRfY2xvc2luZ19hbmRfc3luY19ibG9ja2RldihtZGRldiwgMCk7Cj4+ICsJCWlmIChlcnIpCj4+
ICsJCQlnb3RvIG91dDsKPj4gKwl9Cj4gWyAuLi4gXQo+PiArb3V0Ogo+PiArCWlmIChjbWQgPT0g
TURfU1RPUF9BUlJBWSkKClNvcnJ5IEkgZG8gbm90IGZpeCBpdCBjb3JyZWN0bHkuIEknbGwgZml4
IGl0IGluIHRoZSBuZXh0IHZlcnNpb24uCgo+PiArCQljbGVhcl9iaXQoTURfQ0xPU0lORywgJm1k
ZGV2LT5mbGFncyk7Cj4+ICsKPj4gKwltZGRldl9wdXQobWRkZXYpOwo+PiArCXJldHVybiBlcnI7
Cj4+ICt9Cj4KPiBbU2V2ZXJpdHk6IEhpZ2hdCj4gRG9lcyB0aGlzIHVuY29uZGl0aW9uYWwgY2xl
YXJhbmNlIG9mIE1EX0NMT1NJTkcgZGVzdHJveSBtdXR1YWwgZXhjbHVzaW9uID1vcgo+IGNvbmN1
cnJlbnQgc3RvcCBhdHRlbXB0cz8KPgo+IElmIHR3byB0YXNrcyBjYWxsIG1kY3RsX2lvY3RsKCkg
d2l0aCBNRF9TVE9QX0FSUkFZIGNvbmN1cnJlbnRseToKPgo+IFRhc2sgQSBzdWNjZWVkcyBpbiBt
ZGRldl9zZXRfY2xvc2luZ19hbmRfc3luY19ibG9ja2RldigpLCB3aGljaCBzZXRzCj4gTURfQ0xP
U0lORy4KPgo+IFRhc2sgQiBmYWlscyBpbiBtZGRldl9zZXRfY2xvc2luZ19hbmRfc3luY19ibG9j
a2RldigpIGJlY2F1c2UgTURfQ0xPU0lORyA9cwo+IGFscmVhZHkgc2V0LCByZXR1cm5pbmcgLUVC
VVNZIGFuZCBqdW1waW5nIHRvIG91dC4KPgo+IFRhc2sgQiB0aGVuIHVuY29uZGl0aW9uYWxseSBj
bGVhcnMgTURfQ0xPU0lORyBhdCB0aGUgb3V0IGxhYmVsLgo+Cj4gVGhpcyBjbGVhcnMgdGhlIGZs
YWcgd2hpbGUgVGFzayBBIGlzIHN0aWxsIHJlbHlpbmcgb24gaXQgdG8gcHJldmVudAo+IGNvbmN1
cnJlbnQgb3BlbmVycyBvciBvcGVyYXRpb25zLCBwb3RlbnRpYWxseSBjaXJjdW12ZW50aW5nIHRo
ZSBwcm90ZWN0aW89cwo+IHRoaXMgcGF0Y2ggYWltcyB0byBwcm92aWRlLiBTaG91bGQgdGhpcyBi
aXQgb25seSBiZSBjbGVhcmVkIGlmIHRoZSB0YXNrCj4gYWN0dWFsbHkgc2V0IGl0LCBvciByZW1v
dmVkIGVudGlyZWx5IGlmIHRoZSBvbGQgbWRfaW9jdGwoKSBkaWRuJ3QgbmVlZCB0bwo+IGNsZWFy
IGl0IGhlcmU/Cj4KPiAtLSAKPiBTYXNoaWtvIEFJIHJldmlldyDCtyBodHRwczovL3Nhc2hpa28u
ZGV2LyMvcGF0Y2hzZXQvMjAyNjEwMDcxMTUxMDQuMTM9ODQtMS1hYmQubWFzYWxraGlAZ2F0ZWNo
LmVkdT9wYXJ0PTQKPgoKLS0gCkJlc3QgUmVnYXJkcywKQWJkLUFscmhtYW4K
