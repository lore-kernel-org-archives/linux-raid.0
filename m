Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83361C43460
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 09:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5094D6120B
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 09:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbhDLJpz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 05:45:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241377AbhDLJjB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Apr 2021 05:39:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C9SnDg147512;
        Mon, 12 Apr 2021 09:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bUKF60lRXNIEJWjBgk7u/shVSocv03NbpYd8DKlFsVo=;
 b=wdEYbvNO7kDnRLDZ12Dhw1MeHGQFy3NORrqKQdUUX4PBxNfrxcSCgkmnkK/H2TGGRQc8
 W6J2bqhWu9eq/OvVN2HbaMsI+WhqYbQoRq/rkHrmIEotS5Yy40NiZ50PVmfe2FwR8Hrh
 JxXrweqE9/5cfhwRt4GlyDDjIJj9ez9SnmhPhaKeaBsd1kCmd83mmSzXisB60sc/qp5Y
 bNkivuK8OscNq2QZUjtFznQcvVQGErSa+kaYCB2ZfMXoiO6V8yeo7qLI0Yb1obmvkxky
 w6dvsReza9qdvgAp/dnMLM8hlrDMpgOtSa2mO+BhLDot+eFwdCLwjhS3Tz5coacbeF2Q YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ymb14f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 09:38:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C9SggL187603;
        Mon, 12 Apr 2021 09:38:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 37unxv5abc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 09:38:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJptDve4qq56MBzL1wER9vhWiKCrFSuH+DeL2KYaG8s0O2bK/NsS3smm15hgqqkzvVlP1RARREvfnevjibjYCgpt9YnWp+pF+SwNBogc8HnQCWXHjYUU8AF6If+E9ykQ/aDaxhqqVAXp4FHPco5LL0mzzBLzptaHEFevOjYQp++lO+jDUYSf2ALMlau5C1OUCu0bxx0LcYPO31k6Hef6L93lko0Rx0ieosOVz1hQhdPgvBiAMtT8uxeAR2TWXa5W5BQHMJuGil2OWjW/6yUADIoWoNmi+MY7QXyswSWVtUqLuzSRV/LFB4QQ8FqZl2X9k0QHQZwb8yC6EVFXqGcoOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUKF60lRXNIEJWjBgk7u/shVSocv03NbpYd8DKlFsVo=;
 b=MJse4o7mWyMQuP+ga0w/gvU93fNKjM9bgtc6ORdKHBmvI34e8+IflWhWq/ooWcWcUoUhneA1Z45HRoLAeHGwa/QCyo+mazfgUcnwq43XCTJ3q3YjQkxD028TjFS+WTi1dTClPk1mNAERn4Voj9ZBgi2Dqf32x8X3YYnFP/7U+rKA57tN/fmDObLawtloy8FygEA4buOqs7Heq7PlZ16Fq2C88pV+WIedTE1DpGgOUTUHeVQcS+lp97L5qw0YH4TLkCHAoa6gyrTNZQkGeuXZNoku6NXwsczc4++fbWYmalWXH+h23sY8js/DAcShq1U91weyiFKRx5i7ZKcp106ovA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUKF60lRXNIEJWjBgk7u/shVSocv03NbpYd8DKlFsVo=;
 b=X+0YkjiQziDGQJmwKuI4qcunE2qXk5sdU9O+LBdpnRIvNEOZgQN20R7CIdFwZLOr2Rl9aR+3iV+dJzVhPyO6oI5dRSyj9/MJtXfCsHWb+XBXWu3CUMJ6ttN+0QzE0B3NAeMyyROXFz03Z8391QblpaHsV97TV0D3mDSLVQuGtpU=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR1001MB2104.namprd10.prod.outlook.com (2603:10b6:910:42::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Mon, 12 Apr
 2021 09:38:27 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974%2]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 09:38:27 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     Song Liu <song@kernel.org>,
        "heming.zhao@suse.com" <heming.zhao@suse.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "lidong.zhong@suse.com" <lidong.zhong@suse.com>,
        "xni@redhat.com" <xni@redhat.com>,
        "colyli@suse.com" <colyli@suse.com>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: RE: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
Thread-Topic: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
Thread-Index: AQHXLL+jpqYxQ9QC0Uybi++B1tJz+6qt4qiAgABmX3CAAMC9gIABYJKAgAA5eOA=
Date:   Mon, 12 Apr 2021 09:38:27 +0000
Message-ID: <CY4PR10MB200755C47FFA2EA54F82E8DCFD709@CY4PR10MB2007.namprd10.prod.outlook.com>
References: <20210408213917.GA3986@oracle.com>
 <ba0f4827-83ae-b7e2-2230-5f4afca2538a@suse.com>
 <CY4PR10MB20077F9F84680DC1C0CAE281FD729@CY4PR10MB2007.namprd10.prod.outlook.com>
 <2becafd0-7df7-7a79-8478-b8246f353c9b@suse.com>
 <CAPhsuW4S-FERHGfj6ENC3K70+9tMsupWVmc9yhLoLWB6qX0jMA@mail.gmail.com>
