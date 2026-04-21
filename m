Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011058.outbound.protection.outlook.com [52.101.62.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304523A641E
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 22:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776810615; cv=fail; b=sksDta5yvYtm8K856eL90Vc9DRgNqOLdjMfjdjeLZ8XrtJMECgpBx6fOT63MYB1GQ3T0pBCw4/Y3KaC9yYzE4u7xXRqToZSlfOG34/xj9EeCXtL9+MX3wWoo9CIvhQaZtk/O4TYwLQPTMh0FguUZmhxuR6uGmhJi2yXWVKSeAXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776810615; c=relaxed/simple;
	bh=LeiCh7z87bznPGHPxXjPZFYOeMcf0C5DmMV0OHiCHG8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OeEa5LimJs2Nzmdd3v+GoCnWsV/CTwgFPCdXKFJ4d85NxlPgbURtuFMf/48uCGPd3sz8p/XtEf2kcIafQ9CGIEved2XaX0epcod1JHK19OwnB0tZPVBObokdP9n9YAtDKmHqRDArSfyBZhlsCn47gFoBoZlMh+eSEQwcOKxz9dc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gNQ4oMLN; arc=fail smtp.client-ip=52.101.62.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gNQ4oMLN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hpmjl3SPYCmNkcg6VRJEy+zO45ikae47bl/hX5vwWGg9j8Xkzq1EGYNYxjbGaajt3RMFvr5CRZzlI1xuL/NxMzIACBu+ZAO0H23A7q1z7MLT0LNKQXB5JbF7FGq2ZYb3gmEyntRMi+KmHH0pRFBIArj00x3tW314CkuiuUJRu0bhtlZogOb5vpQMnnBmKcJM54AkMI8ti82KqDK2EqrMFPF3VTpQrhKShSn5BzwT158GnBawQahmnnkcmyxUpaRDVi2IboPbnuEYD411dLomGAseOpEqWYKDsL9QD9n/12lIU9ra0MlwMmV0XucSO8ajWJ79ljtSt0LCVZ512MxeSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeiCh7z87bznPGHPxXjPZFYOeMcf0C5DmMV0OHiCHG8=;
 b=ossJ7d/FM8XKZWMMyfeD0zw5pvYWeMoYeSF7raue9wRRA9hgTF18CG/arArQvgSspqsSuHbOaZUZpJsjjuF3RHQSEbI86Enfu1I6szb6Ea23HkM8QFk/MSqZFXbomJP4AJr82+1aVdzROGZSYoyVhfNZD5ipD5g/3j+SbTwOp0dbsC8e8Y82Nv5ouWF0WkNvSj23aybVkGDB1a/YZq9n6wxyTKOlMylFBZk9j7ONXqvhAF18n+D4tIp4NykOIG3sAePLaKDYV/H8Hudq0xeGVgnQXfQACuxcNFJxFzAuSt35cf2AjLoE6ZyVqxfNGDga9eZ/v7J3M055vB1EHaRchg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeiCh7z87bznPGHPxXjPZFYOeMcf0C5DmMV0OHiCHG8=;
 b=gNQ4oMLNl0MxiXUoNS3CZGaLdvDb5KsELuBOPerG5mLNDsHN5Us3Fjy3trMfRw0cZ3vlV1H5SHmcdbJ8e5MhKJhwywwerxpNk421R8aTeR70vRl3iFKco91U4TiHA7472QCJu+/iDST7xC3sr5aM3ox+cFPU5Fwlte8V/roNd8G2s4eRS2wTdt7vMrPqE9PozoM0R6sYrsxgmJoZB6lHQ2RQdQBk+HoCzU0YSSbWj7ZGq0ck62jonssAjFmwB0qNqbiC/cqkU2TTslbLAxcX2lFXyuh2WNRRQxOBZvETwJ5FIvI5II89+gN4lun6ioq9RlyZO6WwEjyKPd7fWvSvEg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.15; Tue, 21 Apr
 2026 22:30:08 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008%6]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 22:30:07 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Chaitanya Kulkarni
	<chaitanyak@nvidia.com>
CC: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com"
	<yukuai@fnnas.com>, "linan122@huawei.com" <linan122@huawei.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Kiran
 Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH V3 1/3] block: clear BLK_FEAT_PCI_P2PDMA in
 blk_stack_limits() for non-supporting devices
Thread-Topic: [PATCH V3 1/3] block: clear BLK_FEAT_PCI_P2PDMA in
 blk_stack_limits() for non-supporting devices
