Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE49C07E95
	for <linux-raid@archiver.kernel.org>; Wed,  7 Jul 2021 11:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F90761182
	for <linux-raid@archiver.kernel.org>; Wed,  7 Jul 2021 11:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhGGLLI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Jul 2021 07:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhGGLLH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Jul 2021 07:11:07 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1790C061574
        for <linux-raid@vger.kernel.org>; Wed,  7 Jul 2021 04:08:26 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l7so1647423wrv.7
        for <linux-raid@vger.kernel.org>; Wed, 07 Jul 2021 04:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vf/OiVDqV9fSwvcgQfeHQlNPp4xiLuOzoFiZkf5l1EE=;
        b=UxkSy8X7wKWW75hBwy8z2nOTDzPrhwpDaD4JSM56evo2wLCuVW3zGC7lO2MwPNKZIu
         pt7RgnQQddWUCLYDyEcQ3S5sqb/OPQIW7oqIw0IJDys34ZAs0+nYnzvZPn8cVDJjWedJ
         /A4NYe4nVRyJVWZVmUZFPB09tlfIJ4VSpq7yy1Bi6X5BLbOKkPGt3cbeDGE1+EoFdYs/
         XEYUHg2Xs6u02rPSzmrcM6S9Vm1qpC3RMqY7/xtMJo0g58jrvGO5rJ1zDbwZ25C4fXx8
         ZB2xxrz+15A0JmBbVaDGY8UbSIW010W+v5lX03sK6Y2FAfRKhpT55GWTxuuOCLJscph6
         oaMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vf/OiVDqV9fSwvcgQfeHQlNPp4xiLuOzoFiZkf5l1EE=;
        b=mgmc6ix1Wuol0Ac3lAsXgqqdgbVg4ej2WaFnfIRF3GTW45rgqce/ww4+Z30IyPzJov
         TGf18gVKsqOOGuvAnAcPlmjpznqekGBOuzpLYjyUkLuwoa7Bvg7zuFv15KevLpSSPQlx
         QbjULDncPqc3YkKStNYOxValc2uCz5kJquFAlBfURhwCyR4fSh6WwzL7tFXjdgrMujAO
         vc1uHy18rxuZLut7fpdJsPDRx4lXO7F2KEOpW0rX4BSXHE3h7TmXwJ/w/P3CFvl1wo7j
         9AU4JHCnlXR0+M8XFHpYUE6MGl1Dn0MiJIS7zv1Lch5zF86sO4b70z/rgI542piRfxKJ
         PdTg==
X-Gm-Message-State: AOAM530roHU+JqGX1XHZ08Uu1QcxwsVqDWPqnnUQfVHbvrD7O7yz1DVK
        Niqf9tx+zckLnxj6Jn4SOQkjpWHBTN70OgMX2QU=
X-Google-Smtp-Source: ABdhPJwpvHnrnd4MZkWGtst+ojt5qpQ73I3L8Sn0gDZvneSPk+OxTnM9RIW2auBm6+0yaKJDxL8B7Xf387cKjZiIZYU=
X-Received: by 2002:a5d:5642:: with SMTP id j2mr27237023wrw.194.1625656105231;
 Wed, 07 Jul 2021 04:08:25 -0700 (PDT)
MIME-Version: 1.0
References: <CADcL3SDfzw+PZHWabN0mrHFuyt1gVtD6Owf_bNpFT=xV-JrVVA@mail.gmail.com>
 <CAOaDVC6yNDOVAvMu4gBuc+sTH50UrXD3z4sODa1NtFsV9SEZ9Q@mail.gmail.com>
In-Reply-To: <CAOaDVC6yNDOVAvMu4gBuc+sTH50UrXD3z4sODa1NtFsV9SEZ9Q@mail.gmail.com>
From:   BW <m40636067@gmail.com>
Date:   Wed, 7 Jul 2021 13:08:14 +0200
Message-ID: <CADcL3SBwbiZJgXVOOTqV2UPqTg=eJwG=ZDCwgzTd9Ez8FH5D6w@mail.gmail.com>
Subject: Re: --detail --export doesn't show all properties
To:     Fine Fan <ffan@redhat.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I'm using ver. mdadm-4.1-24.3.1.x86_64 / openSUSE kernel 15.3

It's only when the array is active you get a raid-level, if the array
is inactive, as in my example, you will not get the raid-level (and
State, Persistence).


