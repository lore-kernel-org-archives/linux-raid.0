Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1062C00140
	for <linux-raid@archiver.kernel.org>; Mon,  8 Aug 2022 20:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244238AbiHHUXY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Aug 2022 16:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243020AbiHHUXW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Aug 2022 16:23:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DCC1A802
        for <linux-raid@vger.kernel.org>; Mon,  8 Aug 2022 13:23:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278IvTG6003703;
        Mon, 8 Aug 2022 20:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RDr9rZwbOWVVfUO/goiECxsX9rUSv4mPDzW5iYzbSiI=;
 b=tEdpehGFe3V/0TR+YnuzaHJsL5qkWFIUIplVRbgs2DSv1uwJv3mkBbX9l/H6Se0MclUY
 f0tgWkbaHk0ZC+kVqcPfzYnsRtBV9Ehf55wgwY+HEgmJbHADMwERvypJCQPhmp1fZNl0
 NTLdvhH827HtkgAoDmEghT4QINmF/0FrQjS5amMWEb/Xv5LrRTzv3WPvI0ONe0SBS8tu
 f5tnkQF+p1m08S+vIRjNAECFU++eJOm6hxeaxNik6aLfjhwSmBwcODyBZpFDCUs3TJS1
 J7oyN6FRpnIKpmGGK77T534EXPJ4KTllFnkBd4XdC6jKPvuOnKFztN2zL2tL7empulJC BA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut4q4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Aug 2022 20:22:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278IPHwp007838;
        Mon, 8 Aug 2022 20:22:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hser28cd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Aug 2022 20:22:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcNabhDHNJGK8T8ZIU817KbUU+oDPoOU+lgWkM4TNgHWf0F0YrS71nw7YuCfVTObMPcJEh6Vr3XMMwybUc74rsM+gZq15Mdu0oIUWuQpjF/NuhKoIDUPQh1VwO/7XCHtMJ+wIkmBpycq5hk5IS6+HcTtX40dOR+5KWo02YnFK0+nWLVDEw2lfNOlt8ya+9SSesh66pN2xqEhcSetAspXI0DB9lbbNG6F6Ea0o3F4heRJkNkqdLRDBKFLhCZXcBTSMcRrdjxlkvcTE3bSknXSYF4oQVlHTmQJpOFgEB+vTyS3fHwOpvjA7CXxgRkGMl7fNM2ss5QK8LrEpF3/9HID6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RDr9rZwbOWVVfUO/goiECxsX9rUSv4mPDzW5iYzbSiI=;
 b=CTWAuKdhvyaOT4j+19i5/ZxGN+HnswYe8K3eVtt9HOT9N+FDFIDpKvkJ6tc4HBHVrcIT6e/ea5kTR6OjDyJLRJO01vxujX6JexLT87x/xLEtLrP0j2W8HP9/XPFj/nOB5fYaC4+SA0V+vns3QIUGwlD6HWeMydgT7bF6+R1G21A2EQ9l8H+epgQnSRULzmumjuaCOi0kBM4Sy/Oat/0RkeXjn75ydZ4M52BrqC5tX5J++Gba4512PN2N6e0oERH0PFHhV1rZNciTqUuK2use4zVHGEmt0XgJBPb4/JU2cGq0A043RtqCEFp5ip3+6WWDrC2UAqhOmdcZvS8d8bEVIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDr9rZwbOWVVfUO/goiECxsX9rUSv4mPDzW5iYzbSiI=;
 b=YZJIOw/WrleRdneS+ff/ieWquuWHK3xvbgR5AWjVCxG7gp3yUQoYAxhJkVXjiwQK8+dva+T2OeRvx5Mlo5qGDVK8j3H4km4RVL7MKFA38A0LvferATcwjxxh9YCu+3jPlqBt3E/dB3gmrmWmaQnvncXwHdwTcXqAgo0jSr50O0M=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB2732.namprd10.prod.outlook.com (2603:10b6:5:b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 8 Aug
 2022 20:22:33 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 20:22:33 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Coly Li <colyli@suse.de>
CC:     Logan Gunthorpe <logang@deltatee.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Jes Sorensen <jsorensen@fb.com>, Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 00/14] Bug fixes and testing improvments
Thread-Topic: [PATCH mdadm v2 00/14] Bug fixes and testing improvments
Thread-Index: AQHYhnZDGlCZAf8takmUvi7d90dio62KzDmAgADfqoCAGg8agA==
Date:   Mon, 8 Aug 2022 20:22:33 +0000
Message-ID: <3431247F-4D2D-4DBA-A028-AC65AF607568@oracle.com>
References: <20220622202519.35905-1-logang@deltatee.com>
 <1561DA98-8681-483F-A14C-FE6877B9DC05@oracle.com>
 <7F1A75AE-2F25-4D77-8BA5-2826E108E85B@suse.de>
In-Reply-To: <7F1A75AE-2F25-4D77-8BA5-2826E108E85B@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e246e42-8b05-45f9-5312-08da797bb9ff
x-ms-traffictypediagnostic: DM6PR10MB2732:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SaLW3zvdbbTlajsNHfFanOf96eljK7Vyd7mYyddQpDD5kEpFviEHA4qlBgzVz6+b5kmDVLET/8xe2MacaXJEgT9S6E5mzxZyBpPTxxN4TXUghfVfcc+q869hRiqtK3IGczoNGom+j+DTQ3NPskcchyvtDDizl613eD7Xj7kqiAZT6Mdf46KRhRv7hrx76p9TEt0rbfBLlKTJyhBQV+aTXL4xO+dKo3sZ3FT68hlxWBI2OR0yuwDoa6IAmUVcQ/6fBDJVQQAtV63GRmhaBDKrLz/feYmgJ5+5wkmHDDuYsFXOWNMGVoQ4sA2CRRXS0vXxVkOgJfrsYjeV5pI3Aa+r5fshXh2psV20Etpdj91dTB44iOXZNYfF9KiVNYyCSZfMHlxni9TLQngKWBw5VK9RwsK/8PGwbbCNoek4ztU1oU6nSk3jNeD1XLvyGqUcSy462qd24MqQ094ZG4pGQMxsDED1R5nEX1FMYhadlhxuQi5LiMp9zK4gghCzNz1VwF4kkBY5Hvy/sdc4N7lN1rOseT2ySZrhHwzQtKYXhgOE/SkH+60i6HZLCBXkp2Ecso0hsLqEsr0lJKR2gTlp2XU0KqpIm/vhjR40tD8n9TGEHv4j3sNa2cgdaG58JOY8fWYDMkx5KwBhcURiBXSg5ACePy+sEMpQTi74L1rL3R2WCMbhJUZeYglSEDKijjbyejEFCPakX2Fo9bN5j2Zbj3xtPMuhwksEyaZpmR6R9JtGFcOjiPdKZmS+qSmSHME2BUrFs0Qt0tOwGY9amOAo4+eUFtYFYh0U5tFlwNeZnsSBVaPYQNTupR3cl2qMMS1gkfrxaPwFG/Ty1sDzRKhytgUztg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(376002)(136003)(366004)(346002)(7416002)(8676002)(4744005)(4326008)(66946007)(83380400001)(36756003)(316002)(6916009)(91956017)(5660300002)(33656002)(66446008)(64756008)(76116006)(66476007)(2906002)(8936002)(44832011)(66556008)(54906003)(26005)(41300700001)(6506007)(71200400001)(122000001)(53546011)(2616005)(86362001)(186003)(6512007)(38100700002)(38070700005)(6486002)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Li3LduNwMvp3guu5jPKshtKUn5lopyLq8hh5eklHstfRcfcVHxG8BTMVpSOU?=
 =?us-ascii?Q?TXvzJmUVFIMUcrR1ufrSsxzZIIyC8P0DJF7G5DjHc38fqLbPaoKd+MLqKrDB?=
 =?us-ascii?Q?WwoZTgvBIhpauYwHvS/Kz+HN1Gt/scPoxwEl2Bgt8HDK3YRFi8yXxfeUrNKt?=
 =?us-ascii?Q?Cx7MJ0oO4TODEobNhduOMQJ+8IJP6LyWBuf4Xoai3eHHm7fbTYyreqHO60Ci?=
 =?us-ascii?Q?uxPZvZ1GOXJ30m9IGEGOQYpIeDwrWISM0F/saZ2pcgkUn4b90wrOT7/v5SfN?=
 =?us-ascii?Q?SzBfRzPiBk7BUCuSa5FOmJEOFQ//Egkl2Uqww30dVlfbs9HMDxYelZdc9Shw?=
 =?us-ascii?Q?NHxWWBq2PDm2nIKIGuW4s65AjLUwRdV3Ua3gQ+2dJ4kVtN/ivjQGz0oUDFkl?=
 =?us-ascii?Q?gOHzZ8wDvJzLqH6N+cYgw1z3BpXEQtEcPNZswi2fx5Oi6JeOEMdx4j2FJUgj?=
 =?us-ascii?Q?YplA7f6pD6xWMpuHLvN8VWkFEJ6Jnnx7F1xysHnh/j1TEWUnSdCGNTF/VwL1?=
 =?us-ascii?Q?y8pEIkoUSqd7q/7Iq/A8u7xT1P0ZjQaaY1Va+AEnm0MTqh+47LUvZSmwGGIh?=
 =?us-ascii?Q?xzRQ1PdMUOC8czr6Tu5/x/lIvoMjHw76sP/emRyaCbGo0c75F+g63azIR0RS?=
 =?us-ascii?Q?XMCWx189qvJPXy9EEFBScjrQclEJe0qAym/pkOQlpa7PT3sdpHPT3gNngT9I?=
 =?us-ascii?Q?IDf8zImuCS5Vcy2B2zcoe035Woa8Sc3GDtZEF9xR9azK5ICD8K3i3scqPsJc?=
 =?us-ascii?Q?LtupxiIeeJP1Sw/ARPoBhkgnzNDQkCPhmUPBpHekBuxYBJf8H/5zB30hqfax?=
 =?us-ascii?Q?Jtbsv+3a36kNmpvZubY+G9MIJReyOY75gBPUTIjsdKp9WERr5B9hjjqsWwaS?=
 =?us-ascii?Q?kx4MgbHLapd7xhUA9wPyTwNqCz+DHmM9p5t6Tcf6XKAn13kqGhktTcXBkNiS?=
 =?us-ascii?Q?OQPTT9S6LckroE0FmJ/pMH1Av2ihV76Dw8gFakKUXNcSicODUwo4augKVakE?=
 =?us-ascii?Q?sIPfbjLYPpevgSnFkTFe6OV4Zk2/pe6nS6R6u/nGPZ+hVA+zY9iUvnUuxPEg?=
 =?us-ascii?Q?wrUHs9IFClRU/aes8ykTEX20TI7NIh8KSFnogx3Aj1pAp7+mc/ledYdafWmZ?=
 =?us-ascii?Q?/uTgPER7IK5eLusy/oInNcybJdhoCdlJOlHjzDqnSMr9Cdx0ocsUdpUX30cn?=
 =?us-ascii?Q?IhufKP1LwpCYUr+eNVnod7qNuwmg3S+LVF704JtNFYUbskVjS3AEEWkGaFIe?=
 =?us-ascii?Q?NnYjiqtTwjytlO/6Sh50QUr0mPIWU70qUNEBOXP06A/2KO2CSkLEe9RsUkb+?=
 =?us-ascii?Q?j1lW5Ujt4b3aDYsiVDaw0hfkar5wSn2Gbo0oJFHIl+pc5jCXyJw3CBIEpeGu?=
 =?us-ascii?Q?IkmikDhgnMHry/Ay5KMsfzkv6BWAQXhqAhBgiO4+iXQqrPRL4bG/G1xIlYUp?=
 =?us-ascii?Q?xKQUf6rsRF6XZvItVQrBQs/c8GgNicB+TVJ38bOlcDQWn1OxG9MNKYiV2wxa?=
 =?us-ascii?Q?hUxo28MFIVwa2k6K/5KJJCPcPV9fBsYjJPMupMIkwpFfFfHqboRjEIoGT7qa?=
 =?us-ascii?Q?Ccwb/fjrbCzDlkljNMBAk5kkN4pdpSi1NMf+4TLoy7Haft+VIr1McDiyyntk?=
 =?us-ascii?Q?HA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2DD1B62BEE2DAB41BC050D4A8B40B0B9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e246e42-8b05-45f9-5312-08da797bb9ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 20:22:33.4490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MMIIoZfvsbmZhGhYK2t5KKFCKtmdqDOYNfsV1ZQWagoPgwdZZgw1ZmZiJKVoXFU7WPFjhqSKzndCc7h5cmhf/dihvMCi60SAcEQA/jDRoxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_13,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 mlxlogscore=957
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080089
X-Proofpoint-ORIG-GUID: 3XWBHWyJUpHHV5zlZ6SRjMh4kCvGAXG4
X-Proofpoint-GUID: 3XWBHWyJUpHHV5zlZ6SRjMh4kCvGAXG4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Coly,

> On Jul 22, 2022, at 11:21 PM, Coly Li <colyli@suse.de> wrote:
>=20
> I just finished to go through all these fixes recently. After the rested =
patches (around 4~5) in my review-queue finished, I will submit them all to=
 Jes for the next step to handle, with your Rviewed-by tag.

Thanks for the update and help with reviews.=20

--
Himanshu Madhani	Oracle Linux Engineering

