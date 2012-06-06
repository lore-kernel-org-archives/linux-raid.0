From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Wed, 6 Jun 2012 16:11:25 +0200
Message-ID: <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 5, 2012 at 1:14 AM, Ole Tange <ole@tange.dk> wrote:

> But I cannot explain why even the best performance (4600 MB/11s = 420
> MB/s) is not even close to the checksum performance reported by the
> kernel at boot (6196 MB/s):

From the friendly people on the mailing list the answer can be summarized as:

Checksumming is only a minor part of what md0_raid6 has to do. A lot
of the work is shuffling data around. The reason why checksumming is
in the kernel log is because the checksumming algorithm is one part
that can be optimized where as the other parts stay the same no matter
chosen the checksumming algorithm.

So when parity computing is mentioned under performance on
http://blog.zorinaq.com/?e=10 is is only a small part of the picture:
The parity computing may only take 1.5% CPU time, but the shuffling
data around can take several magnitudes longer - thus software RAID
may not be able to outperform hardware RAID in that aspect.

In other words: What you see is normal, and it is not out of the
ordinary to see md0_raid6 use 100% CPU time on a single core when
using a 24 disk RAID6. Work is underway to spread the load to multiple
cores using the experimental kernel parameter
CONFIG_MULTICORE_RAID456.

If the bottleneck is md0_raid6, choose a chunk size that gives
reasonable performance on your CPU (which in your case seem to be
32-64 KB).


/Ole
