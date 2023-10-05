Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EE2E92709
	for <linux-raid@archiver.kernel.org>; Thu,  5 Oct 2023 15:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjJEPOX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Oct 2023 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbjJEPNf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 Oct 2023 11:13:35 -0400
Received: from micaiah.parthemores.com (micaiah.parthemores.com [199.26.172.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12537B28A
        for <linux-raid@vger.kernel.org>; Thu,  5 Oct 2023 07:36:37 -0700 (PDT)
Received: from [10.21.1.136] (unknown [193.11.98.138])
        by micaiah.parthemores.com (Postfix) with ESMTPSA id 0BAA2300314;
        Thu,  5 Oct 2023 09:27:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parthemores.com;
        s=micaiah; t=1696490822;
        bh=DP7w7lHsnorhSlbBVBO12so5vcK/3NARMXHR89c6eV0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=YvhN69PshBAp1KTHCN3nDR8P2XIZqn+mU9AlBOf43ZNhchXgfmf7A8phvDX6aA9Df
         lVFsGKFvBFgPuiwM5rAqVnQ/5ApxImHF1lwjAh4mL/qNAxY3iYMYTkE9lO+j68nanY
         MkErnbwpNjuS1Pm+PG1Hr5TYOkp+gVciMeVhC7UI=
Message-ID: <37b90505-6bef-6bb8-5576-19b30017697b@parthemores.com>
Date:   Thu, 5 Oct 2023 09:28:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: request for help on IMSM-metadata RAID-5 array
Content-Language: en-GB
To:     Yu Kuai <yukuai1@huaweicloud.com>, Roman Mamedov <rm@romanrm.net>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
 <20230923162449.3ea0d586@nvm>
 <4095b51a-1038-2fd0-6503-64c0daa913d8@parthemores.com>
 <20230923203512.581fcd7d@nvm>
 <72388663-3997-a410-76f0-066dcd7d2a63@parthemores.com>
 <4d606b3d-ccec-e791-97ba-2cb5af0cc226@huaweicloud.com>
 <02a12a6d-eac4-51a1-e5ab-3df4d79bb87b@parthemores.com>
 <86dd0750-d060-eada-dc16-03a783c3bd1d@huaweicloud.com>
 <9c67d4b6-9b7d-467c-827a-729f62348d54@parthemores.com>
 <a0b8a693-5d9c-d354-5afc-4500b78a983e@huaweicloud.com>
From:   Joel Parthemore <joel@parthemores.com>
In-Reply-To: <a0b8a693-5d9c-d354-5afc-4500b78a983e@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Den 2023-10-05 kl. 04:50, skrev Yu Kuai:
> Hi,
>
> 在 2023/09/30 3:44, Joel Parthemore 写道:
>> Den 2023-09-26 kl. 03:10, skrev Yu Kuai:
>>
>>
>>>>> It'll be much helper for developers to collect kernel stack for 
>>>>> all stuck thread(and it'll be much better to use add2line).
>>>>
>>>>
>>>> Presuming I can re-create the problem, let me know what I should do 
>>>> to collect that information for you. I'm very much a newbie in that 
>>>> area.
>>>
>>> You can use following cmd:
>>>
>>> for pid in `ps -elf | grep " D " | awk '{print $4}'`; do ps $pid; 
>>> cat /proc/$pid/stack; done
>>>
>>> Thanks,
>>> Kuai
>>
>>
>> for pid in `ps -elf | grep " D " | awk '{print $4}'`; do ps $pid; cat 
>> /proc/$pid/stack; done
>>    PID TTY      STAT   TIME COMMAND
>>   4017 tty1     D+     0:00 e2fsck /dev/md126
>
> Do you check that this thread is hanged and the e2fsck doesn't make 
> progress?


I wasn't trying to run e2fsck at the time. Instead I had run mdadm 
--stop /dev/md126, which was hanging. (Sorry; looks like I forgot to 
include that!) mdadm -D /md126 showed no re-syncing happening at the time.

Unfortunately, I had not heard back from you, and I felt like I couldn't 
keep the problematic RAID array around any longer, so I wiped it and 
replaced it with a fully native-Linux RAID5 array instead of one using 
IMSM metadata.

Joel

