From: David Brown <david.brown@hesbynett.no>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Tue, 21 Jan 2014 10:18:14 +0100
Message-ID: <52DE3B56.2000506@hesbynett.no>
References: <20140120203433.GY6553@blisses.org> <20140121084617.582f9b75@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121084617.582f9b75@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Mason Loring Bliss <mason@blisses.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/01/14 22:46, NeilBrown wrote:
> On Mon, 20 Jan 2014 15:34:33 -0500 Mason Loring Bliss <mason@blisses.org>
> wrote:
> 
>> I was initially writing to HPA, and he noted the existence of this list, so
>> I'm going to boil down what I've got so far for the list. In short, I'm
>> trying to understand if there's a reasonable way to get something equivlant
>> to ZFS/BTRFS on-a-mirror-with-scrubbing if I'm using MD RAID 6.
>>
>>
>>
>> I recently read (or attempted to read, for those sections that exceeded my
>> background in math) HPA's paper "The mathematics of RAID-6", and I was
>> particularly interested in section four, "Single-disk corruption recovery".
>> What I'm wondering if he's describing something theoretically possible given
>> the redundant data RAID 6 stores, or something that's actually been
>> implemented in (specifically) MD RAID 6 on Linux.
>>
>> The world is in a rush to adopt ZFS and BTRFS, but there are dinosaurs among
>> us that would love to maintain proper layering with the RAID layer being able
>> to correct for bitrot itself. A common scenario that would benefit from this
>> is having an encrypted layer sitting atop RAID, with LVM atop that.
>>
>>
>>
>> I just looked through the code for the first time today, and I'd love to know
>> if my understanding is correct. My current read of the code is as follows:
>>
>> linux-source/lib/raid6/recov.c suggests that for a single-disk failure,
>> recovery is handled by the RAID 5 code. In raid5.c, if I'm reading it
>> correctly, raid5_end_read_request will request a rewrite attempt if uptodate
>> is not true, which can call md_error, which can initiate recovery.
>>
>> I'm struggling a little to trace recovery, but it does seem like MD maintains
>> a list of bad blocks and can map out bad sectors rather than marking a whole
>> drive as being dead.
>>
>> Am I correct in assuming that bitrot will show up as a bad read, thus making
>> the read check fail and causing a rewrite attempt, which will mark the sector
>> in question as bad and write the data somewhere else if it's detected? If
>> this is the case then there's a very viable, already deployed option for
>> catching bitrot that doesn't require complete upheaval of how people manage
>> disk space and volumes nowadays.
> 
> ars technica recently had an article about "Bitrot and atomics COWs: Inside
> "next-gen" filesystems."
> 
> http://feeds.arstechnica.com/~r/arstechnica/everything/~3/Cb4ylzECYVQ/
> 
> Early on it talks about creating a brtfs filesystem with RAID1 configured and
> then binary-editing one of the device to flip one bit.  Then magically btrfs
> survives while some other filesystem suffered data corruption.
> That is where I stopped reading because that is *not* how bitrot happens.

That is certainly true - their fake "bitrot" was very unrealistic, at
least as a disk error.  Undetected disk read errors are incredibly rare,
even on cheap disks, and you will not get them without warning (very
high /detectable/ disk read error rates).  However, as Peter points out
there can be other sources of undetected errors, such as memory errors,
bus errors, etc.

I've read your blog on this topic, and I fully agree that checksumming
or read-time verification should not be part of the raid layer.  The
ideal place is whatever is generating the data generates the checksum,
and whatever is reading the data checks it - then /any/ error in the
storage path will be detected.  But that is unrealistic to achieve - you
can't change every program.  Putting the checksums in the filesystem, as
btrfs does, is the next best thing - it is the highest layer where this
is practical.  Of course it comes at a cost - checksums have to be
calculated and stored - but that cost is small on modern cpus.

Another nice thing that is easier and faster with filesystem checksums
is deduplication, which is not really something you want on the raid layer.

David



> 
> Drives have sophisticated error checking and correcting codes.  If a bit on
> the media changes, the device will either fix it transparently or report an
> error - just like you suggest.  It is extremely unlikely to return bad data
> as though it were good data.  And the codes that btrfs use have roughly the
> same probability of reporting bad data as good - infinitesimal but not zero.
> 
> i.e. that clever stuff done by btrfs is already done by the drive!
> 
> To be fair to btrfs there are other possible sources of corruption than just
> media defect.  On the path from the CCD which captures the photo of the cat,
> to the LCD which displays the image, there are lots of memory buffers and
> busses which carry the data.  Any one of those could theoretically flip one
> or more bits.  Each of them *should* have appropriate error detecting and
> correcting codes.  Apparently not all of them do.
> So the magic in btrfs doesn't really protect against media errors (though if
> your drive is buggy it could help there) but against errors in some (but not
> all) other buffers or paths.
> 
> i.e. it sounds like a really cool idea but I find it very hard to evaluate
> how useful it really is and whether it is worth the cost.   My gut feeling is
> that for data it probably isn't.  For metadata it might be.
> 
> So to answer your question:  yes- raid6 on reasonable-quality drives already
> protects you against media errors.  There are however theoretically possible
> sources of corruption that md/raid6 does not protect you against.  btrfs
> might protect you against some of those.  Nothing can protect you against all
> of them.
> 
> As is true for any form of security (and here are at talking about data
> security) you can only evaluate how safe you are against some specific threat
> model.  Without a clear threat model it is all just hand waving.
> 
> I had a drive one which had a dodgy memory buffer.  When reading a 4k block,
> one specific bit would often be set when it should be clear.  md would not
> help with that (and in fact was helpfully copying the corruption from the
> source drive to a space in a RAID1 for me :-).  btrfs would have caught that
> particular corruption if checksumming were enabled on all data and metadata.
> 
> md could conceivably read the whole "stripe" on every read and verify all
> parity blocks before releasing any data.  This has been suggested several
> times, but no one has provided code or performance analysis yet.
> 
> NeilBrown
> 
> 
>>
>> On a related note, raid6check was mention to me. I don't see that available
>> on Debian or RHEL stable, but I found a man page:
>>
>>     https://github.com/neilbrown/mdadm/blob/master/raid6check.8
>>
>> The man page says, "No write operations are performed on the array or the
>> components," but my reading of the code makes it seem like a read error will
>> trigger a write implicitly. Am I misunderstanding this? Overall, am I barking
>> up the wrong tree in thinking that RAID 6 might let me preserve proper
>> layering while giving me the data integrity safeguards I'd otherwise get from
>> ZFS or BTRFS?
>>
>> Thanks in advance for clarifications and pointers!
>>
> 

