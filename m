Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C59C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 00:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7F93611CE
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 00:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbhDMASM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 20:18:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhDMASM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Apr 2021 20:18:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D0FrkW113019;
        Tue, 13 Apr 2021 00:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4bn/5CtU/vmQRcgubbqaP2frpYRguEzbHPsfjgjgcX0=;
 b=ZQe/kGuXnflv1rJjmXYMDdv6JCoJulHdBJUqrCc0xmcrJjjzIfGaBvX1PuLaF9L0TETw
 uvfQEE8GPuyFuOxESnQXxMZiETUTbMkBQcz3IYcMKbOgI1L3WVlq0nWC1CO617NtzzGH
 D2ZXgjRKAyix19i28rf5IiE8T8pgqXA0iX3MP+BbP8yxIxeECrnKSNBhfkBsbPcQJeMh
 zAuNe1ZhBW2A6a83v6dZRlhG/WqQZrJD8NRK7V/2k5Ob/8h/uiwWdGuG7JUhoPP4Zyx0
 3o9WC9QbQdLGUAPFkuzvLW7bwvHZHXeu4df4FP0YyYuavIfdnuGTSgo3g4YD2wkavSUG hQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37u4nndd5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 00:17:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D0GSEa094649;
        Tue, 13 Apr 2021 00:17:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 37unknse5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 00:17:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y57cpJLMd9Ojxxvhf4DNXoYTzMWPFgKSL1C6Y0OtIPkccU1PCmNwpVYy8eKHtJYi+2d+gBlmttWMy9zACq0pG2yKaAwR4BXYWVZdBZzH+9Tx8mn6zNE+zkkTSd0pjWt4pZNJScqHW04H5OFnKGBzc9xeLHTiGlROK9EK/nqueVTbFpGubQljpKREnxLsI47X0b1mqYptHJ8ZeIqgg7VxCg6YBPwj0CJwPVVW+58ad5K+pfQrwOdiB3w+BCzTF5rTL3ipXFgg/4NfzsRf+tOO1lXWbAKivtHAB72Tlt4s9+1oiVPPRepMb8tTaE1akfqcZdEGGddT7PXOP+VS++luYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bn/5CtU/vmQRcgubbqaP2frpYRguEzbHPsfjgjgcX0=;
 b=FC+UgckitoGetvW2Q7T9Q8WcGYQYSfwqbfzjq0qOzv2o9ap3Z3QFcfxyF35i6b67O4Dd+TFJdQp/JpFtWHWzO6NMwz6dMMRDvk9AGXG4EpsSIopcGw39s0el1R/C21LeGe7OLzZenLroyfDZf1ZoHbg05gh6UyH+5lx8qkDYySGOUDiq5EvOtOrFF+gzQeLfLrBTLkwglLgmAgmPq9LuwyvCMgJHnYqTwfcBuEi3nMJrIVHHJSnqdOwAq2DWwepFvLL9uQCZYfPP0HfSzw4/HQgY7weIxUdny+SsuW/3lSAARuNF7segm6DXtqe5cKRPiwwn/Us1RR5JylHvJtDOdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bn/5CtU/vmQRcgubbqaP2frpYRguEzbHPsfjgjgcX0=;
 b=TuBTrI9LSj7GuUNcpgkcWDd7X0sQ0LI0sVFlqKBy3aIm7NHVrAgLmVyxh2iU9tUr2YVsRjO0Kuv8wLUJUuH0JaJMyu9717nsqxRFEb+4/znrm1KTcTDMIj6o6nIPjY5qeTZKPopFvnvxficK28oFmSb6H8YRkCT8bC/ewgx74Nc=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1333.namprd10.prod.outlook.com (2603:10b6:903:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 00:17:42 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974%2]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 00:17:42 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>,
        Song Liu <song@kernel.org>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "lidong.zhong@suse.com" <lidong.zhong@suse.com>,
        "xni@redhat.com" <xni@redhat.com>,
        "colyli@suse.com" <colyli@suse.com>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: RE: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
