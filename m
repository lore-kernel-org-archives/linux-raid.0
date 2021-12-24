Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDBCC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 24 Dec 2021 03:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351205AbhLXDzR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Dec 2021 22:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbhLXDzR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Dec 2021 22:55:17 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3816C06175A
        for <linux-raid@vger.kernel.org>; Thu, 23 Dec 2021 19:55:16 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 131so22118535ybc.7
        for <linux-raid@vger.kernel.org>; Thu, 23 Dec 2021 19:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=57IPGc5XHpCkLpEbN6dOrQraifRg6VAoun17zTOJ0mA=;
        b=iGLBEyurEoWppmOUO+PSLVjAQzSxeot3Vt4axo7qdEllrORX61jSgbueg+TkXfalDD
         O/m5srPYhUxIhDh2Q8S5BfNhP+XeMScpjJaLD30RNMcRYj4RIGSbfavI+VvoCw5S1gc0
         dBDI6ta+W7uFTuN+183cDXMmUcFVEoKBWe9BtmresHhUM18Hvlr6dDB0lx9mhg/1SWr8
         /1gU54YdsxFZMO+9jfBZq+jNYTYNjw7DDLEXDENho2Y+UzcWsV2cfXoPUFS1fwA2Phiz
         q53jTfpy0jc5C4UgeswZrho7fdrXMSSlr2S2+gl2KWY4/ACVd2IcD2IGzhAlBgUK+a2T
         3aFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=57IPGc5XHpCkLpEbN6dOrQraifRg6VAoun17zTOJ0mA=;
        b=4s/Zj/Eud3F2CrbeiNyNfec/CeoXGDoK4rsBH4HLRwo7SlHB+QsvRT/7/6NVQOvriQ
         y0ILVGceoInnNZwTpQ8lEQCNExIY4il3tdgFNQQKmXZHYeexnwVSOpV+LQlkRNz8UF9S
         kD4dtB0BZeyE8bnh4vfBPgXh7D5HDO/mhTthWiiD5ECr/KoUCo6mMpGirFYvjER1hh9V
         0+D28DHU2SvNPs/wMHmkQVg5a2cmGVol3ruMWBiAXrbDXznVR4g+n0mgKXAqyWZc+z8D
         0qWSf/A6gyzPHUruXcoWvMpkqjAfi7woldSSu0j6qPXcdMCSoM/CfXaMeXm/hRn15jWZ
         yjlg==
X-Gm-Message-State: AOAM532u4m0vXTehFYQSY808jEKhSbl3v7nhm212OGXSiaaw1+0UIUEI
        JsI6ickOgW0B04Wl6/2bWkEywugGyY6TV4NP4vtng/UKkZA=
X-Google-Smtp-Source: ABdhPJxzz1yKXoFAwsJNjogMav2wAryJk5rUO4gDlQVEmDkXe8fVDBV/aWup8uNqUGMRpqmSCGYyF3WNM+KdrlulsiE=
X-Received: by 2002:a05:6902:1007:: with SMTP id w7mr7543175ybt.718.1640318115756;
 Thu, 23 Dec 2021 19:55:15 -0800 (PST)
MIME-Version: 1.0
References: <CAA9kLn1nZZKHLahjkyJzChgTMC2WKEoyJG2PhHzeXbD_qY_-yw@mail.gmail.com>
 <Yb8ebs7lhEHHTqif@metamorpher.de>
In-Reply-To: <Yb8ebs7lhEHHTqif@metamorpher.de>
From:   Tony Bush <thecompguru@gmail.com>
Date:   Thu, 23 Dec 2021 22:55:01 -0500
Message-ID: <CAA9kLn1JwRLWpOd-kRnLj2YqQhkRM_R_LFisA9_acxHdFJpFVg@mail.gmail.com>
Subject: Re: Need help Recover raid5 array
To:     Andreas Klauer <Andreas.Klauer@metamorpher.de>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I am at a loss.  I tried setting up an overlay with the 'overlay
manipulation functions' as a script.  First time touching that, but i
think it is working correctly.  I then wipefs --all --types
pmbr,gpt,dos /dev/sd{a,b,c,e}.  I wanted to tack on a file system
label of 'linux_raid_memeber' but dont know how.  Then I did :

