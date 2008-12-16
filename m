From: "Chris Worley" <worleys@gmail.com>
Subject: Re: detection/correction of corruption with raid6
Date: Tue, 16 Dec 2008 15:20:03 -0700
Message-ID: <f3177b9e0812161420s53b7699focf6a4b06d83a307@mail.gmail.com>
References: <1228510833.16555.76.camel@localhost>
	 <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>
	 <1228511195.16555.78.camel@localhost>
	 <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan>
	 <1228511558.16555.84.camel@localhost>
	 <6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>
	 <1229095884.16555.144.camel@localhost>
	 <18759.4982.86181.792757@notabene.brown>
	 <Pine.GSO.4.64.0812160835190.22670@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0812160835190.22670@montezuma.acc.umu.se>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 16, 2008 at 12:59 AM, Mattias Wadenstein <maswan@acc.umu.se> wrote:
> On Tue, 16 Dec 2008, Neil Brown wrote:
>> On Friday December 12, redeeman@metanurb.dk wrote:
>>
>> As has been said elsewhere in this thread, silent corruption is rarely
>> if ever caused by the storage device.  They tend to have strong CRCs
>> etc which detect bit-flips with greater reliability than the RAID6
>> algorithm would detect them.
>
> If by storage device, you mean the actual disk, then yes, it seems that way.
> At least in practice. In theory hdd manufacturers only guarantee you get a
> bitflip less often than once every 10^14 or 10^15 bits. Which is quite
> often. 10^14 bits is roughly the ammount of data read during a resync of a
> large:ish raidset.
>
> In general, I agree that a checksumming filesystem is more important for
> data integrity. This is why all new fileservers around here are running
> Solaris+ZFS instead of Linux.

I've seen many high-end arrays, such as those done by DDN
(www.datadirectnet.com), that spend idle time scouring the drives for
corruption.  They don't think it's insignificant.

I've had Linux RAID5 MD arrays with silent corrupt data, that could
have detected/corrected by idle scouring (before a disk goes bad
altogether, when the silent/corrupted data on a "good" disk becomes
totally unrecoverable).

SSD's like FusionIO have strong ECC built into every write (11 bits
per 240 bytes) that extend the usable life of NAND storage from 100K
writes per cell (using the industry standard 1 bit per 512 bytes) into
decades (they constantly scour too).

Chris
