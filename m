Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E1BC2D0A3
	for <linux-raid@archiver.kernel.org>; Thu, 12 Nov 2020 11:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB238221FE
	for <linux-raid@archiver.kernel.org>; Thu, 12 Nov 2020 11:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ng5TboSv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgKLL2L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Nov 2020 06:28:11 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:43300 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727147AbgKLL2D (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 12 Nov 2020 06:28:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605180479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xFyUiezV1cdW4/QTofUxjO180K8KiGOd6d3KDMph82k=;
        b=Ng5TboSvWALbvTNrCJcFVxgIbrvOHCergJOpiA2BKPf9I0OQgDgasktUmLygF8fQ9AGHsq
        YvcSFR+09q16mgWU2lkAtCfDFGG+qmalG6lfhg7PoJwuBwtT+sQwoYUrepoTvmjdzH0UDF
        m6g9P+i2uSWXioSsp3AY9LxBknga2oo=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2058.outbound.protection.outlook.com [104.47.12.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-N2Dl2i7rPO23ytFPRaPJDw-1; Thu, 12 Nov 2020 12:27:57 +0100
X-MC-Unique: N2Dl2i7rPO23ytFPRaPJDw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pcx3aNuQZo13HMHm+YRsoAFj4OPvW+fe0ptTHB0M/fCvKFeTJI87gB05+W9w1EBxgKqahigtjwt1vXt6VIqsaPL38529J7BUD7e7jLo+hcWnOqh3Tx6TX4QGMTkA2Jq3fVd/bxChSoMKieD6KaEB30Y18k5DUhdq3d00hI2Yy1F05t33zcBrojMhRVzZ9JZBTQA8VTqZv4tIRcRxlD4EY8+PZB2XbvMrxmduHJNGXgIvxJ68iWBeDAV2KtEg1jv5ltiDI9NYT+0v9ubUr8UyyzywjcHVrwNcYxg3al8wzhLrkr7h6EYMKRLrJFjXD3Egs5GpFtZGv8jA7X5DgXIrSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dfgu8xSBnPTufu2XeyBZqtrIzNHfESMJ4vVIGErGmM=;
 b=Q1TjaoHOnqcU6vH3rbCFRYlNNCjkG3Ym3u9O2FKVyBrDt9r9fDE4vr6OzFHMgDy5jHq3KwkH6AEtV88RJg9L8Onyt9jH0mbDfcUKmH0jGxLkG2rBuarMqgPeLYwMyc6hWlEf5MIclALumVPtMorO9EqtXlFNlEgOz+lk9qz55t3KdgIWV1xI7a8nwplDNJS2bS1l1asRzUeRD4Gh5y1oDc47fIz0Qoq+iF8TVLeOXERT02HAwSisRMaYpNQMAXvMlBnwrhTxYOGRtjJsv5aQ0RXj4my8H08Vje4STqgvecTjgT1ybwEZrNckJciW6n7baTbgUsxjlvm5cP7Vwf5otA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6908.eurprd04.prod.outlook.com (2603:10a6:10:116::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Thu, 12 Nov 2020 11:27:56 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 11:27:56 +0000
Subject: Re: [PATCH v2] md/cluster: fix deadlock when doing reshape job
To:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, guoqing.jiang@cloud.ionos.com
CC:     lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de
References: <1605109898-14258-1-git-send-email-heming.zhao@suse.com>
 <a5b45adc-2db2-3429-49f9-ac3fa82f4c87@redhat.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <d606f944-f66f-98f7-498d-f3939a395934@suse.com>
Date:   Thu, 12 Nov 2020 19:27:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <a5b45adc-2db2-3429-49f9-ac3fa82f4c87@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.134.204]
X-ClientProxiedBy: HK2PR04CA0089.apcprd04.prod.outlook.com
 (2603:1096:202:15::33) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.204) by HK2PR04CA0089.apcprd04.prod.outlook.com (2603:1096:202:15::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 11:27:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbae1b0e-cd52-4311-f6bd-08d886fe00c1
X-MS-TrafficTypeDiagnostic: DB8PR04MB6908:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB69089544CE1EBB980FC872CC97E70@DB8PR04MB6908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v4WMkYUiudxv+GJ7y3ANmws84j8KkqcoOiLvQ4XZVRNmakfvOSeVHu2zYfKuzpIDJF4h0zuedOtGhELE11Z/RIgc1NJnSZHgWfoJFKIVH3SqbEEKcR4VedbmRMebazrX7I10+vvqtIZqq/8sDBC/wbg+P3EL7pNWM0Wa3YDHVGwFohr6YK9Cmb7hQshzU7vxgIzeI1/Tjd1tOm2aEUsCXB3mCr1uJ0yLvU7LHwdg7HPM+3Tg32NFmX9CFA1vqV6ngTZHAqy9CjI9MvgisI65nn2uhb9ZsAUsWQrjZUpV4ypYltQf1DTY6bZNX0jvWHgcv4bB2Jby7dCOaXOx7yCzr7+kZFE1i2Cvq5vhnKRHSdaQ2/sDMrc1j3L+6mrznv3qb7bNcP3szU8EvqO13kkp6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(366004)(346002)(39860400002)(6486002)(5660300002)(316002)(66946007)(66476007)(66556008)(31696002)(6666004)(86362001)(83380400001)(8886007)(26005)(4326008)(186003)(16526019)(36756003)(8936002)(31686004)(478600001)(6512007)(52116002)(956004)(8676002)(6506007)(53546011)(2616005)(2906002)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TlFDfZm6IdjSIiAhBHsUTU+DNR37cOn1e5mn9T9Kf1jOiGB12987LKIok83lD/Cm7k6iLHk4cCgbUclXK4FEDmlmtA2wtzU7mp/RsCbUodfttPlY3+cS9pMQ5MZIOEPM9Oadda6OjsguwOaOSWkesKUCceZMwGsKQ9UYw96fiwO6vUqERZf4YZBb3JU6WmZ2+BKjz81DgekBRlE2/dgRI+u91+DM1s9maAg/TO1loa240GdxyoZYMY+kRZcOdpbp5JGUlY251LDtfAuy7GoAh56T8YdmisCODagbJcPc0q6JXRsS4QxjKP2H7JZo1ilHvOOt9YWIu/hbotMzZDQ9jNuvhhKvLq75chtugwRIjYiDsUedoX1nkdp+t9iUfxhFvgPt1AlVeBe2w2jH/u/ymC8uyDg2eWeD4qhJp5Y80X1nGpOiMgJDw3JYd7yoiucCqs0wXP17wgXFo0oFiJcizptNwP7bkS12L2uTFHBpJlSsdkKX2buaNi76Vci9dr85DnvmZax38le0HSgv+kYESEA/IH6qHMpqQvDtdZwRu8jrPZKZb+UjsYFUdy0NI38d3LBKVWe+ANY/57XWU6jRJO+4iM/KzR3qtN8RcA9CEEV8iqPpFSEWrVyicQeOnBNS5YlPQ4RMnDEg2HoGBaCrqQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbae1b0e-cd52-4311-f6bd-08d886fe00c1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 11:27:56.7320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WZfjH2DnSGJ3DhswQEwlVKh1SUdqwYOGwFqQog81Z0W2in9wbAGrdydeW2+It52ETHSn9CrsLR97XRyrWLfYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6908
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

On 11/12/20 1:08 PM, Xiao Ni wrote:
>=20
>=20
> On 11/11/2020 11:51 PM, Zhao Heming wrote:
>> There is a similar deadlock in commit 0ba959774e93
>> ("md-cluster: use sync way to handle METADATA_UPDATED msg")
>> My patch fixed issue is very like commit 0ba959774e93, except <c>.
>> 0ba959774e93 step <c> is "update sb", my fix is "mdadm --remove"
>>
>> ... ...
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 msecs_to_jiffies(5000));
>> +=C2=A0=C2=A0=C2=A0 if (rv)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return lock_token(cinfo, mdd=
ev_locked);
>> +=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>> =C2=A0 }
> Hi Heming
>=20
> Can we handle this problem like metadata_update_start? lock_comm and meta=
data_update_start are two users that
> want to get token lock. lock_comm can do the same thing as metadata_updat=
e_start does. If so, process_recvd_msg
> can call md_reload_sb without waiting. All threads can work well when the=
 initiated node release token lock. Resync
