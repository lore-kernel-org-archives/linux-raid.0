From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: weird issues with raid1
Date: Fri, 5 Dec 2008 20:10:11 -0600
Message-ID: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I set up a raid1 between some devices, and have been futzing with it.
I've been encountering all kinds of weird problems, including one
which required me to reboot my machine.

This is long, sorry.

First, this is how I built the raid:

mdadm --create /dev/md10 --level=1 --raid-devices=2 --bitmap=internal
/dev/sdd1 --write-mostly --write-behind missing

then I added /dev/nbd0:

mdadm /dev/md10 --add /dev/nbd0

and it rebuilt just fine.

Then I failed and removed /dev/sdd1, and added /dev/sda:

mdadm /dev/md10 --fail /dev/sdd1 --remove /dev/sdd1
mdadm /dev/md10 --add /dev/sda

I let it rebuild.

Then I failed, and removed it:

The --fail worked, but the --remove did not.

mdadm /dev/md10 --fail /dev/sda --remove /dev/sda
mdadm: set /dev/sda faulty in /dev/md10
mdadm: hot remove failed for /dev/sda: Device or resource busy

Whaaa?
So I tried again:

mdadm /dev/md10 --remove /dev/sda
mdadm: hot removed /dev/sda

OK. Better, but weird.
Since I'm using bitmaps, I would expect --re-add to allow the rebuild
to pick up where it left off. It was 78% done.

mdadm /dev/md10 --re-add /dev/sda

cat /dev/mdstat

md10 : active raid1 sda[2] nbd0[1]
      78123968 blocks [2/1] [_U]
      [>....................]  recovery =  1.2% (959168/78123968)
finish=30.8min speed=41702K/sec
      bitmap: 0/150 pages [0KB], 256KB chunk


******
Question 1:
I'm using a bitmap. Why does the rebuild start completely over?

4% into the rebuild, this is what --examine-bitmap looks like for both
components:

        Filename : /dev/sda
           Magic : 6d746962
         Version : 4
            UUID : 542a0986:dd465da6:b224af07:ed28e4e5
          Events : 500
  Events Cleared : 496
           State : OK
       Chunksize : 256 KB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123968 (74.50 GiB 80.00 GB)
          Bitmap : 305172 bits (chunks), 305172 dirty (100.0%)

turnip:~ # mdadm --examine-bitmap /dev/nbd0
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : 542a0986:dd465da6:b224af07:ed28e4e5
          Events : 524
  Events Cleared : 496
           State : OK
       Chunksize : 256 KB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123968 (74.50 GiB 80.00 GB)
          Bitmap : 305172 bits (chunks), 0 dirty (0.0%)


No matter how long I wait, until it is rebuilt, the bitmap on /dev/sda
is always 100% dirty.
If I --fail, --remove (twice) /dev/sda, and I re-add /dev/sdd1, it
clearly uses the bitmap and re-syncs in under 1 second.


***************
Question 2: mdadm --detail and cat /proc/mdstat do not agree:

NOTE: mdadm --detail says the rebuild status is 0% complete, but cat
/proc/mdstat shows it as 7%.
A bit later, I check again and they both agree - 14%.
Below, from when the rebuild was 7% according to /proc/mdstat

/dev/md10:
        Version : 00.90.03
  Creation Time : Fri Dec  5 07:44:41 2008
     Raid Level : raid1
     Array Size : 78123968 (74.50 GiB 80.00 GB)
  Used Dev Size : 78123968 (74.50 GiB 80.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 10
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Dec  5 20:04:30 2008
          State : active, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Rebuild Status : 0% complete

           UUID : 542a0986:dd465da6:b224af07:ed28e4e5
         Events : 0.544

    Number   Major   Minor   RaidDevice State
       2       8        0        0      spare rebuilding   /dev/sda
       1      43        0        1      active sync   /dev/nbd0


md10 : active raid1 sda[2] nbd0[1]
      78123968 blocks [2/1] [_U]
      [==>..................]  recovery = 13.1% (10283392/78123968)
finish=27.3min speed=41367K/sec
      bitmap: 0/150 pages [0KB], 256KB chunk



-- 
Jon