On Tue, Jul 6, 2021 at 11:48 AM Fine Fan <ffan@redhat.com> wrote:
>
> Hi Brain,
>
> I am wondering which version did you use?
> As you requested three items here:
> 1."Raid Level",<<<<<<====== I have the "MD_LEVEL" line in --export output.
> 2."State"
> 3."Persistence"
>
> On my side , I am using  :
>  [root@Fedroa34Server ~]# cat /etc/redhat-release
> Fedora release 34 (Thirty Four)
> [root@Fedroa34Server ~]# uname -a
> Linux Fedroa34Server.localdomain 5.11.12-300.fc34.x86_64 #1 SMP Wed Apr 7 16:31:13 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
> [root@Fedroa34Server ~]# rpm -q mdadm
> mdadm-4.1-7.fc34.x86_64
> [root@Fedroa34Server ~]#
>
>  It has "MD_LEVEL" in the --export output  , but the "State" and "Persistence" are not there.
>
> [root@Fedroa34Server ~]# mdadm --detail --export /dev/md126
> MD_LEVEL=raid1    <<<<<<<<<============ I got the MD_LEVEL here.
> MD_DEVICES=2
> MD_CONTAINER=/dev/md/imsm
> MD_MEMBER=0
> MD_UUID=8e3f51e6:d136a0b1:247281c2:ae7f0456
> MD_DEVNAME=Volume0
> MD_DEVICE_ev_sda_ROLE=0
> MD_DEVICE_ev_sda_DEV=/dev/sda
> MD_DEVICE_ev_sdb_ROLE=1
> MD_DEVICE_ev_sdb_DEV=/dev/sdb
>
> [root@Fedroa34Server ~]# mdadm --detail /dev/md126
> /dev/md126:
>          Container : /dev/md/imsm, member 0
>         Raid Level : raid1
>         Array Size : 234428416 (223.57 GiB 240.05 GB)
>      Used Dev Size : 234428416 (223.57 GiB 240.05 GB)
>       Raid Devices : 2
>      Total Devices : 2
>
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
>
> Consistency Policy : resync
>
>
>               UUID : 8e3f51e6:d136a0b1:247281c2:ae7f0456
>     Number   Major   Minor   RaidDevice State
>        1       8        0        0      active sync   /dev/sda
>        0       8       16        1      active sync   /dev/sdb
> [root@Fedroa34Server ~]#
>
>
>
>
>
>
> On Mon, Jul 5, 2021 at 8:21 PM BW <m40636067@gmail.com> wrote:
>>
>> This is an example of the --export output:
>>
>> # mdadm --detail --export /dev/md127
>> MD_DEVICES=3
>> MD_METADATA=1.2
>> MD_UUID=70bc1acd:f879f9cd:dca76d79:d9ce624a
>> MD_DEVNAME=debian:R5
>> MD_NAME=debian:R5
>> MD_DEVICE_dev_sdc_ROLE=spare
>> MD_DEVICE_dev_sdc_DEV=/dev/sdc
>> MD_DEVICE_dev_sdd_ROLE=spare
>> MD_DEVICE_dev_sdd_DEV=/dev/sdd
>> MD_DEVICE_dev_sdb_ROLE=spare
>> MD_DEVICE_dev_sdb_DEV=/dev/sdb
>>
>> This is the same command in "normal" format-output:
>>
>> # mdadm --detail /dev/md127
>> /dev/md127:
>>            Version : 1.2
>>         Raid Level : raid5
>>      Total Devices : 3
>>        Persistence : Superblock is persistent
>>              State : inactive
>>    Working Devices : 3
>>               Name : debian:R5
>>               UUID : 70bc1acd:f879f9cd:dca76d79:d9ce624a
>>             Events : 358
>>     Number   Major   Minor   RaidDevice
>>        -       8       32        -        /dev/sdc
>>        -       8       48        -        /dev/sdd
>>        -       8       16        -        /dev/sdb
>>
>>
>> It would be nice if the --export included the properties "Raid Level",
>> "State", "Persistence" (the first two most important).
>>
>> Another thing, is it correct that "MD_DEVNAME" and "MD_NAME" should be the same?
>> Or perhaps "MD_NAME" should show the kernel/Device-Mapper name e.g.
>> "md127", that would be helpful (by the way, what do you call this mdxx
>> name?)
>>
>> Thanks
>> Brian, Denmark
>>
>
>
> --
>
>
>
>
> Fine Fan
>
> Kernel Storage QE
>
> ffan@redhat.com
>
> T: 8388117
> M: (+86)-15901470329
