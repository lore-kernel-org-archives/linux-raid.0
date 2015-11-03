From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested
Date: Mon, 2 Nov 2015 19:11:24 -0500
Message-ID: <5637FBAC.8000900@turmel.org>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
 <56367C33.6060703@turmel.org>
 <CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
 <5637842D.1070000@turmel.org>
 <CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
 <5637BCE4.8000006@turmel.org>
 <CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Dee,

On 11/02/2015 06:49 PM, o1bigtenor wrote:

> mdadm -E /dev/sdb1
> /dev/sdb1:
>          Magic : a92b4efc
>        Version : 1.2
>    Feature Map : 0x0
>     Array UUID : 79baaa2f:0aa2b9fa:18e2ea6b:6e2846b3
>           Name : debianbase:0  (local to host debianbase)
>  Creation Time : Mon Mar  5 08:26:28 2012
>     Raid Level : raid10
>   Raid Devices : 4
> 
> Avail Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
>     Array Size : 1953518592 (1863.02 GiB 2000.40 GB)
>  Used Dev Size : 1953518592 (931.51 GiB 1000.20 GB)
>    Data Offset : 2048 sectors
>   Super Offset : 8 sectors
>   Unused Space : before=1968 sectors, after=1024 sectors
>          State : clean
>    Device UUID : a80c76db:eaea61af:bcb9cbbb:ac99e467
> 
>    Update Time : Fri Aug 28 10:38:32 2015
>       Checksum : 29a4fa98 - correct
>         Events : 47341
> 
>         Layout : near=2
>     Chunk Size : 512K
> 
>   Device Role : Active device 3
>   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

Useful disk.

> root@debianbase:/# mdadm -E /dev/sdc1
> mdadm: No md superblock detected on /dev/sdc1.
> root@debianbase:/# mdadm -E /dev/sdd1
> mdadm: No md superblock detected on /dev/sdd1.

Not useful disks.

> root@debianbase:/# mdadm -E /dev/sdf1
> /dev/sdf1:
>          Magic : a92b4efc
>        Version : 1.2
>    Feature Map : 0x0
>     Array UUID : 79baaa2f:0aa2b9fa:18e2ea6b:6e2846b3
>           Name : debianbase:0  (local to host debianbase)
>  Creation Time : Mon Mar  5 08:26:28 2012
>     Raid Level : raid10
>   Raid Devices : 4
> 
> Avail Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
>     Array Size : 1953518592 (1863.02 GiB 2000.40 GB)
>  Used Dev Size : 1953518592 (931.51 GiB 1000.20 GB)
>    Data Offset : 2048 sectors
>   Super Offset : 8 sectors
>   Unused Space : before=1968 sectors, after=1024 sectors
>          State : clean
>    Device UUID : 9e749fa9:a0efe791:ea09d2e2:72b99f6c
> 
>    Update Time : Fri Aug 28 10:38:32 2015
>       Checksum : 615d736 - correct
>         Events : 47341
> 
>         Layout : near=2
>     Chunk Size : 512K
> 
>   Device Role : Active device 1
>   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

Yay! Useful disk.  And with a device role that should make a functional
degraded array with /dev/sdb1

>> You may have to conquer this to succeed.  While man pages certainly
>> aren't perfect, they are the most complete documentation available on
>> any linux system.  Most people in your situation struggle with the
>> 'synopsis' section, and how to decipher the brackets and braces and
>> such.  Google 'reading man pages' and sample the results for a wide
>> overview.  Save the deep dive on 'Backus-Naur' for last. :-)
> 
> Sounds like you like the present layout.

Not really.  That doesn't change my advice.

[trim /]

> With two drives removed from access then sdb1 and sdd1 were the useful drives.
> Now with all drives plugged in we are still looking at sdb1 and sdd1 as being
> the most likely accessible drives.

/dev/sdb1 and /dev/sdf1 at the moment.

> Yes something changed from this morning to now. The way it is now makes more
> sense but I didn't change anything.

Rebooting with or without a USB device or any other missing disk is all
it takes.

>> Please supply the updated mdadm -E reports as I asked.  Trim all of the
>> old mails from your reply, too.  Makes for very difficult reading.
> 
> Sorry - - - you did ask for all of what had gone on.

Oh, no.  I wasn't complaining that you supplied them.  Just reminding
you to trim them.  I don't want to annoy the list managers any more than
necessary. :-)

>> When we get your array assembled, we'll use hexdump to poke around.

Ok.  Make sure no array is active in /proc/mdstat.  For any there, do:

mdadm --stop /dev/mdX

Force assemble the array in degraded mode, verbosely:

mdadm -Avf /dev/md0 /dev/sdb1 /dev/sdf1

If the above fails, cut and paste the entire report in your reply.

If it succeeds, paste the output of the following in your reply:

dd if=/dev/md0 bs=1M count=16 |hexdump -C |head -n 1000

That'll be the first 1000 lines of a hex report of the beginning of your
array.

Phil
