From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Tue, 19 Feb 2013 16:16:02 -0500
Message-ID: <5123EB92.5090505@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5123E4E9.3020609@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Stone,

You dropped the linux-raid list.  Please use "Reply-to-all" for any list
on vger.kernel.org.

[trim /]

>>> i found with an hexdump on the disk sdc1 and sdf1 the LUKS header
>>> hexdump -C /dev/sdc1 | head -40
>>> .....
>>> 00100000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00
>>> |LUKS....aes.....|

Note that the location is 100000 hex.  That is 1MB, or 2048 512-byte
sectors.

> i dont have a report from my disks before i recreated it. why i do this?
> i have found many postings and there say this is a good way... :/

Many people get in trouble and *have* to do it, but it is a *last*
resort, as it destroys the original configuration data.  Most people who
blog about these things report the command the fixed *their* problem,
without thinking about what *should* be done.

> mdadm -E /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 87345225:b5aea7dc:3f3569ba:4804f177
>            Name : bender:2  (local to host bender)
>   Creation Time : Tue Feb 19 10:20:40 2013
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 3906766941 (1862.89 GiB 2000.26 GB)
>      Array Size : 5860145664 (5588.67 GiB 6000.79 GB)
>   Used Dev Size : 3906763776 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors

When you recreated the array, the newer version of mdadm used a
different data offset.

>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 4353f38f:8adbd4fb:a80abaff:a08a784f
> 
>     Update Time : Tue Feb 19 10:33:58 2013
>        Checksum : c2ed9b46 - correct
>          Events : 4
> 
>          Layout : left-symmetric
>      Chunk Size : 512K

This chunk size is the default for recent versions of mdadm, but not
older ones.  But the 1MB data offset is also somewhat recent, so there's
a good chance this will work.

[trim /]

> i also have a hexdump on the md2 device running but this takes on 6Tb a
> very long time...

This won't be needed.

> the crash was on Feb 18. the syslog from this date i have. i attacht it
> at this mail and hope that is ok.
> at the end of the syslog.2 you see the first errors and then came the
> logswitch

I was hoping for the last successful boot-up from before the drive
failure, so I could see the device order for sure.  But I did find a
recovery event on the 17th that shows it:

> Feb 17 13:49:34 bender kernel: [5286525.603601] RAID conf printout:
> Feb 17 13:49:34 bender kernel: [5286525.603609]  --- level:5 rd:4 wd:3
> Feb 17 13:49:34 bender kernel: [5286525.603615]  disk 0, o:1, dev:sdc1
> Feb 17 13:49:34 bender kernel: [5286525.603620]  disk 1, o:1, dev:sdd1
> Feb 17 13:49:34 bender kernel: [5286525.603624]  disk 2, o:1, dev:sde1
> Feb 17 13:49:34 bender kernel: [5286525.603628]  disk 3, o:1, dev:sdf1

So your next step is find an older copy of mdadm that will create an
array with Data Offset of 2048 sectors (logical 512-byte sectors).
Something from about six months ago should do.  (The new 128MB offset
default is to support Bad Block logging, a fairly new feature.)

Then, with the older mdamd version, you must use "mdadm --create
--assume-clean" just like you already did.  If luksOpen works, do *not*
mount it until you've used "fsck -n" to see if the array properties are
correct.

If that reports many errors, you will need to try other chunk sizes
until you find the size the array was created with.  If you had saved
the "mdadm -E" reports from the original array, we would not have to guess.

Meanwhile, you need to investigate why you lost one disk, and then
another during rebuild.  This is often a side effect of using cheap
desktop drives in your array.  It is possible to do, but doesn't work
"out-of-the-box".

Please share "smartctl -x" from each of your drives, and the output of:

for x in /sys/block/sd*/device/timeout ; do echo $x ; cat $x ; done

Phil
