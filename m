From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: tip: origin tree build failure (x86, 32-bit, allyesconfig)
Date: Thu, 22 Apr 2010 11:12:41 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.1004221111220.26046@i5.linux-foundation.org>
References: <19350.53522.385933.467438@notabene.brown> <20100422070610.GA18884@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100422070610.GA18884@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 22 Apr 2010, Ingo Molnar wrote:
> 
> All 32-bit x86 builds (x86, allyesconfig) that enable RAID are failing with 
> this build failure:
> 
>  drivers/built-in.o: In function `raid5_compute_sector':
>  raid5.c:(.text+0x2e42ac): undefined reference to `__umoddi3'
>  raid5.c:(.text+0x2e42d8): undefined reference to `__umoddi3'
>  raid5.c:(.text+0x2e42ff): undefined reference to `__umoddi3'
>  raid5.c:(.text+0x2e4327): undefined reference to `__umoddi3'
>  raid5.c:(.text+0x2e4385): undefined reference to `__umoddi3'
>  drivers/built-in.o:raid5.c:(.text+0x2e43bc): more undefined references to `__umoddi3' follow
> 
> Caused by this commit:
> 
>   35f2a59: md/raid5: allow for more than 2^31 chunks.

Gaah, yes.

How about just making it "unsigned long" instead of sector_t, and telling 
people that if they have more than 2**32 chunks in their RAID array, they 
should damn well use a 64-bit CPU.

The alternative, of course, is to use "sector_div()" everywhere. Neil?

		Linus
