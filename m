Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.113
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793205446;
	b=VXSvlJKm2WWNqgDaZGXnzHpmjKYeYDYqvGMjkso92sw9T6uNOBnDOsBmKfSPq5YdW3Bh
	 rOXgHcbxb5l3U9mfq/6LaNQWNBlDiOEaCjkGqiPA4DtlD3t35/hA+pMWuX2MQdMR1Nv0w
	 qySwIaO8kyyxu8dMuRdLq6WC50tVIBgd6p57dZABEwbkvxKGJb3iv+RUj0JybTkGBZ56u
	 UKckNuHAr5c/WHNQIK02+LS7WHof7SZR8fMVmiVTiAv89v0taorEC2VpjALPo1QMxl6Ay
	 siX3OgZVtHpttbLK2RgggR5Ya1PKQBgU6ZyzVD0bIRPiBuI5qDVf9cf+TIwZ1sba88g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793205446;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-gt-tenant:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ZZ1eZFLKFoZeyQi+7IsasJGnhq24W6n2NorOX41CafI=;
	b=f/z5k7Z8Y99a0aHeYmPibtwvqXTnSAfJZUsR+z1fofuIxWYatKcUPyiLSzF1z7YsZLr/
	 0fCB/kZ4//Wk/8UoK7ASDEnQAhjU9MQSN82UkUsV5o1vxAmGa7PrpGA9iGISVGS0qZwcY
	 WIynf9aSOaP0zEN7NlC8DYqBLRbiCfH5CIePARs3qwZsZEVpkaFrANsae/+sWG/vK/W+v
	 33d3NKOt1MBvW0KG65UoT43YGST5LtwCpLmt1Nkhv8yNnMAMGdMqcsKRxCKUqhmrFGDq+
	 1KxAJaRPmCluNgouFnkojKUzIgsNlVOr+ZdqsYqV0ghtBILslemdWJ0sSW+yb8esFhg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gatech.edu;
	spf=pass smtp.mailfrom=gatech.edu;
	dkim=pass header.d=gatech.edu header.i=@gatech.edu header.a=rsa-sha256 header.s=selector2 header.b=QsUki3t8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.113
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020113.outbound.protection.outlook.com [52.101.56.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CEB60A2638
	for <linux-raid@vger.kernel.org>; Wed, 28 Oct 2026 16:37:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3CEB60A2638
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gatech.edu header.i=@gatech.edu header.a=rsa-sha256 header.s=selector2 header.b=QsUki3t8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UUjh8BFj3gNXcVAli1R5sKl3kJIgKnUdZJmiVwh5ddDSOF+tvHhUPVk4On42tnl2L+eOo9moVWH3zTyZjtcUTpa4watKV4uJdfGsi3YWyrmMTvpmbX4taiy8/vEsvEDzKDbgrAhGZGUag2CA3iem1Py1T318UpEf8M+8GwSt1IcmdW/RCQKN65ff1ap+sBDgWbNumB2TJZVoWkWb5Ad4O7bP9wfetWfB/F498peVqPCDoJIs84kR9kGt4cFOvR+EPQkx1ltthpdY44gtB3mNO83DiIWPFUlZy49OMEGL0FvKG+btvHPv+U+aPEtmnojRWaighZJn72x+7sg5/yqS+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZZ1eZFLKFoZeyQi+7IsasJGnhq24W6n2NorOX41CafI=;
 b=p7kWB1U5OpfQSVutrqIwZF3j5B22u91d25TcDoEb1UyaOIfrL6VQJZkzFDCdB42rev5b89Rp43/WYjL+Vn5hoMJ5L7uxBmau5p+BQZpicyIkHSg3ioWSAhIz1dnXCQcnsmv5xbQDbFn+sWAZQLjYzT4lD1sEbYXexycXysmp/RwIh+JOU/0tRC6DLAcSh1Lo656WfWwZB5vHKKy1fJpdjs3QZg7DpyH7twiyOKwLESFiBtPGva5zixGJ/xbAhg9zn3X0nV8UBF92AVM9QroXXij/tfGyPOwuhQWZT57DqGj2pZF9nhVmBanOO793Rv9QGq7igO+ElN+xZJDuepGQwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZ1eZFLKFoZeyQi+7IsasJGnhq24W6n2NorOX41CafI=;
 b=QsUki3t85f6oWjHc+xHdXeXC7ztuMoiUdlqh88by9Fyrs12B1IrZCHKIkUBMXs8Yhct/46rH/XPvyotd9uLeDIcN5kxnU3bNKw/oqCn73+9XOUqrd/65yt9hN/VWLBpU5DVMZm8ofFZLl+45d56nBE0dLtqKB5nK0K7LUovGTdll3ZT8Dj4jy3yE0msJoQbgWUzyM7RRyD3Ym+HTVrTgFTv8V6bGMJR2tbVsT2CMKu5O0w6bfoK6oVPCysh5xTUCPoc9eZNf5CvOweHuXz5+XiO4jH1z8Z+t4ekduSlQ+BwX1cXm8qJ5qt40dhI8XNHZCOu2KlOneKc+36zuLDqXgQ==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by SA3PR07MB262098.namprd07.prod.outlook.com (2603:10b6:806:58d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 16:37:22 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0569.007; Wed, 28 Oct 2026
 16:37:22 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>
CC: "blazej.kucman@graidtech.com" <blazej.kucman@graidtech.com>,
	"ncroxon@redhat.com" <ncroxon@redhat.com>, "xni@redhat.com" <xni@redhat.com>,
	"song@kernel.org" <song@kernel.org>, "yukuai@kernel.org" <yukuai@kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] mdadm: Deprecate the obsolete --auto-detect option
Thread-Topic: [PATCH] mdadm: Deprecate the obsolete --auto-detect option
Thread-Index: AQHdXKWk/Eu9yn3gWkG8xQmEoOcxmbcSvQyAgABACYCAABMWgIAAK70A
Date: Wed, 28 Oct 2026 16:37:22 +0000
Message-ID: <m233tp3hof.fsf@gmail.com>
References: <20261015130326.442915-1-abd.masalkhi@gatech.edu>
 <20261028100317.3b964788@kernel.org> <m25wym2diq.fsf@gmail.com>
 <20261028150047.688d2120@kernel.org>
In-Reply-To: <20261028150047.688d2120@kernel.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|SA3PR07MB262098:EE_
x-ms-office365-filtering-correlation-id: c0ee2d2e-854b-4dfd-a5bf-08df3511bd92
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|786006|1800799024|23010399003|366016|376014|4143699003|38070700021|261026121527099003|261021121427099003|5023799004|11063799006|56012099006|261022105027099003|261009223027099003|10067099003|22082099003|18002099003|6133799003|261026140227099003|261028144727099003;
x-microsoft-antispam-message-info:
 bQoWizBdWCmSDJdfdVSraBvpogZc4s6n5hhpr8FNLodzJzedZxxw5VxqXNXwaJh8m6dgY7QCSX3WrQBAt+qdPx4P/UOkKUv+LDY3pzsPq8yKtH9MaQgGGYaz9TOKp+h4qzxfPEqmv9QIIb8Owh2FfTjfq6RJlFFGbWaMaSjiVO+Byel9WyhIYBYD4pojy3Si4JqRIcYJzjPwNqAQPSUeOekeKwN9j9zvTmL7Cl40tvB6Or9BRpTEJG0pC6cpBt6U8Ctl8UEjDkCjF0Y7cxiSEIRbdxflLHD2MZsGN57k4qeF9GLGjAVF51FGEdsV2Z/T6OD0LKy96WInz77DelxuWlG8MFGsxZ/MwF5JF3kETsYm3oFflvNRjoe2/n/gkgFnF8sMbthgGCP0IVq0Kr/IFAWlJDM4nAErA217C0Y2mD7aEoqMKp/RLIYNGCaf9RV3KboVAtrcKaZC2y88P6wbdcumz51YUWPjsBOYMLeWusL0gAg1Tk9LTN5b8ACCu32VAltXhrtkhF9Llq9kZunXHRfhqIdggnB86w3BVjCRxH4lU/nC4G+IinsXc9MbZQLH+kCDMmYIqXcsWKdEvQXNyn1MBrFWFoiBXeTjhv6LhnZ2gR7WQT2353wBIxZqnAHLjbK08/PyHHTktX1GeEWSmVuEg7s1nkxO3pskLacBH2GTIff+KzeckItqN0gDwPiOC+9IxsK8gph81Pw9cI/v0hlobXEEwYOs/45bbY6QQUw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(1800799024)(23010399003)(366016)(376014)(4143699003)(38070700021)(261026121527099003)(261021121427099003)(5023799004)(11063799006)(56012099006)(261022105027099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(261026140227099003)(261028144727099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UytOc3NGdWdmbGpTSXUwRjUyRjZHb0pOYVA3YStuZ0J6RGtWNWt5ZlF5aW9I?=
 =?utf-8?B?eEZrRXB1bXRRRkkyc1U3ZVF2cVBxOTdyUUxVT1lkaWNPanpEa2I5Y3JBdGNi?=
 =?utf-8?B?bzU3SVd5VmI3REVLSW10UGVkMnBDcmRRVzF2eE9aVmtSNXBneE5SZ25leXRu?=
 =?utf-8?B?T3M4QXlhWmc5dTAyVVVHemF6UzdXWHpGZ2hUV3B0WVRYOWhGby9QWDNIek9y?=
 =?utf-8?B?WFRnTjI3UHliNHYxZVpzQmFYbTVBdlBxazdKTVVRcmZ4TStoeU5LMFhlNjlB?=
 =?utf-8?B?NlM3ZkxtU3FEa24xbFprWWZod1JEK1FxM0JudUVWcjIvYW1Ecm4wY3ltVUpP?=
 =?utf-8?B?N3JRVTFIMTZLZldXelhYcFV6TXVzc2hOeEU2bktXYksxYTkrZzV6MTloU05p?=
 =?utf-8?B?c2RHdlZJd281NmVFT0grT1l3SXVmNmZyRVczb1lucXlHVTgrdkdEYnNrN3FJ?=
 =?utf-8?B?alhVK1hXUExnZy8rMk9OWmtrYXJGTUcrUUo2dXQ0NVhiWU1XeEN5Q3F1a1dY?=
 =?utf-8?B?bEhBR3VvSHRDUVF3MHpDNG12SkpPdXlZN0M2TDJseVJJMU9WZG9oQmI2STNF?=
 =?utf-8?B?MFRZQ0l6cE9NdWk1UmtvQjdaWXpDb09hSWpxOXJqaHdsOHVHbXVmaVVja3N2?=
 =?utf-8?B?QUZhZ29ESStmb3RuZGN3R2NjcDFmZkRSVnFPT1dHSUprZUNydzl4Y2J5Yk5K?=
 =?utf-8?B?dVFzRStrMjVtN1hLTWM4RGhZZDBlbnlLL0RVM0dQaHRKUGJiZ0xkamFxS1dO?=
 =?utf-8?B?aE0xVmtZaURZclNQZmZBaVF4S1l5WXRwQlk5Q0RNMXd3YkkrSExYdUhheW9S?=
 =?utf-8?B?dEYzTWJ4MFhsRTllU2lDZEI3NzMxVDNYWVAwbVlqWEg1TTBVWFQ4NHQ3MW1I?=
 =?utf-8?B?U0NjeFFqalpubC9zYjZUN0RibEN3SUtOL0pRSlRKMmsrNFZhZDF4cVBUdjVH?=
 =?utf-8?B?UnRNSUJoWG5Rdkg0VUN4QzU5aHVXMHQxOWdNYzlmcEJoYTJWdEJxT29Sa1BV?=
 =?utf-8?B?WFNvdWpHR095TWwyOTVFTkF4TFFMWW5tRi9SVDZ0cmFjeS8vZW45a0VtbW1a?=
 =?utf-8?B?YnNJK2NldXlySXkvSjZlbERBYks1RVVmbVpMQVBWQXZBQ3hQL3lrcjVHY3gr?=
 =?utf-8?B?akYrQmI1OTRyTk1TVHFqNEdOR2lJbmYwUFpLZ2lOalZDYisrQzJCa0d6dERV?=
 =?utf-8?B?QkdjelFiREdKS3JZb3VBWWw4SWtDRlAreDJMaWJXRmg1YWtqdDdxWnBpR2Zo?=
 =?utf-8?B?Vk4zenlBWHorajV1Rk56a2E4NFBJVDVrTFFxWSt2Y2YxMXFNeFFicXp2RkNL?=
 =?utf-8?B?N3BSUWhidTl5YkQ1TndjaUlhTWl6ZllvR1NGSUh6RXJFdGlaRkVUazhCYW1B?=
 =?utf-8?B?TlFLa2owZTc0ei9wWjNGbG1rUzZMZDVBZjRPSklFU3ZjYVRUZVA2VlRPdHhn?=
 =?utf-8?B?eEQ3MkNKaDZ3aDV1dHZHeUNJNnJlZlFLcklwakIzUCtwVThFWGZseXhMblJ3?=
 =?utf-8?B?SWdMc0ZaNlRPRUw5Y0FFNTNGTjFSL01RVmZWMmhEb3hxR3lJZExubkNaWFBu?=
 =?utf-8?B?Sk03bUpndVJvQ2J5VWVTNkt3eGo1NFVBWHdoL2JEenRGVVRBN24yZDNZTXJq?=
 =?utf-8?B?SlhPYzU1WnVoZjIvZjRaUEVzdTljYVd5N1FLN2QxUGk4dE5CZnRGc1JNT0ZV?=
 =?utf-8?B?WjJZamZUdnltYlFqN3M3M2Z1U21WdXV6dEhBczNWQkFiV08yYWJDL3NhbU15?=
 =?utf-8?B?NkF2c2lHaUVKU1ZFU3hOcmZvQmpiZHZNdUpvZmVPL29jVEJsRFFRaC9COGcz?=
 =?utf-8?B?ejJtYjZ0a09HUVpLSGpBbGxrSUFUUjZTS24zOGo2V3BkOGpweXNDMzNSYWJh?=
 =?utf-8?B?anloZzByc3hNd3JGbFI4MDRnN3lxQkk0Rm5vaUtYZHpPSmJEQWNCbVlNdkcv?=
 =?utf-8?B?VzR4Y2k2KzJQWGoxejltSUkxRVM1U1dKZnFzeWJNOVJITWs1bnJIbnRWS0ZL?=
 =?utf-8?B?VE5lVEd3Sk12UGY0K1R5T2RFUnRBWGhiQWk0QUxrZGNrSWp1Z1dXZmVUaTI1?=
 =?utf-8?B?RVVTekNWOW1MbGlISE9Ed0lJNFFmc2l1RHhTUDU3cnozZTZGanFVbWVpTlhN?=
 =?utf-8?B?bS9qazVnY2RoYlk2L0xGSU9iUFBVTWhKbVRHbjFqOW1OR2VpdWN3c1hRMFRk?=
 =?utf-8?B?eVcrSjF0WTB1QzBlcllSdTZOSW9vZXZkM01peXRKU1QveE1yZ1h3NXpUY1l0?=
 =?utf-8?B?Nm1SZm55K0NRZGgyUmJjTnV0My9OMmhueXgyVFY4YVhBd3BCdUdLam9lK29x?=
 =?utf-8?Q?w5laqJkznXa3UNRzld?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: gatech.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR07MB9958.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ee2d2e-854b-4dfd-a5bf-08df3511bd92
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 16:37:22.0667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uSi5hIA576PM78KUzsERpCkFgjJF+Rc5ZXb423o7FDgFJ38e7VpNYjZlhJFVa3O3G734EOUSLyPtJhY+ptMmLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR07MB262098

SGksCgpPbiBXZWQsIE9jdCAyOCwgMjAyNiBhdCAxNTowMCArMDEwMCwgTWFyaXVzeiBUa2Fjenlr
IHdyb3RlOgo+IE9uIFdlZCwgMjggT2N0IDIwMjYgMTI6NTI6MzAgKzAwMDAKPiAiTWFzYWxraGks
IEFiZCBBbHJobWFuIiA8YWJkLm1hc2Fsa2hpQGdhdGVjaC5lZHU+IHdyb3RlOgo+Cj4+IEhpIE1h
cml1c3osCj4+IAo+PiBPbiBXZWQsIE9jdCAyOCwgMjAyNiBhdCAxMDowMyArMDEwMCwgTWFyaXVz
eiBUa2FjenlrIHdyb3RlOgo+PiA+IE9uIFRodSwgMTUgT2N0IDIwMjYgMTM6MDM6NTkgKzAwMDAK
Pj4gPiAiTWFzYWxraGksIEFiZCBBbHJobWFuIiA8YWJkLm1hc2Fsa2hpQGdhdGVjaC5lZHU+IHdy
b3RlOgo+PiA+ICAKPj4gPj4gRnJvbTogQWJkLUFscmhtYW4gTWFzYWxraGkgPGFiZC5tYXNhbGto
aUBnYXRlY2guZWR1Pgo+PiA+PiAKPj4gPj4gLS1hdXRvLWRldGVjdCBvcGVuZWQgbWQwICg5OjAp
IGFuZCBpc3N1ZWQgdGhlIFJBSURfQVVUT1JVTiBpb2N0bCB0bwo+PiA+PiBhc2sgdGhlIGtlcm5l
bCB0byBzdGFydCB0aGUgYXJyYXlzIGl0IGhhZCBhdXRvLWRldGVjdGVkLiBUaGUga2VybmVsCj4+
ID4+IHJlbW92ZWQgdGhpcyBpb2N0bCBpbiBjb21taXQgZDgyZmE4MWMyMzY0ICgibWQ6IHJlcGxh
Y2UgdGhlCj4+ID4+IFJBSURfQVVUT1JVTiBpb2N0bCB3aXRoIGEgZGlyZWN0IGZ1bmN0aW9uIGNh
bGwiKS4gQmVmb3JlIHRoYXQsIGl0Cj4+ID4+IHdvcmtlZCBvbmx5IHdoZW4gbWQgd2FzIGJ1aWx0
IGludG8gdGhlIGtlcm5lbC4gU2luY2UgdGhlbiwKPj4gPj4gbWRfaW9jdGwoKSAgCj4+ID4KPj4g
PiBSZWRoYXQgc3RpbGwgYnVpbGRzLWluIG1kIGludG8ga2VybmVsIHNvIHRoZXJlIGlzIGNoYW5j
ZSB0aGF0Cj4+ID4gc29tZW9uZSBpcyB1c2luZyBpdC4KPj4gPgo+PiA+ICAKPj4gPj4gaGFzIHJl
amVjdGVkIGl0IHdpdGggRU5PVFRZLCBtYWtpbmcgLS1hdXRvLWRldGVjdCBpbmVmZmVjdGl2ZSBv
bgo+PiA+PiBjdXJyZW50IGtlcm5lbHMuICAKPj4gPgo+PiA+Cj4+ID4gSGVsbG8sCj4+ID4gRG8g
eW91IG1pbmQgdG8gc3VibWl0IGdpdGh1YiBQUnMgZm9yIG1kYWRtIHBhdGNoZXM/Cj4+ID4gaHR0
cHM6Ly9naXRodWIuY29tL21kLXJhaWQtdXRpbGl0aWVzL21kYWRtCj4+ID4gIAo+PiAKPj4gU3Vy
ZSwgSSB3aWxsIHN1Ym1pdCB0aGUgbmV4dCB2ZXJzaW9uIGFzIGEgR2l0SHViIHB1bGwgcmVxdWVz
dC4KPj4gCj4+IE9uZSBxdWVzdGlvbiwgc2hvdWxkIEkgYWxzbyBzZW5kIHRoZSBSRkMgcGF0Y2hl
cyBmb3IgdXBkYXRpbmcgbWRhZG0gdG8KPj4gdXNlIHRoZSBuZXcgVUFQSSB0byB0aGUgbWFpbGlu
ZyBsaXN0LCBvciBpcyBzdWJtaXR0aW5nIEdpdEh1YiBQUnMKPj4gc3VmZmljaWVudD8KPgo+Cj4g
SW4gdGhpcyBwYXJ0aWN1bGFyIGNhc2UgdGhlcmUgaXMgbm90aGluZyBpbnRlcmVzdGluZyB3ZSBh
cmUgZ29pbmcgdG8gZG8KPiB3aXRoIGtlcm5lbCBvciBhbnkgcHJvYmxlbSB0aGF0IG5lZWRzIHRv
IGJlIGNvb3JkaW5hdGVkIHdpdGgga2VybmVsLgo+IEp1c3QgdGFrZSBuZXcgVUFQSSBhbmQgdXNl
IGl0IG9uY2UgaXMgYXZhaWxhYmxlIHNvIEkgZG9uJ3QgdGhpbmsga2VybmVsCj4gbGlzdCBtZXNz
YWdpbmcgaXMgbmVlZGVkLgo+Cj4gSSBmb3Jnb3QgdG8gc2F5LCB0aGUgcHJvYmxlbSB5b3UgYXJl
IGNoYWxsZW5naW5nIGlzIHZlcnkgbGVnYWN5LiBXaXRoCj4gcHJvcG9zZWQgY2hhbmdlLCB3ZSB3
aWxsIG5vdCBuZWVkIHRvIG9wZW4gdGhlIGRldmljZSBhbmQgZ2VuZXJhdGUKPiB1bm5lY2Vzc2Fy
eSBldmVudHMgKGFuZCBwcm9ibGVtcykgYW55bW9yZSEgSSdtIGdsYWQgdG8gc2VlIHNvbWVvbmUK
PiB3b3JraW5nIG9uIGl0Lgo+CgpZZXMsIHRoYXQgaXMgdGhlIGVuZCBnb2FsLiBJIHBsYW4gdG8g
ZG8gaXQgaW4gdHdvIHBoYXNlcy4gdGhlIGZpcnN0Cm9uZSBpcyB0byAgYnV0IGtlZXAgdGhlIGFy
cmF5IG9wZW4gYXMgdG9kYXksIGV4Y2VwdCBmb3Igc3RvcCBhbmQKcmVhZC1vbmx5IGFuZCBpIHdp
bGwgb3BlbiB0aGUgcHVsbCByZXF1ZXN0IHRvZGF5IG9yIHRvbW9ycm93LgoKQW5kIHRoZSBzZWNv
bmQgaXMgdG8gc3RvcCBvcGVuaW5nIHRoZSBhcnJheSBlbnRpcmVseSB3aGVuIHRoZSBjb250cm9s
Cm5vZGUgaXMgYXZhaWxhYmxlLiBJdCBpcyB0aGUgaGFyZGVyIHBhcnQuICBNdWNoIG9mIG1kYWRt
IGlzIGJ1aWx0IGFyb3VuZAp0aGUgYXJyYXkgZmQsIGl0IGlzIHBhc3NlZCB0aHJvdWdoIG1vc3Qg
ZnVuY3Rpb25zIGFuZCB1c2VkIGZvciBzeXNmcwpsb29rdXBzIGFuZCBkb2luZyBpdCBzZXBhcmF0
ZWx5IGtlZXBzIHRoZSBmaXJzdCBzZXJpZXMgcmV2aWV3YWJsZS4KCj4gTWFyaXVzego+CgotLSAK
QmVzdCBSZWdhcmRzLApBYmQtQWxyaG1hbgo=
