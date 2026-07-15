Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021078.outbound.protection.outlook.com [40.107.130.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F4A34041C
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 07:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784099433; cv=fail; b=DME5dIZW3oxAWMk4TANIYE4WvDvybWzFsumEChQm9zXBfhGazMtE1kmNluoqiPS1kS66he1/IoIgInIeMA+3wbcdf99d//Fh0Knjcl1TfKzfBFkDC6BLYtd2YcUiCDf6eAVB7RU/TtmlkUt+gSgWESfxZRvGUCbRwHdBhLn+ci0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784099433; c=relaxed/simple;
	bh=9LoVqPnfHBCMH1BrV3upaycId/dZoCILVEF/9826gHA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BaQ4PvLjxpMQ6e3NcKFV27RwFuzuqFjMc95yidRt+5YIa/6fDvgATB1jE2Ym71Ov3AabgQVmrLnhctSu0FbkPSo95fa+dMNlwk8Djhwsr+Q9+ZRg9lrVRjHZUEWzSD3ief6KUA6jclHMIY5TYygwkA3pAhCfLN53V8JINl3sTMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl; spf=pass smtp.mailfrom=hunenet.nl; dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b=pY5dM71P; arc=fail smtp.client-ip=40.107.130.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b="pY5dM71P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZJAo5XF5WJo6lj1LLj1TqTmmwraIQ+u4oJ6RJyiWOKHh77sHYe9cFC5k0JFso1TvmU0rmHKq/p79mFUTdgYPVbNDquSD3uj9UHqTIaHQMRj+MelJek4ZBqJVU59GyQbapl79BDlQVOmZtDmVKanB2x6eiLVIH6ZcUmGPPi8Ql0lGbT5MIfIlOuHYQm5QXjKnubBo0t1yBNe0LVe9YhLyqlOo5QMha/sU3J/czoIBSkEcfhjeZ00TVZbYBGXcPXtsaQJ0NJgsfHok8Z5HHla0/RxMXOHjKUmybhbvng19E60rG685Vp+E5BOlSOtJW8A+8GGbbgel49o7foo12fwrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LoVqPnfHBCMH1BrV3upaycId/dZoCILVEF/9826gHA=;
 b=ZxxzM6aIl56yO3w2TZg+nCKS4cyDb8IZ0be/zU9rHTtCidd22i838x7kb0ZVKM98sHR3IxigUjSGNqbkkEvRmjhfuPH/8GSKqSyvx8sxzWhEqm6utjF4JB/PCBh2vCZ1E0w12GgzzHtcLgBspLnFJrHOum0IA59efButp+wvjFFmGSoEHbK/El8pyNVfIYfjxoqzOBq7uiI563GyghE29eQWgj79LP+hkXemZcYe0QBbUFOP0zBt8a81ixZ9gP6dmdR5++SxW0JX0S0aEvWhZV8Sc96hQ+c8Bra1qe0fNz/3knQEzxGsvJwRE1Mby/Q8kKxcBo3kf0ZpkfAL8FkFPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hunenet.nl; dmarc=pass action=none header.from=hunenet.nl;
 dkim=pass header.d=hunenet.nl; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hunenet.nl;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LoVqPnfHBCMH1BrV3upaycId/dZoCILVEF/9826gHA=;
 b=pY5dM71Po06BTEO+R07i2zopd8mGsqbn3SjYv2lR6utY93kJVUWf44G1KPtbod0iqIAyKHCF1WknJwMibN8p/04szjMxDHGzCFkPsRKU/o+2PHmB51dCrjZsIArczwGWL5TTit4RKQXzseKIQ2jPYV+49bfTeSbjclTxLesQ7eSmoQtZU5q34qBZDez42q/CYo1Ma+Utx2hD3LgpZYD5po3uLO0GUqHvTD+VAU3Gb+AnrSutUqIYSUTmkn12UQj6s4d1FXT53N4bM01oUMunA9nkqjnVYPWEFl59kWroEJzSpOVcwScdOD/wOP3uw7y+sRqT8jOf2J5X0eC3dFPxGQ==
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com (2603:10a6:803:e8::33)
 by AM0PR05MB6836.eurprd05.prod.outlook.com (2603:10a6:20b:144::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 07:10:26 +0000
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5]) by VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 07:10:26 +0000
From: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
Thread-Topic: Subject: RFC: Read repair for md RAID1 after mirror read
 failures
