From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID1 & 2.6.9 performance problem
Date: Mon, 17 Jan 2005 15:39:47 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net>
References: <41EBD827.80701@pipi.ma.cx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EBD827.80701@pipi.ma.cx>
Sender: linux-raid-owner@vger.kernel.org
To: Janusz Zamecki <janusz@pipi.ma.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 17 Jan 2005, Janusz Zamecki wrote:

> Hello!
>
> After days of googling I've gave up and decided to ask for help.
>
> The story is very simple: I have /dev/md6 raid1 array made of hdg and
> hde disks. The resulting array is as fast as 1 disk only.

Why would you expect it to be any faster?

> Please check this out:
>
> hdparm -t /dev/hdg /dev/hde /dev/md6
>
> /dev/hdg:
>   Timing buffered disk reads:  184 MB in  3.03 seconds =  60.76 MB/sec
>
> /dev/hde:
>   Timing buffered disk reads:  184 MB in  3.01 seconds =  61.08 MB/sec
>
> /dev/md6:
>   Timing buffered disk reads:  184 MB in  3.03 seconds =  60.74 MB/sec

These are all good - nice fast disks too by the looks of it - best I've
seen for a while is about 55MB/sec head bandwidth.

> I've expected much better /dev/md6 performance (at least 100MB/s).

I wouldn't - use RAID-0 if you want more performance.

> It seems that md6 uses one drive only. This is the dstat output:

As I understand it, it reads "chunksize" blocks from one drive, then
switches to the other drive, then back again.

Try a bigger read - eg:

  time dd if=/dev/md6 of=/dev/null bs=128K count=8192

but I don't think there are any real gains to be made with RAID-1 - your
results more or less track everything I've seen and used with RAID-1 - ie.
disk read speed is the same as reading from a single device, and never
significantly faster.

Good luck...

Gordon


