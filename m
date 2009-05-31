From: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Subject: Re: Upgrading a software RAID
Date: Sun, 31 May 2009 01:21:32 -0400
Message-ID: <4A2213DC.9000100@usherbrooke.ca>
References: <4A1EA095.9090406@usherbrooke.ca> <4A217BA8.1080208@tmr.com> <4A217C6C.7080301@usherbrooke.ca> <20090531001730.GA16311@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090531001730.GA16311@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Bill Davidsen <davidsen@tmr.com>, robin@robinhill.me.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I finally succeeded in getting my system back. To remind you, I started 
with this configuration :

/proc/mdstat :

md2 : active raid5 sda3[0] sdc3[2] sdb3[1]
      957040000 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
     
md1 : active raid0 sda2[0] sdc2[2] sdb2[1]
      19534848 blocks level 0 [3/3] [UUU]
     
md0 : active raid1 sda1[0] sdc1[2] sdb1[1]
      96256 blocks [3/3] [UUU]

mount :
/dev/md1 on / type ext3 (rw,relatime,errors=remount-ro)
/dev/md0 on /boot type ext3 (rw,relatime)
/dev/md2 on /home type ext3 (rw,relatime)

And I wanted to change md1 to a RAID5. So, here is what I did and what 
worked.
1- Booted with a LiveCD (Ubuntu 8.04.2 Alternate CD)
2- Backed-up / using tar, put the file on /home
3- Destroyed the array, with mdadm --zero-superblock /dev/sd*2 and mdadm 
--stop /dev/md1
4- Created the new RAID5 array
5- Installed a fresh Ubuntu with the install disc
6- Copied the /boot, /etc/mdadm/mdadm.conf and /etc/fstab from the fresh 
install
7- Restored the backup over the fresh install
8- Restore the files copied at step 6
9- Booted

At this point, it gave me an error saying that the filesystem could not 
be mounted with some number. I found this web page
http://linux.byexamples.com/archives/321/fstab-with-uuid/
which told me how to get the uid for my disks, and I updated the 
/etc/fstab consequently.

Tadam! It works! I can now plan and buy my new 1TB HD and let the RAID 
reconstruct the files, then grow the arrays.

I wrote this email in the hope that it might be usefull to someone someday.


Thanks everyone for your help throughout the day.


Maxime Boissonneault
