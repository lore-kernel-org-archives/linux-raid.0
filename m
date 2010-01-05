From: Alessandro Baretta <alexbaretta@gmail.com>
Subject: Re: Linear mode: array size is less than sum of sizes
Date: Wed, 6 Jan 2010 00:01:15 +0100
Message-ID: <f4143ac21001051501x142d8b4cle9950dfbdde7241c@mail.gmail.com>
References: <f4143ac21001051021o45110f1fi833fc03bf9bae4a@mail.gmail.com>
	<4B439BC8.1030908@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B439BC8.1030908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi John,

First of all thanks for your help.

On Tue, Jan 5, 2010 at 9:06 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
>
>> As you can see the computed size is 67 sectors less than the reported
>> size. What happened to those sectors?
>
> At the very least md linear mode will round down the constituent devices to
> multiples of the rounding size, which is the same as the chunk size - see
> `man mdadm` for rounding size. The default 64K is 128 sectors, and probably
> explains what's happened to your 67 sectors - sda1 has its last 65 sectors
> ignored, and sda5 2. You specify the chunk size in KiB not sectors so I
> don't know how you're going to fix this, and I've a feeling performance
> would be woeful even if you could have a 1-sector chunk size.

That's exactly it! I thought that the 64k chunks were only relevant
for RAID1 and greater. I am losing 65 sectors on /dev/sda1 and 2 on
/dev/sda5. I have checked that the the first 64k of /dev/sda1 are
equal to the 64k of /dev/md0 following the first 16000 sectors. I
could try to resize the NTFS partition up by 63 sectors, hopefully
without clobbering it beyond repair, and map sectors 16001 to the end
of the device to the first partition.

>> [...] All in all,
>> how safe (or unsafe) is my approach to virtualizing Windows XP on my
>> Linux box?
>
> I don't really know how safe it is, but I don't like your 16002-sector
> thingy. If you're going to do this I can't help thinking you should
> duplicate the real partition table, showing the partition starting on sector
> 63, so you want 63 extra sectors, not 16002. You might do it using a file on
> your filesystem via loopback instead of messing about with a silly
> 1-cylinder partition.

I tried binding a loopback device to an md array, but it failed. I
(erroneously) concluded that loopback devices could not be used in md
arrays. Now, taking your advice, I tried again, and it worked. There's
a glitch, however: initially I tried on a 62 sector file, now on one
of the 64k files i extracted from the sda5+sda1 linear array I built
previously. If I revert to the smaller 62 sector file which would
allow me to duplicate the partition table, building the array fails.
Now I understand that this is due to the fact that the first device
(incidentally a loopback device) is smaller than the 64K rounding
size. This means that the loopback device size is rounded down to
zero. Hence, the error from mdadm.

This means that in the virtual setup I cannot maintain the partition
table as it is in the physical setup. That said, I agree that the sda5
approach is clumsy. Yet, even if I go through the loopback device I
will need to prepend a 64K device at the head of the windows
partition. And the virtual partition table will not coincide with the
physical one.

>> Thank you in advance for any help you can provide.
>
> Good luck and let me/us know how you get on!

Ok. Did it. I eventually used the loopback device as you suggested,
but with a 128 sector size. Now I am able to mount my Windows
partition via the md0p1 device.

fsc:~# fdisk /dev/md0

The number of cylinders for this disk is set to 30224768.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help): u
Changing display/entry units to sectors

Command (m for help): p

Disk /dev/md0: 123.8 GB, 123800649728 bytes
2 heads, 4 sectors/track, 30224768 cylinders, total 241798144 sectors
Units = sectors of 1 * 512 = 512 bytes
Disk identifier: 0xde317135

    Device Boot      Start         End      Blocks   Id  System
/dev/md0p1   *         128   241798143   120899008    7  HPFS/NTFS

Command (m for help): Command (m for help): ^C
fsc:~# mount
/dev/sda3 on / type ext4 (rw,errors=remount-ro)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
(rw,noexec,nosuid,nodev)
/dev/md0p1 on /mnt/windoze type ntfs (rw)
fsc:~#

Nice feat! Now I have to get a bootloader installed, and I should be set.

Thanks again.

Alex
