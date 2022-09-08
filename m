Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC09C54EE9
	for <linux-raid@archiver.kernel.org>; Thu,  8 Sep 2022 14:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbiIHOwr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Sep 2022 10:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiIHOwa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Sep 2022 10:52:30 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BFB1223A2
        for <linux-raid@vger.kernel.org>; Thu,  8 Sep 2022 07:52:27 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p18so18120181plr.8
        for <linux-raid@vger.kernel.org>; Thu, 08 Sep 2022 07:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=NT8pFe8DS6wtnbv2yHYTCWSten605vvSuplkcKIiyyA=;
        b=ogmnwLdLsU2uWbRkw2x0q/05/vinyH1xE5YApy3sGCddv5tJJuiC/ib+I5g7OLEm+J
         iTf2hyawHk19XdUbiHKTdgSr9/wio5rbE9WcXorSUq4bTyYyPq7RPkz+mvAecI6ATdmi
         ag+esPLQD0cllJ9jrATPc43zFmjuwRQ+H6Ey9vxGFGLywO2C7zPmV9uV0svwxP2Q6mMK
         W2brNbWmLPpK8hgIwkFt8NHPzManKmTjAqAlJaRxiYgpSVF5+dPdvaLWYSiE6jWpUVmu
         dlzaksPxrYZZP2q6LIn9nXSW2kpLDeg5RCZlA+zQ+CqkW4IDoi7G1HEDtt3r8cL/Cosu
         K0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=NT8pFe8DS6wtnbv2yHYTCWSten605vvSuplkcKIiyyA=;
        b=NV9TvS3D1cxM1k2j/PDK84Wr3dREckr6/3saZn7ljA0H7Wv7muXMOfdp7pTfk+/LEr
         xYFvB4aGp5cZTUjIEi6Xr8VICewK0M3lePnRJ9O7HBFFum9P5BIOI6GYS0ByeAqmDdEK
         jxPbLY4NTQ5h9p+qpNYcCQtEzniuBAlnwbQ/n0MLeFQgEIFVV+5ZGwCFtR/E+/dobm8t
         c7AQBBZweUIKuCJIMczhd54E5ZdW2BBxNepHdxxdp8R8qW/RDU3iFNTSkNlZ4+TvgK6n
         1XHLe4hk23dOFjUK8g42+ea+tRVNPMinWZKKWnhDSiPS06Zzu+7V64Vq49ei4FvNMwh7
         lpQQ==
X-Gm-Message-State: ACgBeo3W8XIdLmKOhes7dePOc2tTkWHIKrYDreIe9K/uAAgo8IN6vU/G
        8gAApsXjwUym2YEmK1VXz97A3jStlhdP7uVj5AlDAOepDmQ=
X-Google-Smtp-Source: AA6agR6HU70kQb21/XZRzwGE6V7//hHMA+6Z1s1AK8ScJ3QR9KYphVwm0k+z2UEs/jrdrusR5dkAP9QcqGq50sIVHQg=
X-Received: by 2002:a17:90a:6784:b0:200:36ea:fe58 with SMTP id
 o4-20020a17090a678400b0020036eafe58mr4533067pjj.16.1662648746471; Thu, 08 Sep
 2022 07:52:26 -0700 (PDT)
MIME-Version: 1.0
From:   Luigi Fabio <luigi.fabio@gmail.com>
Date:   Thu, 8 Sep 2022 10:51:50 -0400
Message-ID: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
Subject: RAID5 failure and consequent ext4 problems
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[also on linux-ext4]

I am encountering an unusual problem after an mdraid failure, I'll
summarise briefly and can provide further details as required.

First of all, the context. This is happening on a Debian 11 system,
amd64 arch, with current updates (kernel 5.10.136-1, util-linux
2.36.1).

The system has a 12 drive mdraid RAID5 for data, recently migrated to
LSI 2308 HBAs.
This is relevant because earlier this week, at around 13,00 local (EST), four
drives, an entire HBA channel, decided to drop from the RAID.

Of course, mdraid didn't like that and stopped the arrays. I reverted
to best practice and shut down the system first of all.

Further context: the filesystem in the array is ancient - I am vaguely
proud of that - from 2001.
It started as ext2, grew to ext3, then to ext4 and finally to ext4 with 64 bits.
Because I am paranoid, I always mount ext4 with nodelalloc and data=journal.
The journal is external on a RAID1 of SSDs.
I recently (within the last ~3 months) enabled metadata_csum, which is
relevant to the following - the filesystem had never had metadata_csum
enabled before.

Upon reboot, the arrays would not reassemble - this is expected,
because 4/12 drives were marked faulty. So I re--created the array
using the same parameters as were used back when the array was built.
Unfortunately, I had a moment of stupid and didn't specify metadata
0.90 in the re--create, so it was recreated with metadata 1.2... which
writes its data block at the beginning of the components, not at the
end. I noticed it, restopped the array and recreated with the correct
0.90, but the damage was done: the 256 byte + 12 * 20 header was
written at the beginning of each of the 12 components.
Still, unless I am mistaken, this just means that at worst 12x (second
block of each component) were damaged, which shouldn't be too bad. The
only further possibility is that mdraid also zeroed out the 'blank
space' that it puts AFTER the header block and BEFORE the data, but
according to documentation it shouldn't do that.
In any case, I subsequently reassembled the array 'correctly' to match
the previous order and settings and I believe I got it right. I kept
the array RO and tried fsck -n, which gave me this:

ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
fsck.ext4: Group descriptors look bad... trying backup blocks...

It then warns that it won't attempt journal recovery because it's in
RO mode and declares the fs clean - with a reasonable looking number
of files and blocks.

If I try to mount -t ext4 -o ro, I get :

mount: /mnt: mount(2) system call failed: Structure needs cleaning.

so before anything else, I tried fsck -nf to make sure that the REST
of the filesystem is in one logical piece.
THAT painted a very different picture:
On pass 1, I get approximately 980k (almost 10^6) of
Inode nnnnn passes checks, but checksum does not match inode
and ~ 2000
Inode nnnnn contains garbage
Plus some 'tree not optimised' which are technically not errors, from
what I understand.
After ~11 hours, it switches to 1b, tells me that inode 12 has a long
list of duplicate blocks

Running additional passes to resolve blocks claimed by more than one inode...
Pass 1B: Rescanning for multiply-claimed blocks
Multiply-claimed block(s) in inode 12: 2928004133 [....]

And ends after the list of multiply claimed blocks with:

e2fsck: aborted
Error while scanning inodes (8193): Inode checksum does not match inode

/dev/md123: ********** WARNING: Filesystem still has errors **********


/dev/md123: ********** WARNING: Filesystem still has errors **********

So, what is my next step? I realise I should NOT have touched the
original drives and dd-ed images to a separate array to work on those,
but I believe the only writing that occurred were the mdraid
superblocks. I am, in any case, grabbing more drives to image the
'faulty' array and work on the images, leaving the original data
alone.

Where do I go from here? I have had similar issues in the past, all
the way back to the early 00s, and I had a near-100% success rate by
re--creating the arrays. What is different this time?
Or, is nothing different and is the problem just in the checksumming?

Thanks!
