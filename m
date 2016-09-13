From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 09:04:59 -0600
Message-ID: <CAJCQCtSL4N6dtMOJVFHocVD3QKCvFmejgt-973M0jjcHMvo-Mg@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <CAJCQCtRQmyvCqCqvmKazPg7cFrZ9A5SzZ+Yts_B3SxHU5s68GQ@mail.gmail.com> <CAHscji2pAt1_yPpXj6gKE-sin0Db3RAo56srM8cye5ub4rSLXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji2pAt1_yPpXj6gKE-sin0Db3RAo56srM8cye5ub4rSLXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Sep 13, 2016 at 12:51 AM, Daniel Sanabria <sanabria.d@gmail.com> wrote:
>> What version of parted?
>
> parted (GNU parted) 3.2

That should reliably fix the GPT, assuming it's appropriate to fix it
- which isn't necessarily a good assumption. The backup GPT is located
in about the same place as the mdadm v2 metadata. So one can step on
the other, depending on how the array is created (on whole devices or
on partitions). The problem with unwinding this is if any of these
structures becomes stale without having the signature wiped, it
becomes important to find out for certain which one is valid and which
one is stale.

>
>> Are these two drives on the same
>> controller?
>
> yes afaict

I'd check all the cables (the connections in particular) drive to
controller and that the controller is seated. Seems sorta unlikely
you'd have the same kind of problem on two drives at the same time
that's a hardware problem unless they share something the other drives
don't; or if some event has modified both drives the same way. Thing
is, invalid argument during seek for read? Kinda sounds like a
hardware problem.

-- 
Chris Murphy
