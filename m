From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: raid1 + bitmaps, but the bitmap isn't being used?
Date: Sun, 14 Dec 2008 20:14:36 -0600
Message-ID: <cccedfc60812141814i4454dc97o524730a4ba780d70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm having some trouble with a raid1 I've been testing with.
I'm using an internal bitmap and 2 devices. One of the devices gets
removed and (via --incremental) re-added to the array with some
frequency. Until today, this has worked perfectly.

Today, I rebooted the server (the machine with the device that is
normally *non-transient*), and when it came back up, md started a
recovery on the entire array.

At various percentiles of the recovery, I've --fail ed, --remove d,
and --re-add ed (with and without --incremental), and every time md
starts completely over. Why does it appear to me as though md is
ignoring the bitmap?

This appears related to my earlier posting where the bitmap appears to
be unused *during* rebuild (recovery) or initial sync, and
--examine-bitmap disagrees with /proc/mdstat about the state of
things.

I'm using openSUSE 11.0's kernel for x86_64, 2.6.25.18-0.2-default,
and mdadm 2.6.4.
This is what --examine-bitmap looks like for both devices:


turnip:/sys/block/md10/md # mdadm --examine-bitmap /dev/nbd0
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : 542a0986:dd465da6:b224af07:ed28e4e5
          Events : 11646
  Events Cleared : 11646
           State : OK
       Chunksize : 256 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 78123968 (74.50 GiB 80.00 GB)
          Bitmap : 305172 bits (chunks), 0 dirty (0.0%)
turnip:/sys/block/md10/md # mdadm --examine-bitmap /dev/sda
        Filename : /dev/sda
           Magic : 6d746962
         Version : 4
            UUID : 542a0986:dd465da6:b224af07:ed28e4e5
          Events : 11770
  Events Cleared : 0
           State : OK
       Chunksize : 256 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 78123968 (74.50 GiB 80.00 GB)
          Bitmap : 305172 bits (chunks), 0 dirty (0.0%)
turnip:/sys/block/md10/md #


-- 
Jon
