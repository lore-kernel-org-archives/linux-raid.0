Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71B6C5519F
	for <linux-raid@archiver.kernel.org>; Sun, 22 Nov 2020 13:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E30D20731
	for <linux-raid@archiver.kernel.org>; Sun, 22 Nov 2020 13:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dVZM5nTe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgKVNP6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Nov 2020 08:15:58 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:59961 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbgKVNP4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 22 Nov 2020 08:15:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606050954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=6/iSbQT1qoJbdvkw90Me0VLN4dZCuJOc9LYkNH/t07E=;
        b=dVZM5nTeXosjiVT4VIrVNIZXI3gaavoeOA80T6/HYHe92AVDORcJpeJF+u8BblwizRUbWz
        5ihLQ1yLazYiRqQWOnuZoaEeCnZ83phxTqKVzqcAkjGTZv/Qx6MU0z0C3VYssrNiY1RqXw
        9k42bVXUmb3S9Nng4C5dQIyb7tsg0b8=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2056.outbound.protection.outlook.com [104.47.4.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-5-KJ8X0xcLNAedETD51ZG_uA-1;
 Sun, 22 Nov 2020 14:15:52 +0100
X-MC-Unique: KJ8X0xcLNAedETD51ZG_uA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biHzXktHvKvSgp1fBjMM8Cjt4biZK0oK2+huQAlolIoSAsy0xCbqVbLQncQp+5g+K6GFmwJ2OIYh5thNODump6QoK879LiWtElgUQk4OdIZ88cqR/InFm3HiwJXwRJ2NA7NB1UvPiqc+n+y5XARSTg0rit7qS1SV5Vc5o1Sbw1d2feuaXVteTcrM5KpSwN/+ImXSc44tIViM9dveO2jCZ+LUqNVY7vmH5Nnq6woQO7uTay0/sg5MqKhTo9u/1CKc1R9oTI3oKYMszbtHHl4QpaCAQSWvnRraZWYscR8F+nrL7HToVqr/jVaC5EhzQnWWz8SVa7jkVD2HkYylIU2B/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/iSbQT1qoJbdvkw90Me0VLN4dZCuJOc9LYkNH/t07E=;
 b=ZPs7LAS0Q90Q5DLPNpy9b2pB/H/GADyRL+IyLRL2udv9jf7gInrEvx9S2sm5/fYciTEmuzZ/dQKrCRGc6hDTr7aUdLc7VOR7COfXBtTQWYR+K2w+CGSrV62vCHsSlMSB4LpnVrSr112XKYVf9nML83O36ddgRs1dzSxXBpBtSwrOytio6FrxldvYMip077w4yeNK/lqGRGHvY6ftrOXrES3zkLZ4koFuPsk7IYSdu4DtoHMpE+bGV6MG4hobe/ZBAaqNIFaNWbx/BbdUDebLjCEmsmSrysZrrX8G9Hcy7kTzl1LMhxsrhDbJlAtvrPoWSmMtECaRX1zOkg/islYjNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR0402MB3809.eurprd04.prod.outlook.com (2603:10a6:208:10::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Sun, 22 Nov
 2020 13:15:51 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::80ec:b18b:9673:b045]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::80ec:b18b:9673:b045%3]) with mapi id 15.20.3564.033; Sun, 22 Nov 2020
 13:15:51 +0000
Subject: Re: [PATCH v2] Detail: show correct raid level when the array is
 inactive
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <20200914025218.7197-1-lidong.zhong@suse.com>
 <48f8cd25-d872-e306-a544-e31c59d91c9b@trained-monkey.org>
 <SA0PR11MB454240AADCFC09D4771325E3FF1F0@SA0PR11MB4542.namprd11.prod.outlook.com>
 <SA0PR11MB45428397B07F6DF50E6F0CBFFF1F0@SA0PR11MB4542.namprd11.prod.outlook.com>
