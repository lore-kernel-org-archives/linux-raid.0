From: Philip Cameron <pecameron@attbi.com>
Subject: Re: Fast RAID 1 Resync
Date: Thu, 02 Jan 2003 20:22:32 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E14E5D8.70409@attbi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Hi Neil,

(Sorry if this is a repost. I had an error with returned mail)

Thanks for your comments.

I also don't see a need to synchronize disks at mkraid time. Its nice to have
identical disks but not necessary as long as the result of reading a sector that
has never been written is undefined. An option to do either approach can be done
as long as there is a real need. Adding an option increases complexity
especially during test.

I have been thinking of tracking writes to each chunk with a counter. The
counters would be organized into a vector indexed by chunk number. The counter
is incremented by the number of mirrors including any currently unavailable
mirrors before the write starts. It is decremeted as each write completes. So
when all writes in a chunk are complete the counter returns to zero. If there is
a missing mirror, the counter will not return to zero (since one of the needed
writes was not done). 

When a disk is pulled, the counters increment but don't return to zero. When the
disk is reinserted, the resync needs to copy chunks where the counter doesn't go
to zero. When the resync of the chunk is complete, set the counter to zero.

To deal with a recovery after crash, I am thinking about using your approach.
Use a bit per counter and set the bit when the counter is non-zero. When a bit
goes from 0 to 1, the updated bit vector is written before starting the write to
the chunk. On reboot after a crash, the bit vector from the selected mirror is
used (the current mechanism is used to select the base disk). The counter is
incremented for each chunk that has a bit that is set. After this, the resync in
the above case can be performed. I don't see a need for timestamps beyond what
is currently being done.

The transitions from 1 to 0 are not all that important since the worst case is
syncing a chunk that is already mirrored. Overall performance can be improved by
delaying the 1 to 0 transition for a few seconds. A lazy write of the bits can
be done every 10 seconds or so if there are no 0 to 1 changes during that interval.

I have a third goal: minimize the resync time for a new (replacement) disk. In
this case all of the chunks that have ever been written need to be copied. I
have been thinking about controlling this through a second bit vector. When a
chunk is written for the first time the bit is set and it is never reset. When
the new disk is added, the counters corresponding to all of the bits that have
been set in the vector are incremented and a resync (as above) is performed. As
above the vector update needs to be done before the write to the chunk. The
length of resync is proportional to how much of the disk has been used.

A hardware note: the system has two IO assemblies each of which contains a PCI
bus, SCSI HBA and 3 hot plugable SCSI disk slots. We are using 72GB disks. Sets
of 2 mirror RAID1 raid sets is the most practical configuration.

Phil Cameron

>> 
>> Hi,
>  
>
>>  You have two quite different, though admittedly similar, goal here.
>>   1/ quick resync when a recently removed drive is re-added.
>>   2/ quick resync after an unclean shutdown.
>> 
>>  I would treat these quite separately.
>> 
>>  For the latter I would have a bitmap which was written to disk
>>  whenever a bit was set and eventually after a bit was cleared.
>>  I would use a 16 bit counter for each 'chunk'.
>>  If the high bit is clear, it stores the number of outstanding writes
>>  on that chunk.
>>  If the high bit is set, it stores some sort of time stamp of when the
>>  number of outstanding writes hit zero.
>>  Every time you write the bitmap, you increment this timestamp.
>>  So when you schedule a write, you only need to write out the bitmap
>>  first if the 16bit number of this chunk has the highbit set and has a
>>  timestamp which is different to the current one - which means that
>>  the bitmap has been written out with a zero in this slot.
>>  So:
>>    On write, if highbit clear, increment counter
>>              if highbit set and timestamp matches, set counter to 1
>> 		 and set bit in bitmap
>> 	     if highbit set and timestamp doesn't match, set
>> 		 bit in bitmap, schedule write, set counter to 1
>>    On write complete,
>> 	decrement counter.  If it hits zero, set to timestamp with
>>         high bit set, clear the bitmap bit, and schudle a bitmap
>> 	writout a few seconds hence.	
>> 
>>  For the former I would just hold a separate bitmap, one bit per
>>  chunk.
>>  While all drives are working, this bitmap would be all zeros.
>>  Whenever a write fails to write to all drives, the relevant bit gets
>>  set.
>>  When a recently failed drive comes back online, we resync all chunks
>>  that have that bit set.
>> 
>>  I don't see a particular need to sync the drives are device creation
>>  time, but I would like to keep the option of doing so.  I don't
>>  really care which behaviour is the default.
>> 
>> NeilBrown
>  
>

