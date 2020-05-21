From: David T-G <davidtg-robot@justpickone.org>
Subject: Re: failed disks, mapper, and "Invalid argument"
Date: Thu, 21 May 2020 07:24:21 -0400
Message-ID: <20200521112421.GK1415@justpickone.org>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk>
 <20200520235347.GF1415@justpickone.org>
 <5EC63745.1080602@youngman.org.uk>
 <20200521110139.GW1711@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200521110139.GW1711@justpickone.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wol, et al --

...and then davidtg-robot@justpickone.org said...
% 
% ...and then Wols Lists said...
% % 
...
% % What I don't want to advise, but I strongly suspect will work, is to
% % force-assemble the two good drives and the nearly-good drive. Because it
% % has no redundancy it won't scramble your data because it can't do a
% 
% Should I, then, get rid of the mapper overlay stuff?  I tried pointing to
% even just three devs and got that they're busy.
[snip]

I was thinking of this last night but hesitant, so I went ahead and tried
it this morning.  Perhaps my overlay and mapper config was all broken,
because this apparently worked out.  Yay, part one.

  diskfarm:root:13:/mnt/scratch/disks> parallel 'dmsetup remove {/}; rm overlay-{/}' ::: $DEVICES 

  diskfarm:root:13:/mnt/scratch/disks> parallel losetup -d ::: /dev/loop1[01234]
  losetup: /dev/loop11: detach failed: No such device or address
  losetup: /dev/loop12: detach failed: No such device or address
  losetup: /dev/loop13: detach failed: No such device or address
  losetup: /dev/loop14: detach failed: No such device or address

This was odd...  Yes, I know I listed too many, but I couldn't remember
whether or not I started counting at zero.

  diskfarm:root:14:~> ls -goh /dev/loop1?
  brw-rw---- 1 7, 11 May 21 07:15 /dev/loop11                                                                                     
  brw-rw---- 1 7, 12 May 21 07:15 /dev/loop12
  brw-rw---- 1 7, 13 May 21 07:15 /dev/loop13                                                                                     
  brw-rw---- 1 7, 14 May 21 07:15 /dev/loop14

  diskfarm:root:13:/mnt/scratch/disks> parallel losetup -d ::: /dev/loop1[1234]                                                   
  losetup: /dev/loop11: detach failed: No such device or address
  losetup: /dev/loop12: detach failed: No such device or address                                                                  
  losetup: /dev/loop13: detach failed: No such device or address
  losetup: /dev/loop14: detach failed: No such device or address                                                                  

Even listing only the actual devices didn't seem to help much.  Huh?
Never mind; let's move on.

  diskfarm:root:13:/mnt/scratch/disks> dmsetup status
  No devices found                                                                                                                

  diskfarm:root:13:/mnt/scratch/disks> mdadm --assemble --force /dev/md0 --verbose /dev/sda1 /dev/sdb1 /dev/sdc1
  mdadm: looking for devices for /dev/md0                                                                                         
  mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 3.
  mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.                                                                 
  mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
  mdadm: forcing event count in /dev/sdc1(2) from 57836 upto 57840                                                                
  mdadm: clearing FAULTY flag for device 2 in /dev/md0 for /dev/sdc1
  mdadm: Marking array /dev/md0 as 'clean'                                                                                        
  mdadm: no uptodate device for slot 1 of /dev/md0
  mdadm: added /dev/sdc1 to /dev/md0 as 2                                                                                         
  mdadm: added /dev/sda1 to /dev/md0 as 3
  mdadm: added /dev/sdb1 to /dev/md0 as 0                                                                                         
  mdadm: /dev/md0 has been started with 3 drives (out of 4).

  diskfarm:root:13:/mnt/scratch/disks> cat /proc/mdstat                                                                           
  Personalities : [raid6] [raid5] [raid4] 
  md0 : active (auto-read-only) raid5 sdb1[0] sda1[4] sdc1[3]
        11720265216 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U_UU]
        
  md127 : active raid5 sdf2[0] sdg2[1] sdh2[3]
        1464622080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
        
  unused devices: <none>

This looks good!  No protection, but it functions.

  diskfarm:root:13:/mnt/scratch/disks> mount /mnt/4Traid5md
  diskfarm:root:13:/mnt/scratch/disks> df -kh !$
  df -kh /mnt/4Traid5md
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md0p1       11T   11T  3.7G 100% /mnt/4Traid5md

Sure enough, there it is.  Yay.

Now ...  What do I do with the last drive?  Can I put it back in and let
it catch up, or should it reinitialize and build from scratch?


Thanks again & HANd

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt
