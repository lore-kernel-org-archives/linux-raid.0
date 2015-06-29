From: Nate Clark <nate@neworld.us>
Subject: I/O error reading from raid 1 device but not slave devices
Date: Mon, 29 Jun 2015 17:35:29 -0400
Message-ID: <CAG2YfWMfwtNkLGoswsZVSxpTm+BxdQD8e1ZB+Mc2+PxWrWSAYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have encountered a strange error while reading from a raid 1 device.
If I read from the md device I encounter an I/O error, however if I
read from the underlying devices there is no issue.

-bash-4.3# dd if=3D/dev/md5 of=3D/dev/null bs=3D256K
dd: error reading =E2=80=98/dev/md5=E2=80=99: Input/output error
1007+1 records in
1007+1 records out
264134656 bytes (264 MB) copied, 1.86707 s, 141 MB/s

-bash-4.3# mdadm --detail -v /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Mon Jun 29 22:34:37 2015
     Raid Level : raid1
     Array Size : 5238784 (5.00 GiB 5.36 GB)
  Used Dev Size : 5238784 (5.00 GiB 5.36 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Tue Jun 30 05:05:43 2015
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : (none):5
           UUID : 8933a60c:c34da7e7:f47bebfb:8b0ba6f6
         Events : 864

    Number   Major   Minor   RaidDevice State
       2       8       21        0      active sync   /dev/sdb5
       1       8        5        1      active sync   /dev/sda5


-bash-4.3# dd if=3D/dev/sda5 of=3D/dev/null bs=3D256K
20480+0 records in
20480+0 records out
5368709120 bytes (5.4 GB) copied, 41.991 s, 128 MB/s

-bash-4.3# dd if=3D/dev/sdb5 of=3D/dev/null bs=3D256K
20480+0 records in
20480+0 records out
5368709120 bytes (5.4 GB) copied, 30.2417 s, 178 MB/s

I did perform a raid resync which completed successfully:
[20814.187596] md: requested-resync of RAID array md5
[20814.187602] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[20814.187605] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for requested-resync.
[20814.187612] md: using 128k window, over a total of 5238784k.
[20873.631782] md: md5: requested-resync done.

The only errors I can find in dmesg that seem to correlate to this are:
[22336.558454] Buffer I/O error on dev md5, logical block 64486, async =
page read

This system is running Fedora's 4.0.5-300 kernel with Neil's patch
"md: clear mddev->private when it has been freed."

I have not tried to reboot the system to see if that fixes the issue
since I didn't know how useful it would be for me to keep it in this
state if I can help with debugging. Another systems running the same
kernel with similar configuration does not seem to have any issue.
Also, the system with the issue only has it on one md device, which
happens to be /, but the other 7 raids work fine. This issue to be
some what rather rare.

Sorry, this email doesn't have too much useful data but I was not sure
what information was needed. Let me know if there is anything I can do
to provide more or better information.

Thanks,
-nate
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
