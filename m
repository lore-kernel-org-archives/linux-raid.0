From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Fri, 6 Jan 2012 21:11:50 +0100
Message-ID: <20120106201150.GB13358@fi.muni.cz>
References: <20111212115459.GC20730@fi.muni.cz>
 <4EE61EAE.20101@anonymous.org.uk>
 <20120106150823.GX25976@fi.muni.cz>
 <20231.9177.523012.471046@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20231.9177.523012.471046@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:
: > half of the disks forming the RAID-10 volume disappeared.
: > After removing them using mdadm --remove, and adding them
: > back, iostat reports that they are resynced one disk a time,
: > not all just-added disks in parallel.
: 
: That's very interesting news. Thanks for reporting this though,
: it is something to keep in mind.

	Yes. My HBA is able to do 4 GByte/s bursts according to the
documentation, and I am able to get 2.4 GByte/s sustained. So getting
only about 120-150 MByte/s for RAID-10 resync is really disappointing.

: > [ ... ] Otherwise it would be better for us to discard RAID-10
: > altogether, and use several independent RAID-1 volumes joined
: > together
: 
: I suspect that that MD runs one recovery per array at a time,
: and 'raid10' arrays are a single array.

	Yes, but when the array is being assembled initially
(without --assume-clean), the MD RAID-10 can resync all pairs
of disks at once. It is still limited to two threads (mdX_resync
and mdX_raid10), so for widely-interleaved RAID-10 CPUs can still
be a bottleneck (see my post in this thread from last May or April).
But it is still much better than 120-150 MByte/s.

: You might try a two layer arrangements, as a 'raid0' of 'raid1'
: pairs, instead of a 'raid10'. The two things with MD are not the
: same, for example you can do layouts like a 3-drive 'raid10'.
: 
: > using LVM (which we will probably use on top of the RAID-10
: > volume anyway).
: 
: Oh no! LVM is nowhere as nice as MD for RAIDing and is otherwise
: largely useless (except regrettably for snapshots) and has some
: annoying limitations.

        I think LVM on top of RAID-10 (or more RAID-1 volumes)
is actually pretty nice. With RAID-10 it is a bit easier to handle,
because the upper layer (LVM) does not need to know about proper
interleaving of lower layers. And I suspect that XFS swidth/sunit
settings will still work with RAID-10 parameters even over plain
LVM logical volume on top of that RAID 10, while the settings would
be more tricky when used with interleaved LVM logical volume on top
of several RAID-1 pairs (LVM interleaving uses LE/PE-sized stripes, IIRC).

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
