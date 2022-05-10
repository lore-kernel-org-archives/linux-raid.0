Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFA9C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 16:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347527AbiEJQmc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 12:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347523AbiEJQm3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 12:42:29 -0400
Received: from GCC02-BL0-obe.outbound.protection.outlook.com (mail-bl0gcc02on2115.outbound.protection.outlook.com [40.107.89.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0C55BE42
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 09:38:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2tzrGXg1kyr5VgxH07UL3G7jtnHzx13eZulRhffST3NZUKd+72JIzoCurWHDYKNatrJzLmFEkZYVSUlhlWlFKxzHsr9FSRR3GIaTkhTxvXzxYyKVRLkXto/VgBq9rnc6WZIddSvivS8UWWOm3Itsf9Ci54Cbe7prFI0Pcf5LaSkOWvLReNi/hgxIWei/ivhe05Xnivim4dGL8XFGeujxbRe6oYXBL0zLGQVnjA5LY1pPMpNpIy8/l5F5XApNfkOkFp+yw88xIKPxUbFMziUBCAUuwE0XhEwslNUl9nNe7Y7IMgLg+Ft8QgkJHTy3bD+4tomMSta93nR/W2AW87ZVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7q1v87zbFr7Ay/OZJ5TBkOHWm0MWj56VTgbMzA+HVJ4=;
 b=Pn4vo45fu3TIoLp6xeeIkMhTtTUFNlSh11+o9UzVVUR90Ae/IIebgElFSMb5swz1mWOnPmbZ0pGzklBxkNyKZSuCsa9j8VO7DoJbDpQnrtzWNHJ4pF7gHEuymeSuo+FoWCMuExZATfYOEmXB3DYmAWX9IGToKf4baAvfPmBhK+hm4PiBpnVrlwT8WwYJT9D1XXmKb9Xv9Sq7qzo7swocdhzjLhnZacjcBTOKEHrxr/exhueSbd8M2zKm0Q/28Qc5c4HtqALWLM02WKcXAduWDoRVadVkvnDwBlCjhlYvRnagoP3yD6v4xfmTK8uC9sY3+eyQZfksQ3u8fjPju363kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nwra.com; dmarc=pass action=none header.from=nwra.com;
 dkim=pass header.d=nwra.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nwra.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7q1v87zbFr7Ay/OZJ5TBkOHWm0MWj56VTgbMzA+HVJ4=;
 b=yMW8ke7NfKNFinPAhQu23y/jfz3KsRdV4S5IES4DRKy1/3ZF4ZfKN5Ne5tqrQXVXdGMO3UBvZGow1pWokELIYTbHR0bJEkxcP9Do8PFcG6fU4PF9s6yKGglcmvZ8G6O4aVsObu/yWmKJDqDvIesrJMvQdNL9rh1AMYvUTLIMBYaRWzsMRX81uzdWU2N9x6vjwfG+Q3DzR69M328/qnxFJu31oZn2j3r4GovIyFy0VjzgBnUh8gxAdt8piyCoLb8YfbUaaptyrZZXkf4+B2MD5ZmYTTbTHs30xdZSVhGCFRmomVbNIcBOZrWw2unocKAnzcQeM6tO/xaYOtLOZS20PA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nwra.com;
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com (2603:10b6:a03:26b::14)
 by CO6PR09MB7622.namprd09.prod.outlook.com (2603:10b6:303:c7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 16:38:28 +0000
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::adad:368e:3553:5368]) by SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::adad:368e:3553:5368%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:38:28 +0000
Message-ID: <f862405a-0c13-eb7e-f802-fdc842218f75@nwra.com>
Date:   Tue, 10 May 2022 10:38:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: nvme raid locking up
Content-Language: en-US
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
References: <d9a9516f-695e-3ead-6744-1510b13148c4@nwra.com>
 <CAAMCDefH7Xn7HvwcRCQMbdbGX-Wz7FtvUMRBHrCfo8ioeBVw=Q@mail.gmail.com>
From:   Orion Poplawski <orion@nwra.com>
Organization: NWRA
In-Reply-To: <CAAMCDefH7Xn7HvwcRCQMbdbGX-Wz7FtvUMRBHrCfo8ioeBVw=Q@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms040107000503000603030402"
X-ClientProxiedBy: CY5PR15CA0005.namprd15.prod.outlook.com
 (2603:10b6:930:14::18) To SJ0PR09MB6318.namprd09.prod.outlook.com
 (2603:10b6:a03:26b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 472108c2-ec4c-4f6d-94b6-08da32a382d2
X-MS-TrafficTypeDiagnostic: CO6PR09MB7622:EE_
X-Microsoft-Antispam-PRVS: <CO6PR09MB7622FE4248A8FC652424AB86CAC99@CO6PR09MB7622.namprd09.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9uuD1b2Hn0v1tu98YJTFe1DZNldY4K74adpjRLKaFuIMAwvZvUhXJEyShsOdfnJ3wz3Q7YOCvG7FIbxtdWMhyZZdR0TG2p5MTpIS7aEIAhjdNO5OIsCVcAYcn5VmtWmvFKW0rmomcdPSnMrGLxixj8/kPsOGr4QdENfm5VFkxpj6YtoBtseWLv/ntUKkP6jXezu6Qom87nT25Ex23AHLo17y17kYfvgNCS2AEXUY6vET50lj/yULPNbHIjPa8tfXeByA9O8LGSAy3h2sz/6rsql0oRhKQqxkDRBVOHaq9NibAKVnnJrckf0j/uaE+5E5zCxpluB6QhTqAkUErB5x7xyLGokQIoSMvcyizSYyGXKgye6JskOJc88yo3vgITMNbfBXFX3NnUgWkRN8fvsOuBLflDZ/hpLSl1EAc6pxaa2ZfZj2r4f8Hfo7818u8UDqG8TKlQXy5ctkEGXMgnPm2UuLZ8Ub4sHJTyfhvJXwWEjXnKbOkdHbd/9KPnmciXDRFNImKj8zoL78cnhN/2G+ByiJP38FOW2Azxa9xWM/G3OTeVEO83c4esE7jMA/vPBvOYcOPqAYLgq3TnzqQ+bQQy+X1A7mLxTl6c0aPM5kCpZxTmpm3UxvfKipbAxFZHziPSwWkm7o14qHdZApCpyJkksXriapoZGrwIQVJYDa7qViSJudK+hGd8oNOhNWaenPvnZJlCi2l6dnVuo5E168KEVahIpEHOSl/f5g1eZ0E6n7d0Dj4UKjpI3uPG0iMQNqrGyb6LoUxH/uxDlQ2gqhMUeMHi7IiHaRu9+kKsNJuZqt5t7pTRuIvZP53nGCEYrc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR09MB6318.namprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(396003)(39840400004)(136003)(5660300002)(235185007)(38100700002)(6916009)(8936002)(316002)(508600001)(3480700007)(66476007)(66556008)(186003)(36756003)(31686004)(66946007)(86362001)(2616005)(31696002)(26005)(6512007)(8676002)(4326008)(40140700001)(966005)(2906002)(6666004)(83380400001)(6486002)(6506007)(33964004)(36916002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2g2WGlWSTZqRURDS09YSGtVQlY3MmRNMGJ2NS9jY2NMVFJlVVJvblkyb2M5?=
 =?utf-8?B?Z08rNGdHYVVQUkNvanNZa0lMcmZaYVJnV2IxYzFHd3RaR1hZTGJ6WC8yMFFp?=
 =?utf-8?B?Umo3WXNFTkZ4NnlpMG5sbTlyY0pNcnRsVHBmUFU0NWVSNGhKTEVzc2wwZCtm?=
 =?utf-8?B?TEJGcUUyYmkreUZjTWtnYmRIVVJTeVRLR2I2aXFHSjdBQkViYzN3eEVTR1Ax?=
 =?utf-8?B?SmlOTzBqV1YzZHBQMHdGSkRWNjlzUlJwVDhINTNlTUc3dzZGUy9XR3N1VVpP?=
 =?utf-8?B?YTQ0ZkZpMys0SGdIc1dsNmtjK3NzT0lLR1BTeEs4TGNTd2Y4L2pXd1I2MTk3?=
 =?utf-8?B?eHZveDZHSndGQ1RqL1BPd1BtLzJzRWxiY0xLNHBrRHZMMytXSFhQNkhVRzcv?=
 =?utf-8?B?UHVnQVhwcmRxdGo3cy9IRmFIcTlIVWVWWG82clNuTEdkcUhWemRhUk5mMDZT?=
 =?utf-8?B?dHdNSEY3UTZNNzkwc2pJTUZ2VVNJNy9CeW9kYUxWdFZPbWxmR2dxaWpkQXBG?=
 =?utf-8?B?MDMvUHErY3AxRnRaWWZFbCtqSzBUcnQ4cUw4WWdrV2JXa00xbWlNTHZFSUdq?=
 =?utf-8?B?QW56R2hDMG9oNHlJUTFPUTh1S0FPSGlqKy9aa01LaW5GSUFYS1JZZXpFWU1J?=
 =?utf-8?B?WVZWWEdJUlZlVWRDRU0rcWxmdVJvTGdiRFhRT1pMTUo0ZVV5UkRlbDRvRlFT?=
 =?utf-8?B?LzUxRkhDVjFMY0kvVVNBVVFwQXNqZkhhak9OeGVOK1dWdStGMXZBVXVzMlo2?=
 =?utf-8?B?UXpOcDFIOWlPZzE3WTgwbWJCbnF6azR2V3ErNG13enZrSDBuaGVjQ2Zxa0sx?=
 =?utf-8?B?UHQ2N2lKZ1RZOXFvVVZMc3pLR0Z0RWNXNU5jNFBLMGVORzhxK3U1d2VRR2h1?=
 =?utf-8?B?L25seTdKWkpmN1A2UVE0aTJkR1k0YmJVc3ZEcnZjK2JQdURlamhYTDRlMVZh?=
 =?utf-8?B?UlR2VEFUYnRRYkIyTGc3T0UxSzd5RDM4SHNXNkxJT0xJOUhHaHN1cEoybW5v?=
 =?utf-8?B?RXlZRU04R0xYcmlXbG1ZSVVjQlptckVta2VDa0djd21VSHFOR0FiVGRncmRN?=
 =?utf-8?B?ak9rYkRkd1RDMlVXMzRlRXhKMXFuWEtLS3NTcGZwM2hCS0tRWFZGTzhJQW53?=
 =?utf-8?B?b3dlR25CM1lHYkR2N3JPSVJGalRRWVpnWHNPQW4yRGFUSFY5UHVkNmVwaTB5?=
 =?utf-8?B?a2lWQjdRaW1NQVEyVHdIWXUxSzlTZ09sWkNsMjVUVmZ4bUdPNTY0WFZWNmRV?=
 =?utf-8?B?TjB1d3RseS83UFlET0tyc0NUK3pSK3BoeTV4TlNCcjJNNmVlQnZZYW1EZlVu?=
 =?utf-8?B?czJoS3VDaUFZN2NPNXl3SFdxVGl0OHVMVWtlSFdVMFlWdnVDb3BkemFJazd6?=
 =?utf-8?B?YUR1SzVRL2NYbnNIWmJaK1ZnOC9Kc0NPM3YxQWFqZHNNMzdzRTRKcHRpRWJY?=
 =?utf-8?B?Zml1ekJldjU5WHRYMXNsOHpqT2xMSzZlK2FOU0YxME1NVUtiNklGS2V5WXd0?=
 =?utf-8?B?SXpPUVQxaXE2dHlpMjBCc1cyQ2VQaVJ6d2lPcUVvZk5WMkR6ZUFScFFaY3g3?=
 =?utf-8?B?Lys0cDlYOUdnL3c4a3YveXd4NWRLalNqcWs2Ykl0ZzNWUnFpYzJEb2NScUFO?=
 =?utf-8?B?M3hLTDFUc1NjWDlXQjNSeEh6ZldRQTg0Rm40WDMyd1gvOWxnVUF6WkFCYmZL?=
 =?utf-8?B?MXVPTG5xM3d5dDNJNElhOUl4WUlXcXkva2FYK09tREo0d0FybnN4MXlaT1NE?=
 =?utf-8?B?bm1mMDUvcFlqb2NvK05VbEVWZTRjMmNYamExbjRjL0JrUWVqckxnUnM2M1ZJ?=
 =?utf-8?B?cFVlQmszWHlKSFQzdGx3cHUzdG83dDVidHpuU1RMak56QmViNi9wU2VyY0l6?=
 =?utf-8?B?MDdWZ3UvOExtZjFJVm12cSsyaTVXbkg1Y2RNRWFSanRuOWxyQ0lGSkUzcjRF?=
 =?utf-8?B?azRhdlFJdU9LbDJQemRUODAvOWxidnRZM0VsT2s1ait5ZWp4NFlZSlFZRmUx?=
 =?utf-8?B?MFlSZXpmVUdUUmY4R293VzNNYkVhZnRhMzRDRkJybmgxbjlSWnZZeUVYcDE3?=
 =?utf-8?B?RXdScUFwZzJzMHhlQmRHb2dBeUNnNDJoVUpONVpIMU9Vdm5tUE1jWE5zUFJa?=
 =?utf-8?B?TFNZaUR0bGx4Tml2OXFlSTFCYlB2NjBwRTBBd3gyUHdiUzBXeW1OeFRZdEdF?=
 =?utf-8?B?emtoUG9Nb0ZCSmhyUjdpTXArcGNucWt6TmlTZHV5VEFWcGd5SDIvRzVtMURM?=
 =?utf-8?B?T0V2Um1uUFhOQ1IvR3B6S1prTkxzUHpFNWxJd25qK2Vvd2wrbk9GdzhrOEp0?=
 =?utf-8?B?MllYNllYTm0zanJUbXp0d3BqOGE5bXJFZ0R5ZzNWQkZkemljMUJwUT09?=
X-OriginatorOrg: nwra.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472108c2-ec4c-4f6d-94b6-08da32a382d2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR09MB6318.namprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:38:28.3961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 761303a3-2ec2-424e-8122-be8b689b4996
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR09MB7622
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--------------ms040107000503000603030402
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/9/22 10:03, Roger Heflin wrote:
> For the hardware, if this is a gen9 with a v4 cpu (cat /proc/cpuinfo will show
> if v3 or v4), then make sure all of your firmware is up to date and disable
> all cstates in the bios and in the os.  If this is a V3 then update bios, but
> my experience was the v3 were pretty stable, but the v4's were very unstable
> without the fixes.
> 
> If you have a v4 there are some instability issues that without a current bios
> are pretty bad and manifest as crashes, uncorrectable memory errors, random
> lockup (no messages in ILO), and random PCIE issues/lockups.  And since NVME
> is PCIE based it may not show exactly the same I as I have previously seen
> (since nothing I deal with has NVME) if the NVME buses are being impacted in a
> similar manner.   Updated bioses seem to reduce the crashes quite a lot, but
> on some machines the additional c-state disables are claimed to also be needed
> by the vendor.

It's a v3 (I guess I'm glad I've stuck with the v3's).  They've been quite
stable in general.  I'll apply the latest BIOS/firmware updates and see if
that makes a difference - thanks for the reminder there.  And then move to
disable cstates if the issue persists.


-- 
Orion Poplawski
IT Systems Manager                         720-772-5637
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion@nwra.com
Boulder, CO 80301                 https://www.nwra.com/

--------------ms040107000503000603030402
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CmMwggUVMIID/aADAgECAhEArxwEsqyM/5sAAAAAUc4Y4zANBgkqhkiG9w0BAQsFADCBtDEU
MBIGA1UEChMLRW50cnVzdC5uZXQxQDA+BgNVBAsUN3d3dy5lbnRydXN0Lm5ldC9DUFNfMjA0
OCBpbmNvcnAuIGJ5IHJlZi4gKGxpbWl0cyBsaWFiLikxJTAjBgNVBAsTHChjKSAxOTk5IEVu
dHJ1c3QubmV0IExpbWl0ZWQxMzAxBgNVBAMTKkVudHJ1c3QubmV0IENlcnRpZmljYXRpb24g
QXV0aG9yaXR5ICgyMDQ4KTAeFw0yMDA3MjkxNTQ4MzBaFw0yOTA2MjkxNjE4MzBaMIGlMQsw
CQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjE5MDcGA1UECxMwd3d3LmVudHJ1
c3QubmV0L0NQUyBpcyBpbmNvcnBvcmF0ZWQgYnkgcmVmZXJlbmNlMR8wHQYDVQQLExYoYykg
MjAxMCBFbnRydXN0LCBJbmMuMSIwIAYDVQQDExlFbnRydXN0IENsYXNzIDIgQ2xpZW50IENB
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxDKNQtCeGZ1bkFoQTLUQACG5B0je
rm6A1v8UUAboda9rRo7npU+tw4yw+nvgGZH98GOtcUnzqBwfqzQZIE5LVOkAk75wCDHeiVOs
V7wk7yqPQtT36pUlXRR20s2nEvobsrRcYUC9X91Xm0RV2MWJGTxlPbno1KUtwizT6oMxogg8
XlmuEi4qCoxe87MxrgqtfuywSQn8py4iHmhkNJ0W46Y9AzFAFveU9ksZNMmX5iKcSN5koIML
WAWYxCJGiQX9o772SUxhAxak+AqZHOLAxn5pAjJXkAOvAJShudzOr+/0fBjOMAvKh/jVXx9Z
UdiLC7k4xljCU3zaJtTb8r2QzQIDAQABo4IBLTCCASkwDgYDVR0PAQH/BAQDAgGGMB0GA1Ud
JQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjASBgNVHRMBAf8ECDAGAQH/AgEAMDMGCCsGAQUF
BwEBBCcwJTAjBggrBgEFBQcwAYYXaHR0cDovL29jc3AuZW50cnVzdC5uZXQwMgYDVR0fBCsw
KTAnoCWgI4YhaHR0cDovL2NybC5lbnRydXN0Lm5ldC8yMDQ4Y2EuY3JsMDsGA1UdIAQ0MDIw
MAYEVR0gADAoMCYGCCsGAQUFBwIBFhpodHRwOi8vd3d3LmVudHJ1c3QubmV0L3JwYTAdBgNV
HQ4EFgQUCZGluunyLip1381+/nfK8t5rmyQwHwYDVR0jBBgwFoAUVeSB0RGAvtiJuQijMfmh
JAkWuXAwDQYJKoZIhvcNAQELBQADggEBAD+96RB180Kn0WyBJqFGIFcSJBVasgwIf91HuT9C
k6QKr0wR7sxrMPS0LITeCheQ+Xg0rq4mRXYFNSSDwJNzmU+lcnFjtAmIEctsbu+UldVJN8+h
APANSxRRRvRocbL+YKE3DyX87yBaM8aph8nqUvbXaUiWzlrPEJv2twHDOiGlyEPAhJ0D+MU0
CIfLiwqDXKojK+n/uN6nSQ5tMhWBMMgn9MD+zxp1zIe7uhGhgmVQBZ/zRZKHoEW4Gedf+EYK
W8zYXWsWkUwVlWrj5PzeBnT2bFTdxCXwaRbW6g4/Wb4BYvlgnx1AszH3EJwv+YpEZthgAk4x
ELH2l47+IIO9TUowggVGMIIELqADAgECAhEAyiICIp1F+xAAAAAATDn2WDANBgkqhkiG9w0B
AQsFADCBpTELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsT
MHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5jb3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0G
A1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5jLjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAy
IENsaWVudCBDQTAeFw0yMDEyMTQyMDQzMDlaFw0yMzEyMTUyMTEzMDhaMIGTMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEmMCQGA1UEChMd
Tm9ydGhXZXN0IFJlc2VhcmNoIEFzc29jaWF0ZXMxNTAWBgNVBAMTD09yaW9uIFBvcGxhd3Nr
aTAbBgkqhkiG9w0BCQEWDm9yaW9uQG53cmEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxBJrIv9eGtrQLaU9pIGsIGBTiW0vZIYmz+5Eoa69sj6t6QANvg0IuVgWZajH
2fu8R+7m/AbZ8Wsuzz+ovtDHiVqUGvGzYyN9a5Ssx94SwNp9zLPfdCRMdh3zJB7gc4GYE/fA
kMkieO8u05f/hSyf9zU5gpjl7SW6p8IjkoyxNOr7KCbI4CQ3+1LG8pn6tz/QJwQ/BJZa4dE0
asXfNlZf5kZtyWtJhwub76zH5uXeODDxY3RooWj1l4V2fQCoFX2ov1ENUW4hRov1cMAD2QHJ
KL0Boir36wISvzq8Z65MSMCGNRiWwRaclVwVZ+QYnlhGZ0g6tMvxVrK+sHnxxr/LOwIDAQAB
o4IBfzCCAXswDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
BDBCBgNVHSAEOzA5MDcGC2CGSAGG+mwKAQQCMCgwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cu
ZW50cnVzdC5uZXQvcnBhMGoGCCsGAQUFBwEBBF4wXDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3AuZW50cnVzdC5uZXQwNQYIKwYBBQUHMAKGKWh0dHA6Ly9haWEuZW50cnVzdC5uZXQvMjA0
OGNsYXNzMnNoYTIuY2VyMDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwuZW50cnVzdC5u
ZXQvY2xhc3MyY2EuY3JsMBkGA1UdEQQSMBCBDm9yaW9uQG53cmEuY29tMB8GA1UdIwQYMBaA
FAmRpbrp8i4qdd/Nfv53yvLea5skMB0GA1UdDgQWBBSpChQTknhqMfb9Exia9G14q4j9ZzAJ
BgNVHRMEAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQA15stihwBRGI8nFvZZalsmOHR954D+vrOZ
7cC0kl9K+S9u8j/E5nZd+A6PTKoDpAEYmPUYpe45tZLblnvfJC0yovSIIMTo1z3mRzldHYAt
ttjShH+M6s3xrqDtHfNAwt3TCf6H83sEpBi6wtbALfkIjKuDitgkdZsyUURoeglaaqVRhi2L
5wOOChQAyfsumjT1Gzk9qRtiv8aXzWiLeVKhzRO7a6o0jSdg1skyYKx3SPbIU4po/aT2Ph7V
niN0oqJHI11Fg6BfAey12aj5Uy96ztotiZRQuhWZPOc4d3df2N8RsdWViBp4jXt2hQjNr0Kw
pUPWRO/PENBVS1Uo1oXfMYIEYjCCBF4CAQEwgbswgaUxCzAJBgNVBAYTAlVTMRYwFAYDVQQK
Ew1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BTIGlzIGluY29y
cG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1c3QsIEluYy4x
IjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7EAAAAABMOfZY
MA0GCWCGSAFlAwQCAQUAoIICdzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjA1MTAxNjM4MjRaMC8GCSqGSIb3DQEJBDEiBCB1jR1rnUtRT47f66I0yTtW
ldXNLdvyPrr2V/1mtlvAhjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIHMA0GCCqGSIb3DQMCAgEoMIHMBgkrBgEEAYI3EAQxgb4wgbswgaUxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BT
IGlzIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1
c3QsIEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7
EAAAAABMOfZYMIHOBgsqhkiG9w0BCRACCzGBvqCBuzCBpTELMAkGA1UEBhMCVVMxFjAUBgNV
BAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsTMHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5j
b3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0GA1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5j
LjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAyIENsaWVudCBDQQIRAMoiAiKdRfsQAAAAAEw5
9lgwDQYJKoZIhvcNAQEBBQAEggEAVxdZxDobxu8y1NCHg52zkz2EY9iP20NhHIGZcoVzzoLL
ju7VHb0acohMs0ESS3xFdYiWRzGBaYwRC/QoHdfXMyBTIypskqgkpiRR9MYx/Tk67nJVlS6P
/DbYAa81LyIi6GwRnkVFKmaB6wcLuDHEmyST9WcByGPL70raKgFE1ieFS35hh87ynhBhWLhl
ZB6Sl4IciFhrkXj0lSf3x9kA/Ci2xmO2CyWxi/PqAqaFsj5GQoe9C3ShfuUGXpvj8LgfEDbP
+OnDGw4ifb8AFMdEWVqM0NtF89UxaBQRd3HrfZuR2s77HE+2a//V0Y4+Va+If9zpwWI6BnLx
i2ECT/CCrQAAAAAAAA==

--------------ms040107000503000603030402--
