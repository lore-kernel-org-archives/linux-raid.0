From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Fri, 11 Dec 2015 20:55:10 -0600
Message-ID: <CAE9DZURoHBRHq2M0spkTrBGoXmw9QjoARb_Gc6C6OvM9940aMA@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<CAE9DZUSNkLxaKH8MtggW+5_uo38CHRTcscvh7Kk-VTb_zWPQ4g@mail.gmail.com>
	<CAK2H+ednN7dCGzcOt8TxgNdhdDA1mN6Xr5P8vQ+Y=-uRoxRksw@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566B6C8F.7020201@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Stoffel <john@stoffel.org>, Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 11, 2015 at 6:38 PM, Phil Turmel <philip@turmel.org> wrote:
> On 12/11/2015 07:00 PM, Dallas Clement wrote:
>
>>> So is my workload of 12 fio jobs writing sequential 2 MB blocks with
>>> direct I/O just too abusive?  Seems so with high queue depth.
>
> I don't think you are adjusting any hardware queue depth here.  The fio
> man page is quite explicit that iodepth=N is ineffective for sequential
> operations.  But you are using the libaio engine, so you are piling up
> many *software* queued operations for the kernel to execute, not
> operations in flight to the disks.  From the histograms in your results,
> the vast majority of ops are completing at depth=4.  Further queuing is
> just adding kernel overhead.
>
> The queuing differences from one kernel to another is a driver and
> hardware property, not an application property.
>
>>> I started this discussion because my RAID 5 and RAID 6 write
>>> performance is really bad.  If my system is able to write to all 12
>>> disks at 170 MB/s in JBOD mode, I am expecting that one fio job should
>>> be able to write at a speed of (N - 1) * X = 11 * 170 MB/s = 1870
>>> MB/s.  However, I am getting < 700 MB/s for queue depth = 32 and < 600
>>> MB/s for queue depth = 256.  I get similarly disappointing results for
>>> RAID 6 writes.
>
> That's why I suggested blktrace.  Collect a trace while a single dd is
> writing to your raw array device.  Compare the large writes submitted to
> the md device against the broken down writes submitted to the member
> devices.
>
> Compare the patterns and sizes from older kernels against newer kernels,
> possibly varying which controllers and data paths are involved.
>
> Phil

Hi Phil,

> I don't think you are adjusting any hardware queue depth here.

Right, that was my understanding as well.  The fio iodepth setting
just controls how many I/Os can be in flight from the application
perspective.  I have not modified the hardware queue depth on my disks
at all yet.  Was saving that for later.

>  The fio man page is quite explicit that iodepth=N is ineffective for sequential
> operations.  But you are using the libaio engine, so you are piling up
> many *software* queued operations for the kernel to execute, not
> operations in flight to the disks.

Right.  I understand the fio iodepth is different than the hardware
queue depth.  But the fio man page seems to only mention limitation on
synchronous operations which mine are not. I'm using direct=1 and
sync=0.

I guess what I would really like to know is how I can achieve at or
near 100% utilization on the raid device and its member disks with
fio.  Do I need to increase /sys/block/sd*/device/queue_depth and
/sys/block/sd*/queue/nr_requests to get more utilization?

> That's why I suggested blktrace.  Collect a trace while a single dd is
> writing to your raw array device.  Compare the large writes submitted to
> the md device against the broken down writes submitted to the member
> devices.

Sounds good.  Will do.  What signs of trouble should I be looking for?
