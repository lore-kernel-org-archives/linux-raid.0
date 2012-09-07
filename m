From: clplayer <cl.player@gmail.com>
Subject: Content Of Files May Be Changed After One Disk Is Failed In RAID5
Date: Fri, 7 Sep 2012 10:04:09 +0800
Message-ID: <CAOHz194A8onv1q5nAFfy3cmma0=nWnQF9GmiOeFr86jOxnGgFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>, djbw@fb.com
List-Id: linux-raid.ids

Hi,

I am stressing the RAID5 functions on my desktop.

I installed 8 hard disks which 4 were on the internal SATA ports and
the others were connected via eSATA.

The operating system on the desktop is Ubuntu 12.04.1 LTS 64-bit.

I have made a script to check the files in the raid while there are
disks becoming failed.

The actions are as below:

1. creating an 8-disk raid, one of the 8 disks is set as the spare.
2. making a ext4 file system on the raid and mounting that raid.
3. generating a file from /dev/urandom in the root file system, and
the size of the file is 1GB.
4. calculating the checksum of the file by the command "cksum."
5. making 10 duplicates of the file and store in the raid, and then
calculating the checksums of each duplicate.
6. setting one of the disks in the raid to be failed after the 10
duplicates are stored and checked.
7. parallelly calculating the checksums of the duplicates again immediately.

Curiously, there are usually several files changed and the checksums
are not consistent.

Then I tried the same senario with the 8-disk reaid with no spare, and
the results is the same.

I have also tried with RAID1 and RAID6, and the checksums are
consistent with the two algorithms.

It looks like there are something wrong within the raid5 functions. I
am tracing the file raid5.c but I can not figure out the

root cause yet.

Would someone please suggest any tips or solutions? Thank you very much.

My script is attached below:

#!/bin/sh

TESTSEQ="0 1 2 3 4 5 6 7 8 9"

mdadm --create /dev/md0 --level=raid5 --raid-devices=7
--spare-devices=1 /dev/sd[a-h]3 --assume-clean -z 10485760 -f -R

mkfs.ext4 /dev/md0

mount /dev/md0 /mnt

#duplicating the source file and calculating the checksum
for ITEM in $TESTSEQ
do
        echo "copying 1Gr.${ITEM}..."
        cp /1Gr /mnt/1Gr.${ITEM}

        cksum /mnt/1Gr.${ITEM} >> /tmp/cksum_org.${ITEM}
        cat /tmp/cksum_org.${ITEM} | while read tmpline
        do
                orgcksum=${tmpline%% *}
                echo "checksum is ${orgcksum}"
        done
done

sync

sleep 10

mdadm -f /dev/md0 /dev/sdb3

echo "producing checksum..."
for ITEM in $TESTSEQ
do
        cksum /md0/1Gr.${ITEM} > /tmp/cksum_out.${ITEM} &
done

#wait for the 10 cksum process being done
sleep 120

echo "checking the result..."
for ITEM in $TESTSEQ
do
        cat /tmp/cksum_out.${ITEM} | while read line
        do
                item=${line%% *}

		#the value 2606882893 was pre-calculated manually
                if [ x"$item" != "x2606882893" ]
                then
                        echo "get wrong cksum on ${ITEM}"
                else
                        rm /tmp/cksum_out.${ITEM}
                fi
        done
done

Thanks,
Peng.
