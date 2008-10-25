From: Neil Brown <neilb@suse.de>
Subject: Re: can I replace spin lock of stripe with mutex?
Date: Sat, 25 Oct 2008 16:19:12 +1100
Message-ID: <18690.44112.137977.511038@notabene.brown>
References: <389deec70810240825m499bb257t9e69d57f08a91efa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from hank.peng on Friday October 24
Sender: linux-raid-owner@vger.kernel.org
To: "hank . peng" <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday October 24, pengxihan@gmail.com wrote:
> hi, neil:
> I want to use hardware engine to do XOR. The driver is based on
> interrupt way, which will cause sleep. I found that in handle_stripe
> function spin lock of a stripe is used during donging XOR. Since
> between spin_lock and spin_unlock, sleep is not allowed, I want to
> replace it with mutex, does it make sense?
> 

What kernel version are you looking at?
I ask because for quite some months (years?) we have had explicit
support for hardware based xor using the "async_tx" extension to the
async-crypto API.
See  crypto/async_tx/ and drivers/dma/

That is a much more complete approach.  Just changing the lock type
would not really help, there are other reasons why we cannot sleep in
that code.

NeilBrown

