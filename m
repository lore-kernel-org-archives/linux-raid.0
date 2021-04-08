Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460E1C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 21:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1470C610C9
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 21:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhDHVjs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:39:48 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39958 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhDHVjr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Apr 2021 17:39:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 138LTmLe096132;
        Thu, 8 Apr 2021 21:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=AUHSChzjhMIgJOOiqTRAZljBSX/McquZXcVzcKxn36k=;
 b=F1lUrvue8PGR3xy8V1tZI0FZaSvCAHUGv747EGlOfYsE1PM57OBTFLCaPvrKemW2OiCL
 FhlfGK7ye745pGDEh/bX1WRDnGVJ0XoCGp4FDK6nlEvN3Cd3pfD05ZAbDFUyX8E8pR8G
 00c0Tl/kuZllV65wkW8Yoo7nUznZ2Mz7cKzzdp6nkZZvqmQj7+iSva7tjwyKr3FnmXSV
 ZerAGi6V1Opaa6gW/1H2spxR6Ijn8yDdvgadaGi4/6al9T6RRDgtHh5CG5tyKX+CftyB
 UGyMldTv20iHN4A92YfXvA/TIZUBgSnR+KnrauKAY6HS4bXKZtHx7JZZcwuGd209W698 Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37rvaw7e7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Apr 2021 21:39:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 138LU5fT169364;
        Thu, 8 Apr 2021 21:39:23 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by userp3030.oracle.com with ESMTP id 37rvbg7e72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Apr 2021 21:39:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elTOzapdqtxCcnbNLH8c+wJ8etYwwIylBH/UxYjrDlIxJ22jetY+h2k3fxgyr7D/eTs50O3RIz8JYpRDpFdhQqnK2U+/nNo1FUtHTNJ6r+B5J2WW56DtVlIW9AYnQsKY8g1uzl0W6xff91Tdf60kWzTUU0eMBwWaO8LYfjpB8e8TfSELNga/BSYtONzjxY63FFFquNGV5uEhnzYwd3wwcjyBGwoQGvk/5RPIoE5f51FEXsRo+GIiCHO6NhfThhoPnKTZ6MnN3bOxFEDCpku/VYIORg84cjCSd8ALszC6wzSBUOCPcrlXIcsvt4re6XYpjiFzgG3tLckSrWgK6FWdcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUHSChzjhMIgJOOiqTRAZljBSX/McquZXcVzcKxn36k=;
 b=IcHZ1/wfOpHB9W7nMezRvOq1EBdB7ieGVmpzmUXBKYDHeF348j6txpyPkqEoNVoJUyNiiPzIaOPxeJrDlaukeJQnTZTfkDGkni51ppAyUQhn8mCfh1ffCOfSY2C+Ccgf/wUiQzk0ZP8u1H79IvgOC513FQJVRXjYooajfqwr5/UNCM/ysSEVDAI2ha+TAWk/vs8Y69RKiXPdD5++esfqNLE+lfdi7272xjNVyZytcreu/kB4usXUnbLwtXxlUm8MNJ73bIKkm9ezSpJtr8yl5VFyDDeY1zoMB/GBS+r2t0ZcT+I+MlnY/bgznH08QzGCfhXCD1j7bdTsRbQGYXC2Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUHSChzjhMIgJOOiqTRAZljBSX/McquZXcVzcKxn36k=;
 b=jcNuml4X50EF5+v8EJVoGSu/3BJ8m3ThNdcA3aPx6vAuhBGcZ3YcNL3QsApTvnJ/Pf3LG74yM6FwrP3FS1E8nB3xLf+POMEAp/BqytYQz3+yqnnPIul3hnIEj4eR1PDC4rYv0wZu6prVR4GWzM0fdYPau1BRRHT83mr7IOMWQX4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1927.namprd10.prod.outlook.com (2603:10b6:903:122::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Thu, 8 Apr
 2021 21:39:21 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974%2]) with mapi id 15.20.4020.016; Thu, 8 Apr 2021
 21:39:21 +0000
Date:   Thu, 8 Apr 2021 21:39:17 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     heming.zhao@suse.com, ghe@suse.com, lidong.zhong@suse.com,
        xni@redhat.com, colyli@suse.com, martin.petersen@oracle.com
