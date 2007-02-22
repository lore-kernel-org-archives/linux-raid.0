From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
Date: Wed, 21 Feb 2007 18:57:39 -0800
Message-ID: <20070221185739.0d509c0d.akpm@linux-foundation.org>
References: <20070220172544.15678.patches@notabene>
	<1070220063516.16208@suse.de>
	<20070221144806.e6eed85c.akpm@linux-foundation.org>
	<17885.636.133245.572876@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17885.636.133245.572876@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Feb 2007 13:39:56 +1100 Neil Brown <neilb@suse.de> wrote:

> I must right code that Andrew can read.

That's write.

But more importantly, things that people can immediately see and understand
help reduce the possibility of mistakes.  Now and in the future.

If we did all loops like that, then it'd be the the best way to do it in new code,
because people's eyes and brains are locked into that idiom and we just
don't have to think about it when we see it.
