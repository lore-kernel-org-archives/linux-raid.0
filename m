From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: Disappointing performance: 5-disk RAID6, 3.11.6
Date: Tue, 21 Jan 2014 18:24:09 -0600
Message-ID: <CAKuK5J2wgccORwctg2EEv=CnPMcRD4d63yZWOGp8-3ARqp3wQw@mail.gmail.com>
References: <CAKuK5J34CvTwZ5S6uyBUdEft2SkwrycXvYfNvQATit8GbdZcuw@mail.gmail.com>
 <20140122095404.25e63a06@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140122095404.25e63a06@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jan 21, 2014 at 4:54 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 21 Jan 2014 10:42:19 -0600 Jon Nelson
> <jnelson-linux-raid@jamponi.net> wrote:
>
>> I have a 5-disk RAID6 using (5) 320GB SATA drives.
>> I rarely see even sequential I/O approaching that of a single drive's
>> performance.
>> Example: (Rarely!) I'll see an aggregate 250MB/s read or write, but
>> that translates to 50MB/s read or write per-drive. I was hoping for
>> more.
>
> A 5 disk RAID6 has 3 data drives (in each stripe), so 250MB/s translates to
> 250/3 or 83MB/s per drive (skipping over parity data isn't faster than
> reading it unless you have a very large chunk size, which brings other costs).
>
> What exactly where you hoping for?
>
> If you run something like
>   for i in a b c d e
>   do dd if=/dev/sd${i}3 of=/dev/null bs=1M count=100 &
>   done
> while system is otherwise idle, what throughput does each dd report?

Of course, you're absolutely right about data disks vs. parity disks.
I'd been playing with raid10 for so long...

Bumping that count up to 10000, I get an aggregate of (up to) 360MB/s,
averaging around 325MB/s, lows near 300MB/s.

Something didn't seem right, though, so I re-ran the dd on each drive
individually and found an outlier. Most were 70-75MB/s, but one was
55MB/s. Bummer. Anyway, thanks for reminding me to think twice, post
once.

-
Jon
