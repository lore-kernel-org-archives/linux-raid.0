Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFE2C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 02:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243989AbiDACP3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 22:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243988AbiDACP2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 22:15:28 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AC53E0FF
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 19:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648779214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XwUqhAQjEj0Ux/vxaE1PGSWC6DD8YEu5hBE5i+VyEVs=;
        b=Xsvl0kt+WurfUtMpEbHcOi6CfCG6xI4Bbz91ohpfMbxQu2ErSWwuhQl4HzuWpbydNcc3GH
        4aMASEDol/ySxb5R492vPHjAGQfJPGNHK05IjmZAZv0v5d/A8hJ9iEeG5PrxicrNSpxGmI
        AtdFX6btQOBwReZpznz9+xu+rGLY5VM=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2104.outbound.protection.outlook.com [104.47.18.104]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-33-SlISIDSoN3GaP8rMb80PtQ-1; Fri, 01 Apr 2022 04:13:33 +0200
X-MC-Unique: SlISIDSoN3GaP8rMb80PtQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNhAIj7mp4ebhC8ffFrb3i7eus6cw10bCYkpz3M6BQLvjDPg8l6x6jWmPWN9+HCX26kb2D/Tn2sArFUtat6mL8EqWelxcCvpoTtF2psoOoGWy7XZxtSeOPLr8dZms4sLKz6Jr+JCYwtPD0pCwd5DA72hh4PH6NWetmo544TZKC8I7bxh9okDCTwUbNAVVBFMZ/kdb6qwtbou38zDwHVaFBlDHhRBYGPemLjWlTghvxy6kDitOWCyNbOBf5evGQ0RilmPs6sdrS2HtOMU4tDsL4u6Wed2rK6clJq3/b0saCqS0vaptjDAXKNACoxGEeLWB2Me7hzlanG9ngLhXJXsKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opglVCRVWrGehQ3nYtwN92KgOUDYPVklX8CKWw7IzCM=;
 b=mGLSYbLqXYybm3xPGjBRGsLJ7TrKG8HEg0p31b8XC1IMUC9ebOhWnW81yooR7QEXEcHaTZDIx1V70wUJwH6xqPq/rvVAuQ2lihhCkn4Fjh6+ibDIwCfcnkbeivk4G2elbGSDCIEjS1WMok+IPgjtQhuIz4/yyztYTbi+nrW05S093SA5RVQBqxn822BbHhpqrIL/VwstjugiAcN/3KLQcS9Ofo1nur/Sb2Y9wmqYqM6AsxW7fl9N3lXs/T/bG9sIEYciHW9u6gVEK2Bv1BPLJduDuzjoAwSl5J3FSZt1vIZQAWS5ntIrdq2rEbYLmplGe6po7tLn3D3q2E8sftRmzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6857.eurprd04.prod.outlook.com (2603:10a6:10:114::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.25; Fri, 1 Apr 2022 02:13:32 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5123.025; Fri, 1 Apr 2022
 02:13:32 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@linux.dev
CC:     Heming Zhao <heming.zhao@suse.com>, xni@redhat.com
Subject: [PATCH v4 0/2] md: fix md_bitmap_read_sb sanity check issue & deprecated api issue
Date:   Fri,  1 Apr 2022 10:13:15 +0800
Message-ID: <20220401021317.4046-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TY2PR01CA0017.jpnprd01.prod.outlook.com
 (2603:1096:404:a::29) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f2bc476-c8d8-4f48-c829-08da13853652
X-MS-TrafficTypeDiagnostic: DB8PR04MB6857:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB6857119B48C5A18F835870A097E09@DB8PR04MB6857.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eyn5A1g/LPyyM4ubA6ywl5+OubBiQ/zK06h43Mwt4QmeSnU/KBsKnad7ESMr3UOxVCYtIXEoiQ0UejHRmq35UZfqstY20TY+c9olf4mkvRwC9/lJoCGMAzGKTIKsilzfazkYae083YS3aUOHdlilS6V90KNzd+AeiXpiClXumUToTer0skM14zJ8344fWnlHY5zBaMMKwpebCsVm8gcaqtysMTj8kkjGU86JsV01MVhKHjw5kgd6LfDxq/36UUihIjRGircECnixEKxuGIKm/gLUWrBSa4WKIYtBh7qAr9AhQpA7thxbxDn9HjJ0I9pBsxU1pg+msRoxN3IUaJn5WPRBoSHgRTKjbURmwSH3H1peZna2oEXSUFm0AEE4VgtzzOdJYXpHR8qrc3XdssbWMe+47YCXQ722MFGwueMw53NhPjpgGJ20OPZwc84sxByrTUaO5gp+zr16JqbX2n7IEqDkhFfPse9Ko7r3elSGY4VJkBWbWHe3RmKjFzRUXYaNbsL3binGh+qCh/IviuPnujDrl9e/fg9yTEVR/pngXZBVkUqJ/oe9xD5lTbEFEoUw8WFVPBI0DQdNIM0sKlnhLJczDOg6r3iwOiXubMP7VoBFcsYYHWonh0oKTKv0M/9oFa0r6aEjsEukT9GSsO3kjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(2906002)(36756003)(6666004)(6486002)(44832011)(4744005)(6506007)(5660300002)(8936002)(4326008)(66946007)(83380400001)(6512007)(66556008)(508600001)(8676002)(66476007)(1076003)(316002)(186003)(26005)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+aRBBUKPfD2lKAR87zXJxOAFDMb9KiiF6TJ5Wkj/yIBy/ildgMJZEjIcfWt3?=
 =?us-ascii?Q?zk/fEJVT65AzJKq4Wwq9aZ8QIp+DxmbKFT/xx1+VgHk53D3txAk41jRXhdF5?=
 =?us-ascii?Q?bPd9xV1HW8quSvQrEGyzxTRd7ubNXQLEX2OVxsyHLntxreReREdSK/a0t/IQ?=
 =?us-ascii?Q?IYLnHXnt/DpaLw9CIqg9msQdP8RtavYF1A/nEVaVfQNznIc/fT69mIqf4MDz?=
 =?us-ascii?Q?aYwihQ2D3qHdZDfLZJCCgTTSsH4MxFdudozFTw46pCEJwoQ28EzU7/eQl/GD?=
 =?us-ascii?Q?M/wBqaDkpBAoqHcYI+qXHw+5pgJz+pcZwSCvbjvmPtNQ/lhtnh9mw60V7NmT?=
 =?us-ascii?Q?Bh8axBDzHQlF+9uZuKIkaWUREp8LlBfGw+psFVFG8u+Uq6rje3LII7E1rDKj?=
 =?us-ascii?Q?WChwZdahPiLFHlaEILu1CBRdVfa0J3hFNhw8ZIhrkWj6ANJ+QeToo1ipt81c?=
 =?us-ascii?Q?1b0jMlCfEWyjp0tzTmHrfWonz7wpo69PR/kNSU41feQXDKtHz5Y+jX52UQh1?=
 =?us-ascii?Q?GMoc96/4aYOJjJ4OXN8G4lNEYZNbPPBTen28i99jSXrTV0dK+7UuuqvuB1Z+?=
 =?us-ascii?Q?Lwid1JZMnICq3S2YvX2ojo1GlFEz1NfaptP8KLv2G+AKlLcEL2XuxTdXcqym?=
 =?us-ascii?Q?gI18yjoIYa7prrWhH9Fr5Vy6AcH2pfHN1FIlPlkr/K1hV8z//vSLq0HLnZXT?=
 =?us-ascii?Q?6J3eTrUCWYlmo1MTH/0HE7dMvwTT61G1MDmWeqmZPHKz6RasLoN7ORltEdu8?=
 =?us-ascii?Q?4fRQwPiMmvUYQo6g/Xz2uKxbO4AgHH+lDabwaNeAy5CRI1RMQCkLTOgZWCC9?=
 =?us-ascii?Q?tmMvA6RY97ibxDXVJhkGB4IVZBlTvR9AN/jvwf/LKXQzm/kgnyS2/0gEX8yo?=
 =?us-ascii?Q?mNXMu8lKrxmHhxkkLDzpU+SPKDed5SIT1PiDn94Q3JSlhYHoeEZdY05ki9HR?=
 =?us-ascii?Q?oWTY3/e7W528GVEptOKHqZhrh6Zo1kzDo4L80GHkahHGtKradb7tQQnVxwIn?=
 =?us-ascii?Q?OSrSQxg57K5ZoK7Rf/1TLwK6I5eRR1jrKdRA8bp001hNRr4U3MCC3qlQKZ9N?=
 =?us-ascii?Q?HwRfOCzMugVXorIDH1zSgdETDk8qrm5vwAMQXH71SZnry22pi5iAMTHonFgh?=
 =?us-ascii?Q?Zkb4lTMB5wmmWwrfwUR8BCpgo4apFKUkH+xl2mcJdCClbPayY5rPRXLNkBbA?=
 =?us-ascii?Q?RbBGA2g8HzTiOz3Rj6MssME3UPGtoJPnm5eZENdO448Y8yzHaIfUh/GbmZsa?=
 =?us-ascii?Q?cz6YGHxtkVmuI3DMuS1PbPHJ51sTMsSlF2gs4CUXOd712E9Ga8gpg6/80woO?=
 =?us-ascii?Q?kKgCFtLkZqyoWOaWjjo2qnxT5C3uBqm+6r8lS+4RU3T6fqFWybQ489OoVTmb?=
 =?us-ascii?Q?/rIeQ2mjQHG7QBAvdiENuNnr7MTMLEujFhhQoYZ7iOlMrcu3dteWOi9g+1Lm?=
 =?us-ascii?Q?cJPCSNUIj9k3smVxihfzVG/N1XOFnZ+PqQ1sqUhFJu1hg/ada05Ic+jN92ws?=
 =?us-ascii?Q?wr+dK60SwYOrzPN1LYTALNXjTjxGaVXdsE0Ln7iyRsXvnD/XAsUODCT+TByA?=
 =?us-ascii?Q?qUI/5gmd3/Jjn1/hb5VXCDPfyKGfxwJE0BI9Q53XoyioURbPpyI3O6ZI78EB?=
 =?us-ascii?Q?siDD0Raj4McqYTnsr26/m6X42GD9KZB/lCNLHrH1DBvAJ3A76lPa9EYbyA8Q?=
 =?us-ascii?Q?SSGyPC/S+GxLXvObUGCPagF2fNPFYmLU2MMjc1q+sXdUFOgR7TqwBTPDSjzD?=
 =?us-ascii?Q?ZZo383i25w=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2bc476-c8d8-4f48-c829-08da13853652
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 02:13:32.2910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEOuLbOMR8NXB8JVCCiTOPFbFEZEaWQwp+7WfM2d6/4E7L09RiAUSJiHZGndI+G2vnDv3/EJ3OyYH9tLehdZag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6857
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

v4: split v3 to two patches.
    - one for sanity check issue
    - one for strlcpy to strscpy, and duplicated issue.

v3: fixed "uninitialized symbol" error which reported by kbuild robot.

v2: revise commit log
      - change mdadm "FPE" error to "Segmentation fault" error
        ("FPE" belongs to another issue)
      - add kernel crash log
    modify a comment style to follow code rule
    change strlcpy to strscpy for strlcpy is marked as deprecated in:
    - Documentation/process/deprecated.rst

v1: for fixing sanity check issue in md_bitmap_read_sb() created v1.

Heming Zhao (2):
  md/bitmap: don't set sb values if can't pass sanity check
  md: replace deprecated strlcpy & remove duplicated line

 drivers/md/md-bitmap.c  | 45 +++++++++++++++++++++--------------------
 drivers/md/md-cluster.c |  2 +-
 drivers/md/md.c         |  6 +++---
 3 files changed, 27 insertions(+), 26 deletions(-)

--=20
2.34.1

