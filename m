Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750A3C64E7B
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 20:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 306F82074A
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 20:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgK3UNO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 15:13:14 -0500
Received: from u17383850.onlinehome-server.com ([74.208.250.170]:59846 "EHLO
        u17383850.onlinehome-server.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727328AbgK3UNO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 15:13:14 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2020 15:13:14 EST
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id C125279D; Mon, 30 Nov 2020 15:05:03 -0500 (EST)
Date:   Mon, 30 Nov 2020 15:05:03 -0500
From:   David T-G <davidtg-robot@justpickone.org>
To:     linux-raid@vger.kernel.org
Subject: re: partitions & filesystems (was "Re: ???root account locked???
 after removing one RAID1 hard disc")
Message-ID: <20201130200503.GV1415@justpickone.org>
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello!

...and then c.buhtz@posteo.jp said...
% 
...
% /dev/sdc (as discs without partitions) are configured as RAID1

This is fine, although it makes me queasy; I always create a partition
table and use a partition as a RAID device, and I leave a sliver at the
back end to hold useful information when the array is completely toasted.
But that's just me :-)


% /dev/md127 and formated with ext4 and mounted to /Daten. I can read
% and write without any problems to the RAID.

On the other hand, this part is interesting ...


% 
...
% 
% Here is the output of my fdisk -l. Interesting here is that
% /dv/md127 is shown but without its filesysxtem.
% 
...
% >Disk /dev/md127: 8 GiB, 8580497408 bytes, 16758784 sectors
% >Units: sectors of 1 * 512 = 512 bytes
% >Sector size (logical/physical): 512 bytes / 512 bytes
% >I/O size (minimum/optimal): 512 bytes / 512 bytes
% 
...
% >/dev/md127 on /Daten type ext4 (rw,relatime)
% 
...
% >UUID=65ec95df-f83f-454e-b7bd-7008d8055d23 /               ext4
% >errors=remount-ro 0       1
% >
% >/dev/md127  /Daten      ext4    defaults    0   0

You don't see any "filesystem" or, more correctly, partition in your

  fdisk -l

output because you have apparently created your filesystem on the entire
device (hey, I didn't know one could do that!).  That conclusion is
supported by your mount point (/dev/md127 rather than /dev/md127p1 or
similar) and your fstab entry (same).

So the display isn't interesting, although the logic behind that approach
certainly is to me.


HTH & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

