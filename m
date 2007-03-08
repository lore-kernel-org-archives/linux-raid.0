From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mismatch_cnt questions
Date: Wed, 07 Mar 2007 22:39:52 -0800
Message-ID: <45EFAFB8.3070703@zytor.com>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<45EB3867.8050907@eyal.emu.id.au>	<17899.18568.523543.478792@notabene.brown>	<45EBCA83.40106@eyal.emu.id.au> <17900.43653.510415.553440@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17900.43653.510415.553440@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday March 5, eyal@eyal.emu.id.au wrote:
>> Neil Brown wrote:
>> [trim Q re how resync fixes data]
>>> For raid1 we 'fix' and inconsistency by arbitrarily choosing one copy
>>> and writing it over all other copies.
>>> For raid5 we assume the data is correct and update the parity.
>> Can raid6 identify the bad block (two parity blocks could allow this
>> if only one block has bad data in a stripe)? If so, does it?
> 
> No, it doesn't.
> 
> I guess that maybe it could:
>    Rebuild each block in turn based on the xor parity, and then test 
>    if the Q-syndrome is satisfied.
> but I doubt the gain would be worth the pain.
> 
> What we really want in drives that store 520 byte sectors so that a
> checksum can be passed all the way up and down through the stack
> .... or something like that.
> 

A lot of SCSI disks have that option, but I believe it's not arbitrary 
bytes.  In particular, the integrity check portion is only 2 bytes, 16 bits.

One option, of course, would be to store, say, 16 sectors/pages/blocks 
in 17 physical sectors/pages/blocks, where the last one is a packing of 
some sort of high-powered integrity checks, e.g. SHA-256, or even an ECC 
block.  This would hurt performance substantially, but it would be 
highly useful for very high data integrity applications.

I will look at the mathematics of trying to do this with RAID-6, but I'm 
99% sure RAID-6 isn't sufficient to do it, even with syndrome set 
recomputation on every read.

	-hpa
