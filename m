From: Phil Turmel <philip@turmel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Fri, 11 Dec 2015 19:38:39 -0500
Message-ID: <566B6C8F.7020201@turmel.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZURuPGEL4bG=44ntbjp+51jktn36LFGfn11xFR-X9O9POw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>, John Stoffel <john@stoffel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/11/2015 07:00 PM, Dallas Clement wrote:

>> So is my workload of 12 fio jobs writing sequential 2 MB blocks with
>> direct I/O just too abusive?  Seems so with high queue depth.

I don't think you are adjusting any hardware queue depth here.  The fio
man page is quite explicit that iodepth=N is ineffective for sequential
operations.  But you are using the libaio engine, so you are piling up
many *software* queued operations for the kernel to execute, not
operations in flight to the disks.  From the histograms in your results,
the vast majority of ops are completing at depth=4.  Further queuing is
just adding kernel overhead.

The queuing differences from one kernel to another is a driver and
hardware property, not an application property.

>> I started this discussion because my RAID 5 and RAID 6 write
>> performance is really bad.  If my system is able to write to all 12
>> disks at 170 MB/s in JBOD mode, I am expecting that one fio job should
>> be able to write at a speed of (N - 1) * X = 11 * 170 MB/s = 1870
>> MB/s.  However, I am getting < 700 MB/s for queue depth = 32 and < 600
>> MB/s for queue depth = 256.  I get similarly disappointing results for
>> RAID 6 writes.

That's why I suggested blktrace.  Collect a trace while a single dd is
writing to your raw array device.  Compare the large writes submitted to
the md device against the broken down writes submitted to the member
devices.

Compare the patterns and sizes from older kernels against newer kernels,
possibly varying which controllers and data paths are involved.

Phil
