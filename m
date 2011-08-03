From: Aaron Scheiner <blue@aquarat.za.net>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Wed, 3 Aug 2011 10:59:22 +0200
Message-ID: <CADz4AWFekPKreuiwzYBvTnbXZnDGRH7nQ1WKEaeOdn7_6M5eQg@mail.gmail.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
 <20110802163907.29fc40b4@notabene.brown> <CADz4AWEWm68H4ON=+StNE8epBfbnVHnSwJo+NjfTf8-w5Bd2Ug@mail.gmail.com>
 <20110803150108.58f5c70b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110803150108.58f5c70b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mmm, learning experience :P

The Wikipedia page on grub says :
"
Stage 1 can load Stage 2 directly, but it's normally set up to load
Stage 1.5. GRUB Stage 1.5 is located in the first 30 kilobytes of hard
disk immediately following the MBR and before the first partition.
"
So if both stage 1 and stage 1.5 were written to the drives
approximately 30KBytes would have been overwritten, so 60 sectors?

Why is the data offset by 256 bytes ? The array was created using a
standard create command (only specifying raid level, devices, chunk
size).

"I just noticed: =A0one is a partition, the other is a whole device. =A0=
That is a
little unusual... =A0be careful not to let it confuse you..."
=2E..yes... I'm not sure how that happened heh. I do have the dmesg log
from the OS drive of the machine the array last ran on. It lists stuff
like drive order (the cables have moved around since then) and
devices.

I had to rush out this morning so I haven't been able to check the
status of scalpel... and that's a great idea @ run in parallel.

On Wed, Aug 3, 2011 at 7:01 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 2 Aug 2011 18:16:56 +0200 Aaron Scheiner <blue@aquarat.za.net=
> wrote:
>
>> Hi Neil! I mailed this list originally because of your website.
>>
>> Thanks for the info regarding layout, it's very helpful and explains=
 a lot.
>>
>> I saved the output of the -E argument before zero-ing the surviving
>> superblocks :
>
> Good !
>
>>
>> "
>> /dev/sdd:
>> =A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
>> =A0 =A0 =A0 =A0 Version : 1.2
>> =A0 =A0 Feature Map : 0x1
>> =A0 =A0 =A0Array UUID : e4a266e5:6daac63f:ea0b6986:fb9361cc
>> =A0 =A0 =A0 =A0 =A0 =A0Name : nasrat:0
>> =A0 Creation Time : Fri May 20 17:32:20 2011
>> =A0 =A0 =A0Raid Level : raid6
>> =A0 =A0Raid Devices : 10
>>
>> =A0Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
>> =A0 =A0 =A0Array Size : 31256213504 (14904.12 GiB 16003.18 GB)
>> =A0 Used Dev Size : 3907026688 (1863.02 GiB 2000.40 GB)
>> =A0 =A0 Data Offset : 272 sectors
>> =A0 =A0Super Offset : 8 sectors
>
> This md superblock is 4K from the start of the device. =A0So installi=
ng GRUB
> must have destroyed more than the first 1 or 2 sectors... I hope it d=
idn't
> get up to 272 sectors...
>
>> "
>> and the second surviving superblock :
>>
>> "/dev/sde1:
>> =A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
>> =A0 =A0 =A0 =A0 Version : 1.2
>> =A0 =A0 Feature Map : 0x1
>> =A0 =A0 =A0Array UUID : e4a266e5:6daac63f:ea0b6986:fb9361cc
>> =A0 =A0 =A0 =A0 =A0 =A0Name : nasrat:0
>> =A0 Creation Time : Fri May 20 17:32:20 2011
>> =A0 =A0 =A0Raid Level : raid6
>> =A0 =A0Raid Devices : 10
>>
>> =A0Avail Dev Size : 3907026688 (1863.02 GiB 2000.40 GB)
>> =A0 =A0 =A0Array Size : 31256213504 (14904.12 GiB 16003.18 GB)
>> =A0 =A0 Data Offset : 256 sectors
>> =A0 =A0Super Offset : 8 sectors
>
> And this one has a slightly different data offset - 256 sectors!
>
> So just "creating" an array on top of this set of devices will never =
restore
> your data as the data offsets are not all the same.
>
> This will be a little bit tricky ... but maybe not too tricky.
>
> First we need to find the correct order and data offsets.
>
> I would get the raid6check.c code from mdadm-3.2.1. =A0It has changed=
 in 3.2.2
> in a way that isn't really what you want.
>
> It can be given (among other things) a list of device and it will che=
ck if
> the RAID6 parity blocks are consistent.
> As RAID6 depends on order, this will be a good indication whether the=
 devices
> are in the correct order or not.
>
> Read the code so we what args it needs. =A0 Note in particular that e=
ach device
> can be accompanied by an 'offset' in sectors. =A0So you might list
> =A0 /dev/sde1:256 /dev/sdd:272
>
> I just noticed: =A0one is a partition, the other is a whole device. =A0=
That is a
> little unusual... =A0be careful not to let it confuse you...
>
> So using raid6check, check the parity of the first few stripes for ev=
ery
> ordering of devices, and each choice of "256" or "272" as the sector =
offset.
> Hopefully only one will work.
>
> The "--examine" output you provided doesn't have a "Device Role" or "=
Array
> Slot" line. =A0That is very strange!! =A0It should tell you at least =
which
> position in the array that device fills.
>
>
> It just occurred to me that partitions might have been changed on you=
 some
> how when you installed GRUB.... probably not but it would be worth ch=
ecking
> the first few hundred K for md metadata just in case it is there.
> A metadata block will start =A0FC 4E 2B A9 =A0(the 'Magic' above is
> little-endian), and will container the "Name" of the array 'nasrat:0'=
 at
> offset 32.
>
> Once we find the data we will need to convince mdadm to create an arr=
ay with
> all the different data_offsets. =A0That will require a little bit of =
coding but
> is achievable.
>
>
> NeilBrown
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
