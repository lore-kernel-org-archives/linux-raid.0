From: Cooper tron <cooper@cobhc.ca>
Subject: raid 6 4 disk failure, improper --create leads to bad superblock
Date: Sat, 28 Dec 2013 18:02:16 -0500
Message-ID: <CAG9GHm3_UNO_jZguFtGpMwMs=a3ut2FXjNWfFV9MU1nC-YJYWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you could please CC me directly. TIA

I have a raid that I've recently realized is ridden with flaws. Id
like to be able to mount it one last time to get a current backup of
user generated data. Then rebuild it with proper hardware.

Currently it is assembled with 10 drives, but unable to mount, or do
anything to the filesystem.

10x 1tb WD green raid6 (flaw 1)

(current --detail, after second rebuild with 64k chunk)
sudo mdadm --detail /dev/md0
/dev/md0:
Version : 1.2
Creation Time : Sat Dec 28 00:06:35 2013 Raid Level : raid6
>Array Size : 7813051904 (7451.11 GiB 8000.57 GB)
>Used Dev Size : 976631488 (931.39 GiB 1000.07 GB)
Raid Devices : 10
Total Devices : 10
Persistence : Superblock is persistent

Intent Bitmap : Internal

Update Time : Sat Dec 28 11:28:25 2013
      State : active
Active Devices : 10
Working Devices : 10
Failed Devices : 0
Spare Devices : 0

Layout : left-symmetric
Chunk Size : 64K

Name : ununtrium:0  (local to host ununtrium)
UUID : c02f6105:1cb6bfd7:d67208f0:fd49519a
Events : 5917

Number   Major   Minor   RaidDevice State
0       8        0        0      active sync   /dev/sda
1       8       16        1      active sync /dev/sdb
2       8       32        2      active sync   /dev/sdc
3       8       48        3      active sync  /dev/sdd
4       8       96        4      active sync  /dev/sdg
5       8      128       5     active sync  /dev/sdi
6       8      144       6     active sync  /dev/sdj
7       8      160       7     active sync /dev/sdk
8       8      192       8    active sync /dev/sdm
9       8      208       9   active sync   /dev/sdn

I recently added 1 more drive going from 9-10. Here is where things
get murky. We just had a killer ice storm, brownouts and power issues
for days. Right as I was growing. So one drive (sde, at the time)
failed during the grow. While investigating I was forced to shut down
due to my ups screaming at me. Once power is back, I boot up and
theres a second drive marked faulty (don't recall which). Smartctl
told me both drives were OK. So I readded them, as they were resyncing
2 more got marked faulty....  There I sat with 4 drives out of the
array (when I should have came for help). No amount of --assemble
would start the array. I did not try any --force. All the drives
tested as being relatively healthy so I took a chance.

I finally got the array to start with --create --raid-devices=10 /dev/sda (etc.)

Once it was done, bad superblock when trying to fsck or mount,
alternate 8193 doesn't help.  I noticed the chunk size was now 512
where mine had always been 64. There are also a few lines under
--examine that I've never seen on my raid before.(@@)

(current examine of the first disk)
sudo mdadm -E /dev/sda
/dev/sda:
 Magic : a92b4efc
Version : 1.2
@@   Feature Map : 0x1
Array UUID : c02f6105:1cb6bfd7:d67208f0:fd49519a   Name : ununtrium:0
(local to host ununtrium)
Creation Time : Sat Dec 28 00:06:35 2013
Raid Level : raid6
Raid Devices : 10

>Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>Array Size : 7813051904 (7451.11 GiB 8000.57 GB)
>Used Dev Size : 1953262976 (931.39 GiB 1000.07 GB)
@@    Data Offset : 262144 sectors
@@   Super Offset : 8 sectors
@@  Unused Space : before=262056 sectors, after=48 sectors
State : active
Device UUID : dea95ce1:099d13a1:17daf1c0:b2f2e2d0

Internal Bitmap : 8 sectors from superblock
Update Time : Sat Dec 28 11:28:25 2013
@@Bad Block Log : 512 entries available at offset 72 sectors
Checksum : 973a6ccf - correct
Events : 5917
Layout : left-symmetric
Chunk Size : 64K
Device Role : Active device 0
Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

I'm also sure my metadata at some point was 0.90. Does it get upgraded
during rebuilds/resyncs or does that have to be specified (did it only
upgrade to 1.2 now during the create??)

I found almost an exact case scenario from some emails, where it was
suggested to --create again with the proper permutations and the raid
should rebuild with hopefully some data intact.  So I tried again this
time just specifying a 64K chunk. After an 11 hour resync. I still
have a bad superblock when trying to mount/fsck.

Without any records of the order of failures, or even an old --examine
or --detail to show me how the raid was shaped when it was running or
its last 'sane' state. Is there any chance I will see that data again?

Happy Holidays!
