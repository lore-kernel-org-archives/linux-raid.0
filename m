From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 22:26:25 +0100
Message-ID: <200501092226.25910.maarten@ultratux.net>
References: <crmt7e$8d6$1@sea.gmane.org> <200501081749.32816.maarten@ultratux.net> <20050109193353.GB9524@janus>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050109193353.GB9524@janus>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 09 January 2005 20:33, Frank van Maarseveen wrote:
> On Sat, Jan 08, 2005 at 05:49:32PM +0100, maarten wrote:

> > However, IF during that
> > resync one other drive has a read error, it gets kicked too and the array
> > dies.  The chances of that happening are not very small;
>
> Ouch! never considered this. So, RAID5 will actually decrease reliability
> in a significant number of cases because:

> -	>1 read errors can cause a total break-down whereas it used
> 	to cause only a few userland I/O errors, disruptive but not foobar.

Well, yes and no.  You can decide to do a full backup in case you hadn't, 
prior to changing drives. And if it is _just_ a bad sector, you can 'assemble 
--force' yielding what you would've had in a non-raid setup; some file 
somewhere that's got corrupted. No big deal, ie. the same trouble as was 
caused without raid-5.

> -	disk replacement is quite risky. This is totally unexpected to me
> 	but it should have been obvious: there's no bad block list in MD
> 	so if we would postpone I/O errors during reconstruction then
> 	1:	it might cause silent data corruption when I/O error
> 		unexpectedly disappears.
> 	2:	we might silently loose redundancy in a number of places.

Not sure if I understood all of that, but I think you're saying that md 
_could_ disregard read errors _when_already_running_in_degraded_mode_ so as 
to preserve the array at all cost.  Hum.  That choice should be left to the 
user if it happens, he probably knows best what to choose in the 
circumstances.

No really, what would be best is that md made a difference between total media 
failure and sector failure.  If one sector is bad on one drive [and it gets 
kicked therefore] it should be possible when a further read error occurs on 
other media, to try and read the missing sector data from the kicked drive, 
who may well have the data there waiting, intact and all.

Don't know how hard that is really, but one could maybe think of pushing a 
disk in an intermediate state between "failed" and "good" like "in_disgrace" 
what signals to the end user "Don't remove this disk as yet; we may still 
need it, but add and resync a spare at your earliest convenience as we're 
running in degraded mode as of now".
Hmm.  Complicated stuff. :-)

This kind of error will get more and more predominant with growing media and 
decreasing disk quality. Statistically there is not a huge chance of getting 
a read failure on a 18GB scsi disk, but on a cheap(ish) 500 GB ATA disk that 
is an entrirely different ballpark. 

> I think RAID6 but especially RAID1 is safer.

Well, duh :)  At the expense of buying everything twice, sure it's safer :))

> A small side note on disk behavior:
> If it becomes possible to do block remapping at any level (MD, DM/LVM,
> FS) then we might not want to write to sectors with read errors at all
> but just remap the corresponding blocks by software as long as we have
> free blocks: save disk-internal spare sectors so the disk firmware can
> pre-emptively remap degraded but ECC correctable sectors upon read.

Well I dunno.  In ancient times, the OS was charged with remapping bad sectors 
back when disk drives had no intelligence.  Now we delegated that task to the 
disk.  I'm not sure reverting back to the old behaviour is a smart move.
But with raid, who knows...

And as it is I don't think you get the chance to save the disk-internal spare 
sectors; the disk handles that transparently so any higher layer cannot only 
not prevent that, but is even kept completely ignorant to it happening. 

Maarten


