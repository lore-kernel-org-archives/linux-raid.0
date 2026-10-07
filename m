Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022088.outbound.protection.outlook.com [40.107.200.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE5D48EBCE;
	Wed,  7 Oct 2026 11:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791373920; cv=fail; b=GHb+BCxxfZuSyEYwlRKnTnO+a7k4ZqIJTOcevmEZ0vdabhMTDBRCJRSiQAkcFXmqj6Mg0mXooi1gXxkac+eMxufF0IWBrZqCxnhu+AzzydvRtEzGdGxlsKBD8Pcm5vrenwPSyDZzJ6/+I5KnLBz3HRCRbpzwOy7hkjnnOjJhPds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791373920; c=relaxed/simple;
	bh=kZ1hFYZXciMPZH+0zosA0iuzMmVdicvX5hXEFi1a9Y8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=iA4iTlzMRXBcMLupK9d76EucLnZfiZoUv5VZzuEuiKGfepSqBthDiAiWO06m8YFUnoY6R4YfM70zuL5CHgXudNNLgrg2rZ2mHRWeNOI4BD+WY/T3//5YwDqkNvvBBml6B6KiLoMQ0R1dkV7y8IRwQTNZhbZGg54OsmwiJbjwtFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=Js5qA2G9; arc=fail smtp.client-ip=40.107.200.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="Js5qA2G9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oNELxkH2ctPEY2Rf1l5UM/RADDvXh17VXWKGuGRiiPV4KmNbfkTFmQwa0r+62EGYttktvPfIvW2WvPqsO9h/ZZQvxtObBJHIvlVuK8H1zUDRewJ75ultCtrF6tTIrHvMGxN7edwLvaxiztfbEUfEnySz2EIXQXBP10T5Dfa4VIlMJSBZVoPAwARcy6Rc1yZ5+R466tcAGk87l+pQpMbe2VLa5VSCpYtSKhHcxSOQJythTCCEApCokB6DrXUQTOqioXAu8PWjOySM0+5+AegmepBuwBlc/BTcwyS0mXiJB+AlcB7P9c5+H0Xh1X3zKODTfgG4M5ahToKUxe5tFuYHXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZ1hFYZXciMPZH+0zosA0iuzMmVdicvX5hXEFi1a9Y8=;
 b=hLQMd8wMxxY9Ywizo1cplFI7CkOkBzgziR3Cbuc9I9jgDrx7pVrktSKXh8s+HYs+uZyw4v/UfNkxzHWtXxxHvWXusjJ0jtRSGl3pwjyBFNXh8/nOshbPXhO6EOKvC135gtGVhWcq29fXlvTZPx4Fq4WSTDzzGH/t42gZhQxa/1uZ4FqJPhMfM7SDo/6b5fpHaY//d4/55W3Z6DWpJDS7UBLNu7PHFHD3KgIrtlRDs256nak5YIyFW67IoeqJssG7YHxSsR2ReQ4SWeHG6Oaz09wfimQ3uKXPGvlGWGOxyuUbwuS1UM8mg/we8eTJxYUYfo3Sz2yCTj3FYSzLbWWC2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ1hFYZXciMPZH+0zosA0iuzMmVdicvX5hXEFi1a9Y8=;
 b=Js5qA2G94TNfMVLwAOsW0LTsaZ8w7rBBDLcbBOX7GuE/x2nlC7n/SlRhAOn36mYx6a3NmsuAVl9APkcAhd3VdxBRRAKicgpvcKdnNUaOFIfNl+FntdF+6AJ6ZnK4KGjEPqKsC71sf6qQm7u7hNmjr3KasNJJNyinHUYeDwlqSonq6K9HS2rfkIlVJ5mcum2ewT9iw8wRzpEohRXDIdMWkPgSiecMxSENVkcJ60JP8/YXRP944KQHOeqgKEm/hNNjmxGE/gvH6O7pLvOwWp4Lx4yIOye9cUz0EzkFO0SiDoqpEHarfPR5JvrMM9CoxU1/mqWOLf33Hf7SPP+omNeKkA==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by BY1PR07MB10725.namprd07.prod.outlook.com (2603:10b6:a03:5c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 11:51:45 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 11:51:43 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	"magiclinan@didiglobal.com" <magiclinan@didiglobal.com>, "xiao@kernel.org"
	<xiao@kernel.org>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Masalkhi, Abd
 Alrhman" <abd.masalkhi@gatech.edu>
Subject: [RFC PATCH v3 0/4] md: add a control device for array management
Thread-Topic: [RFC PATCH v3 0/4] md: add a control device for array management
Thread-Index: AQHdVlI4gqCpX8pE0UaHSK0LnxY91w==
Date: Wed, 7 Oct 2026 11:51:43 +0000
Message-ID: <20261007115104.13884-1-abd.masalkhi@gatech.edu>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|BY1PR07MB10725:EE_
x-ms-office365-filtering-correlation-id: 18590d80-d735-4ee4-4fe4-08df24695b79
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|786006|38070700021|11063799006|3023799007|10067099003|56012099006|18002099003|6133799003;
x-microsoft-antispam-message-info:
 lqX0MARmOpckdYzz3G2QCIGVPcBpE4iM5Ykx5okCrbePxomW7qP1T0gmryuNDj6UolS3iLlLk4MTorxcgY4khyKC60vI3z4lQsQ7CjP2PlTzvulP4n9Rc8Cw6ziSGesmCvQIcqJRPg2rkzLN/PDCUxitPoSmYRrc3O+IKt1zzHBeaPtd9UY3T1WxYoWTMIbOFAonzXGSj1Zz4D2/9CqRIZujBFHf7Br7NNRXv8UFFA85fypmqrKsV8Vn74ZbBy0TbZfL+BJ2Ad2I8tydmU98TdjshCAy6Clkp2seFINve9BvHc1EYZ30BU7BLE2t/5ZJ0aNM9PzIALiwq9hGdK4SSTwx6F/qS8Dinh8iH3+eUQ2fvK3rdgkhBoA88KzVfZ1iUQfeJ9aOh+69tprK+U2G1udtfmcr4vQ5Rdii4hWlYI4Go+vA/oMbGihHHpsQyAW1JsyrWpttF4tDmmjZQq4jXdtPgXg2lUiKrs71hloZfXDOVmAy+JXj4ASbR1pSDdvG+NBcfTfS7Aw+TxixEv9mrU3Mmxk31BTC7TDdpaEmrJzJXK/TMsM1UxjevRmp1wC1bmhxW/YNpB6h31r48peARiRDX0IdfV2m1ezxiOg31wZQu7/5/bFDlMu3P+dmYg8IftxV/O1w6KAdUmlq9tjGUwFeRb3PoYwVRIN0zGDK0M4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(786006)(38070700021)(11063799006)(3023799007)(10067099003)(56012099006)(18002099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WHhPOHRMM0ZuQ0ZVZXlBOW1zTnp5WEFzZjJ4STYyUzNlYWxwNEFRME5xbDkr?=
 =?utf-8?B?SEJwNEVOU2xQM29PYWJWUzFOZkJxa3lMNGVXejArdVhVV2NxbC9nUWpkbHRX?=
 =?utf-8?B?aXRrNlJoOFpXVGU4VjFUTlJ3YzB3bHI5WmpiNlZldUFKcUtia0NrenQ5ajJv?=
 =?utf-8?B?Y0loRGhmWm5RaVlWV1ErYTVWZmRDNy9MQzVneXJTbDJxdjFPRjRQUVZHWjBE?=
 =?utf-8?B?dVpMRTFmdUFjTkpDYnFPTk15V0EydmJqT2FMZk5NQzdhNFlxTmZUWlRmaGRT?=
 =?utf-8?B?bkhTcWlWTG5LeHFSanBJK3VDNUNUTVJ0djIyUnBsSk9PVVBQQmdqMGpVOTZi?=
 =?utf-8?B?clk3NWZ4Y1FtM2NqY25CcjN6amQyVThKTWM1U2JrN2xxVUxxRGRMZlNiSjFn?=
 =?utf-8?B?NkY5SHJVTlA1NEtqa0NYbUpCWmk1UmpHbXM3cXc5c3FrQkU1KzZMRHg3SCtn?=
 =?utf-8?B?Mzgram04RzZ0WWZVM0g0czZQdzJUbE5Ddm1PblZhcHRYSmNMcVZKNjNxNmJn?=
 =?utf-8?B?TXNIR21peEFtaUxyNHRHQU82UzdZbGJCNWdmVXhrWnA4emVTeWFNRTF6enQw?=
 =?utf-8?B?UmprREIxUVdEVGZ3amVjd2g5bjZMVFFPZUpqR3hFV1dRUlZyOWJEQ0lOdURW?=
 =?utf-8?B?bWVBdmFoUkNlUnRFdUEzRFIxQTV4dVVFekY2TlAxbCtGVEJmem0yYkxJM1dZ?=
 =?utf-8?B?cTV4V1lxbHdUVC9zU1ViSVUybkZqb3ZKUzkydUwzTms5cFJVbERTV1l3Uzli?=
 =?utf-8?B?V00ycjJ6Yk9DTE1lTk95OXQzMjBJaFg2ZThDeUs1Q2p5d0Q1bE0zK21ldUly?=
 =?utf-8?B?RWdMN1VNUXQ5NjFqSDJiMzV4dFhDS0VXOGNGVTl1TzZzVFMxdlRmZGd6cFNG?=
 =?utf-8?B?M0wvSjNUVjRDajgxR1RIOVhXK1djd3RBK3Z1QWdSUzNZV2FoWW1WZERuUDFV?=
 =?utf-8?B?YkFjZmMwTTg1dTVpYjVOMHZmaFlKMjRIaTNKY2VGYTMxSEhxSDAxR3dJNXEy?=
 =?utf-8?B?Y2wrVTlLeUFBODVacFJTL0lKUTAwK2ZFRG1NZVQxbW0xUHNtZllHN09SUXlD?=
 =?utf-8?B?Mmg5MmZUbGd3dmN4VHRYY2ZRamJJWTRubStoV012WUtSUWs0b3ZRU0ZBVi9V?=
 =?utf-8?B?ZWVFc2dwcEhmcHNpWkVhZlRmbFdUWnNmTnY1ZTZEdGJTWWhwa0tZMS9XUlBi?=
 =?utf-8?B?SE1kQ3ByZkoxZjh1NHZqaFdMMXh6dzg5cCtyc0ZLZndCTzBUVVZFeXJRc2NI?=
 =?utf-8?B?ZS9tZzN1MThvK0J4ait1QXRJbkZ3bE1DVVRtcWR1Yi95dlk0OGYyaTJsNURJ?=
 =?utf-8?B?S2kvNlZIbng1ZGc1dDJQTm5JNk16YXlJaGhYYkVxTDZOWTE2dTJ2MTZvYmtP?=
 =?utf-8?B?TlNLYWVkVE1QRjZyS3o2NGlpUThPTDlzbnVtdDRXaFlMdXNSUGpQRUtuaVVW?=
 =?utf-8?B?UEhrS21OTGhrSnN1bUtjbExJS0RRZm5IYmhmUGV1R1Z4cTBPdHhtYllBVFNQ?=
 =?utf-8?B?KzdCRUtHTmIxOFJmVmtQMHBsRmhEQkpZUmxWZ2VmT2U0NFVtZUtSSEFreEZR?=
 =?utf-8?B?K09HOWVYeTAvZEZneEF1bkl3MzZyTVRwU2s2cWROdk9mdk1qZ0lxVTJqMy9U?=
 =?utf-8?B?N1p0dWNlSkxxZlhSWVdHMGF1d3Y3d0JvazMraEJMS3YzK0V5VHE5dkFoSTF1?=
 =?utf-8?B?RGVDR3VlY29ONG9aOXZ1ZFdjcjUrQmlHSndOTlRYT0JCQVV6UDFWUCtJcTdU?=
 =?utf-8?B?Ly85MC9jSVk4OVlOeTRVc1dvTUtQbno5anhYZmhUUVpBZlA2cVNDVlJFbENK?=
 =?utf-8?B?NkhKMjV5dWQ3WjB1M09uNVBaV2dhK3k1MUtGOTE1b2pSL3Q0cENoUUQ1emEz?=
 =?utf-8?B?T1Z3cDZ6Y0ZNZlE0bmVjUGRwbzZMV3hnTHhKYkpLeUhQTjViYlNLSkpJc2w4?=
 =?utf-8?B?M0tJUjk0SkZEVHZLVWtUN3FCNGpYZXBLV3NOWk9ZdnBpM2NlaUNETklJaTlQ?=
 =?utf-8?B?R1Z0aDFtazQzMk80SU14ckEzZmErMmFNUXJueVJHaVlnODJRcnF3NmtVTEpX?=
 =?utf-8?B?S2ZxTVNzLzZHa1ZYenA4SUpRYmF6YlBKQ3lRUHhnZFU2bWFITUM5MmtITG1K?=
 =?utf-8?B?TWp3cmJpaUZmV054RmtubDBBWmxpTytWUjhyalBVellvRGRKTnA3TzJTYVFI?=
 =?utf-8?B?YTUzSFpsT2VRcnR0WTVibGJIT1hqUkExUlpiTExBTjVoaUJUejNmb2VPb01U?=
 =?utf-8?B?S1MyS1VqL2szR3VXT2FKTlBJdHptSFpyS2ROdDUzZ05mTnAxejBlV09UcTdp?=
 =?utf-8?Q?k+9/wGDqzsps6mqcQg?=
Content-Type: text/plain; charset="utf-8"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 18590d80-d735-4ee4-4fe4-08df24695b79
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2026 11:51:43.4373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZYebOhzSUxk3WGlBy+bsZxnYdJZimNdIG0On6JUi9+wntXACRG2WGvxNIe+hdym8e+y/MvxV2/7Zmstc3papLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR07MB10725

RnJvbTogQWJkLUFscmhtYW4gTWFzYWxraGkgPGFiZC5tYXNhbGtoaUBnYXRlY2guZWR1PgoKSGks
CgpUaGlzIHNlcmllcyBhZGRzIGEgbmV3IC9kZXYvbWQtY29udHJvbCBtaXNjIGNoYXJhY3RlciBk
ZXZpY2UgZm9yCm1hbmFnaW5nIG1kIGFycmF5cyB3aXRob3V0IG9wZW5pbmcgdGhlIGNvcnJlc3Bv
bmRpbmcgbWQgYmxvY2sgZGV2aWNlLgoKQ3VycmVudGx5LCBtZCBtYW5hZ2VtZW50IGlvY3RscyBh
cmUgaXNzdWVkIG9uIHRoZSBtZCBibG9jayBkZXZpY2UKaXRzZWxmLCB3aGljaCByZXF1aXJlcyB0
aGUgY2FsbGVyIHRvIGhvbGQgdGhlIGFycmF5IG9wZW4gd2hpbGUKY29uZmlndXJpbmcgb3Igc3Rv
cHBpbmcgaXQuCgpUaGlzIGlzIGEgcHJvYmxlbSBmb3IgU1RPUF9BUlJBWSBhbmQgU1RPUF9BUlJB
WV9STy4gQmVmb3JlIHRoZSBhcnJheSBpcwpzdG9wcGVkLCB0aGUgcGFnZSBjYWNoZSBtdXN0IGJl
IGZsdXNoZWQsIGFuZCBubyBvdGhlciB0YXNrIG1heSBoYXZlIHRoZQpkZXZpY2Ugb3BlbiBvciBi
ZSB3cml0aW5nIHRvIGl0LiBUaGUgaXNzdWUgYXJpc2VzIHdoZW4gc2V2ZXJhbCB0YXNrcwpzaGFy
ZSB0aGUgc2FtZSBmaWxlIGRlc2NyaXB0b3IgdGFibGUsIGFzIHRoZXkgY291bnQgYXMgYSBzaW5n
bGUgb3BlbmVyLgpDb25zZXF1ZW50bHksIG9uZSB0YXNrIG1heSBzdGlsbCBiZSB3cml0aW5nIHdo
aWxlIGFub3RoZXIgdGFzayBmbHVzaGVzCnRoZSBwYWdlIGNhY2hlIGFuZCBzdG9wcyB0aGUgYXJy
YXkuIEEgd3JpdGUgd2l0aGluIHRoaXMgd2luZG93IGNhbiByYWNlCndpdGggdGhlIHN0b3Agb3Bl
cmF0aW9uLgoKVGhlIHNvbHV0aW9uIHdhcyBzdWdnZXN0ZWQgYnkgWXUgS3VhaSBhbmQgWmhpaGFv
IENoZW5nLiBTZWUgdGhlCmZvbGxvd2luZyBkaXNjdXNzaW9uczoKCmh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpbnV4LXJhaWQvODU2YTA2NWMtMzhlZi0wOGNkLTc3MDEtOGY1NzkyMTJhMWEzQGh1
YXdlaS5jb20vCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXJhaWQvMTJiMGJjNGMtNWRm
Yi00OTM2LThlY2QtODQ5MTM3YjU5N2Q4QGZ5Z28uaW8vCgpUaGUgbmV3IGNvbnRyb2wgZGV2aWNl
IGlzIG5vdCB0aWVkIHRvIGFueSBtZCBhcnJheS4gRWFjaCByZXF1ZXN0CmlkZW50aWZpZXMgdGhl
IHRhcmdldCBhcnJheSBieSBuYW1lLCBVVUlELCBvciBkZXZpY2UgbnVtYmVyLCBhbmQKY2Fycmll
cyBhIGZsYWdzIGZpZWxkLiBVbmtub3duIGZsYWdzIGFyZSByZWplY3RlZCB3aXRoIC1FTk9UVFku
IFRoZSBuZXcKY29tbWFuZHMgbWlycm9yIHRoZSBleGlzdGluZyBtZCBibG9jay1kZXZpY2UgaW9j
dGxzLCB3aXRoIFNUT1BfQVJSQVlfUk8KcmVwcmVzZW50ZWQgYnkgTURfU1RPUF9BUlJBWSB3aXRo
IE1EX1JPX0ZMQUcgc2V0LgoKTmV3IDY0LWJpdCBzdHJ1Y3R1cmVzLCBpbmNsdWRpbmcgbWR1X2lv
Y3RsLCBhcmUgaW50cm9kdWNlZAoobWR1X2FycmF5X2luZm82NCwgbWR1X2Rpc2tfaW5mbzY0LCBt
ZHVfcGFyYW02NCwgbWR1X2JpdG1hcF9maWxlNjQsCmFuZCBtZHVfdmVyc2lvbjY0KSB0byByZXNv
bHZlIHBhZGRpbmcgYW5kIG92ZXJmbG93IGlzc3VlcyBpbiBmaWVsZHMKc3VjaCBhcyBzaXplLCBj
dGltZSwgYW5kIHV0aW1lLgoKVGhlIGV4aXN0aW5nIG1kIGJsb2NrLWRldmljZSBpb2N0bCBpbnRl
cmZhY2UgcmVtYWlucyB1bmNoYW5nZWQuCkEgd2FybmluZyBpcyBlbWl0dGVkIHdoZW4gaXQgaXMg
dXNlZCB0byByZWNvbW1lbmQgdXBncmFkaW5nIG1kYWRtIHRvCnVzZSB0aGUgbmV3IGNvbnRyb2wg
aW50ZXJmYWNlLgoKVGhlIG1kYWRtIGhhcyBiZWVuIG1vZGlmaWVkIGNvcnJlc3BvbmRpbmdseToK
TGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtcmFpZC8yMDI2MDkyODIxMTg0OS4z
NjAyNDE0LTEtYWJkLm1hc2Fsa2hpQGdtYWlsLmNvbQoKVGhpcyBpcyBhbiBSRkMgYmVjYXVzZSB0
aGUgbmV3IFVBUEkgKHN0cnVjdCBtZHVfaW9jdGwsIG1kdV9hcnJheV9pbmZvNjQsCm1kdV9kaXNr
X2luZm82NCwgbWR1X3BhcmFtNjQsIG1kdV9iaXRtYXBfZmlsZTY0LCBhbmQgbWR1X3ZlcnNpb242
NCBhbmQKdGhlIG5ldyBjb21tYW5kIHNldCkuIEkgYW0gdGhpbmtpbmcgYWJvdXQgYWRkaW5nIGEg
bmV3IGNvbW1hbmQKTURfTkVXX0FSUkFZIG9yIE1EX0NSRUFURV9BUlJBWSB0byBjcmVhdGUgYSBu
ZXcgYXJyYXkuIEZlZWRiYWNrIG9uIHRoZQppbnRlcmZhY2UgaXMgd2VsY29tZS4KCkkgYW0gYXNs
byBjb25zaWRlcmluZyBhZGRpbmcgYSBjb21tYW5kIHRvIGNyZWF0ZSBhIG5ldyBhcnJheQpNRF9O
RVdfQVJSQVkuCgpTdWdnZXN0ZWQtYnk6IFl1IEt1YWkgPHl1a3VhaUBmeWdvLmlvPgpTdWdnZXN0
ZWQtYnk6IFpoaWhhbyBDaGVuZyA8Y2hlbmd6aGloYW8xQGh1YXdlaS5jb20+ClNpZ25lZC1vZmYt
Ynk6IEFiZC1BbHJobWFuIE1hc2Fsa2hpIDxhYmQubWFzYWxraGlAZ2F0ZWNoLmVkdT4KCkNoYW5n
ZXMgaW4gdjM6CiAtIEZpeCB0aGUgaXNzdWVzIHJlcG9ydGVkIGJ5IHNhc2hpa28tYm90LCBMaW5r
OiBodHRwczovL3Nhc2hpa28uZGV2LyMvcGF0Y2hzZXQvMjAyNjEwMDExMjU2MTEuOTQzNzMxLTEt
YWJkLm1hc2Fsa2hpQGdtYWlsLmNvbT9wYXJ0PTQKIC0gTGluay12MjogaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGludXgtcmFpZC8yMDI2MTAwMTEyNTYxMS45NDM3MzEtMS1hYmQubWFzYWxraGlA
Z21haWwuY29tLwoKQ2hhbmdlcyBpbiB2MjoKIC0gTW92ZSB0aGUgY29kZSBmcm9tIG1kLWN0bC5j
IGludG8gbWQuYyBhbmQgcmVtb3ZlIG1kLWN0bC5jLgogLSBIYW5kbGUgdGhlIG5ldyBjb21tYW5k
cyBkaXJlY3RseSBpbiBtZGN0bF9pb2N0bCgpIGluc3RlYWQgb2YKICAgY29udmVydGluZyB0aGVt
IHRvIHRoZSBvbGQgaW9jdGxzLgogLSBVc2UgYSBkeW5hbWljIG1pc2MgbWlub3IgbnVtYmVyIGZv
ciAvZGV2L21kLWNvbnRyb2wuCiAtIERyb3AgdGhlIGRldm5hbWUgbW9kdWxlIGFsaWFzLCB3aGlj
aCBvbmx5IHdvcmtzIHdpdGggYSBmaXhlZCBtaW5vci4KIC0gRml4IHRoZSBpc3N1ZXMgcmVwb3J0
ZWQgYnkgc2FzaGlrby1ib3QuCiAtIFRha2UgZGlza3NfbXV0ZXggYXJvdW5kIHRoZSBsb29rdXBz
LCBzbyB0aGF0IHRoZXkgbmV2ZXIgc2VlIGFuCiAgIG1kZGV2IHRoYXQgbWRfYWxsb2MoKSBoYXMg
bm90IGZpbmlzaGVkLgogLSBDbGVhciBob2xkX2FjdGl2ZSBvbmx5IHdoZW4gYSBjb21tYW5kIHN1
Y2NlZWRzLgogLSBMaW5rLXYxOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1yYWlkLzIw
MjYwOTI4MjAxMjI0LjM2MDIyNjItMS1hYmQubWFzYWxraGlAZ21haWwuY29tCgpBYmQtQWxyaG1h
biBNYXNhbGtoaSAoNCk6CiAgbWQ6IGFkZCB1YXBpIGRlZmluaXRpb25zIGZvciB0aGUgbWQgY29u
dHJvbCBkZXZpY2UKICBtZDogcGFzcyBzdHJ1Y3QgbWR1X2Rpc2tfaW5mbzY0IHRvIG1kX2FkZF9u
ZXdfZGlzaygpCiAgbWQ6IHVzZSBzdHJ1Y3QgbWR1X2FycmF5X2luZm82NCBmb3IgU0VUX0FSUkFZ
X0lORk8KICBtZDogYWRkIGEgY29udHJvbCBkZXZpY2UgZm9yIGFycmF5IG1hbmFnZW1lbnQKCiBk
cml2ZXJzL21kL21kLWF1dG9kZXRlY3QuYyAgICAgfCAgIDQgKy0KIGRyaXZlcnMvbWQvbWQuYyAg
ICAgICAgICAgICAgICB8IDcwMyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0KIGRy
aXZlcnMvbWQvbWQuaCAgICAgICAgICAgICAgICB8ICAxNyArLQogaW5jbHVkZS91YXBpL2xpbnV4
L3JhaWQvbWRfdS5oIHwgMTE5ICsrKysrKwogNCBmaWxlcyBjaGFuZ2VkLCA4MjMgaW5zZXJ0aW9u
cygrKSwgMjAgZGVsZXRpb25zKC0pCgoKYmFzZS1jb21taXQ6IDVjMmY0MTE1MDUxZDA2NGFkNzli
MGI0ZWRhYzcwYTJiNjI1MjhkOWQKLS0gCjIuNDMuMAoK
