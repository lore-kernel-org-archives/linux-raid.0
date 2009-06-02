From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Upgrading a software RAID
Date: Tue, 02 Jun 2009 14:33:08 -0400
Message-ID: <4A257064.6030502@tmr.com>
References: <4A1EA095.9090406@usherbrooke.ca> <4A217BA8.1080208@tmr.com> <4A217C6C.7080301@usherbrooke.ca> <20090531001730.GA16311@rap.rap.dk> <4A2213DC.9000100@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A2213DC.9000100@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, robin@robinhill.me.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maxime Boissonneault wrote:
> I finally succeeded in getting my system back. To remind you, I 
> started with this configuration :
>
> /proc/mdstat :
>
> md2 : active raid5 sda3[0] sdc3[2] sdb3[1]
>      957040000 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>     md1 : active raid0 sda2[0] sdc2[2] sdb2[1]
>      19534848 blocks level 0 [3/3] [UUU]
>     md0 : active raid1 sda1[0] sdc1[2] sdb1[1]
>      96256 blocks [3/3] [UUU]
>
> mount :
> /dev/md1 on / type ext3 (rw,relatime,errors=remount-ro)
> /dev/md0 on /boot type ext3 (rw,relatime)
> /dev/md2 on /home type ext3 (rw,relatime)
>
> And I wanted to change md1 to a RAID5. So, here is what I did and what 
> worked.
> 1- Booted with a LiveCD (Ubuntu 8.04.2 Alternate CD)
> 2- Backed-up / using tar, put the file on /home
> 3- Destroyed the array, with mdadm --zero-superblock /dev/sd*2 and 
> mdadm --stop /dev/md1
> 4- Created the new RAID5 array
> 5- Installed a fresh Ubuntu with the install disc
> 6- Copied the /boot, /etc/mdadm/mdadm.conf and /etc/fstab from the 
> fresh install
> 7- Restored the backup over the fresh install
> 8- Restore the files copied at step 6
> 9- Booted
>
> At this point, it gave me an error saying that the filesystem could 
> not be mounted with some number. I found this web page
> http://linux.byexamples.com/archives/321/fstab-with-uuid/
> which told me how to get the uid for my disks, and I updated the 
> /etc/fstab consequently.
>
> Tadam! It works! I can now plan and buy my new 1TB HD and let the RAID 
> reconstruct the files, then grow the arrays.
>
> I wrote this email in the hope that it might be usefull to someone 
> someday.

 It is, and I will belatedly tell you that recent versions of mdadm have 
a "--uuid" option which allows you to set the uuid of the array as you 
create it. However, it sounds as if the problem was not starting the 
array with uuid, but mounting the filesystem, and that uuid can be set 
with tune2fs, using the "-U" option.

I include that for completeness, I agree that changing the things which 
use a new uuid is safer than changing the uuid which could, given 
adequate user error, result in duplicate uuid's on multiple arrays or 
filesystems. This is a "bad thing{tm}" and should be avoided. You did it 
right (IMHO) and congrats on getting it going.

-- 
Bill Davidsen <davidsen@tmr.com>
  Even technical things can appear to be magic, if the documentation is
obscure enough. For example, PulseAudio is configured by dancing naked around
a fire at midnight, shaking a rattle with one hand and a LISP manual with the
other, while reciting the GNU manifesto in hexadecimal.

