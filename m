Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79763C388F7
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 06:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047D620674
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 06:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gfNLo37o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgKJG7t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 Nov 2020 01:59:49 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:45990 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726213AbgKJG7s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 10 Nov 2020 01:59:48 -0500
X-Greylist: delayed 16495 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2020 01:59:46 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604991585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QLj0NJhpg5OfTGQOW7gp87CR0ABIqmyyJtxrxmPCNe4=;
        b=gfNLo37octCa8Nv/uEvGzle7UQMwASov0vT3WHPzkvMFq5S/lAXg3SUDeE2VTV/rr8p9p1
        SxrzKrEJ0YHawAv2LiHnNmHc7uwBxxoVxiEj5dSNXrESp2esAiQb6aOh5nsRlw24fICyh7
        IY7bRgwthHKZfNop1UyN7Z8vy8n1gYE=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-21-b1NUlUasO0Km7tYLWs-3jw-1; Tue, 10 Nov 2020 07:59:44 +0100
X-MC-Unique: b1NUlUasO0Km7tYLWs-3jw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDi8R97cp5SD/Ski3OuytoLt9qhcPYJ8HMFYKoJgzVQ1jCpJqDOjAx2QbdZUrs54mJNrik8/qkSySlwHxcvoKiMdqAfrK0kzLxDdzZHdB9l0BSoVdg01Hpnl8xaHmmKWCnqcvIhUWnKYcZ6JhygBqe1y4wynsw7f5UQ3JKZB1jRlg4ws4fv/URGsdWh4CGe3j2SHeVjyxYYLfOKCaWpVeM6SMwuV11bkEZxvVn0dzNnUtXBtoHj82XW2bBUKW1pV3CTj/k2Acn+ZEWmgJ3F36fVRH0J0x+RVnTYlpuiiAPVoy7oEB8KF6KTy567Mo70nnozIOMHpfwGxjH8yXvTP+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKi/WOqzRczJFnschc4Z8pRyZdTIhGeZeZxfGQHM6Rk=;
 b=A2fPyrq/VdijMT7Xdum6SrCZwaiunA5YMJLmRD3yZ+CKzMR5NK5Icrst1S3se58ehpq6uaP5qIshjzFW1AwAJyKG98GQUZORhKl9I3+Tv6Hq3zQPPu8EoPn2JhxgN1ulYgfk4O/ousVK+zLJEGjg8loQ97Da3iyzEclv/vtltC42qSMCETfdggeSST7a98pzoY/7PHEiUzeNwN+YiuMP5gjhsyGHpxBlzOyD6FeKuI32tt4qCKlseg4n7oiWhypODhc0N060galPThxrZ+x1EPl9X3enoKQfUuajA+Qd7U9uezhXzJXuaAR14KSOhKX6EKEI890tBECEH3iajmR0IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4443.eurprd04.prod.outlook.com (2603:10a6:5:32::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.29; Tue, 10 Nov 2020 06:59:43 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 06:59:43 +0000
Subject: Re: [PATCH 1/2] md/cluster: reshape should returns error when remote
 doing resyncing job
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-raid@vger.kernel.org, song@kernel.org
CC:     lidong.zhong@suse.com, xni@redhat.com, neilb@suse.de,
        colyli@suse.de
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
 <1604847181-22086-2-git-send-email-heming.zhao@suse.com>
 <4a845cf6-3d18-1cc2-d8ca-620bc7bc8714@cloud.ionos.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <cff180e1-f9cf-db15-1794-52d931c1dd1a@suse.com>
Date:   Tue, 10 Nov 2020 14:59:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <4a845cf6-3d18-1cc2-d8ca-620bc7bc8714@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.132.155]
X-ClientProxiedBy: HK0PR03CA0106.apcprd03.prod.outlook.com
 (2603:1096:203:b0::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.155) by HK0PR03CA0106.apcprd03.prod.outlook.com (2603:1096:203:b0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 06:59:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3548d453-d478-4fc3-2469-08d88546334b
X-MS-TrafficTypeDiagnostic: DB7PR04MB4443:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4443F26EC9D77B46DCCDC70197E90@DB7PR04MB4443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A87YTCsYIyBc+Un7J/87OP445+izp0Pyj7g0KgMdU9rPeGwRAiBZETiGGPEg7f1KYHRJRFFl+PHq8MpgOCPfS76Qi95lXU/EQDq6J8uS81nNK9UW6KW6j2aFTk8xp0Qt4VLbO0KfFF5owa9IMuUQaqUI16PG3qbuNO3fqc5BSAxoXkK2sRlMdT7gpzSDo4mRIecUiZSlJ1Je3dU/PCh/8bxuzftVa5E4y/2pQkGzdqelV9nGTPd6Lf/rDcU/sERqJDTJ/mBiRcmrcsD4GobJRs8A1YwS8NJSkR0xKkHqLjNxiBBGPjfR1GGBxAXdZYEhmpI90Hsuq0rk72FzcY2xZ6Erex0asfL6QrM39z1cv/cInobROx8BBcEbfAbonODoLCZk3j+KcHRdAqA+E0ZKPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(39860400002)(396003)(478600001)(4326008)(316002)(8676002)(31696002)(83380400001)(31686004)(86362001)(186003)(36756003)(66476007)(52116002)(6512007)(6666004)(2906002)(66556008)(6506007)(956004)(8936002)(53546011)(6486002)(2616005)(5660300002)(8886007)(66946007)(16526019)(26005)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gZ82BxUxCEdE2Qb/I+GW+U+J+nwTBEPvCywkwO5HPlIDxVm3kjQ17KLKjqzhxWDm5mFNejdstXC592DgwlamcyhXW1lRwOX8SY3dZbYTlfAoAfCoIXRuxf4/JexwpNJ7Nig0XAXVPBpmqEht597P9OygsTs4adoLGTA9Rk6RVpr1Gxrzhv8erH7Aq375HJ4x2S2/zhMxi5hH8Ml8SH04jxOnOELCAsOImHxeIh2JjYTNbpQ/whXdwhoXZAMpOdVLLpTP1K+PwA9aSqKAT5M5uWnTmOVtxoPu/OyfGg7UTuNHBjXbTQcqkTOC8tYOCiE5poQxFe0D8nh0uzoeQAelfeh/i9gvXCL/xaRYjKTVevp9cUwFzdB9PL5iVrjSNpensG9PDAKVI2Cn7zX2g8O79/P6mBwZhbUfLGXRn6D+P3KmqOqqklnkaNkBZ0inGuCu8BVlTNP2f88bpCiYaDtkdUHJkZyCAqIfLD5o67bNPdZhVxjCokHqELD4OpqEew6igPtatuvaPWxeHFqYITS4+D2IlhQk9wmJVTjlfrjB88cTxk95li+yBwrE2LFa/tSMLHykN/k4Uuz1j9MsdVyFET88+SOjXKBzOVtivWpDymefGbiXXsn3gzKPfIttoaUjl5lq2xLTZrQEHns8H/B/Pg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3548d453-d478-4fc3-2469-08d88546334b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 06:59:43.0630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boTAM2c3Juab2GIEUDHKIrsL8vv7aMUalggAPOuwboAY67eQy8pbPUqoyTKHUDQeSb8hl5KmpMf6zfPh6Gyhig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4443
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/10/20 2:38 PM, Guoqing Jiang wrote:
>=20
>=20
> On 11/8/20 15:53, Zhao Heming wrote:
>> Test script (reproducible steps):
>> ```
>> ssh root@node2 "mdadm -S --scan"
>> mdadm -S --scan
>> mdadm --zero-superblock /dev/sd{g,h,i}
>> for i in {g,h,i};do dd if=3D/dev/zero of=3D/dev/sd$i oflag=3Ddirect bs=
=3D1M \
>> count=3D20; done
>>
>> echo "mdadm create array"
>> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh
>> echo "set up array on node2"
>> ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"
>>
>> sleep 5
>>
>> mdadm --manage --add /dev/md0 /dev/sdi
>> mdadm --wait /dev/md0
>> mdadm --grow --raid-devices=3D3 /dev/md0
>>
>> mdadm /dev/md0 --fail /dev/sdg
>> mdadm /dev/md0 --remove /dev/sdg
>> =C2=A0 #mdadm --wait /dev/md0
>> mdadm --grow --raid-devices=3D2 /dev/md0
>> ```
>>
>=20
> What is the result after the above steps? Deadlock or something else.

The result was writen in cover-letter, in the "*** error behavior ***".
I will add the result as comments in V2 patch.

>=20
>> node A & B share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB, and
>> the disk size is more large the issue is more likely to trigger. (more
>> resync time, more easily trigger issues)
>>
>> There is a workaround:
>> when adding the --wait before second --grow, the issue 1 will disappear.
>>
>> ... ...
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_w=
arn("md: updating array disks failed. %d\n", ret);
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Since mddev->delta_disks has alre=
ady updated in update_raid_disks,
>>
>=20
> Generally, I think it is good.
>=20
> Thanks,
> Guoqing
>=20

