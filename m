From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Mon, 14 Dec 2015 14:14:42 -0600
Message-ID: <CAE9DZUT42rCgjSacbs170ftzBtC4i83TRvk7CGeELqpYg3hVzw@mail.gmail.com>
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
	<566BA6E5.6030008@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566BA6E5.6030008@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Stoffel <john@stoffel.org>, Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 11, 2015 at 10:47 PM, Phil Turmel <philip@turmel.org> wrote:
> On 12/11/2015 09:55 PM, Dallas Clement wrote:
>
>> Right.  I understand the fio iodepth is different than the hardware
>> queue depth.  But the fio man page seems to only mention limitation on
>> synchronous operations which mine are not. I'm using direct=1 and
>> sync=0.
>
> You are confusing sequential and synchronous.  The man page says it is
> ineffective for *sequential* operations, especially when direct=1.
>
>> I guess what I would really like to know is how I can achieve at or
>> near 100% utilization on the raid device and its member disks with
>> fio.  Do I need to increase /sys/block/sd*/device/queue_depth and
>> /sys/block/sd*/queue/nr_requests to get more utilization?
>
> I don't know specifically.  It seems to me that increasing queue depth
> adds resiliency in the face of data transfer timing jitter, but at the
> cost of more CPU overhead.
>
> I'm not convinced fio is the right workload, either.  It's options are
> much more flexible for random I/O workloads.  dd isn't perfect either,
> especially when writing zeroes -- it actually reads zeros over and over
> from the special device.  For sequential operations I like dc3dd with
> its pat= wipe= mode.  That'll only generate writes.
>
>>> That's why I suggested blktrace.  Collect a trace while a single dd is
>>> writing to your raw array device.  Compare the large writes submitted to
>>> the md device against the broken down writes submitted to the member
>>> devices.
>>
>> Sounds good.  Will do.  What signs of trouble should I be looking for?
>
> Look for strictly increasing logical block addresses in requests to the
> member devices.  Any disruption in that will break optimum positioning
> for streaming throughput. Per device. Requests to the device have to be
> large enough and paced quickly enough to avoid starving the write head.
>
> Of course, any reads mixed in mean RMW cycles you didn't avoid.  You
> shouldn't have any of those for sequential writes in chunk * (n-2)
> multiples.
>
> I know it's a bit hand-wavy, but you have more hardware to play with
> than I do :-)
>
> Phil

Hi Phil,  I ran blktrace while writing with dd to a RAID 5 device with
12 disks.  My chunk size is 128K.  So I set my block size to 128K *
(12-2) = 1280k.   Here is the dd command I ran.

# /usr/local/bin/dd if=/dev/zero of=/dev/md10 bs=1280k count=1000 oflag=direct

> Look for strictly increasing logical block addresses in requests to the
> member devices.  Any disruption in that will break optimum positioning
> for streaming throughput. Per device. Requests to the device have to be
> large enough and paced quickly enough to avoid starving the write head.

I just ran blktrace and then blkparse after the write finished.  I'm
new to blktrace so not really sure what I'm looking at.  I wasn't able
to see the writes to individual disks.

> Of course, any reads mixed in mean RMW cycles you didn't avoid.  You
> shouldn't have any of those for sequential writes in chunk * (n-2)
> multiples.

I did see lots of rmw's which I am assuming I should not be seeing if
everything is correctly aligned!

  9,10   1        0    15.016034153     0  m   N raid5 rmw 1536 5
  9,10   1        0    15.016039816     0  m   N raid5 rmw 1544 5
  9,10   1        0    15.016042200     0  m   N raid5 rmw 1552 5
  9,10   1        0    15.016044241     0  m   N raid5 rmw 1560 5
  9,10   1        0    15.016046200     0  m   N raid5 rmw 1568 5
  9,10   1        0    15.016048096     0  m   N raid5 rmw 1576 5
  9,10   1        0    15.016049977     0  m   N raid5 rmw 1584 5
  9,10   1        0    15.016051851     0  m   N raid5 rmw 1592 5
  9,10   1        0    15.016054075     0  m   N raid5 rmw 1600 5
  9,10   1        0    15.016056042     0  m   N raid5 rmw 1608 5
  9,10   1        0    15.016057916     0  m   N raid5 rmw 1616 5
  9,10   1        0    15.016059809     0  m   N raid5 rmw 1624 5
  9,10   1        0    15.016061670     0  m   N raid5 rmw 1632 5
  9,10   1        0    15.016063578     0  m   N raid5 rmw 1640 5
