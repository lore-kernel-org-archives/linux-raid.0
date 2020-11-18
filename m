Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042B3C6369E
	for <linux-raid@archiver.kernel.org>; Wed, 18 Nov 2020 16:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 782EC20780
	for <linux-raid@archiver.kernel.org>; Wed, 18 Nov 2020 16:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fxBGB+YP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgKRQqC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Nov 2020 11:46:02 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:43970 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbgKRQqB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 18 Nov 2020 11:46:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605717959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uIKhj6pWxyGWQk/dxGtYam+MK4oPoktEFTVurVt1Gd8=;
        b=fxBGB+YPogprN+iHlgohDAsqjv0x2/2F87vUjee4Uu7Uf8R7rdaExLN2sTj4A/7/SYuac6
        N1rceBf+3A51Ccr20DqgsodJDb58+iFuEmpWXWFDv64qUXKPLqz0nlw/cwvHy9LY7CGIHJ
        c3YHgj8MzV4hjwxKTzSTveIiNnjkerU=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2055.outbound.protection.outlook.com [104.47.12.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-_GloxSriMMCyrxmucY6lnw-1; Wed, 18 Nov 2020 17:45:57 +0100
X-MC-Unique: _GloxSriMMCyrxmucY6lnw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTeurL99+prhn/33AqHNc0BLrxj4dZgEqyBPJb7jWIuBWD70gv+QWCccuvWtcGjZzZkkyjd0BUeqN/fHkFMY/ydz8jcZse9/TcVn8mVpEmg9posCnbMemlZrGH87t5ONHM3kDp4JV9jiWsT1rs9QVwOo1B9NeX8keoOX6QyBpwa16X690xDmv7SUvYQv0OCICHUK9J3n0leUEnl57PfoeDTC+O3KP1UqHE1vmToM1ZreqnmD/1qKzRyOMi/P2oHPIdJ0oMGQBBtY+raTfds1wwOX8rrKnTou3KA0LFSS4/ay8G3linM91OGftteOrQbOPmZMp1N9SFRq8DkYzVDgIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpJyQIZPvnLAZKf4meFaMeBSpDZTksERPQSXmvBsFaQ=;
 b=b+g7lsLfdtzZg7mTzW14EUgboFU5/vDfK6CSL0LVZPz9Ywe7R3q7sHZigXAAfZmSi2Xligcjz9d7e/O4B1gYFyleNN7+QL27tmoevywLhM2CpM0TStcf5b56N0v4Y9AXDrLCxOPYV32eJn+KCrprJmY+mGvp+cWXj+KW9cXWsxxw0u8DtTpb9LQ9mFu3v3S/G3PCxqyFOe0fekR1pno6wMn1iewXwYpVETi4fcCt0u6XWlmn37cfGk1VC9HfcuAYgOgt9ihx0hXQwRHym3KSJgujvZEFUvSv6nTvFBtBeclhN8vjY+Nb7RSYooP0lH3o5qZyTznLFrtwugOFAP1xXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB5643.eurprd04.prod.outlook.com (2603:10a6:10:aa::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Wed, 18 Nov 2020 16:45:56 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 16:45:56 +0000
Subject: Re: Events Counter - How it increments
To:     =?UTF-8?Q?Jorge_F=c3=a1bregas?= <jorge.fabregas@gmail.com>,
        linux-raid@vger.kernel.org
References: <819ff80e-10d0-8cc6-b34c-418fdea7b57a@gmail.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <567bc78b-cf37-c40b-2e99-b86a80bdfb3e@suse.com>
Date:   Thu, 19 Nov 2020 00:45:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <819ff80e-10d0-8cc6-b34c-418fdea7b57a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.135.93]
X-ClientProxiedBy: HK2PR04CA0079.apcprd04.prod.outlook.com
 (2603:1096:202:15::23) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.135.93) by HK2PR04CA0079.apcprd04.prod.outlook.com (2603:1096:202:15::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 16:45:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26e16351-960e-444b-ad4c-08d88be16b5c
X-MS-TrafficTypeDiagnostic: DB8PR04MB5643:
X-Microsoft-Antispam-PRVS: <DB8PR04MB5643CCCA5D8AB77AF00C280B97E10@DB8PR04MB5643.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ynKlfnP9PPtmeJNb3P0i38O13jBSqCA0bLBkfzJCcOmOH+HHoc2MRqsyvjVO1zaK3XlsSgE2h3NY/GvEZPM4jkvhqipbSm/Ghy7SI+Jz1Q6jUqGi5Xbhs7sYdBjksgdtbu9bvFTAD4AV/HQP33Bndy2OMPgXMTCPnECUliPCD0zpXgCpbTu3bhN+TNCfrdgFIYrkqlCrRF93ZbWuNSp4bTg0fQOZ5Lj5NT+q36l7QZP6XF3l4o0vl13IElVZSYhItGwHfoyf24fwceuKlnRB8t7va5EUs8IREx92RCGCSL+/Zl6CghF30QcNt3Dss66q7yPQQDLmEwtOw/yeja9xQl91UAW+Mcoej1z83zQBkNigb4DzeyP5TBY60FLB7lVZsy4lgST34/RIHEUxixwOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(6512007)(8676002)(6666004)(4744005)(66556008)(66946007)(31696002)(16526019)(31686004)(316002)(2906002)(478600001)(2616005)(5660300002)(956004)(66476007)(52116002)(186003)(8936002)(8886007)(86362001)(36756003)(83380400001)(26005)(53546011)(6506007)(6486002)(66574015)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BwOl/b7+s/avynEilnH6fHZfLcciKV+svzJMqKs0GYpqsurZ/m8PQKOzXfJWeqIdVH71aivNNRcAMHh30Vn1nLeW9w+bbObAEJ3OA2dQkX7z+BMLsMA+UrJwGUp0LwsPpVlqGodAxR0dn4kD19cV0aptu1Cjfrsosu6srvMNIm3/mKSLQqiUJfWf1OWX+xXDp2xg+iAMcGVOKOqvxUGu1yhGI8UrQ3Mbt3SbEIy2eM5PXVAM+kdU1nNwRPmxLYmnMsX2XogNUPDqOPBjaZ/OAYqfs3QFL5VDa/5Xf5/iLfc+IR8oMh6YcLjxVOawmcjgA9DjHF4WU8J0DOqXZHYu4dvcKOBPxqtD5G2xnBXz9mG1Ay+u9S+xKDdngd3cW6sBqrjk/qi8OywFVFLTAs8UXHDJIeicSIp/nLTZaEyL5gDoSPNp+Dd1+1jX3mviUe+GOJx9J4NdpUy2byRQPC/hpZDOYUuyS9HsGODJKaZnSuSRZueVHZLqF/GhRh27v6l8BpgZmf1P/AywfdqgbjPBkKbZC1Xxb8+b34tRFMAQASTBU7ynVH9hxULO8sTEFpGY0anB5TgjYyn3NMbD7CeaSVvBjFNo91NigRGnM1hMLoZyITI/irYJPvDmPEAiIMy/ycKcNNg1kpfRqgHDO6En9w==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e16351-960e-444b-ad4c-08d88be16b5c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 16:45:55.9802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NPOLmdlU/Fg8Lk9ShhJIm4t4HnSSG4sLrN0zRatGTFZJ7TNPIkq16QIE0gtekdM6Zh4HZ0rUCN2+MLnLAfuhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5643
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/10/20 10:24 PM, Jorge F=C3=A1bregas wrote:
> Hi everyone,
>=20
> I'm new to Linux RAID. I've searched for a clear explanation on this but
> couldn't find it.
>=20
> How does the "Events" counter (as shown with mdadm --examine) gets
> incremented? On what sort of events?
>=20
> I was initially confused about the "Events" (thinking on the different
> events as reported by mdadm --monitor) but I see this is another thing.
> I've seen explanations about it incrementing after performing writes but
> I've done some test writes and I don't see the counters changing at all
> on my RAID1 arrays.  I've also seen explanations that it increments
> whenever there are changes to the superblock?
>=20
> Thank you.
>=20

The events is related with (struct mddev) mddev->events.=20
you can search it in kernel source code.

and the 'events' is also recorded in md metadata area, with struct:
```
struct mdp_superblock_1 {
   ... ...
   __le64  events;     /* incremented when superblock updated */
   ... ...
};
```

