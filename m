From: "Richard B. Pyne" <rpyne@kinfolk.org>
Subject: system startup hangs
Date: Wed, 07 Dec 2011 15:38:05 -0700
Message-ID: <4EDFEACD.3010806@kinfolk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please forgive me if I ask stupid questions, I am fairly new to linux 
raid and most of the documentation I can find is severely outdated 
and/or written for someone who already understands linux raid.

I have successfully built a set raid 6 array with 4 drives and have 
copied my system partitions onto the raid drives. I then reboot with 
root=/dev/md0.

Everything looks like it is working right up through:

md/raid:md0 raid level 6 active with 4 out of 4 devices, algorithm 2
md0: detected capacity change from 0 to 1000131788
md: autorun DONE.
md0: unknown partition table
EXT3-fs (md0): error: couldn't mount because of unsupported optional 
features
EXT2-fs (md0): error: couldn't mount because of unsupported optional 
features
EXT4-fs (md0): mounted filesystem with ordered data mode.  Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
freeing unused kernel memory: 472k freed


at which point it just hangs. No more disk access, no more messages.


The system has 5 WD Caviar Black 500GB drives. I did the linux install 
on the first drive and built the other 4 drives into the raid system, 
planning to move everything (except the /boot partition) on to the raid 
array and then repartition everything except the /boot partition on the 
first drive and add it to the raid.

I currently have md0 for / md1 for /home md2 for /usr md3 for /var and 
md4 on which I plan on running lvm to allocate to other system needs.

Any advice, insights and/or direction will be greatly appreciated.


