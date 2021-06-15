Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86636C48BE5
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 11:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F10561455
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 11:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFOLaP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Jun 2021 07:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhFOLaP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Jun 2021 07:30:15 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DA6C061574
        for <linux-raid@vger.kernel.org>; Tue, 15 Jun 2021 04:28:10 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 5so3505204qkc.8
        for <linux-raid@vger.kernel.org>; Tue, 15 Jun 2021 04:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=tIjev/T+gSqdhS1QJ6AFcJAwFVrMFMrv+SkjQH8aNqQ=;
        b=vRuZJvO1BPKK3+5C6FF64I9wLGyc9Xa9VTtWyYsigSz631+kHOJa2do0U2LXDM5mBx
         TKeqbKUki9Yqeq8m7iPsRXXiummwlBpq/f8po340lrttEyQarjkh4jcJdJV18/GUE2Gs
         NmttCfKi12XcMxhTFIaxAnGwYHhkbrM/EFj3tgryyXDA7+t2oovjjKfHnw1/q606MByK
         N4MQtYZSAwE2gBuVzv4FvrtbI/07+SOCFYNFNMkDgCel56e/HpjZxVhpyw7gIMUOIngg
         UyPywZXY3IgJYppXV9Aen8+GEpRLwSd6ZVmIzAjFNt/3YepnEBRYbQRlJn6zmHAd+hHX
         eJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tIjev/T+gSqdhS1QJ6AFcJAwFVrMFMrv+SkjQH8aNqQ=;
        b=OQ5J7kLrZlhPGV5k2ZKRpwLbyRuSGCtHD4biPaQ0QhPBCEhouKZZCXM11706/nXmjz
         wSEFw42aSunEmG4+D2kpodCrfYjpPXtCTV1yj/pRLvq4Z1pi0cMmCu7DYgEYBrq1Jr2f
         cQc5Q9nylzbgH8+I7IgPw3zeT1294DMg0k9FYBg7Ynve/i6UjFNqyzpH5le2qRduhlcK
         zWcuRWzjsZ6kKIBxTOvTUoW/Pp4UVBeOe90cKO3Cj9+p2y/QiVadvGF9XagXQ7lfyyGB
         VqTpZ/sYZsVy/bd9m3q1J0gDdVMg49BYEkYUMdP/2N2rEx8Y9vOeWhJtkm4JeqFZl7fz
         07Yg==
X-Gm-Message-State: AOAM532UtPliLcXFzA2Fw2ZBfgigWT5OrfcdZ2uSI1SKv9Arkmh4lSMW
        I5l/RWWt9hC3lQo4aCBCMcmwoUGq6Yz5
X-Google-Smtp-Source: ABdhPJyxMXBf58B2TDnfzd74Vwvv/nVKaduVZxBqGpW2/DsyATKaFbt1FzATlPab5OW9qzDWoN+zZw==
X-Received: by 2002:a05:620a:6c9:: with SMTP id 9mr21478398qky.303.1623756489449;
        Tue, 15 Jun 2021 04:28:09 -0700 (PDT)
Received: from ?IPv6:2001:1284:f013:be0e:5972:b4af:263a:d9ed? ([2001:1284:f013:be0e:5972:b4af:263a:d9ed])
        by smtp.gmail.com with ESMTPSA id m7sm11950101qki.79.2021.06.15.04.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 04:28:08 -0700 (PDT)
Subject: Re: Recover from crash in RAID6 due to hardware failure
To:     Leslie Rhorer <lesrhorer@att.net>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <bd617822-79bd-ce40-f50e-21d482570324@gmail.com>
 <4745ddd9-291b-00c7-8678-cac14905c188@att.net>
 <ed21aa89-e6a1-651d-cc23-9f4c72cf63e0@gmail.com>
 <f07a1c5e-b2ed-cff6-e4e3-1f4956a68c3d@att.net>
From:   Carlos Maziero <carlos.maziero@gmail.com>
Message-ID: <de1f0636-c194-4cf3-c464-589b78186fa0@gmail.com>
Date:   Tue, 15 Jun 2021 08:28:06 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f07a1c5e-b2ed-cff6-e4e3-1f4956a68c3d@att.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Leslie,

thanks for your suggestion! I succeeded to do it, although the path was
a bit longer:

a) remove logical volume (synology creates one, it prevents stopping the
array):

# ll /dev/mapper/
crw-------    1 root     root       10,  59 Sep  5  2020 control
brw-------    1 root     root      253,   0 Jun 10 11:57 vol1-origin

# dmsetup remove vol1-origin

b) stop the array:

# mdadm --stop /dev/md2
mdadm: stopped /dev/md2

c) recreate the array with the original layout:

# mdadm --verbose --create /dev/md2 --chunk=64 --level=6
--raid-devices=5 --metadata=1.2 /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3
/dev/sde3

mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: /dev/sda3 appears to be part of a raid array:
    level=raid6 devices=5 ctime=Sat Sep  5 12:46:57 2020
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdb3 appears to be part of a raid array:
    level=raid6 devices=5 ctime=Sat Sep  5 12:46:57 2020
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdc3 appears to be part of a raid array:
    level=raid6 devices=5 ctime=Sat Sep  5 12:46:57 2020
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdd3 appears to be part of a raid array:
    level=raid6 devices=5 ctime=Sat Sep  5 12:46:57 2020
mdadm: layout defaults to left-symmetric
mdadm: /dev/sde3 appears to be part of a raid array:
    level=raid6 devices=5 ctime=Sat Sep  5 12:46:57 2020
mdadm: size set to 2925544256K
Continue creating array? yes
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.

d) checking it:

# cat /proc/mdstat
Personalities : [raid1] [linear] [raid0] [raid10] [raid6] [raid5] [raid4]
md2 : active raid6 sde3[4] sdd3[3] sdc3[2] sdb3[1] sda3[0]
      8776632768 blocks super 1.2 level 6, 64k chunk, algorithm 2 [5/5]
[UUUUU]
      [=>...................]  resync =  6.8% (199953972/2925544256)
finish=2440.4min speed=18613K/sec
     
md1 : active raid1 sda2[1] sdb2[2] sdc2[3] sdd2[0] sde2[4]
      2097088 blocks [5/5] [UUUUU]
     
md0 : active raid1 sdc1[3] sdd1[0] sde1[4]
      2490176 blocks [5/3] [U__UU]
     
unused devices: <none>

After that, I fsck'ed and mounted it read-only, and now I'm happy
recovering my data... :-)

Thanks again!

Carlos


Em 14/06/2021 22:36, Leslie Rhorer escreveu:

> Oops!  'Sorry.  That should be:
>
> mdadm -S /dev/md2
> mdadm -C -f -e 1.2 -n 5 -c 64K --level=6 -p left-symmetric /dev/md2
> /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3 /dev/sde3
>
>
>     You only have five disks, not six.
>
