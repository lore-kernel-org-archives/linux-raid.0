Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57CDC388F9
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 11:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42789246EE
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 11:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IwupS+HC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgKSL1U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Nov 2020 06:27:20 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:21283 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgKSL1T (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 19 Nov 2020 06:27:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605785235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eR2kHWAaQtkqv2ktfrvTsrDgDwW+RI+q4vtJQOwgTDc=;
        b=IwupS+HCvMeaKWXM8ykR9WZfiARKKD2CTjfnko/3hxrGobruqxIMUIVqT54GTaKBk6bqvf
        IEVmMOHMHqqHDwM9bH2tSXiNVc9pqGU/LA8aOFH83SKerbQGcS82pUTHyjhGk2UjZZeNPz
        xOlrhASDOCGY6dQit+6vjnzziReVqgM=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2058.outbound.protection.outlook.com [104.47.12.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-13-TJlMgg28PoS6sfzkqw7ocQ-1; Thu, 19 Nov 2020 12:27:14 +0100
X-MC-Unique: TJlMgg28PoS6sfzkqw7ocQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K44tF8O4EdBLKmQavHWmau501mx2RXsszqA6dfxIln5Uc9p8T2pWd1J/8RzpcZfcYNnPywVppLYfeddfbUEise6l8z7JnMk3zIXpljUr91raJf4PYciXCRaSxgQS4PfvHcqJMI94nUDMJycw+dXpmOU6HhDEIL3xUkzOXRjLAHNevena/nQY26WqlGhdAYlAJhmMzNw9YBKLjDFpZH2KPiHkKWpOAq/FcHqvuZ6wZD8IKEdne4XVFU+qWJ0ZQkVY77M4mIU9zSSSJff8qmh9Z+n0g2yE7EEuM91PQSqFqHnoI1E8gRSSGTXjX+Lpf4vTziFTEbFeBowKsTotkHLjLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6QMAIJvqj8eFPO3VMUYx+u1L2uPkS7WiIj7RVOK8b4=;
 b=Is7FXkFdIUDU1hU6TANecqn7XBBoJH4e59HEtoSeacqOJ97gAss2NF1GFfEwmSWp/4+t92YLSB0LdSiIBSYTeNmdy0ACG0QkjPa/VyxQMtYbqg8m5Zl3DJ6j63GoFMYWIvbBM34RbGgmLX85zdHgELBTjGSklzv1UrhQywLfePjGao0XysYP8+SLrN8pQ1Xzh4zY+BqTEd8y9uzlksdgDAMhqoLy26/w6a7T4zorxFQbfC5AjjqigBXdwlWwjqo92RTYj6IRnpQzfjjcql31wkQgY1tcOBhX6QD1HPquB49MwFTpa18R2P1Pr+kEgCAjY37bRrbcDz4gX3uNXYcPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB5644.eurprd04.prod.outlook.com (2603:10a6:10:a4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.22; Thu, 19 Nov 2020 11:27:13 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 11:27:13 +0000
Subject: Re: Events Counter - How it increments
To:     =?UTF-8?Q?Jorge_F=c3=a1bregas?= <jorge.fabregas@gmail.com>,
        linux-raid@vger.kernel.org
References: <819ff80e-10d0-8cc6-b34c-418fdea7b57a@gmail.com>
 <567bc78b-cf37-c40b-2e99-b86a80bdfb3e@suse.com>
 <f2d69b9a-9e2d-a104-0600-612f5d39084c@gmail.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <4bade6e8-988c-11dd-0a77-5adffd926d7b@suse.com>
Date:   Thu, 19 Nov 2020 19:27:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <f2d69b9a-9e2d-a104-0600-612f5d39084c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.130.58]
X-ClientProxiedBy: HKAPR03CA0010.apcprd03.prod.outlook.com
 (2603:1096:203:c8::15) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.58) by HKAPR03CA0010.apcprd03.prod.outlook.com (2603:1096:203:c8::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.9 via Frontend Transport; Thu, 19 Nov 2020 11:27:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ec8299f-de2b-49d4-9242-08d88c7e0f89
X-MS-TrafficTypeDiagnostic: DB8PR04MB5644:
X-Microsoft-Antispam-PRVS: <DB8PR04MB56444656E5BCD8E0655DA8C597E00@DB8PR04MB5644.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGQUUxuReTzCJQXfixOqJCNbfmCe/48fCyAvy9Z6rGNxio9L2xE4Pb4mbgp6c8L52yzJQBmHNWpHIrcf91RDpDGlGZXVhwJzafTczG9jka/t8a37u+nh2aCUz5vwSqS20Dv1TejY9f1UOFbvtJJ93aQzEEcIfRADYu4d7MqyH0iRzRCaIdxsgdRk0va9duZhCVRqcCZZ6xF+9A56vn0iuMo4ZyhDoDyc8hW3NhJygVBgKmwg+l2U/QbDjsLQnEOq7WDXvxYNSILADFh2U8XQgf+0K13mTebuBiNFZIzmq/dV+j9+9r/LhJbQ4QFJMm52p52BDe9guMhCTgsax6ySgxxNwaf2HtjaDUEmaDu/uFHAirkAFTa5zoBBtZhX9vGomqeCRTCwdI8RbQufLEEWSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(366004)(396003)(31696002)(53546011)(186003)(16526019)(26005)(478600001)(6506007)(8886007)(6512007)(8936002)(2906002)(8676002)(83380400001)(66476007)(66556008)(52116002)(5660300002)(6486002)(2616005)(316002)(956004)(36756003)(86362001)(6666004)(31686004)(66946007)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2QuTtTMaQqlXidrz3paKWp+8bqJntW+PbrZyQVwvdoZu3V25M9pwJTrpa0SSa+Y9/useeqAYEtFnLClXV1uQELZxSuZtLi/Yx22cvo2gitWYec2BsTPj6OtFSbHD447fWvUyN5v7VAmFrbA48WxIdip+u0SYiJilRHWg7np7jOP6D6QaiHFZ11SSOQqVgTAyXwmzT+JsyUmkEGe3mXcAXazJTzvWYvwTLgpm1RdSrWdSGV+irOCRECWd6Ox2jhFFqw3wM1EJcZzaSmLFt6VuQdaLVKWvjUvCI1Hu0QmB2JrDWaG/Q8kKUv3NKws6bMzIKJbfjsGHVF/YxGd9yzesJeO8G47b2WA/S9LednH9CMdEILhD+Be1B5N2CNL/61R8K9RvvCrI7ju9xuR09c1Dx47AjawecpuVo87fZrgPm2mWh8wwArWZ1sMt5Pf6U8HDT2mZkck6FPY84ym93hcuSUPut8uzVIsFt62fGO2+rk/Ir6muITJgbf9djR0nnC1xXEcYaVw5ySK2YtzoKYqmtG7spKCpaEzJcNaGSupSuFPe4oXLtRexUAmsvBpr4qn/a8FqEUBTu2KE1WJGppNH11GYPoG18MbZju2w3L3lINpd/H7r8Kuk/tMvwCvJqQGX+3uwNsxXVuzO0Swcmmth8Q==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec8299f-de2b-49d4-9242-08d88c7e0f89
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 11:27:12.9535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RMt0WfYnv4e6tI2cijAnJmyrbCB0Vo8zOcJlnLzdOUGdwH1SWqnU2MXwYP9Mpab0Ls6jNgHhsIk4aeYNFB/ylA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5644
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

On 11/19/20 10:21 AM, Jorge F=C3=A1bregas wrote:
> On 11/18/20 12:45 PM, heming.zhao@suse.com wrote:
>> The events is related with (struct mddev) mddev->events.
>> you can search it in kernel source code.
>=20
> Thank you Heming.  I was expecting more of a general view since I'm a
> new user.  Sorry I wasn't clear.
>
very general overview: if array status/superblock is changed, event will in=
crease.


> What sort of events cause the Event counter to increase?  If it's mainly
> whenever the superblock is updated then my question is: What sort of
> events cause the superblock to be updated? I can imagine detection of
> failed disk, read errors, array checks, commands by user/admin,
> assembly-reassembly etc? If an array operates fine for months - without
> user intervention,  will the Event counter increase at all?
>=20

the status/event is the content of struct mdp_superblock_1:
    __le64  ctime;      /* lo 40 bits are seconds, top 24 are microseconds =
or 0*/
    __le32  level;      /* -4 (multipath), -1 (linear), 0,1,4,5 */
    __le32  layout;     /* only for raid5 and raid10 currently */
    __le64  size;       /* used size of component devices, in 512byte secto=
rs */

    __le32  chunksize;  /* in 512byte sectors */
    __le32  raid_disks;
    ... ...
    __le64  reshape_position;   /* next address in array-space for reshape =
*/
    __le32  delta_disks;    /* change in number of raid_disks       */
    __le32  new_layout; /* new layout                   */
    ... ...
    __le32  dev_number; /* permanent identifier of this  device - not role =
in raid */
    ... ...
    __le16  dev_roles[0];   /* role in array, or 0xffff for a spare, or 0xf=
ffe for faulty */=20

I am not very familiar with md, and can't enumerate all the cases. For your=
 writing:
failed disk - dev_roles[X]
read errors - may change: dev_roles[X], recovery_offset
array checks - normally won't change, except disk fail is detected
commands by user - depend on special cmd
If an array operates fine for months - without user intervention - won't ch=
ange

at last, please read the code.

Thanks.

