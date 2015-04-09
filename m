From: Dave Chinner <david@fromorbit.com>
Subject: Re: interesting MD-xfs bug
Date: Fri, 10 Apr 2015 08:18:46 +1000
Message-ID: <20150409221846.GG13731@dastard>
References: <5526E8E9.3030805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5526E8E9.3030805@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: xfs <xfs@oss.sgi.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 09, 2015 at 05:02:33PM -0400, Joe Landman wrote:
> If I build an MD raid0 with a non power of 2 chunk size, it appears
> that I can mkfs.xfs a file system, but it doesn't show up in blkid
> and is not mountable.  Yet, using a power of 2 chunk size, this does
> work correctly.   This is kernel 3.18.9.
> 
> 
> For example, non-power of 2 chunk:
> 
> root@unison:~# wipefs -a /dev/sdb
> 4 bytes were erased at offset 0x1000 (linux_raid_member)
> they were: fc 4e 2b a9
> root@unison:~# wipefs -a /dev/sda
> 4 bytes were erased at offset 0x1000 (linux_raid_member)
> they were: fc 4e 2b a9
> root@unison:~# mdadm --create /dev/md20 --level=0 --metadata=1.2
> --chunk=1152 --auto=yes --raid-disks=2 /dev/sd[ab]
> mdadm: array /dev/md20 started.
> 
> root@unison:~# mkfs.xfs /dev/md20
> log stripe unit (1179648 bytes) is too large (maximum is 256KiB)
> log stripe unit adjusted to 32KiB
> meta-data=/dev/md20              isize=256    agcount=50,
> agsize=268435296 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=13164865984, imaxpct=5
>          =                       sunit=288    swidth=576 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> root@unison:~# blkid | grep xfs

That looks more like a blkid or udev problem. try using blkid -p so
that it doesn't look up the cache but directly probes devices for
the signatures. strace might tell you a bit more, too. And if the
filesystem mounts, then it definitely isn't an XFS problem ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
