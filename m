From: NeilBrown <neilb@suse.com>
Subject: Re: doubt about raid1 and writemostly
Date: Thu, 25 Jun 2015 08:59:54 +1000
Message-ID: <20150625085954.57b485ab@noble>
References: <CAH3kUhEdDY2DeAQ1FYaEvsRRdia9kn6V+9VQETxVdh9j-R3TTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhEdDY2DeAQ1FYaEvsRRdia9kn6V+9VQETxVdh9j-R3TTA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 23 Jun 2015 12:01:33 -0300 Roberto Spadim
<roberto@spadim.com.br> wrote:

> hi guys, i'm with a doubt
> when i use witemostly, how the md handle the slower drive
> (writemostly) for example i have 2 ssd that support 500mb/s write
> running raid1, i included a hdd with +- 100mb/s write with writemostly
> flag
> when i execute a dd if=/dev/zero of=./test , i get near to 200mb/s
> with dd, and using iostat -d 1 -k, i get +- 100mb/s
> there's some kind of configuration to writemostly drive? something
> like 'buffer size' or someting like it?
> 

You need to also enable --write-behind if you want md/raid1 to not be
slowed down so much by a slower device.
However this only really helps hide latency.  There is nothing that can
be done to help over-all throughput.

When you set --write-behind you can provide a number which is the
number of outstanding requests that can be in flight to the
write-mostly device.

If your writes are "bursty" in nature - so lots of writes together,
then longer pauses with no writes, then this write-behind buffer can
hide the delay caused by the slower device.  If you write continuously,
then there is no way that the slower device can keep up and the
over-all throughput will be reduced to match the slowest device.

This functionality was originally written for cases where both devices
had the same throughput, but one was higher latency, due to being
several kilometres away on the other end of an optical fibre.

NeilBrown