From:   Zhong Lidong <lidong.zhong@suse.com>
Autocrypt: addr=lidong.zhong@suse.com; keydata=
 xsBNBFne5DgBCADQj9QdXtw20bP35mDylFrd0LWj4cjpQ9kHD693GVpwNqTmwJcxGJutRvhe
 8HJjiJhstnP60v6+Q+qoP7cNY4KS35LDZJHgXbdRcPYBSzabEdWfge6UH86HxK8MHY0w+GDu
 TseKNwt6fr6NH2FVQSTTQhpVv+fYGPTgAqaKD5J8JhTHS9c/sBsV1zNSQmTULpykXXcO/COL
 +Yw2A7P4+KR12wNAIhpITRykUtfKiHjdAFBLmQs0ES/c/MwQ2gOwEt7RAjJB9il71oR+9Kyr
 CDkHaBoNK/mkdDyXDL/FBCqEExeiYL3XnBWckoyPZT8ivA5DQuOuiG8Yv2TyTMSaSMQFABEB
 AAHNU0xpZG9uZyBaaG9uZyAoU1VTRSBMMyB0ZWFtLiBCZWlqaW5nIE9mZmljZS4gbGlkb25n
 L2x6aG9uZyBvbiBJUkMpIDxsemhvbmdAc3VzZS5jb20+wsB/BBMBAgApBQJZ3uQ4AhsDBQkJ
 ZgGABwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsnlJphZSmJJZWgf/VSvl+O1sRDI6
 VIAXiGzFCqVnPBARZFXMahzYrTbfb/LdxTCE9R5g2ex5jM7ME8Y+j/PtCS7z0TW5jF0R9LFP
 gjTHfaUqDq7sqzrONB85NMud+qtkn07HlgTCwhIZe972LHuv96iWv7n1nRyMHe8eAMK2xVL9
 sPS3L4LW5b2AN1BEwk3x/BVoXKNMzlKP8CyoDG03UaptcBRgbm+Ds9Sgx9ZuxkAL/nUdDqvB
 6Of+FleCNRmTm5c9gawOS3w24KzVCbhOKSp+y8FSt0gS05mL1P1wVos2sErKgOk6uSNo5oa2
 TIk6T5BpWytWKRcdn2NSmM68MqezUXMpD/eCjkohF87ATQRZ3uQ4AQgAvvWi8gOGzVm4uiUj
 pxeteRthpsdvm3YU7rAWwxPPSXjZDDoSL8ogSoj5/mV7wKxJemv/UHnxWO66KNkP5YlwBVpf
 yhLWvFuas8vKgrL6xwstjIoqQkAHwzFeMGKYdXZKZbJgxl56MeE6cpGoKpMHNkRVDhbmhfOt
 yrISWhBccrOsgeYjaPos8B53sAQry5PoVA3hNhpSZ23N37VZcs4KJOtNpxbsXC3KcbrisXUr
 MqkyYnccSNVGT1Bfr4nItAp3bdgyoMPh2kWkNtX7xms5fQs3kIZoCevbjQcJeerBG/E4rNtq
 wBYtagTg9m0/bn/w+iA6RfcLZWC7Z31ggkSZ0wARAQABwsBlBBgBAgAPBQJZ3uQ4AhsMBQkJ
 ZgGAAAoJELJ5SaYWUpiScgEIAMcAuAxnvRg5L9aB1/Xrmm+ILf7qB7FYxmavGMkZ+sHrLhw1
 Ycb5jYMhQQcTGCefKpsxx44PAw5DhJe7xnbHjRAWl8ScCGXmJUof3eaQ+7p3pWtl7R/J5W4j
 C5undogrFFcRimd5ah1tWc0t4BejelxpV+OiG4u/ghuCMrEQn6DgGL++gDs3vAspW/43RNZe
 BaxvvUMbNU0B3iKlwzXUxCDlBu8EcXEltM9MF02yoG5FxLaRXa/8kqeYAgH2vQjJqfMBMBLS
 tYfhW3GUnwUCN1GlKsguZWKprwgDzAp0JIeAatemSNtCzcTpgT0gTB+iTWYac12EQTu3Ckdx
 Rdu9+hQ=
