From: NeilBrown <neilb@suse.de>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Wed, 3 Aug 2011 15:01:08 +1000
Message-ID: <20110803150108.58f5c70b@notabene.brown>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
	<20110802163907.29fc40b4@notabene.brown>
	<CADz4AWEWm68H4ON=+StNE8epBfbnVHnSwJo+NjfTf8-w5Bd2Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADz4AWEWm68H4ON=+StNE8epBfbnVHnSwJo+NjfTf8-w5Bd2Ug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Scheiner <blue@aquarat.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2 Aug 2011 18:16:56 +0200 Aaron Scheiner <blue@aquarat.za.net> wrote:

> Hi Neil! I mailed this list originally because of your website.
> 
> Thanks for the info regarding layout, it's very helpful and explains a lot.
> 
> I saved the output of the -E argument before zero-ing the surviving
> superblocks :

Good !

> 
> "
> /dev/sdd:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : e4a266e5:6daac63f:ea0b6986:fb9361cc
>            Name : nasrat:0
>   Creation Time : Fri May 20 17:32:20 2011
>      Raid Level : raid6
>    Raid Devices : 10
> 
>  Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
>      Array Size : 31256213504 (14904.12 GiB 16003.18 GB)
>   Used Dev Size : 3907026688 (1863.02 GiB 2000.40 GB)
>     Data Offset : 272 sectors
>    Super Offset : 8 sectors

This md superblock is 4K from the start of the device.  So installing GRUB
must have destroyed more than the first 1 or 2 sectors... I hope it didn't
get up to 272 sectors...

> "
> and the second surviving superblock :
> 
> "/dev/sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : e4a266e5:6daac63f:ea0b6986:fb9361cc
>            Name : nasrat:0
>   Creation Time : Fri May 20 17:32:20 2011
>      Raid Level : raid6
>    Raid Devices : 10
> 
>  Avail Dev Size : 3907026688 (1863.02 GiB 2000.40 GB)
>      Array Size : 31256213504 (14904.12 GiB 16003.18 GB)
>     Data Offset : 256 sectors
>    Super Offset : 8 sectors

And this one has a slightly different data offset - 256 sectors!

So just "creating" an array on top of this set of devices will never restore
your data as the data offsets are not all the same.

This will be a little bit tricky ... but maybe not too tricky.

First we need to find the correct order and data offsets.

I would get the raid6check.c code from mdadm-3.2.1.  It has changed in 3.2.2
in a way that isn't really what you want.

It can be given (among other things) a list of device and it will check if
the RAID6 parity blocks are consistent.
As RAID6 depends on order, this will be a good indication whether the devices
are in the correct order or not.

Read the code so we what args it needs.   Note in particular that each device
can be accompanied by an 'offset' in sectors.  So you might list
   /dev/sde1:256 /dev/sdd:272

I just noticed:  one is a partition, the other is a whole device.  That is a
little unusual...  be careful not to let it confuse you...

So using raid6check, check the parity of the first few stripes for every
ordering of devices, and each choice of "256" or "272" as the sector offset.
Hopefully only one will work.

The "--examine" output you provided doesn't have a "Device Role" or "Array
Slot" line.  That is very strange!!  It should tell you at least which
position in the array that device fills.


It just occurred to me that partitions might have been changed on you some
how when you installed GRUB.... probably not but it would be worth checking
the first few hundred K for md metadata just in case it is there.
A metadata block will start  FC 4E 2B A9  (the 'Magic' above is
little-endian), and will container the "Name" of the array 'nasrat:0' at
offset 32.

Once we find the data we will need to convince mdadm to create an array with
all the different data_offsets.  That will require a little bit of coding but
is achievable.


NeilBrown


