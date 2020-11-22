Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603B4C5519F
	for <linux-raid@archiver.kernel.org>; Sun, 22 Nov 2020 15:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10ADA20773
	for <linux-raid@archiver.kernel.org>; Sun, 22 Nov 2020 15:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LDjfhh5S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgKVPOT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Nov 2020 10:14:19 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:44858 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727728AbgKVPOS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 22 Nov 2020 10:14:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606058056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DIdTsKLKqEB6IWd+aDs9kXnP+hYExmhWtCQe8qkmpeY=;
        b=LDjfhh5SJdz94jZ1QG83iWoXfMBXm3JniGnO0q6+4Ep7VC5G9cWGakpDCbGrOyxfp+8tnK
        /qWBotLM6QE2v+LHMjeRwpP+jizLWPQBSUEcdiZ6fxXS5W54Fsw0n2glkhXbyzR5Nm3Ej+
        LOZUAcvQqACd5+UocutZjL7y8Q7vItc=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2050.outbound.protection.outlook.com [104.47.9.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-4-eMy8_OsNPFqVX3Jfy0CNpg-1;
 Sun, 22 Nov 2020 16:14:04 +0100
X-MC-Unique: eMy8_OsNPFqVX3Jfy0CNpg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UN7kr6LFmphelIcnotI0A95EZ15E1jj4aTUvNumM85uUvPLU9C2HrOPqL8Px2DOzMCbXbidtFnqstYxnK3p0bFAZCHrvMSj9Qp45mFFREBtbjNBH6V+xeR2DDCYRuUACO5xpyQnk1no+WWiTwxl7KcFTxxqqOv5lMk4zJLyyXONv0WB2M6QV6WMDIha43ZD7evqxZ16qp8zhc+SNmEkygdS+val59pU05WkKL0Xos1axhS6Duw05tpXevMsZIktKdpTKjTuaiwaPqJJoc8m6sEbxJL7UH0ML4ZrIbCoRHTn9lUlZKAEpjnH+ZOlTAsHwB2ehy5FbI9gB8by5JcZvwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxaxHUYuhsUgJg0VuJREEOqz9rngPzrE77IWdAnvFEE=;
 b=l8ZoIEpY2w2U9pbZWbV1M4qUml2HepaL6kiXWnaAb73UKLI28vvNjYX6twscWjvktFfZrEWFBML5JYFyEEb+Rc2IwtxR5iozvuWwfqvqCkuM0gZV4Jd7s+ptkHR7UFXq55yhnrw8dFKCQOkHbs8unhpqmxl6BTqZd60d+UGbI+NZMRDuwUgxXNpSOc1/Agdvz7AcwGdUmLiJxzG0H8oz2n4M3DuHLLoFQYxl36t34/cJuKuxqOlv+sS/A6lLuCQRaGGuwZw27DTGJktCmdy8xXoa7aL0/3WzuBzosA/e30zeQONAqzkDub26ulu9KSymyryEENkGUFyDGAmQTSZ5lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=suse.com;
Received: from AM6PR04MB6536.eurprd04.prod.outlook.com (2603:10a6:20b:fc::30)
 by AM7PR04MB7109.eurprd04.prod.outlook.com (2603:10a6:20b:117::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Sun, 22 Nov
 2020 15:14:02 +0000
Received: from AM6PR04MB6536.eurprd04.prod.outlook.com
 ([fe80::780d:31fb:2dd5:b84f]) by AM6PR04MB6536.eurprd04.prod.outlook.com
 ([fe80::780d:31fb:2dd5:b84f%7]) with mapi id 15.20.3589.029; Sun, 22 Nov 2020
 15:14:02 +0000
From:   Lidong Zhong <lidong.zhong@suse.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org
CC:     Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
Subject: [PATCH] Detail: fix segfault during IMSM raid creation
Date:   Sun, 22 Nov 2020 23:12:29 +0800
Message-ID: <20201122151229.16365-1-lidong.zhong@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [39.78.22.199]
X-ClientProxiedBy: AM3PR05CA0091.eurprd05.prod.outlook.com
 (2603:10a6:207:1::17) To AM6PR04MB6536.eurprd04.prod.outlook.com
 (2603:10a6:20b:fc::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux-rzeb.suse (39.78.22.199) by AM3PR05CA0091.eurprd05.prod.outlook.com (2603:10a6:207:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21 via Frontend Transport; Sun, 22 Nov 2020 15:14:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ed9d52a-1c37-4209-ac39-08d88ef93e59
X-MS-TrafficTypeDiagnostic: AM7PR04MB7109:
X-Microsoft-Antispam-PRVS: <AM7PR04MB7109F53779857A66B6296A99F8FD0@AM7PR04MB7109.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S1IvDBSHAeBDn140KaIl0FAZu4GeYAKYat4dFkT/n46KyOf8BX4PEOAm/iXmtrKpQrt0HuwXaqo2wFF3goHtuUVLbPBgcAagwy8VRoWLqk71Whpjutf/yn91aaSz1BKOW2v7CLkG+x5L9QW/WCf2VCZ9pEQLQj+hjdGB9enYMKH/Sya1YOs0FrDTcLIiBQM5SQ0yNyXq/sXbMT24ZOpWWM5FflNpEI5Nwl72FpiANlEYzMsztp34rddncZTPmogaxq/tgxS4RcWWhaUWkriNo3NTAK2gAEslIkzcSnKJYxDwHDgOfFKfHPiVU75OnThFnVkhjsnPbmeyefFhQqNWAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6536.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39850400004)(366004)(346002)(376002)(36756003)(86362001)(478600001)(6666004)(4744005)(2616005)(6506007)(66476007)(4326008)(66556008)(956004)(1076003)(8936002)(186003)(8886007)(316002)(8676002)(16526019)(6486002)(5660300002)(66946007)(6512007)(83380400001)(52116002)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kOmmBkoQkHH5buG2CUCG/G63+VmS0wFv87y8B4G/OxqkuurIqLGmI3DYoorm3UfrXKvF+Dz+FFXzRJuQFGdby0iPhAqZlW2nx/pX/i86qMQmNrlQvkYiMPmFdmDf6bnar9aHv5oxJI/9vdNGl+I/Z7QrNH8Qt4q4daUEl/gtG89FfCb8tpcVZFnJfEvwKlgK/oeDhya4xFGneVi4Y3MPocTX8Fy1CODDNfCAkUe42mqgYef8GzmYjVMs3eNENZutRGiezFhCZrtUcaAUd9MhKBWcjTCSW0vUW7Fhkj76BRymcB8w0gUBUo90FBXEUQkK/v32Qy9IoaWJ+24U5Fx8304JWgtTQyFz4pjORIT/vYXCY0qoN5rYwnN80CX2ItY0wj8pS4lBAEdkPKg8ocBwT1ZA0K0RhJN3kdlDOIo+zx4yOYurDw+Niamyxjmgh27dG2BqiWC6LGdBBLnxaX9351hIHeOhWrb5Y8cospWSpumnHdEnq/LWwv8kM6RPj3PZZEJGYACgVCIGn4gNhQ0MG5RaFaMVIQTiR9/srsBYqmP61CgvSRwke4xVxfQdse8h3DcTfamnSyT4yfGeQrDK+kOoiZvdeWNvQoKE7z2p7VZzL78f5G0U/0aM/QU/P8ye5ni+TaY9ndbkE8ydZ4Fcsw==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed9d52a-1c37-4209-ac39-08d88ef93e59
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6536.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2020 15:14:02.5935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GMT54fMn8qBgmUKm77G+nheatfZfweQoAYhN8Z9xAn6m6MM3fBbDfsoOdp83KPBN3/jMgHWOw9jIYDrZPitz/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7109
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It can be reproduced with non IMSM hardware and IMSM_NO_PLATFORM
environmental variable set. The array state is inactive when creating
an IMSM container. And the structure info is NULL because load_super()
always fails since no intel HBA information could be obtained.

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
Reported-by: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
Fixes: 64bf4dff3430 (Detail: show correct raid level when the array is inac=
tive)
---
 Detail.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Detail.c b/Detail.c
index b6587c8..ea86884 100644
--- a/Detail.c
+++ b/Detail.c
@@ -224,7 +224,7 @@ int Detail(char *dev, struct context *c)
 	}
=20
 	/* Ok, we have some info to print... */
-	if (inactive)
+	if (inactive && info)
 		str =3D map_num(pers, info->array.level);
 	else
 		str =3D map_num(pers, array.level);
--=20
2.26.2

