From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Forcing raid1 resync
Date: Mon, 16 Aug 2004 12:38:28 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408161638.i7GGcS331755@watkins-home.com>
References: <8075D5C3061B9441944E1373776451186488C0@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8075D5C3061B9441944E1373776451186488C0@cinshrexc03.shermfin.com>
To: "'Rechenberg, Andrew'" <ARechenberg@sfg.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From what I understand...
If the arrays don't share physical disks, that can re-sync at the same time.
Maybe some throttling system is limiting it to just 5 at a time.  Maybe CPU
load?  I don't know if md does things based on how busy the CPU is.  Is your
CPU maxed out?

These are related to throttling:
/proc/sys/dev/raid/speed_limit_max
/proc/sys/dev/raid/speed_limit_min

Do "man md" for more info.

The speed limits are per device, not per array.
Make sure the max is large enough the permit your disks to go as fast as
they can.  I use 100000 (100,000K bytes/second).  My disks are not that
fast, and having too large of a number does not hurt.
At least as a test, set the min to the same value as max.

I use these commands when I want to change by hand:
cat /proc/sys/dev/raid/speed_limit_max
cat /proc/sys/dev/raid/speed_limit_min

echo 100000 > /proc/sys/dev/raid/speed_limit_max
echo 1000 > /proc/sys/dev/raid/speed_limit_min

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Rechenberg, Andrew
Sent: Monday, August 16, 2004 11:24 AM
To: linux-raid@vger.kernel.org
Subject: Forcing raid1 resync

Hello,

Is there anyway to force a resync of RAID1 arrays that need to be
resynced?  I have 26 RAID1 arrays and when the system shuts down
uncleanly, or the machine crashes hard, sometimes I need to hotadd
devices back into the array.  For example if I have the following in
/etc/raidtab:

raiddev /dev/md23
        raid-level              1
        nr-raid-disks           2
        persistent-superblock   1
        chunk-size              64
 
        device                  /dev/sdao1
        raid-disk               0
        device                  /dev/sdbc1
        raid-disk               1

/proc/mdstat for md23 will show:

md23 : active raid1 sdbc1[1]
      17783808 blocks [2/2] [U_]

And I will need to use mdadm or raidhotadd to add /dev/sdao1 back into
the array.  When I add a device back into the array the reconstruction
doesn't start immediately and/or if another reconstruction is underway,
the new recontruction will not occur until the first one has completed.

Is this behavior expected/by design?  Waiting for 26 arrays to
reconstruct one at a time is painfully slow.  When I created the arrays
they all started to sync at the same time so I know the RAID code will
sync more than one at a time, and when my box came up yesterday after a
hard power cycle, about 5 arrays started syncing, but the rest waited
until those were finished and then synced one at a time.

I looked through md.c and raid1.c and I see that hot_add_disk() calls
md_recover_arrays() which wakes up the md recovery thread, but does the
thread only allow one synchronization to occur at a time?

Here are some of my system details:

Red Hat 7.3 with updates
kernel-bigmem-2.4.20-30 with megaraid2 patch

If someone could point me in the direction in the code to understand the
way this process works I would appreciate it.  Let me know if you need
any more information.

Regards,
Andrew Rechenberg
Infrastructure Team, Sherman Financial Group
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

