From: Neil Brown <neilb@suse.de>
Subject: Re: AWFUL reshape speed with raid5.
Date: Fri, 1 Aug 2008 11:26:22 +1000
Message-ID: <18578.26174.118449.299867@notabene.brown>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday July 28
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday July 28, jnelson-linux-raid@jamponi.net wrote:
> I built a raid5 with 2 devices (and --assume-clean) using 2x 4GB
> partitions (not logical volumes).
> I then grew it to 3 devices.
> The reshape speed is really really slow.
...
> 
> Kernel is 2.6.25.11 (openSUSE 11.0 x86-64 stock)
> 
> /proc/mdstat for this entry:
> 
> md99 : active raid5 sdd3[2] sdc3[1] sdb3[0]
>       3903744 blocks super 1.0 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>       [=>...................]  reshape =  8.2% (324224/3903744)
> finish=43.3min speed=1373K/sec
> 


1.3MB/sec is certainly slow.  On my test system (which is just a bunch
of fairly ordinary SATA drives in a cheap controller) I get about 10
times this - 13MB/sec.

> 
> This is on a set of devices capable of 70+ MB/s.

The 70MB/s is streaming IO.  When doing a reshape like this, md/raid5
need to read some data, then go back and write it somewhere else.  So
there is lots of seeking backwards and forwards.

You can possibly increase the speed somewhat by increasing the buffer
space that is used, thus allowing larger reads followed by larger
writes.  This is done by increasing
       /sys/block/mdXX/md/stripe_cache_size

Still, 1373K/sec is very slow.  I cannot explain that.

NeilBrown
