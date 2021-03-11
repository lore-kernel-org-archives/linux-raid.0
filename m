Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137D1C433E0
	for <linux-raid@archiver.kernel.org>; Thu, 11 Mar 2021 03:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B20E364F8B
	for <linux-raid@archiver.kernel.org>; Thu, 11 Mar 2021 03:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhCKDz7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:55:59 -0500
Received: from mail1.bemta24.messagelabs.com ([67.219.250.112]:62090 "EHLO
        mail1.bemta24.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230052AbhCKDz7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 10 Mar 2021 22:55:59 -0500
Received: from [100.112.134.46] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.us-west-2.aws.symcld.net id 88/FF-17150-DC499406; Thu, 11 Mar 2021 03:55:57 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA1WTf0xTVxTHuX2vrw/GY89S5diB0TIQMK0tbqW
  SZdOEaFmmYWaOjM1IK4V2QGF9JVbNWJkBtFhBijorCEILjs2M0blRMOJwChuIxM2F/YizoxJ+
  mGLGYjbUbe/50G3/3HzO+Z77veck55KYeJaQkgab1WAx64pkRARunAo8Jb/akJmrPHOL1hyvu
  CbSVEzVYJrhulaBprq5F2kOfH4S17T4PxZq/rw0gmnm9o8SG0it2+4ktI5gK649sj8k0vrOpG
  jnLtwgtL7hfdr57hVZohyhyawvseUKjT3nJ4jShihbaPgDgR09oBwoghTTdgE4RwYJBwpngxk
  Ep0flvFAhgIMTTiEv3EdwuDGDExDtxaA+MIfxwRUchkaqRHzQhaBmYR5xAU73YTDY1o/zZs0C
  qGwbXTSbQNDSuMyBSJKgU+Bqt45DCb0FQlde5MoxulcAn7qmcC4fTW+F7kAeX5IFY7+rORMJn
  QpDF704xzidAL7hVoxjis6Fox8FEceIjoNgy6SAY4yOgR+DzY8YaBo8569hPC+F6Ym/hHz9IQ
  T3Gwk+Hw/tdS7Ecxxcb65Z5C2wcGoS5zkF3h9rX/QshPqOkIjnRBi/c2DRfwV0OgOL9bFwa/w
  LghsR6D4hnPb7RXVI6f5Pf252TIxOhk961/LpVdBQExC5H422BL4+EcRbEN6J0vQWU4HRWqwz
  FclVSqVcpUqVq9atk6s1Ct1euV5Rxsh3GxirPFWh280omD3Fu4ryFGaDtRuxu5ZXWpnRg/6ev
  asYQMtJgWwplVaXmSuO0pfk7THqGONOS1mRgRlAsSQpA+qmi9WWWAwFBlu+qYjd2McykJEyCZ
  V0mJUpplRXzJgKeOkbtJ6sm25qxUhfk5c9v+JOMW4uMRukMdQf9ewFmrtgLDM/sXv8B66jOGk
  0hcLCwsSRpQZLscn6f30GxZBIFk1J2K8ijjSZrU9eZXeXnUVCrVRu4hqy6v6VpHaBdfsMvNDY
  /9mXC9aORMKb8rNA0e9JytdXT70aZvOEax23fYOOoc6Vk84TOa80e/zHdmS/vjkuwZcsPdh2s
  SEh7eE7quDGyR9+OrKtvW91a1XBpQ0Zl3/tCvdR3z5z7t6djnz/svblrtrymZ02+aa2e/Pjs4
  d2hUGgy03Z459dey70AIZlPQ83vtxWfbT8+ZFV2Pe13sqzZ+MbkraXR2U1Zdurbv+it6krc1B
  8mnQoKzaJuCEkjr+dnCh7Q7v1TfX6bZndhc/VRky/9x2R/XST+uYOxuJ3heCl3xJn0i+Yk/ep
  LiP3h2PKNZ7EmrTXYCDo3Kv0SFan38XwdNe7hW/Jjq2R4YxRp0rBLIzuHz8wGUt+BAAA
X-Env-Sender: ahuang12@lenovo.com
X-Msg-Ref: server-9.tower-346.messagelabs.com!1615434955!36986!1
X-Originating-IP: [104.232.225.11]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.60.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 24969 invoked from network); 11 Mar 2021 03:55:57 -0000
Received: from unknown (HELO lenovo.com) (104.232.225.11)
  by server-9.tower-346.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 11 Mar 2021 03:55:57 -0000
