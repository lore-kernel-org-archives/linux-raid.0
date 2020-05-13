From: "John Stoffel" <john@stoffel.org>
Subject: Re: [general question] rare silent data corruption when writing data
Date: Wed, 13 May 2020 13:49:10 -0400
Message-ID: <24252.13078.107482.898516@quad.stoffel.home>
References: <b0e91faf-3a14-3ac9-3c31-6989154791c1@yandex.pl>
        <20200513063127.GA2769@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200513063127.GA2769@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: Michal Soltys <msoltyspl@yandex.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I wonder if this problem can be replicated on loop devices?  Once
there's a way to cause it reliably, we can then start doing a
bisection of the kernel to try and find out where this is happening.

So far, it looks like it happens sometimes on bare RAID6 systems
without lv-thin in place, which is both good and bad.  And without
using VMs on top of the storage either.  So this helps narrow down the
cause.  

Is there any info on the work load on these systems?  Lots of small
fils which are added/removed?  Large files which are just written to
and not touched again?

I assume finding a bad file with corruption and then doing a cp of the
file keeps the same corruption?  


>>>>> "Chris" == Chris Dunlop <chris@onthe.net.au> writes:

Chris> Hi,

Chris> On Thu, May 07, 2020 at 07:30:19PM +0200, Michal Soltys wrote:
>> Note: this is just general question - if anyone experienced something 
>> similar or could suggest how to pinpoint / verify the actual cause.
>> 
>> Thanks to btrfs's checksumming we discovered somewhat (even if quite 
>> rare) nasty silent corruption going on on one of our hosts. Or perhaps 
>> "corruption" is not the correct word - the files simply have precise 4kb 
>> (1 page) of incorrect data. The incorrect pieces of data look on their 
>> own fine - as something that was previously in the place, or written 
>> from wrong source.

Chris> "Me too!"

Chris> We are seeing 256-byte corruptions which are always the last 256b of a 4K 
Chris> block. The 256b is very often a copy of a "last 256b of 4k block" from 
Chris> earlier on the file. We sometimes see multiple corruptions in the same 
Chris> file, with each of the corruptions being a copy of a different 256b from 
Chris> earlier on the file. The original 256b and the copied 256b aren't 
Chris> identifiably at a regular offset from each other. Where the 256b isn't a 
Chris> copy from earlier in the file

Chris> I'd be really interested to hear if your problem is just in the last 256b 
Chris> of the 4k block also!

Chris> We haven't been able to track down any the origin of any of the copies 
Chris> where it's not a 256b block earlier in the file. I tried some extensive 
Chris> analysis of some of these occurrences, including looking at files being 
Chris> written around the same time, but wasn't able to identify where the data 
Chris> came from. It could be the "last 256b of 4k block" from some other file 
Chris> being written at the same time, or a non-256b aligned chunk, or indeed not 
Chris> a copy of other file data at all.

Chris> See Also: https://lore.kernel.org/linux-xfs/20180322150226.GA31029@onthe.net.au/

Chris> We've been able to detect these corruptions via an md5sum calculated as 
Chris> the files are generated, where a later md5sum doesn't match the original.  
Chris> We regularly see the md5sum match soon after the file is written (seconds 
Chris> to minutes), and then go "bad" after doing a "vmtouch -e" to evict the 
Chris> file from memory. I.e. it looks like the problem is occurring somewhere on 
Chris> the write path to disk. We can move the corrupt file out of the way and 
Chris> regenerate the file, then use 'cmp -l' to see where the corruption[s] are, 
Chris> and calculate md5 sums for each 256b block in the file to identify where 
Chris> the 256b was copied from.

Chris> The corruptions are far more likely to occur during a scrub, although we 
Chris> have seen a few of them when not scrubbing. We're currently working around 
Chris> the issue by scrubbing infrequently, and trying to schedule scrubs during 
Chris> periods of low write load.