Message-ID: <252f5329-ec8f-dee1-cd5a-548c9b3f5368@suse.com>
Date:   Sun, 22 Nov 2020 21:15:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <SA0PR11MB45428397B07F6DF50E6F0CBFFF1F0@SA0PR11MB4542.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [39.78.22.199]
X-ClientProxiedBy: AM8P189CA0008.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::13) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from l3-laptop.suse (39.78.22.199) by AM8P189CA0008.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Sun, 22 Nov 2020 13:15:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a21d485-4555-4d01-7f64-08d88ee8bb50
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3809:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3809E797B961D793CA35AA83F8FD0@AM0PR0402MB3809.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qx1Kzf5OAEGTstN7RhXZvvSsumGaL/Fxn92TSAhXCd6F1f5p0IxyNRoXai8tTIkbLWBYY2Gd117Dj0KGOcIEYL339rHtaaIR+jdvFwfjJ0x+mwMozby84ZtADCEsxABYaCHpM+3kU4C1H/pocRORBdQpv3DPNdeZ9H+tV/4ppDXCWz0zaL9wyU6nqyxd23qPFtki0kCtWVZEVHtjlEUsWmFUJ0HP9kASX0P7H6rQ8c4lvHT5FwP+88i3WjE4Myzdk07T5egHwN5Os6qbmIwuD8AjjgiBuHicvde3sDzSCauuG/jmaE5Y3FAu2Mxg046bhfEigAjpLCiT+fBGLTEBPQA5E3i1K5RYXsdiN50ZZM1hYgPKrzFm6lV26DkLfgXw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(346002)(136003)(396003)(376002)(110136005)(31686004)(52116002)(66476007)(2906002)(66556008)(83380400001)(66946007)(6506007)(316002)(5660300002)(53546011)(36756003)(186003)(6666004)(8886007)(6486002)(86362001)(16526019)(31696002)(8936002)(956004)(2616005)(4326008)(478600001)(6512007)(26005)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EvzSWrBxYESw+v/lIK9N9VKxqYTDyHDcAaF1nGYKI7gIhJpcWNk2+sd8mldq48K22jj8AKn27ZqbSNhW+wv4PeFTMlxIwrVujlXaAeR33ttkR0JH63thWqeNXQjQBP/rf/Z8LfFz6Bt1WkkNaxsqokOmiABc84522HOGaW553TgGbIqpVX3OE3UUAsXdP94Maio55N6WPSWwEQKfoZHtFJsHnMQ38ZnsHVT1hbMELU2PBMD0JCWvEz84j8quG0lIjodVLTy2tk50j4CHVU7/B+yRj5SLMO7JomJ5qx3TR6uvLIhRTPzCL+PZNrkyd8SVubQGZxvwrITD8iOmMB4FFWtbOBzr93r5jnsjXg53gra3rztW+7uzE+cvmDI2B/EU6onyBzpp6qF7xTMbHamgfLQLfXxeAhzT2UYl0OPRHHsvDUPwhvMLjFqncuLKeRiBHsjyE//qUE+QShChG/zp913boW6UKo7hZg1JLVj9p6i3q2hJKn9afuZ7bHc/IvJJHRug0oOPotfLeUSjKuaKuwQVVhyBZAGPDLlISRxIBxDm5dxRRGFYNL2LM7TpyAiWs59fxzL7jrV2sXuNm7N4WxOwlURUVoWWwqS0Xh7cUQCbHmWU7CYYbzwcbPafcKTBDo9DKfgKtJnLIcp7jgjm1yQQDjxDRzanIVZaxeK5as4mqfO0KwCc70l6Oy9j81BHb8qWB7LL2awVuiuHxVtIcf0psHdqzneydSHHgf+DB2bGdaywMnERmhc1CCbcwYjYsIziAmn+J0eY1Aat5Fmo/HlqQZ2NPpkLXlR+snXhnZ4/qNj9L0CVh7pz125beg3OStmsv9O5JR3LyAzSoFMKHk2D9l5S6N6XJAvVOxrABG17ILKbn2H7iPEC+rQ2TvCWHyazIMvHFPQTosSEGB2usA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a21d485-4555-4d01-7f64-08d88ee8bb50
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2020 13:15:51.4358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PLnjcZci1GYk3t8kgQQGE0H6GLHUg3kmHh2sQB5B73172FjFbGTBNfPv12RX62dA0Z2E8N/LxbOgmm2Yl+66XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3809
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Tkaczyk,

