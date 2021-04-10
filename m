Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0600DC433ED
	for <linux-raid@archiver.kernel.org>; Sat, 10 Apr 2021 21:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE42161105
	for <linux-raid@archiver.kernel.org>; Sat, 10 Apr 2021 21:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbhDJVga (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Apr 2021 17:36:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:35442 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhDJVg3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Apr 2021 17:36:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13ALSE9P012285;
        Sat, 10 Apr 2021 21:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ozn3F7cNES+nOgUc5CwfnUEC/pm0II+yIklzgNCbeJA=;
 b=to/cLIZu5a0F7pU5VJgY+qdsM1zhGT5C4AMhMAGfyxzUKm3JDvJAVIClB0JhpaioW3bL
 P0eiG4dIfBF4HZ2+gAv1oPLMXieVzlTK+lOQVyhimiBJdRKkPtA54uRKqF9e459D5nqv
 N0JjjAm0qXoDZ7viG+Y7A7dlRoNncQttQr29GGOfkRofWctOefmIrWq+TjaiPCV00Sri
 KCkA7xV0C3nxMW3wtXtTboDkpqop6RdkcBcY2mBzXB26hTeByIt8Hr3yEkXK1k/PkyXV
 6A65x+AGJp6jMJ+sNv4CyBbz3W1qmnPBWjdmYea01vtQEOilALUk1TCD9nkpR/1CPizi YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hb8yes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 21:35:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13ALPVtM114059;
        Sat, 10 Apr 2021 21:35:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3020.oracle.com with ESMTP id 37u3u1sh0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 21:35:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaMPOSOK6nMsMHZP9LZXBo+v6mmwlWIvawyaj/KLcMGnzdkwATFHOvx01rsbtAAQkl49igjZz9nnYw1X7fcwYRxaaRjDgAC+oeZJRujaza7uhTPOKECe0GYiZl28eMN2k5T+aLEVc4XULsiWReh/svczMNgF9hjUXug3DMPeD0E8YPubpGvzBjEF2WTpMsnP1DKyQV9mJnQzW7Y5N4bMF+VDeBF9yVG7jHXDN4EF52cwNohjwIw+J3eJpHRaZsUKp7Bcx1XSanHVx/fC5iEIsZQTYKGHhGBjpROvLpQwncQwOmJsS+BBT0GpczceF4rbma7uIWZ2IvTEe7u2hj5Nxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ozn3F7cNES+nOgUc5CwfnUEC/pm0II+yIklzgNCbeJA=;
 b=EderwXI5D4A+NZn2ERiv46c02c5mvWY+YwLpTDRNqompvU8s22EYPCQ3BrCwSEwxsxGrcX/ioCRipGfaQpY4wo/zVbHtW1wjLWOQoBMTElTToC69DlTrvlFLm+1yZWow/WSlmsfSnouhWySQ2KCP2jt5r6u768onjlV+MV+BHRuGP1IRZ99z2fo3Ax+y9DjUCn7gYJnlCpDqt8hJrQl1LSBvMVmsgTnGUJgsya1tsmFpMCfoFZmecQZ/p+Vd6E8CiIwgDqoW7FBlNbxIzySLLjheRTGV5rRdSzdG0/j+Hno5YaScFBrJb9FPgcradxDPcw7Bi4jJnVUr0qhxYZfebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ozn3F7cNES+nOgUc5CwfnUEC/pm0II+yIklzgNCbeJA=;
 b=rRo4XdDr5I5JQnIqrtNZiaQtdyPeTkF14pa8PDGCPNolSWQCUyFRBgi07cgMSyBmudbtFMBwkpW+out17vtSFV3tdtmaHpk42XPzSo3dbPYgfpmzcrFnxV2FvHkWiH972ZndujoHcsBc/T9f9kAJAVbCa+aSpkXXa5+BHaw21T8=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1413.namprd10.prod.outlook.com (2603:10b6:903:27::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 21:35:52 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974%2]) with mapi id 15.20.4020.016; Sat, 10 Apr 2021
 21:35:52 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>
CC:     "lidong.zhong@suse.com" <lidong.zhong@suse.com>,
        "xni@redhat.com" <xni@redhat.com>,
        "colyli@suse.com" <colyli@suse.com>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: RE: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
