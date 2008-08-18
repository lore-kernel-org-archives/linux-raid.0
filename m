From: Jan Wagner <jwagner@kurp.hut.fi>
Subject: Re: single RAID slower than aggregate multi-RAID?
Date: Mon, 18 Aug 2008 15:27:31 +0300 (EEST)
Message-ID: <alpine.DEB.1.10.0808181501010.698@kurp.hut.fi>
References: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi> <18597.64737.508658.390657@notabene.brown> <alpine.DEB.1.10.0808181339010.365@kurp.hut.fi> <18601.25349.670500.530839@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18601.25349.670500.530839@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Mon, 18 Aug 2008, Neil Brown wrote:
>> http://www.metsahovi.fi/~jwagner/10g-tests/pmp/linux-raid-1.txt
>
> you appear to be doing the write tests to the three small arrays in
> series, one after the other.
> You need to do them in parallel to find the aggregate bandwidth of the
> system.
> i.e.  run
>
> sudo /usr/bin/time dd if=/dev/zero of=/dev/md0 bs=1024k count=48000 &
> sudo /usr/bin/time dd if=/dev/zero of=/dev/md1 bs=1024k count=48000 &
> sudo /usr/bin/time dd if=/dev/zero of=/dev/md2 bs=1024k count=48000 &
>
> all at once in the background.  What does that produce?

Sorry, I forgot to mention this in the .txt file: all the three tests 
were in fact running in parallel, just on different xterm terminals. The 
.txt is a copypaste from the three terminals.

When I used '&' backgrounding the results were the same.


But let's redo it, for completeness:

oper@abidal:~$ sudo /usr/bin/time dd if=/dev/zero of=/dev/md0 bs=1024k count=48000 &
[1] 13283
oper@abidal:~$ sudo /usr/bin/time dd if=/dev/zero of=/dev/md1 bs=1024k count=48000 &
[2] 13286
oper@abidal:~$ sudo /usr/bin/time dd if=/dev/zero of=/dev/md2 bs=1024k count=48000 &
[3] 13288

48000+0 records in
48000+0 records out
50331648000 bytes (50 GB) copied, 218.485 s, 230 MB/s
0.07user 147.77system 3:38.50elapsed 67%CPU (0avgtext+0avgdata 0maxresident)k
48inputs+98304008outputs (1major+520minor)pagefaults 0swaps
48000+0 records in
48000+0 records out
50331648000 bytes (50 GB) copied, 218.206 s, 231 MB/s
0.05user 145.51system 3:38.20elapsed 66%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+98304008outputs (0major+521minor)pagefaults 0swaps
48000+0 records in
48000+0 records out
50331648000 bytes (50 GB) copied, 218.895 s, 230 MB/s
0.06user 137.92system 3:38.89elapsed 63%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+98304008outputs (0major+520minor)pagefaults 0swaps

Kind regards,
  - Jan