Subject: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
Message-ID: <20210408213917.GA3986@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [209.17.40.37]
X-ClientProxiedBy: BYAPR08CA0069.namprd08.prod.outlook.com
 (2603:10b6:a03:117::46) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (209.17.40.37) by BYAPR08CA0069.namprd08.prod.outlook.com (2603:10b6:a03:117::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 21:39:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d48c6516-7bf5-48ea-ca59-08d8fad6c584
X-MS-TrafficTypeDiagnostic: CY4PR10MB1927:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR10MB1927591A92694DEE75DAEF81FD749@CY4PR10MB1927.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZAvJ8e9lN3X8z+9au8jowKZ4L1sCYIIqzQ173IEu/i8iA25IYec6pqEqVDKGH6rcOUHCoPHcIpD1xB5ZCzy0bYCaX3G6m/SQtSUpl+eTd62/uUSa/qM+cFxHnHwnRy3HxO5xyetBACLK/IEs1nlo1EIMUh1H4tY59Im2i0fWb7g83pf6SSXo3G29hUTsWOmcBwpM0DtR+kwZxtvB+lIqsZpQga7Izh+T5fxQ5zmM/00R5tzV52RW0dNSDuWXb37A1vVSTcngNv5OK0vEEX5JOnc1Yr8YZUYZEFQTkoXFsUMIiHm4GlkdW70y+8OAfrK/hVPra/VAjhpjFcDWYAC39dI5fc0XR3Ocwcm6SSTu9Mx289mMGgW8D9AYzUOBaiNXxUbDeUq4rJ9sMelf4mJXEIBPYlkYetupv4P1qUipJ+4fMAXwGEYHw9pwLoLq6A1rd6ssbMwt40xoh9q8Cavf+neOd6z1CXGzj7h6I3kBTWgCuyki5V43AEd0ySVb7FqtX8msPaETEy9CYBE83htCJ/5f/uKXy9eWoRh6bakU/WZ/TSkCB2IUxYz6obtOaNWHAZgrrCN95Mm7FpCcGJWkN9vOFYi+G5TDqICcgDqkPOzmpL6u8WehOeEfto5ItUgAZ1r2FoAFx3toF6uEHttaVJILa84orBrAhVMKbOF1APZlbv7YEjyn8NDOeMwNwBZW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(136003)(396003)(478600001)(8936002)(66556008)(1076003)(8676002)(86362001)(55016002)(2616005)(83380400001)(956004)(38100700001)(33656002)(2906002)(6666004)(66476007)(66946007)(44832011)(316002)(38350700001)(36756003)(26005)(186003)(8886007)(52116002)(4326008)(107886003)(5660300002)(7696005)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Tt36YA8EpiqatsmhFHHEgg/dS+yShPgNhAdd54SFB5cBoF4X7cy/1mw2vcns?=
 =?us-ascii?Q?JqUydSSUiNYHbGfx51vXtF21H460GCm2nGrBubDrAbUY5c1Kdrpho9DmBnw0?=
 =?us-ascii?Q?5JMs7UqXhva/7S1Fm+E+d6VMeFNUXSQPSN5+EICK3OsTmL7nlC2UFPpReTmZ?=
 =?us-ascii?Q?zLr7dGZr/kC4R7+FgOVLr5bhc8F4QqTN6K9/y6du0V2DWkzWHMYb2/xVy8H+?=
 =?us-ascii?Q?5GGpmHt/CDv6AZs3vOKhJQ2wlA58r/iklpqJEH51mtDPJ4kt73IeawLZyrwT?=
 =?us-ascii?Q?9In8/6bBJXoWuQzgJjFi6snkg11QeDKYrn2K5zscDzh6RehchVaAoEs+02lh?=
 =?us-ascii?Q?kPcTcyauYxGKUrzCHkupbLSffTp+vLM/ZnHMXJCrJuQH261Du/xC8jD4GuY9?=
 =?us-ascii?Q?lRU/2djzwdZBVUrmu8MbE37ZnXkaRkzC/q9JW+IcQRUWw831EPuUcHA7xke9?=
 =?us-ascii?Q?Fn1BlwiyRUrOfV3xIRGYh4wpjKfCYInkcDP8Uju7nU2r2GTOR/Ea1SRj8fv+?=
 =?us-ascii?Q?3nOS0d4pp8XcrY3Db3fk6YukHzeVt2fFNbb3M02DLzgLkIgxmeJfv+AVGQYv?=
 =?us-ascii?Q?FqS0Y/YxfDMow52910d9ZXaGmKRJOByq/Ns175YQKDrAmTyn02Eh9Hkw3RH6?=
 =?us-ascii?Q?jCO5Y9VyOdhrj7G3j6+cYPH10QMpqtwlGfOV5I8oMzmi3ix+8xnZuiuyC7St?=
 =?us-ascii?Q?kLRuYtEHJxLVrfUlJMghULLzIbrRd5L7stR1Hu9Om4oW8bEpXZ3dP4UXO5sb?=
 =?us-ascii?Q?/eP/0RXRJRP6WWj1smW7+N3ww9T+TDd+EDBAY7z/W+eZg1aTIrU2Tf5erqze?=
 =?us-ascii?Q?v3KGfzYozAXkUHpdQQ50zY2KNTVxwL4Atk/HSdMzaTvWHOC4GTRfNrPutuZJ?=
 =?us-ascii?Q?fWiAKw2XPNouhYcM1WLtITLHA3DnSu3S0tnMVJKJdDCrHITtzAtHQU4Wf6/p?=
 =?us-ascii?Q?bNIH6eeCNcLjpGAP8SeZwE6UHhse2H8WWDBeHjJq/SMtHqVZLp5uWaV+7/J6?=
 =?us-ascii?Q?cAOIyFBYwKnFy8fztPp2dujL1oUZ/9K4GuTJrsv1J+RWE+dhAhmWqLyLIq7C?=
 =?us-ascii?Q?a//YRsE4Nv5sclTIy0PUzRcrCtVWMUemc7km/Hf7CCNBYkKQLRDy05KQl3ov?=
 =?us-ascii?Q?HfzAuLUBsYsO+Xn68gv1dZY4tlnok0Hnibe3uqVQgXWwyC3A6a77/i7UclUp?=
 =?us-ascii?Q?42j/7wgfIBCLRjErEUkzPbYiyr6TRCmt/5ecrcNAT9+Sv1Do0aQC8MVAsLBc?=
 =?us-ascii?Q?qhD8FjZ7fWe1IMm41oSQk2y2nm6pyuabEev1AdfRHnBwQhgcpkZ+3LRXeKjW?=
 =?us-ascii?Q?rgZyLTJ4ZgJHQJD0VjJ4cTn/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d48c6516-7bf5-48ea-ca59-08d8fad6c584
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 21:39:21.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGeVyNGKuGxivSArz8OEiAUJq1nzYaWx9MiOo/6AUfb1+A9HieiaUea40SiSK1tUarukP2kb/GCJnhqxBGzOTowLxdfLLIxgFErqbYZN54iHh4O9+cZtL0uuBQEXBLOn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1927
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104080143
X-Proofpoint-ORIG-GUID: Qn0-7zrHux2qnITpAPN-ZZ-qTnwgiK4E
X-Proofpoint-GUID: Qn0-7zrHux2qnITpAPN-ZZ-qTnwgiK4E
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104080143
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

NULL pointer dereference was observed in super_written() when it tries
to access the mddev structure.

[The below stack trace is from an older kernel, but the problem described in
this patch applies to the mainline kernel.]

[ 1194.474861] task: ffff8fdd20858000 task.stack: ffffb99d40790000
[ 1194.488000] RIP: 0010:super_written+0x29/0xe1
[ 1194.499688] RSP: 0018:ffff8ffb7fcc3c78 EFLAGS: 00010046
[ 1194.512477] RAX: 0000000000000000 RBX: ffff8ffb7bf4a000 RCX: ffff8ffb78991048
[ 1194.527325] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8ffb56b8a200
[ 1194.542576] RBP: ffff8ffb7fcc3c90 R08: 000000000000000b R09: 0000000000000000
[ 1194.558001] R10: ffff8ffb56b8a298 R11: 0000000000000000 R12: ffff8ffb56b8a200
[ 1194.573070] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 1194.588117] FS:  0000000000000000(0000) GS:ffff8ffb7fcc0000(0000) knlGS:0000000000000000
[ 1194.604264] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1194.617375] CR2: 00000000000002b8 CR3: 00000021e040a002 CR4: 00000000007606e0
[ 1194.632327] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1194.647865] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1194.663316] PKRU: 55555554
[ 1194.674090] Call Trace:
[ 1194.683735]  <IRQ>
[ 1194.692948]  bio_endio+0xae/0x135
[ 1194.703580]  blk_update_request+0xad/0x2fa
[ 1194.714990]  blk_update_bidi_request+0x20/0x72
[ 1194.726578]  __blk_end_bidi_request+0x2c/0x4d
[ 1194.738373]  __blk_end_request_all+0x31/0x49
[ 1194.749344]  blk_flush_complete_seq+0x377/0x383
[ 1194.761550]  flush_end_io+0x1dd/0x2a7
[ 1194.772910]  blk_finish_request+0x9f/0x13c
[ 1194.784544]  scsi_end_request+0x180/0x25c
[ 1194.796149]  scsi_io_completion+0xc8/0x610
[ 1194.807503]  scsi_finish_command+0xdc/0x125
[ 1194.818897]  scsi_softirq_done+0x81/0xde
[ 1194.830062]  blk_done_softirq+0xa4/0xcc
[ 1194.841008]  __do_softirq+0xd9/0x29f
[ 1194.851257]  irq_exit+0xe6/0xeb
[ 1194.861290]  do_IRQ+0x59/0xe3
[ 1194.871060]  common_interrupt+0x1c6/0x382
[ 1194.881988]  </IRQ>
[ 1194.890646] RIP: 0010:cpuidle_enter_state+0xdd/0x2a5
[ 1194.902532] RSP: 0018:ffffb99d40793e68 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff43
[ 1194.917317] RAX: ffff8ffb7fce27c0 RBX: ffff8ffb7fced800 RCX: 000000000000001f
[ 1194.932056] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
[ 1194.946428] RBP: ffffb99d40793ea0 R08: 0000000000000004 R09: 0000000000002ed2
[ 1194.960508] R10: 0000000000002664 R11: 0000000000000018 R12: 0000000000000003
[ 1194.974454] R13: 000000000000000b R14: ffffffff925715a0 R15: 0000011610120d5a
[ 1194.988607]  ? cpuidle_enter_state+0xcc/0x2a5
[ 1194.999077]  cpuidle_enter+0x17/0x19
[ 1195.008395]  call_cpuidle+0x23/0x3a
[ 1195.017718]  do_idle+0x172/0x1d5
[ 1195.026358]  cpu_startup_entry+0x73/0x75
[ 1195.035769]  start_secondary+0x1b9/0x20b
[ 1195.044894]  secondary_startup_64+0xa5/0xa5
[ 1195.084921] RIP: super_written+0x29/0xe1 RSP: ffff8ffb7fcc3c78
[ 1195.096354] CR2: 00000000000002b8

