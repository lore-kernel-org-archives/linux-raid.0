From: Jim Paris <jim@jtan.com>
Subject: Re: Kernel panic, FS corruption  Was: Re: Call for RAID-6 users
Date: Fri, 6 Aug 2004 00:04:39 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040806040439.GA21258@jim.sh>
References: <cds76e$ee7$1@terminus.zytor.com> <200407310228.27969.maarten@ultratux.net> <200408011503.20452.maarten@ultratux.net> <20040801180536.GA3897@jim.sh> <ceuhbm$rgs$1@terminus.zytor.com> <20040806001909.GA19760@jim.sh> <4112D2A1.9000001@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4112D2A1.9000001@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> If you can reproduce it with ext2/3 it would make debugging simpler, 
> because I understand the ext code and data structures a lot better.

This demonstrates it on ext2.  I can't seem to reproduce it with just
simple use of 'dd', but it shows up if I untar a ton of data.

This script:
- creates five 100MB "disks" through loopback
- puts them in a six-disk RAID-6 array (resulting size=400MB, degraded)
- untars about 350MB of data to the array
- runs e2fsck, which shows filesystem errors

Usage: 
- put r6ext.sh and big.tar.bz2 in a directory
- run r6ext.sh as root

Sorry for the huge files, but e2fsck didn't show any problems when I
scaled everything down by a factor of 10.  You could probably make
your own big.tar.bz2 and see the same problem, as there's nothing
special about this data.

  http://stonewall.mit.edu/~jim/r6ext.sh
  http://stonewall.mit.edu/~jim/big.tar.bz2 (77MB)

-jim
