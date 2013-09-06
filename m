From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Re: Problem halting raid 1
Date: Fri, 06 Sep 2013 10:09:20 -0600
Message-ID: <5229FE30.2090502@bluehost.com>
References: <CABcjxUOszUPsEJu_nCSRwzCCy5ijs9YUb0ia8HbZ6kzW-jCwWA@mail.gmail.com> <20130906221905.0eb57dc5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130906221905.0eb57dc5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?B?TWlndWVsIENvcmJlcsOhbiBSdWl6?= <migcorrui@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/06/2013 06:19 AM, NeilBrown wrote:

>> What I want to do is to completely remove the array so I can mount the
>> individual partitions anywhere else without the need of mdadm (and
>> access the data created when the array was running).
>
> If the array uses 0.90 or 1.0 metadata, then having stopped the array you can
> simply mount the component devices
>
> If it uses 1.1 or 1.2 you can only access the data via md.
>

I've mounted filesystems outside of mdadm with version 1.1 and 1.2 metadata.  It just requires a little linux jiggery-pokery.

1) Get the data offset using mdadm -E

/dev/sda:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0f9091ac:202b80dc:31e8820b:f2faeb31
            Name : array_3529
   Creation Time : Sat Jul 27 20:53:55 2013
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 4194041856 (1999.88 GiB 2147.35 GB)
      Array Size : 2097020736 (1999.87 GiB 2147.35 GB)
   Used Dev Size : 4194041472 (1999.87 GiB 2147.35 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 7f91df10:05450594:32823f26:924d31ad

     Update Time : Mon Sep  2 22:18:19 2013
        Checksum : f9f956af - correct
          Events : 69985


    Device Role : Active device 0
    Array State : A. ('A' == active, '.' == missing)

2) Multiply the data offset by 512 to convert sectors to bytes

262144 * 512 = 134217728

3) Setup the disk as a loopback device with the data offset

losetup --offset 134217728 /dev/loop1 /dev/sda

4) Now use the loopback device - it looks just like the md device would.

kpartx -a /dev/loop1
mount -o ro /dev/mapper/loop1p1 /mnt/foo

Of course you have to realize that any modifications you make to the filesystem are not mirrored - you will be forced to resync the mirror if you make any modifications to disk at all.

My $0.02

Tregaron


