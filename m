From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: raid1 + 2.6.27.7 issues
Date: Mon, 9 Feb 2009 18:07:48 -0600
Message-ID: <cccedfc60902091607j4f37420s64898e4994d2607e@mail.gmail.com>
References: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com>
	 <18832.43882.839120.846061@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18832.43882.839120.846061@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 9, 2009 at 4:17 PM, Neil Brown <neilb@suse.de> wrote:
...

> I've managed to reproduce this.
>
> If you fail the write-mostly device when the array is 'clean' (as
> reported by --examine), it works as expected.
> If you fail it when the array is 'active', you get the full recovery.
>
> The array is 'active' if there have been any writes in the last 200
> msecs, and clean otherwise.
>
> I'll have to have a bit of a think about this and figure out where
> what the correct fix is.   Nag me if you haven't heard anything by the
> end of the week.


Can-do. Here are some more wrinkles:

Wrinkle "A". I can't un-do "write-mostly". I used the md.txt docs that
ship with the kernel which suggest that the following should work:

1. I let the array come up to sync
2. I echoed "-writemostly" into /sys/block/md11/md/dev-nbd0/state
3. A 'cat state' showed "in_sync,write_mostly" before, and "in_sync" after.
4. --fail and --remove /dev/nbd0
5. --re-add /dev/nbd0
6. 'cat state' shows "in_sync,write_mostly" again. D'oh!



Wrinkle "B": When I did the above, when I --re-add'ed /dev/nbd0, it
went into "recovery" mode, which completed instantly. My recollection
of "recovery" is that it does not update the bitmap until the entire
process is complete. Is this correct? If so, I'd like to try to
convince you (Neil Brown) that it's worthwhile to behave the same WRT
the bitmap and up-to-dateness regardless of whether it's recovery or
resync.

I'm including the --examine, --examine-bitmap from both /dev/nbd0 and /dev/sda:

/dev/nbd0:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf24d099:9e174a79:2a2f6797:dcff1420
           Name : turnip:11  (local to host turnip)
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 160086384 (76.34 GiB 81.96 GB)
     Array Size : 156247976 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (74.50 GiB 80.00 GB)
   Super Offset : 160086512 sectors
          State : clean
    Device UUID : 01524a75:c309869c:6da972c9:084115c6

Internal Bitmap : 2 sectors from superblock
      Flags : write-mostly
    Update Time : Mon Feb  9 17:49:21 2009
       Checksum : 6404fbcd - correct
         Events : 90426


    Array Slot : 2 (failed, failed, 0, 1)
   Array State : Uu 2 failed
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : cf24d099:9e174a79:2a2f6797:dcff1420
          Events : 90426
  Events Cleared : 90398
           State : OK
       Chunksize : 4 MB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123988 (74.50 GiB 80.00 GB)
          Bitmap : 19074 bits (chunks), 0 dirty (0.0%)

/dev/sda:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf24d099:9e174a79:2a2f6797:dcff1420
           Name : turnip:11  (local to host turnip)
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 160086384 (76.34 GiB 81.96 GB)
     Array Size : 156247976 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (74.50 GiB 80.00 GB)
   Super Offset : 160086512 sectors
          State : clean
    Device UUID : 0059434c:ecef51a0:2974482d:ba38f944

Internal Bitmap : 2 sectors from superblock
    Update Time : Mon Feb  9 17:57:34 2009
       Checksum : 2184ad61 - correct
         Events : 90446


    Array Slot : 3 (failed, failed, failed, 1)
   Array State : _U 3 failed
        Filename : /dev/sda
           Magic : 6d746962
         Version : 4
            UUID : cf24d099:9e174a79:2a2f6797:dcff1420
          Events : 90446
  Events Cleared : 90398
           State : OK
       Chunksize : 4 MB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123988 (74.50 GiB 80.00 GB)
          Bitmap : 19074 bits (chunks), 0 dirty (0.0%)




-- 
Jon
