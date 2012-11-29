From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Thu, 29 Nov 2012 22:18:28 +0100
Message-ID: <20121129211828.GZ16230@one.firstfloor.org>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <m2obigf9xa.fsf@firstfloor.org> <50B7CFF8.7010401@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50B7CFF8.7010401@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Linux Raid <linux-raid@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

> The code is compiled so that the xmm/ymm registers are not available to
> the compiler.  Do you have any known examples of asm volatiles being
> reordered *with respect to each other*?  My understandings of gcc is
> that volatile operations are ordered with respect to each other (not
> necessarily with respect to non-volatile operations, though.)

Can you quote it from the manual? As I understand volatile as usual
is not clearly defined. 

gcc has a lot of optimization passes and volatile bugs are common.


> Either way, this implementatin technique was used for the MMX/SSE
> implementations without any problems for 9 years now.

It's still wrong.

Lying to the compiler usually bites you at some point.

-Andi
