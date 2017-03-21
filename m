From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 14:26:10 +0100
Message-ID: <CAJH6TXih4wv10WDGOA2PT-b8FSetx06D237HS_cpT4+Ap0d0dg@mail.gmail.com>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net> <58D1244E.3040204@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58D1244E.3040204@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-03-21 14:02 GMT+01:00 David Brown <david.brown@hesbynett.no>:
> Note that to cause failure in non-degraded RAID5 (or degraded RAID6),
> your two URE's need to be on the same stripe in order to cause data
> loss.  The chances of getting an URE somewhere on the disk are roughly
> proportional to the size of the disk - but the chance of getting an URE
> on the same stripe as another URE on another disk are basically
> independent of the disk size, and it is extraordinarily small.

Little bit OT:
is this the same even for HW RAID Controllers like LSI Megaraid
or they tend to fail the rebuild in case of multiple URE even in
different stripes?

> No, you cannot.  Your conclusion here is based on several totally
> incorrect assumptions:
>
> 1. You think that RAID5/RAID6 recovery is more stressful, because the
> parity is "all over the place".  This is wrong.
>
> 2. You think that random IO has higher chance of getting an URE than
> linear IO.  This is wrong.

Totally agree.

> 3. You think that getting an URE on one disk, then getting an URE on a
> second disk, counts as a double failure that will break an single-parity
> redundancy (RAID5, RAID1, RAID6 in degraded mode).  This is wrong - it
> is only a problem if the two UREs are in the same stripe, which is quite
> literally a one in a million chance.

I'm not sure about this.
The posted paper is talking about "standard" raid made with hw raid controllers
and I'm not sure if they are able to finish a rebuild in case of double URE even
if coming from different stripes.

I think they fail the whole rebuild.
