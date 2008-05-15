From: David Greaves <david@dgreaves.com>
Subject: Re: (no subject): should have read--"Regarding thread '"Deleting
 mdadm RAID arrays'".
Date: Thu, 15 May 2008 15:01:36 +0100
Message-ID: <482C4240.7020202@dgreaves.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B12C53D0880@SE-EX008.groupinfra.com> <482B5600.6040204@dgreaves.com> <3ECBDC05781B3D48ABD520A01ABF2F9B12C5435703@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B12C5435703@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Henry, Andrew" <andrew.henry@logica.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Lets keep it 'on list' for the benefit of others :)

Henry, Andrew wrote:
> Well, I want RAID1 for failover, and encryption for security and lvm to be able to add devices at a later stage.
Yes, makes sense. Just a 'warning' (but that's too strong) to be aware that this
layering may help uncover some bugs :)

> Sorry, didn't mean that it will not boot at all.  It boots but hangs on mounting the device I have given in fstab.
OK

>> (nb what distro/kernel are you using)
> 
> Im using CentOS 5.1 x86_64 with 2.6.18-53 as OS and the LiveCD I used was Ubuntu 8.04 x86_64.
OK.
This kernel is very old wrt mainline although I suspect the distro will have
backported many bugfixes and improvements I have no idea which :)

>>> So after all that rambling, my question is:
>>>
>>> Why did /dev/md0 appear in fdisk -l when it had previously been sda/sdb
>> even after successfully creating my array before reboot?
>> fdisk -l looks at all the devices for partitions.
>> sdc isn't there (hardware failure?)
> 
> 
> Yes, it was hardware failure.  The Sil controller had completely locked up on one port, probably due to all the dd'ing going on.  I had to completely turn everything off and unplug cables.  When I rebooted, I could then see my 2 500GB discs and my 320GB disc.  Just to clarify:  The 500GB discs are replacements for the single 320GB disc I have at the moment.  The reason why I want to raid/dmcrypt/lvm is that I want extra security of RAID1 and I will lvm it because I plan to buy a second 320GB at a later stage and then RAID1 the two 320GBs in the same manner as above and add them to the same logical volume as the 2 500GB discs.
OK. That's not good though.

>>> How do I remove the array?  Have I now done everything to remove it?
>> mdadm --stop
> 
> Do I not need to do -f /dev/sda -r /dev/sda to remove them properly??
starting and stopping an array is normal operation.
Adding/removing disks is usually a recovery activity.

To 'destroy' an array you should stop it and zero the superblocks on the
component devices.

> Ok, after power cycling it all, my 2 500GB discs came back according to fdisk -l.
good.

> Then I booted a LiveCD and dd'd sda and sdb from there, both the beginning of the device at 10MB and the last 256KB of the devices.
OK - however random incantations of other commands are not recommended or needed
for md on it's own.

> I then rebooted into CentOS and they showed up as unpartitioned devices and /proc/mdstat was empty.
OK.
>  I them proceeded to create a new array with mdadm --create and it says the same thing as before: that they are already part of an array!

>  I thought if I wiped the device and removed the config file it would wipe it but apparently there is something else I need to do?
Well, fixing your email client to wrap lines helps!
There is. Use --zero-superblock. Not aware of any bugs but you're on old systems
here.

>  Anyway, I answered yes to the question of "do you want to continue" and it then says "out of sync, syncing discs" and *that* is when the /dev/md0 device appears when running fdisk -l, but now I can still see both sda and sdb.
OK. all as expected.

>  Does /dev/md0 get registered with fdisk -l when there is an active array running?
fdisk scans the system for block devices and when an array is running it shows
up - usually by udev nowadays but mdadm will also created device nodes I think.

> At least I can still see the discs now.  So now it's been syncing all night and it's 50% complete.
That's slow - my RAID5 takes 3hrs to do 320Gb - mirrors should be a *lot* faster.

> I start to get the feeling that I need to use mdadm to stop, set fail and remove the devices to do this properly and to not dd them!
Err, yes.

>  If I let the syncing continue, so that mdadm thinks the array is OK, can I then stop and remove them properly with mdadm?  How?
This is what distros are for...

You are doing a lot of things that are not needed.

> I want to wipe it all now and start again because I definitely want to autodetect on boot.
Many people are confused by this - your distro will detect and mount the array
on boot. It will then run lvm and dmcrypt over the top.
You *do not* need (and should not use) kernel autodetect. You should assemble
the array in the init scripts.

David