>> The hardware is (can provide more detailed info of course):
>> 
>> - Supermicro X9DR7-LN4F
>> - onboard LSI SAS2308 controller (2 sff-8087 connectors, 1 connected to 
>> backplane)
>> - 96 gb ram (ecc)
>> - 24 disk backplane
>> 
>> - 1 array connected directly to lsi controller (4 disks, mdraid5, 
>> internal bitmap, 512kb chunk)
>> - 1 array on the backplane (4 disks, mdraid5, journaled)
>> - journal for the above array is: mdraid1, 2 ssd disks (micron 5300 pro 
>> disks)
>> - 1 btrfs raid1 boot array on motherboard's sata ports (older but still 
>> fine intel ssds from DC 3500 series)

Chris> Ours is on similar hardware:

Chris> - Supermicro X8DTH-IF
Chris> - LSI SAS 9211-8i  (LSI SAS2008, PCI-e 2.0, multiple firmware versions)
Chris> - 192GB ECC RAM
Chris> - A mix of 12 and 24-bay expanders (some daisy chained: lsi-expander-expander)

Chris> We swapped the LSI HBA for another of the same model, the problem 
Chris> persisted. We have a SAS9300 card on the way for testing.

>> Raid 5 arrays are in lvm volume group, and the logical volumes are used 
>> by VMs. Some of the volumes are linear, some are using thin-pools (with 
>> metadata on the aforementioned intel ssds, in mirrored config). LVM uses 
>> large extent sizes (120m) and the chunk-size of thin-pools is set to 
>> 1.5m to match underlying raid stripe. Everything is cleanly aligned as 
>> well.

Chris> We're not using VMs nor lvm thin on this storage.

Chris> Our main filesystem is xfs + lvm + raid6 and this is where we've seen all 
Chris> but one of these corruptions (70-100 since Mar 2018).

Chris> The problem has occurred on all md arrays under the lvm, on disks from 
Chris> multiple vendors and models, and on disks attached to all expanders.

Chris> We've seen one of these corruptions with xfs directly on a hdd partition.  
Chris> I.e. no mdraid or lvm involved. This fs an order of magnitude or more less 
Chris> utilised than the main fs in terms of data being written.

>> We did not manage to rule out (though somewhat _highly_ unlikely):
>> 
>> - lvm thin (issue always - so far - occured on lvm thin pools)
>> - mdraid (issue always - so far - on mdraid managed arrays)
>> - kernel (tested with - in this case - debian's 5.2 and 5.4 kernels, 
>> happened with both - so it would imply rather already longstanding bug 
>> somewhere)

Chris> - we're not using lvm thin
Chris> - problem has occurred once on non-mdraid (xfs directly on a hdd partition)
Chris> - problem NOT seen on kernel 3.18.25
Chris> - problem seen on, so far, kernels 4.4.153 - 5.4.2

>> And finally - so far - the issue never occured:
>> 
>> - directly on a disk
>> - directly on mdraid
>> - on linear lvm volume on top of mdraid

Chris> - seen once directly on disk (partition)
Chris> - we don't use mdraid directly
Chris> - our problem arises on linear lvm on top of mdraid (raid6)

>> As far as the issue goes it's:
>> 
>> - always a 4kb chunk that is incorrect - in a ~1 tb file it can be from 
>> a few to few dozens of such chunks
>> - we also found (or rather btrfs scrub did) a few small damaged files as 
>> well
>> - the chunks look like a correct piece of different or previous data
>> 
>> The 4kb is well, weird ? Doesn't really matter any chunk/stripes sizes 
>> anywhere across the stack (lvm - 120m extents, 1.5m chunks on thin 
>> pools; mdraid - default 512kb chunks). It does nicely fit a page though 
>> ...
>> 
>> Anyway, if anyone has any ideas or suggestions what could be happening 
>> (perhaps with this particular motherboard or vendor) or how to pinpoint 
>> the cause - I'll be grateful for any.

Chris> Likewise!

Chris> Cheers,

Chris> Chris
