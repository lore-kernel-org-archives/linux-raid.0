Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09DBC4167B
	for <linux-raid@archiver.kernel.org>; Thu,  2 Nov 2023 23:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjKBXX3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Nov 2023 19:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjKBXX2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Nov 2023 19:23:28 -0400
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA080DB
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 16:23:25 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SM0L41KqSz9Qpt
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 10:23:24 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SM0L36KV4z9QWj
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 10:23:23 +1100 (AEDT)
Message-ID: <bd60ac9f-7acd-494e-bfb6-b146a5add0d9@eyal.emu.id.au>
Date:   Fri, 3 Nov 2023 10:23:19 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: problem with recovered array
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
 <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au>
 <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
 <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au>
 <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
 <ZUNfK1jqBNsm97Q-@vault.lan>
 <22339749-c498-459e-9dbe-c12859be0580@eyal.emu.id.au>
 <CAAMCDecMvSN9KnNhu3QyRQah016uJhg_vXtjO90WECBCMr8W9w@mail.gmail.com>
 <1b453db1-b260-4e0b-978e-f15928d10151@eyal.emu.id.au>
 <CAAMCDec1acjdpVx0qPqQWhDCpAVmMQP-g8tMGc4-iXPbNZV6kg@mail.gmail.com>
From:   eyal@eyal.emu.id.au
In-Reply-To: <CAAMCDec1acjdpVx0qPqQWhDCpAVmMQP-g8tMGc4-iXPbNZV6kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 03/11/2023 04.05, Roger Heflin wrote:
> You need to add the -x for extended stats on iostat.  That will catch
> if one of the disks has difficulty recovering bad blocks and is being
> super slow.
> 
> And that super slow will come and go based on if you are touching the
> bad blocks.

I did not know about '-x'. I see that the total columns (kB_read, kB_wrtn) are not included:-(

Here is one.

Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
md127            1.88    116.72     0.00   0.00   11.27    62.19    6.31   1523.93     0.00   0.00  218.42   241.61    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    1.40   1.72
sdb              0.67     67.42    16.17  96.02   11.61   100.68    3.74    367.79    89.35  95.98    7.65    98.33    0.00      0.00     0.00   0.00    0.00     0.00    2.02    6.25    0.05   1.92
sdc              0.81     89.74    21.61  96.39   15.30   110.94    3.74    367.58    89.29  95.98    7.70    98.20    0.00      0.00     0.00   0.00    0.00     0.00    2.02    5.15    0.05   1.73
sdd              0.87    102.17    24.66  96.59   16.75   117.28    3.73    367.34    89.24  95.99   15.00    98.45    0.00      0.00     0.00   0.00    0.00     0.00    2.02    3.28    0.08   3.92
sde              0.87    101.87    24.58  96.56   19.38   116.46    3.72    367.45    89.28  96.00   16.20    98.71    0.00      0.00     0.00   0.00    0.00     0.00    2.02    3.30    0.08   3.94
sdf              0.81     90.11    21.70  96.39   16.24   110.80    3.73    367.15    89.20  95.99   14.19    98.51    0.00      0.00     0.00   0.00    0.00     0.00    2.02    3.17    0.07   3.91
sdg              0.68     67.91    16.28  95.97   12.17    99.30    3.73    367.20    89.21  95.98   13.28    98.32    0.00      0.00     0.00   0.00    0.00     0.00    2.02    3.10    0.06   3.86

Interesting to see that sd[bc] have lower w_await,aqu-sz and %util and higher f_await.
Even not yet understanding what these mean, I see that sd[bc] are model ST12000NM001G (recently replaced) while the rest are the original ST12000NM0007 (now 5yo).
I expect this shows different tuning in the device fw.

I do not expect this to be relevant to the current situation.

I need to understand the r vs w also. I see wkB/s identical for all members, rkB/s is not.
I expected this to be similar, but maybe md reads different disks at different times to make up for the missing one?

Still, thanks for your help.

> On Thu, Nov 2, 2023 at 8:06 AM <eyal@eyal.emu.id.au> wrote:

[discussion trimmed]

-- 
Eyal at Home (eyal@eyal.emu.id.au)
