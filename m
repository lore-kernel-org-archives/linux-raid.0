From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Cancel reshape?
Date: Wed, 12 Jan 2011 04:19:30 +0000
Message-ID: <4D2D2BD2.7000601@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've just started reshaping a RAID-5 to a RAID-6. I had meant to 
increase the number of drives too, so avoiding using the backup file all 
the way through. Unfortunately I forgot to specify that, so it's going 
rather slowly. I said:

mdadm /dev/md1 --grow --level=6 --backup-file=/some/where/else

where md1 had 3 active and 2 spare devices. It's now reshaping itself to 
RAID-6 with 4 active and 1 spare.

What I meant was

mdadm /dev/md1 --grow --level=6 --raid-disks=5 --backup-file=...

Can I cancel reshape that's currently running, and using the backup file 
that's actually on another (RAID-1) array on three of the same drives, 
and running at ~7MB/s, and try again?

Cheers,

John.
