From: Jan Wagner <jwagner@kurp.hut.fi>
Subject: Re: single RAID slower than aggregate multi-RAID?
Date: Wed, 20 Aug 2008 15:24:07 +0300 (EEST)
Message-ID: <alpine.DEB.1.10.0808201506440.7882@kurp.hut.fi>
References: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi> <18597.64737.508658.390657@notabene.brown> <alpine.DEB.1.10.0808181339010.365@kurp.hut.fi> <18601.25349.670500.530839@notabene.brown> <alpine.DEB.1.10.0808181501010.698@kurp.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0808181501010.698@kurp.hut.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

just thought I should re-post and add the 12disk raid0 stats here as well:

On Mon, 18 Aug 2008, Jan Wagner wrote:
> When I used '&' backgrounding the results were the same.
>
> But let's redo it, for completeness, three 4disk raid0 in parallel:
>
> oper@abidal:~$ sudo /usr/bin/time dd if=/dev/zero of=/dev/md0 bs=1024k 
> count=48000 &
> [1] 13283
> oper@abidal:~$ sudo /usr/bin/time dd if=/dev/zero of=/dev/md1 bs=1024k 
> count=48000 &
> [2] 13286
> oper@abidal:~$ sudo /usr/bin/time dd if=/dev/zero of=/dev/md2 bs=1024k 
> count=48000 &
> [3] 13288
>
> 48000+0 records in
> 48000+0 records out
> 50331648000 bytes (50 GB) copied, 218.485 s, 230 MB/s
> 0.07user 147.77system 3:38.50elapsed 67%CPU (0avgtext+0avgdata 0maxresident)k
> 48inputs+98304008outputs (1major+520minor)pagefaults 0swaps
> 48000+0 records in
> 48000+0 records out
> 50331648000 bytes (50 GB) copied, 218.206 s, 231 MB/s
> 0.05user 145.51system 3:38.20elapsed 66%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+98304008outputs (0major+521minor)pagefaults 0swaps
> 48000+0 records in
> 48000+0 records out
> 50331648000 bytes (50 GB) copied, 218.895 s, 230 MB/s
> 0.06user 137.92system 3:38.89elapsed 63%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+98304008outputs (0major+520minor)pagefaults 0swaps

And a single 12disk raid0:

oper@abidal:~$ sudo /usr/bin/time dd if=/dev/zero of=/dev/md0 bs=1024k
48000+0 records in
48000+0 records out
50331648000 bytes (50 GB) copied, 106.334 s, 473 MB/s
0.10user 90.41system 1:46.38elapsed 85%CPU (0avgtext+0avgdata 
0maxresident)k
88inputs+98304000outputs (2major+526minor)pagefaults 0swaps

The Dirty/Writeback values were at 
http://www.metsahovi.fi/~jwagner/10g-tests/pmp/linux-raid-1.txt

For the 3 x 4disk raid0s the values were ~390MB Writeback and ~14MB 
Dirty. Aggretate write rate 690MB/sec.

For the 1 x 12disk raid0 just ~14MB Writeback and ~190MB Dirty. Write 
rate 473 MB/sec.

Didn't mention before but the kernel is the Ubuntu 2.6.24-19-generic SMP, 
and it is on a 4 core system. I also booted with 'nosmp', but all the 
write rates were approximately the same.

Do you have any more thoughts or possible tests?

Perhaps I should read up on a kernel profiling howto...?

Kind regards,
  - Jan
