Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06345C433B4
	for <linux-raid@archiver.kernel.org>; Sat, 10 Apr 2021 15:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9B04611AE
	for <linux-raid@archiver.kernel.org>; Sat, 10 Apr 2021 15:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhDJP2g (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Apr 2021 11:28:36 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:34470 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234754AbhDJP2g (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 10 Apr 2021 11:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618068500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p86Qmz4SE+WuN5eOYmQNKYuP7GvwerAusm+hB98Y4KA=;
        b=B7b7vLpmf9MkMJE+tWUZKHaOzPrAwGHh4Q7spbEhfbhW71Wy5l+r6MZWhyYXraULtx1HHY
        vBewT7djHkIalXi7VHXD+77ujOySpaW+6K0purbPdPF6XPt44xdpeCqOX+Gn6RVXa5YGmW
        h76o2hTxFxC4CbjRUiW94aGM4ntAXXs=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-28-L4EGO3qvMDOGrrfxKn7TAw-1; Sat, 10 Apr 2021 17:28:09 +0200
X-MC-Unique: L4EGO3qvMDOGrrfxKn7TAw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zrs/sStPTcAFNC+qnfZBpxolRgZwT79IAYVdwc38sJN03NXGkDj1kIWzwRXHJHC/lumh0s++X2QX/7Bha/nQvLQObxBeV+6qYB9QsOk7t45JF4N1S4T1/1LHoB8TRoCYPPH50wpneC+qlauloDj/uz1PztP3UgLf9UeSNZcVBKSHi5uc3e5Ndw3zhXw/YC2Tljr3BrMRDtQr/16zVaBiDkwTLlABY/+1858w1jSdNCMNSk/aHQIlTXtL1qG9nMKnfBU345XIlolfuVeV1Q3wQgfU0eZ0s1SRS84hHX3blUebcQ0EABUhMQD/eGJXNflJv/KQzEcX2imbw5b3eZ2Mow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p86Qmz4SE+WuN5eOYmQNKYuP7GvwerAusm+hB98Y4KA=;
 b=bVR4GunJkXCD2P/czYVk1J9Ow7ycCcqxW5KVr7Bp8dVDoCrYLdOOfDVKuVPenhiPwtuvKCk5CqtJzFXzqVJJP7BBa9rMDpUpc/ytaWH8VWFFwRSMY1SVphGSdsaIsguvjrzYX73nPZISjHY0D4Tk6jwzFwIO+m3uCQ9VdrkjCCUFoDWIDncZLjLGPbJQHtG420tlFPzkz8rwCGgi7trN4RHYpzJjsRr+MtTZPnM4wfqYaaHPX4lvsyOSUlrpHbaXmrYtenPCqtaqG02+1Psu5ixTTOXeGWBRo85TAqvN6QzLVZT/WBJehvZAz4JqDaBwR0KhYtGzwP5zrI4NDHMYCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6697.eurprd04.prod.outlook.com (2603:10a6:10:10b::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.32; Sat, 10 Apr 2021 15:28:07 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.037; Sat, 10 Apr 2021
 15:28:07 +0000
Subject: Re: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        linux-raid@vger.kernel.org, song@kernel.org
Cc:     lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com,
        martin.petersen@oracle.com
References: <20210408213917.GA3986@oracle.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <ba0f4827-83ae-b7e2-2230-5f4afca2538a@suse.com>
Date:   Sat, 10 Apr 2021 23:27:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210408213917.GA3986@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.133.231]
X-ClientProxiedBy: HK2PR06CA0003.apcprd06.prod.outlook.com
 (2603:1096:202:2e::15) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.231) by HK2PR06CA0003.apcprd06.prod.outlook.com (2603:1096:202:2e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Sat, 10 Apr 2021 15:28:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f77d4704-62a5-4d47-a845-08d8fc353d79
X-MS-TrafficTypeDiagnostic: DB8PR04MB6697:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6697B368B38830397DA3E4F497729@DB8PR04MB6697.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fpIBw+q4/Z3kKhjTmOBgcmnU0q4UkvKCXLXs5KRKg0UBVbKoabVTc5BXq5M6wmmD6VLdUNmCW25ehzaYVCYmz059tRQRliiVw20QQ7mgzvNJZUDbv0TPJIEe30thX/xqX/f+3Cwxx9ehLfQ5ujwIT4pBO+hDFk3VMsEuWuOxWcNoXPr7HZVesGt8aZqKb0oPzRYXveYMgiPSiwAvnpKBd7TXW58myx+YK6UnT+zVwX29Mb8PpAT252FWNCJ/wh5NWSc4abJykqmLG4wPvolfMIPy8fg41uuCpZ1fTkIE38w1tU5KJIvDkd3rpNI2EX2xB7GQcBwyX131FLkCxZsfGqF68fNdFNlDs/B+JZuxXJPvQNyELg79Mq2E3nuamoabm8BC4RBsEJ63Zz6Wh/s2MxcQ6n5V51nQ9xARpRHngDNgQbrNeX2ovxa6tQl5ATSwVSUBFkaogNm5DAhQhSTJwiVGA2p+adxxAa5PVz5IAperZ53JKs3lvVzcET8BowgL2+N4LBsLHTMEBNelp4Rm2LdUs+AxSDYPGzZfZ80jSCbH2xJFPXut62d5AgCCGjDnhyTz2eyrhc1w/QMI2awMDAkIGZM3o585TX5dJXBc4hrf+eywoX4VqR8ih0i0uWqhCmkqwxIp4OFcbrOU6NqTAVhs3tj6VVSmqT3LRkKlGsqitvAkTEyZNx6yvoAJtLDAWHj4yuxFNsbD5t47uL7BgZ5ZizKyZPYfg5KOyxFCqj0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(396003)(376002)(136003)(478600001)(5660300002)(31686004)(6666004)(4326008)(66556008)(52116002)(66476007)(8886007)(66946007)(83380400001)(316002)(8936002)(2906002)(6486002)(38100700002)(38350700002)(36756003)(6506007)(8676002)(53546011)(26005)(186003)(16526019)(31696002)(86362001)(956004)(6512007)(2616005)(9126006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VlA3bDY0Q25pR0x2Rmc0ejN6cnZ5Qng1d29HUWhteThTblZzKzB0UlBZekdJ?=
 =?utf-8?B?U3ZBRW9WZURVdEpJZldTVGh5RWZiSytpU0FtSCs3SC9LT3ZNa1ZlejNOWTFm?=
 =?utf-8?B?ZHlUMmU2clg1Rlh1dkxmMkpzN2Y3RkFraVNkQzg5elBpUE5FZmxjbmhPa20y?=
 =?utf-8?B?TTFxeWpHaVF2OVkyVDVXNkd0Z20xNTFPdVZZSUxEWUt1SU1oRGhqZlBzZ0ZL?=
 =?utf-8?B?WGw0cHg5WHhrc01yMnZYNmRycGNNQ2ZiekJOTVhZYkhsb1M4UWkxVlFUMDd5?=
 =?utf-8?B?UmhXQ0w0ek1rNHZSeVQ2bEc2bXNDT1d6KzUrVFBhK3JuYmJJQXpFRE1IYzFO?=
 =?utf-8?B?SHNmQVBiWGR0NFF0Q2YzQTJWbVdNNHM5UzQwUUg2R1hyOFdPSjdhSUVyL3lQ?=
 =?utf-8?B?N2lwcy8zd2NBd2t2Q2tlSU9hS0wybDExUnh4eTJ2UTN0Y0FjNUR5TUhYbVBN?=
 =?utf-8?B?SmRWdUN0SkNHNkVFaFJkT3hYWnplSU1lLzh0LzJHOUIwWTdUTUVraFZsVVI5?=
 =?utf-8?B?WHFUVFBOdHNkTUxQcEw2a3FMK1lzNnV6SkdQekkwb25DWGk3eGRmaHVHTXdz?=
 =?utf-8?B?bC8yb3NaZmplNUdFcjRMMVhhU3Z1UktFNTFsSFVBeXY4eGR5a1NheTFDNWtl?=
 =?utf-8?B?eW1lQ0dOY0tVRllvcEduRDhrMGpGK0c0Y3lnb1pSYng0TzlheGhUNVhXOHg1?=
 =?utf-8?B?RXJtOWxXenV0TW5mbHhBRG55cUpVanF3WDJMbjI5N1h6eXV5VDlwMzhQY0ha?=
 =?utf-8?B?OTNELzU5Z3QwSDhTWS83UC9NVEwyZEpxL3hmdGxsQ0h5RE9QaG5mUkdFM1BL?=
 =?utf-8?B?ZW9Cbnc1U0IwY2RKV2xxQ21WUnhaZ2xuVHV5dHpFdFFMMHRLN3NNRnFjWXR1?=
 =?utf-8?B?eXYwWXhDcGoxU3laSGVyU0VsVXIrWUN4UWE3WnhGVU5vcVZNTW5QaTNmRmVC?=
 =?utf-8?B?TUxvTVFkcVF0VUtxZVM2K1lTdmFGR0hKVFZuQ0w3d0U4ZURTbTFoUDAwb2dU?=
 =?utf-8?B?dTExbnV5K1M2bVB4ZlgyRWZwZFQrM1FaZnZuNmpZSVloVFQwS3RMbUlKanlq?=
 =?utf-8?B?RTF1QnNzRGJjeXVwZ1B1RkpaczJtSFE4UGFlRFFnTTlNbysvQkN2MlBLVldJ?=
 =?utf-8?B?NnlRa3M2VFRuNkJ4WXJ2RGw5NzlGSzhPc1VsV3B3eUJXTmJTRDhCUmNzM3Yv?=
 =?utf-8?B?aHEzZlJRM1pOT1dZRUFCS0cwVXFkMk80MUVUUElybGpCMmZaM0RJOGlxLzZt?=
 =?utf-8?B?dXoyWG1DTFB2K1FGVWFnaHVWY1M0Ykl4RFVxM3h3UEV0d3JxYjlxR3NZZlNT?=
 =?utf-8?B?L3NQc3hsK2VPTy9VZG1TZjRxdDFwQ0JJY3Rtb3VkR1pZZ0p5YnBJSzdDYS9E?=
 =?utf-8?B?TXZjNERrc3JPTkJYQWlPcklQMTJ1OFYvM1BGZ215MksyRS83SG5uL3F2S2hl?=
 =?utf-8?B?QjllSkV3V2RoUlJkRHJsYytsWFN0WlMvWktqWEdETHJwYnlrSDM3bHpyYWNI?=
 =?utf-8?B?WkNqaVNNaDVoUGRFWkVJMFJlc2hobkV2UXJNR1JodTIxMWZmdG5sQitrZ3la?=
 =?utf-8?B?NTdZUEwvejhnejZyaUs3R0VYeVlqOEE1eHlqZ0pNQU5rbVpBNzF2ZGc2MTZt?=
 =?utf-8?B?YlVHV2tFTEJjSTVqS3lyYU05RVdtRHVITnpUaTBQUlF2REFGS0VMNGZrajFp?=
 =?utf-8?B?UldjOUhTN0xHdDJjZ2FqZkVkbjhybXJLeWYrNStnMm4xVDlkb2tPZllxdTY2?=
 =?utf-8?Q?gODA57S5jqFvsYLqTDZ8JGXO8+Y9I5K/Xg8XKP4?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77d4704-62a5-4d47-a845-08d8fc353d79
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 15:28:06.9373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gy8fJt0D8KWHsXVE9tughfwCch2l5QCuJkMtfLY6MvFuK2wMW8tYreP4Jbig0+2ipviD9P6liT0EL/wGT7tMkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6697
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/9/21 5:39 AM, Sudhakar Panneerselvam wrote:
> NULL pointer dereference was observed in super_written() when it tries
> to access the mddev structure.
> 
> [The below stack trace is from an older kernel, but the problem described in
> this patch applies to the mainline kernel.]
> 
> ... ...
> 
> bio in the above stack is a bitmap write whose completion is invoked after the
> tear down sequence sets the mddev structure to NULL in rdev.
> 
> During tear down, there is an attempt to flush the bitmap writes, but it
> doesn't fully wait for all the bitmap writes to complete. For instance,
> md_bitmap_flush() is called to flush the bitmap writes, but the last call to
> md_bitmap_daemon_work() in md_bitmap_flush() could generate new bitmap writes
> for which there is no explicit wait to complete those writes. This results in a kernel
> panic when the completion routine, super_written() is called which tries to
> reference mddev in the rdev that has been set to
> NULL(in unbind_rdev_from_array() by tear down sequence).
> 
> The solution is to call md_bitmap_wait_writes() after the last call to
> md_bitmap_daemon_work() in md_bitmap_flush() to ensure there are no pending
> bitmap writes before proceeding with the tear down.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>   drivers/md/md-bitmap.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 200c5d0f08bf..e0fdc3a090c5 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1722,6 +1722,7 @@ void md_bitmap_flush(struct mddev *mddev)
>   	md_bitmap_daemon_work(mddev);
>   	bitmap->daemon_lastrun -= sleep;
>   	md_bitmap_daemon_work(mddev);
> +	md_bitmap_wait_writes(mddev->bitmap);
>   	md_bitmap_update_sb(bitmap);
>   }
>   
> 

Hello Sudhakar,

First, let's discuss with master branch kernel.

What command or action stands for "tear down" ?
 From your description, it very like ioctl STOP_ARRAY.
Your crash was related with super_written, which is the callback for
updating array sb, not bitmap sb. in md_update_sb() there is a sync
point md_super_wait(), which will guarantee all sb bios finished successfully.

for your patch, do you check md_bitmap_free, which already done the your patch's job.

the call flow:
```
do_md_stop //by STOP_ARRAY
  + __md_stop_writes()
  |  md_bitmap_flush
  |  md_update_sb
  |   + md_super_write
  |   |  bio->bi_end_io = super_written
  |   + md_super_wait(mddev) //wait for all bios done
  + __md_stop(mddev)
  |  md_bitmap_destroy(mddev);
  |   + md_bitmap_free //see below
  + ...

md_bitmap_free
{
    ...
     //do your patch job.
     /* Shouldn't be needed - but just in case.... */
     wait_event(bitmap->write_wait,
            atomic_read(&bitmap->pending_writes) == 0);
    ...
}
```

Would you share more analysis or test results for your patch?

Thanks,
Heming

