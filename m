From: Jon Nelson <jnelson-suse@jamponi.net>
Subject: help with bad performing raid6
Date: Mon, 27 Jul 2009 14:19:42 -0500
Message-ID: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a raid6 which is exposed via LVM (and parts of which are, in
turn, exposed via NFS) and I'm having some really bad performance
issues, primarily with large files. I'm not sure where the blame lies.
When performance is bad "load" on the server is insanely high even
though it's not doing anything except for the raid6 (it's otherwise
quiescent) and NFS (to typically just one client).

This is a home machine, but it has an AMD Athlon X2 3600+ and 4 fast SATA disks.

When I say "bad performance" I mean writes that vary down to 100KB/s
or less, as reported by rsync. The "average" end-to-end speed for
writing large (500MB to 5GB) files hovers around 3-4MB/s. This is over
100 MBit.

Often times while stracing rsync I will see rsync not make a single
system call for sometimes more than a minute. Sometimes well in excess
of that. If I look at the load on the server the top process is
md0_raid5 (the raid6 process for md0, despite the raid5 in the name).
The load hovers around 8 or 9 at this time.

Even during this period of high load, actual disk I/O is fairly low.
I can get 70-80MB/s out of the actual underlying disks the entire time.
Uncached.

vmstat reports up to 20MB/s writes (this is expected given 100Mbit and
raid6) but most of the time it hovers between 2 and 6 MB/s.

What can I do to improve performance?
Why is the load so high on the server? The client is absolutely bored
(load less than 0.5 most of the time).
Is this some weird interaction between NFS(v3) and software raid6?

My raid6 config:

/dev/md0:
        Version : 1.01
  Creation Time : Mon Feb  9 20:56:40 2009
     Raid Level : raid6
     Array Size : 613409536 (584.99 GiB 628.13 GB)
  Used Dev Size : 306704768 (292.50 GiB 314.07 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Mon Jul 27 14:18:55 2009
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K


-- 
Jon