Thread-Index: AQHdFAT9gXN+3UMPxEiBW2BLzju2krZuDRaAgAAc44A=
Date: Wed, 15 Jul 2026 07:10:25 +0000
Message-ID: <368d1223-1d41-4227-af33-bd6bd00b5c3d@hunenet.nl>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com>
In-Reply-To: <m2y0fcesbe.fsf@gmail.com>
Accept-Language: nl-NL, en-US
Content-Language: nl-NL
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hunenet.nl;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR05MB6144:EE_|AM0PR05MB6836:EE_
x-ms-office365-filtering-correlation-id: 9f25bb18-6d2c-4d8a-fa7d-08dee24024fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|4143699003|56012099006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 5go6x0ymNqAXWmblTjwRyvKyVL1x2dBnJGzyLuAXe/V6K/Y4NRKbdsNqqqJudB5REVs/BM+k5Gs8pgjT1CSIxj2Qfplg14mXLoeWmsRfviZ2a6Xd4Ku5qIXyn1PhiybitIgR1Ci8Nio5bv9gBbhhiVE98WL49JefWj3D3vZD2UY0hcU2tAVOV6wJyzLmWJwjiSIXDAlg8GEABNcGyyX0SMh0Y8sZd/gkRj6iqKz22SPCIU9b5lmylVeeH196n1l0i1bi2Xb3y7rVXP8dUx5Zty6OvQ5hGgAbiAOCqYGBsR9A9fzEBuEoYgKe+ZG3HxVUgJ7IDnmhzWHYDfOoYhKAYi9b3IhrliCWU0sPw/BY0JPZR6koP+ZMSAl/I9lBjLvBW7jHnpx7tzWGYisDKBywRwnxybn3nFaAc50SxsOSQwKgQCd+DdqynTsa1e6keMC0nYl9/Xy/qhxyr/EzMr2nA3lse+zRF8HtJveoTsHWE1Dd0wmsUODKnAgUXcnRqaZKA61gEtjvjngUZyeB4scEM6/2k0CukDyVsunXBulxmXbdLnyLGBmi2oQBGlSSbEJ+sziZY6lzIyFsfwaGYCdRulcIkGx9XjvOcrlLo8b2oeMTWGgCMEPmJdioILnxKs7ui+M1BxqlY3ccjgtIGVwqtez9yyuF5srDYUfgSjR5nQMB77NwKG4NcjtM5Ib1rajG5WmKYspRfBpB05N25PHOM+a3FBk0vjTZKdd5716VJE8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB6144.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(4143699003)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NlJBVnhjakRqdVZJK1FDeTFVcDFzL0UxQnhhU3BTRUZBYW1XcDdNcWdpMXR3?=
 =?utf-8?B?L3NlMytNWVluNkdoa2FERnMxTlNIZ3FVTnU4QlF6c24vQzVhV3psaU9iV0x5?=
 =?utf-8?B?Zi9PREVDdm9TbXVEY25pd2h1STFlbWZyeUtqTUwzeTgyWHR5blNaWUxqckdo?=
 =?utf-8?B?QlZ0UTBidEc2NzdMbXJhaHBTK0k1d2pBVFpHSUpMdXlkVWZQQXZoSmVGek1Y?=
 =?utf-8?B?a2kzZUFoOGdJWTFLd0p1Y1l2MldPMm5zT1JkcnBqWmVUc3pQemtCalBDc09P?=
 =?utf-8?B?UW1RQW9zVkVDR204cTRTMk5ONXFwWDBMUWRNK0RCbEo5SmVKMlhGWEhkRkRW?=
 =?utf-8?B?NHQ4UnhFNThzblpoZitDNndYbWZTNmd0ek12YWZBbVREUnBKT1lmR3AvU04w?=
 =?utf-8?B?WnNIV2tNd3QxeFJpY01FOEhVOFhjVDZ4c21PWmxQcmZRTWFHcUlYMDQ3cVlh?=
 =?utf-8?B?N1I2YTFITWI0ZmhtSjZNWUxPUUlIRmQvWmNqazcwNTNmdng3NDNsb2xzS0dS?=
 =?utf-8?B?UmRJQmJSbTZCWDJkblJqVnpWV3ZrVXI5cUxJTDgwbWJ4cVI1ZGlEWlZad0pL?=
 =?utf-8?B?QlRxVW45RENIZ3Y4a05FRXZhL3p1UUJlRUNMbWR2Smw2bW5mTDZ1UXhEbnI1?=
 =?utf-8?B?bm1ZaDFuVlpSalhUMjlrVDU4di9IQUw5Q0tFOUxldDZtNTkzOFIwbXR3QVFi?=
 =?utf-8?B?Y0pBSUduY2ZNUTNCTzhGb0tyKzgyOVp6VG02ZGRvdXUrWThON05rMzBQa01Z?=
 =?utf-8?B?M3NvYWx4cE1CSXhVR1lQMXYrNWZBSzFzS1A5VlZ6MzlMU2ZUdnlnSnBDVjVJ?=
 =?utf-8?B?RS9DZTRVVzNwMzdSeXdmV2hwby8wL3JkU25tQ2hjL0E4aFZvdThmcjF5TkF4?=
 =?utf-8?B?R2FGVkoyWW9ETGZpaFNQSVFveVR5V1JCKzZpN01rcXRhNnBON0NQcHgrdmx0?=
 =?utf-8?B?V3RUU0xwbytiRUtLY1c2cFNIM0F3TkpQQS9EcEFXc0xBNWdhTkNUZm9YdENn?=
 =?utf-8?B?T0xTL0ZjaHlFOWdrRk15YXhsekQ0N2NiT1BHSytVOXJtS3VFc1QxREQwSisv?=
 =?utf-8?B?cStzTFJVK3ZEYVViRm93a2ZyVWJ3dEpvOVhSOURXVTFGNnZwTTlrM0w1c0Jt?=
 =?utf-8?B?VTYvbWdjakFHcHAyUFFuTlkrUDdyQWg4S2FsZm53b3U5WUp6N1YxNW9sNWhD?=
 =?utf-8?B?OFVnQTBuelhIK1E5N05vSlhFMXBPY01OYVVZakU0Ymw3NzlnRTBjMUlBODV5?=
 =?utf-8?B?ajRpSDVVVmlwRjhEb1JrU0piUlE5UU1oeW5jb0ZmeFowbmlrMHI3aXJuaHFF?=
 =?utf-8?B?WHdiMHFRaGwvdWtjR09CQ25Ea2MxT1RIdkNXcjZpd2w1aTROQmxHa0c2aEJX?=
 =?utf-8?B?YlY3MlNhbkJaWko2eDdLNXVYT01jdVBRYnVDTEJSSTQwUXVoWVZjUGpSdG5U?=
 =?utf-8?B?cnRJZ1ZybFZMOVpDUVphRlBta25mYnYwdUpuOXZvSkI4MmxCdTI0VklIV21p?=
 =?utf-8?B?TTJEdExGaUN0SDhRTnlXTEZ6bzhldUpLR2ducEVsOWNqdkhxU0c2cTdPNFVj?=
 =?utf-8?B?dTZROFdWeE5hQUVvd3BYclRHTFhhNkhGRnNDaXRYSFV0cVIzbUF6UkhacDRQ?=
 =?utf-8?B?S25hTytYNnlnbXJqNWk2K1ZHdEZIdnh3RTJySWJ5ZHZTWnFvd3crQjd6R29v?=
 =?utf-8?B?VWpRUG1PWkZYYktpNjEwVEhGYjBtZHJOYVVzUWIrU1A1TXJYTUlKbUd2Z1Rm?=
 =?utf-8?B?Wms0a0pjUEp4Qlg2ODVKdHZDbVFNTy9uOWRIK0hTb3BUZWZnU2FiWDRDZGsx?=
 =?utf-8?B?TzErL2plVk9zd1dGSjRTVFNXQnlDVlBnYXh2ZldQbXoxTWt4QVVqUi9nTGFx?=
 =?utf-8?B?VzdtK2JGVlBKd0FiOTh2b2k5UG5hb1dFR3lyTmNneDN0c2crbmJ6Y0lOOUlR?=
 =?utf-8?B?WldoeVBqUXIrS0hLUStFUTdXMWJmb3hFcDhSQU9LWE5IekY0T0d6RzdQV2hv?=
 =?utf-8?B?cG01NjNLRHNmaGVHSHNhRENQT1paT2taenZYTXdRWEZnOStRWDEwdlk1ZDkr?=
 =?utf-8?B?RklpbEtnY0RvcDBjQUhLZkxKZjFZSnIra1BtV3Nna0FqRGZEa0VNOVlsYXFq?=
 =?utf-8?B?K2orSXRoVGZvcHAvTENDTnE2Y3ZKYTIyTzRDR0JqU0paN0JSZkFZeFQ2TjZ2?=
 =?utf-8?B?UDF6dlloVTBhUExRRnJjSVZqRktwNUNDRCtZZVFtSEhqY3JOVjRwTnR3UFZk?=
 =?utf-8?B?dmdGbEhTT1ozUVhISUFoMVYyNW9ZRk8xbjRMNDVRaURwbk5YOEZneDRKV2ZM?=
 =?utf-8?Q?zgiETMvF49+3bORCTq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <247D1DEDB9C76D4AB0C87C6925ED06D5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: hunenet.nl
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB6144.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f25bb18-6d2c-4d8a-fa7d-08dee24024fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2026 07:10:25.9010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 887aa16f-e08f-4cfb-bc70-8f3f25a72a41
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5+loFBULedNoL+OBMK2P27bXhxQ/ksAN4WDWRIbN6SsiFTVIgNdyyrUb2Y+Zbypf//ca1IeALGGhzWwpBxw4Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6836

