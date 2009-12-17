From: "Majed B." <majedb@gmail.com>
Subject: Re: reconstruct raid superblock
Date: Thu, 17 Dec 2009 14:45:26 +0300
Message-ID: <70ed7c3e0912170345s9482d6ek1950422359b3da88@mail.gmail.com>
References: <549053140912161953x665f84cbnc457c45e47ac2a97@mail.gmail.com>
	<70ed7c3e0912162117n3617556p3a8decef94f33a1c@mail.gmail.com>
	<70ed7c3e0912162121v5df1b972x6d9176bdf7e27401@mail.gmail.com>
	<70ed7c3e0912170235m3af05859x9c0472d4c7d2f370@mail.gmail.com>
	<4877c76c0912170322oda9d5f0tdb13c37517bb5e31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912170322oda9d5f0tdb13c37517bb5e31@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is that because the disk was removed from the array and/or lost its
superblock info?

I've had problems with arrays before during resync, and I was able to
stop them and resume them again, sometimes after disks jump out of the
array (but still retaining their superblock info).

On Thu, Dec 17, 2009 at 2:22 PM, Michael Evans <mjevans1983@gmail.com> wrote:
> He's using v0.9 superblocks; even if the replaced device was at 99%
> complete it would still have to restart from 0% when re-added.
>



-- 
       Majed B.
