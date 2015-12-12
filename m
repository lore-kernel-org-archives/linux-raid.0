From: Phil Turmel <philip@turmel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Fri, 11 Dec 2015 23:47:33 -0500
Message-ID: <566BA6E5.6030008@turmel.org>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
 <CAE9DZUR1Nka=5mAB2WQHeFkinO0CzuH_GT1gRiVsuREQfgdGcQ@mail.gmail.com>
 <CAK2H+efF2dM1BsM7kzfTxMdQEHvbWRaVe7zJLTGcPZzafn2M6A@mail.gmail.com>
 <CAE9DZUQ+LOFWNQ2MpKoSx8j8RHVqkL15PO+jVjs7EkCQykG6VA@mail.gmail.com>
 <CAE9DZUQo4CojhuVkQ6y=gTEWG5qUkeu57wcZsqbXZtGD_V5JCQ@mail.gmail.com>
 <CAK2H+ec-zMbhxoFyHXLkdM-z-9cYYzNbPFhn19XjTHqrOMDZKQ@mail.gmail.com>
 <CAE9DZURK+bZ=4czbGojzW815Du1ascr5vzAPtQBw4ZDGyq0MAQ@mail.gmail.com>
 <22122.64143.522908.45940@quad.stoffel.home>
 <CAE9DZUQ=QynBKYJvq2JSnMaACKNpm+5yrhz+5x9Tx6_TK78mCg@mail.gmail.com>
 <22123.9525.433754.283927@quad.stoffel.home>
 <CAE9DZUTMnwpUX1e95c_i04uWREHd+aR8P2yCE_W-WmEbL6YRkw@mail.gmail.com>
 <CAE9DZUTTP1VhVgT56dyv6aLaM2V8peWSHaBg4xvXzGGUZcJ_hw@mail.gmail.com>
 <CAE9DZURuPGEL4bG=44ntbjp+51jktn36LFGfn11xFR-X9O9POw@mail.gmail.com>
 <566B6C8F.7020201@turmel.org>
 <CAE9DZURoHBRHq2M0spkTrBGoXmw9QjoARb_Gc6C6OvM9940aMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZURoHBRHq2M0spkTrBGoXmw9QjoARb_Gc6C6OvM9940aMA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/11/2015 09:55 PM, Dallas Clement wrote:

> Right.  I understand the fio iodepth is different than the hardware
> queue depth.  But the fio man page seems to only mention limitation on
> synchronous operations which mine are not. I'm using direct=1 and
> sync=0.

You are confusing sequential and synchronous.  The man page says it is
ineffective for *sequential* operations, especially when direct=1.

> I guess what I would really like to know is how I can achieve at or
> near 100% utilization on the raid device and its member disks with
> fio.  Do I need to increase /sys/block/sd*/device/queue_depth and
> /sys/block/sd*/queue/nr_requests to get more utilization?

I don't know specifically.  It seems to me that increasing queue depth
adds resiliency in the face of data transfer timing jitter, but at the
cost of more CPU overhead.

I'm not convinced fio is the right workload, either.  It's options are
much more flexible for random I/O workloads.  dd isn't perfect either,
especially when writing zeroes -- it actually reads zeros over and over
from the special device.  For sequential operations I like dc3dd with
its pat= wipe= mode.  That'll only generate writes.

>> That's why I suggested blktrace.  Collect a trace while a single dd is
>> writing to your raw array device.  Compare the large writes submitted to
>> the md device against the broken down writes submitted to the member
>> devices.
> 
> Sounds good.  Will do.  What signs of trouble should I be looking for?

Look for strictly increasing logical block addresses in requests to the
member devices.  Any disruption in that will break optimum positioning
for streaming throughput. Per device. Requests to the device have to be
large enough and paced quickly enough to avoid starving the write head.

Of course, any reads mixed in mean RMW cycles you didn't avoid.  You
shouldn't have any of those for sequential writes in chunk * (n-2)
multiples.

I know it's a bit hand-wavy, but you have more hardware to play with
than I do :-)

Phil