sudo mdadm --create /dev/md2 --assume-clean     --level=5 --chunk=512K
--metadata=1.2 --data-offset=257024s     --raid-devices=5
/dev/mapper/sda /dev/mapper/sdb /dev/mapper/sdc /dev/mapper/sdd
/dev/mapper/sde
mdadm: /dev/mapper/sdd appears to be part of a raid array:
       level=raid5 devices=5 ctime=Fri Nov 16 13:20:25 2018
mdadm: partition table exists on /dev/mapper/sdd but will be lost or
       meaningless after creating array
Continue creating array? y
mdadm: array /dev/md2 started.
thecompguru@bushserver:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md2 : active raid5 dm-4[4] dm-3[3] dm-2[2] dm-1[1] dm-0[0]
      39065233408 blocks super 1.2 level 5, 512k chunk, algorithm 2
[5/5] [UUUUU]
      bitmap: 0/73 pages [0KB], 65536KB chunk

unused devices: <none>
thecompguru@bushserver:~$ sudo mount /dev/md2 /media/raid
mount: /media/raid: wrong fs type, bad option, bad superblock on
/dev/md2, missing codepage or helper program, or other error.
thecompguru@bushserver:~$ sudo mdadm --stop /dev/md2

Is this normal and looks as expected?  Am I doing this right?  Do I
need to do this 120 times changing the drive order till it shows up as
working?  I need some hand holding or some more step by step because I
am just not sure what to do.

Is it possible to do some kind of dd snip and copy out some parts of
the good drive to get mdadm to look for the superblock or whatever
it's needing from the other drives?

Check me on the overlay as well.  I just copied the 2 functions and
added a line at the bottom into a .sh executable script and ran with
sudo.
****
devices="/dev/sda /dev/sdb /dev/sdc"

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
****

My only way to proceed right now would be to run the overlay_create
and I assume that starts me fresh again on drive changes?  I then try
creating the array again with a different drive order?  Not really
very feasible.  Can I determine the order placement of the intact
drive in any way?  Then that's like 24 possible arrangement options
instead of 120.

Thanks for any help.

On Sun, Dec 19, 2021 at 6:58 AM Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
>
> On Sat, Dec 18, 2021 at 11:31:39PM -0500, Tony Bush wrote:
> > I forgot that this new-to-this-system SSD had Windows 10 OS on
> > it and I believe it tried to boot while I was working on hooking up my
> > monitor.  So I think that it saw my raid drives and tried to fdisk
> > them.  I did mdadm directly to drive and not to a partition(big
> > mistake I know now).  So I think the drives were seen as corrupted and
> > fdisk corrected the formatting.
>
> Windows is known to do this but it can just as well happen within Linux.
> Hopefully no filesystem formatting took place...
>
> > To fix, I have been leaning toward making the drives ready only and
> > using an overlay file. Like here:
> > https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
>
> This method is so useful there should be standard command in Linux
> to create and manage overlays; but there is none so you have to make do
> with the 'overlay manipulation functions' as shown in the wiki.
>
> > But i dont understand all the commands well enough to work this for my
> > situation.  Seems like since I don't know the original drive
> > arrangement that may be adding an additional level of complexity.  If
> > I can figure out the read only and overlay, I still don't know exactly
> > the right way to proceed on the mdadm front.  Please anyone who has a
> > handle on a situation like this, let me know what I should do.  Thanks
>
> I summarized `mdadm --create` for data recovery here:
>
>   https://unix.stackexchange.com/a/131927/30851
>
> In addition you should remove the bogus GPT and MBR partition headers.
> You can use 'wipefs' for this task. (Test it with overlays first...)
>
>   wipefs --all --types pmbr,gpt,dos /dev/...
>
> You are lucky to have all the relevant `mdadm --examine` output,
> so you already know the correct data offset and only need to guess
> the correct order of drives.
>
> Regards
> Andreas Klauer
