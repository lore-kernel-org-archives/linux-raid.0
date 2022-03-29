Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB87DC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 29 Mar 2022 07:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiC2Hfj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Mar 2022 03:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbiC2Hfh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Mar 2022 03:35:37 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13967D5F
        for <linux-raid@vger.kernel.org>; Tue, 29 Mar 2022 00:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648539233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrXm9cOnYCrk0Q8y7MtKCIv9MnWc6NBvtbH6zY02gCw=;
        b=Uodsp4z/3r3oHSHNxgv14/RwhM82oKp+nRw8vAV0Nf0FxLHpFva0iOXPGTLGj20V0ew36c
        8usr2kWmQUqytSnwkNifPB82+r/itPMAnxYpoNzNiXKkxPx/UjGZRTJeQ8/6NqC8Aa5UDB
        0gV+vTUURzyB9qcE7GgLJjC/6XxP07Y=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2058.outbound.protection.outlook.com [104.47.13.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-26-KbZt6pE5NBCTo8dw9TuIqw-1; Tue, 29 Mar 2022 09:33:51 +0200
X-MC-Unique: KbZt6pE5NBCTo8dw9TuIqw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlYBSn2fw4SVxOmtQrgLju31YoliCNREjIeLjYLdfovW/L2z2p/FkVsqdpJQvza4x3WUA2lVi/62ap9TpFui5zWGfbWYSNY9Dcezi0ht2GJva7q0vvcSiyR5LFBw3YqgXE6iS9U/kk1pvOoBqN/XlZZKg5hCNlPmgXrzLoUDkQlg+gL0jv5BDVcluMDV0W4Wz6qSDdqFjP0C8lOKiLVnl9wjm/Xnv2xT58kBri1GjW45m42GTtP25tmdA4z5mXpvWh4VlkVzsYc1MCvurCz9ts5VvuDhEj6TmjrDUzverhBiuhoy2jv0ya2OszqF5ObkybLTYXwqDUxR4pvNzautIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrXm9cOnYCrk0Q8y7MtKCIv9MnWc6NBvtbH6zY02gCw=;
 b=fCAgYE0Warvq1aEEq8A8CbAEoVJ3WHzKl6Wv3OiBrPdGGazYi7dC3J+XQ/fHieAuBOj4IksLemg3ZJC/b1HtfyDzni96hfxVssLa2yrhm4ib/Huf4AnJOdsCLEgCSy5MG4WwTt9NTs8xQKErQPcm1JCtm4ZTQMs9vpjH9bR9xFOBETYIzC/K8YWL/xc34wVMzDCA+rBJ426SOwkG4KmEJ3+8C02EuK9sxckzlbELbCpY+Cjytj1HD0prRRky76eQvtErpnHVlxbFes1I9aCgkmRyKraVz6bo03yUOR0K/DgvxXxdagBTccSDCmaKl9qsYBX5wlMujCKyHqiNFyS33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 VI1PR04MB6336.eurprd04.prod.outlook.com (2603:10a6:803:f2::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.23; Tue, 29 Mar 2022 07:33:49 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 07:33:49 +0000
Message-ID: <471a3df2-9fac-59a0-7bec-1fcd1d1c5de5@suse.com>
Date:   Tue, 29 Mar 2022 15:33:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] md/bitmap: don't set sb values if can't pass sanity
 check
Content-Language: en-US
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@linux.dev
Cc:     xni@redhat.com
References: <20220329072722.1786-1-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <20220329072722.1786-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR03CA0047.apcprd03.prod.outlook.com
 (2603:1096:202:17::17) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42293123-db15-4a95-00b8-08da1156771f
X-MS-TrafficTypeDiagnostic: VI1PR04MB6336:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6336E9400A10F19FB07E4164971E9@VI1PR04MB6336.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJO7Nzg6BfwuV08sXI3xNtXy9TaoXmxI+va4aL6a1M42kOTAwZa/QY1E1oa8fioGBkNKuXegU1zWeEH/MYve2nS0BkboCT8LTBYoyFASEC+D1h0fXeDiNWJtDiRFnQzaZF7SHpb8YV63ZOnEvklUK/JZCf7w2YZMdTomnldlc5ZW0DmN9YlXDAukIYdOKUgJquRfx/VC+udp4iDpul/VSfzi3XsGIyINjutAMLJTMD7sAsTSWM5BG9hCeFAr7py8UyQbEoqQDXXC2vN+KmyZ4q3UdJxwVqNCe1Onz/HY4VwuPIvt3n3C7A5DfCHmRuxEr/8LIzLstw2iFaVcXq15J89keX4qRZRh9o1y+8L1WS4sKNe9fZDQsMCDcPQEoFzC3e19dgutcaJC9YFmXjVdvwnrDcuvGdej1yuXQXdp2yHjBna54RJ82vt6T96nBc0FnfB4Q8PzYpw4BUrMGCzvt0Zbz4XQ0FMcM3yX0M6ghI2JmSdEx2G88rb2N0ejtzwLAdm/UceIdmFKcFA48QOyFYRy4WmzKIe/OxnmSL+Md2/ODkqAxlhJ+3W2rsHcI0usus5scKeP+RnboSYJY702GhcUVr/UGeO8Oy4dleuNw2FjyasmFVMil5yN4tbxjU61kHRN57Tk+5BXjhl59h1p3FrG3ZvU7MptuqzuAs75yTb8NcEEjjEpMMjF4kGa/kP6UC3ozqQMT16fgccomLlN7DxVxJ4oaIkAYF+1WGBEItU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(8676002)(4326008)(66476007)(2906002)(66946007)(66556008)(31686004)(4744005)(31696002)(86362001)(36756003)(6512007)(6666004)(6506007)(8936002)(5660300002)(186003)(2616005)(26005)(38100700002)(53546011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmNhWkhKZTA5STZ2N2FsajZqdHQ3cVRsUDQvaXRrR3pSUkoyaDB1RmZCM1kx?=
 =?utf-8?B?VVRlNGkrcjl4M1R5aGRuYVRYdGpGYUZwNzRTaWowTXdYS3RmUGFxaWo3R2Ft?=
 =?utf-8?B?Ymw1eS9taHI0OFh4U3dVNGZhTllBelpHMWJTa2Q1NDZpbk05ZDBQYkE2ZFoz?=
 =?utf-8?B?eWc0czh3Z0hENE1Vc0RPY1cwQm92a1Uwa2FobzFqRHN1NE5ZcmFBSGsvS0xq?=
 =?utf-8?B?NDF5TjZSaDc1azRrMlpOc1VFRStLb3pqYTVGaHNKZ3R2eXd1NFJNUmtGajM4?=
 =?utf-8?B?bkVuU0FYa0J2b3F6UDJ6bHVPam9YWitUNFlNdlBudk9nRU1TUExWclM3dnYy?=
 =?utf-8?B?TCsvbzRNQlgzSlk1QjRTRFhWNGJCaXJldXFyY0wrNGNSQTNZSkN1VGJMTmZE?=
 =?utf-8?B?cTFCcnJFSlpERlkrTlh0UzcrU0VibDdsMUlEMWNKa3E5aGNFUWpOQWtNL3Ra?=
 =?utf-8?B?TWp4YUVGQk02cUU1cmtXZTN6VWxReVlLbXd5VW9JejhXbEV0eXVUbzVOZkRS?=
 =?utf-8?B?NjY0V0puMGMrUUMrL3Uyb0g0aWNzeUJrL3pBMlhBSEpCaGxGdFpSb2crVzY4?=
 =?utf-8?B?OEExV0xYYVRqU3o5VHFobFRHZVJNQ1VtWXVpdFRqWjN1TWFHRWExYU5GVTJw?=
 =?utf-8?B?OHZXdkViQjRmcHV3cy9vVnBlNWhqTjB3U3pwRWpQalVBNS9pZFFsQ0d3ZThT?=
 =?utf-8?B?d2d6UlpWbWc1bmhuTWdnZFZYNTlIMktxczl4Z3hNQ3F6RW5JSlc2NlM2NGVy?=
 =?utf-8?B?Q1BFbUxtdzBEMEJpdjJIRG9PRWgvSktiQ3lCR2Z2RmsyWnhjNkRjQTI5cThL?=
 =?utf-8?B?UUQxdVRwa29HWXpUcDFwMGxKS3pMVndYUUZvZWVGRTBkOEZzYVliQWlYNVcx?=
 =?utf-8?B?dWdBYlYxK3JpSWFYV2tmN21ST0ZIanZybExzVHZOT1VlM21NWmJ0U01wL1lr?=
 =?utf-8?B?U21NVW1UWDFnUi9lZG5iQXdzcW5wQWQ0c2wrckFrTmVSSklUQ0ZKUXB0akpV?=
 =?utf-8?B?V0FHZUhRaHlOeDlHOVAzK2ZSb3RNT2k1Ujh5Und0emkrN2RhR2tXa1FwZW9M?=
 =?utf-8?B?dFp6Sk9rRGpJeWV3bEZ2WUhFVFVZSnJjelR0Q29hY0N2dVR3Z1hodnUwTm5O?=
 =?utf-8?B?VHJVeEtKYnl2T1pkSjNRTmh2a1pjcE56RzZNaGRHN2pCM1oyOUp3M3NwdWpE?=
 =?utf-8?B?R0VuZXRUQUFqSENCc1dwWU03SDFtKzlYczhTNU9tWUpnZnIwSE9MR1VnN3hl?=
 =?utf-8?B?VVYzOTh5bU9EelZ5eEIzOTVEa0tHNVBhcE1WTVg0Z0t0NTM1NTRicUsvcWcv?=
 =?utf-8?B?QVQ5dUFqMGxaelRob3FFUjA3UHdhUERFRFJQWXFkSEg3OWFTcndTc2JZR3pq?=
 =?utf-8?B?dGVoalRiL1E1RXJVN0J6cVRqQWw3SldCMDM2dW5UUEVBcEpHRGFYNzhDcXpD?=
 =?utf-8?B?eGZZdjJjYmIxSjBlcXhrQTNZcXVVSVAyT0NKTTlyUHlMOWYrcDNyT0VuRDJr?=
 =?utf-8?B?VWJiT1dpT1Q3a1lDb1AzK2w1bk5wT1QxLzBaMVZmcUxnd3gwNkV0L2JxTlpH?=
 =?utf-8?B?VWlXQ01kMWJlV2s3aVQ3WFlhT0hZK0F1UW9qWUhIUnppMFRJODY3NTMrcjh5?=
 =?utf-8?B?bWVPL1VIL3NwSkRlcGFYN0JsYWJzTWprQ1dNUnVibWhXZ2s5aUl0Ym5YcGd2?=
 =?utf-8?B?dEU3T2Y4bTljUWpLNGhvcWxPcVpMaDNaU0FnVEtnNjRCOG1pcW5qdTRSekt2?=
 =?utf-8?B?RUZ1Wkl2RTZkZmNqZWJoSnN5czJoR0FHOTlmbWlqN0k0K1Q3VUE0TjZBQkpl?=
 =?utf-8?B?ZVEycDRjOVd5RzdKMTVOS1A5alphTzJIeTMzNUJrZGxqajVmZkZzZUVtUTdy?=
 =?utf-8?B?MDlYQ3VMQzRiNHBaeGJJWUo3UjFlRWxtb2dzOUZvTk9sZ1RYd2tGRHlWSDEx?=
 =?utf-8?B?emhYMG1sMGRMNjFiUEZMSzNIV2xWNWtsakRRN25wRmdSMTNOamM0aXhMZ3Jo?=
 =?utf-8?B?R3MvaHpNSEFHdGovcG9KVzhZNG1pcDBtUVpjdU5UZmhlUkx6SmR5UUtZdyt3?=
 =?utf-8?B?OEtmRGx3WmlZbnZVUXNtL1BUM0JmZDdMcVhMNFdQck93WFo0S1NBUWJYWDlZ?=
 =?utf-8?B?b2RSKzdUUFpDdzdOR3RhQXBtVXpVTklCNklWT09hdXJDeFB3elY5TmZST2g2?=
 =?utf-8?B?Mms4YVY4RUF5R1JpWWZyUU5vTm1OR1lqUkVFbFlFMk9kRXlVUStPTkFFN1Z4?=
 =?utf-8?B?UkxzWkw3RGU1N29Na0lkUFFkOTlzeTlTTEJqVlVxaW02UkxVemdBdGNRQ0ZB?=
 =?utf-8?B?SkdEaHBXZWNObGdqc3BQbHVzRTlsVHdabk81Kzl5ZjRHZjl5cmk5UT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42293123-db15-4a95-00b8-08da1156771f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 07:33:49.2851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TbTgUnMs3sshNqX0WawZB8XQ9X/b5Dni95D7Zg5ZK66IyKNfbd+jdsD+5f7IJp9ltiDR8IhXdaMYao2Y2JCHlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6336
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/29/22 15:27, Heming Zhao wrote:
> If bitmap area contains invalid data, kernel will crash then mdadm
> triggers "Segmentation fault".
> This is cluster-md speical bug. In non-clustered env, mdadm will
> handle broken metadata case. In clustered array, only kernel space
> handles bitmap slot info. But even this bug only happened in clustered
> env, current sanity check is wrong, the code should be changed> ... ...
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v2: * revise commit log
>        - change mdadm "FPE" error to "Segmentation fault" error
>          ("FPE" belongs to another issue)
>        - add kernel crash log
>      * modify a comment style to follow code rule
>      * change strlcpy to strscpy for strlcpy is marked as deprecated in
>        Documentation/process/deprecated.rst
>        - note: strlcpy() still exists in md.c & md-cluster.c

Please note, beside Guoqing's review comments, I added new code change : strlcpy() => strscpy()

- Heming


