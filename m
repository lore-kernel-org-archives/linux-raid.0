From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: Re: Re: Re: Re[2]: Bugreport mdadm-2.0-devel-1
Date: Tue, 19 Jul 2005 14:49:10 +0300
Message-ID: <647326015.20050719144910@netvision.net.il>
References: <1684363827.20050706121331@netvision.net.il>
 <17100.29413.164442.415932@cse.unsw.edu.au>
 <1892534227.20050707043013@netvision.net.il>
 <17103.10618.547298.274604@cse.unsw.edu.au>
 <17111.5969.741703.944406@cse.unsw.edu.au>
 <69444850.20050719000811@netvision.net.il>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <69444850.20050719000811@netvision.net.il>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil!
Thanks much for the patch, the array can now be started again.
However, I observe some strange behaviour with raid1 intelligent
resync. I'm not sure if your new patch (md/raid1: clear bitmap when
fullsync completes)
http://marc.theaimsgroup.com/?l=linux-raid&m=112140143401678&w=2
addresses this strangeness, cause I still didn't apply it.

When we create a raid1 array with bitmap it starts a full resync.
Let's wait a couple of minutes, so the resync will proceed to, say,
50%. Then stop the array and assemble it again with the same bitmap.
We expect it should resync only the remaining part, but it does a full
resync again instead.
Please see a log below.

What do you think?

Thanks,

Maxim Kozover.

# mdadm -C /dev/md0 --bitmap /bitmap -e 1 -l 1 -n 2 /dev/sdb /dev/sdc
mdadm: array /dev/md0 started.
# more /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc[1] sdb[0]
      16777208 blocks [2/2] [UU]
      [===========>.........]  resync = 55.6% (9339328/16777208) finish=4.2min speed=29091K/sec
      bitmap: 2048/2048 pages [8192KB], 4KB chunk, file: /bitmap
      
unused devices: <none>
# mdadm -S /dev/md0
# mdadm -A /dev/md0 --bitmap /bitmap /dev/sdb /dev/sdc
mdadm: /dev/md0 has been started with 2 drives.
# more /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb[0] sdc[1]
      16777208 blocks [2/2] [UU]
      [>....................]  resync =  0.3% (53248/16777208) finish=5.2min spe
ed=53248K/sec
      bitmap: 2048/2048 pages [8192KB], 4KB chunk, file: /bitmap

unused devices: <none>


MK> Thanks much, Neil, will try.
MK> Thanks,
MK> Maxim.