Sorry for late response. I can reproduce it locally. I'll submit
a new patch to fix the regression.

Thanks,
Lidong

On 10/20/20 8:32 PM, Tkaczyk, Mariusz wrote:
> Hello,
> one clarification:
> Issue can be reproduced, just create container and observe system journal.
> I mean that the seqfault cannot be reproduced directly, it comes in background,
> during creation.
> 
> Sorry for being inaccurate.
> 
> Mariusz
> 
> -----Original Message-----
> From: Tkaczyk, Mariusz <mariusz.tkaczyk@intel.com> 
> Sent: Tuesday, October 20, 2020 11:50 AM
> To: Jes Sorensen <jes@trained-monkey.org>; Lidong Zhong <lidong.zhong@suse.com>
> Cc: linux-raid@vger.kernel.org
> Subject: RE: [PATCH v2] Detail: show correct raid level when the array is inactive
> 
> Hello Lidong,
> We are observing seqfault during IMSM raid creation caused by your patch.
> 
> Core was generated by `/sbin/mdadm --detail --export /dev/md127'.
> Program terminated with signal SIGSEGV, Segmentation fault.
> #0  0x000000000042516e in Detail (dev=0x7ffdbd6d1efc "/dev/md127", c=0x7ffdbd6d0710) at Detail.c:228
> 228                     str = map_num(pers, info->array.level);
> 
> The issue occurs during container or volume creation and cannot be reproduced manually.
> In my opinion udev is racing with create process. Observed on RHEL 8.2 with upstream mdadm.
> Could you look?
> 
> If you are lack of IMSM hardware please use IMSM_NO_PLATFORM environment variable.
> 
> Thanks,
> Mariusz
> 
> -----Original Message-----
> From: Jes Sorensen <jes@trained-monkey.org>
> Sent: Wednesday, October 14, 2020 5:20 PM
> To: Lidong Zhong <lidong.zhong@suse.com>
> Cc: linux-raid@vger.kernel.org
> Subject: Re: [PATCH v2] Detail: show correct raid level when the array is inactive
> 
> On 9/13/20 10:52 PM, Lidong Zhong wrote:
>> Sometimes the raid level in the output of `mdadm -D /dev/mdX` is 
>> misleading when the array is in inactive state. Here is a testcase for 
>> introduction.
>> 1\ creating a raid1 device with two disks. Specify a different 
>> hostname rather than the real one for later verfication.
>>
>> node1:~ # mdadm --create /dev/md0 --homehost TESTARRAY -o -l 1 -n 2 
>> /dev/sdb /dev/sdc 2\ remove one of the devices and reboot 3\ show the 
>> detail of raid1 device
>>
>> node1:~ # mdadm -D /dev/md127
>> /dev/md127:
>>         Version : 1.2
>>      Raid Level : raid0
>>   Total Devices : 1
>>     Persistence : Superblock is persistent
>>           State : inactive
>> Working Devices : 1
>>
>> You can see that the "Raid Level" in /dev/md127 is raid0 now.
>> After step 2\ is done, the degraded raid1 device is recognized as a 
>> "foreign" array in 64-md-raid-assembly.rules. And thus the timer to 
>> activate the raid1 device is not triggered. The array level returned 
>> from GET_ARRAY_INFO ioctl is 0. And the string shown for "Raid Level"
>> is str = map_num(pers, array.level); And the definition of pers is 
>> mapping_t pers[] = { { "linear", LEVEL_LINEAR}, { "raid0", 0}, { "0", 
>> 0} ...
>> So the misleading "raid0" is shown in this testcase.
>>
>> Changelog:
>> v1: don't show "Raid Level" when array is inactive
>> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
>>
> 
> Applied!
> 
> Thanks,
> Jes
> 

