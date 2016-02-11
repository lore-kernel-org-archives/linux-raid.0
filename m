From: Marc MERLIN <marc@merlins.org>
Subject: md raid5 on top of dmcrypt, or dmcrypt on top of md raid5?
Date: Thu, 11 Feb 2016 08:29:59 -0800
Message-ID: <20160211162959.GG13969@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 5 drive md array with dmcrypt on top, and btrfs on top of that.
Kernel: 4.4

Honestly, the performance is not good, but it's hard to pin down what
exactly is to blame (there could be performance issues with btrfs too).
I have read that dmcrypt is supposed to be multithreaded, and that's
been true for multiple years.

I put dmcrypt on top so that doing a raid sync or rebuild does not
involve encryption/decryption.
But can someone confirm that indeed if I have a single md device, and 4
CPUs, my throughput is not limited by a single CPU decrypting the
device?

And if I'm going to recreate the array (using bcache this time), is
there a better way to recreate it to avoid performance issues?
It is an array with many small files (filesystem backups), so lots of
random non contiguous I/O

Currently, I have:
gargamel:~# mdadm --detail /dev/md8
/dev/md8:   
        Version : 1.2
  Creation Time : Sat Apr 19 23:03:59 2014
     Raid Level : raid5
     Array Size : 7813523456 (7451.56 GiB 8001.05 GB)
  Used Dev Size : 1953380864 (1862.89 GiB 2000.26 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Feb 11 08:26:45 2016
          State : active 
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

gargamel:~# cryptsetup luksDump /dev/md8
LUKS header information for /dev/md8

Version:        1
Cipher name:    aes
Cipher mode:    xts-plain64
Hash spec:      sha1
Payload offset: 3072
MK bits:        256

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
