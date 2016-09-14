From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Wed, 14 Sep 2016 09:15:53 -0600
Message-ID: <CAJCQCtQXd6GgXhu-7h9nNjA1zfdoH_TAEkeQajYv5vsmuG2Vpw@mail.gmail.com>
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
 <CAJCQCtSTaByUR_2dnGrA0y0dtTaS_sweLKn19QD1=wv+2mnvHg@mail.gmail.com> <CAHscji2dhdE7mL-4i8mE6sShQtGCB6v1K02TBQQD4-6R-ZtoZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji2dhdE7mL-4i8mE6sShQtGCB6v1K02TBQQD4-6R-ZtoZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 14, 2016 at 8:57 AM, Daniel Sanabria <sanabria.d@gmail.com> wrote:
>> So yes you can just run gdisk, go to expert menu with x, then verify
>> with v, and print the table with p, and post all of that and we'll
>> confirm before you use w to write out the fixed table.
>
> choices now:
>
> [root@lamachine ~]# gdisk /dev/sdc
>
> GPT fdisk (gdisk) version 1.0.1
>
> Warning! Disk size is smaller than the main header indicates! Loading
> secondary header from the last sector of the disk! You should use 'v' to
> verify disk integrity, and perhaps options on the experts' menu to repair
> the disk.
>
> Caution: invalid backup GPT header, but valid main header; regenerating
> backup header from main header.
>
>
> Warning! One or more CRCs don't match. You should repair the disk!
>
> Partition table scan:
>
>   MBR: not present
>   BSD: not present
>   APM: not present
>   GPT: damaged
>
>
> Found invalid MBR and corrupt GPT. What do you want to do? (Using the
> GPT MAY permit recovery of GPT data.)
>  1 - Use current GPT
>  2 - Create blank GPT
>
>
> Your answer:

1. Use current.

Then x, v, p and post the output.



-- 
Chris Murphy
