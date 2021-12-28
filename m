Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F442C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 28 Dec 2021 23:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhL1X4t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Dec 2021 18:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhL1X4s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Dec 2021 18:56:48 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E430FC061574
        for <linux-raid@vger.kernel.org>; Tue, 28 Dec 2021 15:56:47 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id w184so38282138ybg.5
        for <linux-raid@vger.kernel.org>; Tue, 28 Dec 2021 15:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jcnFkePmR3hTnKNiRnec4wehDBrexIQyviW3Yw/lp8M=;
        b=o0hprRFZS2lbMVdyCXd9/KRDtoSIkuzSpMmGPZxvxqNOx/vfrpz+uUqGAUetsPI6Jl
         7XNRaZpmhT8mshwTsaSKhzDAoMz52nMgH+MkXnjSX8TAEUZ0MC49mX9zKbI3e0Ee9LFF
         AsMradUzZqvDGetMhE/uWUcFnd6N9UtvoyuJnMecA0LZeNxNllDnktl1PbFm4bmMHPH7
         tT/EP6jnf0RUyMWcT0+IZL84MjnN84EjZ278qeRYAAIZzOVHvfyXWyk443shIxHGVaNH
         LLyNK5LhbjQhC0OalSc+P9jsxAAHEbiFbfIW0qtFn0oYhk730466PMkh716KxOebIFMQ
         sa7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jcnFkePmR3hTnKNiRnec4wehDBrexIQyviW3Yw/lp8M=;
        b=d7mkf7RGgUi1QGMHu/NVKV3Fxl5qunSP8wCu9xqVmeTk5FdFg6S7DoeosCI4P1U8W0
         Ll6hcxGd/+Jmyj63PQCgzcrY97cQL5CPOraFQSbpj/u0vOAgRXzATIKcOClOA0kEOFn2
         5v0FfMuQzwZJBwa4ii/DYYl8C8EDKCgWgluvvKDTkKBUE5AZ6XgbkrMhDMQS8NJeEfi3
         E7ElKllYUUxh7zWhOhoeEZz4km6Jm8R3UrwA0rhlVcLDUWOT14B6+bcml7dxEKW5Dt2L
         BdnxBSeBfzzRtX9il6awJXHunR5vQZ5aWbDgoi4QweO3nWLMNKQlVaEr1vOZ/I8gVshr
         CSqA==
X-Gm-Message-State: AOAM531h/UdtZH0ngtFqlNrLcd0H20+fKsPpi4GDU0tNip+5jyki4QLL
        i/YxoLcpYeE/8zuVxXK+v3373cEnAmYzHjx1IygtG62x5rw=
X-Google-Smtp-Source: ABdhPJyEeLBW3G+G/gOhLtkPAb25CDFYyMVMPmGC80VsbaNjM3cdE7VUXq0x53HhnAzcoknyEp6Lj4b6lNvLv22BjXQ=
X-Received: by 2002:a25:f449:: with SMTP id p9mr28691457ybe.594.1640735806921;
 Tue, 28 Dec 2021 15:56:46 -0800 (PST)
MIME-Version: 1.0
References: <CAA9kLn1nZZKHLahjkyJzChgTMC2WKEoyJG2PhHzeXbD_qY_-yw@mail.gmail.com>
 <Yb8ebs7lhEHHTqif@metamorpher.de> <CAA9kLn1JwRLWpOd-kRnLj2YqQhkRM_R_LFisA9_acxHdFJpFVg@mail.gmail.com>
 <YcV6tUwlKd+tLd78@metamorpher.de>
In-Reply-To: <YcV6tUwlKd+tLd78@metamorpher.de>
From:   Tony Bush <thecompguru@gmail.com>
Date:   Tue, 28 Dec 2021 18:56:35 -0500
Message-ID: <CAA9kLn3AYkoa5ybqoxoVRg1umhCbAwsshGNDPtV05tU7K-ZCAQ@mail.gmail.com>
Subject: Re: Need help Recover raid5 array
To:     Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks for the help.  I have successfully recovered my raid.  Here is
what I did if it helps someone else.

My situation: /dev/sdd is in tact and the second (1) drive in my array
for from mdadm examine of this drive
I created a script to make and overlay via nano with this inside:
-----------------------------------------------------------------------------
devices="/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde"

