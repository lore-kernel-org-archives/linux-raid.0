Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD51AC7EE2F
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 02:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjE3CoJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 22:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjE3CoI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 22:44:08 -0400
Received: from out-48.mta0.migadu.com (out-48.mta0.migadu.com [IPv6:2001:41d0:1004:224b::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7603118D
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 19:43:43 -0700 (PDT)
Message-ID: <3502c511-01de-cb05-6cc3-6096d51278ca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685414621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eHBbBelZEmCkUiOJhdDfRl5MgFzUvF5emefHlpJRyZ4=;
        b=W8jN5ze7gjzof5IE9Ca9Cvb8MfNxoeZZyTs3sHBWEgwvmNb9vWjVNTFAztSN9l9K5X41rb
        y0TiET0Iw3TsC0D/6434ghGTRs/3D3mNTLCzc5nUhsbtnf00WYEZ7hELnEZzSwIfEp9ezQ
        h08zYjuUiTD8WoV8ykKjUu7IBEw53aQ=
Date:   Tue, 30 May 2023 10:43:35 +0800
MIME-Version: 1.0
Subject: Re: The read data is wrong from raid5 when recovery happens
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
 <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
 <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
 <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
 <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev>
 <CALTww2_vmryrM1V+Cr8FKj3TRv0qEGjYNzv6nStj=LnM8QKSuw@mail.gmail.com>
 <73b79a2d-95fe-dac0-9afc-8937d723ffdf@linux.dev>
 <495541d3-3165-6d4b-f662-3690139229e9@huaweicloud.com>
 <CALTww2_wphLSHV6RAOO05gs0QO8H9di-s_yJRm0b=D7JmjjbUg@mail.gmail.com>
 <d3e3ccdf-3384-b302-7266-8996edee4ca8@linux.dev>
 <CALTww2_7PFmmCk1bGMco3a1cMJTxJtUiOs-i764qp0vnQRZJkw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CALTww2_7PFmmCk1bGMco3a1cMJTxJtUiOs-i764qp0vnQRZJkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/30/23 10:30, Xiao Ni wrote:
> On Tue, May 30, 2023 at 10:23 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>> On 5/30/23 10:11, Xiao Ni wrote:
>>>> May I ask if these processes write the same file with same offset? It's
>>>> insane if they do... If not, this cound be a problem.
>>> They write to different files. One process writes to its own file.
>> How big is the capacity of your array? I see the script write 100G file
>> first, then create
>> different files with 3GB size. So you probably need a array with 200G array.
>>
>> ./01-test.sh:dd if=/dev/zero of=/tmp/pythontest/file1bs=1M count=100000
>> status=progress
>>
>> Thanks,
>> Guoqing
>>
>>
> I used ssd disks and without --size. So the raid is almost 1TB

I can't reproduce it after disable write 100G file1 and decrease 
FILE_SIZE to 30
to fit my array, and iostats is on, just FYI.

localhost:~/readdata #cat /sys/block/md126/queue/iostats
1
localhost:~/readdata #./01-test.sh
mdadm: stopped /dev/md126
umount: /dev/md126: no mount point specified.
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md126 started.
mke2fs 1.43.8 (1-Jan-2018)
/dev/md126 contains a ext4 file system
        last mounted on /tmp/pythontest on Mon May 29 22:21:18 2023
Creating filesystem with 784896 4k blocks and 196224 inodes
Filesystem UUID: 2eb67cc5-67d0-432e-9b66-d3bc3c472d93
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

Mount point already exists: /tmp/pythontest
Clearing mount point!
mdadm: set sdd faulty in md126
mdadm: hot removed sdd from md126
5.15.0-rc4-59.24-default
Mon May 29 22:31:27 EDT 2023
dd start at : Mon May 29 22:31:27 EDT 2023
Mon May 29 22:31:27 EDT 2023
dd ended at : Mon May 29 22:31:27 EDT 2023
mdadm: added /dev/sdd
Mon May 29 22:31:30 EDT 2023
stresstest start  at : Mon May 29 22:31:30 EDT 2023
Test started!
start
[...]
start
Rebuild ended, testing done!
stresstest end at : Mon May 29 22:32:30 EDT 2023
Mon May 29 22:32:30 EDT 2023


Thanks,
Guoqing
