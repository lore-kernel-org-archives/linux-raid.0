From: "Bryan J. Smith" <b.j.smith@ieee.org>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Date: Wed, 26 Sep 2007 10:11:56 -0700 (PDT)
Message-ID: <673292.62672.qm@web32906.mail.mud.yahoo.com>
References: <Pine.LNX.4.64.0709261223290.15219@p34.internal.lan>
Reply-To: b.j.smith@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709261223290.15219@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Bryan J Smith <b.j.smith@ieee.org>
Cc: xfs-bounce@oss.sgi.com, Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I have a question, when I use multiple writer threads (2 or 3) I
> see 550-600 MiB/s write speed (vmstat) but when using only 1
thread,
> ~420-430 MiB/s...

It's called scheduling buffer flushes, as well as the buffering
itself.

> Also without tweaking, SW RAID is very slow (180-200
> MiB/s) using the same disks.

But how much of that tweaking is actually just buffering?
That's a continued theme (and issue).

Unless you can force completely synchronous writes, you honestly
don't know.  Using a larger size than memory is not anywhere near the
same.

Plus it makes software RAID utterly n/a in comparison to hardware
RAID, where the driver is waiting until the commit to actual NVRAM or
disc is complete.


-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
