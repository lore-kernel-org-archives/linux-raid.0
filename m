From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 12:08:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310271208.04442.maarten@vbvb.nl>
References: <1067179519.1222.107.camel@cala> <200310261716.17030.maarten@vbvb.nl> <200310270927.32751.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310270927.32751.dusty@strike.wu-wien.ac.at>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 27 October 2003 09:27, Hermann Himmelbauer wrote:
> On Sunday 26 October 2003 17:16, maarten van den Berg wrote:
> > On Sunday 26 October 2003 15:45, Mario Giammarco wrote:
> > > Hello,
> > >
> > >
> > > My problem is: I have seen that RAID1 code does not interleave reads so
> > > it does not improve performance very much putting two hard disks.
> >
> > After thinking about your question for a minute, I think I found the
> > obvious reason for that.  Raid1 being a mirror set it does not make sense
> > to interleave anything. Either disk1 reads it first or disk2 reads it
> > first. Once you get the data from either disk, then you're done; no need
> > to wait for the second disk (giving you the identical datablock).
> > Interleaving only makes sense with other raid levels, but not with level
> > 1.
>
> It seems you're missing something: Interleaving means here, reading one
> part of the data from one disk and another part from the other disk, not
> reading the same data from both.

I know what interleaving means; I just think it is counterproductive in Raid1.

> When reading a file from the RAID1, you could e.g. read the first block
> from the first disk, the second from the second disk, the third from the
> first disk and so on.

The way it works now, AFAIK, is that concurrent read commands are issued to 
all the drives in Raid1.  Because of seek times and the amount of rotation 
needed to get the right sector underneath the head(s), one of the disks will 
be first to transfer the data. This can be 'sooner' by a large amount.

If you instead want to interleave reads you lose the possibility to gain speed 
from this mechanism described above. It would be a trade-off and I'm not sure 
interleaving would come out as the winner here. Interleaving comes from for 
instance RAM access. But a RAM chip has to 'recover' from a read, i.e. it 
needs a little bit of time in between each read. Interleaving there is very 
sensible since you can let one bank 'rest' while the other bank 'works'.

For disks, this is not so; once the right sector is under the head the hard 
work is done; reading on onto following or adjacent sectors happens at or 
near the theoretical full speed. If you switch drives after 128 blocks you 
slow your transfer, not speed it up.  This will depend on many many factors 
like how large a read it is and how scattered the data is across the platter.

But, maybe I'm way off base here and new insights have changed this.  :-)

Greetings,
Maarten

> This would *theoretically* double the read speed - like with RAID0.
>
> Practically this speed doubling would not occur as you have to add the seek
> times when reading files, but I assume with TCQ and things like that there
> could be some tricks to optimize the read behavior.
>
> Anyway - it seems no RAID1 implementation - be it hardware or software
> RAID1 - seems to make use of this read performance increase.
>
> 		Best Regards,
> 		Hermann

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
