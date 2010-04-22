From: Ingo Molnar <mingo@elte.hu>
Subject: tip: origin tree build failure (x86, 32-bit, allyesconfig)
Date: Thu, 22 Apr 2010 09:06:10 +0200
Message-ID: <20100422070610.GA18884@elte.hu>
References: <19350.53522.385933.467438@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19350.53522.385933.467438@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


* Neil Brown <neilb@suse.de> wrote:

> are available in the git repository at:
> 
>   git://neil.brown.name/md/ for-linus

( Note, i'm re-using this old MD pull request thread to report a bug in a pull 
  request you sent to Linus in the past two days. I havent found the pull 
  request nor the patch on lkml. )

All 32-bit x86 builds (x86, allyesconfig) that enable RAID are failing with 
this build failure:

 drivers/built-in.o: In function `raid5_compute_sector':
 raid5.c:(.text+0x2e42ac): undefined reference to `__umoddi3'
 raid5.c:(.text+0x2e42d8): undefined reference to `__umoddi3'
 raid5.c:(.text+0x2e42ff): undefined reference to `__umoddi3'
 raid5.c:(.text+0x2e4327): undefined reference to `__umoddi3'
 raid5.c:(.text+0x2e4385): undefined reference to `__umoddi3'
 drivers/built-in.o:raid5.c:(.text+0x2e43bc): more undefined references to `__umoddi3' follow

Caused by this commit:

  35f2a59: md/raid5: allow for more than 2^31 chunks.

I've reverted the commit from -tip for now.

Thanks,

	Ingo
