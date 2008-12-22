From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Mon, 22 Dec 2008 08:40:35 -0600
Message-ID: <cccedfc60812220640m53f668q56fcf765286bedd4@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	 <cccedfc60812172050h58697665y975a18550842aebb@mail.gmail.com>
	 <cccedfc60812172055n58181ad4lcdff8f172c6a496c@mail.gmail.com>
	 <18761.56537.935250.561921@notabene.brown>
	 <cccedfc60812172147q240466a8w53c5bd2540edf6a4@mail.gmail.com>
	 <18761.60380.938542.26851@notabene.brown>
	 <cccedfc60812181815oa63b526tb51c3bee558fbdf@mail.gmail.com>
	 <cccedfc60812190851x446a6046p2578b8de72edc93b@mail.gmail.com>
	 <cccedfc60812191240m185d5f49td1ec2070c70c88e4@mail.gmail.com>
	 <cccedfc60812191318w18de5dfbs28bf476bd5d88359@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60812191318w18de5dfbs28bf476bd5d88359@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

More updates:

1. I upgraded to openSUSE 11.1 over the weekend. The kernel is
2.6.27.7-9 as of this writing.

2. When I fired up the machine which hosts the network block device,
the machine hosting the raid properly noticed and --re-added /dev/nbd0
to /dev/md11.

3. /dev/md11 went into "recover" mode (not resync).

4. I'm using persistent metadata and a write-intent bitmap.


**Question**:

What am I doing wrong here? Why doesn't --re-add cause resync instead
of rebuild? If I'm reading the output from --examine-bitmap (below)
correctly, there are 2049 dirty bits at 4MB per bit or about 8196 MB
to resync.


According to this (from the manpage)

       If an array is using a write-intent bitmap, then devices
       which have been removed can be re-added in  a  way  that
       avoids  a  full  reconstruction but instead just updates
       the blocks  that  have  changed  since  the  device  was
       removed.     For   arrays   with   persistent   metadata
       (superblocks) this is done  automatically.   For  arrays
       created  with  --build  mdadm needs to be told that this
       device we removed recently with --re-add.

I'm doing everything OK.
I can the --examine, --examine-bitmap from /dev/nbd0 *before* it is
added to the array:


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
    Update Time : Sat Dec 20 19:43:43 2008
       Checksum : 63c19462 - correct
         Events : 7042


    Array Slot : 2 (failed, failed, empty, 1)
   Array State : _u 2 failed
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : cf24d099:9e174a79:2a2f6797:dcff1420
          Events : 5518
  Events Cleared : 5494
           State : OK
       Chunksize : 4 MB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123988 (74.50 GiB 80.00 GB)
          Bitmap : 19074 bits (chunks), 0 dirty (0.0%)

Then I --re-added /dev/nbd0 to the array:

Dec 22 08:15:53 turnip kernel: RAID1 conf printout:
Dec 22 08:15:53 turnip kernel:  --- wd:1 rd:2
Dec 22 08:15:53 turnip kernel:  disk 0, wo:1, o:1, dev:nbd0
Dec 22 08:15:53 turnip kernel:  disk 1, wo:0, o:1, dev:sda
Dec 22 08:15:53 turnip kernel: md: recovery of RAID array md11
Dec 22 08:15:53 turnip kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Dec 22 08:15:53 turnip kernel: md: using maximum available idle IO
bandwidth (but not more than 5120 KB/sec) for recovery.
Dec 22 08:15:53 turnip kernel: md: using 128k window, over a total of
78123988 blocks.

And this is what things look like 20 minutes into the reconstruction/rebuild:

turnip:~ # mdadm --examine-bitmap /dev/sda
        Filename : /dev/sda
           Magic : 6d746962
         Version : 4
            UUID : cf24d099:9e174a79:2a2f6797:dcff1420
          Events : 15928
  Events Cleared : 5494
           State : OK
       Chunksize : 4 MB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123988 (74.50 GiB 80.00 GB)
          Bitmap : 19074 bits (chunks), 2065 dirty (10.8%)
turnip:~ # mdadm --examine-bitmap /dev/nbd0
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : cf24d099:9e174a79:2a2f6797:dcff1420
          Events : 5518
  Events Cleared : 5494
           State : OK
       Chunksize : 4 MB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123988 (74.50 GiB 80.00 GB)
          Bitmap : 19074 bits (chunks), 0 dirty (0.0%)
turnip:~ #

and finally some --detail:


/dev/md11:
        Version : 1.00
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
     Array Size : 78123988 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (149.01 GiB 160.00 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Dec 22 08:24:25 2008
          State : active, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Rebuild Status : 8% complete

           Name : turnip:11  (local to host turnip)
           UUID : cf24d099:9e174a79:2a2f6797:dcff1420
         Events : 15928

    Number   Major   Minor   RaidDevice State
       2      43        0        0      writemostly spare rebuilding   /dev/nbd0
       3       8        0        1      active sync   /dev/sda

--
Jon
