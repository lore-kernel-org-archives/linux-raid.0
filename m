From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Re: LVM performance
Date: Sun, 09 Mar 2008 20:56:06 +0100
Message-ID: <47D440D6.90509@student.tuwien.ac.at>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>	<18360.8065.335494.142060@tree.ty.sabi.co.UK>	<20080217074526.29d3c5c5@hardcode42.net>	<20080218062604.05ae4821@szpak>	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>	<20080218154203.6e2d1483@szpak>	<47BB30DF.1080006@student.tuwien.ac.at>	<18364.6868.854623.613958@tree.ty.sabi.co.UK>	<47BED119.4070000@student.tuwien.ac.at> <18384.63840.605334.155518@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18384.63840.605334.155518@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi schrieb:
> pg> Those are as such not very meaningful. What matters most is
> pg> whether the starting physical address of each logical volume
> pg> extent is stripe aligned (and whether the filesystem makes use
> pg> of that) and then the stripe size of the parity RAID set, not
> pg> the chunk sizes in themselves. [ ... ]
> 
> om> Am I right to assume that stripe alignment matters because
> om> of the read-modify-write cycle needed for unaligned writes?
> 
> Sure, if you are writing as you say later. Note also that I was
> commenting on the points made about chunk size and alignment:
> 
>   jk> [ ... ] This might be related to raid chunk positioning with
>   jk> respect to LVM chunk positioning. If they interfere there
>   jk> indeed may be some performance drop. Best to make sure that
>   jk> those chunks are aligned together. [ ... ]
> 
>   om> I'm seeing a 20% performance drop too, with default RAID
>   om> and LVM chunk sizes of 64K and 4M, respectively. Since 64K
>   om> divides 4M evenly, I'd think there shouldn't be such a big
>   om> performance penalty.
> 
> As I said, if there is an issue with "interference", it is about
> stripes, not chunks, and both alignment and size, not just size.
> 

Thanks for explaining this. I think I finally got it ;-).
I will probably recreate the array anyway, so I might as well do it 
right this time. I currently have three drives, but when I run out of 
space, I will add a fourth. So the setup should be prepared for a reshape.

Based on what I understand, the things to look out for are:

  * LVM/md first extent stripe alignment: when creating the PV, specify 
a --metadatasize that is divisible by all anticipated stripe sizes, 
i.e., the least common multiple. For example, to accommodate for 3, 4 or 
5 drive configurations with 64KB chunk size, that would be 768KB.

  * Alignment of other extents: for the initial array creation with 3 
drives the default 4MB extent size is fine. When I add a fourth drive, I 
can resize the extents with vgchange - though I'm a bit hesitant as the 
manpage doesn't explicitly say that this doesn't destroy any data. The 
bigger problem is that the extent size must be a power of two, so the 
maximum I can use with 192KB stripe size is 64KB. I'll see if that hurts 
performance. The vgchange manpage says it doesn't...

  * Telling the file system that the underlying device is striped. ext3 
has the stride parameter, and changing it doesn't seem to be possible. 
XFS might be better, as the swidth/sunit options can be set at 
mount-time. This would speed up writes, while reads of existing data 
wouldn't be affected too much by the misalignment anyway. Right?

> Reading from the outer tracks of a RAID5 2+1 on contemporary
> 500GB drives should give you at least 100-120MB/s (as if it were
> a 2x RAID0), and the numbers that you are reporting above seem
> meaningless for a comparison between MD and DM, because there
> must be something else that makes them both perform very badly.

The general slowness is due to the fact that I'm using external drives, 
two USB ones and one Firewire. To add insult to injury, the two USB 
drives share one port with a hub, so it's obviously not going to be very 
fast. Also, it's probably not the best idea since it adds another 
potential single point of failure...
That said, the machine is currently down for hardware troubleshooting 
(see my other thread "RAID-5 data corruption" for that) and if it turns 
out the USB controller is indeed flaky, i might end up replacing the 
whole thing with a more sensible configuration.

> 
> Odds are that your test was afflicted by the page cache
> read-ahead horror that several people have reported, and that I
> have investigated in detail in a recent posting to this list,
> with the conclusion that it is a particularly grave flaw in the
> design and implementation of Linux IO.

Do you mean the "slow raid5 performance" thread from October where you 
pointed out that the page cache is rather CPU-intensive?
Also, it might be related to read-ahead: It was 128 for md0 and 256 for 
dm-0, and after I set it to 3072 for both, I got about the same 
sequential read performance (~50MB/s) for both.
> 
> Since the horror comes from poor scheduling of streaming read
> sequences, there is wide variability among tests using the same
> setup, and most likely DM and MD have a slightly different
> interaction with the page cache.
> 
> PS: maybe you are getting 40-50MB/s only because of some other
>     reason, e.g. a slow host adapter or host bus, but whatever
>     it is, it results in an improper comparison between DM and
>     MD.

Okay, I'll shut up. :-)

-- 
Oliver
