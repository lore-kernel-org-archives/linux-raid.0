From: Gordon Henderson <gordon@drogon.net>
Subject: Re: raid5 performance question
Date: Mon, 6 Mar 2006 11:59:34 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 6 Mar 2006, Raz Ben-Jehuda(caro) wrote:

> Neil Hello .
> I have a performance question.
>
> I am using raid5 stripe size 1024K over 4 disks.
> I am benchmarking it with an asynchronous tester.
> This tester submits 100 IOs of size of 1024 K --> as the stripe size.
> It reads raw io from the device, no file system is involved.
>
> I am making the following comparsion:
>
> 1. Reading 4 disks at the same time using 1 MB buffer in random manner.
> 2. Reading 1 raid5 device using 1MB buffer in random manner.
>
> I am getting terrible results in scenario 2. if scenario 1 gives 120 MB/s from
> 4 disks, the raid5 device gives 35 MB/s .
> it is like i am reading a single disk , but by looking at iostat i can
> see that all
> disks are active but with low throughput.
>
> Any idea ?

Is this reading the block device direct, or via a filesystem? If the
latter, what filesystem?

If ext2/3 have you tried mkfs with a stride option?

See:
  http://www.tldp.org/HOWTO/Software-RAID-HOWTO-5.html#ss5.11

Gordon
