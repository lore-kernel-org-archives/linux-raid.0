From: Neil Brown <neilb@suse.de>
Subject: Re: about raid5 recovery when created
Date: Thu, 10 Dec 2009 12:43:59 +1100
Message-ID: <20091210124359.4dd1a93a@notabene.brown>
References: <389deec70912080501u6c6bc90ei2d34ef245a1dae9e@mail.gmail.com>
	<20091208131446.GA21130@cthulhu.home.robinhill.me.uk>
	<389deec70912080549h1b22489es612235ad29354d6b@mail.gmail.com>
	<20091208135600.GB21130@cthulhu.home.robinhill.me.uk>
	<389deec70912080603w47d7fda3jf021af169ac1c48c@mail.gmail.com>
	<4877c76c0912090030r266337afs394ecec463555258@mail.gmail.com>
	<389deec70912090329w65b7fa06hff8b75ad8f637307@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <389deec70912090329w65b7fa06hff8b75ad8f637307@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: Michael Evans <mjevans1983@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 9 Dec 2009 19:29:04 +0800
hank peng <pengxihan@gmail.com> wrote:

> I think it is better to implement this function in kernel's md layer.
> I wonder what Neil Brown think of this?

I don't think it is worth the effort.
You probably would save some CPU time as you don't need to XOR, but as has
been said, we are usually IO bound, not CPU bound.

With the current arrangement, you can start using the array immediately - you
don't have to wait for the initial recovery to complete.
If you zeroed all devices at create time, you would have to wait for that to
complete before using the array.

So I see very little gain, and significant cost.

NeilBrown

