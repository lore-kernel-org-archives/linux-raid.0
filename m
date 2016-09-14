From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Wed, 14 Sep 2016 10:13:03 -0600
Message-ID: <CAJCQCtSsC3=hh60PudHqziubnv_KVFevbCgV3MNZKnL44Fow=Q@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
 <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com>
 <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
 <CAJCQCtRdbWg7HgX=wghd8OBUcauiVfES6NSOKOZj38HMWVg65A@mail.gmail.com>
 <CAHscji1fgVrKwOwf+sCfOrg-MNz0MwRzXAJswKcP=vP2x0PVug@mail.gmail.com>
 <CAJCQCtSTaByUR_2dnGrA0y0dtTaS_sweLKn19QD1=wv+2mnvHg@mail.gmail.com>
 <CAHscji2dhdE7mL-4i8mE6sShQtGCB6v1K02TBQQD4-6R-ZtoZw@mail.gmail.com>
 <CAJCQCtQXd6GgXhu-7h9nNjA1zfdoH_TAEkeQajYv5vsmuG2Vpw@mail.gmail.com>
 <CAHscji1wVYzpzu8X+GYuuxZPdLzY-f+8oogyH7ttqVwMJe2=iQ@mail.gmail.com> <CAJCQCtQ3kAKd4U=MgVawU9D6QKuxC+XjLYR6EyL87wuyBvvmtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQ3kAKd4U=MgVawU9D6QKuxC+XjLYR6EyL87wuyBvvmtg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Low priority but you could make the type codes consistent for both
partitions. It doesn't matter if they're 8300 or FD00 on GPT disks,
there's nothing I know that actually uses this information. FD00 is
maybe slightly better only in that it'll flag a human to expect that
there's mdadm metadata on this partition rather than a file system.


Chris
