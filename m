From: "Matthew Simpson" <matthew@symatec-computer.com>
Subject: Re: Force RAID1 as clean
Date: Tue, 6 Jan 2004 08:39:27 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001501c3d462$e3409590$0100a8c0@KARI>
References: <yw1xn091zuwy.fsf@ford.guide>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2.4.18 here and I'm also getting about 1MBs/sec on resynch.  :(

----- Original Message -----=20
=46rom: "M=E5ns Rullg=E5rd" <mru@kth.se>
To: <linux-raid@vger.kernel.org>
Sent: Monday, January 05, 2004 8:13 PM
Subject: Force RAID1 as clean


>
> Is there a way to forcibly mark a RAID1 as clean?  I know it can be
> dangerous, I just don't want to wait for 200GB of scrap to resync.
>
> For some reason, the resync is terribly slow in Linux 2.6.0, only
> ~1MB/s.  DMA is enabled on all disks and the individual performance o=
f
> each disk is normal.  There are no error messages from the kernel.  I=
t
> just doesn't seem right.
>
> --=20
> M=E5ns Rullg=E5rd
> mru@kth.se
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
