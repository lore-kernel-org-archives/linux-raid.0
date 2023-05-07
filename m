Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAF3C77B7D
	for <linux-raid@archiver.kernel.org>; Sun,  7 May 2023 16:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjEGQsC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 7 May 2023 12:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEGQsC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 7 May 2023 12:48:02 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFB13C1B
        for <linux-raid@vger.kernel.org>; Sun,  7 May 2023 09:47:59 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7606d460da7so84309939f.1
        for <linux-raid@vger.kernel.org>; Sun, 07 May 2023 09:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1683478079; x=1686070079;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cHE2BVoHUJ30gnMOLIBELK7LDKl0GFyuXpCO3ocMVnk=;
        b=Ax+gtdouoVW6MfoV4m5hDv2NjTU2jCMjKf7jBRsWtrAfMVEobewy/l94HFoWSNpuku
         0LB7DKb4xxL7sMZ2t192mlg5QLW4vnaThwv6HmojTjV+ifKDXfUOU2Izkii/nB1zPoBv
         tTGJPyLX4zHZLylzDs4DLY41XwxphO7ruVKqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683478079; x=1686070079;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cHE2BVoHUJ30gnMOLIBELK7LDKl0GFyuXpCO3ocMVnk=;
        b=b7DDo626JVp9Yc1/k9FcEJXJ4U+kYhmD9PL+PCeso2rJg6WnaNVA2nJo/+FOAk4NnC
         U+jWn0JwzIaj6qGPwJiPmXTmUeKzBIN+X5qBJdhiZFNAPmCzyvHpgA5uF/u5YL13zYYt
         KYJh07eE9V2MCsZ8ZjcEguEKEMp2dvREkLuwgYFBh0H+4LUXpmfImWJi7bUIJIyW6DlF
         Qk0MI4vjN5dFfv5koluYe3yq/de4ofhWtTRMleB+2bsoXi89T9WxsD/kpMuKfn6vrczM
         KbN9WxCJ7c3ZvojQ1gnG+yforM6iFTh4lW+hLvOzaekeayiK9mbs4aISUnb601tfYix9
         PvmA==
X-Gm-Message-State: AC+VfDyaMUQbPsr5lmJF0I7tDRv95FLAlypZ+YhGVWqYf2XXQrIqtk3/
        brpVSzeJEdw9sxoU61x+JHIIcA==
X-Google-Smtp-Source: ACHHUZ5OYM3HRUtE9jdwWykxtHGRiP1uHECaPgIpe2T61Cl0BzQMIUz21aykqutMqxySr/aCMI/5rQ==
X-Received: by 2002:a6b:f214:0:b0:760:e9b6:e6da with SMTP id q20-20020a6bf214000000b00760e9b6e6damr5203774ioh.1.1683478079163;
        Sun, 07 May 2023 09:47:59 -0700 (PDT)
Received: from [10.211.55.3] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id i22-20020a5d8416000000b00746c717e922sm1623038ion.43.2023.05.07.09.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 09:47:58 -0700 (PDT)
Message-ID: <fc55e52f-f97c-03b1-04a2-c2c300f9550b@ieee.org>
Date:   Sun, 7 May 2023 11:47:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Second of 3 drives in RAID5 missing
To:     Wols Lists <antlists@youngman.org.uk>,
        Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org
References: <d11acbac-a31b-b38c-8e10-b664ec52a47b@ieee.org>
 <7605c54f-670a-a804-b238-627cd561ce52@suse.de>
 <0b5a2849-90ec-573c-03ed-0847135a4e9d@youngman.org.uk>
 <8f046b28-f187-66d8-f67c-3e5821f66e92@ieee.org>
 <b754545f-c505-71d9-6da0-2df8c607ae52@youngman.org.uk>
Content-Language: en-US
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <b754545f-c505-71d9-6da0-2df8c607ae52@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/7/23 2:35 AM, Wols Lists wrote:
>>
>> Is it an easy command?  Is any more information required?
>>
> mdadm array --add /dev/sdc1

I think I'm on my way back now.  Thank you very much.	-Alex

root@meat:/home/elder# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md127 : active raid5 sdc1[4] sdb1[0] sdd1[3]
       15627786240 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[3/2] [U_U]
       [>....................]  recovery =  1.2% (96275752/7813893120) 
finish=639.3min speed=201178K/sec
       bitmap: 0/59 pages [0KB], 65536KB chunk

unused devices: <none>
root@meat:/home/elder# mdadm --detail /dev/md127
/dev/md127:
            Version : 1.2
      Creation Time : Sun Oct 22 21:19:23 2017
         Raid Level : raid5
         Array Size : 15627786240 (14.55 TiB 16.00 TB)
      Used Dev Size : 7813893120 (7.28 TiB 8.00 TB)
       Raid Devices : 3
      Total Devices : 3
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Sun May  7 11:45:04 2023
              State : clean, degraded, recovering
     Active Devices : 2
    Working Devices : 3
     Failed Devices : 0
      Spare Devices : 1

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : bitmap

     Rebuild Status : 1% complete

               Name : meat:z  (local to host meat)
               UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
             Events : 9636

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        4       8       33        1      spare rebuilding   /dev/sdc1
        3       8       49        2      active sync   /dev/sdd1
root@meat:/home/elder#