Thread-Index: AQHczefMTO+D9Nv0DUKPwJ7l20+cVrXjCUuAgAcXtYA=
Date: Tue, 21 Apr 2026 22:30:07 +0000
Message-ID: <a2a14d08-cb31-453a-9ddd-71f7dd4d6992@nvidia.com>
References: <20260416212633.72650-1-kch@nvidia.com>
 <20260416212633.72650-2-kch@nvidia.com>
 <CGME20260417101607epcas5p204981188700b5f9e3135d80ed7f16eb1@epcas5p2.samsung.com>
 <20260417101127.uku7q65akj6gwwh4@green245.gost>
In-Reply-To: <20260417101127.uku7q65akj6gwwh4@green245.gost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DS7PR12MB6214:EE_
x-ms-office365-filtering-correlation-id: 64ef3016-8a42-44ba-f1f1-08de9ff58ad8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|18002099003|38070700021|22082099003|56012099003;
x-microsoft-antispam-message-info:
 0MpcckuoSUkYgrZ1Rl3vRPQw98lC4bkqE+Pbji2KVSBuMpTxCqGHohNdZmI6yeb4Q6nXtKY+wYge/n6MYc05GmmzYoyZOVbX60kN8SvZkye+LNjQlVvbrZIAlkkrebRKbXBKDT6dVmizNZUBjeQsUjt/MZjnQy3wvCqMMCUNrGt4oHbCI01nnfkjYGx49thpAl5mmlVvMFahvKrgzxyfdPdWxJAaAj7CrKD50gdbgfJbw7Qcmck3Chfn5uT6DrlvcSc88je/iLkaUoDegYioKdkQhtkxLIQ658JmsbkyGB0/IaIMzowNyZE/ksqBgYNh/cwR+EJjheP77Zglq4RNdhVwKVIgQBFSYd2+X0c5ODdEb+IOYrERlB1s/Zu/ghrFV4WenKWw8yNFIGifMV5cBLwO1aOgleU98DlupX42iWJgjFnMwvoCb2I8vDi4GpilkZu/PDNmnYXU1cw88eXO+qtyfQEY1cA4rSG6AYYMeGX1A2yWcY+uBG/fEVqx9iPenMLOM1mFwN2kApC4/T0pIDZEMFImwYzXh1TAbyczGL8HK4w1HXZmMSATQFhWxqDWktV6xO4gZSTqzoc22S40LrO10/gYqD4IvZPEgHPdYNYrxAEPgPUPABilgOeZ7upniLYOLpyOg1W7gxRZlft7RW9JoQVlSkhdlQUXvqiG/Mi3HhnOdzWWOcdDD86gmOZNawURwhHynZINu0sTC5cREFEfB4dTj+4GgXno7vajjD0bFf6GGyf0gl2HEDuexq3FV7ydJuP47JJrFnZMgCiZHMTv78JoPkvbTtD4dMsOB28=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(18002099003)(38070700021)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZWZZMkVqdkNSajE1dzFRTmVGaUVQa2padHNtNkRDazh4MGs0NHVxZ2I2RVhB?=
 =?utf-8?B?UmdrOUYvUFRLbG03TXQxanpwYk1xSEpQQVAxTVY4T3U1L3JFdU40bzVGUXdS?=
 =?utf-8?B?WFBKZnZVNGZ1WnRzNFBRRWxwcjB3cTlEcFN6cXZIdG42WWprbVh4eDA4QmlW?=
 =?utf-8?B?eU9PSjlvb09QT3ZvUVJVckx5N2t0WVNaR3NHZ2UzRlNraWxhTElBVWdHclI1?=
 =?utf-8?B?Qm10RXd1Tks5eGFEVTIyMTBGSVRWbVByYVJNZ3MwZ1NQUHA0VEtMdHZ1dEpW?=
 =?utf-8?B?ckE0L0M3NzVPQlBMZEtGdXhWNlNYNzltVjdmS3RuK2U3VDlsU0RTODJGQTE0?=
 =?utf-8?B?V2JaM3lWSnNic2k4VXc1TUJMT1FtY3RTd3RpVDJVRHJsM3h4aks3cG5kS0cw?=
 =?utf-8?B?K1dlR01yMTQ1NmtwZHp1OWUyWUUveXd3TG1ISzdrVnAwK213RTRleEw3RkIy?=
 =?utf-8?B?UzlSU0U2aVZHOUxoWnlVdW0zN2w1WFdjRTVhZTZuN0lKUVdISzhoYVpsQWdM?=
 =?utf-8?B?VmF3MEFyN3lCV2lCcjRtWEVnTFZ3Vm9nQ21QSWthZGdTZlNrOVhxSG5wTU52?=
 =?utf-8?B?VTRmU3MySXp5aXlQRUZGV1hFWDZwRUlqQ0IvQW0ramJTSU1QbDJZQlV1QU1Z?=
 =?utf-8?B?UHdRbW9OTkhmeHA3UkJ5VlB6SCs1eTAwY2cySzdMN3JML1NTL3Q5aXdKZFd0?=
 =?utf-8?B?MzVaWFBJMFlueDMxK1VmdnFLUi9FL1BxMnNaaHQyVUlIa3pFSERRQWpYSzNa?=
 =?utf-8?B?YVVHK3FlZ3ZyVS9CM1hIOWhiQkp5WDZDeGRhQlhZQXVmUWh0aldYZ0tpTzNk?=
 =?utf-8?B?QTJqb0NOcUFhUmlDdU5rd3EzWTFTdFNENjdMckx6cGdNUGpKdW9Mc2lzcVA4?=
 =?utf-8?B?cGFuSTBUOVlxcDZPR2VDcjhsMmJ6ZUxBcHJOZnMrUUNrWG8rbU90OWV6SU04?=
 =?utf-8?B?R0pBU3N2c2NLUk9TblZsMTVtRzRQYm9CRHB4YWo4eWg4T0ZZTVJyM0l5TjlB?=
 =?utf-8?B?S0gyb0ZFZUFadURMbXJ3RGFMVFl1aEI2MFZ3eVZmd2Y5a1RDbHNKbUNCdW5u?=
 =?utf-8?B?Vzl1OHBaSkpTUVY5NFZmNHVEdGE1dVdFZjBQL0t4aTRUK3g1dlFrYXJzNjB4?=
 =?utf-8?B?cmtPRS9EbWdlekxnV2s1Yy9OTUdteHVRMWpXdi9NQ0tRUWxEdVhXSEZadGEw?=
 =?utf-8?B?K3lnZElBRGFoK2swU3dNeHJwRWhBR3pnZmRtSDF1bTE4ZjVVWmpkM1dodlRh?=
 =?utf-8?B?VjZUK2czRUpnTlBPamt3ZDdBV2FvTFBOZlhwYjN3cDZERTI3b09yNjZkQk5M?=
 =?utf-8?B?dnVPQ0crU1c0Nkx0UVA2SlNmWUR1U09zckN1OWlLb0tCNVBTRGFTQjArVEtS?=
 =?utf-8?B?Z3FVN0lvZE0rZ0JMTzdNVFZjSWlFQUZjY3lBZkIra2hLcUhJaU5uSG9kUFdz?=
 =?utf-8?B?elpWbTZJSWtFVWE1emo3dmZtOEVRSG93RHg2dURNc3UvUUViVlB5bzlBY2lK?=
 =?utf-8?B?aHhDWlJLc3VwY0t6QS9SNFgxdUxybzJlOUdVREFnamNuNFoyV0JwYUdjOE95?=
 =?utf-8?B?M0h5eDZCSVE4MjVQUkZoS1c2QmVVRm90UU1zS3NqU1dJWjVLU3Z1WkMvcEEx?=
 =?utf-8?B?WTVBc3NQRnpuenB6WDVqUUNVQ04zeWhQUkNoSzc4eVdSd0dpMUl1NmRyRk9D?=
 =?utf-8?B?NEkvVk5xeDNGZ1o3UUE5UlBMRkhaSCt6Z1BlNy92SFNRajlmSFZ5aDQ5ZjBX?=
 =?utf-8?B?cjhjdnNmRlpEekpOMzg4clErbFNOY2NZZnM4dEJ3U0NSVi9JeWVYYWNqTXRG?=
 =?utf-8?B?cDdralpybnU2RHBmbDJzc0g5UDMwYUorOE14ZjdZUXBCVmxjdmg1ZDVXY3hK?=
 =?utf-8?B?djlqTDVNT2lWRkpSdmNVT3hlaXJpeWN6b0g4eHZEYXpyRDZkcXFuSnVxRFhE?=
 =?utf-8?B?dDZJNXhUSHM5QlRSK2E3ZUVPMThjdG53d0pndGQwcThPLzZ3blQ2NXV3dlpZ?=
 =?utf-8?B?dHpJRzJvT1hsNXJWQzNvNURHYVhPWkRaaXBRNlBkM0R2ekFXMlRWakpqWkZ5?=
 =?utf-8?B?Q2ZVandBb3R2dHV5VzJTU3ZrcVVOYTc5SThlUFB0cjRXWG56Nk9CWHV3cDBU?=
 =?utf-8?B?bVpZYm1CWHhla2pzQVJ6dFQ1SVRYcEQ1ZFBLZitEcWJkQTJDOWcwTmtSQ1lC?=
 =?utf-8?B?OXR3Zi9Pd0dWcVY3NW0zVmN1c1NsYjc3ajhzMythdWxPZWFleWU2YU80c3pt?=
 =?utf-8?B?bWhWS3QrU3FWTVpNb1BKaUsrQXl1MENiTHlOUUZGODJrb3VZVWF6cDJVcHB2?=
 =?utf-8?B?YmowbTFObkZZdGNJajNFN1ZhNElsQWRvb2hCenY2QTNJSnRhYzQ5QXhVZWM3?=
 =?utf-8?Q?pc3wkNMmJ3mAiFw+ikdJQ9bUFdyJLSeaWrBaN21XhKBPI?=
