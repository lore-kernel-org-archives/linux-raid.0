From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 14:13:18 -0600
Message-ID: <CAJCQCtT_4O8r-cJQaw7P-47ekawYUH7cuw-30vbB8J_J+Kf+WQ@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
 <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com> <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

An invalid backup GPT suggests it was stepped on by something that was
used on the whole block device. The backup GPT is at the end of the
drive. And if you were to use mdadm create on the entire drive rather
than a partition, you'd step on that GPT and also incorrectly recreate
the array. Have you told us the entire story about how you got into
this situation? Have you use 'mdadm create' trying to fix this? If you
haven't, don't do it.

I see a lot of conflicting information. For example:

> /dev/md129:
>         Version : 1.2
>   Creation Time : Mon Nov 10 16:28:11 2014
>      Raid Level : raid0
>      Array Size : 1572470784 (1499.63 GiB 1610.21 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Nov 10 16:28:11 2014
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>
>      Chunk Size : 512K
>
>            Name : lamachine:129  (local to host lamachine)
>            UUID : 895dae98:d1a496de:4f590b8b:cb8ac12a
>          Events : 0
>
>     Number   Major   Minor   RaidDevice State
>        0       8       50        0      active sync   /dev/sdd2
>        1       8       66        1      active sync   /dev/sde2
>        2       8       82        2      active sync   /dev/sdf



>> /dev/md129:
>>         Version : 1.2
>>      Raid Level : raid0
>>   Total Devices : 1
>>     Persistence : Superblock is persistent
>>
>>           State : inactive
>>
>>            Name : lamachine:129  (local to host lamachine)
>>            UUID : 895dae98:d1a496de:4f590b8b:cb8ac12a
>>          Events : 0
>>
>>     Number   Major   Minor   RaidDevice
>>
>>        -       8       50        -        /dev/sdd2


The same md device, one raid0 one raid5. The same sdd2, one in the
raid0, and it's also in the raid5. Which is true? It sounds to me like
you've tried recovery and did something wrong; or about as bad is
you've had these drives in more than one software raid setup, and you
didn't zero out old superblocks first. If you leave old signatures
intact you end up with this sort of ambiguity, which signature is
correct. So now you have to figure out which one is correct and which
one is wrong...

Maybe start out with 'mdadm -D' on everything... literally everything,
every whole drive (i.e. /dev/sdd, /dev/sdc, all of them) and also
everyone of their partitions; and see if it's possible to sort out
this mess.


Chris Murphy
