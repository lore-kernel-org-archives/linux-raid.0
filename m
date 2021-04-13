Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8619C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 04:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C37DF613AB
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 04:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhDMEJJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Apr 2021 00:09:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhDMEI6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Apr 2021 00:08:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D3xZnb195353;
        Tue, 13 Apr 2021 04:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=OuG3dIcLAMf5u+CgCMKuMXJGjsUAjNtMIpPjEKeLwFk=;
 b=ZMAL/2bue/kIzjlH9BO/uBRLgyydVFZhYvsWW0+ADCrcfDEVR0iqtbPhcfXoCh/4/EoX
 FpoG0aFbYYKW4DWO/0iuFfyqRFJPTOSfkNFpGu5+mz6z1tmmgqmlMbhWXNPLF3WZMmsY
 P5ZnPS1oIKECwYAAZ56cxO5NOOBenZNG6iygx9yXHTNWoFzbJ+TQ4ZgBi3a+LdYljiUx
 A1Pi5yQ2sckRMNmqKkTg/ZQETNKMmqUYDYGkBWHRP9T3aDnmWdTCvUnzkRGJP+MgquIc
 v6oNdxMkGb169P+BmCtyFzDXfIg1azjpRXSznyXnJxOoJW4vnn7u6gWAlPfulRk3FuDT Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nndnmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 04:08:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D45dwR064217;
        Tue, 13 Apr 2021 04:08:34 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2057.outbound.protection.outlook.com [104.47.37.57])
        by aserp3020.oracle.com with ESMTP id 37unwy9uv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 04:08:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2SC/BAES2x+tXxMcAs+PdflmMmNCHGZQWGXMgY1i5E2Vz1t2eQAJGQDc5CD5oFPjh28mOeUbe3YXDtc1SMoT5PurRtw+NI8/mSBzFzCdr9d9q0v0XoDSj61n33TQLLba8v8/cWCGUuEmrN2nZKwegzKd2rmh6AsrTKJLRcS+3pRzMf4KMOTMLh+2KAN1ojb73961WQCnVwlCQp2zSoa4WiiEQwboA6O93z47oWkhWsxvdSYA6rqT4ouhasK18Xxvzo8j7CxLjDH8t/8rhDo6zUjQNDgXUHQNCmr87n6/OK3WV/EIMoHrSL87QaVX7q6iA/p79CQ1GRaTQsAGeLfjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuG3dIcLAMf5u+CgCMKuMXJGjsUAjNtMIpPjEKeLwFk=;
 b=O5IghJvA/XKBhoB17j/vceDCIw0e2Eu5kMru3wQLP7KQfNr+nsMWMmJI1b4JKh9e3ogzp6M7mm7+qDgnuuAcqbTrys7eyhiB7ypvn4LnOG0JeM9Uvhm75qv7k2dTsyK+r9nf5IPaJ2u9kGpD83MML2hXHu7LYVKRVnNzVY8DHUfoSUJCIA8fozVKB7urzY/wI1+qj5Uz3hXmpIUD54mUr10Ea+idwqOfGpnIfx+Hhy508HhrhSCh4rQIfCEzF5WFy10AtkFFpTHLIDGw1+2EFxT12or1nyzgj9MHFXFFtnogS1iC7o5f2bfbDH8hqMVIfVdQSdK2rY2FPD/Fbs3YGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuG3dIcLAMf5u+CgCMKuMXJGjsUAjNtMIpPjEKeLwFk=;
 b=tBumiRebXouDRUMbyGYnRX04UaK+MyAQ0HG4wRqRjWFn2UseEkBBHeQLaof/aDQmlWu4RdQDEQXY7BJOZqNVaJVHr0MOZcHS7FZIKlwhJZVtrsIxIuNRlrg0ePCklq09vw8xzUDkWAB4YYiG6Z3TRfdMx7vJeuxuic3m1wj+iek=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1272.namprd10.prod.outlook.com (2603:10b6:910:7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Tue, 13 Apr
 2021 04:08:32 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974%2]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 04:08:32 +0000
Date:   Tue, 13 Apr 2021 04:08:29 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     linux-raid@vger.kernel.org, song@kernel.org, heming.zhao@suse.com
Subject: [PATCH v2] md/bitmap: wait for external bitmap writes to complete
 during tear down
