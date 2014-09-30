From: Robert L Mathews <lists@tigertech.com>
Subject: Re: raid1 - ssd, doubts
Date: Tue, 30 Sep 2014 12:58:30 -0700
Message-ID: <542B0B66.9080506@tigertech.com>
References: <CAH3kUhHkot3doqVZQ0TAot0A3e8i8RFWqsiLL35p1OYsvz5Xkw@mail.gmail.com>	<542AD06C.9080908@redhost.ro> <CAH3kUhFwakMSRAgKdSR-4g53KwHS6Yj_mmm3TOVKRQ_qaA9SNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFwakMSRAgKdSR-4g53KwHS6Yj_mmm3TOVKRQ_qaA9SNA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9/30/14 9:20 AM, Roberto Spadim wrote:

> well, others experiences and comments are wellcome :)
> comments about cache (bcache,flashcache,dm cache) are wellcome too

Keep in mind that sequential read and write speeds are not everything.
For our use pattern, for example (busy Web and mail servers with
millions of files that aren't necessarily grouped physically on the
disk, even when in the same directory [think maildirs where each file
represents one message]), latency is more important -- particularly read
latency.

Our servers use three-disk RAID 1 arrays. When we replaced one of the
spinning hard drives in each array with an SSD (some of which were
Samsung 840 Pros), then marked the remaining two spinning disks as
"write-mostly", the average read latency on the array dropped from
around 12 ms to less than 2 ms.

More importantly, the average amount of time any process on a server is
waiting in the "D" state (read or write) dropped from 8% to 3%.

Note that improving the read performance this way also improves the
write performance of the entire array, because when a write occurs, it
will never be queued behind a spinning disk read: the spinning disk is
more likely to be idle.

So our experience confirms that adding a single SSD to a RAID 1 array,
then marking the others write-mostly, is a good stopgap measure on the
road to replacing all spinning disks with SSDs. It effectively doubled
the average performance of our storage. No additional caching layers
required.

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
