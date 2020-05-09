From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Assemblin journaled array fails
Date: Sat, 9 May 2020 12:54:59 +0200
Message-ID: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Looks like I have now another issue with journaled array that now fails 
to assemble - with related command used to assembly it (whether it would 
be mdadm --incremental called by udev, or manually from commandline) 
hanged and unkillable.

The array was previously running with different journal that was later 
replaced with different better disks. The journal device itself is 
healthy and assembles fine. Assembling (the below dump is when mdadm vis 
udev was doing it):


mdadm -D /dev/md126
/dev/md126:
            Version : 1.1
      Creation Time : Tue Mar  5 19:28:58 2019
         Raid Level : raid5
      Used Dev Size : 18446744073709551615
       Raid Devices : 4
      Total Devices : 5
        Persistence : Superblock is persistent

        Update Time : Sat May  9 09:34:58 2020
              State : active, FAILED, Not Started
     Active Devices : 4
    Working Devices : 5
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : journal

               Name : xs22:r5_big  (local to host xs22)
               UUID : d5995d76:67d7fabd:05392f87:25a91a97
             Events : 56283

     Number   Major   Minor   RaidDevice State
        -       0        0        0      removed
        -       0        0        1      removed
        -       0        0        2      removed
        -       0        0        3      removed

        -       8      145        3      sync   /dev/sdj1
        -       8      129        2      sync   /dev/sdi1
        -       9      127        -      spare   /dev/md/xs22:r1_journal_big
        -       8      113        1      sync   /dev/sdh1
        -       8       97        0      sync   /dev/sdg1



mdadm -Esv:

ARRAY /dev/md/r1_journal_big  level=raid1 metadata=1.1 num-devices=2 
UUID=c18b3996:49b21f49:3ee18e92:a8240f7f name=xs22:r1_journal_big
    devices=/dev/sdv1,/dev/sdu1
ARRAY /dev/md/r5_big  level=raid5 metadata=1.1 num-devices=4 
UUID=d5995d76:67d7fabd:05392f87:25a91a97 name=xs22:r5_big
    spares=1 
devices=/dev/md/xs22:r1_journal_big,/dev/sdg1,/dev/sdh1,/dev/sdj1,/dev/sdi1


When I was changing journal some time ago (successfully, everything was 
working fine afterwards) this is what I did:

echo [write-through] >/sys/md126/md/journal_mode
mdadm /dev/md126 --fail /dev/md/r1_journal_big --remove 
/dev/md/r1_journal_big
echo resync >/sys/md126/md/consistency_policy

# here i created new journal from new disks, the name was the same

mdadm --readonly /dev/md126
mdadm /dev/md126 --add-journal /dev/md/r1_journal_big
echo [write-back] >/sys/md126/md/journal_mode
# At this point mdadm confirmed everything went fine

After the reboot I'm in the situation as outlined above. Any suggestion 
how to assemble this array now ?
