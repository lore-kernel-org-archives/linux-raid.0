From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: stride / stripe alignment on LVM ?
Date: Sat, 3 Nov 2007 21:21:18 +0100
Message-ID: <20071103212118.5fd4c770@absurd>
References: <20071101101037.63b523f8@absurd>
 <18218.24819.569744.141171@notabene.brown>
 <472B1F91.8000208@tmr.com>
 <20071102231605.7add5154@absurd>
 <1194115248.25553.59.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194115248.25553.59.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford said:     (by the date of Sat, 03 Nov 2007 14:40:48 -0400)

> so you really only need to align the
> lvm superblock so that data starts at 128K offset into the raid array.

Sorry, I thought that it will be easier to figure this out
experimentally - put LVM here or there, write 128k of data to the
disc (inside LVM partition), then see (with hexedit) if this data is
really split across several discs or not.

In fact I even managed to find where LVM superblock starts inside
RAID, the problem for me was that I wasn't sure where it ends, and
where the actual data, starts, and *THAT* data has to be aligned on
128K offset. Now I know that I should simply look more carefully at
LVM manuals, to see exactly what is the size of LVM superblock.

So I was unable to do that simple 128k test like that:

# dd if=./128k_of_0xAA of=/dev/lvm_raid5/test

then looking for 128k(or 64k or 32k) of 0xAA on hda3 and sda3. 
But most of the time was spent searching the search pattern
(scanning the disc). So my efficiency was low, and in fact I should
have simply used a smaller test partitions (eg. hda4, sda4 with
just 20MB), so scanning would be faster.

With smaller test partitions perhaps I'd have enough time to overcome
the main difficulty - dealing with degraded array (and encoded data).

Possibly I'll try this next time when I'll buy fourth disc to the
array (next year), so I'll be able to have two degraded arrays
of two discs at the same time. Then I could use LVM again and 
"dd" all data from old array to new one, then grow the new array
to use all 4 HDDs.

Currently I just formatted /dev/md1 with ext3, without LVM.

Thanks, I got to remember that in 1.1 the superblock is on the front.
And I shouldn't forget about the bitmap either :)

> If you run mdadm -D /dev/md1 it will tell you the data offset
> (in sectors IIRC).

Uh, I don't see it:

backup:~# mdadm -D /dev/md1
/dev/md1:
        Version : 01.01.03
  Creation Time : Fri Nov  2 23:35:37 2007
     Raid Level : raid5
     Array Size : 966807296 (922.02 GiB 990.01 GB)
    Device Size : 966807296 (461.01 GiB 495.01 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sat Nov  3 20:59:06 2007
          State : active, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : backup:1  (local to host backup)
           UUID : 22f22c35:99613d52:31d407a6:55bdeb84
         Events : 39975

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1       8        3        1      active sync   /dev/sda3
       2       0        0        2      removed


thanks again for all your helpful responses!
-- 
Janek Kozicki                                                      |
