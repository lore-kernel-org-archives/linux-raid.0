From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: 3ware 7500 performance, was: experiences with 3Ware 6400 3W-6400?
Date: Sat, 28 Jun 2003 10:57:28 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0306281040270.16597-100000@router.windsormachine.com>
References: <6661311060.20030628170015@mail.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6661311060.20030628170015@mail.ru>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 28 Jun 2003, Alex Verbitsky wrote:

> What kernel did you use for testing?

Those two machines are running 2.4.21, and saw similar results under
2.4.20.

> upgrading firmware to 7.6 - the same.

I'll try this next week when I'm at the office, and see if it does
anything.

> As a conclusion, seems that RH9's kernel (and maybe some other kernels?) are broken.

Using a self built kernel, so who knows.

> Also, did you tweaked max-readahead/min-readahead params?
> doing this:
>         echo 256 > /proc/sys/vm/max-readahead
>         echo 128 > /proc/sys/vm/min-readahead
> increased my sequental read from 58 MB/s to 80 MB/s (at expense of CPU
> usage - from 22% to 36%).

Haven't touched those, testing that now.

Yup, seeing about a 10-15% increase for the most part, and a little more
cpu load, which is't a problem, as I've got spare cpu to spare, even with
the gzip going.  Can't very accurately test the system as I can't just
init 1 it and go test from here.

> Also you did not report your RAM size. if you have 512 MB, your
> results are not very accurate because some amount of writes is
> cached.

256 meg in each machine.

> I highly recommend you to upgrade - though i did not notice any
> performance gains, it contains new improved CLI utility with online
> array create/delete commands, and also better support RH8.

I have one machine running 7.6 already, and didn't notice anything useful
to me, besides being able to call up the alarms from the cli, which I
track in the syslog anyways.

If I have a drive failure, I have to power down the machine anyways, so
online create/delete doesn't bother me much.

> MD> The 7000-2 and 7500-4's in raid1 work quite nicely.  The 7500-4 in raid5
> MD> actually lags the system for 3-5 seconds when doing a lot of disk i/o.
> MD> Feels like working on a p120 with DMA shut off, to be honest.
> What do you mean by this? I did not notice anything like this, though i
> use it for sequental i/o mainly.
> if your i/o is highly random, then 3ware acceleration (R5 fusion) is
> not working and you should receive something like 5-10 MB/s.

Likely that, as if I'm ungzip'ing say a 3 gig file, and then go to log in,
doing even an ls will take a few seconds to come up.

Mike

