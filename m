From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: fsck out of memory
Date: Fri, 7 Feb 2003 10:24:42 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030207102442.O18636@schatzie.adilger.int>
References: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu>; from kernel@ddx.a2000.nu on Fri, Feb 07, 2003 at 04:17:35PM +0100
To: kernel@ddx.a2000.nu
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Feb 07, 2003  16:17 +0100, kernel@ddx.a2000.nu wrote:
> i'm trying to run e2fsk after a system hang
> after 1 hour running (70%) which had a memory usage for about 128M
> i get these errors in the dmesg :
> 
> Out of Memory: Killed process 732 (fsck.ext2).
> Out of Memory: Killed process 732 (fsck.ext2).
> Out of Memory: Killed process 732 (fsck.ext2).
> Out of Memory: Killed process 732 (fsck.ext2).
> 
> I really wonder if there is something wrong with e2fsk ?
> does it really need that much memory ?
> (fsck on 2.2TB /dev/md0)

I don't think many people have run e2fsck on such a large filesystem
before when there are lots of problems.  It is entirely possible that
you need so much memory for such a large filesystem.  I would suggest
creating a larger swap file temporarily (on some other partition) so
that e2fsck can complete.

It _may_ be that e2fsck could reduce memory consumption somewhere (or
enable a "use less memory but run slowly" heuristic, but that isn't
very likely, or if it was it would be very slow.

Regarding the "use fsck.ext3" response - ignore it, it is incorrect.
There is no difference at all between fsck.ext2, fsck.ext3, e2fsck.

Cheers, Andreas
--
Andreas Dilger
http://sourceforge.net/projects/ext2resize/
http://www-mddsp.enel.ucalgary.ca/People/adilger/
