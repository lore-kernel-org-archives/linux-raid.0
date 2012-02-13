From: David Brown <david@westcontrol.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Mon, 13 Feb 2012 12:19:12 +0100
Message-ID: <4F38F1B0.5010300@westcontrol.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38CEE2.6000701@westcontrol.com> <CAGqmV7pDuy_rQjsUmVhoHwVGZtdS3dvzhL55fcdehE7AZdtkgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7pDuy_rQjsUmVhoHwVGZtdS3dvzhL55fcdehE7AZdtkgw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/02/2012 10:46, CoolCold wrote:
> On Mon, Feb 13, 2012 at 12:50 PM, David Brown<david@westcontrol.com>  wrote:

>>
>> As another point, since you have mostly read accesses, you should probably
>> use raid10,f2 far layout rather than near layout.  It's a bit slower for
>> writes, but can be much faster for reads.
>>
>> mvh.,
>>
>> David
> David, thank you too - you have formalized and written down what I had
> babelized in my head. Though I not going to have large sequential
> writes/reads, info about "far" layouts is useful and I may use it
> later as reference.
>

Far layout of raid10 is also faster than near for small reads, though 
the difference is less dramatic.

The layout you drew for raid10,n2 is:

A1 A1 A2 A2 A3 A3 A4
A4 A5 A5 A6 A6 A7 A7
A8 A8 A9 A9 A10 A10 A11
A11 ...


For raid10,f2 it is:

A1 A2 A3 A4 A5 A6 A7
A8 A9 A10 A11 A12 A13 A14
....

A7 A1 A2 A3 A4 A5 A6
A14 A8 A9 A10 A11 A12 A13
....

(I'm not too sure of the details of which drives the second copies go on 
for more than 2 drives, but the main point is that it is always on a 
different drive from the original.)

This layout has two advantages.  First, if you /are/ doing a large read, 
you'll get full raid0 striped performance.  Secondly, since each block 
has two copies, one on the inner half of a disk, and one on the outer 
half, reads will normally be handled by only the outer halves of the 
disks.  This means half the average head movement, and faster throughput 
- the outer halves of disk drives are significantly faster than the 
inner halves.  But if the system is already reading from the outer half 
of a drive, it can still use the inner halves to access a copy of the 
data in parallel if that helps overall.

This combines to give raid10,f2 an average read performance that can be 
quite a lot higher than with a pure raid0 setup, and lower read latency 
than raid10,n2 even for small reads.

The disadvantage is greater head movement during writes, so writes have 
longer latency.  But overall it is almost certainly the best choice for 
your read-heavy usage.