Thread-Topic: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
Thread-Index: AQHXLL+jpqYxQ9QC0Uybi++B1tJz+6qt4qiAgABmX3CAAMC9gIABYJKAgAA5eOCAAAepgIAA74Lg
Date:   Tue, 13 Apr 2021 00:17:42 +0000
Message-ID: <CY4PR10MB200771938F7D63DDB295CE0BFD4F9@CY4PR10MB2007.namprd10.prod.outlook.com>
References: <20210408213917.GA3986@oracle.com>
 <ba0f4827-83ae-b7e2-2230-5f4afca2538a@suse.com>
 <CY4PR10MB20077F9F84680DC1C0CAE281FD729@CY4PR10MB2007.namprd10.prod.outlook.com>
 <2becafd0-7df7-7a79-8478-b8246f353c9b@suse.com>
 <CAPhsuW4S-FERHGfj6ENC3K70+9tMsupWVmc9yhLoLWB6qX0jMA@mail.gmail.com>
 <CY4PR10MB200755C47FFA2EA54F82E8DCFD709@CY4PR10MB2007.namprd10.prod.outlook.com>
 <a33cc4b5-2ced-86e5-ae20-242b4f3478c9@suse.com>
In-Reply-To: <a33cc4b5-2ced-86e5-ae20-242b4f3478c9@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [73.217.118.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90ce4fca-d456-4f5d-683d-08d8fe118e3b
x-ms-traffictypediagnostic: CY4PR10MB1333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB133332618AC5956FA3E5A242FD4F9@CY4PR10MB1333.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IVMBJ7aHqjLU5oywnkSONWCmD1NUJAgS0AFPUrxYAd6Y/eZKbdHQLr9du2V/dXrj4Plo7jHw2+RFdnii0Vf9SvYHhWzZ0vTknlqnryU3HX3v1ewfmB9BzMDTJ0DjH9PKyrga6CUG6xs+hFzsruAn4CHcD57+owvD19pUflztfmF+NkbULw1G00o4Ij/DoDq3j4m9sDaMyWuprFvPrBYAvX3bCpmg+lMZzAippZjluRaxcfov+1zH6G2WZtHEmkc2Fub6n7GIAiCwMK/PmGCZfipz6wAiVbiLJ2ANIx0rD6hAXithGJnnJWdYoIY7gG3gINpM05W+Sv36IBwsCiTC5MnhnEyxJo15pcJQVjYisXYQZuZl+1k/lawXHOuozjzOwi3tJbqY52RWnhPq79kSRP66NkzoJpSULgj398sbucom4nU/N/pWMKU+dFlvuQM6lAbUmD+jE5BFV1Z3IusqHA3t1w1htTXBF6fUmPnWMDZwT8099xctSpRMsiOx7IkZW/cw+jJ56RlZVqy1ytRnJQnymv7/uII4lq0Qy+BooweVFFwbYgdJqucBcq44dVpJ4BO1kl9v48VgrYamcqCSD1G07oOLeulEPVg6INglOUY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(396003)(376002)(39860400002)(86362001)(66556008)(33656002)(76116006)(4326008)(66946007)(2906002)(83380400001)(53546011)(71200400001)(6506007)(186003)(8936002)(316002)(9686003)(5660300002)(55016002)(52536014)(26005)(8676002)(54906003)(110136005)(66446008)(38100700002)(107886003)(7696005)(64756008)(478600001)(66476007)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZXdDSzliYVIwRkFwQWZYYlAxQktmNVhlRW5Za09PYkZXWDhlaE1xVjhyZlRC?=
 =?utf-8?B?bmNyN0FNRzVaMWFwUGVOQkhHaFJkTW42RXJ1ZmFKR2Qwc2tvUTlDVS8zNlBN?=
 =?utf-8?B?Q0d4UGR0N3BoNTdmbzRUVnczRHJpdXc2dDBtYlo4U1VlYWZFdXMxcjZlcFcv?=
 =?utf-8?B?SVprOHJHa2NuVVFMcnFVNUs5R2d2bTZVVkFrZHBXcUtURGh3citsK2FlZGhM?=
 =?utf-8?B?a2tqeFpBOW1VNzJzcE1rZEJ6U3pray9Dd0x6N2hJT08vNmJQT2dJVnBJSXNC?=
 =?utf-8?B?ZXZ0OUVsWGtzR3pkV01RbU5PSlVmS1E1Z3U1cVVEWUthRG1FVGYyRVgxTVRk?=
 =?utf-8?B?d1BWUXpEeVJBOHZ6N3ZTOVl4Y2J6c0RHNTNyTlh2dG1Bd05hakFobjBLbHpo?=
 =?utf-8?B?TUttNmZucWdXeWtSMkNhd3JMZzFMYmhySWVpd2UrRjR3bGlhYmVoWjcxTFFY?=
 =?utf-8?B?N1d0Qnc2enBWR0xtWHJIN2tLUDhUcU13cGx1MzVQSVdmVUI0dm92dTlBL1dX?=
 =?utf-8?B?UjZaZ09wNUhwbTNtWXF2djBlcGVVbHpoWmFCaFBMZzZQbHpGckNRMlI1aHE1?=
 =?utf-8?B?MzZNMWYyYjkwcVdXUTcxYjRCMFFEajF4R3lHVzJLelNHSGZRMy9peHh6aktp?=
 =?utf-8?B?RVAydU92Y1NWY1BORFlib0EzeCtIcmFpWFloZjhDT283bStLa3hPb2lNOU1B?=
 =?utf-8?B?SkNuejZFZ290c1ZqMUt6U3RwQXM3S3A3K0luMnp0ZHo1Q2Q4d2RSVmhIYmQr?=
 =?utf-8?B?L2pkZ1plNGhkTUhqSlVxUEs0Y2FKL1F1TlA3UjZZaCtKU0h6SkVGZ2k2VUJz?=
 =?utf-8?B?OEFsT0kzRndIL3BzZUZhM1JSbjJadytjMkdyd21PWDY2dmcxVWkvL2xJY09E?=
 =?utf-8?B?VUdGZWRaOWxjNmxJWTI4bSszb0liSmJkV2lEbm4yUFZWNXFnR1hMcURpTFZQ?=
 =?utf-8?B?cWV2eHAyN01yTml5Y3haRTFUcU1TU0FadEdUdUJSdEE5TVJlbWQyQ2RtYlh1?=
 =?utf-8?B?VnZHbW5iQ0NRRkVBaEQ5YzlZT0N3WG1qT0VIODFLV1ZrRkkvUHY1V1g2bFFa?=
 =?utf-8?B?RWtUQnN3enkyZTd3eE1LWjdGZjFlS21FSVZyNTI5ZlJVNUc3R2JUU0pYc1No?=
 =?utf-8?B?MjRIblZMakpBNk1ySFlmMURxWlpQdTFUSmlMNStzbzhBYkJtMllTL09nLzNG?=
 =?utf-8?B?L2tVSldQa3Y3Uk8yd3dTdTV2QXlBdnZnVktjQVNaTDUvSDNiTFE1SS9qV2hq?=
 =?utf-8?B?VTIvMG1ad29RSm5hTU9SeTB0UmlldTMvTzNkZk5EdjR5REI0eXVVOHZNWk5X?=
 =?utf-8?B?WVB2cDNhRDBwWm9xNjBMWldzRTFKNGlmNHVFMXRqTmZjTlRtdk1lTUtUbFBN?=
 =?utf-8?B?YkpCOGFhWjZ3V1A5OGZqKytYK1B1NGJsK1c5L3FmMTY1ZXlLU0UrTTlTWFJz?=
 =?utf-8?B?bUYvRFN1NTdPU0FxcFUveG1TL3Z5KzY2cXZwMEFqYkJkc1FrWHdQZXdCc1Bx?=
 =?utf-8?B?NXpxTUFGazZubkdPM1hvWGNBOThiRzFMUGRqaHZFTDhnZlVQZmNJaVkzdWZh?=
 =?utf-8?B?WGRBWk5hQmVWcE9VdU9jdnZjbUNGVmROODl4YnFUOGkvZVIzNDh2eWhhSHZU?=
 =?utf-8?B?ZzcxU3d2OEZCanh2ejc5OTN2dGlXNFJCTW5MWEU1MDdEcDhQTFNsYUtTQjBF?=
 =?utf-8?B?ZTl5QTl1aUcreEVyTlA3bE02YXNQeWJNTkhzSWtkV25Cck9paU1aaGxrKzEy?=
 =?utf-8?Q?YJYqRbSi1YOQR6J4AypxzHNkDx5ROEwdhItUEH6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ce4fca-d456-4f5d-683d-08d8fe118e3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 00:17:42.6042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yGJjTyTGamZIVkIANoyuVxPDPefVD7if7w6vIHm1pkExALGVzqLoS7X2JyZA1CwnaCscL84zrT9OJDTJYRSfnGO63NaF67oGmJz/RUo5glJSfSjirWuDsLqEzEa9CK1T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1333
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130000
X-Proofpoint-ORIG-GUID: qgn7T7NHdAKKWSlk7i2dxQ0Xkdpqn5Dk
X-Proofpoint-GUID: qgn7T7NHdAKKWSlk7i2dxQ0Xkdpqn5Dk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130000
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogaGVtaW5nLnpoYW9Ac3Vz
ZS5jb20gW21haWx0bzpoZW1pbmcuemhhb0BzdXNlLmNvbV0NCj4gU2VudDogTW9uZGF5LCBBcHJp
bCAxMiwgMjAyMSAzOjU5IEFNDQo+IFRvOiBTdWRoYWthciBQYW5uZWVyc2VsdmFtIDxzdWRoYWth
ci5wYW5uZWVyc2VsdmFtQG9yYWNsZS5jb20+OyBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPg0K
PiBDYzogbGludXgtcmFpZEB2Z2VyLmtlcm5lbC5vcmc7IGxpZG9uZy56aG9uZ0BzdXNlLmNvbTsg
eG5pQHJlZGhhdC5jb207IGNvbHlsaUBzdXNlLmNvbTsgTWFydGluIFBldGVyc2VuDQo+IDxtYXJ0
aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gbWQvYml0bWFw
OiB3YWl0IGZvciBiaXRtYXAgd3JpdGVzIHRvIGNvbXBsZXRlIGR1cmluZyB0aGUgdGVhciBkb3du
IHNlcXVlbmNlDQo+IA0KPiBPbiA0LzEyLzIxIDU6MzggUE0sIFN1ZGhha2FyIFBhbm5lZXJzZWx2
YW0gd3JvdGU6DQo+ID4+PiBJbiBteSBvcGluaW9uLCB1c2luZyBhIHNwZWNpYWwgd2FpdCBpcyBt
b3JlIGNsZWFyIHRoYW4gY2FsbGluZyBnZW5lcmFsIG1kX2JpdG1hcF93YWl0X3dyaXRlcygpLiB0
aGUgbWRfYml0bWFwX3dhaXRfd3JpdGVzIG1ha2VzDQo+IHBlb3BsZQ0KPiA+PiBmZWVsIGJpdG1h
cCBtb2R1bGUgZG9lcyByZXBldGl0aXZlIGNsZWFuIGpvYi4NCj4gPj4+DQo+ID4+PiBNeSBpZGVh
IGxpa2U6DQo+ID4+PiBgYGANCj4gPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLWJpdG1h
cC5jIGIvZHJpdmVycy9tZC9tZC1iaXRtYXAuYw0KPiA+Pj4gaW5kZXggMjAwYzVkMGYwOGJmLi5l
YTZmYTVhMmNiNmIgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJzL21kL21kLWJpdG1hcC5jDQo+
ID4+PiArKysgYi9kcml2ZXJzL21kL21kLWJpdG1hcC5jDQo+ID4+PiBAQCAtMTcyMyw2ICsxNzIz
LDggQEAgdm9pZCBtZF9iaXRtYXBfZmx1c2goc3RydWN0IG1kZGV2ICptZGRldikNCj4gPj4+ICAg
ICAgICAgICBiaXRtYXAtPmRhZW1vbl9sYXN0cnVuIC09IHNsZWVwOw0KPiA+Pj4gICAgICAgICAg
IG1kX2JpdG1hcF9kYWVtb25fd29yayhtZGRldik7DQo+ID4+PiAgICAgICAgICAgbWRfYml0bWFw
X3VwZGF0ZV9zYihiaXRtYXApOw0KPiA+Pj4gKyAgICAgICBpZiAobWRkZXYtPmJpdG1hcF9pbmZv
LmV4dGVybmFsKQ0KPiA+Pj4gKyAgICAgICAgICAgICAgIG1kX3N1cGVyX3dhaXQobWRkZXYpOw0K
PiA+DQo+ID4gQWdyZWVkLiBUaGlzIGxvb2tzIG11Y2ggY2xlYW5lci4NCj4gPg0KPiA+Pj4gICAg
fQ0KPiA+Pj4NCj4gPj4+ICAgIC8qDQo+ID4+PiBAQCAtMTc0Niw2ICsxNzQ4LDcgQEAgdm9pZCBt
ZF9iaXRtYXBfZnJlZShzdHJ1Y3QgYml0bWFwICpiaXRtYXApDQo+ID4+PiAgICAgICAgICAgLyog
U2hvdWxkbid0IGJlIG5lZWRlZCAtIGJ1dCBqdXN0IGluIGNhc2UuLi4uICovDQo+ID4+PiAgICAg
ICAgICAgd2FpdF9ldmVudChiaXRtYXAtPndyaXRlX3dhaXQsDQo+ID4+PiAgICAgICAgICAgICAg
ICAgICAgICBhdG9taWNfcmVhZCgmYml0bWFwLT5wZW5kaW5nX3dyaXRlcykgPT0gMCk7DQo+ID4+
PiArICAgICAgIHdhaXRfZXZlbnQobWRkZXYtPnNiX3dhaXQsIGF0b21pY19yZWFkKCZtZGRldi0+
cGVuZGluZ193cml0ZXMpPT0wKTsNCj4gPg0KPiA+IEkgdGhpbmsgdGhpcyBjYWxsIGxvb2tzIHJl
ZHVuZGFudCBhcyB0aGlzIHdhaXQgaXMgYWxyZWFkeSBjb3ZlcmVkIGJ5IG1kX3VwZGF0ZV9zYigp
IGZvciBub24tZXh0ZXJuYWwgYml0bWFwcyBhbmQgdGhlIHByb3Bvc2VkIGNoYW5nZSBpbg0KPiBt
ZF9iaXRtYXBfZmx1c2goKSBmb3IgZXh0ZXJuYWwgYml0bWFwcy4gU28sIGNhbiB3ZSBvbWl0IHRo
aXMgY2hhbmdlPw0KPiANCj4gWWVzLCBpdCdzIGFic29sdXRlIHJlZHVuZGFudCBzdGVwLCB0byBh
ZGQgb3IgcmVtb3ZlIHRoaXMgbGluZSBpcyB1cCB0byB5b3UuDQo+IEkgYWRkZWQgdGhpcyBsaW5l
IGZvciBmb2xsb3dpbmcgdGhlIHN0eWxlIG9mIGJpdG1hcC0+cGVuZGluZ193cml0ZXMuIFRoZSBj
b21tZW50IGluIHRoaXMgYXJlYSBhbHNvIGdpdmUgYSBleHBsYW5hdGlvbi4NCj4gDQoNCkhlbGxv
IEhlbWluZywgU29uZywNCg0KSSBjb3VsZCBub3QgcmVwcm9kdWNlIHRoZSBpc3N1ZSB3aXRoIHRo
ZSByZXZpc2VkIGZpeC4gSSB3aWxsIGJlIHN1Ym1pdHRpbmcgdGhlIHJldmlzZWQgcGF0Y2ggc2hv
cnRseS4NCg0KVGhhbmtzDQpTdWRoYWthcg0K