Received: from HKGWPEMAIL03.lenovo.com (unknown [10.128.3.71])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by Forcepoint Email with ESMTPS id E6A46D682BBEBEAE5F20;
        Wed, 10 Mar 2021 22:55:53 -0500 (EST)
Received: from HKGWPEMAIL01.lenovo.com (10.128.3.69) by
 HKGWPEMAIL03.lenovo.com (10.128.3.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 11 Mar 2021 11:55:51 +0800
Received: from HKGWPEXCH01.lenovo.com (10.128.62.30) by
 HKGWPEMAIL01.lenovo.com (10.128.3.69) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2106.2
 via Frontend Transport; Thu, 11 Mar 2021 11:55:51 +0800
Received: from APC01-PU1-obe.outbound.protection.outlook.com (104.47.126.57)
 by mail.lenovo.com (10.128.62.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2106.2; Thu, 11 Mar
 2021 11:55:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0vY2rnCy+nyEWXzzbeayg45I1b/iQ9Av4smngEVxm5TPE3VuyDnLF4KyzX8472pxDP4ToX76UaSZKYs38nvyM2nykxgwDhKFfod61DQVRWGvmNKlJODP9OCtvXlst8DgTsN6ZzOiQyylgnhw1JG4HkdLT6v6mgrozhLYagQ3fRKUIMaHAROHy6cbBzCQ/NHQDj0p6VcFeIzQQkn5F3NeWQiM5dPcuK4CMj6z1ZIj0txn1v2jjEYI/NuclJnUMU+2/qYnlYwHWis2PSEyvdJQCUNMgGYUTONQbTOxGaFnXB9EvV6+bmuaBJo9ge90MrEWcIgZ+jjO2q520wto6wNlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8AIJiVMX/ydHUNNWlCdLBANJKUTqXiDNG65r+WELcE=;
 b=M8lRaqRSbQBk352jZ+GGQfr9C9tdOtLeEaFK2ompwuEfwrw1clDoFn1zVxdW3c6rrW0EgS4q+4puP63TMMTBxqD2udh3dMuacyfyjdXG9QhMu6rNJ4uBMDrPoANn8W82CSx0VNdWcRpTYn8b2ZZlarQQfdpRUXt7kC+zKcjeBpLY5lp8BNVrWFfvqpNiP1HASGVuydqL44nn8+AbEt574yhcpYPe7U6UtNVu8tjDyR3PBTlSCPZykKM2Jdf17A+mS+Pq1fvlUKWrqFwkskEeXe0+HKioFXUb470ScBi2BuHDJcP667QpD2HXpa6fazyVU7twVt1CCbZHDZXb7txrrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lenovo.com; dmarc=pass action=none header.from=lenovo.com;
 dkim=pass header.d=lenovo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=LenovoBeijing.onmicrosoft.com; s=selector2-LenovoBeijing-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8AIJiVMX/ydHUNNWlCdLBANJKUTqXiDNG65r+WELcE=;
 b=w/3Ybm5mO6anrhuFfoA6GlaL8rMCyKariZHA4G7v3fYTxzp2rCcIbw9nmpJp8k1Qh7g8v/wJADlrIZABzL1HtvbLbB/RErxPJEt3Kkty89MZ6YLAFWxmQjQNkbU+PiDkkSuj5EhtLJp1eUErUtf+Wkuy7LvPkWZS5qtg8J8Tz6M=
Received: from HK2PR0302MB2594.apcprd03.prod.outlook.com (2603:1096:202:c::8)
 by HK0PR03MB3713.apcprd03.prod.outlook.com (2603:1096:203:7c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.30; Thu, 11 Mar
 2021 03:55:50 +0000
Received: from HK2PR0302MB2594.apcprd03.prod.outlook.com
 ([fe80::55c2:6aa2:c195:848f]) by HK2PR0302MB2594.apcprd03.prod.outlook.com
 ([fe80::55c2:6aa2:c195:848f%8]) with mapi id 15.20.3933.027; Thu, 11 Mar 2021
 03:55:50 +0000
From:   Adrian Huang12 <ahuang12@lenovo.com>
To:     Xiao Ni <xni@redhat.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "matthew.ruffell@canonical.com" <matthew.ruffell@canonical.com>,
        "colyli@suse.de" <colyli@suse.de>,
        "guoqing.jiang@cloud.ionos.com" <guoqing.jiang@cloud.ionos.com>,
        "ncroxon@redhat.com" <ncroxon@redhat.com>,
        "hch@infradead.org" <hch@infradead.org>
Subject: RE: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard request
Thread-Topic: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard
 request
Thread-Index: AdcWGbcz5IZGSXRyQiiLc8MMhkpsuwAAFEYQ
Date:   Thu, 11 Mar 2021 03:55:50 +0000
Message-ID: <HK2PR0302MB2594AD3A6B5B44DB954975A1B3909@HK2PR0302MB2594.apcprd03.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [220.143.152.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1138425-4a28-4dc5-4934-08d8e4418f6b
x-ms-traffictypediagnostic: HK0PR03MB3713:
x-microsoft-antispam-prvs: <HK0PR03MB3713432A035681A90238BB8AB3909@HK0PR03MB3713.apcprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ka5XXwzB3kKxPCl6q0bko+obkntBbHd4j6wloyCXH4Ap7USLgzppG+2z1BM+HG3Oq+peeBpTj4qGTKspALuCcSYC76SlQo9vkwAZI5V1hXt5hfQQWPyUytrEqOQrENSy7GIRVCQMorM26xYCA15b7vlv72yTPVf0bGlNC6VlvZUTzLApaMTDm5+YKAr3loaGDRSG843QNr0T7erDTIa790Fh24/Ln6W7LQOEaZykjmRDIhDmuyzCfQs426BtPJ/cdXiow52VTwoOXJLaco2dVeVEtrFMbS7Zfcw9NWZnKC5WWXZTJGTaF4mEVjGFT9m/doobA73XhdbPaEITd0GRXYd5TAKL6C3Y+t68kuk1HAlGPghB/GSig3zS2odvIBAX8YDF4JHYLqeqPwsA/Tjh1bZ2OxRteRJoGXlKJpPnIMUa2rHQ5dmJzoggC+JdNetJSqDa5LOMWzG0AmBeEojg79F2/wi30qZgcTA5KK5TX3mQktPCrVbamt9rfAfO2KWWmON+Xr70iIWP2PyBVQsJSXNaxdexq0xH5G4fsqyQLY44zhlIfREEBiLXkodtd+zVXo/6GJMDi+CyIKFTv11SLtXz6hyrjre5WG/CWUdvY0KlVn47VpIf7dKH0n9YO54Qs8ISzIfxUVA6UD9P4AdhdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR0302MB2594.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(478600001)(86362001)(52536014)(76116006)(966005)(66946007)(5660300002)(66446008)(66476007)(6506007)(55016002)(71200400001)(9686003)(64756008)(53546011)(26005)(66556008)(186003)(8936002)(8676002)(2906002)(54906003)(7696005)(316002)(83380400001)(110136005)(4326008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dmtLRzA4VkpPTnFxS1g0cHpHM3B5alEyeTViNFZUMWxVL1ZUSXZTdG5TSkdh?=
 =?utf-8?B?UGdPWE90VGRrUHNVU3lSeTBLZmFBMzlrWHZRa25DY0xvYnFxRFFEV0F4UnRi?=
 =?utf-8?B?cHFWSnZqdzFrcUNFYzF3cDlZc2o0Y2wyNDNpV3V3R08rMVlQdThyYXBwUHNn?=
 =?utf-8?B?Z0RQQXdSMFRBZHZDME1UL2JNYXhNUTZvOVcxb0s3UHhQS01RSFBycDhuendJ?=
 =?utf-8?B?bE1IMHdZNXJ3ZjNTU0NxOVcrK1hmZ0RvZzhadmQ5OStwVDZ4akxiWXFueGRv?=
 =?utf-8?B?dEhrZC9Qd0RXOEVSeFFkRUZ3Z0ExU3NVL1c3NXVQdXpCaHJKSmhiTGVGWStS?=
 =?utf-8?B?ZXNOdXR1WmZJZmRpemZLUkJLSEt5VU1pTG9XODc0OGVrNGVmdmo4Y3dNcG5v?=
 =?utf-8?B?OW5Id0VGZ3kzQlVGNDNPL0g5RHBkc3Q5V0g4NW1RQkF6YTcwTHNzY2ZOWDRD?=
 =?utf-8?B?NkVod2Q2c0F0M0t1WXVObmxmN2ltZDBESHU1MjV2N0xYTVduQjF4aWIyMDQw?=
 =?utf-8?B?Y0VHck5KY1lEK0VLc3RmSXRnZWNLQ1g2TWdGb2JsdEhuTUlBVy9ZT1VHdUs1?=
 =?utf-8?B?ejJrVzg3SVhKUkFha1NpaVFpSmErOFJxWGVLdzJLRUlpN0YyOUpXVXJLNlhl?=
 =?utf-8?B?cjVEay9BaVBrSnc3V0w0elA5NExyL3FMR0twM3k5Vy9DMWpoNjl6ZDdhZkxK?=
 =?utf-8?B?L1I3NjJFTXVzNnhTdmZIdUZWYUdVdUdaY29qVGRpMThJWDlZMmhSSElUTy9N?=
 =?utf-8?B?bk1wUS9tZU45dnZ5cU9aRGhycGJBNi80WWQzMVRFMktRcnVoQ3ZoNUFBeWtD?=
 =?utf-8?B?VUdoMDVtcUpqQ2JzWmpnL3dQWDVLNExYRkRKSk1CelpVUHhqNlZCRWU4MDlB?=
 =?utf-8?B?Z2V1RjJnVVpldk1QdUVaMDlYRzhSRUN3ak0yVlV1dFBJb2RCaHNGM0R3SFAr?=
 =?utf-8?B?b2pUanZTTnZLc2JmZGtaSGk3TUFia04wbC9uRFdGYkJXSXNZeFkwVXBHZGtz?=
 =?utf-8?B?SG5mWHJxVnhQT0JveWJXOVdnci94dUxFc2J6MldzMStPcEFvQmhVenVFVUpD?=
 =?utf-8?B?eW5GN0cvQTJrQUhyQ29WVllQMWRtZmJ0Tmk5OCs3aEQrbnlOR252S1hLUkt5?=
 =?utf-8?B?RlhyVlIwVEVxNy9xNUl2WlJRNjQ0cHNPSUQ2MEc3TjdvZEcycVV3NExMZ2Uw?=
 =?utf-8?B?a3ZQVkpPQU5SczJ1L2oydVF0N1BFcDdZNFBPUW8xWFRlRmY0U2ZHallweUpm?=
 =?utf-8?B?YnNtclVQdVZCVGtOa3NZOTVGa05PbVk2bkoyUmJEQUdlaFlnU2owNndiaFJs?=
 =?utf-8?B?R2pxQkZnRHo3akJuT3pwM0hCa2xsdGxMVUVLS2FxUCt3MExlamRibXlqNWRs?=
 =?utf-8?B?U01FMUlkU0kwVlVzUFZya0I1THh5QWo4QTBIdTVibG1SZ053VjB1aHVFOFo5?=
 =?utf-8?B?cXZKN25yWmVKT0NrVnVnaDNaaFBYT0FEVFYvL1ZoK1FkUjlVRUpMQkRUdXZ4?=
 =?utf-8?B?MWpNak5OcGNxR0FDcUVHM2VNazV0M09Cc2VRZ0lDYVJubU5QT05ReCsrRE95?=
 =?utf-8?B?UWE4VmhvZ3RPRzlPM21randiSk1lU1ltd1hqVUZRSThOT2RqclZGYU9rRlB2?=
 =?utf-8?B?K1YvSkp5cVo4dmczS0M3NEorbTVFaS9KeDJUYmVwS211YUIvQkNDUVQxVGs0?=
 =?utf-8?B?dnJuaG1KcDVuUi9kbGE1djlCZFJYZGo2cVpvMVJlaDVGZjVJOTZpdlkxTCt0?=
 =?utf-8?Q?+G46YsCNOS3TXZ5hJw3qBal1gO+o8xkBWNYAeF+?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK2PR0302MB2594.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1138425-4a28-4dc5-4934-08d8e4418f6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 03:55:50.1755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NbWM1m+vQ9dkksP4Od5KesI6maqWqTm7RVjuQpCgLHeRz3L06ZSx42X4AO1HBXEeVz97V9PB5UsmwkvS/OupNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR03MB3713
X-OriginatorOrg: lenovo.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBYaWFvIE5pIDx4bmlAcmVkaGF0
LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDQsIDIwMjEgMTo1NyBQTQ0KPiBUbzog
c29uZ2xpdWJyYXZpbmdAZmIuY29tDQo+IENjOiBsaW51eC1yYWlkQHZnZXIua2VybmVsLm9yZzsg
bWF0dGhldy5ydWZmZWxsQGNhbm9uaWNhbC5jb207DQo+IGNvbHlsaUBzdXNlLmRlOyBndW9xaW5n
LmppYW5nQGNsb3VkLmlvbm9zLmNvbTsgbmNyb3hvbkByZWRoYXQuY29tOw0KPiBoY2hAaW5mcmFk
ZWFkLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0ggVjIgMC81XSBtZC9yYWlkMTA6IEltcHJvdmUgaGFu
ZGxpbmcgcmFpZDEwIGRpc2NhcmQgcmVxdWVzdA0KPiANCj4gWGlhbyBOaSAoNSk6DQo+ICAgbWQ6
IGFkZCBtZF9zdWJtaXRfZGlzY2FyZF9iaW8oKSBmb3Igc3VibWl0dGluZyBkaXNjYXJkIGJpbw0K
PiAgIG1kL3JhaWQxMDogZXh0ZW5kIHIxMGJpbyBkZXZzIHRvIHJhaWQgZGlza3MNCj4gICBtZC9y
YWlkMTA6IHB1bGwgdGhlIGNvZGUgdGhhdCB3YWl0IGZvciBibG9ja2VkIGRldiBpbnRvIG9uZSBm
dW5jdGlvbg0KPiAgIG1kL3JhaWQxMDogaW1wcm92ZSByYWlkMTAgZGlzY2FyZCByZXF1ZXN0DQo+
ICAgbWQvcmFpZDEwOiBpbXByb3ZlIGRpc2NhcmQgcmVxdWVzdCBmb3IgZmFyIGxheW91dA0KDQpI
aSBYaWFvIE5pLA0KDQpUaGFua3MgZm9yIHRoaXMgc2VyaWVzLiBJIGFsc28gcmVwcm9kdWNlZCB0
aGlzIGlzc3VlIHdoZW4gY3JlYXRpbmcgYSBSQUlEMTAgZGlzayB2aWENCkludGVsIFZST0MuDQoN
ClRoZSB4ZnMgZm9ybWF0dGluZyBwcm9jZXNzIHdhcyBub3QgZmluaXNoZWQgb24gNS40LjAtNjYg
YW5kIDUuMTIuMC1yYzIgKHdhaXRpbmcNCmZvciBvbmUgaG91ciksIGFuZCB0aGVyZSB3ZXJlIGxv
dHMgb2YgSU8gdGltZW91dHMgZnJvbSBkbWVzZy4gDQoNCldpdGggdGhpcyBzZXJpZXMgKG9uIHRv
cCBvZiA1LjEyLjAtcmMyKSwgdGhlIHhmcyBmb3JtYXR0aW5nIHByb2Nlc3Mgb25seSB0b29rDQox
IHNlY29uZC4gQW5kLCBJIGRpZCBub3Qgc2VlIGFueSBJTyB0aW1lb3V0cyBmcm9tIGRtZXNnLg0K
DQpUaGUgdGVzdCBkZXRhaWwgWzBdIGlzIHNob3duIGFzIGZvbGxvd3MuIA0KDQpTbywgZmVlbCBm
cmVlIHRvIGFkZCBteSB0ZXN0ZWQtYnkuIA0KDQpbMF0gaHR0cHM6Ly9naXN0LmdpdGh1YnVzZXJj
b250ZW50LmNvbS9BZHJpYW5IdWFuZy81NmRhYWZlMWI0ZGJkOGI1NzQ0ZDAyYzVhNDczZTVjZC9y
YXcvODJmMzM4NjI2OThiZTI1NjdhZjQ4Yjc2NjJmMDhjY2Q4ZThkMjdmZC9yYWlkMTAtaXNzdWUt
dGVzdC1kZXRhaWwubG9nDQoNCi0tIEFkcmlhbg0K
