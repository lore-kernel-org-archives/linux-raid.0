From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 15:17:12 +0100
Message-ID: <bb145bd20803020617i77113488h53ead5af3b10e48@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <20080302134836.GB20333@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080302134836.GB20333@cthulhu.home.robinhill.me.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  Have you tried rebooting?  I have (sporadically) the same issue - I/O
>  just slows to a crawl and it's impossible to get anything done.

Nice idea, but ...

- on the first reboot, the disk order was reversed, resulting in the
kernel not being able to find the rootfs. The second attempt was fine.
Which means there is another issue to debug once this one is cleared
up, just great. Never mind that I DID reboot a few times just to test
disk ordering ...

- the array does not continue to sync to the "spare" created during
array creation automagically, it just sits there:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdb[0] sde[4] sdd[2] sdc[1]
      2930285568 blocks super 1.0 level 5, 1024k chunk, algorithm 2 [4/3] [UUU_]
      bitmap: 3/466 pages [12KB], 1024KB chunk

I have no idea how to restart the sync properly but even without the
array syncing the responsiveness problem is unchanged. FWIW the sync
speed by itself was ok (~45MB/s @ 30%, which is about what a single
disk would do).

I think I'll be going from annoyed to desperate now ...

C.

P. S: BTW, mdadm segfaults at the end of --assemble, too
mdadm[3635]: segfault at 0000000000000000 rip 0000000000412d2c rsp
00007fffd6f371f0 error 4
