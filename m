From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: MD/RAID1 Large File Support
Date: Mon, 12 May 2003 16:55:18 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0305121649090.31347-100000@router.windsormachine.com>
References: <EC803175C921D411BCE2000000006429081C363F@ash-exch_lg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EC803175C921D411BCE2000000006429081C363F@ash-exch_lg>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 12 May 2003, Duncan, Mike wrote:

> $ cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 hdb2[1] hda2[0]
>       38925376 blocks [2/2] [UU]
> unused devices: <none>

You probably want to consider moving hdb to hdc, as if either hda or hdb
should die, it will likely take down the bus that the other drive is
sitting on.

As well, a controller failure(rare), will take both drives offline.

> md.o or raid1.o as being the culprit.

I ran a raid5 on the main backup server here, and it handled >2GB files
via both ssh and smbtar, and everything else.  I also had another system
running a software raid1, and it handled large files as well now that I
think of it.

Debian 3.0r1 though on both, with a custom built 2.4.20 kernel.

The one machine now runs a 4x250gb 3ware 7500-4 raid5 array though, and
the other is a 2x40 3ware 7000-2 raid 1, so I can't double check for
you with software raid.

Mike

