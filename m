Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73021C6FD1C
	for <linux-raid@archiver.kernel.org>; Wed, 22 Mar 2023 19:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjCVTCM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjCVTBy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Mar 2023 15:01:54 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC69613F
        for <linux-raid@vger.kernel.org>; Wed, 22 Mar 2023 12:00:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679511557; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Iuv0ypjQ3TNS1eSyDW/xSHWe+YO5+wtswBLzLCBj2ND8cyEZhsUwPdxduvYdMjOSG5EOMo+Z2p1Z6xF9yU2fGcCVWevqJU/NZNwKg9EEQx4QGgRq5127SYt9E/3Fz/est+PPh7s1KWqWffyBqJ7LsGNyYxWQW4jjsZoXjbtmm4k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1679511557; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Xc/Bt3M84/rPsQ3nkFHBQtKJH1nhnSQvDI/JcrBNhSQ=; 
        b=VORaP3eXi0VvfaeXQYKeb+F6l8CUOLHn7cxU5b/7Jj49s2hfteYhmT5bqd7nbaZaQX/qTSxyjDWTfQS/37S8WmAQWas3+gwBXvLrUFz/TJdZjfF4J5vn8xEA6gGyK6uLZomIopFYr72krMQrKIJ+EuRNa5rsZT4CM5UroCnkvt0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 167951155437318.63163592411729; Wed, 22 Mar 2023 19:59:14 +0100 (CET)
Message-ID: <a8009c66-6542-95d8-0064-8022d4043a7f@trained-monkey.org>
Date:   Wed, 22 Mar 2023 14:59:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: mdadm --detail works, mdadm --stop says "does not appear to be an
 md device"
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Marc MERLIN <marc@merlins.org>
Cc:     linux-raid@vger.kernel.org
References: <20230317173810.GW4049235@merlins.org>
 <20230320153639.0000238d@linux.intel.com>
 <20230320145035.GW21713@merlins.org>
 <20230320161659.00001c48@linux.intel.com>
 <20230321020101.GC4049235@merlins.org>
 <20230322081126.0000066d@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230322081126.0000066d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/22/23 03:11, Mariusz Tkaczyk wrote:
> On Mon, 20 Mar 2023 19:01:01 -0700
> Marc MERLIN <marc@merlins.org> wrote:
> 
>> On Mon, Mar 20, 2023 at 04:16:59PM +0100, Mariusz Tkaczyk wrote:
>>> On Mon, 20 Mar 2023 07:50:35 -0700
>>> Marc MERLIN <marc@merlins.org> wrote:
>>>   
>>>> On Mon, Mar 20, 2023 at 03:36:39PM +0100, Mariusz Tkaczyk wrote:  
>>>>> Hi,
>>>>> mdadm is unable to complete this task because it cannot ensure that it
>>>>> is safe to stop the array. It cannot open the array with O_EXCL.
>>>>> If it is mounted then it may hang if filesystem needs to flush some
>>>>> data.    
>>>>  
>>>> Thanks for the reply. The array was not mounted, that said, given that
>>>> it was fully down, there wasn't a way to flush the data if it had been
>>>> (cable problem to an enclosure, all the drives disappeared at once)
>>>>   
>>>>> Please, try umount the array if it mounted somewhere and then try:
>>>>>
>>>>> # echo inactive > /sys/block/md6/md/array_state
>>>>> # echo clear > /sys/block/md6/md/array_state    
>>>>
>>>> I can try this next time (already had to reboot), thanks.
>>>>
>>>> That said, mdadm should output a better message in this case  
>>>>>> mdadm: /dev/md6 does not appear to be an md device    
>>>> is clearly wrong 
>>>>
>>>> Is that something easy to fix/improve?  
>>>
>>> Oh, sorry my bad, please see the code:
>>> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/mdopen.c#n472
>>>
>>> We are failing to "understand" the array:
>>> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/util.c#n229
>>> It has nothing to do with open and O_EXCL. I didn't dig into to determine
>>> why.
>>>
>>> Anyway, now error seems to be reasonable but maybe we should be able to
>>> tract this array as valid? I requires more work and analysis so it is not
>>> simple fix.  
>>
>> You are definitely more knowledgeable about this than I am.
>> All I can say is that the array was down, not mounted, and I couldn't
>> stop it without a reboot, and that's a problem.
>>
>> Any way to force stop in a case like this, would be quite welcome :)
>>
>> Thanks,
>> Marc
> 
> Jes, how you see this?

If we can force stop it with a big fat warning, then I think that would
be a good feature to add. The must reboot requirement is not exactly ideal.

Cheers,
Jes


