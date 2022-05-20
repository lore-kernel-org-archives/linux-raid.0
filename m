Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5070FC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 20 May 2022 21:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351331AbiETV0S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 May 2022 17:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiETV0R (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 May 2022 17:26:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD0039828
        for <linux-raid@vger.kernel.org>; Fri, 20 May 2022 14:26:16 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIoCSI004434;
        Fri, 20 May 2022 21:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2TmKynw1IEhJgrASW+3qHFlyX36C2hN7LjOOXcyVngg=;
 b=ljAPNzIHsuCyKiakgzCnA1+Q+8dGibx2sxguwSbYbCDVN2zPvGAsD+7GS9cz9JnTyEV+
 QtjoTeWAuEbA4LdR+O/QobAl2SVnz0NSHSuWZpcTSsZqA00Ge/44wTUNOdFVt19CkFQT
 j7EiMo2ETze50HL2SipDuLdGPSZQdBIbMCl37B8QB4wShJYDM3AfKabx6PoktO7HKhPK
 w5mMoV4r22jq96yOK9cfdlnpDJ2Zmg2tuYFOfZj7wvp1ZZVlpz7AnehILH19EHiXJ8xt
 E45LYtwCuyCRjDzZcAhROA9YyqnbUJVW0wBVgq4aZEk7dMGsNcQQnoMazTh9GPHbYcJH 4g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucfp8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 21:26:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KLCFnJ001378;
        Fri, 20 May 2022 21:26:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v6cutd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 21:26:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ha5QE9m3b2nm4D843rZBY5h+8P7QT4shpkVohAKv0rqSM1OYVVYRVMuABpTj6smn/68WS3OPD5NtyjdwjYjqayTnqJmjdsZzgbGwYWuRqKDJhjXM5c26SUOKUzgTnRwR0YUeZ5XowOv1D2s915QLvz2S1GdduVrFsdClvesnT41Hbk1soLCIVKZayLpAny55wwBszbuZhFjv+jT3KyaEhaW6q6l8pg6xZNkZnPO8gmVbD8BAAIeN76UTsXGqyhYePq/y+MNlifsqX6spi3X5WlWAXXcza9cOlKMiPwe421foppAAGR9ZvbpnCarJ4TTw1WqeDRshXWAV+Yrvwt/QKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TmKynw1IEhJgrASW+3qHFlyX36C2hN7LjOOXcyVngg=;
 b=bE8Mp4riQRJM4VJc3gTJ3S+Iu0cUWW830jucB2ueKEFeejMvfX8/DrJ6ymqmfYu3kgiFjZP6XGFc7XiXk6MCwGjGzzRLeEUKslyxpe++rKh2R+RLwH/1kW/70p3aJq8W50ANJbyK58DC1Sz/NrEDR8gM0x2KAwZWGgxIBVgokgbAdfNToYim9LduW7xuTdIfUi8i81jtFxyMCGr0zBBEWiHjtIXAMD5Ab+DyK3i6Z8k161IJsPHYPO3EROmakSGlyRkoI5iIp+Rw8LY7oYIEIHblAg3Rz7HLW8ZAbKY9NfWZFhtvEGseimnvzEah0vXhAep1gZDQx2PGXVg8wD2Kew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TmKynw1IEhJgrASW+3qHFlyX36C2hN7LjOOXcyVngg=;
 b=EwMcDD6ezTb+Xczncd1lXMoBocGp5+uUJr6h0/UWU+LCf63jSm6HqG+rKRnGkhrdoVNYHoNFfKTG0j7N/4SyA8Q6oYYdmQ1LtvjzJTvNEN6FX8+MJGafxI6IaryqELoxJ3lvVM86VyGznZdzr2Ur7+cwggTjitumOkCeTibRl24=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 21:26:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5273.014; Fri, 20 May 2022
 21:26:08 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Logan Gunthorpe <logang@deltatee.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] Resurrect mdadm test cases
