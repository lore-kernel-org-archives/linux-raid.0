Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1477C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 20 May 2022 21:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349681AbiETVNF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 May 2022 17:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345724AbiETVND (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 May 2022 17:13:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D74ED7A1
        for <linux-raid@vger.kernel.org>; Fri, 20 May 2022 14:13:02 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KJBpBr019283;
        Fri, 20 May 2022 21:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=C+sns7PBiuVSHZMuQJiCWnqdOXZBnu6gjIRSaXbIKfY=;
 b=PXqqkEY7AoKsaf5jaj/ZecVYMja6uCzrRdhC/NTnaV20yI7wnj9r+w9Hn99h71soWYqR
 qCep46XW5q/GFh4Zcp3nvXBPMzZ67/BlvnpuFwB/Mo3ewb9aAz5S3jy0MzbDWFZHVPks
 Dh0dXYHAhqi7Mm3Hb72MhLY5VsBvG6r5nbg/vV8EHyBzyIg5yf00TYQSHmqSBApYsQI9
 pUm0R2taLCmiIySDPuyRnJb+GFoMiShVazWfs7u/Z6dlhczSXggtdhJD8BGLp0KG9tTz
 KOC7uz9/iTthabAhq/vTZ14/TgvY1oL3Ls47BZ7BEfVbc05D1dDg0Jhxkw6Qo6PX974d hg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aaqpab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 21:12:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KLA9Am005146;
        Fri, 20 May 2022 21:12:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6qcfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 21:12:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWnHA0iy1HD6v/JmTqFGrsRl/AKbGjrYucu2DzEswZIaR0dDhayMXtcPtpX5dzew2RDDcC+9YE6OUlAYm+Qwo/3l6L6+/oLilpXrWCzIlPI5p1538/LHmh1fewnEPOtew4+Of/Xq68lv4BFOTEQaxa7jwYhrI2Gs1r0AgtzYGDglo/mSdTL6/0nghCVDD6yr/iU4dukRH9kQSTgN3jEPUrq/Tef/LFu9QHItdbIDyN0tR7aBUWIXdMiFwJe/WPNTdFM+bPy4FUWTGnO3o7qOaJrq1Dn6pnPAvQBb28gKrPAf7silPD/CZAGuTQT/Ril7+IrGNH9/4kbV3+sl++rsQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+sns7PBiuVSHZMuQJiCWnqdOXZBnu6gjIRSaXbIKfY=;
 b=QTsgWcHxgS6h5vHCY3jphIUlehODeZpCZBEawnMruBhU+7WIkPp8aIfZDFf9SynPrFa07j7OPtApwp8R3JaM0Gk+ovFJsNgLWKJOjvw7+ZawlWDeYCrFeKoscubeIIwkzwN39fTIAynbAgakzv2fdhMgqBEmJlrI//SZiLGzPPqzgwqGw4Iozo9jrP5xzBTfaMX4Vt0iAR8OMCNkIAl+KQ0TNLjEfpm4btt8xUSL5wki8hlwt2ZM61B2w8IMeEMRu6JbcHF5m+D418hk+jxojdWnzJM03gnSPJ9Mvg1QvcPTfqt+iaC1tXTYdI5vCQ7UMUVlskE7h8z28/PbfJfSRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+sns7PBiuVSHZMuQJiCWnqdOXZBnu6gjIRSaXbIKfY=;
 b=vuxy0bj3isnur3pKeZwX2bvqODA8HXBeGFC0amz+sptso6ZRTIgV2VkXrqDKXJP7NiCNBxxh1V+xPqzymUNQe7y/XoIowuIrCIrLbpVoIQ7kzi3036/nP8/TcMPxEIm3tQiy6Xg9LiDjfpnyiAI4S2MbnvAZOcsP9nGyebMWHkU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BLAPR10MB5217.namprd10.prod.outlook.com (2603:10b6:208:327::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Fri, 20 May
 2022 21:12:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5273.014; Fri, 20 May 2022
 21:12:54 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Logan Gunthorpe <logang@deltatee.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] Resurrect mdadm test cases
Thread-Topic: [PATCH v3 0/7] Resurrect mdadm test cases
Thread-Index: AQHYZJC7fhbAHqB3w0++hqRxLPjFqa0oKnIAgAApKYA=
Date:   Fri, 20 May 2022 21:12:54 +0000
Message-ID: <F15DE600-6805-494D-99AC-497CA14127D6@oracle.com>
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
 <2a6073e9-12ea-f468-6bfd-92609ce824df@deltatee.com>
In-Reply-To: <2a6073e9-12ea-f468-6bfd-92609ce824df@deltatee.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b1a38fe-eaa6-4cf6-7a22-08da3aa581cc
x-ms-traffictypediagnostic: BLAPR10MB5217:EE_
x-microsoft-antispam-prvs: <BLAPR10MB52174A97A086DE7E8F3E367EE6D39@BLAPR10MB5217.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4WHX9FSUn8zDf0HykJR+W6pqQbUZfrVm19NXXBANEXy641jbtVmhBN959Md6i2SIOSfrTuqkP8P9khj0MX7JgRIqn5BawU1Z+FyQkRJLG4kevpPzzxZzJ3uL0uF3WmlRDNLijQIAoUhsjGIYuVd70RAvBJaWDAw0O2bt+Fux1F/bLgj1UDNr64ShI+gsebgKoEL62ZQYR/py4pzx+tOJW6aiVTQKG2Ha2BZR/EILI9IV+RJoFoR1vWUH2Zut0JzTxvzqdIP6z73bzbm673QJ95bAOwqIMfsVQ+oM90GkYR5bMcPRM66vSS6g4YbuXLIk1tiorXtam7dgsKoPltWzSrD9oBfio0PEEvEA5OcIB40rqmtaleolSPlmf4y5SecryT5S7ez35k1fQ7Z8tqZnM73JIJ/qjacjE+wi6QzEz+kiw9z7kvVSYlyGIdcsjLqymuGsfHOm+W1ZMFrIkgJN7KBOscHKbxIQNPvx+eX5/lXJqCaJJDJgY7qixmA3jss3YPHiKpPvzp5XXwLOKwhPt3062/n6wrJICQzBMxcskmCuoDWtO7f2qCQ2hGqAEzcocvt/5MDdkRBcC4bZV9wd6kJ/gvgQII+psqXfm1vxXVgnM1arVe3xissHxB8D1LFHXWte17A6JQ44Tq2bhU2OphTWh3Ee1WLb8c27YMKIDjxPSsjPj+0zoiW/bs4y5Wr0vMC++3qIimtaeMbDuzUB7Ceisu9Kqiz3OaV/uzaV/1eelyiNnA28mA7zaWTYVKsERGCE0EYraf+n6gLN22XJp5+x+IwEcpEYyP4uXB72n7HNHWx1GFEeQ35BPLzWxIp6iz9Fd5VZNSSlYpslA0BNKHv0moIHA3px+Zerz3Mj3dA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(76116006)(66476007)(66446008)(64756008)(66556008)(66946007)(6512007)(83380400001)(8676002)(2616005)(26005)(4326008)(91956017)(186003)(6486002)(33656002)(71200400001)(508600001)(6916009)(53546011)(6506007)(966005)(316002)(44832011)(36756003)(2906002)(122000001)(38070700005)(5660300002)(38100700002)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnlTckNBeU1sZVFqdm4zanhYTWh4MVN4ZzlzaW1xYVhKUkp5Y3pRZVBMVVRs?=
 =?utf-8?B?T3NBZEV5V1BrTWppdEQ4VG5TS1l0bGZzUFdMMkxtSWpPd0E4RzZsSVNDMkJw?=
 =?utf-8?B?MlVsNkVETXppcWNvNnQybWxLdFdOS3QxbllkMUNjZmtWMEdIcUFxRi84cGtJ?=
 =?utf-8?B?TGpvNjNDYmN3NzNRUVg5c0c0VkdtZ0hOVE0rWVlHNHo2aXhaN05nUjhLVWVo?=
 =?utf-8?B?anM2R2x3WEVwbXhnRUNJL3FsVi9nTzMyZ0hqYURVQ0pyWXZrcVh3YWhMbjE3?=
 =?utf-8?B?bnA1VTRYZ2U1cVdmUFAxdE1GYlBEblI0UjUyS1AzZDAyWGx5R3RrTjNSQmhv?=
 =?utf-8?B?cUtIdlFtUUJCNjYxYlpmK1FQeHdKQk90aG5lZ1RCOXNhcTEvdDJwRy85aFZ3?=
 =?utf-8?B?OE13MWJ6b2NyM1BuR29wT01OQW5wY242VTVRWHNHTm9vd3A4R3VrUnc2L1I1?=
 =?utf-8?B?V0xWR1ZTMmE3TStGUlh2WFREYWp5anp6SW1YZWV6L3hCRFNRNEFiTmoyRzV6?=
 =?utf-8?B?NThBamxvTDN6ZVB1dVRqVUEyQmg1T0twZUFaL3Q2UFk2Wk9IcnQrZ3dZVVR0?=
 =?utf-8?B?N2t4Y0UwdjZ5SG1kdmIxc3lkcjBGbUFwRUxrVUlVUVA1L3JIeS93Smlrakp2?=
 =?utf-8?B?OTFZQWZuaE9nTnEyTFdUK0xvVVE5RjUrSk5NdW91Vi9kTHBYeUZOakxwQ3Zu?=
 =?utf-8?B?QVNDNFlWZEV4dDB4QzhhcGg2MFhLV1Q3VFIvcG8xN3BEVDRFY3pUMTB6WWlS?=
 =?utf-8?B?NGtwdlhNY1g0a3QwRFBkbHEvanRJaUs1ZjVsU3pxdEZsc2t0WnFReHR0OUVE?=
 =?utf-8?B?UGFxby85eXh3eVE3eDh5NG1SYUFyeVlpVEZOeTRkYkdPMm10NnpabHdVWVkr?=
 =?utf-8?B?Sk1TczdRU3AyTTZUSzdTSDU3V3BsMzF0c3E2MzZQK0hjQW42SERUVS9jTWRv?=
 =?utf-8?B?TFFPLzJEMkFKQTZPWWZETHlVY2hkOFpOWXowbXJreFNLSndUNnBaSGtHMTZn?=
 =?utf-8?B?UjIvdERYdUtSdHFwOGFzQWE4T1ZNTVJ2SG1hR0ZVUGc1cWV6Y090dC9xemZR?=
 =?utf-8?B?ZFk2SGVPZ1U3bThJSDA1MmFEMEZNa3E0Mkswb2JiSzlKRUhvMm8wdFJqcmlQ?=
 =?utf-8?B?TVN5VExha0JKQ1FUMTd1b3FCTnl6dFZBekRhcWJ1cFJJbzc0ZVlxUFhGb0p5?=
 =?utf-8?B?RnJmOVQxeVhVSWNVSllyS2VzbTJqeU5mSmZHQ1AvSUx2VC9US28vRW9CSXZF?=
 =?utf-8?B?NHdGYzEzQW83ZU04RC8ycGU0VnAzOEN5ZVVSOVNqeCtBQnloc1VVdk9DekVm?=
 =?utf-8?B?d21tdEFpQkZONlFuOHRSeXJJMHppb2lMWS85bklPZFlFNVRUcC9nempERUU4?=
 =?utf-8?B?Q2owS0UyK1ZnekRkRk1TVVNtbFBPeG4zeWY0UVhOQUxOZkY5Q0lXNmhwTUZL?=
 =?utf-8?B?eElQMUJ2dTZ5MUtoRFFUN3ptWE1uRGgybFp0YWExaXFwbWxZVVZqU1djdjlh?=
 =?utf-8?B?d0g0b0xnZysxZGIzdDdoeHZpaXZtUk8vUjk5RE43TER0N21JYkJ6bjlnTHNq?=
 =?utf-8?B?clhrRktmTHNpTGwzSC9wK2tnaHFlNEk4YWJONjdrbUNDcnJ6a3YvdTdNSUg1?=
 =?utf-8?B?eU1OTTQ0cDRLRnFCbVdvRkZZTlJ6K2o0UDVZWmxTVWwzN2VoRjRacTVaMlhM?=
 =?utf-8?B?WkpJNzM0NktkYXA5YmY0aElqMm5ra3ZvcXVhT011eUVHWTZHS2ZrcVUyTTRP?=
 =?utf-8?B?OVhpTGRITHZ1WGpPbXpMMFFxeGZhSENyN281dktYWERrZGdzdzZYM28wUlEx?=
 =?utf-8?B?UWw5Z005aU5nNVhVVlprSUtsRzB0UUJ1b2xuOVc1VVJrMTV0Z3d2RCt0SFNw?=
 =?utf-8?B?STVHR2pJVi8wT3BacXdKWHBqcHNlWFl3MjNVT0VwcVFiNTNlMmlXeUtJTzQz?=
 =?utf-8?B?MGY1YUVsOXVLeThlM0lsV01ubTYyaDFENFZBYUdBeDRsQldBSzBJYzZneDJR?=
 =?utf-8?B?bHUxVGJJd041QjJnZmZTa091c3dTc2pSRytzVVBhUjBkakl4czVubThkdVI4?=
 =?utf-8?B?QzlJbm03cGlqNjh1aktVUVVVYUgyOG9uNTdldlZOWElBNzhIcDh5TStKcWw3?=
 =?utf-8?B?U1VubU0yNEJoUFJjdHJZSVV1V1NrMHpYdWZnM2hzUXpWSDc2U1lJRkNmTnZp?=
 =?utf-8?B?eUVVRTFKZUt2VGFXNzYxUEdROW5zTVVwZ21KQ1U2b2ZqeGFjWE40ckk2TnlK?=
 =?utf-8?B?Snd2a2RjNzAyQ09ZaG0yU21RRjUrd0hXOVFvSDZsL2JGR2MrYk05dkg4cEpD?=
 =?utf-8?B?ZDhDalFWQ0dLL05JTG1MbGxTeXk3Z3kxQi9HWGoxRjNFRFYyOXpOcmFEczc0?=
 =?utf-8?Q?m/K7mBzmOfSSDqeWTbxDqlgpMRT9K/nzlvhRI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBADB58C45764146960F542851FB72AD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1a38fe-eaa6-4cf6-7a22-08da3aa581cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 21:12:54.7866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6o537UZxuH4g6NVvFm/Xekrqjd2k4rCeL7WudXR2zAK9TSEA6ZG9vlyKGaJf/s/NK7qnvmr0efmHeS9Tie+uHjy7XlqtMMviYTx3f2HFBe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5217
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_07:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200131
X-Proofpoint-ORIG-GUID: 5ZDdTIwWl7H-mCS0B6FdaSDe9NCnG0b7
X-Proofpoint-GUID: 5ZDdTIwWl7H-mCS0B6FdaSDe9NCnG0b7
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

SGkgTG9nYW4sIA0KDQo+IE9uIE1heSAyMCwgMjAyMiwgYXQgMTE6NDUgQU0sIExvZ2FuIEd1bnRo
b3JwZSA8bG9nYW5nQGRlbHRhdGVlLmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gSGkgSGltYW5zaHUs
DQo+IA0KPiBPbiAyMDIyLTA1LTEwIDExOjA5LCBoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20g
d3JvdGU6DQo+PiBGcm9tOiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNs
ZS5jb20+DQo+PiANCj4+IEhpLCANCj4+IA0KPj4gSSBhbSBwaWNraW5nIHVwIHBhdGNoZXMgdGhh
dCB3ZXJlIHN1Ym1pdHRlZCBlYXJsaWVyIFsxXSBhbmQgcmVjZWl2ZWQNCj4+IGNvbW1lbnRzIHdo
aWNoIHdlcmUgYWRkcmVzc2VkIGluIFsyXS4gVGhpcyBzZXJpZXMgaXMgYW4gYXR0ZW1wdCB0bw0K
Pj4gcmVzdXJyZWN0IHRoZSByZXZpZXcgcmVxdWVzdCB3aXRoIGNvbWJpbmVkIHBhdGNoc2V0IHRo
YXQgcmVzb2x2ZXMgZXJyb3INCj4+IGVuY291bnRlcmVkIHdoaWxlIHJ1bm5pbmcgdGVzdCBjYXNl
cyBmb3IgZWFjaCBvZiB0aGUgcmFpZCB0eXBlcy4NCj4+IA0KPj4gSSd2ZSB0ZXN0ZWQgdGhpcyBz
ZXJpZXMgd2l0aCBsYXRlc3QgNS4xOC4wLXJjNCsga2VybmVsLiANCj4+IA0KPj4gWzFdIGh0dHBz
Oi8vbWFyYy5pbmZvLz9sPWxpbnV4LXJhaWQmbT0xNjI2OTc4NTM2MjIzNzYmdz0yDQo+PiANCj4+
IFsyXSBodHRwczovL21hcmMuaW5mby8/bD1saW51eC1yYWlkJm09MTYzOTA3NDg4MTIwOTczJnc9
Mg0KPiANCj4gSSBoYXZlIGFsc28gYmVlbiB3b3JraW5nIG9uIHRoZXNlIHRlc3RzIGZvciB0aGUg
bGFzdCBjb3VwbGUgd2Vla3MgdG8gZ2V0DQo+IHRoZW0gY2xlYW5lZCB1cCBhbmQgbW9yZSByZWxp
YWJsZS4gSSBqdXN0IHNlbnQgYSBzZXJpZXMgZml4aW5nIGEgbnVtYmVyDQo+IG9mIHRoZSBrZXJu
ZWwgaXNzdWVzIHRoYXQgSSd2ZSBmb3VuZC4NCg0KTGV0IG1lIGxvb2sgdXAgdGhlIHNlcmllcyBm
cm9tIHlvdSBvbmxpbmUuIEkgaGF2ZW7igJl0IHNlZW4gaXQgc2hvdyB1cCBpbiBteSBpbmJveCB5
ZXQuIA0KDQo+IEkgaGF2ZSBhbm90aGVyIHNlcmllcyBpbiB0aGUgd29ya3MNCj4gZm9yIG1kYWRt
IHdoaWNoIGhhcyBzb21lIG92ZXJsYXAgd2l0aCB5b3Vycy4gU2VlbXMgeW91J3ZlIGZpeGVkIGEg
bnVtYmVyDQo+IG9mIHRlc3RzIEkgaGF2ZW4ndCB0aG91Z2ggYW5kIHZpY2UgdmVyc2EuDQo+IA0K
DQpZZXMuIEl0IHdvdWxkIGJlIGEgZ29vZCBlZmZvcnQgdG8gZ2V0IHRoZXNlIHRlc3RzIHRvIHdv
cmsgbW9yZSByZWxpYWJseS4gDQoNCj4gWW91IGNhbiBzZWUgbXkgV0lQIGJyYW5jaCBoZXJlOg0K
PiANCj4gaHR0cHM6Ly9naXRodWIuY29tL2xzZ3VudGgvbWRhZG0vIGJ1Z2ZpeGVzDQo+IA0KPiAN
Cg0KV2lsbCBwdWxsIGNoYW5nZXMgZnJvbSB5b3VyIGJyYW5jaCB0byB3b3JrIGluIG15IGVudi4g
DQoNCj4+IFN1ZGhha2FyIFBhbm5lZXJzZWx2YW0gKDcpOg0KPj4gUmV2ZXJ0ICJtZGFkbTogZml4
IGNvcmVkdW1wIG9mIG1kYWRtIC0tbW9uaXRvciAtciINCj4gDQo+IEkgYWN0dWFsbHkgc2F3IHRo
aXMgaXNzdWUgdG9vIGFuZCBoYXZlIGEgZml4IGZvciBpdCB0aGF0IGRvZXNuJ3QgaW52b2x2ZQ0K
PiByZXZlcnRpbmcuIFNlZToNCj4gDQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9sc2d1bnRoL21kYWRt
L2NvbW1pdC81NzVlMWRlYmI5ODNkOGVkODM3ZTY2NDYyNTI5YWVhMDI1MTI5ZjY1DQo+IA0KPiAN
Cg0KSG1tLi4gZ29vZCB0byBrbm93IHRoYXQuIEkgd2lsbCBwdWxsIHRoaXMgY29tbWl0IGludG8g
bXkgdHJlZS4gDQoNCj4gVGhhbmtzLA0KPiANCj4gTG9nYW4NCg0KLS0NCkhpbWFuc2h1IE1hZGhh
bmkJT3JhY2xlIExpbnV4IEVuZ2luZWVyaW5nDQoNCg==
