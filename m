Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EB7C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 30 Mar 2022 10:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbiC3Kgo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbiC3Kgm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Mar 2022 06:36:42 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4ED2BB0D
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 03:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648636496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f8+Mgx9Qxr2qon80dpKZAbfdXY4mCu8OSlhySnlC7z4=;
        b=gp56rUeON29uDEupnGzU6X0ZwZO1m4Nq071QqM/nNOzKIjqlbQsk8rnLWgC723paX0CR8Z
        NZoqiVpTx5QOKtQhO9fpuS2CVQUtYGv011+bRHeVRi5f5kKmAbUXoJ2wMNaD5Wm3El00iI
        fJ6ySOCpAsqF8CSP6iYXzWSvUmV/eaY=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2109.outbound.protection.outlook.com [104.47.18.109]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-10-Q5G2HPHINgCdCgH9d7nIDw-1; Wed, 30 Mar 2022 12:34:53 +0200
X-MC-Unique: Q5G2HPHINgCdCgH9d7nIDw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hD5bdHhiXYbq55YEsYKMCmW+KmEsz1ZZp+SBMDk4ShQE1J36OK/omdUI71m6sj0azBeLcOYScfJuWYoyoQA/qS9L/zcRII2OclnI0cZsvjISAVd3I8BaAiWLs3D/QlE/zM8vmrEK01qEjrHktMmlXYTBig3uenwodsiUmLcE+DnwxAOcxCG4Nus5o4XnSucpZtN3d/e/1xIRYiUB+Z7N7JpRuN0XrIi/4DHi69sOTYX3NJlsPtb4NbOVbA912Q/lev95ytmL9lVGlfqEnSEeCVfWGnCQC23SqgukDTUW2twEfKApmuIV1NvKXbA+NSSRMXOAOYLyyfRLvevOVwga/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8+Mgx9Qxr2qon80dpKZAbfdXY4mCu8OSlhySnlC7z4=;
 b=U9JGPXSObG+ZbcD7wXnj+pyKIq3/R+Gbv4itovUaj5iew4nj2m+z7wCJVMsm9pLHy5h9AmexMD8IjPU2C7PYDu63D7gZVG7gRv8A/5AKIqzcUimWJPWo+dr/KUfbTXTFrS+d6Jenk3/H0kKnZ6WYOgXsy8LW447G23VlH3RKtvTJX6ak3Pk1NQUWBWLO2pB3c262GdQTOCILmP67gD67WQHnEfBZRlJ0XgMRirfWqUJoaEHw+ckH50NtouAsnvzAjiyp539gmLjB1foJzOg2+WxrZudNvk3deS89kR8x/PrKzIUdIaUsV+VYS9v0DQN2bD9rJfyVNswBRYseSp8D2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 PAXPR04MB9326.eurprd04.prod.outlook.com (2603:10a6:102:2b8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 10:34:52 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 10:34:52 +0000
Message-ID: <228810f7-90bf-15cf-37ba-c7977d35c046@suse.com>
Date:   Wed, 30 Mar 2022 18:34:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] md/bitmap: don't set sb values if can't pass sanity
 check
