Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0E0C64E7B
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 11:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 911932076E
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 11:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgK3LTh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 06:19:37 -0500
Received: from mail.thelounge.net ([91.118.73.15]:53291 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbgK3LTg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Nov 2020 06:19:36 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Cl2mY6L8hzXVl;
        Mon, 30 Nov 2020 12:18:53 +0100 (CET)
To:     Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
        antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
 <ef7d7b4c-d7d2-1bff-8b13-2187889162af@grumpydevil.homelinux.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: =?UTF-8?Q?Re=3a_=e2=80=9croot_account_locked=e2=80=9d_after_removin?=
 =?UTF-8?Q?g_one_RAID1_hard_disc?=
Message-ID: <ed411d06-c343-43dc-04e1-0a17658cb989@thelounge.net>
Date:   Mon, 30 Nov 2020 12:18:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <ef7d7b4c-d7d2-1bff-8b13-2187889162af@grumpydevil.homelinux.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Am 30.11.20 um 12:10 schrieb Rudy Zijlstra:
> 
> On 30-11-2020 11:31, Reindl Harald wrote:
>>
>>
>> Am 30.11.20 um 10:27 schrieb antlists:
>>>> I read that a single RAID1 device (the second is missing) can be 
>>>> accessed without any problems. How can I do that?
>>>
>>> When a component of a raid disappears without warning, the raid will 
>>> refuse to assemble properly on next boot. You need to get at a 
>>> command line and force-assemble it
>>
>> since when is it broken that way?
>>
>> from where should that commandlien come from when the operating system 
>> itself is on the for no vali dreason not assembling RAID?
>>
>> luckily the past few years no disks died but on the office server 300 
>> kilometers from here with /boot, os and /data on RAID1 this was not 
>> true at least 10 years
>>
>> * disk died
>> * boss replaced it and made sure
>>   the remaining is on the first SATA
>>   port
>> * power on
>> * machine booted
>> * me partitioned and added the new drive
>>
>> hell it's and ordinary situation for a RAID that a disk disappears 
>> without warning because they tend to die from one moment to the next
>>
>> hell it's expected behavior to boot from the remaining disks, no 
>> matter RAID1, RAID10, RAID5 as long as there are enough present for 
>> the whole dataset
>>
>> the only thing i expect in that case is that it takes a little longer 
>> to boot when soemthing tries to wait until a timeout for the missing 
>> device / componenzt
>>
>>
> The behavior here in the post is rather debian specific. The initrd from 
> debian refuses to continue  if it cannot get all partitions mentioned in 
> the fstab. 

that is normal behavior but don't apply to a RAID with a missing device, 
that's the R in RAID about :-)

> On top i suspect an error in the initrd that the OP is using 
> which leads to the raid not coming up with a single disk.
> 
> The problems from the OP have imho not much to do with raid, and a lot 
> with debian specific issues/perhaps a mistake from the OP

good to know, on Fedora i am used not to care about missing RAID devices 
as long there are enough remaining

there is some timeout which takes boot longer than usual but at the end 
the machines are coming up as usual, mdmonitor fires a mail whining 
about degraded RAID adn that's it

that behavior makes the difference a trained monkey can replace the dead 
disk and the rest is done by me via ssh or having real trouble needing 
physical precence

typically fire up my "raid-repair.sh" telling the script source and 
target disk for cloning partition table, mbr and finally add the new 
partitions to start the rebuild

[root@srv-rhsoft:~]$ df
Dateisystem    Typ  Größe Benutzt Verf. Verw% Eingehängt auf
/dev/md1       ext4   29G    7,8G   21G   28% /
/dev/md2       ext4  3,6T    1,2T  2,4T   34% /mnt/data
/dev/md0       ext4  485M     48M  433M   10% /boot

[root@srv-rhsoft:~]$ cat /proc/mdstat
Personalities : [raid10] [raid1]
md1 : active raid10 sdc2[6] sdd2[5] sdb2[7] sda2[4]
       30716928 blocks super 1.1 256K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

md2 : active raid10 sdd3[5] sdb3[7] sdc3[6] sda3[4]
       3875222528 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 2/29 pages [8KB], 65536KB chunk

md0 : active raid1 sdc1[6] sdd1[5] sdb1[7] sda1[4]
       511988 blocks super 1.0 [4/4] [UUUU]

unused devices: <none>
