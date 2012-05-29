From: Jonathan Molyneux <jonathan@infinitedepth.com.au>
Subject: raid5 to raid6 - reshape very slow
Date: Tue, 29 May 2012 10:33:52 +1000
Message-ID: <4FC41970.5080009@infinitedepth.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everyone,

I'm currently reshaping my raid5 array into a raid6 array (by adding a 
spare and growing).

Unfortunately I didn't research the nuances before doing so and missed 
the opportunity to --layout=preserve.

As a result the array is rebuilding by use of a backup-file, at a rather 
slow pace.

md1 : active raid6 sde1[0] sdb1[6] sdh1[5] sdc1[4] sdg1[3] sdd1[2] sdf1[1]
       7325679680 blocks super 0.91 level 6, 64k chunk, algorithm 18 
[7/6] [UUUUUU_]
       [=========>...........]  reshape = 47.0% (689413888/1465135936) 
finish=4126.9min speed=3132K/sec

I have tried the following so far:

* read ahead tweaking
* stripe_cache_size tweaking (not a limiting factor - mdadm seems to 
tune this appropriately)
* running the backup file from dev/shm (only for testing purposes)

The reshape does not seem to be IO or CPU bound, it just seems to be 
limited by the sync's and meta data updates to each disk.

Is it possible to increase the buffer/stripes that mdadm process in a 
batch to speed up the process (~41m/2 -> 1G) ?

Any thoughts would be appreciated (even to confirm there is nothing to 
be done).

