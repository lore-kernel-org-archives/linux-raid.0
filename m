From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Fri, 5 Dec 2008 20:46:29 -0600
Message-ID: <cccedfc60812051846l3352a5f3medc9e921e29c7434@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

More info:

according to /dev/mdstat (and /var/log/messages) the rebuild is complete:

md10 : active raid1 sda[0] nbd0[1]
      78123968 blocks [2/2] [UU]
      bitmap: 0/150 pages [0KB], 256KB chunk

and --detail:

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

    Update Time : Fri Dec  5 20:40:32 2008
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 542a0986:dd465da6:b224af07:ed28e4e5
         Events : 0.554

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1      43        0        1      active sync   /dev/nbd0



however, --examine-bitmap disagrees:

        Filename : /dev/sda
           Magic : 6d746962
         Version : 4
            UUID : 542a0986:dd465da6:b224af07:ed28e4e5
          Events : 554
  Events Cleared : 554
           State : OK
       Chunksize : 256 KB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123968 (74.50 GiB 80.00 GB)
          Bitmap : 305172 bits (chunks), 274452 dirty (89.9%)

The bitmap numbers *DID NOT CHANGE* throughout the entire rebuild
process, and when it was complete, changed to what you see above. The
rebuild completed a few minutes prior to the --examine-bitmap.

Something is very funky.

If I --grow --bitmap=none, --grow --bitmap=internal then things look
OK after maybe 10-15 seconds.

Of course, when this is complete the --fail --remove and --re-add work
as expected on /dev/sda.



-- 
Jon
