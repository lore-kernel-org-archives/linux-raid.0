From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH 6/7] md/raid10, LLVM: get rid of variable length array
Date: Fri, 17 Mar 2017 20:05:16 +0100
Message-ID: <CACT4Y+bybdpqB71=inx8amwr188Mb2QyBeRTDdWZ3AFyDwVX0A@mail.gmail.com>
References: <20170317001520.85223-1-md@google.com> <20170317001520.85223-7-md@google.com>
 <20170317120837.pr74cv3xuj7qpoin@hirez.programming.kicks-ass.net>
 <CAG_fn=XcQLtcHRSm2BHYce9LMtyFJ+fWxfE4vYPCw+7U0DcrmQ@mail.gmail.com>
 <CAG_fn=WooTLkzex3hqPgO5pr7GsK3v7Z5riSA7K+-_S=S7rmBQ@mail.gmail.com>
 <20170317180350.63jjysejk2i6vkon@pd.tnic> <CACT4Y+Ysvjz+UzEi0dTtsNxxnG7WXTiZPr+KSk8HHwSu7vX1ew@mail.gmail.com>
 <20170317185720.5s7qa6hl233t24ag@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20170317185720.5s7qa6hl233t24ag@pd.tnic>
Sender: linux-crypto-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Alexander Potapenko <glider@google.com>, Peter Zijlstra <peterz@infradead.org>, Michael Davidson <md@google.com>, Michal Marek <mmarek@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Shaohua Li <shli@kernel.org>, Matthias Kaehlcke <mka@chromium.org>, "x86@kernel.org" <x86@kernel.org>, "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, kbuild-all@01.org, Fengguang Wu <fengguang.wu@intel.com>
List-Id: linux-raid.ids

On Fri, Mar 17, 2017 at 7:57 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Mar 17, 2017 at 07:47:33PM +0100, Dmitry Vyukov wrote:
>> This problem is more general and is not specific to clang. It equally
>> applies to different versions of gcc, different arches and different
>> configs (namely, anything else than what a developer used for
>> testing).
>
> I guess. We do carry a bunch of gcc workarounds along with the cc-*
> macros in scripts/Kbuild.include.
>
>> A known, reasonably well working solution to this problem is
>> a system of try bots that test patches before commit with different
>> compilers/configs/archs. We already have such system in the form of
>> 0-day bots. It would be useful to extend it with clang as soon as
>> kernel builds.
>
> Has someone actually already talked to Fengguang about it?

+Fengguang

> Oh, and the stupid question: why the effort to build the kernel
> with clang at all? Just because or are there some actual, palpable
> advantages?

On our side it is:
 - clang make it possible to implement KMSAN (dynamic detection of
uses of uninit memory)
 - better code coverage for fuzzing
 - why simpler and faster development (e.g. we can port our user-space
hardening technologies -- CFI and SafeStack)

You can also find some reasons in the Why section of LLVM-Linux project:
http://llvm.linuxfoundation.org/index.php/Main_Page
