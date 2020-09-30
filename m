Return-Path: <SRS0=vpcD=DH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4956C4727C
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 01:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9DB720738
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 01:49:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=madore.org header.i=@madore.org header.b="hxz5lnVY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgI3BtF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Sep 2020 21:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbgI3BtF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Sep 2020 21:49:05 -0400
X-Greylist: delayed 511 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Sep 2020 18:49:05 PDT
Received: from achernar.gro-tsen.net (achernar6.gro-tsen.net [IPv6:2001:bc8:30e8::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31E29C061755
        for <linux-raid@vger.kernel.org>; Tue, 29 Sep 2020 18:49:05 -0700 (PDT)
Received: by achernar.gro-tsen.net (Postfix, from userid 500)
        id 1BF1D2140517; Wed, 30 Sep 2020 03:40:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=madore.org;
        s=achernar; t=1601430033;
        bh=OTAeH8uY3lQic1r3ClvJyjkp8AshwjfsmtdSm8BnXRc=;
        h=Date:From:To:Subject:From;
        b=hxz5lnVYkWXdBQD3tEpsmtBR5A50K7EnrABN5I/jKbBYf49BsLhK94twAXc8cO2Wz
         ZrUCh/w9qfg4Yz+tWpCv8KV8VUZao072I2nezPQF/W8M4Eihlbwh3mSM10Hd10Jpo8
         YGFWbLQ/c2qh2p3/ky9lKkvHpKOO5G+mLk/GXIXY=
Date:   Wed, 30 Sep 2020 03:40:33 +0200
From:   David Madore <david+ml@madore.org>
To:     Linux RAID mailing-list <linux-raid@vger.kernel.org>
Subject: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
Message-ID: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear list,

[The following was originally posted to LKML, and I've been told this
list was a more appropriate place for this kind of report.
Apologies.]

I'm trying to reshape a 3-disk RAID5 array to a 4-disk RAID6 array (of
the same total size and per-device size) using linux kernel 4.9.237 on
x86_64.  I understand that this reshaping operation is supposed to be
supported.  But it appears perpetually stuck at 0% with no operation
taking place whatsoever (the slices are unchanged apart from their
metadata, the backup file contains only zeroes, and nothing happens).
I wonder if this is a know kernel bug, or what else could explain it,
and I have no idea how to debug this sort of thing.

Here are some details on exactly what I've been doing.  I'll be using
loopbacks to illustrate, but I've done this on real partitions and
there was no difference.

## Create some empty loop devices:
for i in 0 1 2 3 ; do dd if=/dev/zero of=test-${i} bs=1024k count=16 ; done
for i in 0 1 2 3 ; do losetup /dev/loop${i} test-${i} ; done
## Make a RAID array out of the first three:
mdadm --create /dev/md/test --level=raid5 --chunk=256 --name=test \
  --metadata=1.0 --raid-devices=3 /dev/loop{0,1,2}
## Populate it with some content, just to see what's going on:
for i in $(seq 0 63) ; do printf "This is chunk %d (0x%x).\n" $i $i \
  | dd of=/dev/md/test bs=256k seek=$i ; done
## Now try to reshape the array from 3-way RAID5 to 4-way RAID6:
mdadm --manage /dev/md/test --add-spare /dev/loop3
mdadm --grow /dev/md/test --level=6 --raid-devices=4 \
  --backup-file=test-reshape.backup

...and then nothing happens.  /proc/mdstat reports no progress
whatsoever:

md112 : active raid6 loop3[4] loop2[3] loop1[1] loop0[0]
      32256 blocks super 1.0 level 6, 256k chunk, algorithm 18 [4/3] [UUU_]
      [>....................]  reshape =  0.0% (1/16128) finish=1.0min speed=244K/sec

The loop file contents are unchanged except for the metadata
superblock, the backup file is entirely empty, and no activity
whatsoever is happening.

Actually, further investigation shows that the array is in fact
operational as a RAID6 array, but one where the Q-syndrome is stuck in
the last device: writing data to the md device (e.g., by repopulating
it with the same command as above) does cause loop3 to be updated as
expected for such a layout.  It's just the reshaping which doesn't
take place (or indeed begin).

For completeness, here's what mdadm --detail /dev/md/test looks like
before the reshape, in my example:

/dev/md/test:
        Version : 1.0
  Creation Time : Wed Sep 30 02:42:30 2020
     Raid Level : raid5
     Array Size : 32256 (31.50 MiB 33.03 MB)
  Used Dev Size : 16128 (15.75 MiB 16.52 MB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Wed Sep 30 02:44:21 2020
          State : clean 
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 256K

           Name : vega.stars:test  (local to host vega.stars)
           UUID : 30f40e34:b9a52ff0:75c8b063:77234832
         Events : 20

    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1
       3       7        2        2      active sync   /dev/loop2

       4       7        3        -      spare   /dev/loop3

- and here's what it looks like after the attempted reshape has
started (or rather, refused to start):

/dev/md/test:
        Version : 1.0
  Creation Time : Wed Sep 30 02:42:30 2020
     Raid Level : raid6
     Array Size : 32256 (31.50 MiB 33.03 MB)
  Used Dev Size : 16128 (15.75 MiB 16.52 MB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Wed Sep 30 02:44:54 2020
          State : clean, degraded, reshaping 
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 256K

 Reshape Status : 0% complete
     New Layout : left-symmetric

           Name : vega.stars:test  (local to host vega.stars)
           UUID : 30f40e34:b9a52ff0:75c8b063:77234832
         Events : 22

    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1
       3       7        2        2      active sync   /dev/loop2
       4       7        3        3      spare rebuilding   /dev/loop3

I also tried writing "frozen" and then "resync" to the
/sys/block/md112/md/sync_action file with no further results.

I welcome any suggestions on how to investigate, work around, or fix
this problem.

Happy hacking,

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
