From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: Rewrite md raid1 member
Date: Thu, 18 Aug 2016 14:01:51 +1000
Message-ID: <20160818040151.GA21256@onthe.net.au>
References: <20160818030451.GA17225@onthe.net.au>
 <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 18, 2016 at 11:27:55AM +0800, Brad Campbell wrote:
> On 18/08/16 11:04, Chris Dunlop wrote:
>> G'day all,
>>
>> What options are there to safely rewrite a disk that's part of a live MD
>> raid1?
>>
>> Specifically, I have smartctl reporting a Current_Pending_Sector of 360 on a
>> member of a raid1 set.
>>
>> A 'check' of the raid comes up clean. I'd like to see if I can clear the
>> pending sector count by rewriting the sectors. Whilst rewriting just those
>> sectors would be ideal, I don't know which they are, so it looks like a
>> whole disk write is the way to go.
> 
> A smartctl -t long on the drive will error out at the first problematic
> sector and put that LBA in the SMART log, so there's a start.

I should have mentioned: a 'smartctl -t long' on the drive came up clean.

> Another way to determine it is run dd from the drive, and it will abort on
> the first error telling you how many records it managed to copy. With the
> default bs of 512, that gives you a sector number.

A 'dd' read of the whole disk also came up clean.

From what I can gather, a "pending sector" is one that's a bit suspect, but
may actually be ok. It seems mine are ok (at least for reading), but the
pending count won't clear until a write succeeds (or fails, and the sector
is remapped).

>> Or is this 'dd' stuff just nuts, a case of "well that's a novel way of
>> trashing your data..." and/or "you're welcome to try, but you get to keep
>> all the pieces and don't come crying to us for help!"?
> 
> Pretty much. If a RAID check is not touching them, then they are likely in
> the vacant area around the superblock. Nothing touches that, and playing
> with it can lead to tears if you misfire and hit the superblock or the data.

Sure - I understand the risks.

> If the superblock is ok, and the errors are outside of the data area I've
> taken a drive out of the array, used dd_rescue to clone the area of the
> drive in question and then written that back to the disk and re-added to the
> array. That just re-writes the good data and with zeros where the bad
> sectors were.
> 
> That is a horrible, horrible procedure that I did on an array I use for
> testing and has no valuable data on. I would not recommend it if you care
> about your array or data.

I'm interested to see if there's a way of essentially doing the above on a
live system, assuming there's appropriate care taken to not trash any
existing data (including superblocks).

I.e. is it *theoretically* possible to write the same data back to the whole
disk safely. E.g. using 'dd' from/to the same disk is almost there, but, as
described, there's a window of opportunity where you could get stale data on
the disk and a raid repair could then copy that stale data to the good disk.

> Brad

Thanks,

Chris