> can send message and clear MD_CLUSTER_SEND_LOCK, then lock_comm can go on=
 working. In this way, all threads
> work successfully without failure.
>=20

Currently MD_CLUSTER_SEND_LOCKED_ALREADY only for adding a new disk.
(please refer Documentation/driver-api/md/md-cluster.rst section: 5. Adding=
 a new Device")
During ADD_NEW_DISK process, md-cluster will block all other msg sending un=
til metadata_update_finish calls
unlock_comm.

With your idea, md-cluster will allow to concurrently send msg. I'm not ver=
y familiar with all raid1 scenarios.
But at least, you break the rule of handling ADD_NEW_DISK. it will allow se=
nd other msg during ADD_NEW_DISK.

>> =C2=A0 static void unlock_comm(struct md_cluster_info *cinfo)
>> @@ -784,9 +789,11 @@ static int sendmsg(struct md_cluster_info *cinfo, s=
truct cluster_msg *cmsg,
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>> -=C2=A0=C2=A0=C2=A0 lock_comm(cinfo, mddev_locked);
>> ... ...
>> +=C2=A0=C2=A0=C2=A0 if (mddev_is_clustered(mddev)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (md_cluster_ops->remove_d=
isk(mddev, rdev))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto=
 busy;
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_kick_rdev_from_array(rdev);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_fla=
gs);
> These codes are not related with this deadlock problem. It's better to fi=
le a new patch
> to fix checking the return value problem.
>=20

In my opinion: we should include these code in this patch.=20
For totally fix the deadlock, md layer should return error to userspace.

But with your comments, I found other potential issues of md-cluster.=20
There still have some cluster_ops APIs, which caller doesn't care error ret=
urn:
.resync_finish - may cause other nodes never clean MD_RESYNCING_REMOTE.
.resync_info_update - this error could be safely ignore
.metadata_update_finish - may cause other nodes kernel md info is inconsist=
ent with disk metadata.

maybe I or other guys fix them in the future.

> Best Regards
> Xiao
>=20

