From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] MD update for 4.9
Date: Fri, 7 Oct 2016 09:44:15 -0700
Message-ID: <CA+55aFxocN1pqucTfOSGe5RLsB0QsRnwr9TANJQkYAiibMty-w@mail.gmail.com>
References: <20161007003850.GA7197@kernel.org> <CAFx4rwTo7s7uVH3PuGF-ys52QaEdxHoP2viYuJteRQqmeiEyqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwTo7s7uVH3PuGF-ys52QaEdxHoP2viYuJteRQqmeiEyqA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: Shaohua Li <shli@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Thu, Oct 6, 2016 at 10:39 PM, Doug Dumitru <doug@easyco.com> wrote:
>
> There is another thread in [linux-raid] discussing pre-fetches in the
> raid-6 AVX2 code.  My testing implies that the prefetch distance is
> too short.  In your new AVX512 code, it looks like there are 24
> instructions, each with latencies of 1, between the prefetch and the
> actual memory load.  I don't have a AVX512 CPU to try this on, but the
> prefetch might do better at a bigger distance.  If I am not mistaken,
> it takes a lot longer than 24 clocks to fetch 4 cache lines.

We have basically never had a case where prefetches were actually a good idea.

If the hardware doesn't do prefetching on its own (partly with just
physical memory patterns in the memory controller, partly just with
aggressive OoO), software isn't going to be able to improve on the
situation in general.

SW prefetching is a broken concept. You can make big differences for
very specific microarchitectures (usually the broken shit ones are the
ones that show it best), but in the general case it's pretty much
always a lost cause. We've had real cases where prefetching just then
made things worse on other hardware.

So just don't do it. It's benchmarketing for specific hardware, it's
not worth worrying about in the bigger picture. You'll find people
spend a lot of time tuning things for their particular hardware, and
it not helping at all on anything else.

Waste of time. Life is too short (and software is too complex) to try
to work around broken microarchitectures with sw prefetching.

              Linus