Content-Language: en-US
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@linux.dev
Cc:     xni@redhat.com
References: <20220330102827.2593-1-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <20220330102827.2593-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0145.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::13) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 902638a6-4153-4c78-bfc2-08da1238ecb4
X-MS-TrafficTypeDiagnostic: PAXPR04MB9326:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9326C68F28EDB7B3BA1AA993971F9@PAXPR04MB9326.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qMc0ZuYBYZEJjprKIJiaW2BVeREESOpPCgtgyooXJUsj7ibY9wxkif7bZ4Z8wfsj+qnNZBIq/zDAgOYbRaJJ+YHza7YlZR0HtCMfclcCpt8oEj+fsAl2LTEp0VnWhyoTJWBSHVMIFRO4BOO+C95OLZ0yl53TtpUuZZAsFUi1Sqek4LQYVmPvPhB1raKoaUakVgUz8nB/yhWkCWqD7rc5em82Q+pIoXlIIIiUFYjBr/992SeTp4FuEL4MURNo22xb/qeI1iuXoTQW9luKS3sfJLwHW1zcYPBWh4aHhzBEFLlOT+eaDPM89Pht+EYRMIwdg6r8cyIHGI9jZAsglRF2Q4HdS/jX8jXCu/B5K+DUs4GO5Gh8l+reKPT0dObe5jnf1a2L+qf9X0gr3j5dRsQawz2+Cy8ssk95/d81B013TDNje5w26XdQtpatOaj3qzUi6UfuyUForBM6MOHwejhlYg/i9vxmFT9xXZ/HmWn8/c8Z1hoLgcMXQfP7tPcDj9KgHeaHLSnTUok7j1owFnspdAlENP2X2ptR0Clf1XvUvZbPyNSraSjWkhcd9B9s0FIHyPElnASbb/pZxf29AXvsa8IuQjB4DD6qCIMkUKqnT7iClt1+hRCAmAjlTATFYcIsaIcEi1pjAtzWZDF6s9KbqwZqq4aVhS3hTC00aw6jpWRikIBnyf2E6gDJYo22sP1xUvbDHXtS8YxMmWkj0yjtFeAjipUrVwC9xLfIA0GPCo8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(316002)(6486002)(8936002)(508600001)(6666004)(6506007)(86362001)(31696002)(5660300002)(6512007)(2906002)(4744005)(4326008)(186003)(26005)(36756003)(8676002)(66946007)(66556008)(66476007)(2616005)(53546011)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFJKd1hrRWtlQkNTa1p2UFc5VUpwYkxIYWNaZTc1TUpUMXptYnNMWDMzT0lU?=
 =?utf-8?B?dERuUGhhT2kyR2lySkxoNkpSU21uUzRZTEYyOUFzcG8zaFRuMzUyRjJxTnlI?=
 =?utf-8?B?UnVVajBwS2NRUzRRelRxcENpUnRPU1Rja3o5bTR2dGFpQkZ5SWFkbDFJMlBB?=
 =?utf-8?B?WEhkQUliaWgwMHhTMFFCRmVBdHkyUVNWRHpjcWMzUi93RDhsZWRESVpwZ3Nr?=
 =?utf-8?B?N3B5L1Bicy9HMXpiNU12Y05RTlpxdENVZlJ2OFF5b21GcGtzSllrVzlyQkhj?=
 =?utf-8?B?T3JDdHVUZGU3M1RPUEczRCtGRDRWeGZFUjErWDQ1bS91RFFzSCt6Y21IR3pI?=
 =?utf-8?B?UEh4ZTdDWjVNMmxHRTVybkEwUGhteGJwUWFVcWkyNWs2MXpweDJqYzdyNnJC?=
 =?utf-8?B?SjlydXlqamI3UG43NXdyVWk3Qk55bFZlempYSjRXWVdtaEIxY2YzWFFNTmFa?=
 =?utf-8?B?aXIwcHM1UmlsQnBQazkxK1RHRTBXQnAvSWNnYmc0RVRDNy81YWJkSjUwcVdE?=
 =?utf-8?B?b3hXbUxiUjJHeHRudzhsT3Y1Yi9VRXlHSHBjV3k0TGEzcUJ6UERndFIxeWFW?=
 =?utf-8?B?U2tpN1FKNEl0NHhFdStoQTZTaG43T04yQ1FaQnNwUTBxODFzNnRVbGlncWZK?=
 =?utf-8?B?cGsrQ3UzRjRidmxtUG15bWt5UjQ5RlZPOTU5dzVMT291cnloN3h6Y3BBdUNn?=
 =?utf-8?B?ek5sK25KL1h4aHBtYVlNSnFhVnhxb3M5d1FWRzkxZ1AzRmJKdmlXbkV5UUww?=
 =?utf-8?B?N3o3U1kwTitjQ3gwUkNjVSt1MU8xVzg1cUt1TlZ4WTZwbGtrdGlKNWhMc3Zh?=
 =?utf-8?B?R1lKekl4N1pOZ0gzV2ZZVi9pL0NKbzRIcTJCeUx4ZWFHak5IY1czaldwbjVQ?=
 =?utf-8?B?MUNTR1d1cjRubHhJRHJtWXFHUStINUpDdG1BOTRZZWJSNUh1OWtROEMrdFY2?=
 =?utf-8?B?OWxCaTJ2cFhuMHN0TXRKd2NHS2ZBeU5vM0hDREN2T212ajJ6VmNvTUhwU1A0?=
 =?utf-8?B?dWd3R3JIaGMvbUNVUFdFK2VYV002dHB1VTQwQlV0K3dnM0NFWTRTQlFUQTVQ?=
 =?utf-8?B?ckcyT2d1M2F5SS9Ga2JHcVlKSFJtS0tORUE5N1RVbUlFVSt6S3lsVDdQcEwv?=
 =?utf-8?B?TENSR1cvbG5LYUpEZHdRdExSL3NSdmV3QkcyeVZINXZPQlQxTGNIUUw2d1Nm?=
 =?utf-8?B?RWZIREpLOW9hVVJ6ZjJGMGdxU1NZNkJTQ05qdE5XZm9oRVR3KzVYdmdlcHl4?=
 =?utf-8?B?MnIzdU1GSmhkQ0l4blBhcUFYVitZQ0FFNFp5akthR01tVTA2MjdJeDFsZCsx?=
 =?utf-8?B?NUVjMEVqZEEyeEFaUG5RMnJ6UHE2SnhNSmF6TVNuSE9ZdzhNL2JHMGMxK0xS?=
 =?utf-8?B?a1hLa3NVWXZCSHd4VHpxYVpvYnpaNjY1cEk3V2dzRWJwMjN6TWQvRnV1czk0?=
 =?utf-8?B?Q09pYWFJbXQ1elRkRExyVkwyL3NHNFZXSXVVY2liMlprRHhqVlFYVmZjcXlE?=
 =?utf-8?B?ZDVZSE82STNncGNCREhaWlpaZmRCYmZCamJMQ21FMWZES3hKNnJML3ViSWFX?=
 =?utf-8?B?cE51S2xaS0RsdW9HNHg4aTZnRWFYMTVPVFA1T1RzWmxiWjdJK0N6VHNpempx?=
 =?utf-8?B?R0o5U093RGVVdzk3TkdseVFEcGI3MmRlYkNSK3dYa3hvb2FyY1BkVlR0WWlj?=
 =?utf-8?B?NndiTmdTVU1LQzZVbVpPbFQ2Z3B1ck9LeCt5K3h4R0VINTMvcFpqaEVSY3g3?=
 =?utf-8?B?NkdYUXNldkdOK2hPdFVHUW5nN2NsaVIwWXdzOSs0bGtUUXFJY3hyRVFVNHEw?=
 =?utf-8?B?MWtOb01KVkdYYU1DcnRBSmczcHdtL2VRVWl4NnQ2REd0OUhVSWlGVXBKNFBD?=
 =?utf-8?B?VFFacGRCL0VOZ1ZSQ3AxRWFVVGtQT0R5b2hoUDYwbzFuRU9pbHpvYjgxOEJY?=
 =?utf-8?B?MmhTSm9KWWhac3R2N25aRHB1UTUveXZaK1Q1WXprZjdLMGp2U1I5YzBXOEto?=
 =?utf-8?B?MFJma2NvZVRYZDNXVEpPKzM5VE5hTXd4WGxIR2xpbHJvK2hrYkFNaUx3YW0v?=
 =?utf-8?B?bU9xZVVhdERwOHJBaWFnTkJHa21vNHpINHY5OHNBRkN0OFhKYmxXTjJUcWJk?=
 =?utf-8?B?TjhiaXlydTZuam9NYUhIdERyOERvK3JoN2NORjdhVkpZckxib3VITXlYL1Mv?=
 =?utf-8?B?RmhNV3VqbjhLUUdrTjh6NStLUlFyaTN3V3h1TDFNUGc5dFB0RTJCZk9oVHFy?=
 =?utf-8?B?TFV2MFBFYm1helpkekd5ZEo1VmttWlJUcm5id1pkNk5wR1NhZXErbDhTKzQ5?=
 =?utf-8?B?eXBvQUdvQ1JSWmdjTWcwZW9nbndaQmIzdk91c0R0MEt5SkxYTXAwUT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 902638a6-4153-4c78-bfc2-08da1238ecb4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 10:34:52.8833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfnKYlefMSHo1+AxbZIIokEPDAXJoeNdaS+8oDUMnHyj8ya6ET+QAwMF1WzWiXbqyTj9AAPjF/0A3UZHg8Kisw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9326
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

sorry for the mistake in v2 patch.
I had checked codes & tested module ko many times before sending v3.

- Heming

On 3/30/22 18:28, Heming Zhao wrote:
> If bitmap area contains invalid data, kernel will crash then mdadm
> triggers "Segmentation fault".
> This is cluster-md speical bug. In non-clustered env, mdadm will
> handle broken metadata case. In clustered array, only kernel space
> handles bitmap slot info. But even this bug only happened in clustered
> env, current sanity check is wrong, the code should be changed.
>

