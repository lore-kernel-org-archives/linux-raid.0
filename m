From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: AWFUL reshape speed with raid5.
Date: Mon, 28 Jul 2008 14:14:21 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What happens if you use 0.90 superblocks?

Also, are these sata ports on the mobo or sata ports on a pci-based mobo?

On Mon, 28 Jul 2008, Jon Nelson wrote:

> I built a raid5 with 2 devices (and --assume-clean) using 2x 4GB
> partitions (not logical volumes).
> I then grew it to 3 devices.
> The reshape speed is really really slow.
>
> vmstat shows I/O like this:
>
> 0  0    212  25844 141160 497484    0    0     0   612  673 1284  0  6 93  0
> 0  0    212  25164 141160 497748    0    0     0    19  594 1253  1  4 95  0
> 0  0    212  25044 141160 498004    0    0     0     0  374  445  0  1 99  0
> 1  0    212  25220 141164 498000    0    0     0    23  506 1149  0  3 96  1
> 0  0    212  25500 141164 498004    0    0     0     3  546 1416  0  5 95  0
>
> The min/max is 1000/200000.
> What might be going on here?
>
> Kernel is 2.6.25.11 (openSUSE 11.0 x86-64 stock)
>
> /proc/mdstat for this entry:
>
> md99 : active raid5 sdd3[2] sdc3[1] sdb3[0]
>      3903744 blocks super 1.0 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>      [=>...................]  reshape =  8.2% (324224/3903744)
> finish=43.3min speed=1373K/sec
>
>
> This is on a set of devices capable of 70+ MB/s.
>
> No meaningful change if I start with 3 disks and grow to 4, with or
> without bitmap.
>
> -- 
> Jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
