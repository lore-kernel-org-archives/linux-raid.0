From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Mon, 18 Jul 2011 20:09:31 +0200
Message-ID: <j01ssr$j1i$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de> <j012fa$6k6$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j012fa$6k6$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/18/2011 12:35 PM, David Brown wrote:
> If there are no free erase blocks, then your SSD's don't have enough over-provisioning.

When you think about "How many free erase blocks are enough?" you'll come to the conclusion that 
this simply depends on the usage pattern.

Ideally, you'll want every write to a SSD to go to a completely free erase block, because if it 
doesn't, it's both slower and will probably also lead to a higher average number of write cycles 
(because more than one read-modify-write cycle per erase block may be required to fill it with new 
data, if that new data cannot be buffered in the SSDs RAM.)

If the goal is to have every write go to a free erase block, then you need to free up at least as 
many erase blocks per time period as data will be written during that time period (assuming the 
worst case that all writes will _not_ go to blocks that have been written to before).

Of course you can accomplish this by over-providing so much flash space that the SSD will always be 
capable of re-arranging the used data blocks such that they are tightly packed into fully used erase 
blocks, while the rest of the erase blocks are completely empty.
But that is a pretty expensive approach, essentially this requires 100% over-provisioing (or: 50 
usable capacity, or twice the price for the storage).
And, you still have to trust that the SSD will use that over-provisioned space the way you want 
(e.g. the SSD firmware could be inclined to only re-arrange erase blocks that have a certain ratio 
of unused sectors within them).

One good thing abort explicitely discarding sectors, while using most of the offered space is 
(besides the significant cost argument) that your SSD will likely invest effort to re-arrange 
sectors into fully allocated and fully free erase blocks exactly at the time when this makes most 
sense for you. It will have to copy only data that is actually still valid (reducing wear), and you 
may even choose a time at which you know that significant amounts of data have been deleted.

> Depending on the quality of the SSD (more expensive ones have more over-provisioning)

Alas, manufacturers tend to ask twice the price for much less than twice the over-provisioning,
so it's still advisable to buy the cheaper SSD and choose over-provisioning ratio by using
only part of it...


> TRIM, on the other hand, does not give you any extra free erase blocks. If you think it does, you've
> misunderstood it.

I have to disagree on this :-)

Imagine a SSD with 10 erase blocks capacity, each having place for 10 sectors.
Let's assume the SSD advertises only 90 sectors total capacity, over-providing one erase block.
Now I write 8 files each of 10 sectors size on the SSDs, then delete 2 of the 8 files.

If the SSD now performs some "garbage collection", it will not have more than 2 free erase blocks.

But if I discard/TRIM the unused sectors, and the SSD does the right thing about it, there will be 4 
free erase blocks.

So, yes, TRIM can gain you extra free erase blocks, but of course only if there is unused space in 
the filesystem.


> It may sometimes lead to saving
> whole erase blocks, but that's seldom the case in practice except when erasing large files.

Our different perception may result from our use-case involving frequent deletion of files, while 
yours doesn't.

But this is not only about "large files", only. Obviously, all modern SSDs are capable of 
re-arranging data into fully allocated and fully free erase-blocks, and this process can benefit 
from every single sector that has been discarded.


> If your filesystem re-uses (logical) blocks, then TRIM will not help.

If the only thing the filesystem does is overwriting blocks that held valid data right until they 
are overwritten with newer valid data, then TRIM will certainly not help.

But every discard that happens in between an invalidation of data and the overwriting of the same 
logical block can potentially benefit from a TRIM in between. Imagine a file of 1000 sectors, all 
valid data. Now your application decides to overwrite that file with 1000 sectors of newer data. 
Let's assume the FS is clever enough to use the same 1000 logical sectors for this. But let's also 
assume the RAM-cache of the SSD is only 20 logical sectors in size, and one erase-block is 10
sectors in size. Now the SSD needs to start writing from its RAM buffer to flash at least after 20 
sectors of data have been processed. If you are lucky, and everything was written in sequence, and 
well aligned, then the SSD may just need to erase and overwrite flash blocks that were formerly used 
for the same logical sectors. But if you are unlucky, the logical sectors to write are spread across 
different flash erase blocks. Thus the SSD can at best only mark them "unused" and has to write the 
data to a different (hopefully completely free) erase block. Again, if lucky (or heavily 
over-provisioned), you had >= 100 free erase blocks available when you started writing, and after 
they were written, 100 other erase blocks that held the older data can be freed after all 1000 
sectors have been written. But if you are unlucky, not that many free erase blocks were available 
when starting to write. Then, to write the new data, the SSD needs to read data from 
non-completely-free erase blocks, fill the unused sectors within them with the new data, and write 
back the erase-blocks - which means much lower performance, and more wear.
Now the same procedure with a "TRIM": After laying out the logical sectors to write to (but before 
writing to them), the filesystem can issue a "discard" on all those sectors. This will enable the 
SSD to mark all 100 erase blocks as completely free - even without additional "re-arranging". The 
following write operation to 1000 sectors may require erase-before write (if no pre-existing 
completely free erase-blocks can be used), but that is much better than having to do 
"read-modify-erase-write" cycles to the flash (and a larger number of that, since data has to be 
copied that the SSD cannot know to be obsolete).

So: While re-arranging of valid data into erase-blocks may be expensive enough to do it only 
"batched" from time to time, even the simple marking of sectors as discarded can help the 
performance and endurance of a SSD.

> It is /always/ more efficient
> for the FS to simply write new data to the same block, rather than TRIM'ing it first.

Depends on how expensive the marking of sectors as free is for the SSD, and how likely newly written 
data that fits into the SSDs cache will cause the freeing of complete erase blocks.


> TRIM is a very expensive command

That seems to depend a lot on the firmware of different drives.
But I agree that it might not be a good idea to rely on it being cheap.

 From the behaviour of the SSDs we like best it seems that TRIM is often only causing cheap "marking 
as free" operations, while sometimes, every few weeks, the SSD is actually doing a lot of 
re-arranging ("garbage collecting"?) stuff after the discards have been issued.
(Certainly also depends a lot on the usage pattern.)

> I believe that there has been work on a similar system
> in XFS

Yes, XFS supports that now, but alas, we cannot use it with MD, as MD will discard the discards :-)


> What will make a big difference to using SSD's in md raid is the sync/no-sync tracking. This will
> avoid a lot of unnecessary writes, especially with a new array, and leave the SSD with more free
> blocks (at least until the disk is getting full of data).

Hmmm... the sync/no-sync tracking will save you exactly one write to all sectors. That's certainly a 
good thing, but since a single "fstrim" after the sync will restore the "good performance" 
situation, I don't consider that an urgent feature.


> Filesystems already heavily re-use blocks, in the aim
> of preferring faster outer tracks on HD's, and minimizing head movement. So when a file is erased,
> there's a good chance that those same logical blocks will be re-used soon - TRIM is of no benefit in
> that case.

It is of benefit - to the performance of exactly those writes that go to the formerly used logical 
blocks.


> btrfs is ready for some uses, but is not mature and real-world tested enough for serious systems
> (and its tools are still lacking somewhat).

Let's not divert the discussion too much. I'll happily re-try btrfs when the developers say it's not 
experimental anymore, and when there's a "fsck"-like utility to check its integrity.

Regards,

Lutz Vieweg



