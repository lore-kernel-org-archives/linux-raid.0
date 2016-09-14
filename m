From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Inactive arrays
Date: Wed, 14 Sep 2016 19:42:50 +0100
Message-ID: <57D99A2A.8000006@youngman.org.uk>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
 <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com>
 <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
 <CAJCQCtRdbWg7HgX=wghd8OBUcauiVfES6NSOKOZj38HMWVg65A@mail.gmail.com>
 <CAHscji1fgVrKwOwf+sCfOrg-MNz0MwRzXAJswKcP=vP2x0PVug@mail.gmail.com>
 <CAJCQCtSTaByUR_2dnGrA0y0dtTaS_sweLKn19QD1=wv+2mnvHg@mail.gmail.com>
 <CAHscji2dhdE7mL-4i8mE6sShQtGCB6v1K02TBQQD4-6R-ZtoZw@mail.gmail.com>
 <CAJCQCtQXd6GgXhu-7h9nNjA1zfdoH_TAEkeQajYv5vsmuG2Vpw@mail.gmail.com>
 <CAHscji1wVYzpzu8X+GYuuxZPdLzY-f+8oogyH7ttqVwMJe2=iQ@mail.gmail.com>
 <CAJCQCtQ3kAKd4U=MgVawU9D6QKuxC+XjLYR6EyL87wuyBvvmtg@mail.gmail.com>
 <CAJCQCtSsC3=hh60PudHqziubnv_KVFevbCgV3MNZKnL44Fow=Q@mail.gmail.com>
 <CAHscji2BKxNDLzZUonGHVB8PzeFbtuwn32NBaX315QPvvhOxyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji2BKxNDLzZUonGHVB8PzeFbtuwn32NBaX315QPvvhOxyg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/09/16 19:16, Daniel Sanabria wrote:
> Other than replacing the green drives with something more
> suitable (any suggestions are welcome)

WD Reds or Seagate NAS. I don't think they make them any more, but
Seagate Constellations are fine too. My Toshiba 2TB 2.5" laptop drive
would be fine.

The tl;dr version of the problem with Greens (and any other desktop
drive for that matter), if you haven't read it up yet, is that when the
kernel requests a read from a dodgy drive, it just sits there,
*unresponsive*, until the read succeeds or the drive times out. And the
drive will time out in its own good time.

If the kernel times out *before* the drive, and by default the kernel
does so after 7 secs, while the drive can take two minutes or more, then
the kernel will recreate the missing block and try to write it. The
drive is unresponsive, the write times out, and the kernel assumes the
drive is dead and kicks it from the array.

That's why you need to increase the kernel timeout, because you can't
reduce the drive timeout, and which is why a flaky hard drive will cause
system response to fall off horrendously.

Cheers,
Wol
