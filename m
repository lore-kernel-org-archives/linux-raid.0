From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: AWFUL reshape speed with raid5.
Date: Wed, 20 Aug 2008 21:58:03 -0500
Message-ID: <cccedfc60808201958q2585f155sf7382efbb173cfb1@mail.gmail.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 28, 2008 at 12:39 PM, Jon Nelson
<jnelson-linux-raid@jamponi.net> wrote:
> I built a raid5 with 2 devices (and --assume-clean) using 2x 4GB
> partitions (not logical volumes).
> I then grew it to 3 devices.
> The reshape speed is really really slow.
>
> vmstat shows I/O like this:
>
>  0  0    212  25844 141160 497484    0    0     0   612  673 1284  0  6 93  0
>  0  0    212  25164 141160 497748    0    0     0    19  594 1253  1  4 95  0
>  0  0    212  25044 141160 498004    0    0     0     0  374  445  0  1 99  0
>  1  0    212  25220 141164 498000    0    0     0    23  506 1149  0  3 96  1
>  0  0    212  25500 141164 498004    0    0     0     3  546 1416  0  5 95  0
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

I found some time to give this another shot.
It's still true!

Here is how I built the array:

mdadm --create /dev/md99 --level=raid5 --raid-devices=2
--spare-devices=0 --assume-clean --metadata=1.0 --chunk=64 /dev/sdb3
/dev/sdc3

and then I added a drive:

mdadm --add /dev/md99 /dev/sdd3

and then I grew the array to 3 devices:

mdadm --grow /dev/md99 --raid-devices=3

This is what the relevant portion of /proc/mdstat looks like:

md99 : active raid5 sdd3[2] sdc3[1] sdb3[0]
      3903744 blocks super 1.0 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      [=>...................]  reshape =  6.1% (241920/3903744)
finish=43.0min speed=1415K/sec

The 1000/200000 min/max defaults are being used.
If I bump up the min to, say, 30000, the rebuild speed does grow to
hover around 30000.

As Justin Piszcz said:

There once was a bug in an earlier kernel, in which the min_speed is
what the rebuild ran at if you had a specific chunk size, have you
tried to echo 30000 > to min_speed?  Does it increase it to 30mb/s for
the rebuild?

Yes, apparently, it does. However, 'git log drivers/md' in the
linux-2.6 tree doesn't show anything obvious for me. Can somebody
point me to a specific commit, patch, etc... because as of 2.6.25.11
it's apparently still a problem (on an otherwise idle system, too).







>
> No meaningful change if I start with 3 disks and grow to 4, with or
> without bitmap.
>
> --
> Jon
>



-- 
Jon
