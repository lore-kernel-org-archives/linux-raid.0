From: David Brown <david.brown@hesbynett.no>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Wed, 19 Sep 2012 09:20:13 +0200
Message-ID: <5059722D.1070409@hesbynett.no>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com> <5051DEC3.9050703@hardwarefreak.com> <CACY-59eJvv98xz_E-0qO_MGF8M40AZ-bCeXOA6zscd+HZdsy+g@mail.gmail.com> <50584B75.1060606@hesbynett.no> <5058E9DF.6090007@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5058E9DF.6090007@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: GuoZhong Han <hanguozhong@meganovo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/09/2012 23:38, Stan Hoeppner wrote:
> On 9/18/2012 5:22 AM, David Brown wrote:
>> On 18/09/2012 11:35, GuoZhong Han wrote:
>>> Hi Stan:
>>>           Thanks for your advice. In your last mail, you mentioned =
XFS
>>> file system. According to your suggestion, I changed the file syste=
m
>>> from raid5 (4*2T, chunksize: 128K, strip_catch_size:2048) to XFS. T=
hen
>>> I did a write performance test on XFS.
>>> The test was as follows:
>>>           My program used 4 threads to do parallel writing to 30 fi=
les
>>> with 1MB/s writing speed on each file. Each thread was bound on a
>>> single core. The estimated total speed should be stable at 30MB/s. =
I
>>> recorded the total writing speed every second in the test. Compared
>>> with speed of ext4, when the array was going to be full, the
>>> performance of XFS has indeed increased. The time to create the XFS
>>> file system was much less than the cost of ext4. However, I found t=
hat
>>> the total speed wasn=92t steady. Although most of time the speed ca=
n
>>> reach to 30M/s, it fell to only about 10MB/s in rare cases. Writing=
 to
>>> 30 files in parallel was supposed to be easy. Why did this happen?
>>>
>>>
>>
>> Two questions - what is the XFS built on? 4 x 2TB in a linear
>> concatenation, or something else?
>
> According to the above it's a 4 drive RAID5.

He wrote "I changed the file system from raid5 (4 x 2T) to XFS", so I a=
m=20
looking for clarification here.

>
>> Secondly, are all your files in the same directory, or in different
>> directories?  XFS scales by using multiple threads for different
>> allocation groups,
>
> This is partially correct if he's using the inode64 allocator.  Do no=
te
> multiple XFS write threads can target the same AG and get parallel
> performance.

I didn't know that - there is always something new to learn!

However, I don't think that should make a huge difference - after all,=20
the work done by these threads is going to be fairly small until you=20
actually get to writing out the data to the AG.  Latency for the=20
application might be reduced a little, but disk throughput will not=20
benefit much.

> What you are referring to above is writing to multiple AGs
> in parallel, where each AG resides on a different member device of a
> concatenation.

Yes, although I know that each AG does not necessarily reside on a=20
different member device.

As far as I see it now, there are three stages -

1. write threads (can be several per AG)
2. AGs (can be several per disk)
3. Disks (members of a linear concat)

>
> Writing to say 16 AGs in parallel where all reside on the same disk
> array will actually decrease performance compared to 16 writes to one=
 AG
> on that array.  The reason is the latter causes far less head travel
> between writes.
>

Yes.

>> and putting these groups in different places on the
>> underlying disk or disks - but files in the same directory go in the
>> same allocation group.  So 30 files in 30 directories will give much
>> more parallelism than 30 files in 1 directory.
>
> Actually, no.  The level of parallelism is the same--30 concurrent
> writes.  As noted above, the increase in performance comes from locat=
ing
> each of the AGs on a different disk, or array.  This decreases the
> number of seeks requires per write, especially with parity arrays.
>

OK, so you get 30 parallel logical writes, but if it does not translate=
=20
into multiple parallel physical writes to the disks by having multiple=20
member disks, then the gains are small.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
