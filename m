From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2 drives failed, one "active", one with wrong event count
Date: Fri, 29 Jan 2010 13:27:39 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001291326430.15329@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se> <alpine.DEB.1.10.1001290502140.15329@uplift.swm.pp.se> <20100129211719.04595761@notabene> <alpine.DEB.1.10.1001291306170.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1001291306170.15329@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 29 Jan 2010, Mikael Abrahamsson wrote:

> On Fri, 29 Jan 2010, Neil Brown wrote:
>
>> 1/ I think you are hitting and mdadm bug in "--assemble --force" that was
>>   fixed in 2.6.8. (git commit 4e9a6ff778cdc58dc).
>
> Thanks, I'll try to upgrade mdadm.

Yes, that solved the problem. Thanks a bunch!

root@ub:~/mdadm-3.1.1# ./mdadm --assemble /dev/md0
mdadm: /dev/md0 assembled from 5 drives - not enough to start the array 
while not clean - consider --force.
root@ub:~/mdadm-3.1.1# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : inactive sdd[0](S) sdf[7](S) sde[8](S) sdc[4](S) sdb[2](S) sdg[6](S)
       11721086688 blocks super 1.2

unused devices: <none>
root@ub:~/mdadm-3.1.1# ./mdadm --stop /dev/md0
mdadm: stopped /dev/md0
root@ub:~/mdadm-3.1.1# ./mdadm --assemble --force /dev/md0
mdadm: /dev/md0 has been started with 5 drives (out of 6).
root@ub:~/mdadm-3.1.1# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid5 sde[8] sdd[0] sdf[7] sdc[4] sdb[2] sdg[6]
       9767572160 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/5] [UUUU_U]
       [>....................]  recovery =  0.2% (5726592/1953514432) finish=468.1min speed=69341K/sec

unused devices: <none>

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
