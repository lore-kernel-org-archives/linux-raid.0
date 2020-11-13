Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486CFC388F7
	for <linux-raid@archiver.kernel.org>; Fri, 13 Nov 2020 13:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB5842223C
	for <linux-raid@archiver.kernel.org>; Fri, 13 Nov 2020 13:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eMbzpL26"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgKMNYB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Nov 2020 08:24:01 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:30012 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726237AbgKMNYA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 13 Nov 2020 08:24:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605273835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YCADaaP44VWMN9uI9Q+BCDMQp6pojSCelPPkEhVIwB4=;
        b=eMbzpL26X9OdIaPEMc6uVGAgjuVRkeaozI8VAZrn9vPqfTk/nU1M0VUrvCyJ7BOQdMbufP
        t8h3x2VZv+sXI4aUueXcSpkwZ7XadsT4dd9FL1F+nqgwagq/Qj8TpnQVy9IpuKKmvnoS5Y
        KuzAsI+vzEihTDOt58BHfv/XAf1XfmU=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-26-Z9mbNBLmNieyR0uboDdoWA-1; Fri, 13 Nov 2020 14:23:54 +0100
X-MC-Unique: Z9mbNBLmNieyR0uboDdoWA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WP5LGgmzWnIWzFOM+xtTFFDxJsGWGPTMhsnnSvwkFJhnGEj22kkIQuOHahSLxbCLhblsS7fifzFjfSzUk6Fk3fwvOzrRONVOItLBrjZ+4Kou2rCAw1+6JeeSAKR3WU7yiABgixtqiT3k8v6uB2Vfcx9zyQN0wm6771+wvy99jpPwmSdt9Re8ZvCc2saGHGg6e8S9kg56B7JIZgbf4MrZDGtEdIRCK5VKQBVbedou+LHbgtIQTBAj9Bhx6GWrzh6l7qMUFqvngnyr8ktTehBC+dgtc7qsNolMnNOvjyZAUbL0TLn995NNbDQzhOhQv+Cf7Lm0kqj9BZncZuChE62zcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTSFayofhYd8cskruynrVmpFEio3CBkVri5570G1qfI=;
 b=AzXOsoQS2LO05spmPAURlZy+6cp+4I4BmhzMu0TErig2gOCFNFY1Z8lCtUhDN/YA4G+cJH+kmxHFr5uK/3X+JfOxooxLM4OLyzy6k99n2l3/JukO1VYguoOOYr7GAsJ6XsxxDT8wcCq/r2wR9Q7HjGZFh6m5Jm2VFMA1yutAtM8hOXs8Nirwu2hYl4WuaZ8fgvHu6eisZ3QoUwZCuIZoFQ97qkkooArXZv3UtWlR9+NkySxZIq4N9hOtlgjVgV/fPw+wKv9l2EomR9LMTUFlI2xydU9b3GxDc14TScAbkj5XysyftLkg+4iSJ9ZE662MSen1zzZsCv/AUDgC8lFaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB4671.eurprd04.prod.outlook.com (2603:10a6:803:71::11)
 by VI1PR0402MB3886.eurprd04.prod.outlook.com (2603:10a6:803:22::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 13 Nov
 2020 13:23:51 +0000
Received: from VI1PR04MB4671.eurprd04.prod.outlook.com
 ([fe80::9d47:ec0a:56e1:f3e9]) by VI1PR04MB4671.eurprd04.prod.outlook.com
 ([fe80::9d47:ec0a:56e1:f3e9%6]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 13:23:50 +0000
Subject: Re: [PATCH v2] md/cluster: fix deadlock when doing reshape job
To:     Xiao Ni <xni@redhat.com>
CC:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing jiang <guoqing.jiang@cloud.ionos.com>,
        lidong zhong <lidong.zhong@suse.com>, neilb@suse.de,
        colyli@suse.de
References: <1605109898-14258-1-git-send-email-heming.zhao@suse.com>
 <a5b45adc-2db2-3429-49f9-ac3fa82f4c87@redhat.com>
 <d606f944-f66f-98f7-498d-f3939a395934@suse.com>
 <738037216.25735601.1605235813114.JavaMail.zimbra@redhat.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <ebdaca10-3ac6-13b8-c9be-c424d390796e@suse.com>
Date:   Fri, 13 Nov 2020 21:23:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <738037216.25735601.1605235813114.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.134.204]
X-ClientProxiedBy: HKAPR04CA0009.apcprd04.prod.outlook.com
 (2603:1096:203:d0::19) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.204) by HKAPR04CA0009.apcprd04.prod.outlook.com (2603:1096:203:d0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 13 Nov 2020 13:23:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e1547b1-c3c4-4139-1173-08d887d75c1c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3886:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3886FCBD12C1F71A256225D197E60@VI1PR0402MB3886.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9xU2GcqpX4atTB0WHV6/TFKtfNkhxRE6JTwTiofQYG4f7aXsOj2NZUUBou42rGCrUkunWwCX2bI9VDOysgCwCmArsFJ0aWRjhfwwHpMMclt0Efg6ababu/KBbdslLW+AMX0c/Ae+a1iwPmiS5KVZ92Y2KshmcG1+ALwfuDWZlt450TA6I5TOz5eLJpoDM41FToq6MW4JmI9RTfzvzG0uDVo3QJZTsPn1Iz5DO2A1E5HzQUKmVBL/CfBS+OsLNWZPkyJVfStMvtdWezKnt6lWkwKPDisT1EXADfewOUwzMIuzzlgkQUKzwN/4zLNeAzq093QQKG1GCiqgIlj8KWp4UcsTlPTSOVICpYihTibSHe1Njs5cAXVtRo7wHKHi2cKZnlY299Y6OYs9bouNJLy5dL09H29RKQyt7izWxwNBkrhNDKi0QIuraksMChAb/wu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(366004)(376002)(346002)(31696002)(66476007)(6666004)(66946007)(53546011)(2616005)(8676002)(4326008)(52116002)(36756003)(2906002)(6486002)(54906003)(26005)(31686004)(8936002)(8886007)(316002)(956004)(86362001)(6506007)(6916009)(83380400001)(16526019)(186003)(478600001)(5660300002)(6512007)(66556008)(9126006)(43740500002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ju9PzFUsmCAFRlMEiqAM5oVMDsfw5x6x7YjUTQRbxukE0KqR/WSa13XOXbsGJLZDrMmJPvQcOslyZHeAaOimR+t73c3Rk96idKRxxz3wO2Ag1Ke9+j3tcwuIs2th2wWhhLueNdvF81xsDSallXeJ5thhVp8ZCpiYHFabMsK1xIAhR2ETIvgDrOKVAmKsYFfhfOaInwg8soFAmmosNUTU7y2zhx0ZPF0f4qJ3ON+A8KBWt5/jHVkelZIDzxOmFl20Z3eLzYMV09sxYPXCecJYMWXt1hLjhjBnEbNGxcUQ124Zqdrvk/j2N94z9pAa1hNS721BgHuMVAMyQvlk8yRn9B1fge2JIjXN6BV9V9RkmHVtdnFUoFc5JlkwMryro2DCnlOyXL/HwDQ7K67dQW/g3FMfPqMi/Ne/xyeL1KVG8Yk1BnX/ReLSFmMi2oIkL1dQgFDRpR6bPQE/+WVNdX36Z88LZJPV2yfIFBa2BKpo5HiYjLrZfX/CxL2/23QWbXzojJ9d+UCViR7EjdPnllMs979WvX8NEYxdqbnts9SSh4n6U3K50ZTjLzXHydk+T2Ba2xp5PjkZkkXVeQUzar47qRHIC52IdvQRA9sEE0RXpKbH3Twr0mqTa+vaEZQ7/Kd92Rde8wRfdQgLCmkZtfMweANi2HkpUNX/GEhTQvuypLDWFaxhGTWSBK1Q88p0BhF4jnkkpKDzlukTS56TW7s2e67PbHWktXi4ofQwc53/AyFSexMsEHWmdfNPshTt24cMs51AR5EoLsVB/9+APn9cpdt9J4KGwTvEJ27KHi6LUCjhraTJKBIThJlEi5+4LIUMEEJRts/F9SrOtuRwM43/lPDs1CTaLA0y6mxY9emd7rH9PvC8JHY5/Bw3kRB8/kPE29tNeKvZpeBFEhwJs23BBQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e1547b1-c3c4-4139-1173-08d887d75c1c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 13:23:50.8412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o16gOu6KwR4NGIFWT3OpdPmScDLAbN4MLTSgZlVHkVyaW4ZAINED8hi2ENi4fS/JhRlv3y2m/wRUEZ1xOPcP2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3886
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/13/20 10:50 AM, Xiao Ni wrote:
>=20
>=20
> ----- Original Message -----
>> From: "heming zhao" <heming.zhao@suse.com>
>> To: "Xiao Ni" <xni@redhat.com>, linux-raid@vger.kernel.org, song@kernel.=
org, "guoqing jiang"
>> <guoqing.jiang@cloud.ionos.com>
>> Cc: "lidong zhong" <lidong.zhong@suse.com>, neilb@suse.de, colyli@suse.d=
e
>> Sent: Thursday, November 12, 2020 7:27:46 PM
>> Subject: Re: [PATCH v2] md/cluster: fix deadlock when doing reshape job
>>
>> Hello,
>>
>> On 11/12/20 1:08 PM, Xiao Ni wrote:
>>>
>>>
>>> On 11/11/2020 11:51 PM, Zhao Heming wrote:
>>>> There is a similar deadlock in commit 0ba959774e93
>>>> ("md-cluster: use sync way to handle METADATA_UPDATED msg")
>>>> My patch fixed issue is very like commit 0ba959774e93, except <c>.
>>>> 0ba959774e93 step <c> is "update sb", my fix is "mdadm --remove"
>>>>
>>>> ... ...
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state),
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 msecs_to_jiffies(5000));
>>>> +=C2=A0=C2=A0=C2=A0 if (rv)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return lock_token(cinfo, m=
ddev_locked);
>>>> +=C2=A0=C2=A0=C2=A0 else
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>>>>  =C2=A0 }
>>> Hi Heming
>>>
>>> Can we handle this problem like metadata_update_start? lock_comm and
>>> metadata_update_start are two users that
>>> want to get token lock. lock_comm can do the same thing as
>>> metadata_update_start does. If so, process_recvd_msg
>>> can call md_reload_sb without waiting. All threads can work well when t=
he
>>> initiated node release token lock. Resync
>>> can send message and clear MD_CLUSTER_SEND_LOCK, then lock_comm can go =
on
>>> working. In this way, all threads
>>> work successfully without failure.
>>>
>>
>> Currently MD_CLUSTER_SEND_LOCKED_ALREADY only for adding a new disk.
>> (please refer Documentation/driver-api/md/md-cluster.rst section: 5. Add=
ing a
>> new Device")
>> During ADD_NEW_DISK process, md-cluster will block all other msg sending
>> until metadata_update_finish calls
>> unlock_comm.
>>
>> With your idea, md-cluster will allow to concurrently send msg. I'm not =
very
>> familiar with all raid1 scenarios.
>> But at least, you break the rule of handling ADD_NEW_DISK. it will allow=
 send
>> other msg during ADD_NEW_DISK.
>=20
> Hi Heming
>=20
> It doesn't need to change MD_CLUSTER_SEND_LOCKED_ALREADY. Is it ok to do =
something like this:
>=20
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 4aaf482..f6f576b 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -664,29 +664,12 @@ static void recv_daemon(struct md_thread *thread)
>    * Takes the lock on the TOKEN lock resource so no other
>    * node can communicate while the operation is underway.
>    */
> -static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
> +static int lock_token(struct md_cluster_info *cinfo)
>   {
> -	int error, set_bit =3D 0;
> +	int error;
>   	struct mddev *mddev =3D cinfo->mddev;
>  =20
> -	/*
> -	 * If resync thread run after raid1d thread, then process_metadata_upda=
te
> -	 * could not continue if raid1d held reconfig_mutex (and raid1d is bloc=
ked
> -	 * since another node already got EX on Token and waitting the EX of Ac=
k),
> -	 * so let resync wake up thread in case flag is set.
> -	 */
> -	if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
> -				      &cinfo->state)) {
> -		error =3D test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
> -					      &cinfo->state);
> -		WARN_ON_ONCE(error);
> -		md_wakeup_thread(mddev->thread);
> -		set_bit =3D 1;
> -	}
>   	error =3D dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
> -	if (set_bit)
> -		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
> -
>   	if (error)
>   		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
>   				__func__, __LINE__, error);
> @@ -701,10 +684,30 @@ static int lock_token(struct md_cluster_info *cinfo=
, bool mddev_locked)
>    */
>   static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
>   {
> +	int ret, set_bit =3D 0;
> +
> +	/*
> +	 * If resync thread run after raid1d thread, then process_metadata_upda=
te
> +	 * could not continue if raid1d held reconfig_mutex (and raid1d is bloc=
ked
> +	 * since another node already got EX on Token and waitting the EX of Ac=
k),
> +	 * so let resync wake up thread in case flag is set.
> +	 */
> +	if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
> +				      &cinfo->state)) {
> +		error =3D test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
> +					      &cinfo->state);
> +		WARN_ON_ONCE(error);
> +		md_wakeup_thread(mddev->thread);
> +		set_bit =3D 1;
> +	}
> +
>   	wait_event(cinfo->wait,
>   		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
>  =20
> -	return lock_token(cinfo, mddev_locked);
> +	ret =3D lock_token(cinfo, mddev_locked);
> +	if (ret && set_bit)
> +		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
> +	return ret;
>   }
>  =20
>   static void unlock_comm(struct md_cluster_info *cinfo)
>=20


thank you for your comments & idea.
I totally understand your solution, it's better than mine.
I will use this idea to file v3 patch.

