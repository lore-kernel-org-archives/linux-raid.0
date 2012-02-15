From: David Brown <david@westcontrol.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Wed, 15 Feb 2012 13:10:32 +0100
Message-ID: <4F3BA0B8.2000405@westcontrol.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <4F39D9B2.3050305@hardwarefreak.com> <20120214113832.GA6157@www5.open-std.org> <4F3AEDEF.2000608@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3AEDEF.2000608@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: keld@keldix.com, CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/02/2012 00:27, Stan Hoeppner wrote:
>
> Maybe I simply don't understand this 'magic' of the f2 and far layouts.
>   If you only read the "faster half" of a spindle, does this mean writes
> go to the slower half?  If that's the case, how can you read data that's
> never been written?
>

Imagine you have disk A with partitions 1 and 2 (1 being the outer 
faster half).  Similarly, disk B is partitioned into 1 and 2.

Take A1 and B2 and tie them together with raid1 as md0.
Take B1 and A2 and tie them together with raid1 as md1.
Take md0 and md1 and tie them together with raid0 as md2.

Then md2 is pretty much a "raid10,f2" of disk A and disk B.


So all data is written twice, with one copy on each disk - that's the 
"raid1" mirroring part.  And each time you need to read a large block of 
data, you can get parts of it in parallel from both disks at once, with 
contiguous reads - blocks 0, 2, 4, ... come from A1, while blocks 1, 3, 
5, ... come from B1.

Reads will normally be taken from the outer halves (A1 and B1), since 
these have faster throughput, and keeping the heads there means half the 
head movement (actually less than that on average).  But if the system 
happens to be reading from (or writing to) A1, and needs access to data 
that is also on A1, it can read it from B2 in parallel.
