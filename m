From: Phil Turmel <philip@turmel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 17 Dec 2015 08:41:14 -0500
Message-ID: <5672BB7A.4050808@turmel.org>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
 <CAE9DZURBQxteib=hW6FskuJCJTxZDWhy5kMVy2u1hU5Nkg8Khg@mail.gmail.com>
 <CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
 <CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
 <CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
 <CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
 <CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
 <CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
 <22128.11867.847781.946791@quad.stoffel.home>
 <CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
 <22128.35881.182823.556362@quad.stoffel.home>
 <CAE9DZUQNBPNXFs69JRU0Q82TQ4RjAgpsc7voMgEzuhSZhmDjig@mail.gmail.com>
 <CAE9DZUQqeCY__+8Fwg51PJc6zAk0J2Apm2TE3CRvxbFUf-xDKQ@mail.gmail.com>
 <CAK2H+eeD2k4yzuvL4uF_qKycp6A=XPe8pVF_J-7Agi8Ze89PPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+eeD2k4yzuvL4uF_qKycp6A=XPe8pVF_J-7Agi8Ze89PPQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>, Dallas Clement <dallas.a.clement@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

On 12/16/2015 07:24 PM, Mark Knecht wrote:
> On Wed, Dec 16, 2015 at 7:31 AM, Dallas Clement
> <dallas.a.clement@gmail.com <mailto:dallas.a.clement@gmail.com>> wrote:
> 
>     Phil, the 16k chunk size has really given a boost to my RAID 5
>     sequential write performance measured with fio, bs=1408k.
> 
>     This is what I was getting with a 128k chunk size:
> 
>     iodepth=4 => 605 MB/s
>     iodepth=8 => 589 MB/s
>     iodepth=16 => 634 MB/s
>     iodepth=32 => 635 MB/s
> 
>     But this is what I'm getting with a 16k chunk size:
> 
>     iodepth=4 => 825 MB/s
>     iodepth=8 => 810 MB/s
>     iodepth=16 => 851 MB/s
>     iodepth=32 => 866 MB/s

Very interesting.  Good to see hypotheses supported by results.

> Dallas,
>    Hi. Just for kicks I tried Phil's idea (I think it was Phil) and

:-)

> sampled  stripe_cache_active
> by putting this command in a 1 second loop and running it today while I
> worked.
> 
> cat  /sys/block/md3/md/stripe_cache_active >> testCacheResults
> 
> My workload is _very_ different from what you're working on. This is a
> high-end desktop
> machine (Intel 980i Extreme processor, 24GB DRAM, RAID6) running 2
> Windows 7 VMs
> while I watch the stock market and program in MatLab. None the less I
> was somewhat 
> surprise at the spread in the number of active lines. The test ran for
> about 10 hours with 
> about 94% of the results being 0, but numbers ranging from 1 line to
> 2098 lines active
> at a single time. Also interesting to me was when that 2098 value hit it
> was apparently 
> all clear in less than 1 second as the values immediately following
> where back to 0.

Yeah, latencies are pretty low.  One-second samples will be fairly
random snapshots under most conditions.  Consider sampling much faster,
but building one-minute histograms and recording those.

Phil
