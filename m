Return-Path: <SRS0=HOAI=D5=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC13C388F2
	for <linux-raid@archiver.kernel.org>; Thu, 22 Oct 2020 12:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B64223BF
	for <linux-raid@archiver.kernel.org>; Thu, 22 Oct 2020 12:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=creamfinance.com header.i=@creamfinance.com header.b="iehxVNA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898276AbgJVMjL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Oct 2020 08:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2898421AbgJVMiw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Oct 2020 08:38:52 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1DEC0613CF
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 05:38:52 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 13so1913554wmf.0
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 05:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=creamfinance.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YyjpZBF+3OEsHilfw+vUwETlg8dwHruXX8KJoDSqWSA=;
        b=iehxVNA9YrR9pqhVsUIvhmgqsA9Bx1dT6KQv9ChCIBQj8h7qlxNaGaAOTHvfPpfJxd
         4dEC+KjT0+z6ItTDzou+7lkejHe+poFSxRflGQ991BMCJFEsRM+HdJFdMgziMPkByH9r
         454iV+S/KtLtgUwjmZn6etSCXRMjoObYCZb9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YyjpZBF+3OEsHilfw+vUwETlg8dwHruXX8KJoDSqWSA=;
        b=afZl1ZMXXzC5gCxo4SV19JQvKr1Js3IlShVC4zLC/KzMRVYcIA1Xcm2NKL3S/zIGzN
         KkI2/TVbaxijlPhwpg48zigqze24lH6LDrNS2qZy3LseGhvXkw8U4pFIlVx1bwejEEvn
         o35U9VchK9ciR0oW6wOYbNkiU3ooOj4ke9UKUn0FjoPQ8cHPh5/C0+Uky3CFmnNm08tb
         SwqdQaEX0NCaIbQasv2Ixrux0EmNwX8boOJf3dneLOfIHM6gJPAbJgq7OlJcavsistFj
         xnsegsN75da+3YlS1kjBqRU2xY1lxN2h35W4YsdQDH+YmJf1mjojJ4/xqwW7/t1859My
         9pdw==
X-Gm-Message-State: AOAM5316zu/qG+AsQ7yBsAxoO6FOI0361qFNKxrc/hdvxvmmDzyqqnzN
        u6Z3VerpkykzGvB4bIlGfHb2HFlCMZm4ONs=
X-Google-Smtp-Source: ABdhPJzR2lwD7TH2lMWWlfyjfAFwFz+6B3WkRMaCoAQjgHHjOk6gB2fJCaV2+z+CqzhuGQtoPsC3+w==
X-Received: by 2002:a7b:c1d6:: with SMTP id a22mr1871689wmj.161.1603370330626;
        Thu, 22 Oct 2020 05:38:50 -0700 (PDT)
Received: from [10.8.100.4] (ip-185.208.132.9.cf-it.at. [185.208.132.9])
        by smtp.gmail.com with ESMTPSA id 4sm3754612wrp.58.2020.10.22.05.38.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 05:38:50 -0700 (PDT)
From:   "Thomas Rosenstein" <thomas.rosenstein@creamfinance.com>
To:     "Jack Wang" <jack.wang.usish@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: mdraid: raid1 and iscsi-multipath devices - never faults but
 should!
Date:   Thu, 22 Oct 2020 14:38:46 +0200
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <263E5644-41C7-4029-A47E-0328483F0941@creamfinance.com>
In-Reply-To: <CA+res+SvZWmCuWdcQA95WPG4wi3kChLmzAH2jKXW3TK5pL=WQg@mail.gmail.com>
References: <ED0868EE-9B90-4CE6-A722-57E0486A71FF@creamfinance.com>
 <CA+res+SvZWmCuWdcQA95WPG4wi3kChLmzAH2jKXW3TK5pL=WQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 22 Oct 2020, at 13:44, Jack Wang wrote:

> Thomas Rosenstein <thomas.rosenstein@creamfinance.com> 
> 于2020年10月22日周四 下午12:28写道：
>>
>> Hello,
>>
>> I'm trying todo something interesting, the structure looks like this:
>>
>> xfs
>> - mdraid
>>    - multipath (with no_path_queue = fail)
>>      - iscsi path 1
>>      - iscsi path 2
>>    - multipath (with no_path_queue = fail)
>>      - iscsi path 1
>>      - iscsi path 2
>>
>> During normal operation everything looks good, once a path fails 
>> (i.e.
>> iscsi target is removed), the array goes to degraded, if the path 
>> comes
>> back nothing happens.
>>
>> Q1) Can I enable auto recovery for failed devices?
>>
>> If the device is readded manually (or by software) everything resyncs
>> and it works again. As all should be.
>>
>> If BOTH devices fail at the same time (worst case scenario) it gets
>> wonky. I would expect a total hang (as with iscsi, and multipath
>> queue_no_path)
>>
>> 1) XFS reports Input/Output error
>> 2) dmesg has logs like:
>>
>> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical 
>> block
>> 41472, async page read
>> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical 
>> block
>> 41473, async page read
>> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical 
>> block
>> 41474, async page read
>> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical 
>> block
>> 41475, async page read
>> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical 
>> block
>> 41476, async page read
>> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical 
>> block
>> 41477, async page read
>> [Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical 
>> block
>> 41478, async page read
>>
>> 3) mdadm --detail /dev/md127 shows:
>>
>> /dev/md127:
>>             Version : 1.2
>>       Creation Time : Wed Oct 21 17:25:22 2020
>>          Raid Level : raid1
>>          Array Size : 96640 (94.38 MiB 98.96 MB)
>>       Used Dev Size : 96640 (94.38 MiB 98.96 MB)
>>        Raid Devices : 2
>>       Total Devices : 2
>>         Persistence : Superblock is persistent
>>
>>         Update Time : Thu Oct 22 09:23:35 2020
>>               State : clean, degraded
>>      Active Devices : 1
>>     Working Devices : 1
>>      Failed Devices : 1
>>       Spare Devices : 0
>>
>> Consistency Policy : resync
>>
>>                Name : v-b08c6663-7296-4c66-9faf-ac687
>>                UUID : cc282a5c:59a499b3:682f5e6f:36f9c490
>>              Events : 122
>>
>>      Number   Major   Minor   RaidDevice State
>>         0     253        2        0      active sync   /dev/dm-2
>>         -       0        0        1      removed
>>
>>         1     253        3        -      faulty   /dev/dm-
>>
>> 4) I can read from /dev/md127, but only however much is in the buffer
>> (see above dmesg logs)
>>
>>
>> In my opinion this should happen, or at least should be configurable.
>> I expect:
>> 1) XFS hangs indefinitly (like multipath queue_no_path)
>> 2) mdadm shows FAULTED as State
>
>>
>> Q2) Can this be configured in any way?
> you can enable the last device to fail
> 9a567843f7ce ("md: allow last device to be forcibly removed from 
> RAID1/RAID10.")

That did work, last device moved into faulted. Is there a way to recover 
from that? or is the array completely broken at that point?
I tried to re-add the first device after it's back up, but that leads to 
a Recovery / Synchronize Loop

btw. kernel 5.4.60

>>
>> After BOTH paths are recovered, nothing works anymore, and the raid
>> doesn't recover automatically.
>> Only a complete unmount and stop followed by an assemble and mount 
>> makes
>> the raid function again.
>>
>> Q3) Is that expected behavior?
>>
>> Thanks
>> Thomas Rosenstein
