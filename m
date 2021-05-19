Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13356C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 17:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA439610CC
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 17:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242729AbhESRK5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 13:10:57 -0400
Received: from sonic309-24.consmr.mail.gq1.yahoo.com ([98.137.65.150]:45287
        "EHLO sonic309-24.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240245AbhESRK5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 13:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621444177; bh=09L3Z/2/6WXFF4fpIQ27BmMVCn2VRCevtGB+u5wkxU4=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=s9q0oS//c08J05yX9AEiWgbjUgfzOmijzdRyotzBgGAbzEz67pkKUTLa+9Brm/zia4Xp1BaUem/ig3i2eHGKK6+oGPnSSVnx7Px8Dn1nMdpNKVtn8uatc3XORK4AiYEPR7Y0mW0+dj4I3+MUl7qMik9LM8A0biDjHKbk+1ZTUbs=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621444177; bh=+eCeu+tRNpe3rQUxSlD2mdLSJVxa6gqhs+ixH2TKpFZ=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=VWjcLwqfhfrY2pwu0V2UHNLq+Y5q1yCBMcYIHx3oCbVkqfOUjZB3hVMQQ0AkwdvdpouRA32N4JzIwijjPBk9niK97n5SXgiLbB2MbYBCT5EZcPBxOLRJ3vMtSx3L8nNEqACnE73maDmo4PTavKGrq61vT9TM+cYEpdlECRuCsjHWK4lKKMZ2vCL+Uih4QVYH8uTMthxL0gjdlE50eDJxk6CkH2n8/WmyCqGq+2FODY8GZhyMohGGQlJqIGyKFXso2AK6gsnN6sCU0hd0KbN3s0BLgP8P5n2cuw2yTvh75r2fSMq+F1sVI3uu8jM02kTVudeQC7Rcwo/IU7CnhJMnrg==
X-YMail-OSG: r7WgLukVM1kmgQB3G9yChhVGnMAu6NCUI0gUAvRrFQfE5rwT.DHkxpBfldrUDVN
 0EhwcWrGxO17u3N9UaifMNoryEWtmNQShJj4FUrcjoGOve2tjKCcZ3jyNjl9DXUZMIdxchLiAqoE
 Si8haespPM_wU7DePv4gTEAFTNfbpMA5LXdnxLUeDiMQtua162.f0wDH4PMV0VxumJBOMqf2IP79
 vmUopUuly2QzPF3hXVJJrQ7mPSJqcVtGRHb5msAqpHHVyUs0NgVdh8hYguBRr9CFcFRIpFMqIiW_
 6sFB1_6N7J7tEpjq5u1gXft6UE1TPMnUi8SMnRC5oj47aGUGNR9uYVZgv9uv67Ic2S8okR6W9.B2
 YtswDIRY4pUKCCPo0By_njbx3g_LJhOra5w8JZqvGtdI2tGIKMiqBi12x60M5qn3UGi8VMQNdPjJ
 pUj7JtO66F6mCozsxEgJ2nA0Bxffq1O8bchRBTBWeJf16saj.Xe1SgX5VJArKhUsD7DFkRDJrgbD
 EMRUlR35jaH0wFQOZl_77kqAvwoEX6zu44dGl3_demYtq9Ach5hEfMHUt22mO.a307O6d_HIOCqO
 JMk21SxIYQNk7QEdKZQqbiWbdbAaWj99YaE8VGfBMtoc0owXBRuDtRkbcfuFJxY0Labh0vSr8tUQ
 .rpz91amqIMGPYeUh_Ypu2pJtDwWnansG1MO5fwDdgq1b6s6uy6UK5Q03PPOdhe0W20YZkPmFCG8
 lu4R8Dw7nmTbSTtbAHbvStZ6hDg7nhlI0Rte7D3wocj7f5KcH2p3j9LJBF6InrT6ST9W7ro0xlRS
 R8fPcoQw1._8lqnbp_vN_KBLwVb1R4s3_FXwehmZb20Qx6aXwrlrpzL7FqnKJOjFJWZHprPUsH1u
 GRvOF2RBXRGPT3guNoedbiY4iaMYttKaRnNl0M37hzE6Gepd06xIJMrnt9lMyPpOr6Y8yW3MSa0W
 2Lzxe0JYXFhOuiy65SLX5J7bBI61xgzFzSuyrfNh41Lba0EKNUJI9bSfr8gqKhio1dPkKDeCkpr0
 1CirwT3EoQBTz0gXC5I2V0lvQv_pKqCfwu8FtT62CASn8eoQwlqMD3MdifCV57swGSDu1RJQVEcZ
 VehEi4mtWeVBGd1Y3pcVZgPsXUzof3Zd4zMlenbh0Y6RBrV5U44YhOtQgiC_2DKGHe.o8Na.OTHl
 NF60NvpbfZm1KfsAzMTATuP6IcFqenrmaZjTJNtdXEvYPELJjXLyKQFRHBllGRo98CQLmRDYAJ1q
 xnGBC_LXla1_qovutZDZw7RE7oam5GJYxRnh5K556A2EIfY0JRxjWSCZS8owP6xiWhOLDdEkR_3o
 INIq2wbIfeHRQ9_9d9fH9XlQEoVTC3pW_WgrCOcX.FupkBrKLqXnX0IyUG9B5HkYMZmOpZ_Zhttd
 vrImYNQVHBzFzpNEOUDRs8zOy9hTZ0cQHniDLazuh4JQG6R_6FHEgL7Ulc3Y2sF4ND8QU3fxmHwu
 Wb0T2NP0WfZPOSEbG8qPKTfKE4yzBBiwPSeWJGHDeuvRPr9XGHgaoL8Lo2nchmILrai3R1kxYLtj
 nsHqXwLg_UbqTQ7cNk49DJBqVxEThGY2D2ZnNFV.FB8tEbNdbcMgJX.klreOC3k94wCc5eGwZ_HE
 mpjVau1znuPx1lOoqmZJCGJSpZQC0FC_V3tJ4ruPQi9J6jabsWVGh7Gc7X2SQWQ8YletgOXh_Umt
 5AUvntxlM8sFCuawzEROUiLKlPoVK.Kv5wCEyXRyOeZOxD6WP27B10pGiqAkNYQLTEwrfnXgV8eg
 UI6O1h8vHVzAjEHVBEdxpPjt3Wtc7hb1SHLh789g0meGLqjkFPQvlpZ.673wEKDLfcz92LOsgpvR
 SaKAjho1W5TZWea7znmmiwAmQshme_0B5bB41edho7s71qzsI3d1ZU1F42pfKLOmP2o2SrHg2QiL
 cyLgq5tPZnNTaXEn2MmJrjnOo_CEa9EpbyhH05Cy1SSr2rHZRtReuX6Gk3jq0gWwnBGsVoDot_0d
 mkYyrKuVpBPZ50lC4YFWVTVCgn7ehOkJ7j9ZINUw_RqfG6I9ksGVqzP5qQa1kMcE.pLgOKgPEp.H
 m3LcUuqEcjvOcQ25HN6izQ8Q7.7xi38DFk9gKZ9s2aZhFy5t3qDVlYtMJWTvPqVh6Y1Mu1UMuO.1
 6gMHogj4lzF_ape.R6Le_CD8V4FquoKeSbcNE83xDv9Y4.yObuHxfzKoleVCg4a4JXfSvIdgkfCU
 .aii.ReqkQpHYv_iZdXB1GCX9TmOKzJZ46.NyGbMn4CczEBcQreKW5yet87WJP_XuFkQAryYGfjq
 ydSYFRf7sviHbaCGCTTT9fSFHWxDIUWQqsBI4wfmfglRYyPahY3.3514cFKOVytppGV3rmO1M0E9
 mweAZ1e0yEj.H16yjRXSyynQSFsQt_s5IafdeAtN2UybPKLYkHDZ99aS98IgmYg7p589SEed5ImW
 03oyb.0j_PA2uXw--
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.gq1.yahoo.com with HTTP; Wed, 19 May 2021 17:09:37 +0000
Received: by kubenode512.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID f3f230d30f2e1c5aa74c748545a1b4c8;
          Wed, 19 May 2021 17:09:32 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     antlists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
 <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
Date:   Wed, 19 May 2021 12:08:48 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/19/2021 11:41 AM, antlists wrote:
> On 19/05/2021 15:48, Leslie Rhorer wrote:
> 
> Because defaults change?

	Oh, I also don't necessarily know which build of mdadm he is using. 
They might be default on my build but not his.

>>      Now try running a check on the assembled array:
>> fsck /dev/md99
>>
>>      If that fails, shutdown the array with
>>
>> mdadm -S /dev/md99
>>
>>      and then try creating the array with a different drive order. 
>> There are only two other possible permutations of three disks.  If 
>> none of those work, you have some more serious problems.
> 
> And here you are oversimplifying the problem immensely. If those three 
> drives aren't the originals

	Hang on.  Which drives do you mean?
