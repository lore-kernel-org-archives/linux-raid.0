From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Date: Mon, 23 Aug 2010 23:29:13 +0300
Message-ID: <AANLkTi=HxY6w2iJme3qW_J_sbXedu7JSSECBEFPM1d_c@mail.gmail.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
	<20100823122606.47524cef.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
	<20100823130109.6da43a58.akpm@linux-foundation.org>
	<AANLkTikpTZfUE-XFCXJV6FdZy0ZTWeoPLF_qErvvjGOy@mail.gmail.com>
	<alpine.DEB.2.00.1008231310100.17716@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008231310100.17716@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi David,

On Mon, 23 Aug 2010, Pekka Enberg wrote:
>> > Hows about you add a helper function
>> >
>> > =A0 =A0 =A0 =A0void *[kmalloc|alloc_page]_retrying_forever_because=
_i_suck(lots of args)
>> >
>> > then convert the callsites to use that, then nuke __GFP_NOFAIL?
>>
>> I'd prefer killing off __GFP_NOFAIL properly :-)

On Mon, Aug 23, 2010 at 11:13 PM, David Rientjes <rientjes@google.com> =
wrote:
> And how is this not done properly if it's not even needed for any of =
the
> allocations in this patchset since the page allocator loops forever f=
or
> their orders and context? =A0(This is why we don't need to add __GFP_=
NOWARN
> in its place.)
>
> This is a cleanup patchset to remove the unnecessary use of __GFP_NOF=
AIL,
> there _are_ GFP_KERNEL | __GFP_NOFAIL allocations that need to be
> addressed in phase three.

My point is that I don't think Andrew's helper will change all that
much. Fixing the actual callers is the hard part and I don't see your
patches helping that either. Hiding the looping in filesystem code is
only going to make problematic callers harder to find (e.g
kmem_alloc() in XFS code).

=46WIW, I'd just add a nasty WARN_ON in the page allocator and put a bi=
g
fat "fix your shit" comment on top of it to motivate people to fix
their code.

                         Pekka