overlay_create()
{

       free=$((`stat -c '%a*%S/1024/1024' -f .`))
        echo free ${free}M
        overlays=""
        overlay_remove
        for d in $devices; do
                b=$(basename $d)
                size_bkl=$(blockdev --getsz $d) # in 512 blocks/sectors
                # reserve 1M space for snapshot header
                # ext3 max file length is 2TB
                truncate -s$((((size_bkl+1)/2)+1024))K $b.ovr || (echo
"Do you use ext4?"; return 1)
                loop=$(losetup -f --show -- $b.ovr)
                #
https://www.kernel.org/doc/Documentation/device-mapper/snapshot.txt
                dmsetup create $b --table "0 $size_bkl snapshot $d $loop P 8"
                echo $d $((size_bkl/2048))M $loop /dev/mapper/$b
                overlays="$overlays /dev/mapper/$b"
        done
        overlays=${overlays# }
}

overlay_remove()
{
        for d in $devices; do
                b=$(basename $d)
                [ -e /dev/mapper/$b ] && dmsetup remove $b && echo
/dev/mapper/$b
                if [ -e $b.ovr ]; then
                        echo $b.ovr
                        l=$(losetup -j $b.ovr | cut -d : -f1)
                        echo $l
                        [ -n "$l" ] && losetup -d $(losetup -j $b.ovr
| cut -d : -f1)
                        rm -f $b.ovr &> /dev/null
                fi
        done
}

overlay_create
------------------------------------------------------------------------------
ran script
sudo ./overlay.sh

cleared bogus info on my overlayed drives:
sudo wipefs --all --types pmbr,gpt,dos /dev/mapper/sda
sudo wipefs --all --types pmbr,gpt,dos /dev/mapper/sdb
sudo wipefs --all --types pmbr,gpt,dos /dev/mapper/sdc
sudo wipefs --all --types pmbr,gpt,dos /dev/mapper/sde

 created script createmdadm.sh with this in it:
-------------------------------------------------------------------------------
mdadm --create /dev/md2 --assume-clean  --readonly    --level=5
--chunk=512K --metadata=1.2  --layout left-symmetric
--data-offset=257024s     --raid-devices=5 /dev/mapper/sd"$1"
/dev/mapper/sdd /dev/mapper/sd"$2" /dev/mapper/sd"$3"
/dev/mapper/sd"$4"
-----------------------------------------------------------------------------------

made a list of all 24 permutations of drive arrangements to plug into
the script each time.  The actual list i used shown below with
examples of outputs that were given:
------
aDbce*
abce
mount: /media/raid: wrong fs type, bad option, bad superblock on
/dev/md2, missing codepage or helper program, or other error.
*this was the output on all attempts to Mount the new array unless
noted otherwise
bace*
cabe*
acbe*
bcae*
cbae*
ebac mount: /media/raid: mount(2) system call failed: Structure needs cleaning.

beac*
aebc*
eabc mount: /media/raid: mount(2) system call failed: Structure needs cleaning.
baec*
abec*
aceb*
caeb*
eacb mount: /media/raid: mount(2) system call failed: Structure needs cleaning.

aecb*
ceab*
ecab mount: /media/raid: mount(2) system call failed: Structure needs cleaning.

ecba mount: /media/raid: WARNING: source write-protected, mounted read-only.

ceba
beca
ebca
cbea
bcea
----------------
ran the mdadmcreate script to create array:
sudo ./createmdadm.sh a b c e
sudo mount /dev/md2 /media/raid
output: mount: /media/raid: wrong fs type, bad option, bad superblock
on /dev/md2, missing codepage or helper program, or other error.

didnt work so i stop it(never needed to umount)
sudo mdadm --stop /dev/md2

then repeat steps with new permutation of drive arrangement:
sudo ./createmdadm.sh a b c e
sudo mount /dev/md2 /media/raid
sudo mdadm --stop /dev/md2

I was looking for a change in output on mounting the raid.
The first and second drive being correct seemed to give a different output:
output:    mount: /media/raid: mount(2) system call failed: Structure
needs cleaning.
correct arrangment gave this output:
output:    mount: /media/raid: WARNING: source write-protected,
mounted read-only.

I then mounted the drive as my user, tested multiple large files and
when i was done crying i unmounted
sudo umount /...
sudo mdadm --stop /dev/md2

modified my overlay.sh last line to overlay_remove instead of overlay_create
removed the overlay the best i know how:
sudo ./overlay.sh

then ran mdadm create on the real drives without readonly peramiter
and the discovered disk arrangements.  Also changed /dev/md2 to
/dev/md0  which is the original config for my raid that is setup
already:
sudo mdadm --create /dev/md0 --assume-clean    --level=5 --chunk=512K
--metadata=1.2  --layout left-symmetric  --data-offset=257024s
--raid-devices=5 /dev/sde /dev/sdd /dev/sdc /dev/sdb /dev/sda
sudo mount /dev/md0 /media/raid
checked my files and rejoiced
not elegant but simple enough.  Wish i would have had a play by play
like this.  Knowing what to expect on outputs really would have been
handy.  I hope this helps someone out there.

My next task is creating a new raid that is inside of partitions.
Need to do this with 2 new drives, transfer 10TB, then shrink and
remove a drive to add to new raid, transfer and repeat.  Let me know
if this is a bad idea please.  I fear shrinking or removing the raid
but heard that this was a feature that has been added more recently
and could work.

Thanks guys.

On Fri, Dec 24, 2021 at 2:45 AM Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
>
> On Thu, Dec 23, 2021 at 10:55:01PM -0500, Tony Bush wrote:
> > /dev/mapper/sda /dev/mapper/sdb /dev/mapper/sdc /dev/mapper/sdd
> > /dev/mapper/sde
>
> Hi Tony,
>
> your examine output of the one drive that was left showed Device role 1,
> and count starts from 0 so that's the 2nd drive in the array. The order
> of the others is unknown so yes, unless you are able to derive order
> from raw data, you simply have to try all combinations. This can be
> scripted as well.
>
> Furthermore you should --examine the array you created and make sure
> that all other variables (offset, level, layout, ...), match your
> previous --examine.
>
> As for re-creating overlays, you can do that for every single step
> but it might not be necessary just for mount attempt.
>
> Note that there is the case where mounting might succeed but drive
> order is still wrong - find a large file and see if it is fully intact.
>
> Best of luck,
> Andreas Klauer
