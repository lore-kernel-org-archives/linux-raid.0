From: David Brown <david.brown@hesbynett.no>
Subject: Re: Using of RAID10,offset for faster writes
Date: Sun, 10 Apr 2011 11:50:18 +0200
Message-ID: <inrugq$aae$1@dough.gmane.org>
References: <inphu9$5kl$1@dough.gmane.org> <20110409150514.GA24675@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110409150514.GA24675@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/04/11 17:05, Keld J=F8rn Simonsen wrote:
> On Sat, Apr 09, 2011 at 02:03:21PM +0200, David Brown wrote:
>> During a discussion about RAID in another context (a Linux newsgroup=
), I
>> began thinking about the speeds of the different RAID10 layouts for
>> different usages.  RAID10,far is often the fastest choice for genera=
l
>> use - you get striped reads for large reads, and access times are go=
od
>> because you can get the data from either disk.  The disadvantage is =
that
>> writes involve a lot of extra head movement, as you need copies of t=
he
>> data on two widely separated areas on the each disk.  But for genera=
l
>> use, you read a lot more often than you write, so the tradeoff is wo=
rth it.
>>
>> In the discussion we were looking particularly at swap space on RAID=
=2E
>> This is a usage that requires a lot of writing, especially small wri=
tes.
>>   Using the RAID10,offset layout should give you most of the benefit=
s of
>> RAID10,far when it comes to reading - you don't get quite as efficie=
nt
>> block reads for large reads, but you can still do a lot of striping =
in
>> the reads.  And writes will involve far less head movement, and so
>> should complete faster.
>>
>> Has anyone tried this, or done any benchmarking?
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Some tests indicate that the theoretical slower writing speed of
> raid10,far tends to be minimized by the elevator algoritm for the dis=
k.
> Writes are normally just delivered to the kernel in-core buffers, and
> then every 30 secs or so flushed to the disk. The elevator orders thi=
s
> writing to minimize head movement. So there is almost no penalty for
> writes for raid10,far.
>

I suppose I was thinking of cases where you have an fsync on the data,=20
or otherwise require the file (or metadata, or fs journal, etc.) to be=20
committed to the disk.  For "normal" writes, write speed seldom matters=
=20
as they sit in memory caches.

But it's a good point.

> Anyway, for swapping the paetition siz is normally quite small, say 2=
 to
> 10 GB, and head movement is thus quite small.
>

Yes, that's true for swap partitions.  Perhaps something like database=20
files would be a better example, where you might have more writes than=20
on general use file systems?

> Tests show that raid10,offset does not really stripe sequential reads=
=2E
> Anyway it would be interesting to see tests on swapping on rid10,offs=
et
> vs raid10,far. I am not sure how to test it. But it could be load tim=
es
> for eg. openoffice in a swapped state - loading a big app is one of t=
he
> areas where you would notice the speed most in a user environment. Th=
t
> could be the reading test. For the writing test, one could operate wi=
th
> a rather small swap  partition, and then load a lot of big apps.
>

=46or testing swap speed, it might be easiest to make a large tmpfs sys=
tem=20
and copy data back and forth to it.

Anyway, you've given me a few points to think about - and probably=20
RAID10,far is "the" answer for now!  If only mdadm supported resizing=20
and reshaping of this level, it would be the ideal choice in many=20
circumstances.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
