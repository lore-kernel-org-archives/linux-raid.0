From: Flynn <flynn@kodachi.com>
Subject: RAID6 Reshape (one more time)
Date: Thu, 09 Aug 2012 00:58:03 -0400
Message-ID: <71AEA6EFEB86AE9F3D4990D4@ryoohko.kodachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(One more time, edited for brevity (hah!), hoping to catch the weekday 
crowd before I try things that'll be destructive...)

Something like four years I created a 4-drive RAID5 on CentOS 5.2. That was 
current at the time, and I was still at an RHEL shop, so it seemed sane.

I had 500GB drives, which I knew I'd want to upgrade, but mdadm explicitly 
said it couldn't do reshapes of RAID5 or RAID6 at the time, so I used a 
hack with LVM + md + multiple partitions instead.  I have ten partitions (5 
- 14), so I had e.g.

md5: RAID5 (sda5, sdb5, sdc5, sdd5 )
md6: RAID5 (sda6, sdb6, sdc6, sdd6 )
etc.

and LVM concatenates 'em all.  Works fine for my use, which is basically 
backups of other stuff (few writes, many reads), and when the time came I 
could use LVM to move data off md5, disassemble the md5 RAID, reassemble it 
with the new disk, etc.

This worked great for four years, including going from 4x500GB RAID5 -> 
4x1500GB RAID5 -> 5x1500GB RAID6. As such, please, let's skip the 
discussions about how crazy an idea it is, and move on. It is a crazy idea, 
but it had a purpose, and it actually filled that purpose pretty well. [ :) 
]

Fast forward to last week. Still running on CentOS 5.2 (I'm a big fan of 
sysadmin by not messing with running systems). But I wanted to add a drive 
to the RAID. Not only is CentOS 5.2 rather long in the tooth, at 5x1500GB 
that LVM trick is awfully slow (it would've taken several weeks). So I 
upgraded to Ubuntu 12.04 LTS, to get a better mdadm.

All was well, briefly.

Adding the drive with the 10-partition setup means issuing 10 mdadm --grow 
commands, and I screwed up a step in the script that did it.  Rather than 
do one grow, wait for it to finish, do the next, etc., it skipped the 
'wait' steps and just issued all 10 grow commands.  I ended up with all ten 
partitions grown to 6 drives, and all but one of them marked "pending 
reshape".  The one remaining was rebuilding.

A little while later, the machine crashed.  [ :P ]  On reboot, the reshape 
that had been underway at the time (partition 7) picked up and carried on 
just fine.  But partition 8 didn't. Nor anything after.

So at this point I have partitions 5, 6, and 7 happy; 8 - 14 are marked 
inactive.  The initial mdadm --grow reported that it passed the critical 
section long before the machine crashed, for all partitions.  mdadm 
--examine on the individual drives shows that each of these partitions 
believes that they are part of a RAID6 with 6 drives, correct checksums 
everywhere, event counters the same, but:

1)  Trying e.g.

    sudo mdadm --assemble --force /dev/md8 /dev/sd[bdefgh]8

says

mdadm: Failed to restore critical section for reshape, sorry.
      Possibly you needed to specify the --backup-file

Given that I didn't specify --backup-file to the initial mdadm --grow, this 
seems... perhaps not entirely helpful.

2)  In a working partition, I always see the 'this' entry in mdadm 
--examine's output matching up with the drive being read (e.g. /dev/sde5 
will say 'this' is /dev/sde5).  In a _non_-working partition, that's not 
the case (e.g. /dev/sdb7 says 'this' is /dev/sdg7).

3)  Finally, all the working partitions show that their superblocks are 
version 0.90.00, but all the non-working partitions show 0.91.00.

Suggestions welcome.  [ ;) ]  In theory there's no data that I can't 
replace on these arrays (it's a backup, after all) but it'd be nice to not 
have to make that particular experiment...

Thanks!

 -- Flynn

--
Whatever happens will happen, and we'll just happen along with it.
                             (From a sketch on _A Prairie Home Companion_)

