From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: [general question] rare silent data corruption when writing data
Date: Wed, 13 May 2020 16:31:27 +1000
Message-ID: <20200513063127.GA2769@onthe.net.au>
References: <b0e91faf-3a14-3ac9-3c31-6989154791c1@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b0e91faf-3a14-3ac9-3c31-6989154791c1@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Thu, May 07, 2020 at 07:30:19PM +0200, Michal Soltys wrote:
> Note: this is just general question - if anyone experienced something 
> similar or could suggest how to pinpoint / verify the actual cause.
>
> Thanks to btrfs's checksumming we discovered somewhat (even if quite 
> rare) nasty silent corruption going on on one of our hosts. Or perhaps 
> "corruption" is not the correct word - the files simply have precise 4kb 
> (1 page) of incorrect data. The incorrect pieces of data look on their 
> own fine - as something that was previously in the place, or written 
> from wrong source.

"Me too!"

We are seeing 256-byte corruptions which are always the last 256b of a 4K 
block. The 256b is very often a copy of a "last 256b of 4k block" from 
earlier on the file. We sometimes see multiple corruptions in the same 
file, with each of the corruptions being a copy of a different 256b from 
earlier on the file. The original 256b and the copied 256b aren't 
identifiably at a regular offset from each other. Where the 256b isn't a 
copy from earlier in the file

I'd be really interested to hear if your problem is just in the last 256b 
of the 4k block also!

We haven't been able to track down any the origin of any of the copies 
where it's not a 256b block earlier in the file. I tried some extensive 
analysis of some of these occurrences, including looking at files being 
written around the same time, but wasn't able to identify where the data 
came from. It could be the "last 256b of 4k block" from some other file 
being written at the same time, or a non-256b aligned chunk, or indeed not 
a copy of other file data at all.

See Also: https://lore.kernel.org/linux-xfs/20180322150226.GA31029@onthe.net.au/

We've been able to detect these corruptions via an md5sum calculated as 
the files are generated, where a later md5sum doesn't match the original.  
We regularly see the md5sum match soon after the file is written (seconds 
to minutes), and then go "bad" after doing a "vmtouch -e" to evict the 
file from memory. I.e. it looks like the problem is occurring somewhere on 
the write path to disk. We can move the corrupt file out of the way and 
regenerate the file, then use 'cmp -l' to see where the corruption[s] are, 
and calculate md5 sums for each 256b block in the file to identify where 
the 256b was copied from.

The corruptions are far more likely to occur during a scrub, although we 
have seen a few of them when not scrubbing. We're currently working around 
the issue by scrubbing infrequently, and trying to schedule scrubs during 
periods of low write load.

> The hardware is (can provide more detailed info of course):
>
> - Supermicro X9DR7-LN4F
> - onboard LSI SAS2308 controller (2 sff-8087 connectors, 1 connected to 
>   backplane)
> - 96 gb ram (ecc)
> - 24 disk backplane
>
> - 1 array connected directly to lsi controller (4 disks, mdraid5, 
>   internal bitmap, 512kb chunk)
> - 1 array on the backplane (4 disks, mdraid5, journaled)
> - journal for the above array is: mdraid1, 2 ssd disks (micron 5300 pro 
>   disks)
> - 1 btrfs raid1 boot array on motherboard's sata ports (older but still 
>   fine intel ssds from DC 3500 series)

Ours is on similar hardware:

- Supermicro X8DTH-IF
- LSI SAS 9211-8i  (LSI SAS2008, PCI-e 2.0, multiple firmware versions)
- 192GB ECC RAM
- A mix of 12 and 24-bay expanders (some daisy chained: lsi-expander-expander)

We swapped the LSI HBA for another of the same model, the problem 
persisted. We have a SAS9300 card on the way for testing.

> Raid 5 arrays are in lvm volume group, and the logical volumes are used 
> by VMs. Some of the volumes are linear, some are using thin-pools (with 
> metadata on the aforementioned intel ssds, in mirrored config). LVM uses 
> large extent sizes (120m) and the chunk-size of thin-pools is set to 
> 1.5m to match underlying raid stripe. Everything is cleanly aligned as 
> well.

We're not using VMs nor lvm thin on this storage.

Our main filesystem is xfs + lvm + raid6 and this is where we've seen all 
but one of these corruptions (70-100 since Mar 2018).

The problem has occurred on all md arrays under the lvm, on disks from 
multiple vendors and models, and on disks attached to all expanders.

We've seen one of these corruptions with xfs directly on a hdd partition.  
I.e. no mdraid or lvm involved. This fs an order of magnitude or more less 
utilised than the main fs in terms of data being written.

> We did not manage to rule out (though somewhat _highly_ unlikely):
>
> - lvm thin (issue always - so far - occured on lvm thin pools)
> - mdraid (issue always - so far - on mdraid managed arrays)
> - kernel (tested with - in this case - debian's 5.2 and 5.4 kernels, 
>   happened with both - so it would imply rather already longstanding bug 
>   somewhere)

- we're not using lvm thin
- problem has occurred once on non-mdraid (xfs directly on a hdd partition)
- problem NOT seen on kernel 3.18.25
- problem seen on, so far, kernels 4.4.153 - 5.4.2

> And finally - so far - the issue never occured:
>
> - directly on a disk
> - directly on mdraid
> - on linear lvm volume on top of mdraid

- seen once directly on disk (partition)
- we don't use mdraid directly
- our problem arises on linear lvm on top of mdraid (raid6)

> As far as the issue goes it's:
>
> - always a 4kb chunk that is incorrect - in a ~1 tb file it can be from 
>   a few to few dozens of such chunks
> - we also found (or rather btrfs scrub did) a few small damaged files as 
>   well
> - the chunks look like a correct piece of different or previous data
>
> The 4kb is well, weird ? Doesn't really matter any chunk/stripes sizes 
> anywhere across the stack (lvm - 120m extents, 1.5m chunks on thin 
> pools; mdraid - default 512kb chunks). It does nicely fit a page though 
> ...
>
> Anyway, if anyone has any ideas or suggestions what could be happening 
> (perhaps with this particular motherboard or vendor) or how to pinpoint 
> the cause - I'll be grateful for any.

Likewise!

Cheers,

Chris
