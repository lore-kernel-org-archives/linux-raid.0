Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05071C43217
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 01:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiCIBOH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiCIBNG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Mar 2022 20:13:06 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6032C11E3C0
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 16:55:56 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 228IosiX010042
        for <linux-raid@vger.kernel.org>; Tue, 8 Mar 2022 15:36:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/Z2qw3VaUfbjXRwnueR2iJclmD5PyTs5j0SZzeOzle8=;
 b=SYpTUyv3Cs4zTj05dKTs+obxhJS9jWkf0YeQ4z3WXMSyUNyeuRFqmfWfYvWmuhsMaL1k
 sH3/hwspRxhdzAu3A7ik40fDjH2kheI5+B5vxrK4cwXyoZe/aDIZj9XWhdHxP6d+Bl1c
 5f1DJy/8OJfTDberU+/zP3jivUFflTELVCo= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ep3jewwhd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 08 Mar 2022 15:36:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VU1UlUyH98clR3doN1TLbv/9YjD4QpTAqXdTVHNpc7B28wjVPFQIlUUVYCmjpCH8Nlw3ALg0oj5wNm+Q5wdc8PNNRGLY85CgwNgQmyxeS/6/FvKyJC49mgvUJFBoci1symUDfcwyx5euntPl1Vs/+PLzPnLXDp8vXq64bn+8vYZm7DKOlIehvllwCb5nuS3JS4BqlUCxg+x6dcYVvEZsr7T5cOmTkRU57BP+FVlp49n3/MSbs0dpvN8bsHKXJ7cnm+azBuT1FD5RDK5DtIU1eHUVmedqwpm0+X10+/uxUelFIwQnbdCuZ+IzIzSvojSSyBi5GPzVmhl/GDbreP7AHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Z2qw3VaUfbjXRwnueR2iJclmD5PyTs5j0SZzeOzle8=;
 b=UTRWFmVJ6bv0bdbJ2d9Xf6G8IpQmxn7Qep5MbSEUJ+z6IKo92WHfoRxSXfdAxtOC54cZKa8IVHXeGo6wTUAjGJ2XBR/EksQMWJgrvbocdTLlbj7wokDN0vVj/Q4kv7cxg3P1qGnS3i88gqdDLm4QhZE8X/eIwOtUiS/TOCx7udgg1nLA2FxvOhNYOY3pdfU8ySe2J803e6heA3a0yjVYjG0jSc1fUJv6sbOvRCkL8HXAtk11ujtnITb/cPq5LmrOVPI0q5wiIENs4KYeXR8CIJCPF95hS/3eErNeW0UKy+zUTkDlWIgValRu5dcqI4Pssb0BpTnxGK7AWVQcw6NBYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BY5PR15MB4306.namprd15.prod.outlook.com (2603:10b6:a03:1b6::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 23:36:29 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 23:36:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?RGlyayBNw7xsbGVy?= <dmueller@suse.de>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [GIT PULL] md-next 20220308
Thread-Topic: [GIT PULL] md-next 20220308
Thread-Index: AQHYM0VVxkmN6EqId0yCxRlSZ6YOJA==
Date:   Tue, 8 Mar 2022 23:36:28 +0000
Message-ID: <A2D06574-B7A1-4126-A3FA-FA24A61C5276@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccbe473c-91f9-4366-3534-08da015c77dd
x-ms-traffictypediagnostic: BY5PR15MB4306:EE_
x-microsoft-antispam-prvs: <BY5PR15MB43064EF73F7550250CB5D1C2B3099@BY5PR15MB4306.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: odCKxwReKnVE14PqnbD5Ch4dq86cV86vui/RUshzMwBVzWizpCwHeFV/MbpP2w9qL1otkf9gGepH3yQSz5dgGu3zfd9EdmGwDPHQ7n1Gvrcrm1+StaQe8lXGojAZdi89YQXxTDmx6HDnW6DaUS8PZIaBcgH2YvDlewsPlLDzsHJ2prchofEXH9Jdazc30SKdWqsca/1cLEDDCVQQap2PpzCqyDc/kdtCC7/2Pjp0SJDSpaNh7KPwCrSYHGQnKQ/V5vONVMIEx4DUCYwNM84l7XRjR7WsXCfLZdjnyde9ql9eJ1vIAR6rq0Ii2hnbdsQut3N/2kkTP0eeo99xauCGdK1+HwDjtiXeZt/T328FXW4XYywSXF7tkwECnXVXHMC1VaSdXieS0gwzs0j4+SGEiAFtPinc3PB3xbFB2gnA8ycRCwGt0QUeXiAZV+mr0Mra6qd7dBrwaSR+5zfVh5oVZ0yw4qe0q7jhSUaLkGn+poE8reQbuWYqR23zpw+ErqsSJlWykqNOAlqPaUjzycStOuYK8v1ejdcz0k8hkPITatisz+9D8yoC/t6U16SLuUnbPPolJfbBmWQn4HBT0FNxL+7Elq43KBR/MJwVCApnP7Ej5jwzgbOWb7Tv/uUbblN5z96W5BgHSEi6+BnV6smKZS3AAxkErha7q2te1bA0zr0lQBe4pJSguGWmk+Tjl3Aq0R74RnbA9UUgn1ZH4SYQoVsXp+45Wi7TJ9CGFQahl/GOo61wTmbwtwA6qRUE1OZY6XAf70JVjv53Xv+T42AR66CNo0HAnYS2QMSfCHQm8EIDRU17Wma/U+bGknADBSym
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(66946007)(91956017)(6916009)(54906003)(66476007)(66556008)(66446008)(8676002)(38070700005)(966005)(6486002)(76116006)(6512007)(316002)(6506007)(5660300002)(4326008)(71200400001)(186003)(66574015)(33656002)(2616005)(83380400001)(2906002)(38100700002)(36756003)(8936002)(508600001)(64756008)(122000001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THQ1QVVRWkJoSXBCUWJwV2tuYk54Z2xkRWZ0Uk1OOUN5YU1NcWtyYVpjUGFF?=
 =?utf-8?B?SFFRcjlDd1U3STFjS0R6T3ZmdTRFUEZsbnU3YU1GZ0p6SGo0ZExjZFRCTTRW?=
 =?utf-8?B?WlAweEtadm9XLy8vNFpRZXpTQmNxRUM5bkxNZ3ZaOStQalBDNTM4RG80WG85?=
 =?utf-8?B?VENCeExiUGFuaVJaNmVaeFhKTHFyWkhkKzArb0dpZ2trZzdQSTVzS202SXNh?=
 =?utf-8?B?Njh4MDh0bDIxRGlVQ1NTU0w2RDlWak1Hd0lNUTB0cEVPNEpYN2JQK1RaSG16?=
 =?utf-8?B?MmRyUTZ2enRucEc0dnc3VStmdVVxQTFCU0x6YlFIUmsxd29wbnROb1JHblFE?=
 =?utf-8?B?M2lRSmZPbHRqd0dyOXI3eWNISnAraGZGejhybzI1MDlKdGtWU3lXaEp2QmMv?=
 =?utf-8?B?ZlRDT3llcGllb3V5TTlIaS9UcEtJcEp1U2pPYUN5UWNOa3hMd1I5MmZ5eWhQ?=
 =?utf-8?B?eG9YbFlCNjU0TXNNY0pCbHE3cXhKSGJBT1ZEMm5TVE5yZUVUU2RBK2grRWVE?=
 =?utf-8?B?SkJSQlRyMTk4ck5KajdtZEp5dCtpY0wwWGxTdHlxb1BoVG5oTmpvTWhMVSti?=
 =?utf-8?B?ZW9uU0ZJakFFbHYremtyNi84RThPNzdlTE43Vm16STB5aWNRY0txWlFyNEFw?=
 =?utf-8?B?K0YyN1hlUXcwNjFoUnhhem5ub3FmbTJiU3NMSmhBRHd2dGs2ZGZ2MGgzWHhP?=
 =?utf-8?B?bjlDeHhkUDdGdkJ2YnVUOElKMU1odkVxclRMZVp5NVpoYnUzNkY4Z0ZpdUVL?=
 =?utf-8?B?VW81anI0VmE3OW5WbnBER1FOSWxjT3NsUWJ1aTZsUlJPaGlYNzc5K3NBZDUv?=
 =?utf-8?B?VGlZR05NdkIyUTE4QmNQWDFkcXg1TXg2NUlBdW81c2ZYbFN3RVU3QWQyY1Fk?=
 =?utf-8?B?K0l6bWwyNGd4R1I1aTlOVEN3RC9qK2dURWFWVVNaUld2QVhPeUpFUTBBUVZt?=
 =?utf-8?B?WmZjU2FneDN3eU1MYXJjVC9Qcm5VK3BpWDJEMnhpQWI2K1gvSWRadHdNMDJT?=
 =?utf-8?B?cFg5WjBscVZyUElxMjhvV21qeDZka2RFUU5JUDJjWG83VzI2aC9VUmtWUm9G?=
 =?utf-8?B?TlBlbFR2NnRjcHh2cHhyZ0pHTVQxekdtU1A4R29XZGpxbVo0WDd3YitOc2Qr?=
 =?utf-8?B?R01JZEQvbGw1ZlNVOVdTWGNlSk5qakkyUzdQKzFsRks1QUZTTjdsUUJhdWlI?=
 =?utf-8?B?bmh1dVZpV3B5Y3ZJUjdpV0NsZzQvY1YzMVkvbEI1MWY3ampJODFkTzN0YldE?=
 =?utf-8?B?YVNCUndaaTJ6RWZQZVRwbHdpMDN0OEhheHFIWmNFemlFNnYvamh5WTNZV2RS?=
 =?utf-8?B?QjBLZVNLVU41d2RCaUtRbHgyRWJWUkRnMU5TRFF1TS96VzJrZFR6cHp5eU85?=
 =?utf-8?B?UlFzaWFRa3NEaHpqVzg5NXR1NDR3aFdGcC9pZTFINTBhVmEyQ3dQQndkdWxu?=
 =?utf-8?B?bDJYMElMTnNaQ3oxTE43NGN1OGZZazVIaUdnZTc5VkplYmhQQXdjWjN5b1BV?=
 =?utf-8?B?cHZCdHBhQ25vbG50blRRa0VIb21ZS3JwUXVOY2N4QlpEc2d6d1hGZEhuN3kv?=
 =?utf-8?B?L2Q2K0Y3dVk1STNHdmU5bzBpN2ttS2JwQjNiaDhHUEpXUjBQSjh6K3hpVC9k?=
 =?utf-8?B?SEhNcUZFLzNiaFp1UC9sczI0c1JGc3JLZ0lBNWdsWDJKSEpQNlZFWlhISnB5?=
 =?utf-8?B?TnZ4OVVmRXl6OStBbVlMNDhmMVA1WjBSeGZQbVpaOCtEdXl1NnRaUmtucjFt?=
 =?utf-8?B?ZCtLT01leGMwSGhEaHpRTlU5emxleHk0TGdHY25wS1A1SzVqSkt1dUNaTlo2?=
 =?utf-8?B?ZVVkREpMaGg3T0NBaVZuZzBsaVJERkt2NnBWQmN6SU9ncFZtNkFuUVo5YURM?=
 =?utf-8?B?bDVnUVJsbkNHL3UrQ2VHUnkzOHJHajYyVFRtR3hSSHlHdmlvLzBkQjlrVHNC?=
 =?utf-8?B?WnZYQnlsUHNOQWtJbVNuQVErVmJKWmlFVTM3d0NXazZHeHdsWTBSbHc3U1Yz?=
 =?utf-8?B?UHhkc1FQeld3ZEU5eFZ2YjRUc1htbHZTN1pPMWNteDB2UGJjeDNJSU9aL2F2?=
 =?utf-8?B?T2xVRWtLKzF2Y2k3ZDBuT0x5NDB0MDV0Y3gxanArdVNpOHlZbkxnaVJDdHBo?=
 =?utf-8?B?ZFlabHY5MGhWTlZWRFVmSUgrTkpRejJMNkJFS25jQm55UWoxSk52MUQ4K1pN?=
 =?utf-8?B?alZQc2ZnM0tLaGRUbENJK1JUOUVNRUtCODhTZ1Z1U1NuSEpxUXpxd0xvdDJW?=
 =?utf-8?B?U3drR21NNXhWY1F6cWlGMXlTTThnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E24C1E9397E79429582F497692D91E9@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbe473c-91f9-4366-3534-08da015c77dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 23:36:28.5482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: psA1CDIb//rArX+SEzchWaZHiyL9XmpUOwfLOolYFQ5cARtHWz/YetcoBhQ1GjwlpPsECs/aTFiMC1ys4J4nkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB4306
X-Proofpoint-GUID: cGTve8AKAwnGisHneQUZW_W_VoxChW5j
X-Proofpoint-ORIG-GUID: cGTve8AKAwnGisHneQUZW_W_VoxChW5j
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_09,2022-03-04_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

SGkgSmVucywgDQoNClBsZWFzZSBjb25zaWRlciBwdWxsaW5nIHRoZSBmb2xsb3dpbmcgY2hhbmdl
cyBmb3IgbWQtbmV4dCBvbiB0b3Agb2YgeW91cg0KZm9yLTUuMTgvZHJpdmVycyBicmFuY2guIE1v
c3Qgb2YgdGhlc2UgY2hhbmdlcyBhcmUgbWlub3IgZml4ZXMgYW5kIA0KY2xlYW4tdXBzLiANCg0K
VGhhbmtzLA0KU29uZw0KDQoNCg0KVGhlIGZvbGxvd2luZyBjaGFuZ2VzIHNpbmNlIGNvbW1pdCBh
NzYzNzA2OTBjM2IzODJlZTFjOTFhOTNhNDQ3YzhlMjU4NjVjOGUyOg0KDQogIE1lcmdlIGJyYW5j
aCAnZm9yLW5leHQnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9jb2x5bGkvbGludXgtYmNhY2hlIGludG8gZm9yLTUuMTgvZHJpdmVycyAoMjAyMi0wMy0w
NiAwODoxMzowOSAtMDcwMCkNCg0KYXJlIGF2YWlsYWJsZSBpbiB0aGUgR2l0IHJlcG9zaXRvcnkg
YXQ6DQoNCiAgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
c29uZy9tZC5naXQgbWQtbmV4dA0KDQpmb3IgeW91IHRvIGZldGNoIGNoYW5nZXMgdXAgdG8gN2Q5
NTlmNmU5NzhjYmJjYTkwZTI2YTE5MmNjMzk0ODBlOTc3MTgyZjoNCg0KICBtZDogdXNlIG1zbGVl
cCgpIGluIG1kX25vdGlmeV9yZWJvb3QoKSAoMjAyMi0wMy0wOCAxNToyMDoyMSAtMDgwMCkNCg0K
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KRGlyayBNw7xsbGVyICgxKToNCiAgICAgIGxpYi9yYWlkNi90ZXN0OiBmaXggbXVs
dGlwbGUgZGVmaW5pdGlvbiBsaW5raW5nIGVycm9yDQoNCkVyaWMgRHVtYXpldCAoMSk6DQogICAg
ICBtZDogdXNlIG1zbGVlcCgpIGluIG1kX25vdGlmeV9yZWJvb3QoKQ0KDQpNYXJpdXN6IFRrYWN6
eWsgKDEpOg0KICAgICAgbWQ6IHJhaWQxL3JhaWQxMDogZHJvcCBwZW5kaW5nX2NudA0KDQpQYXVs
IE1lbnplbCAoMik6DQogICAgICBsaWIvcmFpZDYvdGVzdC9NYWtlZmlsZTogVXNlICQocG91bmQp
IGluc3RlYWQgb2YgXCMgZm9yIE1ha2UgNC4zDQogICAgICBsaWIvcmFpZDY6IEluY2x1ZGUgPGFz
bS9wcGMtb3Bjb2RlLmg+IGZvciBWUEVSTVhPUg0KDQogZHJpdmVycy9tZC9tZC5jICAgICAgICAg
fCAgMiArLQ0KIGRyaXZlcnMvbWQvcmFpZDEtMTAuYyAgIHwgIDUgKysrKysNCiBkcml2ZXJzL21k
L3JhaWQxLmMgICAgICB8IDExIC0tLS0tLS0tLS0tDQogZHJpdmVycy9tZC9yYWlkMS5oICAgICAg
fCAgMSAtDQogZHJpdmVycy9tZC9yYWlkMTAuYyAgICAgfCAxNyArKystLS0tLS0tLS0tLS0tLQ0K
IGRyaXZlcnMvbWQvcmFpZDEwLmggICAgIHwgIDEgLQ0KIGxpYi9yYWlkNi90ZXN0L01ha2VmaWxl
IHwgIDQgKysrLQ0KIGxpYi9yYWlkNi90ZXN0L3Rlc3QuYyAgIHwgIDEgLQ0KIGxpYi9yYWlkNi92
cGVybXhvci51YyAgIHwgIDIgKy0NCiA5IGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyks
IDMxIGRlbGV0aW9ucygtKQ==
