Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF95C7618A
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 23:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjCSX3o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 19:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCSX3n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 19:29:43 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795E513DE8
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 16:29:42 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-17ab3a48158so11464236fac.1
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 16:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679268582;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9HwpFzzi4r0hSHWqlWIpdJqozYBTmc2/t3ON56tm9/w=;
        b=NjJKA3CXJyvrGkuavMU3Dkb2MPFCvyCRqKI0W0oFB94tfGAoona9v76+Jvg8tpZzP/
         GzFeY1twlEH8CEM2hC2vPcSYjlmz/dAqQcdFYMION8VaRLrTzl+7uzoG3a/36gCRwNxo
         zeqCjvqh1NPBrWkofao8HO5jWWrDhxZ9kQONCLJH6AG4J3NExg55X8zv1eJoqT6LJ5Po
         5pmy22uR3Lh/Z++XAqsH8IPzwWwNs8vfVqMacVOai5SHOceuORp0hihD1MJ800QlKmhR
         y12hpB7MehXdrMtH4PqjkSVmXd2nd0YeOZx+pnIeBZBiypx0CQW5VRsiN1z+HjLs+Y1+
         RIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679268582;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9HwpFzzi4r0hSHWqlWIpdJqozYBTmc2/t3ON56tm9/w=;
        b=j2Ds03zA8ISR1gkA2hNG3e4L/OoglowzN3qEyZMHsyGXoUOC7t8M2GrpxN0HMerCx5
         aOBwKBn1FyEjJfrTbIhLJI7WB1ByspPh3tN7VJBigUtfzRpagwYXaSevRMjuY88t0Ukm
         xy/q2t9Lq0gU+/qXdqvb6/caq7dCKdva34kwORBpl2DrC8/bg85p/U7btYV40r55l9zo
         oYDO0I9mbjk25SOXc+6mV/a+GlQtEo8kxqnB4glTiJUuSB4nnO6UWtnErIlBiJ5jWnij
         E8cT+5ayKXk9nq1EmcPBrRdE3gU6hIy0k3wpGMSxs+SVp4JsQ1f0dHEoegTIKQvmw+94
         0RWg==
X-Gm-Message-State: AO0yUKUbYEV+11dNlSvwlSHJ9rNVzcQXJw9Ddq6lucV7bJTYLbWu6Gch
        MrpP0YyeG9lCo2M0fUY+52k8I7RSvWs=
X-Google-Smtp-Source: AK7set/d0/FP1AnKN7/3CvWsLTzoYb5TOv1ER4EdFyNhFYlqctMsKn/Frr7BaJ6vr4ue+mUQkGxAow==
X-Received: by 2002:a05:6870:c087:b0:172:289b:93c5 with SMTP id c7-20020a056870c08700b00172289b93c5mr2596457oad.0.1679268581703;
        Sun, 19 Mar 2023 16:29:41 -0700 (PDT)
Received: from [192.168.3.92] ([47.189.247.51])
        by smtp.gmail.com with ESMTPSA id p16-20020a9d76d0000000b0068bd922a244sm3417815otl.20.2023.03.19.16.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 16:29:41 -0700 (PDT)
Message-ID: <671da160-d5b3-8ed1-f7c1-672fa587ecad@gmail.com>
Date:   Sun, 19 Mar 2023 18:29:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Renaming md raid and moving md raid to a different machine.
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
 <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
 <7037738d-05e3-b277-61ed-37f66cfdef7e@youngman.org.uk>
From:   Ram Ramesh <rramesh2400@gmail.com>
In-Reply-To: <7037738d-05e3-b277-61ed-37f66cfdef7e@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/19/23 17:51, Wol wrote:
> On 19/03/2023 18:58, Ram Ramesh wrote:
>> Hi,
>>
>>    My primary DVR is old and I need to move it to more recent 
>> hardware. I have two md raids (a raid1 and another raid6) called 
>> /dev/md0 and /dev/md1. I plan to have root on the new machine on raid1 
>> and thus I like to rename my /dev/md0 to /dev/md1 in the old machine 
>> before I move it to the new machine. After that I want to move the 
>> disks in the most recommended way to minimize the chance of loss.
> 
> Do you have an mdadm.conf, or do the arrays auto-assemble without one?
I have mdadm.conf and each md is named in that file.

