From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: s/w raid and bios renumbering HDs
Date: Mon, 31 Oct 2005 16:37:19 -0800 (PST)
Message-ID: <Pine.LNX.4.63.0510311623470.25152@twinlark.arctic.org>
References: <8d03025a0510310756q7410ef13v6ffb4764229b2eb6@mail.gmail.com>
 <Pine.LNX.4.63.0510311126200.25465@twinlark.arctic.org> <4366AFEA.6030906@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4366AFEA.6030906@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hari Bhaskaran <hbhaskaran@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 31 Oct 2005, Hari Bhaskaran wrote:

> So that "DEVICE paritions" line was really supposed to be there? Hehe... I
> thought it was just a
> help message and replaced it with "DEVICE /dev/hda1 /dev/hdc1" :)

you can use "DEVICE /dev/hda1 /dev/hdc1" ... but then mdadm scans will 
only consider those two partitions... if you use "DEVICE partitions" it'll 
look at all detected partitions for the components.  it makes it easy when 
you move disks around to new controllers and their location changes, 
things will continue to jfw.


> If I ever end up in a situation with a non-root raid down (say I did --stop),
> how do I start it back up? (--run seems
> to give me some errors). Anyways, more "rtfm" to do.

you want --assemble ...


> > the root is the only one which you need to be careful with -- when debian
> > installs your kernel it constructs an initrd which lists the minimum places
> > it will search for the root raid components... for example on one of my
> > boxes:
> > 
> > # mkdir /mnt/cramfs
> > # mount -o ro,loop /boot/initrd.img-2.6.13-1-686-smp /mnt/cramfs
> > # cat /mnt/cramfs/script
> > ROOT=/dev/md3
> > mdadm -A /dev/md3 -R -u 2b3a5b77:c7b4ab81:a2b8322a:db5c4e88 /dev/sdb4
> > /dev/sda4
> > # umount /mnt/cramfs
> >   
> Did u install yours with raid options in the debian installer? I dont think my
> initrd image would have all these ( I dont have
> access to the machine now to check) - but I wouldn't think the mkinitrd that I
> used to created the initrd image would
> know that I am using raid or not ( I am talking about the mdadm references in
> your script). Or are you saying you
> added these yourself?

there's really no reason to avoid the debian installer's raid support if 
you know you want raid, but i haven't used it much.

you only need to do initrd edits by hand once if you're converting root to 
a raid. there's a few steps in the debian doc about this (see Part II. 
RAID using initrd and grub) /usr/share/doc/mdadm/rootraiddoc.97.html.

after that initial change, and you've managed to boot with root on raid 
then subsequent mkinitrd *should* fill in the details automatically... 
i.e. every time you upgrade your kernel you get a new initrd, and it 
should automatically include the root raid setup.

-dean
