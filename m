From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: how to handle bad sectors in md control areas?
Date: Sun, 02 Mar 2014 11:56:22 +1100
Message-ID: <531281B6.1020404@eyal.emu.id.au>
References: <530DA2DE.9030705@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530DA2DE.9030705@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I did not get a clear reply, and decided to follow my assumption that
the 128MB header is used lightly (only 4K-16KB seem to be non zero).

I just cleared the bad block
	dd of=/dev/sdi1 bs=4K seek=32456 count=1 if=/dev/zero

The write was successful and no bad blocks were recorded in smart log.

Everything else looks good, and hopefully the next 'check' will stay
clean too.

The general question remains, at least some conformation of the how
much space is actually used in the header. Maybe add this to 'mdadm -E'?

cheers
	Eyal

On 02/26/14 19:16, Eyal Lebedinsky wrote:
> In another thread I investigated an issue with a pending sector, which now seems to be
> a bad sector inside the md header (the first 256k sectors).
>
> The question now remaining: what is the correct approach to fixing this problem?
>
> The more general issue is what to do when any md control area develops an error. does
> all data have redundant copies?
>
> The simple way that I see is to fail the member, remove it, clear it (at least
> --zero-superblock and write to the bad sector) and then add it. However this
> will incur a full resync (about 10 hours).
>
> Is there a faster, yet safe way? I was thinking that a clean umount and raid stop
> should allow a create with --assume-clean (which will write to the bad sector and
> "fix" it), but the doco discourages this.
>
> Also, it is not impossible to think that the specific bad sector (toward the end
> of the header) is not actually used today, meaning I can live with it as is, or
> write anything to the bad sector as it does not get used. Too involved though.
>
> A bad sector in the data area should be fixed with a standard raid 'check' action.
>
> TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
