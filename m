From: Larkin Lowrey <llowrey@gmail.com>
Subject: raid5-cache: Cannot get enough stripes due to memory pressure.
 Recovery failed.
Date: Sat, 4 Nov 2017 12:13:21 -0400
Message-ID: <e4b20202-95e8-c31c-c37b-3da3109537d2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a 12 disk raid6 array that I can no longer assemble. When I 
booted I got dumped into the dracut recovery shell and manually 
assembling the array yielded...

# mdadm --assemble /dev/md2 /dev/dm-3 /dev/sd[e-lu-x]1

md/raid:md2: device sde1 operational as raid disk 0
md/raid:md2: device sdx1 operational as raid disk 11
md/raid:md2: device sdw1 operational as raid disk 10
md/raid:md2: device sdv1 operational as raid disk 9
md/raid:md2: device sdu1 operational as raid disk 8
md/raid:md2: device sdl1 operational as raid disk 7
md/raid:md2: device sdk1 operational as raid disk 6
md/raid:md2: device sdj1 operational as raid disk 5
md/raid:md2: device sdi1 operational as raid disk 4
md/raid:md2: device sdh1 operational as raid disk 3
  md/raid:md2: device sdg1 operational as raid disk 2
md/raid:md2: device sdf1 operational as raid disk 1
md/raid:md2: raid level 6 active with 12 out of 12 devices, algorithm 2
md/raid:md2: Cannot get enough stripes due to memory pressure. Recovery 
failed.
md/raid:md2: failed to run raid set.
md: pers->run() failed ...
md: md2 stopped.
RUN_ARRAY /dev/md2: Input/output error

The journal is on LVM volume /dev/dm-3 and is 2GB. It's sitting on a 
raid10 of 4 SSDs.

The system has 16GB of RAM and 8GB of swap. Memory looks good:

# free
               total        used        free      shared buff/cache   
available
Mem:       16327416      242296    15930344        1216 154776    15821820
Swap:       8388604           0     8388604

The prior shutdown could have been unclean for the array. The shutdown 
process got stuck and I eventually had to use the reset button.

I have a second (8 drive) raid6 array on this host that has a 2GB 
journal and it won't assemble either.

Kernel: 4.13.10-100.fc25.x86_64

What can I do? Do I need more RAM?

--Larkin
