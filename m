From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Question about raid robustness when disk fails
Date: Thu, 28 Jan 2010 03:52:56 -0800
Message-ID: <4877c76c1001280352q475a3416m2bfda127596df9d@mail.gmail.com>
References: <1262972385.8962.159.camel@kije>
	 <87hbqeyua9.fsf@frosties.localdomain>
	 <7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
	 <4877c76c1001262022p369eac60s639d87cad743ff94@mail.gmail.com>
	 <87vden2a2a.fsf@frosties.localdomain> <4B6005DC.7070701@shiftmail.org>
	 <87wrz3zvwu.fsf@frosties.localdomain> <4B6018EC.7090805@shiftmail.org>
	 <87fx5r36k9.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fx5r36k9.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jan 27, 2010 at 7:34 AM, Goswin von Brederlow <goswin-v-b@web.de> wrote:
> Asdo <asdo@shiftmail.org> writes:
> If you kick of a read-error-recovery and get another error on another
> drive then your raid will be down as well. Better not risk that.
>

I mostly only disagree with this point; everything else is more a
choice of tuning.  Different applications having different desires.

If a read is late, it might be a good idea to force a full stripe
recheck and alert the administrator about the latency/failure.

Current raid levels do not have a way of validating blocks
individually or even as part of a larger data set other than the
stripe; raid 5 has only one set of redundant data, but no way of
determining for sure which data-unit is bad.  Likely the 'slow' drive
should be presumed bad, and the rest of the stripe recalculated.  If
the drive returned data it should be compared to the calculation's
result.  If the data matches then it managed a clean read, but a
re-write should be issued anyway to ensure that the data really is
over-written.  The problem is the case where the data doesn't match,
but we lack another parity chunk (to validate against the computed
recovery data) due to using a single recovery stripe and no
validation.

Suddenly we have two potentially valid solutions and no way of
determining which is correct.  The question is which source you
believe is less likely to have an error: a single potentially faulty
drive that has returned a maybe error-corrected read (which has
certain odds of being correct), or a set of other drives that happened
to return data a little more quickly, but which all also have an
inherent risk (though less /per drive/) of error.  My gut reaction is
that the more nominally timed and reacting drives /likely/ are the
correct source, but that there is still an unquantified risk of
failure.

Of course, this is also a slightly moot point; in the above model we'd
have received one or the other first and already passed it to the next
layer.  A simpler approach would be to presume a soft failure on
timeout and unconditionally follow the re-computation path; only
dropping it if one of those drives also had an error or timeout.



The highly risk adverse or truly paranoid might willingly sacrifice
just a little more storage to 'make extra sure' that the data is
correct; which would greatly simplify the risks outlined above.

Going with the default chunk size of 64k, that's 128 x 512bytes.  512
/ 4 = 128 chunks for 32bit checksums, 512/16 = 32 for 128 bit
checksums, or 16 for 256 bit ones.  A proposed reduction in capacity,
respectively (and truncated, not rounded), to 99.993%, 99.975%, and
99.951% of the otherwise usable storage space. (Using
(SectorsPerChunk*ChunksThatFit)/(SectorsPerChunk*ChunksThatFit+1) to
give the data that would fit in the same sized 'old space' but first
making the 'old space' one sector larger to simplify the calculation.
Obviously the offsets and packing change if you choose a larger sector
size but keep the chunk size the same.)

With multi-core systems I don't see a major downside on the extra
processing workload, but I do see the disk bottle-neck as a downside.
The most natural read pattern would be to slurp up the remaining
sectors to the CRC payload on each drive.  For large streamed files
the effect is likely good.  For databases and small-file tasks that
cache poorly this would probably be bad.

Just arbitrarily making the chunk one sector larger only drops the
storage ratio to 99.224% and eliminates that problem (plus provides
the remainder of those sectors to dedicate to additional payload).

The error detection/recovery payload could better be expressed as
taking the minimum (and most frequently occurring) form of device
block size; but tunable up from there just as chunk size is.  This way
it could work for media that doesn't suffer seek time, but does have
data-alignment issues.


From a logical view both the existing MD/RAID and these additional
validity/recovery (likely what the unused space in the per-chunk
checksum storage model could be filled with) methods should exist in
some kind of block device reliability layer.  The type of reliability
that MD currently provides would be a simple whole-partition/device
approach.  The kind of reliability that BTRFS and ZFS aim for are a
more granular approach.  Obviously a place where code and complexity
can be reduced by using a common interface and consolidating code.
Additional related improvements might also be exposed via that
interface.

Is that something others would value as a valid contribution?  I'm
actually thinking of looking in to this, but don't really want to
expend the effort if it's unlikely to be anything more than a local
patch trying to anchor me to the past (when I'm not at least being
paid to continually port it forward).