bio in the above stack is a bitmap write whose completion is invoked after the
tear down sequence sets the mddev structure to NULL in rdev.

During tear down, there is an attempt to flush the bitmap writes, but it
doesn't fully wait for all the bitmap writes to complete. For instance,
md_bitmap_flush() is called to flush the bitmap writes, but the last call to
md_bitmap_daemon_work() in md_bitmap_flush() could generate new bitmap writes
for which there is no explicit wait to complete those writes. This results in a kernel
panic when the completion routine, super_written() is called which tries to
reference mddev in the rdev that has been set to
NULL(in unbind_rdev_from_array() by tear down sequence).

The solution is to call md_bitmap_wait_writes() after the last call to
md_bitmap_daemon_work() in md_bitmap_flush() to ensure there are no pending
bitmap writes before proceeding with the tear down.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/md/md-bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 200c5d0f08bf..e0fdc3a090c5 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1722,6 +1722,7 @@ void md_bitmap_flush(struct mddev *mddev)
 	md_bitmap_daemon_work(mddev);
 	bitmap->daemon_lastrun -= sleep;
 	md_bitmap_daemon_work(mddev);
+	md_bitmap_wait_writes(mddev->bitmap);
 	md_bitmap_update_sb(bitmap);
 }
 
-- 
1.8.3.1

