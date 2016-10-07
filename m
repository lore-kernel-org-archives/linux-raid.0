From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] MD update for 4.9
Date: Fri, 7 Oct 2016 11:02:32 -0700
Message-ID: <CA+55aFzZ9-1dC9L_Q1xxKuKWKavP0eeB0YQjK0gzoBtKbDzSOw@mail.gmail.com>
References: <20161007003850.GA7197@kernel.org> <CAFx4rwTo7s7uVH3PuGF-ys52QaEdxHoP2viYuJteRQqmeiEyqA@mail.gmail.com>
 <20161007173957.GA37192@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161007173957.GA37192@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Doug Dumitru <doug@easyco.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Fri, Oct 7, 2016 at 10:39 AM, Shaohua Li <shli@kernel.org> wrote:
>
> I did try your patch and it improved 10% in my machine, but this isn't
> relevent to the pull. We can do the tunning later if necessary. I'm
> hoping the intel guys can share some hints, but apparently Linus isn't a
> fan for such tuning.

We've had horrible experiences with prefetching in the past.  We've
seen microarchitectures that do really bad things when the prefetch
takes a TLB miss, for example, and suddenly they stall on the
prefetch, and actually slow the code down.

Admittedly, most of the bad cases are probably not a big deal for
streaming raid rebuild code, so it may well be that it works better
there.

So I'm not categorically against prefetching, but it needs to be
tested across a lot of different (micro-)architectures. Right now, I
guess something very specific like AVX512 means effectively just one
or two microarchitectures and then it's easy to say "it always helps".

The worst cases for the kernel have generally been in generic code.

                      Linus
