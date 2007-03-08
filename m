From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mismatch_cnt questions
Date: Wed, 07 Mar 2007 22:34:13 -0800
Message-ID: <45EFAE65.9050608@zytor.com>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<45EB3867.8050907@eyal.emu.id.au> <17899.18568.523543.478792@notabene.brown> <45EBCA83.40106@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45EBCA83.40106@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: Neil Brown <neilb@suse.de>, Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eyal Lebedinsky wrote:
> Neil Brown wrote:
> [trim Q re how resync fixes data]
>> For raid1 we 'fix' and inconsistency by arbitrarily choosing one copy
>> and writing it over all other copies.
>> For raid5 we assume the data is correct and update the parity.
> 
> Can raid6 identify the bad block (two parity blocks could allow this
> if only one block has bad data in a stripe)? If so, does it?
> 
> This will surely mean more value for raid6 than just the two-disk-failure
> protection.
> 

No.  It's not mathematically possible.

	-hpa
