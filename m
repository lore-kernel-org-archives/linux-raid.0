From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Neil, bug in the minimum guaranteed patch?
Date: Fri, 11 May 2007 20:18:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705112016050.18017@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It worked for a while but this time I ran my raid check while doing an 
rsync, for a while, it guaranteed 1MB/s but then:

$ cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : active raid1 sdb2[1] sda2[0]
       136448 blocks [2/2] [UU]
         resync=DELAYED

md2 : active raid1 sdb3[1] sda3[0]
       55681216 blocks [2/2] [UU]
       [============>........]  check = 62.1% (34605376/55681216) 
finish=7.5min speed=46277K/sec

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] 
sde1[2] sdd1[1] sdc1[0]
       1318686336 blocks level 5, 128k chunk, algorithm 2 [10/10] 
[UUUUUUUUUU]
       [=>...................]  check =  7.7% (11329412/146520704) 
finish=45.5min speed=49515K/sec

md0 : active raid1 sdb1[1] sda1[0]
       16787776 blocks [2/2] [UU]

unused devices: <none>

It spiked back to 49MB/s its now 56MB/s -- something is wrong here.  The 
rsync is now in dstate:

root     18039 20.0  0.7  39200 30508 pts/9    D+

Everything is very lagged, it is almost as if it is taking all of the 
available resources for the check!

Justin.
