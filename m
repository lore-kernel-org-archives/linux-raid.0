Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F84C4321E
	for <linux-raid@archiver.kernel.org>; Tue, 29 Nov 2022 22:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiK2W4O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Nov 2022 17:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbiK2W4N (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Nov 2022 17:56:13 -0500
X-Greylist: delayed 397 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Nov 2022 14:56:09 PST
Received: from hoggar.fisica.ufpr.br (hoggar.fisica.ufpr.br [IPv6:2801:82:80ff:7fff::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3B1E9
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 14:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=fisica.ufpr.br;
        s=201705; t=1669762167;
        bh=BWWmYY6FcGvubWpHVpTYKST0ESEORjvSzm7Wv7QYrjI=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=FI2yVBDg/H6KBze72DZZaHDG7YXP8d+At7tMueAqPM/EKV6SyUzToIdQ+I85zFBQ8
         2pOMj5fX1fDU7HIEkOZNbyZpOdHFhgKgi8BJwKISTqGxfEDLoFKWQFg9iC0QIwgsf4
         hvHUj8moIxDyQiEVaoqw0H1y32JcfcxlR6ZVYSzD/PqodGQhGnB4YiAlxyAlpPtvbl
         E8Kf3xwHrstsx9MgzuM/d/R4AQCKsULFywN314Bm0xcg5B0FsU8IaVkcIkgCfa1Ce8
         D1OnNDvSofJHdkfiSFG9GFIHMhnL5ZcvDXblBWuEm9iCQSzQp1M5/4Itkyp6z54Xm6
         qWMh42cZE1wdw==
Received: by hoggar.fisica.ufpr.br (Postfix, from userid 577)
        id 4BE3B3620280; Tue, 29 Nov 2022 19:49:27 -0300 (-03)
Date:   Tue, 29 Nov 2022 19:49:27 -0300
From:   Carlos Carvalho <carlos@fisica.ufpr.br>
To:     linux-raid@vger.kernel.org
Subject: Re: Fwd: Recover RAID5
Message-ID: <Y4aMd76c2vo5Wvd2@fisica.ufpr.br>
References: <CAA0v=OA8LS0s7G8CHK_0oL=nh49_H4G26-r85GgZLOAtbb3WOg@mail.gmail.com>
 <CAA0v=OANGnih6sxB6TTdynA0BbSOhyaMpfvW2O1KSSTws76AtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAA0v=OANGnih6sxB6TTdynA0BbSOhyaMpfvW2O1KSSTws76AtQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Samuel Lopes (samuelblopes@gmail.com) wrote on Mon, Nov 28, 2022 at 08:33:31PM -03:
> Then I run:
> 
> mdadm -v --create /dev/md5 --level=5 --chunk=512K --metadata=1.2
> --layout=left-symmetric --data-offset=262144s --raid-devices=6
> /dev/sdn1 /dev/sdj1 /dev/sdl1 /dev/sdm1 /dev/sdo1 /dev/sdr1
> --assume-clean
> 
> I'm not sure about the data-offset but that value makes the array size
> match the old --detail output

Well... You'd have to know it exactly. It's strange it's needed, shouldn't be
unless de original command used it. The mdadm versions should also be the same.

You can try to compare the the output of mdadm -E of the disks you know are
good and the new/failed ones to see if there are differences.

Besides this the only suggestion I have is to try different values of
data-offset (starting without this option) to see if any of them makes the
array mountable. Even so the risk of corruption is high, you should fsck.

If you want high reliability the whole installation process is bad, starting
from raid5 use. Next time don't do this way...
