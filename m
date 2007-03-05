From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: mismatch_cnt questions
Date: Mon, 05 Mar 2007 18:45:07 +1100
Message-ID: <45EBCA83.40106@eyal.emu.id.au>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<45EB3867.8050907@eyal.emu.id.au> <17899.18568.523543.478792@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17899.18568.523543.478792@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
[trim Q re how resync fixes data]
> For raid1 we 'fix' and inconsistency by arbitrarily choosing one copy
> and writing it over all other copies.
> For raid5 we assume the data is correct and update the parity.

Can raid6 identify the bad block (two parity blocks could allow this
if only one block has bad data in a stripe)? If so, does it?

This will surely mean more value for raid6 than just the two-disk-failure
protection.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
