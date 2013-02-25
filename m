From: szlin <lin.sunze@gmail.com>
Subject: Re-sync in RAID 1 with bitmap setting issue
Date: Mon, 25 Feb 2013 16:50:31 +0800
Message-ID: <CAFk6z8Nw7VWKGMFcmORq2sOvwfJmOhyCni5v9V_rxmupkDJf8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In order to increase the re-sync speed, I used a external bitmap to
reduce RAID 1 re-sync time.
But *sometimes* I still got a long re-sync time after RAID 1 is assembled.

My test step.
    1. Build up RAID 1 with external bitmap
    2. Access data
    3. * Hard power off *
    4. Boot up system and check RAID1 status

Most of the time, the bitmap information is normal and re-sync time is
very short.
            Filename : /etc/mdadm/bitmap.bin
            Magic : 6d746962
            Version : 4
            UUID : fb1fbcce:6fcce698:0df00c38:
4aa8fa4e
            Events : 1678
            Events Cleared : 1678
            State : OK
            Chunksize : 64 MB
            Daemon : 5s flush period
            Write Mode : Normal
            Sync Size : 97620160 (93.10 GiB 99.96 GB)
            Bitmap : 1490 bits (chunks), 1 dirty (0.1%)

But when I got a long long re-sync time, it seems like almost all bits
in bitmap are dirty and I cannot understand what cause this weird
situation.
            Filename : /etc/mdadm/bitmap.bin
            Magic : 6d746962
            Version : 4
            UUID : fb1fbcce:6fcce698:0df00c38:4aa8fa4e
            Events : 1684
            Events Cleared : 1678
            State : OK
            Chunksize : 64 MB
            Daemon : 5s flush period
            Write Mode : Normal
            Sync Size : 97620160 (93.10 GiB 99.96 GB)
            Bitmap : 1490 bits (chunks), 1475 dirty (99.0%)


Here is my test environment.
Linux kernel:      2.6.31.8
MDADM version: v3.2.5

Any suggestions on what I can do to stop this issue (adjust chunksize
or flush period)?
Thanks for any advices!
