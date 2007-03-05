From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt questions
Date: Tue, 6 Mar 2007 10:40:53 +1100
Message-ID: <17900.43653.510415.553440@notabene.brown>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
	<17898.45673.573800.56474@notabene.brown>
	<45EB3867.8050907@eyal.emu.id.au>
	<17899.18568.523543.478792@notabene.brown>
	<45EBCA83.40106@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eyal Lebedinsky on Monday March 5
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 5, eyal@eyal.emu.id.au wrote:
> Neil Brown wrote:
> [trim Q re how resync fixes data]
> > For raid1 we 'fix' and inconsistency by arbitrarily choosing one copy
> > and writing it over all other copies.
> > For raid5 we assume the data is correct and update the parity.
> 
> Can raid6 identify the bad block (two parity blocks could allow this
> if only one block has bad data in a stripe)? If so, does it?

No, it doesn't.

I guess that maybe it could:
   Rebuild each block in turn based on the xor parity, and then test 
   if the Q-syndrome is satisfied.
but I doubt the gain would be worth the pain.

What we really want in drives that store 520 byte sectors so that a
checksum can be passed all the way up and down through the stack
.... or something like that.

NeilBrown
