From: Karl Newman <siliconfiend@gmail.com>
Subject: [BISECT] Kernel panic, RIP bitmap_create
Date: Wed, 2 May 2012 22:05:44 -0700
Message-ID: <CAOOwNt+wjMU9+Dzrr3+d3dwML2_Q_CgT4X5OgiKvPA_bBoTYcg@mail.gmail.com>
References: <CAOOwNtJhFa67EFTs5AdgSHzFseBr9xJGTsaEOyYnaYYNCeUMAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOOwNtJhFa67EFTs5AdgSHzFseBr9xJGTsaEOyYnaYYNCeUMAQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hi,

I'm attempting to use kernel 3.4-rc? but keep running into a kernel panic on
boot, with RIP pointing to bitmap_create. I tried 3.4-rc1, 3.4-rc4 and
3.4-rc5 and they all have the kernel panic, while 3.3.4 boots fine. I have
my root on raid 5 with an internal bitmap, and the kernel panic occurs if I
use the built-in kernel autodetect or during the root array assembly via
mdadm inside a dracut-generated initramfs. I bisected it down to the
following commit:
61a0d80ce4ab5b4fb9ecb38f1fb19654778b71ed

md/bitmap: discard CHUNK_BLOCK_SHIFT macro

Be redefining ->chunkshift as the shift from sectors to chunks rather than
bytes to chunks, we can just use "bitmap->chunkshift" which is shorter than
the macro call, and less indirect.

Signed-off-by: NeilBrown <neilb@suse.de>

My bisect testing including a scary commit where 2 of 3 drives had their
UUIDs zeroed when I booted with it! Fortunately I found the mailing list
archives with the solution and I was able to recover everything and keep
bisecting (although I was tempted to quit and just give the range of
commits...).

I hope this fix can make it into the next 3.4-rc kernel.

Thanks,

Karl Newman

P.S. Sorry for the possible repeat, apparently Gmail's default HTML
format is unacceptable to this list.
