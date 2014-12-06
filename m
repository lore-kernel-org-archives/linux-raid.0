From: Emery Guevremont <emery.guevremont@gmail.com>
Subject: On RAID5 read error during syncing - array .A.A
Date: Sat, 6 Dec 2014 13:35:50 -0500
Message-ID: <CAB_L8sZoinCMbp7wrjYaQ=XgCOiBWZBLHkMsV_g+nUyM9pc7CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The long story and what I've done.

/dev/md0 is assembled with 4 drives
/dev/sda3
/dev/sdb3
/dev/sdc3
/dev/sdd3

2 weeks ago, mdadm marked /dev/sda3 as failed. cat /proc/mdstat showed
_UUU. smarctl also confirmed that the drive was dying. So I shutdown
the server and until I received a replacement drive.

This week, I replaced the dying drive with my new drive. Booted into
single user mode and did this:

mdadm --manage /dev/md0 --add /dev/sda3  a cat of /proc/mdstat
confirmed the resyncing process. The last time I checked it was up to
11%. After a few minutes later, I noticed that the syncing stopped. A
read error message on /dev/sdd3 (have a pic of it if interested)
appear on the console. It appears that /dev/sdd3 might be going bad. A
cat /proc/mdstat showed _U_U. Now I panic, and decide to leave
everything as is and to go to bed.

The next day, I shutdown the server and reboot with a live usb distro
(Ubuntu rescue remix). After booting into the live distro, a cat
/proc/mdstat showed that my /dev/md0 was detected but all drives had
an (S) next to it. i.e. /dev/sda3 (S)... Naturally I don't like the
looks of this.

I ran ddrescue to copy /dev/sdd onto my new replacement disk
(/dev/sda). Everything, worked, ddrescue got only one read error, but
was eventually able to read the bad sector on a retry. I followed up
by also cloning with ddrescue, sdb and sdc.

So now I have cloned copies of sdb, sdc and sdd to work with.
Currently running mdadm --assemble --scan, will activate my array, but
all drives are added as spares. Running mdadm --examine on each
drives, shows the same Array UUID number, but the Raid Devices is 0
and raid level is -unknown- for some reason. The rest seems fine and
makes sense. I believe I could re-assemble my array if I could define
the raid level and raid devices.

I wanted to know if there are a way to restore my superblocks from the
examine command I ran at the beginning? If not, what mdadm create
command should I run? Also please let me know if drive ordering is
important, and how I can determine this with the examine output I'll
got?

Thank you.
