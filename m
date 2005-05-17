From: George Huber <huber_geo@hotmail.com>
Subject: Problems setting up RAID1
Date: Tue, 17 May 2005 13:48:21 -0400
Message-ID: <d6danj$nmr$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

all,

I am having problems setting up RAID 1 using Fedora core 3.  Here are
the steps that I have taken to date.

1) On the first SCSI drive, I installed a clean version of Linux, the
    hard drive is partitioned as follows:
    /dev/sda1              /boot              512 Mbytes
    /dev/sda2              /cvsroot           20 GBytes
    /dev/sda3              /archives          20 GBytes
    /dev/sda4     (extended partition)
    /dev/sda5              /home              10 GBytes
    /dev/sda6              swap                2 GBytes
    /dev/sda7              /                  14 GBytes

2) Downloaded the souce code for 2.6.11-8 recompiled the kernel with
    RAID support included in the kernel, not as modules.

3) Build the partions on the second SCSI drive to match the first.

4) Set the partition types of sd[ab]2, sd[ab]3, sd[ab]5, sd[ab]6 and
    sd[ab]7 to 0xFD (Linux Software Raid Autodetect)

5) rebooted the host, on reboot I had three mirroed partitions:
    /dev/md0 : /dev/sda2 and /dev/sdb2
    /dev/md1 : /dev/sda3 and /dev/sdb3
    /dev/md2 : /dev/sda5 and /dev/sdb5

    Question 1 - why did swap and root fail to become part of the array?

6) using mdadm with the examine flag, I found that neither /dev/sd[ab]6
or
    /dev/sd[ab]7 had raid superblocks on them.  Attempting to build
arrays
    using:
    mdadm --create /dev/md3 --level=1 --raid-devices=2 /dev/sd[ab]6
    failed (sort of expected since swap was mounted).

7) booted with a rescue disk, and did not mount any of my partitions,
    and then executed the following commands:

    mdadm --create /dev/md3 --level=1 --raid-devices=2 /dev/sd[ab]6
    mdadm --create /dev/md4 --level=2 --raid-devices=2 /dev/sd[ab]7

    both of these commands succeeded, and cat-ing /proc/mdstat showed
    to raid arrays that were in the process of synching.

8) I let the two arrays finish synching, and then rebooted the computer

    normally.  I received a `ton' of messages about not being able to
    touch various files in the root file system because the root file
    system is read-only.  After a while I finally did get a shell, and
    I was able cat /proc/mdstat - I saw the expected five arrays,
however
    the array for the root file system only had one drive in it:

    ....
    md4 : active raid sdb7[1]
        11759424 blocks [2/1] [_U]
    ....

    All the other raid arrays had two entries (as expected) as were
readible
    as well as writable.

    On examining dmesg, I fould the following:

    md: Autodetecting RAID arrays
    md: could not bd_claim sda7
    md: autorun...
    md: considering sdb7...
    md:  adding sdb7...

    so it seems that the RAID subsysem is not able to access / control
    my root partition.

    Question 2 - What do I need to do to be able to RAID my root
partition?
    Question 3 - What do I need to do to fix my `read-only' file system
                 problems?
      Questions 2 and 3 are probably related.

    Note: I was able to execute the command:
    mount / -o remount,rw

    to make my root filesystem read-write.

9) Finally, I rebooted into rescue mode without mounting any of my
drives,
    manually mounted /dev/sda7 and copied /etc/mdadm.conf to the floppy
    and then unmounted /dev/sda7.  Next I ran:
    mdadm --assemble --scan --config=/mnt/floppy/mdadmconf
    and all five of my RAID arrays came up, with two members each and
the
    array holding my root file system was writable.

Any suggestiong on what I should try next.

