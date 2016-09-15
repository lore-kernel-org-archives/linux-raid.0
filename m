From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Inactive arrays
Date: Thu, 15 Sep 2016 17:21:51 +0800
Message-ID: <b17373c6-88a9-68df-4f72-a2dbf2cd72ea@fnarfbargle.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
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
 <57D99A2A.8000006@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57D99A2A.8000006@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Daniel Sanabria <sanabria.d@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/09/16 02:42, Wols Lists wrote:
> The tl;dr version of the problem with Greens (and any other desktop
> drive for that matter), if you haven't read it up yet, is that when the
> kernel requests a read from a dodgy drive, it just sits there,
> *unresponsive*, until the read succeeds or the drive times out. And the
> drive will time out in its own good time.

Yep. I've had great results using Greens but the trick is either TLER or 
adjusted timeout, *and* disable head parking & spindown.

I'm lucky in that all my Greens are old enough they still have TLER.
These are the oldest ones with power on hours taken from SMART:
/dev/sdq - WDC WD20EARS-60MVWB0 - 5 years 157 days
/dev/sdi - WDC WD20EARS-60MVWB0 - 5 years 157 days
/dev/sdl - WDC WD20EARS-60MVWB0 - 5 years 157 days
/dev/sdm - WDC WD20EARS-60MVWB0 - 5 years 157 days
/dev/sdp - WDC WD20EARS-60MVWB0 - 5 years 157 days
/dev/sdn - WDC WD20EARS-60MVWB0 - 5 years 157 days
/dev/sdg - WDC WD20EARS-60MVWB0 - 5 years 158 days

I have one that is only 3 years 242 days (replacement for an early 
failure), and anything newer than that is a Red. I started with 10 
Greens and 7 are still humming along nicely.

Like any commodity drive, get your timeouts right and keep them spinning.

Regards,
Brad.
