From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: raid1 - ssd, doubts
Date: Tue, 30 Sep 2014 17:29:36 -0300
Message-ID: <CAH3kUhF5EAsGq_1zug-m7pGF82NaT2tfWop_5eE61pyQDFLYxw@mail.gmail.com>
References: <CAH3kUhHkot3doqVZQ0TAot0A3e8i8RFWqsiLL35p1OYsvz5Xkw@mail.gmail.com>
	<542AD06C.9080908@redhost.ro>
	<CAH3kUhFwakMSRAgKdSR-4g53KwHS6Yj_mmm3TOVKRQ_qaA9SNA@mail.gmail.com>
	<542B0B66.9080506@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <542B0B66.9080506@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

wow, nice :)
i think that's something near what i have today, the latency is the
main problem that i need to reduce and control, checking every time
with users, they don't care if system is slow to send a big file, they
care if system stop for some seconds and get back, and stop again and
get back, a smothly operation is prefered instead of batchs of high
speed

+1 to this experience, here i have some "D" state process too,
interesting common point

let'me ask others questions....

today you have 3 disk and/or ssd, before you had 3 disks, any time you
got 2 disks setup and tried to change only one disk to ssd? that will
be my scenario if i stay with raid and ssd solution without new cache
layers, about trim commands and this setup life time, there's any
scheduler cleanup method? how many time running this setup? here 1
year is a nice time to consider as a sucessfull project, i replace
disks near to 2 years






2014-09-30 16:58 GMT-03:00 Robert L Mathews <lists@tigertech.com>:
> On 9/30/14 9:20 AM, Roberto Spadim wrote:
>
>> well, others experiences and comments are wellcome :)
>> comments about cache (bcache,flashcache,dm cache) are wellcome too
>
> Keep in mind that sequential read and write speeds are not everything.
> For our use pattern, for example (busy Web and mail servers with
> millions of files that aren't necessarily grouped physically on the
> disk, even when in the same directory [think maildirs where each file
> represents one message]), latency is more important -- particularly read
> latency.
>
> Our servers use three-disk RAID 1 arrays. When we replaced one of the
> spinning hard drives in each array with an SSD (some of which were
> Samsung 840 Pros), then marked the remaining two spinning disks as
> "write-mostly", the average read latency on the array dropped from
> around 12 ms to less than 2 ms.
>
> More importantly, the average amount of time any process on a server is
> waiting in the "D" state (read or write) dropped from 8% to 3%.
>
> Note that improving the read performance this way also improves the
> write performance of the entire array, because when a write occurs, it
> will never be queued behind a spinning disk read: the spinning disk is
> more likely to be idle.
>
> So our experience confirms that adding a single SSD to a RAID 1 array,
> then marking the others write-mostly, is a good stopgap measure on the
> road to replacing all spinning disks with SSDs. It effectively doubled
> the average performance of our storage. No additional caching layers
> required.
>
> --
> Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
