Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA27C433C1
	for <linux-raid@archiver.kernel.org>; Sun, 28 Mar 2021 02:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D03F961613
	for <linux-raid@archiver.kernel.org>; Sun, 28 Mar 2021 02:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhC1CPX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 27 Mar 2021 22:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhC1COw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 27 Mar 2021 22:14:52 -0400
X-Greylist: delayed 161 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 27 Mar 2021 19:14:52 PDT
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1778CC0613B1
        for <linux-raid@vger.kernel.org>; Sat, 27 Mar 2021 19:14:52 -0700 (PDT)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id 8ACE9796; Sat, 27 Mar 2021 22:14:51 -0400 (EDT)
Date:   Sat, 27 Mar 2021 22:14:51 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: why won't this RAID5 device start?
Message-ID: <20210328021451.GB1415@justpickone.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all --

I recently migrated our disk farm to a new box with a new OS build
(openSuSE from KNOPPIX).  Aside from the usual challenges of setting
up the world again, I have a 3-device RAID5 volume that won't start.
The other metadevice is fine, though; I think we can say that the md
system is running.  Soooooo ...  Where do I start?

  diskfarm:~ # cat /proc/mdstat 
  Personalities : [raid6] [raid5] [raid4] 
  md0 : active raid5 sdc1[3] sdd1[4] sdb1[0]
        11720265216 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U_UU]
        
  md127 : inactive sdl2[0](S) sdj2[3](S) sdf2[1](S)
        2196934199 blocks super 1.2
         
  unused devices: <none>

[No, I don't know why md127 was first a moment ago!]  I tried reassembling
the device, but mdadm doesn't like it.

  diskfarm:~ # mdadm --stop /dev/md127
  mdadm: stopped /dev/md127
  diskfarm:~ # mdadm --assemble --scan
  mdadm: /dev/md/750Graid5md assembled from 1 drive - not enough to start the array.
  mdadm: Found some drive for an array that is already active: /dev/md/0
  mdadm: giving up.
  mdadm: No arrays found in config file or automatically

But ... what's with just 1 drive?

  diskfarm:~ # for D in /dev/sd[fjl] ; do parted $D print ; done
  Model: ATA WDC WD7500BPKX-7 (scsi)
  Disk /dev/sdf: 750GB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags: 

  Number  Start   End    Size   File system  Name              Flags
   2      1049kB  750GB  750GB  ntfs         Linux RAID        raid
   3      750GB   750GB  134MB  ext3         Linux filesystem

  Model: ATA WDC WD7500BPKX-7 (scsi)
  Disk /dev/sdj: 750GB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags: 

  Number  Start   End    Size   File system  Name              Flags
   2      1049kB  750GB  750GB  ntfs         Linux RAID        raid
   3      750GB   750GB  134MB  xfs          Linux filesystem

  Model: ATA Hitachi HDE72101 (scsi)
  Disk /dev/sdl: 1000GB
  Sector size (logical/physical): 512B/512B
  Partition Table: msdos
  Disk Flags: 

  Number  Start   End     Size    Type     File system  Flags
   1      1049kB  4227MB  4226MB  primary  ntfs         diag, type=27
   2      4227MB  754GB   750GB   primary  reiserfs     raid, type=fd
   3      754GB   754GB   134MB   primary  reiserfs     type=83
   4      754GB   1000GB  246GB   primary  reiserfs     type=83

Slice 2 on each is the RAID partition, slice 3 on each is a little 
filesystem for bare-bones info, and slice 4 on sdl is a normal basic
filesystem for scratch content.

  diskfarm:~ # mdadm --examine /dev/sd[fjl]2 | egrep '/dev|Name|Role|State|Checksum|Events|UUID'
  /dev/sdf2:
       Array UUID : 88575f01:592167fd:bd9f9ba1:a61fafc4
             Name : diskfarm:750Graid5md  (local to host diskfarm)
            State : clean
      Device UUID : e916fc67:b8b7fc59:51440134:fa431d02
         Checksum : 43f9e7a4 - correct
           Events : 720
     Device Role : Active device 1
     Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
  /dev/sdj2:
       Array UUID : 88575f01:592167fd:bd9f9ba1:a61fafc4
             Name : diskfarm:750Graid5md  (local to host diskfarm)
            State : clean
      Device UUID : 0b847f84:83e80a3d:a0dc11e7:60bffc9f
         Checksum : 9522782b - correct
           Events : 177792
     Device Role : Active device 2
     Array State : A.A ('A' == active, '.' == missing, 'R' == replacing)
  /dev/sdl2:
       Array UUID : 88575f01:592167fd:bd9f9ba1:a61fafc4
             Name : diskfarm:750Graid5md  (local to host diskfarm)
            State : clean
      Device UUID : cc53440e:cb9180e4:be4c38d4:88a676eb
         Checksum : fef95256 - correct
           Events : 177794
     Device Role : Active device 0
     Array State : A.. ('A' == active, '.' == missing, 'R' == replacing)

Slice f2 looks great, but slices j2 & l2 seem to be missing -- even though
they are present.  Worse, the Events counter on sdf2 is frighteningly
small.  Where did it go?!?  So maybe I consider sdf2 failed and reassemble
from the other two [only] and then put f2 back in?

Definitely time to stop, take a deep breath, and ask for help :-)


TIA & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

