From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 20:43:30 +0100
Message-ID: <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> This is a problem. What do you get for
>
> cat /sys/block/sdc/device/timeout

[root@lamachine ~]# cat /sys/block/sdc/device/timeout
30
[root@lamachine ~]# cat /sys/block/sdd/device/timeout
30
[root@lamachine ~]# cat /sys/block/sde/device/timeout
30
[root@lamachine ~]#

> Anyone specifically familiar with WDC Greens, and if the lack of SCT
> ERC can be worked around in the usual way by increasing the SCSI
> command timer value? Or is there also something else? I vaguely recall
> something about drive spin down that can also cause issues, does that
> need mitigation? If no one chimes in, this information is in the
> archives, just search for 'WDC green' and you'll get an shittonne of
> results.

In another thread I found Phil Turmel recommending to change the
timeout value like this:

for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done

Is that what you guys are talking about when mentioning the SCT/ERC issues?

> OK so the next thing I want to see is why you're getting these
> messages from parted when you check sdc and sde for partition maps. At
> the time you do this, what do you see in kernel messages? Maybe best
> to just stick the entire dmesg for the current boot up somewhere like
> fpaste.org or equivalent.

https://paste.fedoraproject.org/427719/37952531/