x-ms-exchange-antispam-messagedata-1: FWnTIop+tCbmMQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C58ABA81752F7744818783E1A5646F0C@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ef3016-8a42-44ba-f1f1-08de9ff58ad8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2026 22:30:07.8255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XkWFOtbJJegn8T4O5J81LHZivmFWICREBsNsnKqUhsNgIqCZQpDF/6lcX+Y8KD+zEPOZEytgcKebXWhus4sScQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6214

T24gNC8xNy8yNiAwMzoxMSwgTml0ZXNoIFNoZXR0eSB3cm90ZToNCj4gT24gMTYvMDQvMjYgMDI6
MjZQTSwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOg0KPj4gQkxLX0ZFQVRfTk9XQUlUIGFuZCBC
TEtfRkVBVF9QT0xMIGFyZSBjbGVhcmVkIGluIGJsa19zdGFja19saW1pdHMoKQ0KPj4gd2hlbiBh
biB1bmRlcmx5aW5nIGRldmljZSBkb2VzIG5vdCBzdXBwb3J0IHRoZW0uwqAgQXBwbHkgdGhlIHNh
bWUNCj4+IHRyZWF0bWVudCB0byBCTEtfRkVBVF9QQ0lfUDJQRE1BOiBzdGFja2luZyBkcml2ZXJz
IHNldCBpdA0KPj4gdW5jb25kaXRpb25hbGx5IGFuZCByZWx5IG9uIHRoZSBjb3JlIHRvIGNsZWFy
IGl0IHdoZW5ldmVyIGENCj4+IG5vbi1zdXBwb3J0aW5nIG1lbWJlciBkZXZpY2UgaXMgc3RhY2tl
ZC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEu
Y29tPg0KPj4gLS0tDQo+PiBibG9jay9ibGstc2V0dGluZ3MuYyB8IDIgKysNCj4+IDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLXNl
dHRpbmdzLmMgYi9ibG9jay9ibGstc2V0dGluZ3MuYw0KPj4gaW5kZXggNzhjODM4MTdiOWQzLi44
Mjc0NjMxMjkwZGIgMTAwNjQ0DQo+PiAtLS0gYS9ibG9jay9ibGstc2V0dGluZ3MuYw0KPj4gKysr
IGIvYmxvY2svYmxrLXNldHRpbmdzLmMNCj4+IEBAIC03OTUsNiArNzk1LDggQEAgaW50IGJsa19z
dGFja19saW1pdHMoc3RydWN0IHF1ZXVlX2xpbWl0cyAqdCwgDQo+PiBzdHJ1Y3QgcXVldWVfbGlt
aXRzICpiLA0KPj4gwqDCoMKgwqDCoMKgwqAgdC0+ZmVhdHVyZXMgJj0gfkJMS19GRUFUX05PV0FJ
VDsNCj4+IMKgwqDCoMKgaWYgKCEoYi0+ZmVhdHVyZXMgJiBCTEtfRkVBVF9QT0xMKSkNCj4+IMKg
wqDCoMKgwqDCoMKgIHQtPmZlYXR1cmVzICY9IH5CTEtfRkVBVF9QT0xMOw0KPj4gK8KgwqDCoCBp
ZiAoIShiLT5mZWF0dXJlcyAmIEJMS19GRUFUX1BDSV9QMlBETUEpKQ0KPj4gK8KgwqDCoMKgwqDC
oMKgIHQtPmZlYXR1cmVzICY9IH5CTEtfRkVBVF9QQ0lfUDJQRE1BOw0KPj4NCj4+IMKgwqDCoMKg
dC0+ZmxhZ3MgfD0gKGItPmZsYWdzICYgQkxLX0ZMQUdfTUlTQUxJR05FRCk7DQo+IEkgdGhpbmsg
eW91IG5lZWQgYmVsb3cgcGF0Y2hbMV0gYXMgd2VsbCB0byB1bnNldCB0aGlzIGhlcmUuDQo+IEFs
c28gSSBmZWVsIGJldHRlciB0byBpbmNsdWRlIE1pa2UsTWlrdWxhcyBhbmQgZG0tZGV2ZWwgbWFp
bGluZyBsaXN0IA0KPiBhcyB3ZWxsLg0KPg0KDQpnZXRfbWFpbnRhaW5lcnMucGwgZGlkbid0IGxp
c3QgTWlrZS9NaWt1bGFzIGFuZCBkbS1kZXZlbC4NCg0KDQo+IFRoYW5rcywNCj4gTml0ZXNoDQo+
DQo+IFsxXQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS10YWJsZS5jIGIvZHJpdmVycy9t
ZC9kbS10YWJsZS5jDQo+IGluZGV4IGRjMmVmZjZiNzM5ZC4uMDQ0MmMxZjRjNjg2IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL21kL2RtLXRhYmxlLmMNCj4gKysrIGIvZHJpdmVycy9tZC9kbS10YWJs
ZS5jDQo+IEBAIC01OTAsNyArNTkwLDggQEAgaW50IGRtX3NwbGl0X2FyZ3MoaW50ICphcmdjLCBj
aGFyICoqKmFyZ3ZwLCBjaGFyIA0KPiAqaW5wdXQpDQo+IMKgc3RhdGljIHZvaWQgZG1fc2V0X3N0
YWNraW5nX2xpbWl0cyhzdHJ1Y3QgcXVldWVfbGltaXRzICpsaW1pdHMpDQo+IMKgew0KPiDCoMKg
wqDCoCBibGtfc2V0X3N0YWNraW5nX2xpbWl0cyhsaW1pdHMpOw0KPiAtwqDCoMKgIGxpbWl0cy0+
ZmVhdHVyZXMgfD0gQkxLX0ZFQVRfSU9fU1RBVCB8IEJMS19GRUFUX05PV0FJVCB8IA0KPiBCTEtf
RkVBVF9QT0xMOw0KPiArwqDCoMKgIGxpbWl0cy0+ZmVhdHVyZXMgfD0gQkxLX0ZFQVRfSU9fU1RB
VCB8IEJMS19GRUFUX05PV0FJVCB8IA0KPiBCTEtfRkVBVF9QT0xMIFwNCj4gK8KgwqDCoCBCTEtf
RkVBVF9QQ0lfUDJQRE1BOw0KPiDCoH0NCj4NCkRNIFAyUERNQSBzdXBwb3J0IG5lZWRzIGEgc2Vw
YXJhdGUgRE0gcGF0Y2ggc2VyaWVzIHdpdGggZXhwbGljaXQgdGFyZ2V0DQpjYXBhYmlsaXR5IHBs
dW1iaW5nIGFuZCBlbmFibGVtZW50IG9ubHkgZm9yIHZldHRlZCB0YXJnZXRzLg0KRW5hYmxpbmcg
aXQgYmxpbmRseSBmb3IgYWxsIHRoZSB0YXJnZXRzIG1heSBub3QgYmUgYWNjZXB0ZWQuDQoNClRo
aXMgc2VyaWVzIGlzIGxpbWl0ZWQgdG8gbWQgUkFJRDAvMS8xMCBhbmQgbmF0aXZlIE5WTWUgbXVs
dGlwYXRoLg0KDQpJ4oCZbGwgc2VuZCBhbiBpbmNyZW1lbnRhbCBETSBzZXJpZXMgc2VwYXJhdGVs
eSBhbmQgd2lsbCBDQyB0aGUgRE0NCm1haW50YWluZXJzIGFuZCBkbS1kZXZlbCwgdGhhbmtzIGZv
ciBsb29raW5nIGludG8gaXQuDQoNCi1jaw0KDQoNCg==
