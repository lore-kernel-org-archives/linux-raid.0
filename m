From: NeilBrown <neilb@suse.com>
Subject: Re: raid5: handle_stripe_dirtying
Date: Wed, 5 Aug 2015 07:31:43 +1000
Message-ID: <20150805073143.6e30ad76@noble>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735FCD417B@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735FCD417B@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 4 Aug 2015 18:32:37 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> Hi Neil,
> 
> before sending a wrong patch. Could you help me to understand the reason 
> for an unconditional singular 

Sending a wrong patch is not such a bad thing - it would help me know
what you are thinking, and so reduce guess-work :-)

> 
> set_bit(STRIPE_HANDLE, &sh->state); 
> 
> in function handle_stripe_dirtying of raid5.c? It seems to be there since
> its introduction somewhere 8 years ago - patch "raid5: refactor handle_stripe5 
> and handle_stripe6 (v3)". 
> 
> If I understand the idea behind the flag right it is required to ensure 
> handling of the stripe in the next handle_stripe() run. That would only make
> sense if we set it unconditionally OR depending on some changes to the
> stripe. The above function does both. See a few lines below in the deep
> if-blocks.

So I'm guessing that you want to remove one of those?  Probably
justified.

That duplication goes back to
 Commit: 396a6123577d ("v2.4.5.4 -> v2.4.5.5")

I think your understanding of STRIPE_HANDLE is pretty spot-on.

NeilBrown

> 
> Thanks in advance.
> 
> Markus

