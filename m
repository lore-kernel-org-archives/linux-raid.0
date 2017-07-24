From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: Wrong array assembly on boot?
Date: Mon, 24 Jul 2017 18:27:50 +0300
Message-ID: <597611F6.20500@yandex.ru>
References: <59739BDD.30307@yandex.ru> <597608BD.7080108@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <597608BD.7080108@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/07/17 17:48, Wols Lists wrote:
> On 22/07/17 19:39, Dark Penguin wrote:
>> Greetings!
>>
>> I have a mirror RAID with two devices (sdc1 and sde1). It's not a root
>> partition, just a RAID with some data for services running on this
>> server. (I'm running Debian Jessie x86_64 with a 4.1.18 kernel.) The
>> RAID is listed in /etc/mdadm, and it has an external bitmap in /RAID .
> 
> As an absolute minimum, can you please give us your version of mdadm.

Oh, right, sorry. I thought the "absolute minimum" would be the kernel
version and the distribution. :)

mdadm - v3.3.2 - 21st August 2014


> And the output of "mdadm --display" of your arrays. (I think I've got
> that right, I think --examine is the disk ...)

It's "mdadm --detail --scan" for all arrays or "mdadm --detail /dev/md0"
for md0.

I have 8 arrays on this server, and the only one that's relevant is this
one. (The rest of them are set up exactly the same way, but with
different names and UUIDs.) So, to avoid cluttering:


$ sudo mdadm --detail /dev/md/RAID
/dev/md/RAID:
        Version : 1.2
  Creation Time : Thu Oct  6 23:15:56 2016
     Raid Level : raid1
     Array Size : 244066432 (232.76 GiB 249.92 GB)
  Used Dev Size : 244066432 (232.76 GiB 249.92 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : /RAID

    Update Time : Mon Jul 24 17:59:53 2017
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : BAAL:RAID  (local to host BAAL)
           UUID : 8b5f18f0:54f655b7:8bfcc60d:4db6e6c8
         Events : 5000

Number   Major   Minor   RaidDevice State
   0       8       65        0      active sync   /dev/sde1
   1       8       33        1      active sync writemostly   /dev/sdc1


And the /etc/mdadm/mdadm.conf entry is:

ARRAY /dev/md/RAID	metadata=1.2	name=BAAL:RAID	bitmap=/RAID
UUID=8b5f18f0:54f655b7:8bfcc60d:4db6e6c8

I don't use the device names here because they change often in a server
with 8 arrays and 20 drives (sometimes I connect a new one or remove an
old one...). The UUID is here, the bitmap file is here, so it just looks
for all drives with this UUID and assembles the array.

As I understand, it has found the first device (/dev/sdc1, which was
outdated) and immediately added it to an array. Then it found the second
device (/dev/sde1, the up-to-date one), noticed an inconsistency and did
not add it. The question is, why did it start the array, why did it not
halt the boot process, why did it not realize that the second device is
newer (and also it already knows about the disappearance of the first
one!)...


-- 
darkpenguin
