From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Inactive arrays
Date: Wed, 3 Aug 2016 22:31:31 +0100
Message-ID: <57A262B3.70103@youngman.org.uk>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk>
 <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3CMO=ZREJypdUhsyKN0TmHWsEybdVLwWCbMZqWGdngOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji3CMO=ZREJypdUhsyKN0TmHWsEybdVLwWCbMZqWGdngOA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/08/16 20:18, Daniel Sanabria wrote:
> Ok,
> 
> Unfortunately the PSU replacement didn't help and I could be facing a
> failed motherboard/cpu :( My question now is, is it possible to
> restore the arrays in a new machine?

Your comment about the system starting up and shutting down almost
immediately implies to me a faulty on/off switch. It could be that
simple. Or of course, it could be worse. Like so many things nowadays,
on/off is controlled by software and if the switch is stuck ...

You might find all it needs is a new case. Or you might not.

But yes, if it's all linux software raid, then sticking the disks into a
new machine should work fine - the new machine should just come straight
up unless you're running an optimised kernel.

(That doesn't imply the arrays will :-( you might need a bit of fixing
for them, but if the machine boots successfully you're most of the way
there.)

Cheers,
Wol

