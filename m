From: Hari Bhaskaran <hbhaskaran@gmail.com>
Subject: s/w raid and bios renumbering HDs
Date: Mon, 31 Oct 2005 07:56:32 -0800
Message-ID: <8d03025a0510310756q7410ef13v6ffb4764229b2eb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to setup a RAID-1 setup for the boot/root partition. I got
the setup working, except what I see with some of my tests leave me
less convinced that it is actually working. My system is debian 3.1
and I am not using the raid-setup options in the debian-installer,
I am trying to add raid-1 to an existing system (followed
http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html  -- 7.4 method 2)

I have /dev/hda (master on primary) and /dev/hdc (master on secondary)
setup as mirrors. I also have a cdrom on /dev/hdd. Now if I disconnect
hda and reboot, everything seems work - except what used to be
/dev/hdc comes up as /dev/hda. I know this since I the bios does
complain that "primary disk 0" is missing and I would have expected a
missing hda, not a missing hdc. Anyways, the software seems to
recognize the "failed-disk" fine if I connect the real hda back. Is
this the way it is supposed to work? Can I rely on this? Also what
happens when I move on to fancier setups like raid5?. My box is a dell
400sc with some phoenix bios (doesnt have many options either). I get
different (still unexpected) results with the cdrom connected and not.

Question #2 (probably related to my problem)

My grub menu.lst is as follows (/dev/md0 is made of /dev/hda1 and /dev/hdc1)
For testing, I made two entries (one for (hd0,0) and another for
(hd1,0)). The howto
I was reading wasn't clear to me. Should I be making just one entry
pointing to /dev/md0?
Also trying labels for "hda" and "hdc" after connecting the faulty
drive back gave me different results ( in one case I was looking at
"older" data and in the other case I wasn't)

(ignore the vs2.1.xxx. it is a linux-vserver patch - shouldn't matter here)

title           Debian GNU/Linux, kernel 2.6.13.3-vs2.1.0-rc4-RAID-hda
root            (hd0,0)
kernel          /boot/vmlinuz-2.6.13.3-vs2.1.0-rc4 root=/dev/md0 ro
initrd          /boot/initrd.img-2.6.13.3-vs2.1.0-rc4.md0
savedefault
boot

title           Debian GNU/Linux, kernel 2.6.13.3-vs2.1.0-rc4-RAID-hdc
root            (hd1,0)
kernel          /boot/vmlinuz-2.6.13.3-vs2.1.0-rc4 root=/dev/md0 ro
initrd          /boot/initrd.img-2.6.13.3-vs2.1.0-rc4.md0
savedefault
boot

Any help is appreciated. If there is a better/current HOWTO, please
let me know. The ones I have seen so far refer to now deprecated tools
(raidtools or raidtools2) and I have had a hard time trying to find
the equivalent syntax for mdadm.

--
Hari