In-Reply-To: <CAPhsuW4S-FERHGfj6ENC3K70+9tMsupWVmc9yhLoLWB6qX0jMA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [73.217.118.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7eba338-5f52-4119-8962-08d8fd96b9cf
x-ms-traffictypediagnostic: CY4PR1001MB2104:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1001MB2104007349FB969FE0B52778FD709@CY4PR1001MB2104.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B72+N3yWr6OaiZ6l7F446BsxbvowmmFwciZHFKmBpbEktJYVwioQEQ3RBMRO9pA88sH7w4i5AX9NlubK2KfI+iEab5zwd/8ZATe0g9QFHU5kkDNtpq6AzLmqfYIiD4nG1jQ4ga0GK3StOwJR9odXOq/MLTb5zyaACbP5mRPfwerWAjqdLvcVibZKvzt4tVNwwo1JURudNQTFz0TZanYLHepQsdMZoXxDs406sIIarQ+kvNVQbu3iPBdMfs8Ab3jWgwHJm3khrBOi9I/H1PLlwYt890BryAqArBg4BVa0FUrGNdlBRCSoBJGnMy0L55qv2U+Qu03W+H5YwpDA3vXusEcE5ymAPzAfu1sAR/r0SLBuPa7CnKPluOxfPNCikJq+erNxqYFT1X5NA1GwB4xtmKBaOYZDnXQ4QpDbjZAJ9Fx5HdJgoj+0apjsZhnWGdmFalXZkipQ4A2cB7b8lxRb9a0RNgkApcL/OrhOvBjLxjqTlgQepfybKjYlmIcVcjeRkaKEkigsJMd2n1wj4i37nk8Iqug5Hmq1KcVDeBrfxniV0fPudzGkaNau8IQ/HXsqlff5mI/MqZZncznhNQCKEmsR7YHarh7u1DnoxPFNs4c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(346002)(39860400002)(366004)(66556008)(66476007)(83380400001)(66446008)(64756008)(66946007)(76116006)(4326008)(33656002)(26005)(5660300002)(186003)(38100700002)(8676002)(2906002)(6506007)(110136005)(54906003)(316002)(8936002)(478600001)(52536014)(9686003)(7696005)(44832011)(107886003)(55016002)(71200400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TWo1YUlKTkRIT1Bjc2hGcUtKbkhPUEE1UlVEMkp1a0hlMytzV045ZExrV3RP?=
 =?utf-8?B?UHRxakNHSHJSd2NmQmI4aUpKbXFyeWxDMnlrc2RabitPZFNoc2ttZ2VqUlZN?=
 =?utf-8?B?OEJGUGE2M2RHNHUyUE9ueHZPN3lnWFlyWGM1SXhUbzV3Rm0relAvQnpERG9K?=
 =?utf-8?B?MlFBbnRMM0tPOWM0clNNSnhzTGVTWlJJNVVnOFdyUE5WMUxLUGdzRWdUanZS?=
 =?utf-8?B?cFBTbHN0YkRBR3piaFFiTWZqVW1iOURSNzUveS9vMXpZVklJK1ZTR2hHYW16?=
 =?utf-8?B?NTdVeXpGeFd0NW5vL0I4VkVjemxhcDFsbXVjbXFqUllFVEFreTYrTUhDN2xv?=
 =?utf-8?B?aW5XdENzNmNjbS9BcC9Vd0gvWDZ3aXpqU2ZURHRFWHBvUThiVFRtK0I5YmRG?=
 =?utf-8?B?YitTNUpneGgxZDhabTMvdGVnODdmSitFZHRvOWY2elZLT09uR20rUzVNcjNu?=
 =?utf-8?B?OTcydy9OejNab0IrK05GNW5uVENQZDBDTENDc2FoSkhuLzIyK00yQ2NnQzBo?=
 =?utf-8?B?eDgxQWlOV29sclV3eTVNakJ2MGgvQktQajFyMUxTdG1vRTduUkVLS0VzLzlr?=
 =?utf-8?B?VVYrTE9weGloaUozbURFd1AyUjFzcFFna3pHUzlRNnZRQS9MN0Vvb1VVa2lS?=
 =?utf-8?B?OGlOcWo4MktUU3F0MGgrb1VsWXpPVzdLNjdJZklNY2xWT2lpWEx1NFJLdUtI?=
 =?utf-8?B?OXB3emtYc0dmbytaMmx1RDZlOENCKzdML0F6ZjVjQXcxejhCZCs0NVdxeTNE?=
 =?utf-8?B?ckVnSGtjcHZpVEdTR1ZBNzhBazVqbTBOM0JsWnlQeUdadUpCQWc2MmFrYWVW?=
 =?utf-8?B?L2x1enBHd2RLZlZxc2RRL0RmSTR6Ym5zWjhYNzU2ZEJLcG81N2xIbW9yYko2?=
 =?utf-8?B?eldNL251YUJ6akVyeWt3WCtOeEwvNlUvK1Z4dk9vbFhQZ1hvNXVQeFR4c2Qy?=
 =?utf-8?B?dW55ZHN2RUtpRWFnbXIzT0RsWGhtT1FsVjJBUEFZYWgyLzdqY1dGR0tYRGRt?=
 =?utf-8?B?WHRhY0l0T0YvTzJhVjh0NXhXczNMdFZYdXQ1WmpzU2ZWWHJreVdHcGhidzFT?=
 =?utf-8?B?bytOZUN2Y1U0ejFlejhMR1dKYWZvSDkzaU5tb0s5Z0wwQWxrdWMwN003MWNR?=
 =?utf-8?B?TWdSSjVhcjN3OURLblFMZmwzWnJjd3JsYnl3T1kzM3U5Qi9lYjYxQ0hzd0hE?=
 =?utf-8?B?SlkzaFc2ZTl3ZWk1Mk9hZnB4SFhxaHdma1MzZkhFRXNSWkN6QjA4REMxajBS?=
 =?utf-8?B?S1JnNmdCeWl0VDExZHdJYkZ6WkVveWFDU085SUhUcVZmU1BPWVl4bVJHSGRi?=
 =?utf-8?B?QUFDaWNVRlptdHdRdVBMVmJWQkpicFJ4ZjBSM3FvVmFYR1hoM1NOUm5sNWNs?=
 =?utf-8?B?ZnJtdVBraTlTQ3pRZThVbWo1QlBqRHk4cVNxdWZ0Vkg4eEVnZ1EwY3EyeENm?=
 =?utf-8?B?Yksyc21LcWtSSUIyZVdRTlh6UWFncGFQa2NCeGprNDlEbnliVTMybXJGSjNU?=
 =?utf-8?B?cE9zTmk4TUhxbzZLaXdjMmJUenFrTUpRTVdlRllYWDhmQkZQSVJQN0tsNm4r?=
 =?utf-8?B?R1lzclJtRDVWb05sLzR4R1RYUHVXUXo4eCszb2JNUHU3V1B1WkVLSjhRR3hq?=
 =?utf-8?B?WnoyS0t4RkdaVjB5dmJVRTlIOWV5cnZKUXNmYkZkNzNWdk9kWFZxeC9Xekln?=
 =?utf-8?B?M0tvQUozNXdzWThVTGVsaUtGV2QyVmdVU0d0U2Vkd3hITFY3QUNDaTRraFl2?=
 =?utf-8?Q?2VAUkbQGhdAc/Z8hyf3ufV1jUXAwbGRkTjlsUaf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7eba338-5f52-4119-8962-08d8fd96b9cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 09:38:27.6603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l1KT/FzOoC4zDdyrAYnP+FFLDnesDNlnMiDFf4IqTEY0PZI4ZsmUlskYFf8y5PyfJ9VtOfH8gnPC9N2VYmUhvpczudDGRyDhIBut+U496vJ5y5JDxuXL1eRMORN6witn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2104
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120062
X-Proofpoint-GUID: 34jWZDs7dTV9LJjEM4LQeFLZbzg3JeW3
X-Proofpoint-ORIG-GUID: 34jWZDs7dTV9LJjEM4LQeFLZbzg3JeW3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120062
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

PiA+IEluIG15IG9waW5pb24sIHVzaW5nIGEgc3BlY2lhbCB3YWl0IGlzIG1vcmUgY2xlYXIgdGhh
biBjYWxsaW5nIGdlbmVyYWwgbWRfYml0bWFwX3dhaXRfd3JpdGVzKCkuIHRoZSBtZF9iaXRtYXBf
d2FpdF93cml0ZXMgbWFrZXMgcGVvcGxlDQo+IGZlZWwgYml0bWFwIG1vZHVsZSBkb2VzIHJlcGV0
aXRpdmUgY2xlYW4gam9iLg0KPiA+DQo+ID4gTXkgaWRlYSBsaWtlOg0KPiA+IGBgYA0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLWJpdG1hcC5jIGIvZHJpdmVycy9tZC9tZC1iaXRtYXAu
Yw0KPiA+IGluZGV4IDIwMGM1ZDBmMDhiZi4uZWE2ZmE1YTJjYjZiIDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvbWQvbWQtYml0bWFwLmMNCj4gPiArKysgYi9kcml2ZXJzL21kL21kLWJpdG1hcC5j
DQo+ID4gQEAgLTE3MjMsNiArMTcyMyw4IEBAIHZvaWQgbWRfYml0bWFwX2ZsdXNoKHN0cnVjdCBt
ZGRldiAqbWRkZXYpDQo+ID4gICAgICAgICAgYml0bWFwLT5kYWVtb25fbGFzdHJ1biAtPSBzbGVl
cDsNCj4gPiAgICAgICAgICBtZF9iaXRtYXBfZGFlbW9uX3dvcmsobWRkZXYpOw0KPiA+ICAgICAg
ICAgIG1kX2JpdG1hcF91cGRhdGVfc2IoYml0bWFwKTsNCj4gPiArICAgICAgIGlmIChtZGRldi0+
Yml0bWFwX2luZm8uZXh0ZXJuYWwpDQo+ID4gKyAgICAgICAgICAgICAgIG1kX3N1cGVyX3dhaXQo
bWRkZXYpOw0KDQpBZ3JlZWQuIFRoaXMgbG9va3MgbXVjaCBjbGVhbmVyLg0KDQo+ID4gICB9DQo+
ID4NCj4gPiAgIC8qDQo+ID4gQEAgLTE3NDYsNiArMTc0OCw3IEBAIHZvaWQgbWRfYml0bWFwX2Zy
ZWUoc3RydWN0IGJpdG1hcCAqYml0bWFwKQ0KPiA+ICAgICAgICAgIC8qIFNob3VsZG4ndCBiZSBu
ZWVkZWQgLSBidXQganVzdCBpbiBjYXNlLi4uLiAqLw0KPiA+ICAgICAgICAgIHdhaXRfZXZlbnQo
Yml0bWFwLT53cml0ZV93YWl0LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgYXRvbWljX3JlYWQo
JmJpdG1hcC0+cGVuZGluZ193cml0ZXMpID09IDApOw0KPiA+ICsgICAgICAgd2FpdF9ldmVudCht
ZGRldi0+c2Jfd2FpdCwgYXRvbWljX3JlYWQoJm1kZGV2LT5wZW5kaW5nX3dyaXRlcyk9PTApOw0K
DQpJIHRoaW5rIHRoaXMgY2FsbCBsb29rcyByZWR1bmRhbnQgYXMgdGhpcyB3YWl0IGlzIGFscmVh
ZHkgY292ZXJlZCBieSBtZF91cGRhdGVfc2IoKSBmb3Igbm9uLWV4dGVybmFsIGJpdG1hcHMgYW5k
IHRoZSBwcm9wb3NlZCBjaGFuZ2UgaW4gbWRfYml0bWFwX2ZsdXNoKCkgZm9yIGV4dGVybmFsIGJp
dG1hcHMuIFNvLCBjYW4gd2Ugb21pdCB0aGlzIGNoYW5nZT8gDQoNCj4gPg0KPiA+ICAgICAgICAg
IC8qIHJlbGVhc2UgdGhlIGJpdG1hcCBmaWxlICAqLw0KPiA+ICAgICAgICAgIG1kX2JpdG1hcF9m
aWxlX3VubWFwKCZiaXRtYXAtPnN0b3JhZ2UpOw0KPiA+IGBgYA0KPiANCj4gSSBsaWtlIEhlbWlu
ZydzIHZlcnNpb24gYmV0dGVyLg0KPiANCj4gSGkgU3VkaGFrYXIsDQo+IA0KPiBBcmUgeW91IGFi
bGUgdG8gcmVwcm9kdWNlIHRoZSBpc3N1ZT8gSWYgc28sIGNvdWxkIHlvdSBwbGVhc2UgdmVyaWZ5
DQo+IHRoYXQgSGVtaW5nJ3MNCj4gY2hhbmdlIGZpeGVzIHRoZSBpc3N1ZT8NCg0KSGkgU29uZywg
SGVtaW5nLA0KDQpQbGVhc2UgcmV2aWV3IG15IGNvbW1lbnRzIGFib3ZlLiBJIGNhbiB0cnkgdG8g
cmVwcm9kdWNlIHRoZSBpc3N1ZSB3aXRoIHRoZSBmaXggb25jZSB3ZSBhZ3JlZSBvbiB0aGUgZmlu
YWwgZml4Lg0KDQpUaGFua3MNClN1ZGhha2FyDQoNCj4gDQo+IFRoYW5rcywNCj4gU29uZw0K
