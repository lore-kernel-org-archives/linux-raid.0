From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: What to do when repair does not fix mismatch_cnt to 0 (2.6.25.1)?
Date: Sun, 11 May 2008 08:35:51 -0700
Message-ID: <e9c3a7c20805110835p3ac264dai9d02b4a0fc3afbce@mail.gmail.com>
References: <alpine.DEB.1.10.0805111038060.22970@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0805111038060.22970@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 11, 2008 at 7:39 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> p34:~# cat /sys/block/md3/md/mismatch_cnt
> 256
>
> p34:~# echo repair > /sys/block/md3/md/sync_action
>
> .. wait awhile ..
>
> md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3]
> sde1[2] sdd1[1] sdc1[0]
>      1318680576 blocks level 5, 1024k chunk, algorithm 2 [10/10]
> [UUUUUUUUUU]
>      [=================>...]  resync = 85.0% (124634296/146520064)
> finish=7.9min speed=46113K/sec
>
> .. done ..
>
> md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3]
> sde1[2] sdd1[1] sdc1[0]
>      1318680576 blocks level 5, 1024k chunk, algorithm 2 [10/10]
> [UUUUUUUUUU]
>
> now check again:
>
> p34:~# cat /sys/block/md3/md/mismatch_cnt
> 256
> p34:~#
>
> # uname -r
> 2.6.25.1
>
> Usually a reboot will take care of it but I would like to know the root
> cause of it and why repair does not fix it?
>

Because of this:
http://marc.info/?l=linux-raid&m=120976366020963&w=2

--
Dan
