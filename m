Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3E4C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 01:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BA80611F2
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 01:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbhDMBoM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 21:44:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35904 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240800AbhDMBoJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Apr 2021 21:44:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D1dCYe019463;
        Tue, 13 Apr 2021 01:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=d9EK5Iz9ES0wC9i5OOVth8nOXpHcEk/yiIX/WYt+lqs=;
 b=vyF5z0hTKTeIp17dwE4Ru6SbFlpWvotOVkSjgRv7LOY2kmU7G029z+GALHyqxCm7Vjo2
 xDyO/bJAFJ7SvOO0hi+7I8lXchhad9+iyKrVZPMdiHrQ8k/fQFB3Jbvy2IuZKQP5VKhl
 OEeLAv6Fx/11HDvA/eBoN/Xuo/ftaL4GWGhl16iLf1hzbNauzX+fl3dw1Q3fwX9Acihv
 ZvKPKRfoe56JUJkzJ05kRgZgTdSqxb2Bu8/XHueBzSxg6WBa4T4VaFKyXtmEK9U3N1aD
 O6q1r0CnQTViw8flJ6fCwH8YnzB5QZ5JPloSh5PEOMKmcZ/PMN3TSVDvQ2sdbDbdvk4N sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nndga7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 01:43:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D1ddO0078058;
        Tue, 13 Apr 2021 01:43:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 37unwy5718-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 01:43:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORf1orMNp27dePouTB4zYz2x9NDWehdybT7QIWAsYXLKqn5XQiWLfUaYvtDtzqfH0d00qs4dNACx9W5RLp86RJ3WNIfBJmAmsRPVMczLHaxE18Z1xlBsdVc36qC2bTeFQYmVnnQdRCzGFzYnWWVBj4LBoMmLhinJpqYyIjYeKr+ItBi6XSiircN8osDcxoMUTXrlQe0m08Kk5Mi7q8BX7tovUD8+QK84oNpJbtQj9V8K84m1KVSxEgpv0zldTstH/NjIjVpCisW7roDTbiS8dNr47ND/Us1/wlY2kS6S9MbptelYoCVymKVDE1wATHarLE43lOKFR8GV7uxEm6v3WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9EK5Iz9ES0wC9i5OOVth8nOXpHcEk/yiIX/WYt+lqs=;
 b=fu5F7DZ+0zkzi1LB6fg76S104ON2zLwXPzFT7WmHrqHARDU23pX52GrQpajyeUiHaXc/eef/zPKKqm9odq9TpvSNdZYlILa/bYx29tv/j9mLPjLfwiw9x0ft1dyetEtkPlc7tMNq12/ZVeJs7s6K0BbilK3eeR+uL6B9Elip5ZcUK5MHG/SrZ5kOXTny4gXGsSHfCRkP5V1bJfF7PX7DHsuA2As1m6k5VCKcvNwqceau2C0e8XKR7yUDGNPK5mXb4a/vTqA3G/VNEx+liJmq5LbP17kOE9oiuBb21s8hb7tru2ieGT3ZnLvQkARPzz73v2Q1i3o/Toi8nAcAUScyPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9EK5Iz9ES0wC9i5OOVth8nOXpHcEk/yiIX/WYt+lqs=;
 b=flpxKNsJOCjpbuhSBEY23B1jvao8Ac4H4+VjX8VBltjEdXC5VFIjjqjvaqIOZH0ge3utNX2CbL0mqUp8OYmx9UiNcytSVPbGfWdQI88ORhqWp0SkOxel+pZrLK6i5MWH7k/GQKkpKNm7C2WpRhd009uIBaxP4fPmbTsKsPcI2XQ=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1575.namprd10.prod.outlook.com (2603:10b6:903:2d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 01:43:41 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974%2]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 01:43:41 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>
CC:     "lidong.zhong@suse.com" <lidong.zhong@suse.com>,
        "xni@redhat.com" <xni@redhat.com>,
        "colyli@suse.com" <colyli@suse.com>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: RE: [PATCH] md/bitmap: wait for external bitmap writes to complete
 during tear down
Thread-Topic: [PATCH] md/bitmap: wait for external bitmap writes to complete
 during tear down
Thread-Index: AQHXMAFSs21VfmdNgESJ2crqtK41caqxq7EAgAAAziA=
Date:   Tue, 13 Apr 2021 01:43:41 +0000
Message-ID: <CY4PR10MB2007581CF5DF008E4C1BD851FD4F9@CY4PR10MB2007.namprd10.prod.outlook.com>
References: <20210413010703.GA13817@oracle.com>
 <3cffdb3d-b5ee-5c50-32a0-328fc806d4b8@suse.com>
