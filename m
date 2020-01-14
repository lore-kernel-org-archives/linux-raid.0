From: William Morgan <therealbrewer@gmail.com>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Tue, 14 Jan 2020 08:47:56 -0600
Message-ID: <CALc6PW7hwT9VDNyA8wfMzjMoUFmrFV5z=Ve+qvR-P7CPstegvw@mail.gmail.com>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk> <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
 <5E17D999.5010309@youngman.org.uk> <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I went ahead and tried the forced assembly:

bill@bill-desk:~$ sudo mdadm --assemble --force /dev/md1 /dev/sdg1
/dev/sdh1 /dev/sdi1
[sudo] password for bill:
mdadm: Merging with already-assembled /dev/md/1
mdadm: Marking array /dev/md/1 as 'clean'
mdadm: failed to RUN_ARRAY /dev/md/1: Input/output error

(The drive letters have changed because I removed a bunch of other
drives. The original drives are now on sd[b,c,d,e] and the copies are
on sd[f,g,h,i] with sdf being a copy of the presumably bad sdb with
the event count which doesn't agree with the other 3 disks.)

So, it failed. dmesg shows:

152144.483755] md: array md1 already has disks!
[152144.483772] md: kicking non-fresh sdb1 from array!
[152144.520313] md/raid:md1: not clean -- starting background reconstruction
[152144.520345] md/raid:md1: device sdd1 operational as raid disk 2
[152144.520346] md/raid:md1: device sde1 operational as raid disk 1
[152144.520348] md/raid:md1: device sdc1 operational as raid disk 3
[152144.522219] md/raid:md1: cannot start dirty degraded array.
[152144.566782] md/raid:md1: failed to run raid set.
[152144.566785] md: pers->run() failed ...
[152144.568169] md1: ADD_NEW_DISK not supported
[152144.569894] md1: ADD_NEW_DISK not supported
[152144.571498] md1: ADD_NEW_DISK not supported
[152144.573964] md1: ADD_NEW_DISK not supported

mdstat shows sdb no longer part of the array:

bill@bill-desk:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : inactive sdd1[2] sde1[1] sdc1[4]
      11720653824 blocks super 1.2

details of the array:

ill@bill-desk:~$ sudo mdadm -D /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Tue Sep 25 23:31:31 2018
        Raid Level : raid5
     Used Dev Size : 18446744073709551615
      Raid Devices : 4
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Sat Jan  4 16:52:59 2020
             State : active, FAILED, Not Started
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 64K

Consistency Policy : unknown

              Name : bill-desk:1  (local to host bill-desk)
              UUID : 723f939b:62b73a3e:e86e1fe1:e37131dc
            Events : 38643

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       -       0        0        1      removed
       -       0        0        2      removed
       -       0        0        3      removed

       -       8       65        1      sync   /dev/sde1
       -       8       49        2      sync   /dev/sdd1
       -       8       33        3      sync   /dev/sdc1

Now if I try the forced assemble again I get:

ill@bill-desk:~$ sudo mdadm --assemble --force /dev/md1 /dev/sdg1
/dev/sdh1 /dev/sdi1
mdadm: Found some drive for an array that is already active: /dev/md/1
mdadm: giving up.

I'm lost now. Not sure what to do anymore. Do I need to edit
mdadm.conf? Do I need to remove the original drives? Any ideas Wols?

Bill
