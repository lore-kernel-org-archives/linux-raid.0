From: "Philippe Dhont   (Sea-ro)" <Philippe.Dhont@searo.be>
Subject: Help needed plz
Date: Thu, 6 Feb 2003 16:16:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <B5747F3DB39FD411884B00B0D07808CCB6C829@server10>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I am new to softraid so i first readed some info about it and i also have
the book "managing raid on linux."
I don't want to use a pre-installed raid (like in suse or redhat etc...) but
i want to do it from my slackware8.1 installation, from scratch!
But there are some things not clear.
This is the situation:
I have a ATA-hda and a ATA-hdc (only 2 disks)
My linux is installed on HDA and everything works fine, i recompiled the
kernel and raid-drivers a succesfully started, the raidtools are also fine.
But now some questions, maybe stupid but it's a different with hardware raid
and i really want to know it.

1) i can't do a mkraid /dev/md0   ==> i get the message that hda1 (my
current installation is on hda1 and everything else, i also boot from it) is
already mounted so i guess this is normal but if i change "hda1 to hda" and
"hdb1 to hdb" in the raidtab then everything works and it synchronizes (can
see it in /proc/mdstat).
But this synchronizes only once, i want to boot from md0 and this is of
course not possible in this situation, it always boots from hda1.
How do i have to boot from md0 ?? Do i have to make a raid1 with 3 disks ??
Or how do i have to do it ? I don't understand this part !!
1 installation disk and two disks for the raid1 and then install a system on
the raid1 ??
And later on remove the install disk i first installed the raid arrey with ?

2)How do i have to install a linux on a md0 ? Do i start with the cd or
something ?
Never did it before.


Thnx for the help, just put me on the way!!
I tried before but i crashed my hdd's already twice !!
But you have to start somewhere, right ?

thnx
Philippe Dhont 