In-Reply-To: <3cffdb3d-b5ee-5c50-32a0-328fc806d4b8@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [73.217.118.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b55ac3ad-1212-4339-0b31-08d8fe1d90e2
x-ms-traffictypediagnostic: CY4PR10MB1575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB15752BCE8AA8852B2C68CA3AFD4F9@CY4PR10MB1575.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9jbVZ8HTkPIIyoNwD7kmdG9qm0rvy8onGocs+DY64NYhMsR3AcZXTrhFFEJcj2BbEWBKqcV164xi2eJfwHMEjqF9vgKqfwbOKZnMX2PXni25vX/sZl8XDY65DDItnPZe+X67rnba2xaeh6/dX92YBM4xUeglvKKrMdmRBpWCUeQlmACT/6+Sjs+akHmlMCj+1RHzj3gE4PVKcsn9Vk50eABLTx5P8zuVskJZmLu+Ulp2Pgg9eoDmR5eJKtl3f5sbUpbrvktfeiLvUFwTSbYTk75y4Hx5LCzzA8f/dV3q/NvQ74TCACmvJYNiPq+8c5LmgNAl4wFpJNd1GKa7L+HJ6GhYW1MLe8ax83AAaSCuscA5b5pgEegonL3BDL/bOjmG3hruvot1tRT6X2Isl6DasYLGyO1ZhMHqk55xf7xyYC8Hx8hrPbQZYrzrqP6O51RlSf6wdN45yRMwd12C+0mxd8KMlEpXP7OBDTD+zoYz8KfIpGWGbv3Wv1buyUuMqb6foE8cNbG7PDXLol+K9PNcOENwghwD2yxn2lwlevmwIfhcbC2uAd/QR48fp9XGyqhJ+KIBM2541OnWwgT1m2p7zJFSJDRnFNI379Xz2voF48I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(366004)(136003)(66946007)(316002)(66556008)(44832011)(66476007)(8676002)(76116006)(2906002)(52536014)(122000001)(64756008)(55016002)(107886003)(7696005)(66446008)(86362001)(54906003)(83380400001)(33656002)(26005)(4326008)(186003)(6506007)(53546011)(38100700002)(5660300002)(110136005)(71200400001)(9686003)(8936002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VWxSQlNsMUNhYWxFTkVjQTgrcXBCK2RwUTgwcUxCVGRGSWRIY0tkdDhEbURq?=
 =?utf-8?B?WVoxRHU0SDdMcXVtV2JaS1pMYkNSWDdjSVYzY2hqZnc0ZWJOY0xXZlBIYzlC?=
 =?utf-8?B?VFpUNExsVTJNVEhGRjUrVUFuZDY4a0x2MnlLMk5LL2l1a0UvWUpubHp6TmZN?=
 =?utf-8?B?alZTbHlzWDFkWWV5OUJJeVlZcU00L3dVTERxaVU4RVF2YzA3ZDNiYXlMTjFD?=
 =?utf-8?B?SjNhWmtVNXgzaEdPUmNxOUszQVMyVzV0U2VZS0FqSkd5M0FETUYrRTc4SnZj?=
 =?utf-8?B?cFU0V2Vhc1c0cDdpZkZId3l6WTMzbVc0OVByaE1nVFZQbTcwYlUya3FSRXZn?=
 =?utf-8?B?N2wxeU5qNlNiZVYxTHQwelRVUnRkS3ZRTmU2VW16NVJIWFpFaEZaVE1LQlI3?=
 =?utf-8?B?MEN3aCsySmZwakRHOFBTeWJYR0RmQTZkZFA2M3NRMWsyWUNMd0FRUUwzNy9X?=
 =?utf-8?B?YVBJOGx1U3RVbGw3cnJIVmpBYlAwRmJzeUZydVlBcUh1cjhrZEtPMU5STDI2?=
 =?utf-8?B?dzdSMDdjNVJYWUh1ZnFHZkZtTnNYVFlIZlkxWkxhSnJRYW1vY01EVmNhYU9W?=
 =?utf-8?B?VGZqbVNlNzlsTnZrRGkwQy8zb09qMlpjb2N2MDUvWDRoNlNCOExuSXAvMWE3?=
 =?utf-8?B?eXdBZjVITWRnaE9sVHJscTF3UDA1UXNGUGpkMU9NWjFGY25CdEJsaHNuZ2lq?=
 =?utf-8?B?ZTdxWFdGdGFya2hzQm4zRjYvWDM3WEEvWjJFNUQ0T0ttcEdpNmVIVVBmNHdT?=
 =?utf-8?B?UWtBYkxCZmRlRFIxeERkM3JWV0h1TC93SEtwSHpxOGVEY2VFNEVHWlRSdEVK?=
 =?utf-8?B?TnhndTFQaXJlTXc3bndsc3hibk1tMk9OTlVIdjFhY1VvcjNkYzkxM2xsQ09L?=
 =?utf-8?B?ZkJVdjI0MUtMeEpjTzViSEhCRG9sU2tzVkpEbGdHUWRNaTEzZ2JMY3l6d0ho?=
 =?utf-8?B?OTlyYzc4cjJDeHJVRGZnSEhOSHFhQTkwY0JCTkFucUREZnhLbDV5c2d0L0JL?=
 =?utf-8?B?VVVtbGVLcEN5cnYwMVpod1Y5WWpqQWQ5NVpQTzVLMlI3WjVhOThaQmRBQWlN?=
 =?utf-8?B?SUVBblljVTB1dnk0bHo2RlhWOExKVXdlTjBkMTk4UURpM3JGWC9aMjJGaXps?=
 =?utf-8?B?T1lyN0RkKzBoWklFaFZIUTUvWWhKd1JCV2JTK1ViMnUrekplZEJHVWwxcE5k?=
 =?utf-8?B?RjhRQ3JKdnZmajJTTWVXNVJMU1J3SURmMzh1Z0xEeklPNDZKVWlqUGZ0Nnl3?=
 =?utf-8?B?RHlMcUhOWHZtVU5uMHV4a2V3KzlXalNvc2dqTU9ZeHJDM1p2am9GN25CdWlu?=
 =?utf-8?B?VFZ6YURyankwY2pvUkxzTEhXd1FsRkdqd2pvdi9xMWZVdkNmNVVpZmY1TFMw?=
 =?utf-8?B?Q2hhNi9WQ2VwRGxhN3RoREh4MjhQUmliVk5KcGRQeEhrdHplN3JSU295Mk1Q?=
 =?utf-8?B?L1F2cHFFK3hGTllMaFQwQTJGT1J4NEJvSVVEdmdma29CU0Q4QUhRVUNEci9N?=
 =?utf-8?B?TEJnTHVDVHVnVVhyT2lVN1JPREdwajFtMmNmK2UwMHBOUlRoSS9mV3hwemR4?=
 =?utf-8?B?L0VKVVpXUUZjQk5LeldZbDloczhOd2NnemVSUG8zN011a3NHWG1USmVxTTRK?=
 =?utf-8?B?VmFicXNFTDBQNXV3ZTlaRHNIZHVrYjUzcjZNTytRa3l1elNJVThXSExHeTNu?=
 =?utf-8?B?NE02U1BNT1N3ZTM0eWVFcWVNdG9nT2UyODNNdTIvR2YrWG5EUk04dkdvdlIz?=
 =?utf-8?Q?J4Q7blBIkzR3Vfmyw8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b55ac3ad-1212-4339-0b31-08d8fe1d90e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 01:43:41.0535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AMo7tUWo3qTIRQQ/5zWdhIwlkmXX7KZKxoF/Vkz4W/hO+ZvY514aCT5998/O2fjl53vefnovEOJ/yn/QeghYLvhLOyXd64vD0fTXF9FMV9L+Pzg9RLWA8EnUY2OVKMw7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1575
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130009
X-Proofpoint-ORIG-GUID: xopKvY7fkHW3qIi0b5NQ_mvSmwLOceWG
X-Proofpoint-GUID: xopKvY7fkHW3qIi0b5NQ_mvSmwLOceWG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130009
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogaGVtaW5nLnpoYW9Ac3Vz
ZS5jb20gW21haWx0bzpoZW1pbmcuemhhb0BzdXNlLmNvbV0NCj4gU2VudDogTW9uZGF5LCBBcHJp
bCAxMiwgMjAyMSA3OjQwIFBNDQo+IFRvOiBTdWRoYWthciBQYW5uZWVyc2VsdmFtIDxzdWRoYWth
ci5wYW5uZWVyc2VsdmFtQG9yYWNsZS5jb20+OyBsaW51eC1yYWlkQHZnZXIua2VybmVsLm9yZzsg
c29uZ0BrZXJuZWwub3JnDQo+IENjOiBsaWRvbmcuemhvbmdAc3VzZS5jb207IHhuaUByZWRoYXQu
Y29tOyBjb2x5bGlAc3VzZS5jb207IE1hcnRpbiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9y
YWNsZS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIG1kL2JpdG1hcDogd2FpdCBmb3IgZXh0
ZXJuYWwgYml0bWFwIHdyaXRlcyB0byBjb21wbGV0ZSBkdXJpbmcgdGVhciBkb3duDQo+IA0KPiBP
biA0LzEzLzIxIDk6MDcgQU0sIFN1ZGhha2FyIFBhbm5lZXJzZWx2YW0gd3JvdGU6DQo+ID4gTlVM
TCBwb2ludGVyIGRlcmVmZXJlbmNlIHdhcyBvYnNlcnZlZCBpbiBzdXBlcl93cml0dGVuKCkgd2hl
biBpdCB0cmllcw0KPiA+IHRvIGFjY2VzcyB0aGUgbWRkZXYgc3RydWN0dXJlLg0KPiA+DQo+ID4g
W1RoZSBiZWxvdyBzdGFjayB0cmFjZSBpcyBmcm9tIGFuIG9sZGVyIGtlcm5lbCwgYnV0IHRoZSBw
cm9ibGVtIGRlc2NyaWJlZA0KPiA+IGluIHRoaXMgcGF0Y2ggYXBwbGllcyB0byB0aGUgbWFpbmxp
bmUga2VybmVsLl0NCj4gPiAuLi4gLi4uDQo+ID4NCj4gPiBUaGUgc29sdXRpb24gaXMgdG8gY2Fs
bCBtZF9zdXBlcl93YWl0KCkgZm9yIGV4dGVybmFsIGJpdG1hcHMgYWZ0ZXIgdGhlDQo+ID4gbGFz
dCBjYWxsIHRvIG1kX2JpdG1hcF9kYWVtb25fd29yaygpIGluIG1kX2JpdG1hcF9mbHVzaCgpIHRv
IGVuc3VyZSB0aGVyZQ0KPiA+IGFyZSBubyBwZW5kaW5nIGJpdG1hcCB3cml0ZXMgYmVmb3JlIHBy
b2NlZWRpbmcgd2l0aCB0aGUgdGVhciBkb3duLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogU3Vk
aGFrYXIgUGFubmVlcnNlbHZhbSA8c3VkaGFrYXIucGFubmVlcnNlbHZhbUBvcmFjbGUuY29tPg0K
PiA+IFJldmlld2VkLWJ5OiBIZW1pbmcgWmhhbyA8aGVtaW5nLnpoYW9Ac3VzZS5jb20+DQo+ID4g
LS0tDQo+ID4gICBkcml2ZXJzL21kL21kLWJpdG1hcC5jIHwgMiArKw0KPiA+ICAgMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiANCj4gDQo+IEhlbGxvIFN1ZGhha2FyLA0KPiANCj4g
QSBmZXcgaW5mbyB0byB5b3UuIElmIEkgdW5kZXJzdGFuZCBrZXJuZWwgcGF0Y2ggc3VibWl0IHJ1
bGVzIGNvcnJlY3RseS4NCj4gMS4NCj4gWW91IGNvdWxkbid0IGFkZCB0aGUgbGluZSAiUmV2aWV3
ZWQtYnk6IEhlbWluZyBaaGFvIDxoZW1pbmcuemhhb0BzdXNlLmNvbT4iIGJlZm9yZQ0KPiBJIGdp
dmUgeW91IHRoaXMgbGluZSBpbiBteSBlbWFpbC4NCj4gQnV0IHRha2UgaXQgZWFzeSwgeW91IGNh
biBhZGQgbXkgbmFtZSBub3cuDQo+IA0KPiAyLg0KPiBUaGlzIGlzIHYyIHBhdGNoLCB5b3Ugc2hv
dWxkIGNoYW5nZSB0aXRsZSBmcm9tIFtQQVRDSF0gdG8gW1BBVENIIHYyXSwgYW5kDQo+IGFsc28g
bmVlZCB0byB3cml0ZSBjaGFuZ2Vsb2cgaW4gcGF0Y2guDQoNCk15IGFwb2xvZ2llcy4gV2lsbCBy
ZXNlbmQgdGhlIHBhdGNoIHdpdGggdGhlIG1vZGlmaWNhdGlvbnMNCg0KVGhhbmtzDQpTdWRoYWth
cg0KDQo+IA0KPiBUaGFua3MsDQo+IEhlbWluZw0KDQo=
