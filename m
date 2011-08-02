From: Aaron Scheiner <blue@aquarat.za.net>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Tue, 2 Aug 2011 18:16:56 +0200
Message-ID: <CADz4AWEWm68H4ON=+StNE8epBfbnVHnSwJo+NjfTf8-w5Bd2Ug@mail.gmail.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
 <20110802163907.29fc40b4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110802163907.29fc40b4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil! I mailed this list originally because of your website.

Thanks for the info regarding layout, it's very helpful and explains a =
lot.

I saved the output of the -E argument before zero-ing the surviving
superblocks :

"
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e4a266e5:6daac63f:ea0b6986:fb9361cc
           Name : nasrat:0
  Creation Time : Fri May 20 17:32:20 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256213504 (14904.12 GiB 16003.18 GB)
  Used Dev Size : 3907026688 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f971c81d:da719d55:b55129f1:802d76ea

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Jul 20 12:40:39 2011
       Checksum : 7ff625b6 - correct
         Events : 421070

     Chunk Size : 128K

"
and the second surviving superblock :

"/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e4a266e5:6daac63f:ea0b6986:fb9361cc
           Name : nasrat:0
  Creation Time : Fri May 20 17:32:20 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907026688 (1863.02 GiB 2000.40 GB)
     Array Size : 31256213504 (14904.12 GiB 16003.18 GB)
    Data Offset : 256 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : ba9da7a2:c47b749f:57081441:5b5e8a4e

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Jul 20 12:40:39 2011
       Checksum : 2aa3a36 - correct
         Events : 421070

     Chunk Size : 128K

"

This is what I've recently done :

I wrote an application that takes samples of the file I have (a copy
of which was also on the damaged array) and writes those samples into
a config file for scalpel.
The application collected 40 samples, each sample is 512 bytes long.
There are gaps of 30KBytes between samples (so the samples cover
roughly 1.2MBytes in total).

Scalpel is currently searching through the drives for the samples. I'm
hoping that once scalpel is done all I'll have to do is arrange the
drives based on what drives samples are discovered on.

Assuming the file was stored contiguously in the filesystem, do you
think this would work ?

Thanks for the info and thanks for an amazing utility/application.

Aaron

On Tue, Aug 2, 2011 at 8:39 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 27 Jul 2011 14:16:52 +0200 Aaron Scheiner <blue@aquarat.za.ne=
t> wrote:
>
>> Hi
>>
>> My original message was sent (and rejected) 4 days ago because it wa=
s
>> in HTML (whoops). Here's my original e-mail with updates :
>>
>> I've got an Ubuntu machine with an mdadm RAID array on level 6.=A0Th=
e
>> RAID-6 array consists of 10 drives and has been running for about 3
>> years now. I recently upgraded the drives in the array from 1TB unit=
s
>> to 2TB units.
>>
>> The drive on which the OS sat died a few days ago, so I installed a
>> new OS drive and then installed Ubuntu Server on it.
>> On reboot the machine hung on a black screen with a white flashing
>> cursor. So I went back into the Ubuntu Setup and installed grub to a=
ll
>> of the drives in the raid array (except two) [wow, this was such a
>> stupid move].
>
> So you still have two with valid superblocks? =A0(or did before you s=
tarted
> re-creating). =A0Do you have a copy of the "mdadm --examine" of those=
? =A0It
> would be helpful.
>
>>
>> I then rebooted the machine and it successfully booted into Ubuntu
>> Server. I set about restoring the configuration for the raid array..=
=2E
>> only to be given the message "No Superblock Found" (more or less).
>> Each element in the array was used directly by mdadm (so /dev/sda, n=
ot
>> /dev/sda1).
>>
>> I see that the superblock is stored within the MBR region on the dri=
ve
>> (which is 512bytes from the start of the disk), which would explain
>> why the superblocks were destroyed. I haven't been able to find
>> anything regarding a backup superblock (does something like this
>> exist?).
>>
>> I have now started using a script that tries to re-create the array =
by
>> running through the various permutations available... it takes rough=
ly
>> 2.5 seconds per permutation/iteration and there are just over 40 000
>> possibilities. The script tests for a valid array by trying to mount
>> the array as read only (it's an XFS file system). I somehow doubt th=
at
>> it will mount even when the correct combination of disks is found.
>> [UPDATE] : It never mounted.
>
> Odd... =A0Possibly you have a newer mdadm which uses a different "Dat=
a
> offset". =A0The "mdadm --examine" of the 2 drives that didn't get cor=
rupted
> would help confirm that.
>
>>
>> So... I have an idea... The array has a hole bunch of movie files on
>> it and I have exact copies of some of them on another raid array. So=
 I
>> was thinking that if I searched for the start of one of those files =
on
>> the scrambled array, I could work out the order of the disks by
>> searching forward until I found a change. I could then compare the
>> changed area (probably 128KB/the chunk size forward) with the file I
>> have and see where that chunk lies in the file, thereby working out
>> the order.
>> [UPDATE] : Seeing as the array never mounted, I have proceeded with
>> this idea. I took samples of the start of the video file and provide=
d
>> them to Scalpel as needles for recovery. After two days of searching=
,
>> Scalpel located the starts of the various segments in the raid array
>> (I re-created the raid array with the drives in random order). I the=
n
>> carved (using dd) 3MBs out of the raid array that contains all the
>> samples handed to scalpel originally (plus a bit more).
>>
>> So now I have to find segments of the start of the intact file in th=
e
>> carved out data from the raid array.
>>
>> It would be really useful if I knew the layout of the array :
>>
>> If the chunk size of the array is 128KB, does that mean that the fil=
e
>> I carved will be divided up into segments of contiguous data, each
>> 128KBs in length ? or does it mean that the length of contiguous dat=
a
>> will be 16KB ( 128 KB / 8 drives ) ?
>
> 128KB per device, so the first alternative.
>
>>
>> Do these segments follow on from each other without interruption or =
is
>> there some other data in-between (like metadata? I'm not sure where
>> that resides).
>
> That depends on how XFS lays out the data. =A0It will probably be mos=
tly
> contiguous, but no guarantees.
>
>
>>
>> Any explanation of the structure of a raid6 array would be greatly
>> appreciated, as well as any other advice (tools, tips, etc).
>
> The stripes start "Data Offset" from the beginning of the device, whi=
ch I
> think is 1MB with recent mdadm, but something like 64K with earlier m=
dadm.
>
> The first few stripes are:
>
> =A0Q =A00 =A01 =A02 =A03 =A04 =A05 =A06 =A07 =A0P
> =A08 =A09 10 11 12 13 14 15 =A0P =A0Q
> 17 18 19 20 21 22 23 =A0P =A0Q 16
>
> Where 'P' is xor parity, Q is GF parity, and N is chunk number N. =A0=
Each chunk
> is 128KB (if that is your chunk size).
>
> This pattern repeats after 10 stripes.
>
> good luck,
> NeilBrown
>
>
>>
>> Thanks :)
>>
>> Aaron (24)
>> South Africa
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