Message-ID: <20210413040829.GA26897@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [209.17.40.37]
X-ClientProxiedBy: SJ0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::15) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (209.17.40.37) by SJ0PR13CA0010.namprd13.prod.outlook.com (2603:10b6:a03:2c0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Tue, 13 Apr 2021 04:08:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19b8b059-f097-44fc-3f57-08d8fe31cd57
X-MS-TrafficTypeDiagnostic: CY4PR10MB1272:
X-Microsoft-Antispam-PRVS: <CY4PR10MB12723AB86E58379825F46AA4FD4F9@CY4PR10MB1272.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AITuO7FeNC2sGR0rBb8V0vsrvGPDPEKzEH/PxxKkBmOb9xRfZ1KMCRecm2pzVI5xkeXP96iKufyEgF2qFCP2fs+bbHAf8ltukRipuy5fh99Of+j9GLMsG5n3mXlKzdJAY0hHcipzmFe5j6X1gkd+BRgCjG56VSNDxzt9JlVW9Ccm4Uy1i72kdc4Na7AGLwFd3yZZaQrUxkFaJQAylJJ20IWJ2JdEZNwsRgGKnDS/1Nnn4uPNNv1eTwNn9Ytx5lku5dMamDtGlLOmhEfnOUSd2+Tg0Q4x99inonNK/j5OeU13t4JoUwtBOMYrhQftfgZ11cFihRUZKTxsTWMr94hWgH6gZc9Gy3KmQCc6wdH+Rcr4TlC28NiCfPSAsv2c01YfSUkQMN+f9jS7Bi5g20DQN//QW9Kqm03axy+o1HK3LVZQkQrGutmgTuSE08+OZyGdHVwTxzXMxIxTqqZ8U5yHsiOyIJiU6UrdgYS8s91HRNbIZ5GePGVaeHydzbLHXh/r8XrMd1n9UbmAZswhsLus54K3vGfsJcdL8rjdODct87tQBPycFPuASKjcN6EI+5JrMEOJNAnRGhWbzetOvzlyTp2NwaUOisFW4DuELFKDpgdIwCaBl4+AhGMYBSTkf78jVimnqyq3q7DLmHD8wtTkb4iSoihDTI4TvVwG2P/aQ/U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(136003)(39860400002)(376002)(52116002)(55016002)(8936002)(44832011)(5660300002)(8676002)(2906002)(7696005)(6666004)(66946007)(38350700002)(2616005)(16526019)(26005)(186003)(8886007)(956004)(86362001)(66476007)(1076003)(36756003)(83380400001)(66556008)(38100700002)(33656002)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jTp3zM58h9ZuXHiNzxTB6ZREYebz1RiWql+2CrrQgmXsKd6b71ETvZOQO+Un?=
 =?us-ascii?Q?TdWID8JsCZcFkBTfgcdyrBJUNHdzgtu5vmS2Ric0dPJbPSdR9cCi8nF8kVAW?=
 =?us-ascii?Q?dngf93FyqXEsTnaHf9plwlVp+eWAqzG2F3Idk8Pycqqkt1tml7dkH5ccVbNV?=
 =?us-ascii?Q?0Y6lbiUcpJdi26xocNWSR2yF0ZTYkMwOCLmGeLisaTsWnwc3mOJzU9haW/Au?=
 =?us-ascii?Q?nFPdH6OStAgP9cZPbuFW4flNA2OnQnkxNM45CvJ8WwIfaPlsVLln6FXEaN3q?=
 =?us-ascii?Q?/N2UDsq+erkzVYvQvE05hevyXpT9BYzn870EpWrclIF8HM12a8Px1Hv3gqSZ?=
 =?us-ascii?Q?lYvFgCBrt6H/TyCzqdyNaETPLQs4RlQhJfSmLPmzpEYtduxh1bKooiShid6Q?=
 =?us-ascii?Q?sQQs7iLuoeQvTL0j2BDc48j1VVS4TwykyJKPNGW1zPFFki8i6228+mntkz/s?=
 =?us-ascii?Q?LiDsPo97RIUWbQ0ScxaiHOY9huZmEFxbGLb6OE4QXgvBCl8azxB3q/grJNHo?=
 =?us-ascii?Q?kzlCkm0vjr+aJtN4m3OkMiyJUA3DlXlv/d+GRAXefkFXAkVLh0BnfP0AahtL?=
 =?us-ascii?Q?ZwWx20IGwg2JSSlG8PHBCob10Y9HoX52lM2B1zLERREVpjG/HFIDkxWicOWR?=
 =?us-ascii?Q?p5NoCPkJ62ZyRoWCq2RknlnAQZpOuhDjDlH6N1yPeshCjDkMYWF7aWirCqUC?=
 =?us-ascii?Q?DR6kg4P+m8IvBMdezMg9BHGDEVonpA9yCE9Rzxsrj7A0/e7mgaYvg5vPjDT4?=
 =?us-ascii?Q?mPchfaSrPwt6TisA8sN40GRqgGhEJw4PwObPwbWUCuNFKwHBmoxSTL86u7S2?=
 =?us-ascii?Q?BTIXZ+xAVZ1AFnpdjIUY1kJZcR2gaFSTt1mKjqIMGVUX3ZeH3St8FafxmfO1?=
 =?us-ascii?Q?CpB3daWq2alWdNbTQtA+NzCKTH8npsNa76TkvJ31gOaRGK67Aj3LD2voD/8L?=
 =?us-ascii?Q?lAxMMCr5Q6/1gdvCxhpmx1s3UL4GCUVUxzJdPlQ+hQfYtAX7SwNOuvHny9+j?=
 =?us-ascii?Q?rZZct2aQLVeQpoh84IxF+il/LQCyLswAVK+VEXYdWK68PoNN57y+IqNk8Oz7?=
 =?us-ascii?Q?47TfqY2rfgWaG590i915WLCL12C2HIBu/07FuYboHzZPw0HHsvC3Un8b+4cW?=
 =?us-ascii?Q?7e87sm4uhsQjlyLLUOdExe65UFntrolyEViPSE/s6Amn3ClqSfMb4xQrEXDe?=
 =?us-ascii?Q?iJaR0zvdIxcBNypBQ0QqCpqGrkYHvoUvZiN4JJUxV1F9HNesxe1yz4YDgmaU?=
 =?us-ascii?Q?cISgZmPF+1afrsNTQEVmJ+xmW6RdBYjc9L/yooUSH2xIZQ+IqpS9MoxVgocD?=
 =?us-ascii?Q?iWXunKi+E7+vHUhbkuRCjjfZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b8b059-f097-44fc-3f57-08d8fe31cd57
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 04:08:32.6844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDUkqofiBLbr6FuiqW+9vt95UkkWbmTrobzvyY9uZ1PfIQnyqLrrZBWlnpRs9wNDiX2dh7Vr3pM4gE0KRuP0dQ3NmoJDAVKGERvzNdVFvy5fxDcwaw4bt+Lmyn8U7pa4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1272
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130026
X-Proofpoint-ORIG-GUID: mhmdVswselhqQrvEx4TEJuqwucqsNw-0
X-Proofpoint-GUID: mhmdVswselhqQrvEx4TEJuqwucqsNw-0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130025
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

NULL pointer dereference was observed in super_written() when it tries
to access the mddev structure.

[The below stack trace is from an older kernel, but the problem described
in this patch applies to the mainline kernel.]

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

bio in the above stack is a bitmap write whose completion is invoked after
the tear down sequence sets the mddev structure to NULL in rdev.

During tear down, there is an attempt to flush the bitmap writes, but for
external bitmaps, there is no explicit wait for all the bitmap writes to
complete. For instance, md_bitmap_flush() is called to flush the bitmap
writes, but the last call to md_bitmap_daemon_work() in md_bitmap_flush()
could generate new bitmap writes for which there is no explicit wait to
complete those writes. The call to md_bitmap_update_sb() will return
simply for external bitmaps and the follow-up call to md_update_sb() is
conditional and may not get called for external bitmaps. This results in a
kernel panic when the completion routine, super_written() is called which
tries to reference mddev in the rdev that has been set to
NULL(in unbind_rdev_from_array() by tear down sequence).

The solution is to call md_super_wait() for external bitmaps after the
last call to md_bitmap_daemon_work() in md_bitmap_flush() to ensure there
are no pending bitmap writes before proceeding with the tear down.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Reviewed-by: Zhao Heming <heming.zhao@suse.com>
---
v2:
- Do the additional bitmap write wait only for external bitmaps.

---
 drivers/md/md-bitmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 200c5d0f08bf..ea3130e11680 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1722,6 +1722,8 @@ void md_bitmap_flush(struct mddev *mddev)
 	md_bitmap_daemon_work(mddev);
 	bitmap->daemon_lastrun -= sleep;
 	md_bitmap_daemon_work(mddev);
+	if (mddev->bitmap_info.external)
+		md_super_wait(mddev);
 	md_bitmap_update_sb(bitmap);
 }
 
-- 
1.8.3.1