Thread-Topic: [PATCH v3 0/7] Resurrect mdadm test cases
Thread-Index: AQHYZJC7fhbAHqB3w0++hqRxLPjFqa0oKnIAgAApKYCAAACTgIAAAyAA
Date:   Fri, 20 May 2022 21:26:08 +0000
Message-ID: <EA6887B4-2A44-49D0-ACF9-C04CC92AFD87@oracle.com>
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
 <2a6073e9-12ea-f468-6bfd-92609ce824df@deltatee.com>
 <F15DE600-6805-494D-99AC-497CA14127D6@oracle.com>
 <978a66e2-c2c2-1365-a620-f43bb38fff26@deltatee.com>
In-Reply-To: <978a66e2-c2c2-1365-a620-f43bb38fff26@deltatee.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1e0ba49-3050-42a4-1ed6-08da3aa75ae8
x-ms-traffictypediagnostic: CH0PR10MB5194:EE_
x-microsoft-antispam-prvs: <CH0PR10MB51948DB9D9DB08EFBE983DCAE6D39@CH0PR10MB5194.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8fvug+0cGtyd/QJnnN17hFwxwrwei80ss1JvKGytXlXc8KBSNOgsXcBOVqtkteeuYqhn918mkMSp4vNb9qn8GzIVtmPl/GVFs4ZYe6B/BJJs5DCewl75VYGP8xgMGoRDiMDUsqbyUORRGqeHH23tGjnrvw0hDRv8RJ8Dbgi0NeU7k5lanPizzKC8rONOIyxhLJKMeqCO4szD2qnrf9zFsBx/nSuvYm/ZJFYNiu0NN0wMo6bP0AsShEnBHQBM4kfKT56GSP4b1ACEQ9dlgwMQQ/orEiVixLFssXhtr7IRTLI7F1he/cyh2AA6k2lukAq9930EpQOG4vszyDlMS9bmXWFQEltnTh2pF+vnv4uRAMaxWRhW9YsgQhI6SyMaYsQMw8lLqs6C02ct3wvK0SUkNX7qASVQT55RzIRpy9QugxR8aJeUrqSEsZMTQkGJ64wodJZ3NvH42rNANZmqMa+UEZv69gkfKM/I60IghdD8i6vltW3iClPOoeBwxQKTZ3pTfOoQDcQccLyTCYCR0Slha76la74io817TikOPagxdBn6inh+1rVZKq5dYM9XJOyMPVLXnO5ldCv+K9lZnNNgCJh+FZVAP+nAeIVvJEgeg0GYt2P+UqscRXZah+iG3XLB86r6nUON7Gfubqx3qxJcnn9lS7k8oDqzx0/+g/wYpvVJQ0z+vGLP72vlnz6UUVhQBys0m4MvXRgPMXlJxzjTKGY1u1qLXH6iXWMwT/Fb6VbD/3n2KSwnTU3t72F7ELJLosm5zmJn6Og2q+hP6caw6qzKG9Pq85cZ+yjx78fAHPwGb3jXsYXkSWi+Uku6mBNRHpRwJd44jAKq7M1XOTUjQESFe7RN9obshf5Ixr7PBr+KjxLf77tizz0p4eAHOnfI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(66556008)(64756008)(8676002)(66476007)(91956017)(76116006)(71200400001)(6916009)(316002)(33656002)(4326008)(66946007)(44832011)(36756003)(8936002)(6486002)(966005)(5660300002)(2906002)(6506007)(508600001)(6512007)(86362001)(83380400001)(38070700005)(2616005)(26005)(122000001)(53546011)(186003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlREQjNEM3ZQZ2JEcGtVdS85a1pLWVZ3NHZGWVZsaGdTbDNjckU0WldiNmhK?=
 =?utf-8?B?QzNtK0MwQU1LVyt1SGhQcHZ3SVp1MG9WRENyWjA4ZC9JMWZoRFRzV2ErRnJk?=
 =?utf-8?B?dk1Ed0JhdnJabVJlSmNIcm5WaUorRjZGa1ozemxyVWRSSGtDNm1RMVU0OStU?=
 =?utf-8?B?SXVMMnh0U29sOFlmWjE2aDlSc0ZQcTgwcUE1QlgxZkUxR1ZabFZmSTZNamd6?=
 =?utf-8?B?ZFRNUTRMbEptSHVCTld3QjQ4VzR0Z1ZkZzRiYmJHdFpKTGlYSmNNWmJ5Qlo1?=
 =?utf-8?B?NHdLRUFncDdYcUl5dlJxVzNKMGpwc3lNUnJZWjNPM2ozL29YZ2hsVHZQYkhh?=
 =?utf-8?B?Y3NhdXBDVngySkxoYnlvWFE1dUFjTk9pbHdZeCtIclM2SlpjYklkazZBeW4y?=
 =?utf-8?B?ZjhnUXlUUVY5akJ2ekhpdnl4MHZTZlVHbTlwYzl2bVFvdVFWMklpeGlmQkU0?=
 =?utf-8?B?eVIvM25BQWVxZnpiVzFJZkdYUlVTTnRMejEvMHBDYTVnNEd6b2ZYN216UzRR?=
 =?utf-8?B?QTdUdklGeDJUN2p4Qm5pUW1tMDkzNTVIK1RoQkNULzZ6b1hwaTQ3R1hjZys2?=
 =?utf-8?B?a1kzYzBUbTUwQUxvK1lPRnBxQWx3NFZzVTd4V20zU0wwbnI1UWVQS2N5NWph?=
 =?utf-8?B?R2p5bXRMNlo0ZmMzU0s1RndRdSs4Z0dmRFl4cDB5bjkwdHdFdWVBSzRldkQ2?=
 =?utf-8?B?Uk9ITGlJMXA3T2VSQjFxL2d5TEtkWE5nZG4rVmpESStuSEI4YXc1dUlSRFdR?=
 =?utf-8?B?U1R3QW4yU3FERDBMdWlqV0Riajl5WmxUTG53VlBsRTFUY1lFcy9NYzIrTC9m?=
 =?utf-8?B?QnVncnJrZU1aL3hqWmRVNzJNQWx4bkhUZytYSDNsclBMa1BhS3dXSWhzb3F6?=
 =?utf-8?B?aFdpa0JmMDEzdHA4bm5GcXVZcTM4V29VQmRxOHRjcUp5TXJxK0VxV00xbG90?=
 =?utf-8?B?UmpvMWtDUnVuSFU4V0dqblV2dEdpQ294anExbnE2bVVIekhDNCtiaDQybnk1?=
 =?utf-8?B?N3QxM1BnK3FEUjE3R0JwUm4rYkdKWGgzMFB0Y3BnVEdJRXdOV2twUW5Nc05n?=
 =?utf-8?B?K1RTV08xeC9RWTNzWnZmdU9KYlNtVzIxSDNKVVN2T1VwSFlMTXdESmliakhB?=
 =?utf-8?B?MFB5L3ppVWxHc2VKVHBMRW1sK1NQc0duVmdkMWNQRXJ0TURyVXBsSXJ2N01x?=
 =?utf-8?B?M3VGZFE0SDdBUTZhVG9WSTVMVStwUDcva1dUZ2xJTGhvcWlhN05vWEcxU285?=
 =?utf-8?B?RmlSVWdaSG1wajRia3RwQlg2dXFia3ZOTzhteEZzREtkL2dvdVhGVWlOUzZG?=
 =?utf-8?B?NzVhU1c1a3Bjd2w2dDhnN1RwSVZRK0dXQ2lXb3NJVTJOTFNBUEpoaFJVOWY4?=
 =?utf-8?B?VCtETm5jY2xkV3BzY3UveXhuRTRoaXNINzZtQXpQeS9rZ1dPdSthN0F2Y3JE?=
 =?utf-8?B?MG55Q0dZbXBrQXpkRkxlSlFEcmhxOWhrTGpSZ1NQdlRveVM0ZVUzTTlKTERP?=
 =?utf-8?B?MjNFMUlWR0s4cXdzdmExQW9rRGZaV2h1NmljZkpzRFJaRk9vYXhZa1Y1Z3FQ?=
 =?utf-8?B?TEgwUDdjOStCTzVialBTNVNSOE5FOXVnV2piZnpIeWU2SUo0cEF4SXQxK3ZV?=
 =?utf-8?B?UjZPS2JrUnpUcXdacnplQVRFamJESFRPaGc5YWN5Vm9yWkR3K1RVdWY2U1NU?=
 =?utf-8?B?ZmhJMkt2azRPSEhGdjRreUpCWCs1ZVVsVng5d3BFRm1kN29FQjlWZldUOVo4?=
 =?utf-8?B?M1VkeEVQNHBlNmp1NmUxeVdkSjI4QU5qemJiTVFMMENVQ0dtZkVabk9kRXRt?=
 =?utf-8?B?MmQ4UHBsNGkyWGxId0hQMTAvZ3UxUG5qQ1NYamVqVEJXL3FHeXpoWGtYdXgr?=
 =?utf-8?B?aWdaUy9kZk5vR0dWYmVFaDlsdVd6QmR6Ri9vZUtncVRGcWI2OW4vYzJlR3Y1?=
 =?utf-8?B?SUE1UG5HV1pYN0tFWEhtdzVINDgyby9HdWFVc0dWa3V0V0k4Z3loSmoyYkpR?=
 =?utf-8?B?T1dDVjIwSWZuSC94Rm1HWnoyanFTYmt4ZDFOR1pQSUR1S2xWTzFPQXBzNTVT?=
 =?utf-8?B?Q0pkYkVjcDlFdWVNVVp6S05SZ1RnOWx2bElnYnk1ZEw4QUUxb0hjOFowSnZU?=
 =?utf-8?B?N1J6NXY2L1hOb0FpMTcrNmhxdXRZNEx0WmRtd29kSHAycGVQZ01yZFlldi9v?=
 =?utf-8?B?WHNDWStXaFlaZzdaQjhneWNrNDFnUlF1WE5hSnQyWTdjbyt4SVI2akVuZHpN?=
 =?utf-8?B?dlhMbmRGRzNmZzJJeGdTTVNLNmErOVBVOWtLN1VXOUtUTWdsdUZKVHp6MHdr?=
 =?utf-8?B?MVZ4dzUvdiswb0RlV0d2QzJoTWdrb25JRzR4SEo5U0xYcTR4SlAxUlJQWlNz?=
 =?utf-8?Q?i9XoEHzRpjIlnEoov3KMnVSHzx2OGjdsqtkPT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE3EBFB5F57B404B8839F7D8A6C1398E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e0ba49-3050-42a4-1ed6-08da3aa75ae8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 21:26:08.4832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8mwWO3RM6RHhKkYneHurgsP+AD2wEBixSIUVNiipHoPK9AbZyXyj+pBAl7vmAqPRVU3TvGfreT6vHjX2M4zRUbVgPnkRupMLOAif9+WCM3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_07:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200131
X-Proofpoint-GUID: xufikiX6KA6fMCL22CLi6r6_MDht5JT6
X-Proofpoint-ORIG-GUID: xufikiX6KA6fMCL22CLi6r6_MDht5JT6
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

DQoNCj4gT24gTWF5IDIwLCAyMDIyLCBhdCAyOjE0IFBNLCBMb2dhbiBHdW50aG9ycGUgPGxvZ2Fu
Z0BkZWx0YXRlZS5jb20+IHdyb3RlOg0KPiANCj4gDQo+IA0KPiANCj4gT24gMjAyMi0wNS0yMCAx
NToxMiwgSGltYW5zaHUgTWFkaGFuaSB3cm90ZToNCj4+IEhpIExvZ2FuLCANCj4+IA0KPj4+IE9u
IE1heSAyMCwgMjAyMiwgYXQgMTE6NDUgQU0sIExvZ2FuIEd1bnRob3JwZSA8bG9nYW5nQGRlbHRh
dGVlLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gDQo+Pj4gSGkgSGltYW5zaHUsDQo+Pj4gDQo+Pj4g
T24gMjAyMi0wNS0xMCAxMTowOSwgaGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29tIHdyb3RlOg0K
Pj4+PiBGcm9tOiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+
DQo+Pj4+IA0KPj4+PiBIaSwgDQo+Pj4+IA0KPj4+PiBJIGFtIHBpY2tpbmcgdXAgcGF0Y2hlcyB0
aGF0IHdlcmUgc3VibWl0dGVkIGVhcmxpZXIgWzFdIGFuZCByZWNlaXZlZA0KPj4+PiBjb21tZW50
cyB3aGljaCB3ZXJlIGFkZHJlc3NlZCBpbiBbMl0uIFRoaXMgc2VyaWVzIGlzIGFuIGF0dGVtcHQg
dG8NCj4+Pj4gcmVzdXJyZWN0IHRoZSByZXZpZXcgcmVxdWVzdCB3aXRoIGNvbWJpbmVkIHBhdGNo
c2V0IHRoYXQgcmVzb2x2ZXMgZXJyb3INCj4+Pj4gZW5jb3VudGVyZWQgd2hpbGUgcnVubmluZyB0
ZXN0IGNhc2VzIGZvciBlYWNoIG9mIHRoZSByYWlkIHR5cGVzLg0KPj4+PiANCj4+Pj4gSSd2ZSB0
ZXN0ZWQgdGhpcyBzZXJpZXMgd2l0aCBsYXRlc3QgNS4xOC4wLXJjNCsga2VybmVsLiANCj4+Pj4g
DQo+Pj4+IFsxXSBodHRwczovL21hcmMuaW5mby8/bD1saW51eC1yYWlkJm09MTYyNjk3ODUzNjIy
Mzc2Jnc9Mg0KPj4+PiANCj4+Pj4gWzJdIGh0dHBzOi8vbWFyYy5pbmZvLz9sPWxpbnV4LXJhaWQm
bT0xNjM5MDc0ODgxMjA5NzMmdz0yDQo+Pj4gDQo+Pj4gSSBoYXZlIGFsc28gYmVlbiB3b3JraW5n
IG9uIHRoZXNlIHRlc3RzIGZvciB0aGUgbGFzdCBjb3VwbGUgd2Vla3MgdG8gZ2V0DQo+Pj4gdGhl
bSBjbGVhbmVkIHVwIGFuZCBtb3JlIHJlbGlhYmxlLiBJIGp1c3Qgc2VudCBhIHNlcmllcyBmaXhp
bmcgYSBudW1iZXINCj4+PiBvZiB0aGUga2VybmVsIGlzc3VlcyB0aGF0IEkndmUgZm91bmQuDQo+
PiANCj4+IExldCBtZSBsb29rIHVwIHRoZSBzZXJpZXMgZnJvbSB5b3Ugb25saW5lLiBJIGhhdmVu
4oCZdCBzZWVuIGl0IHNob3cgdXAgaW4gbXkgaW5ib3ggeWV0LiANCj4gDQo+IA0KPiBBaCwgc29y
cnksIGhlcmUncyBhIGxpbms6DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAy
MjA1MTkxOTEzMTEuMTcxMTktMS1sb2dhbmdAZGVsdGF0ZWUuY29tDQo+IA0KPiBMb2dhbg0KDQpU
aGFua3MgISEhDQoNCi0tDQpIaW1hbnNodSBNYWRoYW5pCU9yYWNsZSBMaW51eCBFbmdpbmVlcmlu
Zw0KDQo=
