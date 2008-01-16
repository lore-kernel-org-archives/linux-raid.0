From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: How do I get rid of old device?
Date: Wed, 16 Jan 2008 18:13:19 -0500 (EST)
Message-ID: <alpine.DEB.0.999999.0801161812150.4374@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161808010.4374@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0801161808010.4374@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Wed, 16 Jan 2008, Justin Piszcz wrote:

> p34:~# mdadm /dev/md3 --zero-superblock
> p34:~# mdadm --examine --scan
> ARRAY /dev/md0 level=raid1 num-devices=2 
> UUID=f463057c:9a696419:3bcb794a:7aaa12b2
> ARRAY /dev/md1 level=raid1 num-devices=2 
> UUID=98e4948c:c6685f82:e082fd95:e7f45529
> ARRAY /dev/md2 level=raid1 num-devices=2 
> UUID=330c9879:73af7d3e:57f4c139:f9191788
> ARRAY /dev/md3 level=raid0 num-devices=10 
> UUID=6dc12c36:b3517ff9:083fb634:68e9eb49
> p34:~#
>
> I cannot seem to get rid of /dev/md3, its almost as if there is a piece of it 
> on the root (2) disks or reference to it?
>
> I also dd'd the other 10 disks (non-root) and /dev/md3 persists.
>
>
>
Hopefully this will clear it out:

p34:~# for i in /dev/sd[c-l]; do /usr/bin/time dd if=/dev/zero of=$i bs=1M 
&  done
[1] 4625
[2] 4626
[3] 4627
[4] 4628
[5] 4629
[6] 4630
[7] 4631
[8] 4632
[9] 4633
[10] 4634
p34:~#

Good aggregate bandwidth at least writing to all 10 disks.

procs -----------memory---------- ---swap-- -----io---- -system------cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  1  9      0  46472 7201008  73424    0    0     0 658756 2339 2242  0 22 24 54
  3 10      0  44132 7204680  73292    0    0     0 660040 2335 2276  0 22 19 59
  5  8      0  48196 7201840  73736    0    0     0 652708 2403 1645  0 23 11 66
  2  9      0  45728 7205036  72628    0    0     0 659844 2296 1891  0 23 11 66
  0 11      0  47672 7202992  72564    0    0     0 672856 2327 1616  0 22  7 71

