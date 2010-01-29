From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2 drives failed, one "active", one with wrong event count
Date: Fri, 29 Jan 2010 05:17:10 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001290502140.15329@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 28 Jan 2010, Mikael Abrahamsson wrote:

> I have a ubuntu 9.04 system with the default mdadm and kernel (2.6.28).

I thought this might be a driver issue, so I tried upgrading to 9.10 which 
contains kernel 2.6.31 and mdadm 2.6.7.1. It seems the sw was unrelated, 
because now during the night three drives were kicked, so I now have 6 
drives, 3 "State: clean", 3 are "State: active", 1 of the "active" ones 
has a different event count. The array shows similar problems, sometimes 
it will assemble will all 6 drives being (S)pares, sometimes it'll 
assemble with 5 drives and shows as "inactive" in /proc/mdstat.

After finding 
<http://www.linuxquestions.org/questions/linux-general-1/raid5-with-mdadm-does-not-ron-or-rebuild-505361/> 
I tried this:

root@ub:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : inactive sdd[0] sdf[7] sdc[4] sdb[2] sdg[6]
       9767572240 blocks super 1.2

unused devices: <none>
root@ub:~# cat /sys/block/md0/md/array_state
inactive
root@ub:~# echo "clean" > /sys/block/md0/md/array_state
-bash: echo: write error: Invalid argument
root@ub:~# cat /sys/block/md0/md/array_state
inactive

Still no go. Anyone who can help me what might be going wrong here, I 
mean, that a drive is stuck in "active" can't be a very weird event 
state?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
