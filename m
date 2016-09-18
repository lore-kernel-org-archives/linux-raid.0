From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: Best tool to partition Drives with new sector geometry - (WAS:
 Need Help with crashed RAID5 (that was rebuilding and then had SATA error on
 another drive))
Date: Sun, 18 Sep 2016 13:08:25 -0500
Message-ID: <f1d51563-27c9-be6c-531e-148223433c0e@gmail.com>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
 <CADDTLRBf9NPO6OuF4a3b+xffZgeZRqHRG+pJdPmbc9-Jat0HVQ@mail.gmail.com>
 <d6d3fe0d-3f9f-985f-9bfb-051428cf221b@websitemanagers.com.au>
 <57BBDA5B.3020706@gmail.com> <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
 <57BF9965.1020403@gmail.com> <57C0856D.8050209@youngman.org.uk>
 <57C32D8E.9030102@gmail.com>
 <3b008fb0-1fb3-f12f-d973-3657de6e6923@websitemanagers.com.au>
 <57C38EF5.7020005@gmail.com> <57C41A47.5050506@youngman.org.uk>
 <e6180f36-f246-b4ad-ef53-8012e583b09e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e6180f36-f246-b4ad-ef53-8012e583b09e@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As an update to this, here's some data:


the older Samsung HD103SJ drives (3 of the 4 drive RAID5 are still alive and well in this stack) have partition#1 (/dev/sdX1) which lists out at:

> [root@quantum myth]# sfdisk -l -uM /dev/sdc        <-- this is the output from one of the 3 HD103SJ drives. The partition was originally created by palimpest.
>
> Disk /dev/sdc: 121601 cylinders, 255 heads, 63 sectors/track
> Units = mebibytes of 1048576 bytes, blocks of 1024 bytes, counting from 0
>
>    Device Boot Start   End    MiB    #blocks   Id  System
> /dev/sdc1         0+ 953867- 953868- 976760001   fd  Linux raid autodetect
> /dev/sdc2         0      -      0          0    0  Empty
> /dev/sdc3         0      -      0          0    0  Empty
> /dev/sdc4         0      -      0          0    0  Empty

When I do the math:

976,760,001 * 1024  = 1,000,202,241,024 bytes --- ok, so that's /dev/sdX1

Now we take 1,000,202,241,024 / 4096 (block size of new drives) = 244190000.25 -- so I have a 1024byte (2 512byte sector) difference between the 2 models when trying to switch over.

Is there a best practice for how to contend with this? (resize the partition somehow on the raid and then alter the partitions sizes -2 sectors to make then /8 nicely? I know. Sounds insane. I have backups. I'd do it. :P )

Should I just eat the performance hit for now?

Thanks,

 -Ben