Thread-Topic: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
Thread-Index: AQHXLL+jpqYxQ9QC0Uybi++B1tJz+6qt4qiAgABmX3A=
Date:   Sat, 10 Apr 2021 21:35:51 +0000
Message-ID: <CY4PR10MB20077F9F84680DC1C0CAE281FD729@CY4PR10MB2007.namprd10.prod.outlook.com>
References: <20210408213917.GA3986@oracle.com>
 <ba0f4827-83ae-b7e2-2230-5f4afca2538a@suse.com>
In-Reply-To: <ba0f4827-83ae-b7e2-2230-5f4afca2538a@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [73.217.118.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9b6c20c-4e11-4880-9f0a-08d8fc689d6c
x-ms-traffictypediagnostic: CY4PR10MB1413:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB1413D55654E07D12630AB2EDFD729@CY4PR10MB1413.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ylC8p+6BouWmVvXWTe7pgFfwE9iHk+BqylKZK5sTYUEPNeYHlRbzJqaMxT0HCacth65qGDBtdGbdFRyBAceLVvs7ClAq58zsFwu7c36WJhFh562XJDJgjvwEgJQShTbb398G+qbojNLR5bUP9BnBnN9xoxVgnmL0rm5bweoLP4fzzNnQ/PK0frzOGTjqlWvISK0EYWxkOg5iRyLz2sQHyEcts/oZrZivnR2OUmfj691nMEeRZAOfQWt351nbq68Nd4YfOyteX5fAzbiM6JrNgzsDkHR+jsTxcqKCqb6Rqb7onE+6IzEisvus+itrm6Gsh3EJjDGC2VeJni+TU8CNkrnbyAlbsqXWV1JIqsqLU1BSZX0MT6jgqU9MUvVISCpGfERNnfxG2nzGzOVV37Hw+OFoMa8RNf2nj4Uc7Mz14tD75zGCTyc3mZflWgx40WN/65iqsxvRsNpC8qWQe3YmmnYWncU93vuU4qavyMLqk0nmstyid/YMpIbeP6M37FhW6rdm6tTEzO3DwA8zlLbHpdnqtXfZRymY/QieVxkFBoOTsfOUw+5JdfcwMyizpK5tY4l3q2Yl6xKr5aiZPyg+SBf/cRSWvx5qYFQ3Y4f3Ct8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(39860400002)(346002)(376002)(33656002)(186003)(316002)(9686003)(26005)(107886003)(55016002)(44832011)(38100700002)(110136005)(71200400001)(54906003)(7696005)(8676002)(4326008)(5660300002)(86362001)(64756008)(66476007)(66446008)(52536014)(83380400001)(76116006)(478600001)(8936002)(6506007)(66556008)(66946007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OVg3Q0xnaEZVOTNNc0lxZi9PV0RmTVo4T093WE5wQnhCL3EwajA3Q3hYSm9j?=
 =?utf-8?B?RkxWd0grSG1lb2x0VnhKenNyTnNxWEFGTXpWc1RlS21MRmZGK2NZamlSSnUy?=
 =?utf-8?B?ZnFrdnZwMC9SL2VUVWdyQnRDWjRmaGVCSXNoY205d2xYL0o2Z1htQU5qaFJ1?=
 =?utf-8?B?YjhlMzQvL3lNS254UE5ZbkxseTl5QlpBL3Uya25FbHhxNHNsNER3aXU2aWt1?=
 =?utf-8?B?TUdjQWNGNDFWT3N0bFAvMUt2dS8vMUFhd2lkdkxMU1V1UlNpay9aWW40VmY1?=
 =?utf-8?B?VDNoeVpManZRYlcrU0paOWJZU0F5ZGg4SWVYY2taaHh6S0RjWHFYMzhCalUv?=
 =?utf-8?B?MWhLUVNtNTJhRXFHRG1oOGZJRi9ISWJtMmRPVUtuMnd6SUh4dXdkUllKWEJK?=
 =?utf-8?B?SGJSVE01Vk5oV0VpMUY3K1puT2RIVEY0S2ludEVYeUtTSEFmUDRVQjU3Q25x?=
 =?utf-8?B?SDRIcVhLZHJtWHJvUWZxcndjeXBETlFwaFg5eXIrRDBqWkQ0b1BReGIybjQr?=
 =?utf-8?B?d1hYbmptNWVuMVl2UkF2MFVSTzFCbzJiMVZYYlNHaXRiWG5SWDNITmhINGRQ?=
 =?utf-8?B?Wml2UDlsclkyQVdzUnRwVnU4UDZLUzgwblQwVDFieXlKOUlMUWYxdXNkbnV4?=
 =?utf-8?B?ZXdxK25mZVRqaTVQRnFTaFVubjdPVHR3bFZRTnVpaFV5WmtwZFZMQ3B4TmdB?=
 =?utf-8?B?NXdLekQyYlVSb1FWVnd6TkJmUS95SkF1L2F3WXdWMlBySlNmbGw1QzhYbUhU?=
 =?utf-8?B?b2krYzBud2tnMlNNR25xWCtDQm1zMjNDRzFFVGU2bnRQVjkxNnIzZng2dE1M?=
 =?utf-8?B?V3duMCt5djJndUF5bmRCcHNyZHdjQVZYQ2FYYXR1NzJwb0xQZi9DaWxLVXZx?=
 =?utf-8?B?REI4eVVtdlZWdnVJSEtmenhzeDQzd2JXbS93Q3g1eHp5SkpJTHB3YWpTa2Y4?=
 =?utf-8?B?ZVkvZVFXcnFickphZURaSURxTHFWZ1R2dkNpbW56YjJ3ZzZhODNUYW5MWDBx?=
 =?utf-8?B?dlBhL0IyOVRsUlVDRlJEQXpadlp4RkV5eDJCaEhrOSs4UEF5bVZSTEdYNU93?=
 =?utf-8?B?ek1sQk8vMFl0U2J2VDFyNklzZmFNaEoybVNuTndPMUx5dXNtdm1MM0QwTHMw?=
 =?utf-8?B?bDBUZUpmWWp2NUFUQVgxRVBVb3Z6Z1NOOFRPNmFtNngvSzh4bWFnY1dWcmRi?=
 =?utf-8?B?TVhMMkREVmpVeHJyTTdQT0VLTCtTSDZ2ZVAzZzRLQlF2blA1Y0F2RThvZVJ0?=
 =?utf-8?B?bXU4SmdlQm8xV0YwK2U2bTRKdEU5a2hZSFB3a1E2Mk5sUFE4TDE4V3M3cHg5?=
 =?utf-8?B?V3AreDVxU0lmZENCVFoxa3lPeUlLTm5DOE5pbnR5YUxqcUw0eis0a05xM21x?=
 =?utf-8?B?NW5XaW8xOUZlWjF5M0dvQnY5dGhVcmNEbDFBT3djU3ZuMHJDYzdSSFJwa3Bz?=
 =?utf-8?B?dndlanB5Nnl1Y2JkVlEvbVpxUFFXaVI5UnArU1lxUFpPYmhlZ3RxMGQrZmF0?=
 =?utf-8?B?anJEREJ6YW1scGg2MmtaNGxFM0Z2c2Y0alByczVwU05CcG4yNXRvSTNaU243?=
 =?utf-8?B?YXBwN280UlE1U1lzMVdzeDlhL2dLanF0dU1LNGltV0pGTW5LQ0UrREZiWGV3?=
 =?utf-8?B?amVGditqZEMzUGZLbTF4ay9IK3FoSTJsOUN2a1VjemZObkgrYVo5dkZRR2li?=
 =?utf-8?B?cUN3STgxeEpoMGRLaTFDMTF5SmYyNERyQ3V5NzRFVnBWR0RRcm03c0RwZWlu?=
 =?utf-8?Q?I3dkhHEKd4hFKL00P4wULEwfs0UWARh5v1vstJX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b6c20c-4e11-4880-9f0a-08d8fc689d6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2021 21:35:51.9835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DXDZN1CQ9SQDyuM8Xp2XOnQXpZq7/pMMBfhatYEBEJncGLkZV6whX8hzWCyglsr9GjXny+WcEAVy+dEnIdSWiD/3b2BCyRrN7BqcuX4GHuaZIfbiC5sYhcEQ8FP5ETYr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1413
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100162
X-Proofpoint-GUID: 9obSPQBjRfAP-uhrMAgeVumIfqNJVikv
X-Proofpoint-ORIG-GUID: 9obSPQBjRfAP-uhrMAgeVumIfqNJVikv
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100162
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

PiBIZWxsbyBTdWRoYWthciwNCj4gDQo+IEZpcnN0LCBsZXQncyBkaXNjdXNzIHdpdGggbWFzdGVy
IGJyYW5jaCBrZXJuZWwuDQo+IA0KPiBXaGF0IGNvbW1hbmQgb3IgYWN0aW9uIHN0YW5kcyBmb3Ig
InRlYXIgZG93biIgPw0KPiAgRnJvbSB5b3VyIGRlc2NyaXB0aW9uLCBpdCB2ZXJ5IGxpa2UgaW9j
dGwgU1RPUF9BUlJBWS4NCj4gWW91ciBjcmFzaCB3YXMgcmVsYXRlZCB3aXRoIHN1cGVyX3dyaXR0
ZW4sIHdoaWNoIGlzIHRoZSBjYWxsYmFjayBmb3INCj4gdXBkYXRpbmcgYXJyYXkgc2IsIG5vdCBi
aXRtYXAgc2IuIGluIG1kX3VwZGF0ZV9zYigpIHRoZXJlIGlzIGEgc3luYw0KPiBwb2ludCBtZF9z
dXBlcl93YWl0KCksIHdoaWNoIHdpbGwgZ3VhcmFudGVlIGFsbCBzYiBiaW9zIGZpbmlzaGVkIHN1
Y2Nlc3NmdWxseS4NCj4gDQo+IGZvciB5b3VyIHBhdGNoLCBkbyB5b3UgY2hlY2sgbWRfYml0bWFw
X2ZyZWUsIHdoaWNoIGFscmVhZHkgZG9uZSB0aGUgeW91ciBwYXRjaCdzIGpvYi4NCj4gDQo+IHRo
ZSBjYWxsIGZsb3c6DQo+IGBgYA0KPiBkb19tZF9zdG9wIC8vYnkgU1RPUF9BUlJBWQ0KPiAgICsg
X19tZF9zdG9wX3dyaXRlcygpDQo+ICAgfCAgbWRfYml0bWFwX2ZsdXNoDQo+ICAgfCAgbWRfdXBk
YXRlX3NiDQo+ICAgfCAgICsgbWRfc3VwZXJfd3JpdGUNCj4gICB8ICAgfCAgYmlvLT5iaV9lbmRf
aW8gPSBzdXBlcl93cml0dGVuDQo+ICAgfCAgICsgbWRfc3VwZXJfd2FpdChtZGRldikgLy93YWl0
IGZvciBhbGwgYmlvcyBkb25lDQo+ICAgKyBfX21kX3N0b3AobWRkZXYpDQo+ICAgfCAgbWRfYml0
bWFwX2Rlc3Ryb3kobWRkZXYpOw0KPiAgIHwgICArIG1kX2JpdG1hcF9mcmVlIC8vc2VlIGJlbG93
DQo+ICAgKyAuLi4NCj4gDQo+IG1kX2JpdG1hcF9mcmVlDQo+IHsNCj4gICAgIC4uLg0KPiAgICAg
IC8vZG8geW91ciBwYXRjaCBqb2IuDQo+ICAgICAgLyogU2hvdWxkbid0IGJlIG5lZWRlZCAtIGJ1
dCBqdXN0IGluIGNhc2UuLi4uICovDQo+ICAgICAgd2FpdF9ldmVudChiaXRtYXAtPndyaXRlX3dh
aXQsDQo+ICAgICAgICAgICAgIGF0b21pY19yZWFkKCZiaXRtYXAtPnBlbmRpbmdfd3JpdGVzKSA9
PSAwKTsNCj4gICAgIC4uLg0KPiB9DQo+IGBgYA0KPiANCj4gV291bGQgeW91IHNoYXJlIG1vcmUg
YW5hbHlzaXMgb3IgdGVzdCByZXN1bHRzIGZvciB5b3VyIHBhdGNoPw0KDQpIZWxsbyBIZW1pbmcs
DQoNClBsZWFzZSBmaW5kIG1vcmUgZGV0YWlscyBhYm91dCBvdXIgc3lzdGVtIGNvbmZpZ3VyYXRp
b24gYW5kIHRoZSBkZXRhaWxlZA0Kc2VxdWVuY2UgdGhhdCBsZWQgdG8gdGhlIGNyYXNoLg0KDQpX
ZSBoYXZlIGEgUkFJRDEgY29uZmlndXJlZCBvbiBhbiBleHRlcm5hbCBpbXNtIGNvbnRhaW5lci4g
L3Byb2MvbWRzdGF0IG91dHB1dA0KbG9va3MgbGlrZSB0aGlzOg0KDQoqKioNCm1kMjQgOiBhY3Rp
dmUgcmFpZDEgc2RiWzFdIHNkYVswXQ0KICAgICAgMTQxNTU3NzYwIGJsb2NrcyBzdXBlciBleHRl
cm5hbDovbWQxMjcvMCBbMi8yXSBbVVVdDQogICAgICBiaXRtYXA6IDEvMiBwYWdlcyBbNEtCXSwg
NjU1MzZLQiBjaHVuaw0KDQptZDEyNyA6IGluYWN0aXZlIHNkYlsxXShTKSBzZGFbMF0oUykNCiAg
ICAgIDEwNDAyIGJsb2NrcyBzdXBlciBleHRlcm5hbDppbXNtDQoqKioNCg0KQWxsIG91ciBzeXN0
ZW0gcGFydGl0aW9uIGlzIGxhaWQgb3V0IG9uIHRvcCBvZiB0aGUgYWJvdmUgUkFJRDEgZGV2aWNl
IGFzDQpzaG93biBiZWxvdy4NCg0KKioqDQovZGV2L21kMjRwNSBvbiAvIHR5cGUgeGZzIChydyxy
ZWxhdGltZSxhdHRyMixpbm9kZTY0LG5vcXVvdGEpDQovZGV2L21kMjRwMSBvbiAvYm9vdCB0eXBl
IHhmcyAocncsbm9kZXYscmVsYXRpbWUsYXR0cjIsaW5vZGU2NCxub3F1b3RhKQ0KL2Rldi9tZDI0
cDE1IG9uIC9ob21lIHR5cGUgeGZzIChydyxub2RldixyZWxhdGltZSxhdHRyMixpbm9kZTY0LG5v
cXVvdGEpDQovZGV2L21kMjRwMTIgb24gL3ZhciB0eXBlIHhmcyAocncsbm9kZXYscmVsYXRpbWUs
YXR0cjIsaW5vZGU2NCxub3F1b3RhKQ0KL2Rldi9tZDI0cDE2IG9uIC90bXAgdHlwZSB4ZnMgKHJ3
LG5vZGV2LHJlbGF0aW1lLGF0dHIyLGlub2RlNjQsbm9xdW90YSkNCi9kZXYvbWQyNHAxMSBvbiAv
dmFyL2xvZyB0eXBlIHhmcyAocncsbm9kZXYscmVsYXRpbWUsYXR0cjIsaW5vZGU2NCxub3F1b3Rh
KQ0KL2Rldi9tZDI0cDE0IG9uIC92YXIvbG9nL2F1ZGl0IHR5cGUgeGZzIChydyxub2RldixyZWxh
dGltZSxhdHRyMixpbm9kZTY0LG5vcXVvdGEpDQoqKioNCg0KSW4gc3VjaCBhIGNvbmZpZ3VyYXRp
b24sIHRoZSBrZXJuZWwgcGFuaWMgZGVzY3JpYmVkIGluIHRoaXMgcGF0Y2ggb2NjdXJzDQpkdXJp
bmcgdGhlICJzaHV0ZG93biIgb2YgdGhlIHNlcnZlci4gU2luY2UgdGhlIHN5c3RlbSBwYXJ0aXRp
b24gaXMgbGFpZCBvdXQgb24NCnRoZSBSQUlEMSwgdGhlcmUgY291bGQgYmUgd3JpdGUgSS9PcyBn
b2luZyB0byB0aGUgUkFJRCBkZXZpY2UgYXMgcGFydCBvZiBzeXN0ZW0NCmxvZyBhbmQgZmlsZXN5
c3RlbSBhY3Rpdml0eSB0aGF0IHR5cGljYWxseSBvY2N1ciBkdXJpbmcgdGhlIHNodXRkb3duLg0K
DQpGcm9tIHRoZSBjb3JlIGR1bXAsIEkgc2VlIHRoYXQsIGFmdGVyIGZpbGVzeXN0ZW1zIGFyZSB1
bm1vdW50ZWQgYW5kIGtpbGxpbmcgYWxsDQpvdGhlciB1c2Vyc3BhY2UgcHJvY2Vzc2VzLCAibWRt
b24iIHRocmVhZCBpbml0aWF0ZXMgdGhlICJzdG9wIiBvbiB0aGUgbWQgZGV2aWNlLg0KDQoqKioN
CkNPTU1BTkQ6ICJtZG1vbiINCiAgIFRBU0s6IGZmZmY4ZmYyYjE2NjNjODAgIFtUSFJFQURfSU5G
TzogZmZmZjhmZjJiMTY2M2M4MF0NCiAgICBDUFU6IDMwDQogIFNUQVRFOiBUQVNLX1VOSU5URVJS
VVBUSUJMRQ0KY3Jhc2g+IGJ0DQpQSUQ6IDczOTAgICBUQVNLOiBmZmZmOGZmMmIxNjYzYzgwICBD
UFU6IDMwICBDT01NQU5EOiAibWRtb24iDQogIzAgW2ZmZmZiOTlkNGVhY2JhMzBdIF9fc2NoZWR1
bGUgYXQgZmZmZmZmZmY5MTg4NGFjYw0KICMxIFtmZmZmYjk5ZDRlYWNiYWQwXSBzY2hlZHVsZSBh
dCBmZmZmZmZmZjkxODg1MGU2DQogIzIgW2ZmZmZiOTlkNGVhY2JhZThdIHNjaGVkdWxlX3RpbWVv
dXQgYXQgZmZmZmZmZmY5MTg4OTYxNg0KICMzIFtmZmZmYjk5ZDRlYWNiYjc4XSB3YWl0X2Zvcl9j
b21wbGV0aW9uIGF0IGZmZmZmZmZmOTE4ODVkMWINCiAjNCBbZmZmZmI5OWQ0ZWFjYmJlMF0gX193
YWl0X3JjdV9ncCBhdCBmZmZmZmZmZjkxMTBjMTIzDQogIzUgW2ZmZmZiOTlkNGVhY2JjMjhdIHN5
bmNocm9uaXplX3NjaGVkIGF0IGZmZmZmZmZmOTExMTAwOGUNCiAjNiBbZmZmZmI5OWQ0ZWFjYmM3
OF0gdW5iaW5kX3JkZXZfZnJvbV9hcnJheSBhdCBmZmZmZmZmZjkxNjk2NDBmDQogIzcgW2ZmZmZi
OTlkNGVhY2JjYzBdIGRvX21kX3N0b3AgYXQgZmZmZmZmZmY5MTY5ZjE2Mw0KICM4IFtmZmZmYjk5
ZDRlYWNiZDU4XSBhcnJheV9zdGF0ZV9zdG9yZSBhdCBmZmZmZmZmZjkxNjlmNjQ0DQogIzkgW2Zm
ZmZiOTlkNGVhY2JkOTBdIG1kX2F0dHJfc3RvcmUgYXQgZmZmZmZmZmY5MTY5YjcxZQ0KIzEwIFtm
ZmZmYjk5ZDRlYWNiZGM4XSBzeXNmc19rZl93cml0ZSBhdCBmZmZmZmZmZjkxMzIwZWRmDQojMTEg
W2ZmZmZiOTlkNGVhY2JkZDhdIGtlcm5mc19mb3Bfd3JpdGUgYXQgZmZmZmZmZmY5MTMyMDNjNA0K
IzEyIFtmZmZmYjk5ZDRlYWNiZTE4XSBfX3Zmc193cml0ZSBhdCBmZmZmZmZmZjkxMjhmY2ZhDQoj
MTMgW2ZmZmZiOTlkNGVhY2JlYTBdIHZmc193cml0ZSBhdCBmZmZmZmZmZjkxMjhmZmQyDQojMTQg
W2ZmZmZiOTlkNGVhY2JlZTBdIHN5c193cml0ZSBhdCBmZmZmZmZmZjkxMjkwMjVjDQojMTUgW2Zm
ZmZiOTlkNGVhY2JmMjhdIGRvX3N5c2NhbGxfNjQgYXQgZmZmZmZmZmY5MTAwM2EzOQ0KIzE2IFtm
ZmZmYjk5ZDRlYWNiZjUwXSBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUgYXQgZmZmZmZm
ZmY5MWEwMDFiMQ0KICAgIFJJUDogMDAwMDdmZjNiZmM4NDZmZCAgUlNQOiAwMDAwN2ZmM2JmOGE2
Y2YwICBSRkxBR1M6IDAwMDAwMjkzDQogICAgUkFYOiBmZmZmZmZmZmZmZmZmZmRhICBSQlg6IDAw
MDA1NWUyNTdlZjA5NDEgIFJDWDogMDAwMDdmZjNiZmM4NDZmZA0KICAgIFJEWDogMDAwMDAwMDAw
MDAwMDAwNSAgUlNJOiAwMDAwNTVlMjU3ZWYwOTQxICBSREk6IDAwMDAwMDAwMDAwMDAwMTANCiAg
ICBSQlA6IDAwMDAwMDAwMDAwMDAwMTAgICBSODogMDAwMDAwMDAwMDAwMDAwMSAgIFI5OiAwMDAw
MDAwMDAwMDAwMDAwDQogICAgUjEwOiAwMDAwMDAwMGZmZmZmZjAxICBSMTE6IDAwMDAwMDAwMDAw
MDAyOTMgIFIxMjogMDAwMDAwMDAwMDAwMDAwMQ0KICAgIFIxMzogMDAwMDAwMDAwMDAwMDAwMCAg
UjE0OiAwMDAwMDAwMDAwMDAwMDAxICBSMTU6IDAwMDAwMDAwMDAwMDAwMDANCiAgICBPUklHX1JB
WDogMDAwMDAwMDAwMDAwMDAwMSAgQ1M6IDAwMzMgIFNTOiAwMDJiDQpjcmFzaD4NCioqKg0KDQpX
aGlsZSBoYW5kbGluZyB0aGUgIm1kIiBzdG9wIGluIHRoZSBrZXJuZWwsIHRoZSBjb2RlIHNlcXVl
bmNlIGJhc2VkIG9uIHRoZQ0KYWJvdmUgbWQgY29uZmlndXJhdGlvbiBpcw0KDQpkb19tZF9zdG9w
DQogKyBfX21kX3N0b3Bfd3JpdGVzDQogfCArIG1kX2JpdG1hcF9mbHVzaA0KIHwgfCArIG1kX2Jp
dG1hcF9kYWVtb25fd29yaw0KIHwgfCB8ICsgbWRfYml0bWFwX3dhaXRfd3JpdGVzKCkNCiB8IHwg
fCB8IChUaGlzIHdhaXQgaXMgZm9yIGJpdG1hcCB3cml0ZXMgdGhhdCBoYXBwZW5lZCB1cCB1bnRp
bCBub3cgYW5kIHRvIGF2b2lkDQogfCB8IHwgfCAgb3ZlcmxhcHBpbmcgd2l0aCB0aGUgbmV3IGJp
dG1hcCB3cml0ZXMuKQ0KIHwgfCB8IHwgKHdhaXQgZmxhZyBpcyBzZXQgdG8gemVybyBmb3IgYXN5
bmMgd3JpdGVzIHRvIGJpdG1hcC4pDQogfCB8IHwgKyB3cml0ZV9wYWdlKCkNCiB8IHwgfCB8IHwg
KEZvciBleHRlcm5hbCBiaXRtYXAsIGJpdG1hcC0+c3RvcmFnZS5maWxlIGlzIE5VTEwsIGhlbmNl
IGVuZHMgdXANCiB8IHwgfCB8IHwgIGNhbGxpbmcgd3JpdGVfc2JfcGFnZSgpKQ0KIHwgfCB8IHwg
KyB3cml0ZV9zYl9wYWdlKCkNCiB8IHwgfCB8IHwgKyBtZF9zdXBlcl93cml0ZSgpDQogfCB8IHwg
fCB8IHwgKFNpbmNlIHRoZSB3YWl0IGZsYWcgaXMgZmFsc2UsIHRoZSBiaXRtYXAgd3JpdGUgaXMg
c3VibWl0dGVkDQogfCB8IHwgfCB8IHwgIHdpdGhvdXQgd2FpdGluZyBmb3IgaXQgdG8gY29tcGxl
dGUuKQ0KIHwgfCB8IHwgfCB8ICsgbWRkZXYtPnBlbmRpbmdfd3JpdGVzIGlzIGluY3JlbWVudGVk
LCB0aGVuIHRoZSBJTyBpcyBzdWJtaXR0ZWQNCiB8IHwgfCB8IHwgfCAgIGFuZCB0aGUgY2FsbCBy
ZXR1cm5zIHdpdGhvdXQgd2FpdGluZw0KIHwgfCArIG1kX2JpdG1hcF91cGRhdGVfc2IoKSAtIChU
aGlzIGNhbGwgc2ltcGx5IHJldHVybnMgYmVjYXVzZQ0KIHwgfCB8IHwgImJpdG1hcC0+bWRkZXYt
PmJpdG1hcF9pbmZvLmV4dGVybmFsIiBpcyB0cnVlIGZvciBleHRlcm5hbCBiaXRtYXBzKQ0KIHwg
KyBtZF91cGRhdGVfc2IoKSAtIChUaGlzIHdvbid0IGJlIGNhbGxlZCBhcyB0aGUgY2FsbCBpcyBj
b25kaXRpb25hbCBhbmQgdGhlDQogfCB8IHwgfCB8IHwgY29uZGl0aW9uIGV2YWx1YXRlcyB0byBm
YWxzZSBpbiBteSBzZXR1cChzZWUgYmVsb3cgZm9yIGNyYXNoIGluZm8pDQogKyBfX21kX3N0b3AN
CiB8ICsgbWRfYml0bWFwX2Rlc3Ryb3kNCiB8IHwgKyBtZF9iaXRtYXBfZnJlZQ0KIHwgfCB8ICsg
d2FpdF9ldmVudChiaXRtYXAtPndyaXRlX3dhaXQsDQogfCB8IHwgfCAgICAgICAgICAgIGF0b21p
Y19yZWFkKCZiaXRtYXAtPnBlbmRpbmdfd3JpdGVzKSA9PSAwKTsNCiB8IHwgfCB8IGJpdG1hcC0+
cGVuZGluZ193cml0ZXMgaXMgemVybywgYnV0IHRoZSBtZGRldi0+cGVuZGluZ193cml0ZXMgaXMg
MSwNCiB8IHwgfCB8IHNvIHRoaXMgY2FsbCByZXR1cm5zIGltbWVkaWF0ZWx5Lg0KIHwgbWQgZGV0
YWNobWVudCBjb250aW51ZXMgd2hpbGUgdGhlcmUgaXMgcGVuZGluZyBtZGRldiBJL08gY2F1aW5n
IE5VTEwgcG9pbnRlcg0KIHwgZGVyZWZlbmNlIHdoZW4gdGhlIEkvTyBjYWxsYmFjaywgc3VwZXJf
d3JpdHRlbiBpcyBjYWxsZWQuDQoNCioqKg0KICAgICAgICBjcmFzaD4gc3RydWN0IG1kZGV2LmJp
dG1hcF9pbmZvLmV4dGVybmFsIDB4ZmZmZjhmZmI2MmYxMzgwMA0KICAgICAgICAgICAgICAgIGJp
dG1hcF9pbmZvLmV4dGVybmFsID0gMSwNCiAgICAgICAgY3Jhc2g+IHN0cnVjdCBtZGRldi5pbl9z
eW5jIDB4ZmZmZjhmZmI2MmYxMzgwMA0KICAgICAgICAgICAgICAgIGluX3N5bmMgPSAxDQogICAg
ICAgIGNyYXNoPiBzdHJ1Y3QgbWRkZXYuc2JfZmxhZ3MgMHhmZmZmOGZmYjYyZjEzODAwDQogICAg
ICAgICAgICAgICAgc2JfZmxhZ3MgPSAwDQogICAgICAgIGNyYXNoPiBzdHJ1Y3QgbWRkZXYucm8g
MHhmZmZmOGZmYjYyZjEzODAwDQogICAgICAgICAgICAgICAgcm8gPSAwDQogICAgICAgIGNyYXNo
PiBzdHJ1Y3QgbWRkZXYuY2x1c3Rlcl9pbmZvIDB4ZmZmZjhmZmI2MmYxMzgwMA0KICAgICAgICAg
ICAgICAgIGNsdXN0ZXJfaW5mbyA9IDB4MA0KICAgICAgICBjcmFzaD4NCioqKg0KDQpQbGVhc2Ug
cmV2aWV3IGFuZCBsZXQgbWUga25vdyB5b3VyIHRob3VnaHRzLg0KDQpUaGFua3MNClN1ZGhha2Fy
DQoNCg0KDQoNCg0KDQoNCj4gDQo+IFRoYW5rcywNCj4gSGVtaW5nDQoNCg==
