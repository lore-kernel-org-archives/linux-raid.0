From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: raid5 performance question
Date: Tue, 7 Mar 2006 10:40:16 +0200
Message-ID: <5d96567b0603070040t114334cbm858147afe551f719@mail.gmail.com>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
	 <17420.46746.365629.168649@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17420.46746.365629.168649@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil.
what is the stripe_cache exacly ?

First , here are some numbers.

Setting it to 1024 gives me 85 MB/s.
Setting it to 4096 gives me 105 MB/s.
Setting it to 8192 gives me 115 MB/s.

the md.txt does not say much about it just that it is the number of
entries.

here are some tests i have made:

test1:
when i set the stripe_cache to zero and run:

  "dd if=/dev/md1 of=/dev/zero bs=1M count=100000 skip=630000"
 i am getting 120MB/s.
 when i set the stripe cache to 4096 and : issue the same command i am
getting 120 MB/s
as well.

test 2:
I would describe what this tester does:

It opens N descriptors over a device.
It issues N IOs to the target and waits for the completion of each IO.
When the IO is completed the tester has two choices:

  1. calculate a new seek posistion over the target.

  2. move sequetially to the next position. meaning , if one reads 1MB
buffer, the next
      position is current+1M.

  I am using direct IO and asynchrnous IO.

option 1 simulates non contigous files. option 2 simulates contiguous files.
the above numbers were made with option 2.
if i am using option 1 i am getting 95 MB/s with stripe_size=4096.

A single disk in this manner ( option 1 ) gives ~28 MB/s.
A single disk in scenario 2 gives ~30 MB/s.

I understand the a question of the IO distribution is something to talk
about. but i am submitting 250 IOs so i suppose to be heavy on the raid.

Questions
1. how can the stripe size cache gives me a boost when i have total
random access
    to the disk ?

2. Does direct IO passes this cache ?

3. How can a dd of 1 MB over 1MB chunck size acheive this high
throughputs of 4 disks
   even if does not get the stripe cache benifits ?

thank  you
raz.




On 3/7/06, Neil Brown <neilb@suse.de> wrote:
> On Monday March 6, raziebe@gmail.com wrote:
> > Neil Hello .
> > I have a performance question.
> >
> > I am using raid5 stripe size 1024K over 4 disks.
>
> I assume you mean a chunksize of 1024K rather than a stripe size.
> With a 4 disk array, the stripe size will be 3 times the chunksize,
> and so could not possibly by 1024K.
>
> > I am benchmarking it with an asynchronous tester.
> > This tester submits 100 IOs of size of 1024 K --> as the stripe size.
> > It reads raw io from the device, no file system is involved.
> >
> > I am making the following comparsion:
> >
> > 1. Reading 4 disks at the same time using 1 MB buffer in random manner.
> > 2. Reading 1 raid5 device using 1MB buffer in random manner.
>
> If your chunk size is 1MB, then you will need larger sequential reads
> to get good throughput.
>
> You can also try increasing the size of the stripe cache in
>    /sys/block/mdX/md/stripe_cache_size
>
> The units are in pages (normally 4K) per device.  The default is 256 which fits
> only one stripe with a 1 Meg chunk size.
>
> Try 1024 ?
>
> NeilBrown
>
>
> >
> > I am getting terrible results in scenario 2. if scenario 1 gives 120 MB/s from
> > 4 disks, the raid5 device gives 35 MB/s .
> > it is like i am reading a single disk , but by looking at iostat i can
> > see that all
> > disks are active but with low throughput.
> >
> > Any idea ?
> >
> > Thank you.
> > --
> > Raz
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
Raz
