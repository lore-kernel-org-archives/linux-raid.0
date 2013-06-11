From: Andrew Brooks <arb@sat.dundee.ac.uk>
Subject: Re: Fwd: mismatches in raid1, clarification please
Date: Tue, 11 Jun 2013 16:39:56 +0100
Message-ID: <CAHOfOo0g9ACH2V_L-_SPXoT7Zd1srJu3av339sjipZDAa9RwxA@mail.gmail.com>
References: <CAHOfOo1Ex+JsJ3NDzyKxAkabBMY4up0apftMK=mVwS4rw_E+Bg@mail.gmail.com>
 <CAHOfOo0gjhXV701kwHcLS4-VYvxCnpLZp76P7hc_-e_g6vi-BA@mail.gmail.com> <20130611151724.GA22861@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130611151724.GA22861@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11 June 2013 16:17, Robin Hill <robin@robinhill.me.uk> wrote:
>> If there has been no read error then how does it know which block is good?
>>
> It doesn't. I'm not sure what the algorithm is to pick which disk to use
> as the reference value

I wonder if someone on this list will know or whether I should ask on
the kernel list.

> but one disk is picked and that data is then written to the other mirrors.
> It's not ideal

No kidding, it potentially catastrophic ;-)

The manual says "It is conceivable for a similar situation to occur on
non-swap files, though it is less likely."
but doesn't elaborate on the possible causes.

Also "Thus the mismatch_cnt value can not be interpreted very reliably on RAID1"
but if you see it on a non-swap partition then surely it's a very
serious problem?

Thanks!
