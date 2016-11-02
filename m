From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Issue with growing RAID10
Date: Wed, 2 Nov 2016 12:13:39 -0600
Message-ID: <CAANLjFpMQNXo6D2=Mfqx-OOGA1+UZvfcz7WK0FPXUs6bGfkHew@mail.gmail.com>
References: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com>
 <581A2BD4.3070109@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <581A2BD4.3070109@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Grow on RAID10 does work. Here is my previous attempt at trying to
change --raid-devices and -p separately.
# mdadm --detail /dev/md13
/dev/md13:
       Version : 1.2
 Creation Time : Wed Nov  2 11:25:22 2016
    Raid Level : raid10
    Array Size : 10477568 (9.99 GiB 10.73 GB)
 Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
  Raid Devices : 2
 Total Devices : 2
   Persistence : Superblock is persistent

   Update Time : Wed Nov  2 11:25:22 2016
         State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
 Spare Devices : 0

        Layout : near=2
    Chunk Size : 512K

          Name : rleblanc-pc:13  (local to host rleblanc-pc)
          UUID : 278c5e33:5ac1d25a:241a0cf7:66269542
        Events : 0

   Number   Major   Minor   RaidDevice State
      0       7        2        0      active sync set-A   /dev/loop2
      1       7        3        1      active sync set-B   /dev/loop3

# mdadm /dev/md13 -a /dev/loop4
mdadm: added /dev/loop4

root@rleblanc-pc:/home/rleblanc/Downloads# mdadm --detail /dev/md13
/dev/md13:
       Version : 1.2
 Creation Time : Wed Nov  2 11:25:22 2016
    Raid Level : raid10
    Array Size : 10477568 (9.99 GiB 10.73 GB)
 Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
  Raid Devices : 2
 Total Devices : 3
   Persistence : Superblock is persistent

   Update Time : Wed Nov  2 11:27:33 2016
         State : clean
Active Devices : 2
Working Devices : 3
Failed Devices : 0
 Spare Devices : 1

        Layout : near=2
    Chunk Size : 512K

          Name : rleblanc-pc:13  (local to host rleblanc-pc)
          UUID : 278c5e33:5ac1d25a:241a0cf7:66269542
        Events : 1

   Number   Major   Minor   RaidDevice State
      0       7        2        0      active sync set-A   /dev/loop2
      1       7        3        1      active sync set-B   /dev/loop3

      2       7        4        -      spare   /dev/loop4

# mdadm --grow /dev/md13 --raid-devices 3

# mdadm --detail /dev/md13
/dev/md13:
       Version : 1.2
 Creation Time : Wed Nov  2 11:25:22 2016
    Raid Level : raid10
    Array Size : 10477568 (9.99 GiB 10.73 GB)
 Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
  Raid Devices : 3
 Total Devices : 3
   Persistence : Superblock is persistent

   Update Time : Wed Nov  2 11:28:08 2016
         State : clean, reshaping
Active Devices : 3
Working Devices : 3
Failed Devices : 0
 Spare Devices : 0

        Layout : near=2
    Chunk Size : 512K

Reshape Status : 1% complete
 Delta Devices : 1, (2->3)

          Name : rleblanc-pc:13  (local to host rleblanc-pc)
          UUID : 278c5e33:5ac1d25a:241a0cf7:66269542
        Events : 12

   Number   Major   Minor   RaidDevice State
      0       7        2        0      active sync   /dev/loop2
      1       7        3        1      active sync   /dev/loop3
      2       7        4        2      active sync   /dev/loop4

----Wait for reshape to finish----
# mdadm --detail /dev/md13
/dev/md13:
       Version : 1.2
 Creation Time : Wed Nov  2 11:25:22 2016
    Raid Level : raid10
    Array Size : 15716352 (14.99 GiB 16.09 GB)
 Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
  Raid Devices : 3
 Total Devices : 3
   Persistence : Superblock is persistent

   Update Time : Wed Nov  2 11:33:25 2016
         State : clean
Active Devices : 3
Working Devices : 3
Failed Devices : 0
 Spare Devices : 0

        Layout : near=2
    Chunk Size : 512K

          Name : rleblanc-pc:13  (local to host rleblanc-pc)
          UUID : 278c5e33:5ac1d25a:241a0cf7:66269542
        Events : 49

   Number   Major   Minor   RaidDevice State
      0       7        2        0      active sync   /dev/loop2
      1       7        3        1      active sync   /dev/loop3
      2       7        4        2      active sync   /dev/loop4

# mdadm --grow /dev/md13 -p n3
mdadm: Cannot change number of copies when reshaping RAID10
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, Nov 2, 2016 at 12:09 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 02/11/16 17:59, Robert LeBlanc wrote:
>> We would like to add read performance to our RAID10 volume by adding
>> another drive (we don't care about space), so I did the following test
>> with poor results.
>
> Quicky reply ...
>
> I don't think you can change the number of raid-devices on a raid10. Are
> you trying to replace a slow drive with a faster one? You can probably
> use the --replace option.
>
> If not that, what do you want to achieve?
>
> Cheers,
> Wol
>