ARRAY /dev/md/1 metadata=1.2 name=zym:md1 
UUID=0e9f76b5:4a89171a:a930bccd:78749144
ARRAY /dev/md2  metadata=1.2 name=zym:2 
UUID=d4e30060:d6395b41:dde52d2e:35ffa6fd

>>
>>    Since the data is large and usually contains recordings and videos 
>> that have backup on Hulu/Ultraviolet, I worry less about backup. Still 
>> it will be big task to repopulate all my data from the source and 
>> therefore prefer not to do stupid things and loose the data.
>>
>>   Online search showed me a way to rename using just mdadm.conf and 
>> that did not work at all. In fact it messed up my raid6 that I had a 
>> panic for a short time. Luckily, I got everything back working 
>> normally. So, I am not sure which one of the online instructions to 
>> follow to rename my /dev/md0 to /dev/md1 before the move. So, I 
>> thought best to ask here.
> 
> Your raid shouldn't be named md0 (md1) at all. By default they now count 
> down from md127 (I think ...)
They are named md0, md1, md2 etc because I created them that way, I 
think. Once created, they are entered into mdadm.conf and they keep 
their name.

I usually image copy system disk from old machine to new machine to 
bootstrap the system. Thus mdadm.conf will go there. That is why I 
cannot have /dev/md0 in the old machine as that name is already taken in 
the new machine. Without image copy, it is difficult to get mythtv 
package to keep its database and recordings in order.
> 
> If you're going to give it a name, give it a name like "root", or 
> "data", or "home". But I've found that very tricky post-facto - it's 
> best done when the array is first created.
>>
>>    Also, once I renamed /dev/md0 to /dev/md1, I want to move all 6 
>> disks in raid6 to the new machine. What is the correct procedure so 
>> that after the movement, I will be able to reboot both the old machine 
>> without raid6 (ie /dev/md1)and the new machine with the moved disks as 
>> /dev/md1? Ideally, I like to teach my old machine to forget /dev/md1 
>> that I want to move and not touch the disks. If I do not do that, I am 
>> afraid my reboot (of the old machine) will get stuck at some point 
>> trying to look for the missing disks/md. All online tutorial talks 
>> about how to assemble on new machine. Does not talk about gracefully 
>> removing an md from an old machine. I want to know if there is any 
>> trick to this other than shutting down and pulling all disks and 
>> rebooting.
>>
>>    Old host runs debian bullseye (linux 5.19, mdadm v4.1) and new will 
>> run debian testing/bookworm (linux 6.1,  mdadm v4.2).  Let me know if 
>> you need anymore information.
> 
> Old host, new host ...
> 
> Sounds to me like the best way to move the raid would simply be to 
> transfer the disks across. The new system should just recognise the 
> array. If it doesn't you can just put the disks back in the old system.
> 
> What I would NOT do is put the old disks in the new system and then 
> build it. Make sure the new system is up and running before you move the 
> disks across. (There have been reports of 
> installers/updates/stuff-like-that not recognising raids and trashing 
> them.)
Ok, I will try this. I am more worried about old host not booting after 
I yank the disks and it does not find them to assemble md that 
mdadm.conf has. I am going to comment out the line for the md (and 
update-initramfs for a good measure) that I plan to transfer. This way, 
I should be safe.
>>
>> Thanks and Regards
>> Ramesh
>>
> https://raid.wiki.kernel.org/index.php/Linux_Raid

I thought I looked there first before searching online. I do not believe 
you have any section for renaming md device after its creation.

I also did not find any instructions on how to not assemble array upon 
reboot and leave the component disks untouched. This will make the 
transfer seamless.
> 
> Dunno where you looked on-line, but this is the best place. Any 
> improvements you think of, let me know.
> 
> Cheers,
> Wol

Thanks for taking interest in my situation. Just helping me to think 
differently itself is great help and I appreciate that help.

Regards
Ramesh

