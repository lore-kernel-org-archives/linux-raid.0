From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 23 Aug 2016 09:34:14 -0500
Message-ID: <CAJvUf-C8ov4tHRGj5SPamJE8PF0Qsr4Cwuv02-9F0SV1yp4ccQ@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-C7CMqUBe+kPaxxTtmvuCXSRes73kMcAnZw7x8=6DNCdw@mail.gmail.com> <CAFx4rwTawqrBOWVwtPnGhRRAM1XiGQkS-o3YykmD0AftR45YkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwTawqrBOWVwtPnGhRRAM1XiGQkS-o3YykmD0AftR45YkA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 16, 2016 at 5:43 PM, Doug Dumitru <doug@easyco.com> wrote:
> One last thing I would highly recommend is:
>
> Secure erase the replacement disk before rebuilding onto it.
>
> If the replacement disk is "pre conditioned" with random writes, even if
> very slowly, this will lower the write performance of the disk during the
> rebuild.

Does that also apply to brand-new disks from the manufacturer?

I.e., should we just always do a secure erase, or sometimes depending
on how the drive was sourced?
