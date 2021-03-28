Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5983C433C1
	for <linux-raid@archiver.kernel.org>; Sun, 28 Mar 2021 21:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BCB61481
	for <linux-raid@archiver.kernel.org>; Sun, 28 Mar 2021 21:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhC1VD2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Mar 2021 17:03:28 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:16644 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhC1VC6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 28 Mar 2021 17:02:58 -0400
Received: from host86-155-154-65.range86-155.btcentralplus.com ([86.155.154.65] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lQaSV-0004Xg-8Y; Sun, 28 Mar 2021 19:48:24 +0100
Subject: Re: why won't this RAID5 device start?
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20210328021451.GB1415@justpickone.org>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <6060D8AA.9030504@youngman.org.uk>
Date:   Sun, 28 Mar 2021 20:27:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <20210328021451.GB1415@justpickone.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/03/21 03:14, David T-G wrote:
> Hi, all --
> 
> I recently migrated our disk farm to a new box with a new OS build
> (openSuSE from KNOPPIX).  Aside from the usual challenges of setting
> up the world again, I have a 3-device RAID5 volume that won't start.
> The other metadevice is fine, though; I think we can say that the md
> system is running.  Soooooo ...  Where do I start?
> 
>   diskfarm:~ # cat /proc/mdstat 
>   Personalities : [raid6] [raid5] [raid4] 
>   md0 : active raid5 sdc1[3] sdd1[4] sdb1[0]
>         11720265216 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U_UU]

This looks wrong - is this supposed to be a four-drive array? U_UU
implies a missing drive ... as does [4/3]
>         
>   md127 : inactive sdl2[0](S) sdj2[3](S) sdf2[1](S)
>         2196934199 blocks super 1.2
>          
>   unused devices: <none>
> 
> [No, I don't know why md127 was first a moment ago!]  I tried reassembling
> the device, but mdadm doesn't like it.
> 
>   diskfarm:~ # mdadm --stop /dev/md127
>   mdadm: stopped /dev/md127
>   diskfarm:~ # mdadm --assemble --scan
>   mdadm: /dev/md/750Graid5md assembled from 1 drive - not enough to start the array.
>   mdadm: Found some drive for an array that is already active: /dev/md/0
>   mdadm: giving up.
>   mdadm: No arrays found in config file or automatically
> 
> But ... what's with just 1 drive?
> 
>   diskfarm:~ # for D in /dev/sd[fjl] ; do parted $D print ; done
>   Model: ATA WDC WD7500BPKX-7 (scsi)
>   Disk /dev/sdf: 750GB
>   Sector size (logical/physical): 512B/4096B
>   Partition Table: gpt
>   Disk Flags: 
> 
>   Number  Start   End    Size   File system  Name              Flags
>    2      1049kB  750GB  750GB  ntfs         Linux RAID        raid
>    3      750GB   750GB  134MB  ext3         Linux filesystem
> 
>   Model: ATA WDC WD7500BPKX-7 (scsi)
>   Disk /dev/sdj: 750GB
>   Sector size (logical/physical): 512B/4096B
>   Partition Table: gpt
>   Disk Flags: 
> 
>   Number  Start   End    Size   File system  Name              Flags
>    2      1049kB  750GB  750GB  ntfs         Linux RAID        raid
>    3      750GB   750GB  134MB  xfs          Linux filesystem
> 
>   Model: ATA Hitachi HDE72101 (scsi)
>   Disk /dev/sdl: 1000GB
>   Sector size (logical/physical): 512B/512B
>   Partition Table: msdos
>   Disk Flags: 
> 
>   Number  Start   End     Size    Type     File system  Flags
>    1      1049kB  4227MB  4226MB  primary  ntfs         diag, type=27
>    2      4227MB  754GB   750GB   primary  reiserfs     raid, type=fd
>    3      754GB   754GB   134MB   primary  reiserfs     type=83
>    4      754GB   1000GB  246GB   primary  reiserfs     type=83
> 
> Slice 2 on each is the RAID partition, slice 3 on each is a little 
> filesystem for bare-bones info, and slice 4 on sdl is a normal basic
> filesystem for scratch content.
> 
>   diskfarm:~ # mdadm --examine /dev/sd[fjl]2 | egrep '/dev|Name|Role|State|Checksum|Events|UUID'
>   /dev/sdf2:
>        Array UUID : 88575f01:592167fd:bd9f9ba1:a61fafc4
>              Name : diskfarm:750Graid5md  (local to host diskfarm)
>             State : clean
>       Device UUID : e916fc67:b8b7fc59:51440134:fa431d02
>          Checksum : 43f9e7a4 - correct
>            Events : 720
>      Device Role : Active device 1
>      Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
>   /dev/sdj2:
>        Array UUID : 88575f01:592167fd:bd9f9ba1:a61fafc4
>              Name : diskfarm:750Graid5md  (local to host diskfarm)
>             State : clean
>       Device UUID : 0b847f84:83e80a3d:a0dc11e7:60bffc9f
>          Checksum : 9522782b - correct
>            Events : 177792
>      Device Role : Active device 2
>      Array State : A.A ('A' == active, '.' == missing, 'R' == replacing)
>   /dev/sdl2:
>        Array UUID : 88575f01:592167fd:bd9f9ba1:a61fafc4
>              Name : diskfarm:750Graid5md  (local to host diskfarm)
>             State : clean
>       Device UUID : cc53440e:cb9180e4:be4c38d4:88a676eb
>          Checksum : fef95256 - correct
>            Events : 177794
>      Device Role : Active device 0
>      Array State : A.. ('A' == active, '.' == missing, 'R' == replacing)
> 
> Slice f2 looks great, but slices j2 & l2 seem to be missing -- even though
> they are present.  Worse, the Events counter on sdf2 is frighteningly
> small.  Where did it go?!?  So maybe I consider sdf2 failed and reassemble
> from the other two [only] and then put f2 back in?

Yes I'm afraid so. I'd guess you've been running a failed raid-5 for
ages, and because something hiccuped when you shut it down, the two good
drives drifted apart, and now they won't start ...
> 
> Definitely time to stop, take a deep breath, and ask for help :-)
> 
Read up about overlays on the web site, use an overlay to force-assemble
the two good drives, run fsck etc to check everything's good (you might
lose a bit of data, hopefully very little), then if everything looks
okay do it for real. Ie force-assemble the two good drives, then re-add
the third. I'd just do a quick smartctl health check on all three drives
first, just to make sure nothing is obviously wrong with them - a
problem could kill your array completely! Then add the third drive back
in (whether you use --add or --re-add probably won't make much difference).

Oh - and fix whatever is wrong with md0, too, before that dies on you!

Cheers,
Wol

