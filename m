From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: detection/correction of corruption with raid6
Date: Tue, 16 Dec 2008 08:59:20 +0100 (MET)
Message-ID: <Pine.GSO.4.64.0812160835190.22670@montezuma.acc.umu.se>
References: <1228510833.16555.76.camel@localhost>
 <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan> <1228511195.16555.78.camel@localhost>
 <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan> <1228511558.16555.84.camel@localhost>
 <6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>
 <1229095884.16555.144.camel@localhost> <18759.4982.86181.792757@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18759.4982.86181.792757@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Redeeman <redeeman@metanurb.dk>, =?iso-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 Dec 2008, Neil Brown wrote:

> On Friday December 12, redeeman@metanurb.dk wrote:
>>>
>>> It is possible (by the theory of Q syndrome, per the article you
>>> linked) to detect which drive is doing a silent corruption with raid6
>>> (and with some extra assumption, that just one drive is doing that).
>>> But it's not implemented.
>>
>> thats a shame, it seems like a KILLER feature, but i guess its not too
>> simple to do, or it would have been done already :)
>
> The reason that it hasn't been done is not that it is difficult.
> Certainly it is not trivial, but more complicated things have been
> implemented.
>
> The reason that it is not even on my TODO list is that I don't think
> it is justifiable.
>
> As has been said elsewhere in this thread, silent corruption is rarely
> if ever caused by the storage device.  They tend to have strong CRCs
> etc which detect bit-flips with greater reliability than the RAID6
> algorithm would detect them.

If by storage device, you mean the actual disk, then yes, it seems that 
way. At least in practice. In theory hdd manufacturers only guarantee you 
get a bitflip less often than once every 10^14 or 10^15 bits. Which is 
quite often. 10^14 bits is roughly the ammount of data read during a 
resync of a large:ish raidset.

In general, I agree that a checksumming filesystem is more important for 
data integrity. This is why all new fileservers around here are running 
Solaris+ZFS instead of Linux.

/Mattias Wadenstein
