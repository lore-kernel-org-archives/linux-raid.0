From: Orion Poplawski <orion@cora.nwra.com>
Subject: raid5 missing drive at boot question
Date: Thu, 22 Sep 2005 16:28:50 -0600
Message-ID: <dgvb75$hp5$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I created a new 8 disk raid5 set with no spares.  Now, when I boot I end 
up with:


md3 : active raid5 sdp1[7] sdo1[6] sdn1[5] sdm1[4] sdl1[3] sdk1[2] sdi1[0]
       3418687552 blocks level 5, 64k chunk, algorithm 2 [8/7] [U_UUUUUU]

which I believe is a "degraded" array.  I then have to do:

mdadm -M -a /dev/md3 /dev/sdj1

to add in the missing disk.  I had to do this after it was created as well.

Why does this happen?  What am I not understanding?

Boot messages:

md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdp1 ...
md:  adding sdp1 ...
md:  adding sdo1 ...
md:  adding sdn1 ...
md:  adding sdm1 ...
md:  adding sdl1 ...
md:  adding sdk1 ...
md:  adding sdi1 ...
md: created md3
md: bind<sdi1>
md: bind<sdk1>
md: bind<sdl1>
md: bind<sdm1>
md: bind<sdn1>
md: bind<sdo1>
md: bind<sdp1>
md: running: <sdp1><sdo1><sdn1><sdm1><sdl1><sdk1><sdi1>
raid5: device sdp1 operational as raid disk 7
raid5: device sdo1 operational as raid disk 6
raid5: device sdn1 operational as raid disk 5
raid5: device sdm1 operational as raid disk 4
raid5: device sdl1 operational as raid disk 3
raid5: device sdk1 operational as raid disk 2
raid5: device sdi1 operational as raid disk 0
raid5: allocated 8376kB for md3
raid5: raid level 5 set md3 active with 7 out of 8 devices, algorithm 2
RAID5 conf printout:
  --- rd:8 wd:7 fd:1
  disk 0, o:1, dev:sdi1
  disk 2, o:1, dev:sdk1
  disk 3, o:1, dev:sdl1
  disk 4, o:1, dev:sdm1
  disk 5, o:1, dev:sdn1
  disk 6, o:1, dev:sdo1
  disk 7, o:1, dev:sdp1

