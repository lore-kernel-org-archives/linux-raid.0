From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: array always resyncs on boot
Date: Sat, 29 Nov 2008 16:37:46 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811291633140.1796@p34.internal.lan>
References: <4931B2C5.5060403@openhardware.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4931B2C5.5060403@openhardware.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tom Walsh <tom@openhardware.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 29 Nov 2008, Tom Walsh wrote:

> <sigh> I need help!
>
> It  is not like I haven't build a raid array before, I've got three
> systems using a mix of raid1 and raid5 that have been running for
> about two years.  Those systems are okay.  It is problems that
> developed with this fourth system.
>
> This system was constructed about 10 months ago using six 320G drives
> (4 Seagage ST3320620AS and 2 Western Digital WD3200AAKS-0).  The
> system ran fine until two months ago when I had to shutdown the system
> for a few weeks.  When I powered up the system, it declared that the
> raid5 array needed to undergo a resync.  Subsequent reboots of that
> system persistently resulted in a resync!
>
> In the past few weeks of chasing the problem down, I have replaced
> *EVERYTHING*!  RAM, Motheboard, cables, Q6600 CPU, power supply,
> switched from PCI-16e video card to a PCI video, removed all non-
> essential cards and USB devices.  The only thing that has not been
> changed in this system is the CPU fan.  And still, the raid array
> insists upon resyncing.
>
> I've overhauled the software, replaced the operating system
> innumerable times with several Mandriva distros: 2008, 2008.1, 2009.
> Removed the Mandriva kernel and compiled a stock 2.6.27.7 from
> ftp.kernel.org.  Ran the Seagate SeaTools on all four drives, no
> errors.  Ran the Western Digital Date Lifeguard on the two drives, no
> errors.  Changed from raid5 to raid10, still resyncs on boot.
>
> What am I doing wrong!?
>
> mdadm --create /dev/md0 --level=10 --raid-devices=6 /dev/sd[a-f]5
> mke2fs -j /dev/md0
> mdadm -Eb /dev/sda5 >> /etc/mdadm
> # edit mdadm.conf
> blkid /dev/md0 >> /etc/fstab
> # edit fstab
>
> I just cannot keep the system from resyncing on every boot.  I've
> gotten to the point that I'm thinking that I may have been root'ed and
> the boot flash of the drives has been reflashed...  Ok, that is
> reaching for an answer, I know.  This is time to ask for help.  help!

If you boot knoppix and manually assemble the array does it assemble cleanly
or does it need a resync as well?

Also:
> mdadm -Eb /dev/sda5 >> /etc/mdadm
> blkid /dev/md0 >> /etc/fstab

I never use these commands?

I take the output of:
# mdadm --examine --scan

And add it to /etc/mdadm/mdadm.conf.

And then add /dev/md0 /mnt xfs etc into /etc/fstab.

In addition I don't use a > 0.90 superblock (not saying thats the problem 
but just noting a difference)

mdadm --create /dev/md3 -e 0.90 --assume-clean --level=5 --chunk=1024 --verbose --raid-devices=10 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 missing /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1

Besides that though the commands look the same.

Do you use initrd/etc or do you compile everything in at the kernel level?
Is it possible one disk is on one controller and the others are on another
or something weird like that, such that the driver for one chipset loads
before and the other does not load until later?

Some dmesg output may be useful along with mdadm -D on the raid array 
before and after reboots.

Justin.
