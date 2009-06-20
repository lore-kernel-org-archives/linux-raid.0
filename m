From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: filesystem stripe parameters
Date: Sat, 20 Jun 2009 10:35:33 +0400
Message-ID: <4A3C8335.4050208@msgid.tls.msk.ru>
References: <7a329d910906181208t2f95d94bsc4eac2c5f20355f5@mail.gmail.com>	 <4A3B573D.5020206@msgid.tls.msk.ru> <1245445142.18616.33.camel@Gecko.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1245445142.18616.33.camel@Gecko.local>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Perreault <justinperreault@dl-jp.com>
Cc: Wil Reichert <wil.reichert@gmail.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Perreault wrote:
> Still learning, please be gentle.
> 
> On Fri, 2009-06-19 at 13:15 +0400, Michael Tokarev wrote:
>> Wil Reichert wrote:
>>> When using LVM on top of RAID 5, is it still worthwhile to pass RAID
>>> stripe information to the filesystem on creation?  Or do the PE's in
>>> LVM blur the specific stripe sizes & I'd want to use some multiple of
>>> those instead?
>> Yes it is still a good idea to pass that info because it is still a
>> RAID5 which requires proper treatment wrt unaligned writes and keeping
>> redundancy.
>>
>> But the thing is that RAID5 and LVM are not good to each other UNLESS
>> RAID5 consists of 3, 5 or 9 (or 17 etc) drives -- i.e. 2^N+1, so that
>> there's 2^N data drives.
>>
>> This is because LVM can only have blocksize as a power of two and in
>> order to be useful that blocksize should be a multiple of RAID5 data
>> row size (stripe size etc).
>>
>> This is only possible when RAID5 has 2^N data drives or 2^N+1 total
>> drives.  The same is for RAID4, and for RAID6 it's 2^N+2 since RAID6
>> has 2 parity drives.
>>
>> But if you can't match LVM blocksize and RAID strip size, there's
>> *almost* no point at telling raid parameters to the filesystem: no
>> matter how hard you'll try, LVM will make the whole thing non-optimal.
> 
> 2.5 questions:
> 
> 1) Will this same issue affect a 5+0 raid array?

Yes, definitely.  But with 5+0 it's a bit more complicated.  In that
case each raid5 should have 3, 5, 9 etc (2^N+1) drives and by combining
the two into raid0 you'll have "combined stripe size" of 2*2^N which
is still power of two and hence can be used with lvm.  You still need
to tell the fs about raid5 properties, not raid0, but this is really
questionable.

> 2) It is inferred that one can choose to not tell the filesystem the
> raid parameters, what negative effect does not doing it have?
> Conversely, what is the positive effect does doing it have?

It's covered by the mkfs.ext3 and mkfs.xfs manpages.  Telling the fs
about your raid properties serves for two purposes - the filesystem
tries to avoid read-modify-write cycle for raid5 (the most expensive
thing, unavoidable if partitions/volumes are not aligned to the
raid stripe-width) and tries to place various data to different
disks.

The most expensive thing is read-modify-write for writes on raid[456].
Basically, if you write only "small" amount of data, raid5 needs to
re-calculate and re-write the parity block which is a function of
your new data and content of all the other data in this stripe.
So it has to read either all other data blocks from this raid row
or at least the previous content of the blocks you're writing AND
the previous parity block, -- in order to calculate new parity.

On the other hand if you write whole stripe (or more), there's
no need to read anything, all the data needed to calculate new
parity is already here.

So basically read-modify-write (for small/unaligned writes) is 3x
more operations (plus seeks!) than direct write (for large and
aligned writes).

But note that by telling the filesystem about the raid properties
we don't affect the file data itself, or, rather, how our applications
will access it.  Filesystem can change metadata location and file
placement, but not the way how userspace writes.  Ok, the fs can
also perform smarter buffering, so that buffered writes will be
sent to raid5 in multiplies of raid stripe width.

Note also that for reads, especially for "large enough" reads all
this alignment etc has little effect.

/mjt
