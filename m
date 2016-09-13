From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 22:26:13 +0100
Message-ID: <57D86EF5.7080701@youngman.org.uk>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk>
 <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk>
 <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
 <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com>
 <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
 <CAJCQCtT_4O8r-cJQaw7P-47ekawYUH7cuw-30vbB8J_J+Kf+WQ@mail.gmail.com>
 <CAHscji3LX3+c_ighYMMDQo1E4ygdepr=Gt2wVmWzdLj+F+tVsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji3LX3+c_ighYMMDQo1E4ygdepr=Gt2wVmWzdLj+F+tVsQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/09/16 21:36, Daniel Sanabria wrote:
> [root@lamachine ~]# mdadm -D /dev/sd*
> mdadm: /dev/sda does not appear to be an md device
> mdadm: /dev/sda1 does not appear to be an md device
> mdadm: /dev/sda2 does not appear to be an md device
> mdadm: /dev/sda3 does not appear to be an md device
> mdadm: /dev/sda5 does not appear to be an md device
> mdadm: /dev/sda6 does not appear to be an md device
> mdadm: /dev/sdb does not appear to be an md device

I think that it's been pointed out, but this should be "mdadm -E".

"mdadm -E" gets passed physical devices eg /dev/sda, "mdadm -D" gets
passed raid devices eg /dev/md127.

Confusing, I know ...

Cheers,
Wol
