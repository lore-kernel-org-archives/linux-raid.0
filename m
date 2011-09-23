From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: potentially lost largeish raid5 array..
Date: Thu, 22 Sep 2011 19:50:36 -0600
Message-ID: <201109221950.36910.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've been struggling with a SAS card recently that has had poor driver support 
for a long time, and tonight its decided to kick every drive in the array one 
after the other. Now mdstat shows:

md1 : active raid5 sdf[0](F) sdh[7](F) sdi[6](F) sdj[5](F) sde[3](F) sdd[2](F) 
sdg[1](F)
      5860574208 blocks super 1.1 level 5, 512k chunk, algorithm 2 [7/0] 
[_______]
      bitmap: 3/8 pages [12KB], 65536KB chunk

Does the fact that I'm using a bitmap save my rear here? Or am I hosed? If I'm 
not hosed, is there a way I can recover the array without rebooting? maybe 
just a --stop and a --assemble ? If that won't work, will a reboot be ok?

I'd really prefer not to have lost all of my data. Please tell me (please) 
that it is possible to recover the array. All but sdi are still visible in 
/dev (I may be able to get it back via hotplug maybe, but it'd get sdk or 
something).

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
