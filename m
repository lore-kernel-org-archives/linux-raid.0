Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51478C4332F
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 23:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiLCX07 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 18:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCX05 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 18:26:57 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAD8164AC
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 15:26:54 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1p1buG-0009wE-6f
        for linux-raid@vger.kernel.org;
        Sat, 03 Dec 2022 23:26:52 +0000
Message-ID: <dfbbb68c-6563-a56b-d4de-dc932cd40005@youngman.org.uk>
Date:   Sat, 3 Dec 2022 23:26:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: about linear and about RAID10
To:     Linux RAID list <linux-raid@vger.kernel.org>
References: <20221124032821.628cd042@nvm> <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
 <25477.7682.651953.966662@quad.stoffel.home> <20221203055816.GT19721@jpo>
 <dad4a4d4-70bb-f09b-c2fc-05dc2d21f8bb@youngman.org.uk>
 <20221203182721.GV19721@jpo>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <20221203182721.GV19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 03/12/2022 18:27, David T-G wrote:
> Anthony, et al --
> 
> ...and then Wols Lists said...
> % On 03/12/2022 05:58, David T-G wrote:
> % >
> % > I've finally convinced The Boss to spring for additional disks so that I
> % > can mirror, so our two servers both have SSD mirroring; yay.  The web
> % > server doesn't need much space, so it has a pair of 4T HDDs mirrored as
> % > well ... but as RAID10 since I thought that that was cool.  Ah, well.
> %
> % Raid 10 across two drives? Do I read you right? So you can easily add a 3rd
> % drive to get 6TB of usable storage, but raid 10 x 2 drives = raid 1 ...
> 
> Thanks for the aa/bb/cc non-symmetrical layout help recently.  I think I
> see where you're going here.  But that isn't what I have in this case.
> 
> Each disk is sliced into two large partitions that take up about half:
> 
>    davidtg@jpo:~> for D in /dev/sd[bc] ; do sudo parted $D u GiB p free | grep GiB ; done
>    Disk /dev/sdb: 3726GiB
>            0.00GiB  0.00GiB  0.00GiB  Free Space
>     1      0.00GiB  1863GiB  1863GiB               Raid1-1
>     2      1863GiB  3726GiB  1863GiB               Raid1-2
>     4      3726GiB  3726GiB  0.00GiB  ext2         Seag4000-ZDHB2X37-ext2
>    Disk /dev/sdc: 3726GiB
>            0.00GiB  0.00GiB  0.00GiB  Free Space
>     1      0.00GiB  1863GiB  1863GiB               Raid1-2
>     2      1863GiB  3726GiB  1863GiB               Raid1-1
>     4      3726GiB  3726GiB  0.00GiB               Seag4000-ZDHBKZTG-ext2
> 
> The two halves of each disk are then mirrored across -- BUT in an "X"
> layout.  Note that b1 pairs with c2 and c1 pairs with b2.
> 
>    davidtg@jpo:~> sudo mdadm -D /dev/md/md4[12] | egrep '/dev/.d|Level'
>    /dev/md/md41:
>            Raid Level : raid1
>           0       8       17        0      active sync   /dev/sdb1
>           1       8       34        1      active sync   /dev/sdc2
>    /dev/md/md42:
>            Raid Level : raid1
>           0       8       18        0      active sync   /dev/sdb2
>           1       8       33        1      active sync   /dev/sdc1
> 
> Finally, the mirrors are striped together (perhaps that should have been
> a linear instead) to make the final device.
> 
>    davidtg@jpo:~> sudo mdadm -D /dev/md/40 | egrep '/dev/.d|Level'
>    /dev/md/40:
>            Raid Level : raid0
>           0       9       41        0      active sync   /dev/md/md41
>           1       9       42        1      active sync   /dev/md/md42
> 
>    davidtg@jpo:~> sudo parted /dev/md40 u GiB p free | grep GiB
>    Disk /dev/md40: 3726GiB
> 	  0.00GiB  0.00GiB  0.00GiB  Free Space
>     1      0.00GiB  3726GiB  3726GiB  xfs          4TRaid10md
>     4      3726GiB  3726GiB  0.00GiB  ext2         4TRaid10md-ntfs
> 
> The theory was that each disk would hold half of the total in the first
> half of its space and that md would be clever enough to ask the proper
> disk for the sector to keep the head in that short run.  Writes cover the
> whole disk one way or another, of course, but reads should require less
> head movement and be quicker.
> 
> Or that's how I understood it in the very many RAID wiki pages and other
> docs I read :-)
> 
Hmm ... so being pedantic about terminology that's a definite raid-1+0, 
not linux-raid-10.

And if I read you right, you have only 2 disks? Split into 4 partitions 
to give you 1+0? WHY!!! I thought the acronym was Keep It Simple S*****.

Linux and raid try to minimise head movement. So if your reads are all 
over the place, one head will gravitate to the end of its disk, while 
the other will gravitate to the start.

There's not much point messing around and changing it now, but if you 
need to increase the array size, I'd just ditch the fancy layout and 
move to a simple real linux-raid-10. Add a new 4TB to your raid-1 mirror 
and convert it to a true raid-10. You said you had plenty of spare 2TBs, 
so --replace one of your 4TBs onto a pair of 2TBs, then --replace one of 
your raid-0's onto it. Finally, just fail the other raid-0 then replace 
it with the last 4TB. That way you don't ever lose redundancy, despite 
just knocking one drive out.
> 
> %
> ...
> % should just replay the lost writes, and you're back in business. So - if
> % your aim is speed of recovery - there's no point splitting the disk into
> 
> [Not here; that's the RAID5 system with big disks.]
> 
> 
> % slices. There are good reasons for doing it, but that isn't one of them!
> 
> How about speed of read?  That was the goal here.  I don't foresee adding
> more disks here, although I do actually have one more internal SATA port
> and so, maybe, yeah, I might go to a three-disk RAID10 somehow.  But this
> server isn't meant to have a lot of content.  [If I can ever find my old
> SATA daughter card, though, I could hang some of those leftover <2T disks
> on it and shoehorn in more archive disks :-]
> 
Well, adding more disks will speed up access. And how much is a (cheap) 
SATA card? about £10?

Actually, that might be a good idea, especially if you want to get into 
playing with lvm? Especially if you can temporarily (or permanently) add 
a third 2TB. Free up a 4TB as before, make a single-disk mirror out of 
it, and create an LVM volume and partition. I'm hoping this partition 
will be big enough just to do a dd copy of your mirror partition across.

Or you could just do a cp copy, but my drives are littered with hard 
links so cp is not a wise choice for me ...

Then as before free up your second 4TB without actually destroying the 
array to keep redundancy, add it in to your new mirror, then you can 
just kill all the remaining disks on the old array. Then add two (or 
more) 2TBs into the new array. That'll give you 6TB of usable space with 
the first 4TB mirrored across 4 drives (you wanted speed?) and the last 
2TB mirrored across the second half of the two 4TB drives. If you can 
then add any more 2TB drives it'll add more disk space but more 
importantly from your point of view, it'll spread the data across even 
more drives and make large files read even faster ... Something to think 
about. Just a warning - you're supposed to be able to easily convert 
between raids, provided you go via a 2-disk mirror. Raid-10, however, 
seems to be rather tricky to get back into a raid-1 layout ... going to 
raid-5 or 6 or whatever (should you want to) might involve building a 
whole new array.

Cheers,
Wol
