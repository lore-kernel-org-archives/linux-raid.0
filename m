From: d tbsky <tbskyd@gmail.com>
Subject: Re: data corruption after rebuid
Date: Thu, 14 May 2015 14:36:43 +0800
Message-ID: <CAC6SzH+gG3=UXLvq9xgfRVe9zEiQUppw26P2KMutCyADbfhnvw@mail.gmail.com>
References: <CAC6SzHKo8kUOJoC+eaZU1mQCzW+WdB6ACRkrM30yUCA7CodLCQ@mail.gmail.com>
	<555439F4.4020200@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <555439F4.4020200@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2015-05-14 14:00 GMT+08:00 Adam Goryachev <adam@websitemanagers.com.au>:
> On 14/05/15 14:54, d tbsky wrote:
> My guess is this is where you went wrong.
> Instead use a tool that will do this intelligently, quick google shows this:
> sgdisk -R=/dev/sdb /dev/sda
> sgdisk -G /dev/sdb
> Taken from:
> http://unix.stackexchange.com/questions/12986/how-to-copy-the-partition-layout-of-a-whole-disk-using-standard-tools
>
> My guess is you copied some data as well as the partition table, and
> that you are using a mdadm label which is stored at the beginning of the
> disk, and possibly are using bitmap on one server and not the other.

    this step did look suspicious. but I had use it many times on
blank hard disks. and it seems works..

> Maybe if you could show some details from each of the raid arrays then
> more people can make more informed comments.

 sure. below is the raid structure of  hostA & hostB:
/dev/md1:
        Version : 1.1
  Creation Time : Wed Feb 19 09:34:03 2014
     Raid Level : raid1
     Array Size : 1953177408 (1862.70 GiB 2000.05 GB)
  Used Dev Size : 1953177408 (1862.70 GiB 2000.05 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal


  and below is the raid structure of my first test:
/dev/md1:
        Version : 1.1
  Creation Time : Mon Oct 20 18:51:47 2014
     Raid Level : raid5
     Array Size : 3906354176 (3725.39 GiB 4000.11 GB)
  Used Dev Size : 1953177088 (1862.69 GiB 2000.05 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu May 14 14:32:25 2015
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K



    and the raid structure of my second and thrid test:
/dev/md1:
        Version : 1.1
  Creation Time : Sun Sep 28 19:20:59 2014
     Raid Level : raid10
     Array Size : 1953033216 (1862.56 GiB 1999.91 GB)
  Used Dev Size : 976516608 (931.28 GiB 999.95 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu May 14 14:33:14 2015
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 512K
