From: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Subject: Re: Upgrading a software RAID
Date: Sat, 30 May 2009 14:11:52 -0400
Message-ID: <4A2176E8.9090701@usherbrooke.ca>
References: <20090528141457.GA30322@cthulhu.home.robinhill.me.uk> <4A1EA095.9090406@usherbrooke.ca> <20090528150849.GB30322@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090528150849.GB30322@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> If the / was on a RAID5, would it be able to boot with 2 disks ?
>> If so, is it possible to convert my RAID0 to a RAID5 ?
>> For example, I could boot on a CD, backup / onto /home, delete the RAID0 
>> array and recreate it as RAID5, then restore the backup. Would this work ?
>>
>>     
> Yes, a RAID-5 will run fine with just two disks. You could certainly
> boot from CD, backup, recreate the RAID, then restore - you'd probably
> need to update the mdadm.conf file (and the initrd) to indicate the new
> array UUID and details though.
>
> You may also want to read through the GRUB section on
> http://en.gentoo-wiki.com/wiki/RAID/Software to see how to install grub
> onto all the drives (avoiding the issue of which drive is currently
> being booted from).
>
>   
Ok. This is the configuration I had :
/dev/md1 was a RAID0 composed of /dev/sda2, /dev/sdb2 and /dev/sdc2

I did this :
mdadm --stop /dev/md1
mdadm --zero-superblock /dev/sda2
mdadm --zero-superblock /dev/sdb2
mdadm --zero-superblock /dev/sdc2

and then this :
mdadm --create --verbose /dev/md1 --level=5 --raid-devices=3 /dev/sda2 
/dev/sdb2 /dev/sdc2

I used the rescue mode from an alternate CD (hardy 8.04.2) to format 
/dev/md1 as ext3. Then, I restored the backup and updated the 
/etc/mdadm/mdadm.conf file with the output of mdadm --detail --scan.

Now, GRUB loads (it was on /dev/md0 which is a RAID1 composed of sd*1), 
and it tries to load Ubuntu, but it just won't load.

You said that I would have to edit initrd... what is that and what do I 
have to change in it ?

Thanks,

Maxime Boissonneault

