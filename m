From: Jim Paris <jim@jtan.com>
Subject: Re: RAID-6: help wanted
Date: Sun, 24 Oct 2004 02:46:51 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041024064651.GA5343@jim.sh>
References: <cleqh6$ps4$1@terminus.zytor.com> <417B3CF9.7090107@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <417B3CF9.7090107@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >There is currently a data-corruption bug in the RAID-6 md layer
> >(raid6main.c).  I have so far not been successful in locating it,
> >although it is easily reproducible, thanks to a set of scripts by Jim
> >Paris.  I suspect it is a race condition between raid6d and the rest
> >of the kernel.
> 
> Great, can we get a copy of the scripts to try and assist?

Sure:

---

Date: Fri, 6 Aug 2004 00:04:39 -0400
From: Jim Paris <jim@jtan.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: Kernel panic, FS corruption  Was: Re: Call for RAID-6 users

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
