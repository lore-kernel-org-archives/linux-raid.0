From: Khurram Hassan <kfhassan@gmail.com>
Subject: Problem recovering failed Intel Rapid Storage raid5 volume
Date: Sat, 21 Jul 2012 21:00:19 +0500
Message-ID: <CAHijsZvPb5PZLmKxUwV4iZ-UOUfpGP_Hf9afaWdX34iO86EHKw@mail.gmail.com>
References: <CAHijsZt-CZ4BhjLU2sdWaGRtDa6bXjz0Bx+RRqoGRzvD6N6yvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHijsZt-CZ4BhjLU2sdWaGRtDa6bXjz0Bx+RRqoGRzvD6N6yvA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have this 3 disk raid5 volumne on an Asus motherboard sporting an
Intel Rapid Storage chipset. The problem began when I noticed in
windows that one of the hard disks (the first one in the array) was
marked as failed in the Intel raid utility. I shutdown the system to
remove the hard disk and removed the cables for the faulty hard disk.
But I made a mistake and remove the cables for one of the working hard
disks. So when I booted, it showed the raid volume as failed. I
quickly shutdown the system and corrected the mistake. But it
completely hosed my raid volume. When I booted the system up again,
both of the remaining 2 hard disks were showed as offline.

I read the raid recovery section in the wiki and installed ubuntu
12.04 on a separate non-raid hard disk (after completely disconnecting
the offline raid5 volume). Then I reconnected the 2 hard disks and
booted ubuntu. Then I gave the following commands:

1) mdadm --examine /dev/sd[bc] > raid.status
2) mdadm --create --assume-clean -c 128 --level=5 --raid-devices=3
/dev/md1 missing /dev/sdb /dev/sdc

It gave the following output:
    mdadm: /dev/sdb appears to be part of a raid array:
        level=container devices=0 ctime=Thu Jan  1 05:00:00 1970
    mdadm: /dev/sdc appears to be part of a raid array:
        level=container devices=0 ctime=Thu Jan  1 05:00:00 1970
    Continue creating array? y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.

But the raid volume is not accessible. mdadm --examine /dev/md1 gives:

    mdadm: No md superblock detected on /dev/md1.

Worse, upon booting the system, the raid chipset message says the 2
hard disk are non-raid hard disks. Have I completely messed up the
raid volume? Is it not recoverable at all?

Thanks.