T24gNy8xNS8yNiA3OjI3IEFNLCBBYmQtQWxyaG1hbiBNYXNhbGtoaSB3cm90ZToNCj4+IEluIG90
aGVyIHdvcmRzLCB0aGUgZmlyc3Qgc3VjY2Vzc2Z1bGx5IHJlY292ZXJlZCByZWFkIHJlcXVlc3Qg
Y291bGQNCj4+IGF1dG9tYXRpY2FsbHkgYmVjb21lIGEgcmVwYWlyIG9wcG9ydHVuaXR5LiBUaGUg
cmVwYWlyIGNvdWxkIGV2ZW4gYmUNCj4+IHNjaGVkdWxlZCBhc3luY2hyb25vdXNseSwgc28gdGhl
IHN1Y2Nlc3NmdWwgcmVhZCBpcyByZXR1cm5lZCBpbW1lZGlhdGVseQ0KPj4gd2hpbGUgdGhlIHJl
d3JpdGUgaXMgcGVyZm9ybWVkIGluIHRoZSBiYWNrZ3JvdW5kLiBVbmxpa2UgYSBwZXJpb2RpYw0K
Pj4gcmVzeW5jLCB0aGlzIHJlcGFpciB3b3VsZCBiZSBkcml2ZW4gYnkgYW4gYWN0dWFsIHJlYWQg
ZmFpbHVyZSwgbWFraW5nIGl0DQo+PiB0YXJnZXRlZCByYXRoZXIgdGhhbiByZXdyaXRpbmcgdGhl
IGVudGlyZSBtaXJyb3IuDQo+Pg0KPiBZZXMsIG1kIGhhcyBoYWQgdGhpcyBmb3IgYSBsb25nIHRp
bWUuIExvb2sgYXQgZml4X3JlYWRfZXJyb3IoKSBpbg0KPiByYWlkMS5jLiBJdCBpcyBjYWxsZWQg
ZnJvbSBoYW5kbGVfcmVhZF9lcnJvcigpIG9uIGFueSBmYWlsZWQgcmVhZC4gSXQNCj4gcmVhZHMg
ZnJvbSBhIGhlYWx0aHkgbWlycm9yIGFuZCByZXdyaXRlcyB0aGUgYmFkIHJlZ2lvbiBvbiB0aGUg
ZmFpbGluZw0KPiBkZXZpY2UsIGdpdmluZyB0aGUgZHJpdmUgYSBjaGFuY2UgdG8gcmV3cml0ZSBv
ciByZW1hcCB0aGUgc2VjdG9yLiBJZiB0aGUNCj4gcmV3cml0ZSBmYWlscywgaXQgcmVjb3JkcyBh
IGJhZCBibG9jay4gbWQgZG9lcyB0aGlzIHN5bmNocm9ub3VzbHkgdW5kZXINCj4gYSBmcm96ZW4g
YXJyYXksIHNvIGl0IGlzIG5vdCBhIG1pc3NpbmcgZmVhdHVyZS4NCj4gDQo+IFRoZSBsaWtlbHkg
cmVhc29uIHlvdSBkaWRuJ3Qgc2VlIGl0IGlzIHRoYXQgeW91ciBhcnJheSB3YXMgYWxyZWFkeQ0K
PiBkZWdyYWRlZCwgc28gdGhlcmUgd2FzIG5vIGhlYWx0aHkgaW4tYXJyYXkgY29weSBmb3IgZml4
X3JlYWRfZXJyb3IoKSB0bw0KPiByZWNvdmVyIGZyb20uIEluIHlvdXIgY2FzZSwgeW91IHdlcmUg
bGlrZWx5IGFibGUgdG8gcmV0cmlldmUgdGhlIGRhdGENCj4gZHVlIHRvIGJ0cmZzIGxldmVsIHJl
ZHVuZGFuY3ksIGFuZCBtZCBjYW4ndCByZXBhaXIgYWNyb3NzIGFycmF5cy4NCj4gDQo+PiBXaXRo
IHRvZGF5J3MgMTjigJMyNCBUQiBIRERzIGFuZCBiYWNrdXAvYXJjaGl2ZSB3b3JrbG9hZHMsIHdo
ZXJlIGRhdGEgbWF5DQo+PiByZW1haW4gdW5jaGFuZ2VkIGZvciB5ZWFycywgbGF0ZW50IG1lZGlh
IGRlZ3JhZGF0aW9uIHNlZW1zIGluY3JlYXNpbmdseQ0KPj4gcmVsZXZhbnQuIEEgc3VjY2Vzc2Z1
bCByZWFkIGZyb20gdGhlIGFsdGVybmF0ZSBtaXJyb3IgbWF5IGJlIG9uZSBvZiB0aGUNCj4+IGxh
c3Qgb3Bwb3J0dW5pdGllcyB0byByZWZyZXNoIHN1Y2ggYSBzZWN0b3IgYmVmb3JlIGl0IGJlY29t
ZXMNCj4+IHBlcm1hbmVudGx5IHVucmVhZGFibGUuDQo+Pg0KPiBBbmQgQ2hlY2svUmVwYWlyIGlz
IHRoZSByaWdodCBkZWZlbnNlIGZvciBjb2xkIGFyY2hpdmFsIGRhdGEgb24gbGFyZ2UNCj4gZHJp
dmVzLg0KDQpUaGFuayB5b3UuIGZpeF9yZWFkX2Vycm9yKCkgd2FzIGV4YWN0bHkgdGhlIHBpZWNl
IEkgd2FzIGxvb2tpbmcgZm9yLiBJIA0KaGFkIG1pc3NlZCB0aGF0IG1kIGFscmVhZHkgcGVyZm9y
bXMgcmVhZCByZXBhaXIgd2hlbiBhbm90aGVyIGhlYWx0aHkgDQptaXJyb3IgaXMgYXZhaWxhYmxl
Lg0KDQpNeSBzaXR1YXRpb24gd2FzIGluZGVlZCBkaWZmZXJlbnQgYmVjYXVzZSB0aGUgYXJyYXkg
aGFkIGFscmVhZHkgbG9zdCBvbmUgDQptZW1iZXIsIHNvIHRoZSBzdWNjZXNzZnVsIHJlYWQgb3Jp
Z2luYXRlZCBmcm9tIEJ0cmZzIHJlZHVuZGFuY3kgYWNyb3NzIA0KYW5vdGhlciBtZCBSQUlEMSBy
YXRoZXIgdGhhbiBmcm9tIHRoZSBzdXJ2aXZpbmcgbWQgbWlycm9yLg0KDQpPbmUgcXVlc3Rpb24g
cmVtYWlucywgdGhvdWdoLiBjaGVjay9yZXBhaXIgcGVyaW9kaWNhbGx5IHJlYWRzIGFsbCANCnNl
Y3RvcnMsIGJ1dCBhcyBmYXIgYXMgSSB1bmRlcnN0YW5kIGl0LCBzdWNjZXNzZnVsbHkgcmVhZCBz
ZWN0b3JzIGFyZSANCm5vdCByZXdyaXR0ZW4uIEZyb20gYSBtZWRpYSBhZ2luZyBwZXJzcGVjdGl2
ZSB0aGlzIGlzIGEgZGlmZmVyZW50IA0KcHJvYmxlbSB0aGFuIHJlY292ZXJpbmcgZnJvbSBhIHJl
YWQgZXJyb3IuIEhhdmUgdGhlcmUgZXZlciBiZWVuIA0KZGlzY3Vzc2lvbnMgYWJvdXQgYSB0cnVl
IG1lZGlhIHJlZnJlc2ggcGFzcyB0aGF0IHJld3JpdGVzIHN1Y2Nlc3NmdWxseSANCnJlYWQgc2Vj
dG9ycyB0byByZWZyZXNoIGxvbmctbGl2ZWQgbWFnbmV0aWMgcmVjb3JkaW5ncz8NCg0KQmVzdCBy
ZWdhcmRzLA0KRGlvbiBLYW50DQo=
