From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 09:20:10 -0600
Message-ID: <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Sep 13, 2016 at 12:56 AM, Daniel Sanabria <sanabria.d@gmail.com> wrote:

>
> [root@lamachine ~]# smartctl -x /dev/sdc
> smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.3.3-303.fc23.x86_64] (local build)
> Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Green
> Device Model:     WDC WD30EZRX-00D8PB0
> Serial Number:    WD-WCC4NCWT13RF

> SCT Error Recovery Control command not supported

This is a problem. What do you get for

cat /sys/block/sdc/device/timeout


>
> [root@lamachine ~]# smartctl -x /dev/sdd
> smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.3.3-303.fc23.x86_64] (local build)
> Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Green
> Device Model:     WDC WD30EZRX-00D8PB0
> Serial Number:    WD-WCC4NPRDD6D7

>
> SCT Error Recovery Control command not supported

Same for sdd.


> [root@lamachine ~]# smartctl -x /dev/sde
> smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.3.3-303.fc23.x86_64] (local build)
> Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Green
> Device Model:     WDC WD30EZRX-00D8PB0
> Serial Number:    WD-WCC4N1294906


> SCT Error Recovery Control command not supported

And sde.

But otherwise no other issues.

Note that WDC Greens are explicitly disqualified for use in RAID of
any level by the manufacturer. We can complain til the cows come home
but the reality is the manufacturer does not stand behind this product
at all in RAID configurations.

Anyone specifically familiar with WDC Greens, and if the lack of SCT
ERC can be worked around in the usual way by increasing the SCSI
command timer value? Or is there also something else? I vaguely recall
something about drive spin down that can also cause issues, does that
need mitigation? If no one chimes in, this information is in the
archives, just search for 'WDC green' and you'll get an shittonne of
results.

OK so the next thing I want to see is why you're getting these
messages from parted when you check sdc and sde for partition maps. At
the time you do this, what do you see in kernel messages? Maybe best
to just stick the entire dmesg for the current boot up somewhere like
fpaste.org or equivalent.



-- 
Chris Murphy
