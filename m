From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 09:27:32 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310270927.32751.dusty@strike.wu-wien.ac.at>
References: <1067179519.1222.107.camel@cala> <200310261716.17030.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310261716.17030.maarten@vbvb.nl>
Content-Disposition: inline
To: maarten van den Berg <maarten@vbvb.nl>, Mario Giammarco <mgiammarco@virgilio.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 26 October 2003 17:16, maarten van den Berg wrote:
> On Sunday 26 October 2003 15:45, Mario Giammarco wrote:
> > Hello,
> >
> >
> > My problem is: I have seen that RAID1 code does not interleave reads so
> > it does not improve performance very much putting two hard disks.
>
> After thinking about your question for a minute, I think I found the
> obvious reason for that.  Raid1 being a mirror set it does not make sense
> to interleave anything. Either disk1 reads it first or disk2 reads it
> first. Once you get the data from either disk, then you're done; no need to
> wait for the second disk (giving you the identical datablock).
> Interleaving only makes sense with other raid levels, but not with level 1.

It seems you're missing something: Interleaving means here, reading one part 
of the data from one disk and another part from the other disk, not reading 
the same data from both.

When reading a file from the RAID1, you could e.g. read the first block from 
the first disk, the second from the second disk, the third from the first 
disk and so on.

This would *theoretically* double the read speed - like with RAID0.

Practically this speed doubling would not occur as you have to add the seek 
times when reading files, but I assume with TCQ and things like that there 
could be some tricks to optimize the read behavior.

Anyway - it seems no RAID1 implementation - be it hardware or software RAID1 - 
seems to make use of this read performance increase. 

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

